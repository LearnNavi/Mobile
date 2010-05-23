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
	private static String DB_PATH = "/data/data/org.learnnavi.app/databases/";
	private static String DB_NAME = "dictionary.sqlite";
	private SQLiteDatabase myDataBase;
	private final Context myContext;
	
    public static final String KEY_WORD = "word";
    public static final String KEY_DEFINITION = "definition";
    public static final String KEY_ROWID = "_id";

	public EntryDBAdapter(Context context) {
    	super(context, DB_NAME, null, 1);
        this.myContext = context;
    }
	
	// Copy the database from the distribution if it doesn't exist
	public void createDataBase() throws IOException{
		 
    	boolean dbExist = checkDataBase();
 
    	if(dbExist){
    		//do nothing - database already exist
    	}else{
    		//By calling this method and empty database will be created into the default system path
               //of your application so we are gonna be able to overwrite that database with our database.
        	this.getReadableDatabase();
        	try {
    			copyDataBase();
    		} catch (IOException e) {
        		throw new Error("Error copying database");
        	}
    	}
    }
	
	// Check if the database exists
    private boolean checkDataBase(){
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
    			Cursor c = checkDB.rawQuery("SELECT version FROM version", null);
    			c.close();
        		checkDB.close();
    		}
    		catch(SQLiteException e){
        		checkDB.close();
    			checkDB = null;
    		}
    	}
 
    	return checkDB != null ? true : false;
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
    
    public Cursor queryAllEntries()
    {
    	return myDataBase.rawQuery("SELECT _id, replace(replace(replace(replace(entries.entry_name, 'b', 'ä'), 'j', 'ì'), 'B', 'Ä'), 'J', 'Ì') AS word, entries.english_definition AS definition FROM entries ORDER BY entries.entry_name", null);
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
