package org.learnnavi.app;

import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;

import android.content.Context;
import android.database.Cursor;
import android.database.MatrixCursor;
import android.database.SQLException;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteException;
import android.database.sqlite.SQLiteOpenHelper;

public class EntryDBAdapter extends SQLiteOpenHelper {
	private static final String DB_PATH = "/data/data/org.learnnavi.app/databases/";
	private static final String DB_NAME = "dictionary.sqlite";
	private SQLiteDatabase myDataBase;
	private final Context myContext;
	private int mRefCount;
	private String mDbVersion;
	
	// Column names for use by other classes
    public static final String KEY_WORD = "word";
    public static final String KEY_DEFINITION = "definition";
    public static final String KEY_ROWID = "_id";
    public static final String KEY_IPA = "ipa";
    public static final String KEY_LETTER = "letter";
    public static final String KEY_PART = "part_of_speech";

    // Query just the first letters for all words
    private static final String QUERY_ALL_LETTERS = "SELECT MIN(_id) AS _id, COUNT(*) AS _count, ' ' || replace(replace(alpha, 'B', 'Ä'), 'J', 'Ì') || ' ' AS letter FROM entries GROUP BY alpha ORDER BY alpha COLLATE UNICODE";
    // Query all words
    private static final String QUERY_ALL = "SELECT _id, replace(replace(replace(replace(entries.entry_name, 'b', 'ä'), 'j', 'ì'), 'B', 'Ä'), 'J', 'Ì') AS word, replace(replace(alpha, 'B', 'Ä'), 'J', 'Ì') AS letter, entries.english_definition AS definition FROM entries ORDER BY alpha COLLATE UNICODE, entries.entry_name COLLATE UNICODE";
    // Query just the first letters for words that match a filter
    private static final String QUERY_FILTER_LETTERS = "SELECT MIN(_id) AS _id, COUNT(*) AS _count, ' ' || replace(replace(alpha, 'B', 'Ä'), 'J', 'Ì') || ' ' AS letter FROM entries WHERE entries.entry_name LIKE ? GROUP BY alpha ORDER BY alpha COLLATE UNICODE";
    // Query words that match a filter
    private static final String QUERY_FILTER = "SELECT _id, replace(replace(replace(replace(entries.entry_name, 'b', 'ä'), 'j', 'ì'), 'B', 'Ä'), 'J', 'Ì') AS word, replace(replace(alpha, 'B', 'Ä'), 'J', 'Ì') AS letter, entries.english_definition AS definition FROM entries WHERE entries.entry_name LIKE ? ORDER BY alpha COLLATE UNICODE, entries.entry_name COLLATE UNICODE";
    // Query just the first English letters for all words
    private static final String QUERY_ALL_TO_NAVI_LETTERS = "SELECT MIN(_id) AS _id, COUNT(*) AS _count, ' ' || beta || ' ' AS letter FROM entries GROUP BY beta ORDER BY beta COLLATE UNICODE";
    // Query all words sorted by English word
    private static final String QUERY_ALL_TO_NAVI = "SELECT _id, replace(replace(replace(replace(entries.entry_name, 'b', 'ä'), 'j', 'ì'), 'B', 'Ä'), 'J', 'Ì') AS definition, entries.english_definition AS word, replace(replace(beta, 'B', 'Ä'), 'J', 'Ì') AS letter FROM entries ORDER BY beta COLLATE UNICODE, entries.english_definition COLLATE UNICODE";
    // Query just the first English letters for words that match a filter
    private static final String QUERY_FILTER_TO_NAVI_LETTERS = "SELECT MIN(_id) AS _id, COUNT(*) AS _count, ' ' || beta || ' ' AS letter FROM entries WHERE entries.english_definition LIKE ? GROUP BY beta ORDER BY beta COLLATE UNICODE";
    // Query words that match a filter sorted/searched by English word
    private static final String QUERY_FILTER_TO_NAVI = "SELECT _id, replace(replace(replace(replace(entries.entry_name, 'b', 'ä'), 'j', 'ì'), 'B', 'Ä'), 'J', 'Ì') AS definition, entries.english_definition AS word, replace(replace(beta, 'B', 'Ä'), 'J', 'Ì') AS letter FROM entries WHERE entries.english_definition LIKE ? ORDER BY beta COLLATE UNICODE, entries.english_definition COLLATE UNICODE";
    // Query a single entry by ID
    private static final String QUERY_ENTRY = "SELECT _id, replace(replace(replace(replace(entries.entry_name, 'b', 'ä'), 'j', 'ì'), 'B', 'Ä'), 'J', 'Ì') AS word, entries.english_definition AS definition, ipa, fps.description as part_of_speech FROM entries LEFT JOIN fancy_parts_of_speech fps USING (part_of_speech) WHERE _id = ?";

    // Query used by the search suggest when neither to or from Na'vi is requested
    private static final String QUERY_FOR_SUGGEST = "SELECT _id, _id AS suggest_intent_data, replace(replace(replace(replace(entries.entry_name, 'b', 'ä'), 'j', 'ì'), 'B', 'Ä'), 'J', 'Ì') AS suggest_text_1, entries.english_definition AS suggest_text_2 FROM entries WHERE entries.entry_name LIKE ? OR entries.english_definition LIKE ? ORDER BY LENGTH(entries.entry_name), beta COLLATE UNICODE, entries.english_definition COLLATE UNICODE LIMIT 25";
    // Query used by the search suggest when Na'vi words are being searched
    private static final String QUERY_FOR_SUGGEST_NAVI = "SELECT _id, _id AS suggest_intent_data, replace(replace(replace(replace(entries.entry_name, 'b', 'ä'), 'j', 'ì'), 'B', 'Ä'), 'J', 'Ì') AS suggest_text_1, entries.english_definition AS suggest_text_2 FROM entries WHERE entries.entry_name LIKE ? ORDER BY LENGTH(entries.entry_name), alpha COLLATE UNICODE, entries.english_definition COLLATE UNICODE LIMIT 25";
    // Query used by the search suggest when English words are being searched
    private static final String QUERY_FOR_SUGGEST_NATIVE = "SELECT _id, _id AS suggest_intent_data, replace(replace(replace(replace(entries.entry_name, 'b', 'ä'), 'j', 'ì'), 'B', 'Ä'), 'J', 'Ì') AS suggest_text_2, entries.english_definition AS suggest_text_1 FROM entries WHERE entries.english_definition LIKE ? ORDER BY LENGTH(entries.english_definition), beta COLLATE UNICODE, entries.english_definition COLLATE UNICODE LIMIT 25";

    // Private only, operated on a single instance
	private EntryDBAdapter(Context context) {
    	super(context, DB_NAME, null, 1);
        this.myContext = context;
    }

	private static EntryDBAdapter instance;
	// Return the singleton instance
	public static EntryDBAdapter getInstance(Context c)
	{
		if (instance == null)
			reloadDB(c);
		return instance;
	}

	// Open the DB from the source file
	public static void reloadDB(Context c)
	{
		if (instance != null)
			instance.close();
		// Always open on the application context, otherwise the first calling activity will be leaked
		instance = new EntryDBAdapter(c.getApplicationContext());
		try
		{
			// Store the DB version once the DB is loaded
			instance.mDbVersion = instance.createDataBase();
		}
		catch (Exception ex)
		{
			// Store a dummy version - shouldn't ever happen
			instance.mDbVersion = "Unk";
		}
	}
	
	public String getDBVersion()
	{
		return mDbVersion;
	}
	
	// Copy the database from the distribution if it doesn't exist, return DB version
	private String createDataBase() throws IOException{
		// If a DB version is returned, it's fine
    	String ret = checkDataBase();
 
    	if(ret != null){
    		//do nothing - database already exist
    	}else{
    		//By calling this method and empty database will be created into the default system path
               //of your application so we are gonna be able to overwrite that database with our database.
        	this.getReadableDatabase();
        	try {
        		// Copy the file over top of the database data
    			copyDataBase();
    			// Check again for a valid version
    			ret = checkDataBase();
    			if (ret == null)
    				ret = "Unk";
    		} catch (IOException e) {
        		throw new Error("Error copying database");
        	}
    	}
    	
    	return ret;
    }
	
	// Check if the database exists, returning the version if it does
    private String checkDataBase(){
    	String ret = null;
    	SQLiteDatabase checkDB = null;

    	try{
    		String myPath = DB_PATH + DB_NAME;
    		// Open a temporary database by path, don't allow it to create an empty database
    		checkDB = SQLiteDatabase.openDatabase(myPath, null, SQLiteDatabase.OPEN_READONLY);
    	}catch(SQLiteException e){
    		//database does't exist yet.
    	}

    	// If the database was opened, check the version
    	if(checkDB != null){
    		try
    		{
    			ret = queryDatabaseVersion(checkDB);
    		}
    		catch(SQLiteException e){
    			// An error means the version table doesn't exist, so it's not a valid DB
        		checkDB.close();
    			checkDB = null;
    		}
    	}
 
    	return ret;
    }
    
    private static String queryDatabaseVersion(SQLiteDatabase db) throws SQLiteException
    {
    	// Simple query of the database version
    	String ret;
    	Cursor c = db.rawQuery("SELECT version FROM version", null);
    	if (c.moveToFirst())
    		ret = c.getString(0);
    	else
    		ret = "Unk";
    	c.close();
    	return ret;
    }
    
    // Copy the database from the distribution
    private void copyDataBase() throws IOException{
    	 
    	//Open your local db as the input stream
    	InputStream myInput = myContext.getAssets().open(DB_NAME);
 
    	// Path to the just created empty db
    	String outFileName = DB_PATH + DB_NAME;
 
    	//Open the empty db as the output stream
    	OutputStream myOutput = new FileOutputStream(outFileName);
 
    	//transfer bytes from the inputfile to the outputfile
    	byte[] buffer = new byte[1024];
    	int length;
    	while ((length = myInput.read(buffer))>0){
    		myOutput.write(buffer, 0, length);
    	}
 
    	//Close the streams
    	myOutput.flush();
    	myOutput.close();
    	myInput.close();
    }

    // Open the database
    public void openDataBase() throws SQLException{
    	if (myDataBase != null)
    	{
    		mRefCount++;
    		return;
    	}
    	mRefCount = 1;
    	//Open the database
        String myPath = DB_PATH + DB_NAME;
    	myDataBase = SQLiteDatabase.openDatabase(myPath, null, SQLiteDatabase.OPEN_READONLY);
    }

    // Change passed in text into an appropriate DB filter string
    private String fixFilterString(String filter)
    {
    	return "%" + filter.toLowerCase().replace('ä', 'b').replace('ì', 'j') + "%";
    }

    // Perform full or filtered query, null filter returns full query
    private Cursor queryAllOrFilter(String allQuery, String filterQuery, String filter)
    {
    	if (filter != null)
    	{
    		return myDataBase.rawQuery(filterQuery, new String[] { fixFilterString(filter) });
    	}
    	return myDataBase.rawQuery(allQuery, null);
    }

    // Query on all words, optionally applying a filter
    public Cursor queryAllEntries(String filter)
    {
    	return queryAllOrFilter(QUERY_ALL, QUERY_FILTER, filter);
    }

    // Query on letters for words, optionally applying a filter
    public Cursor queryAllEntryLetters(String filter)
    {
    	return queryAllOrFilter(QUERY_ALL_LETTERS, QUERY_FILTER_LETTERS, filter);
    }
    
    // Query on all words for X > Na'vi dictionary, optionally applying a filter
    public Cursor queryAllEntriesToNavi(String filter)
    {
    	return queryAllOrFilter(QUERY_ALL_TO_NAVI, QUERY_FILTER_TO_NAVI, filter);
    }
    
    // Query on English letters for words, optionally applying a filter
    public Cursor queryAllEntryToNaviLetters(String filter)
    {
    	return queryAllOrFilter(QUERY_ALL_TO_NAVI_LETTERS, QUERY_FILTER_TO_NAVI_LETTERS, filter);
    }
    
    // Perform a simple query to offer results for suggest
    public Cursor queryForSuggest(String filter, Boolean type)
    {
    	if (type == null) // Unspecified (Global search, or unified search)
    		return myDataBase.rawQuery(QUERY_FOR_SUGGEST, new String[] { fixFilterString(filter), "%" + filter + "%" });
    	else if (type) // Native to Na'vi
    		return myDataBase.rawQuery(QUERY_FOR_SUGGEST_NATIVE, new String[] { fixFilterString(filter) });
    	else // Na'vi to native
    		return myDataBase.rawQuery(QUERY_FOR_SUGGEST_NAVI, new String[] { "%" + filter + "%" });
    }

    // Return the fields for a single dictionary entry
    public Cursor querySingleEntry(int rowId)
    {
    	return myDataBase.rawQuery(QUERY_ENTRY, new String[] { Integer.toString(rowId) });
    }
    
    // Perform a refcounted close operation
    // ** This should, perhaps, be based on a subclass reference,
    //    so GC cleanup can trigger closes
    @Override
	public synchronized void close() {
    	mRefCount--;
    	if (mRefCount > 0)
    		return;

    	if(myDataBase != null)
    		myDataBase.close();

    	instance = null;
    	super.close();
	}
    
    @Override
	public void onCreate(SQLiteDatabase db) {
    	// Empty database
	}
 
	@Override
	public void onUpgrade(SQLiteDatabase db, int oldVersion, int newVersion) {
		// Probably should delete the dataabse and re-copy it
	}

	// Return if the DB is open
	public boolean isOpen()
	{
		return (instance != null);
	}

	// Perform a query that intentionally returns nothing,
	// for suggest searches without an open DB
	public Cursor queryNull()
	{
		return new MatrixCursor(new String[] { "_id" });
	}
}
