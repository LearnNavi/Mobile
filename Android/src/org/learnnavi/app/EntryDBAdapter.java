package org.learnnavi.app;

import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;

import android.content.Context;
import android.database.Cursor;
import android.database.SQLException;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteException;
import android.database.sqlite.SQLiteOpenHelper;

public class EntryDBAdapter extends SQLiteOpenHelper {
	private static final String DB_PATH = "/data/data/org.learnnavi.app/databases/";
	private static final String DB_NAME = "dictionary.sqlite";
	private SQLiteDatabase myDataBase;
	private final Context myContext;
	
    public static final String KEY_WORD = "word";
    public static final String KEY_DEFINITION = "definition";
    public static final String KEY_ROWID = "_id";
    public static final String KEY_IPA = "ipa";
    public static final String KEY_LETTER = "letter";
    public static final String KEY_PART = "part_of_speech";
    
    private static final String QUERY_ALL_LETTERS = "SELECT MIN(_id) AS _id, COUNT(*) AS _count, replace(replace(alpha, 'B', 'Ä'), 'J', 'Ì') AS letter FROM entries GROUP BY alpha ORDER BY alpha COLLATE UNICODE";
    private static final String QUERY_ALL = "SELECT _id, replace(replace(replace(replace(entries.entry_name, 'b', 'ä'), 'j', 'ì'), 'B', 'Ä'), 'J', 'Ì') AS word, replace(replace(alpha, 'B', 'Ä'), 'J', 'Ì') AS letter, entries.english_definition AS definition FROM entries ORDER BY alpha COLLATE UNICODE, entries.entry_name COLLATE UNICODE";
    private static final String QUERY_FILTER_LETTERS = "SELECT MIN(_id) AS _id, COUNT(*) AS _count, replace(replace(alpha, 'B', 'Ä'), 'J', 'Ì') AS letter FROM entries WHERE entries.entry_name LIKE ? GROUP BY alpha ORDER BY alpha COLLATE UNICODE";
    private static final String QUERY_FILTER = "SELECT _id, replace(replace(replace(replace(entries.entry_name, 'b', 'ä'), 'j', 'ì'), 'B', 'Ä'), 'J', 'Ì') AS word, replace(replace(alpha, 'B', 'Ä'), 'J', 'Ì') AS letter, entries.english_definition AS definition FROM entries WHERE entries.entry_name LIKE ? ORDER BY alpha COLLATE UNICODE, entries.entry_name COLLATE UNICODE";
//    private static String QUERY_GROUP = "SELECT _id, replace(replace(replace(replace(entries.entry_name, 'b', 'ä'), 'j', 'ì'), 'B', 'Ä'), 'J', 'Ì') AS word, entries.english_definition AS definition FROM entries WHERE alpha = (SELECT alpha FROM entries WHERE _id = ?) ORDER BY alpha COLLATE UNICODE, entries.entry_name COLLATE UNICODE";
    private static final String QUERY_ALL_TO_NAVI_LETTERS = "SELECT MIN(_id) AS _id, COUNT(*) AS _count, beta AS letter FROM entries GROUP BY beta ORDER BY beta COLLATE UNICODE";
    private static final String QUERY_ALL_TO_NAVI = "SELECT _id, replace(replace(replace(replace(entries.entry_name, 'b', 'ä'), 'j', 'ì'), 'B', 'Ä'), 'J', 'Ì') AS definition, entries.english_definition AS word, replace(replace(beta, 'B', 'Ä'), 'J', 'Ì') AS letter FROM entries ORDER BY beta COLLATE UNICODE, entries.english_definition COLLATE UNICODE";
    private static final String QUERY_FILTER_TO_NAVI_LETTERS = "SELECT MIN(_id) AS _id, COUNT(*) AS _count, beta AS letter FROM entries WHERE entries.english_definition LIKE ? GROUP BY beta ORDER BY beta COLLATE UNICODE";
    private static final String QUERY_FILTER_TO_NAVI = "SELECT _id, replace(replace(replace(replace(entries.entry_name, 'b', 'ä'), 'j', 'ì'), 'B', 'Ä'), 'J', 'Ì') AS definition, entries.english_definition AS word, replace(replace(beta, 'B', 'Ä'), 'J', 'Ì') AS letter FROM entries WHERE entries.english_definition LIKE ? ORDER BY beta COLLATE UNICODE, entries.english_definition COLLATE UNICODE";
//    private static String QUERY_GROUP_TO_NAVI = "SELECT _id, replace(replace(replace(replace(entries.entry_name, 'b', 'ä'), 'j', 'ì'), 'B', 'Ä'), 'J', 'Ì') AS definition, entries.english_definition AS word FROM entries WHERE alpha = (SELECT alpha FROM entries WHERE _id = ?) ORDER BY beta COLLATE UNICODE, entries.english_definition COLLATE UNICODE";
    private static final String QUERY_ENTRY = "SELECT replace(replace(replace(replace(entries.entry_name, 'b', 'ä'), 'j', 'ì'), 'B', 'Ä'), 'J', 'Ì') AS word, entries.english_definition AS definition, ipa, fps.description as part_of_speech FROM entries LEFT JOIN fancy_parts_of_speech fps USING (part_of_speech) WHERE _id = ?";
    
    private static final String QUERY_FOR_SUGGEST = "SELECT _id, _id AS suggest_intent_data, replace(replace(replace(replace(entries.entry_name, 'b', 'ä'), 'j', 'ì'), 'B', 'Ä'), 'J', 'Ì') AS suggest_text_1, entries.english_definition AS suggest_text_2 FROM entries WHERE entries.entry_name LIKE ? OR entries.english_definition LIKE ? ORDER BY beta COLLATE UNICODE, entries.english_definition COLLATE UNICODE LIMIT 5";

	public EntryDBAdapter(Context context) {
    	super(context, DB_NAME, null, 1);
        this.myContext = context;
    }
	
	// Copy the database from the distribution if it doesn't exist, return DB version
	public String createDataBase() throws IOException{
		 
    	String ret = checkDataBase();
 
    	if(ret != null){
    		//do nothing - database already exist
    	}else{
    		//By calling this method and empty database will be created into the default system path
               //of your application so we are gonna be able to overwrite that database with our database.
        	this.getReadableDatabase();
        	try {
    			copyDataBase();
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
    		checkDB = SQLiteDatabase.openDatabase(myPath, null, SQLiteDatabase.OPEN_READONLY);
    	}catch(SQLiteException e){
    		//database does't exist yet.
    	}

    	if(checkDB != null){
    		try
    		{
    			ret = queryDatabaseVersion(checkDB);
    		}
    		catch(SQLiteException e){
        		checkDB.close();
    			checkDB = null;
    		}
    	}
 
    	return ret;
    }
    
    private static String queryDatabaseVersion(SQLiteDatabase db) throws SQLiteException
    {
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
    	//Open the database
        String myPath = DB_PATH + DB_NAME;
    	myDataBase = SQLiteDatabase.openDatabase(myPath, null, SQLiteDatabase.OPEN_READONLY);
    }
    
    private String fixFilterString(String filter)
    {
    	return "%" + filter.toLowerCase().replace('ä', 'b').replace('ì', 'j') + "%";
    }
    
    private Cursor queryAllOrFilter(String allQuery, String filterQuery, String filter)
    {
    	if (filter != null)
    	{
    		return myDataBase.rawQuery(filterQuery, new String[] { fixFilterString(filter) });
    	}
    	return myDataBase.rawQuery(allQuery, null);
    }
    
    public Cursor queryAllEntries(String filter)
    {
    	return queryAllOrFilter(QUERY_ALL, QUERY_FILTER, filter);
    }
    
    public Cursor queryAllEntriesToNavi(String filter)
    {
    	return queryAllOrFilter(QUERY_ALL_TO_NAVI, QUERY_FILTER_TO_NAVI, filter);
    }
    
    public Cursor queryAllEntryToNaviLetters(String filter)
    {
    	return queryAllOrFilter(QUERY_ALL_TO_NAVI_LETTERS, QUERY_FILTER_TO_NAVI_LETTERS, filter);
    }
    
    public Cursor queryAllEntryLetters(String filter)
    {
    	return queryAllOrFilter(QUERY_ALL_LETTERS, QUERY_FILTER_LETTERS, filter);
    }
    
    public Cursor queryForSuggest(String filter)
    {
    	return myDataBase.rawQuery(QUERY_FOR_SUGGEST, new String[] { fixFilterString(filter), "%" + filter + "%" });
    }
    
//    public Cursor queryGroup(int groupId)
//    {
//    	return myDataBase.rawQuery(QUERY_GROUP, new String[] { Integer.toString(groupId) });
//    }
//    
//    public Cursor queryGroupToNavi(int groupId)
//    {
//    	return myDataBase.rawQuery(QUERY_GROUP_TO_NAVI, new String[] { Integer.toString(groupId) });
//    }
    
    public Cursor querySingleEntry(int rowId)
    {
    	return myDataBase.rawQuery(QUERY_ENTRY, new String[] { Integer.toString(rowId) });
    }
    
    @Override
	public synchronized void close() {
    	if(myDataBase != null)
    		myDataBase.close();
 
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
}
