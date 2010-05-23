package org.learnnavi.app;

import java.io.IOException;

import android.app.ListActivity;
import android.database.Cursor;
import android.os.Bundle;
import android.widget.SimpleCursorAdapter;

public class Dictionary extends ListActivity {
	private EntryDBAdapter mDbAdapter;

	/** Called when the activity is first created. */
	@Override
	public void onCreate(Bundle savedInstanceState) {
	    super.onCreate(savedInstanceState);
	
        setContentView(R.layout.dictionary);
        mDbAdapter = new EntryDBAdapter(this);
        try
        {
		    mDbAdapter.createDataBase();
		    mDbAdapter.openDataBase();
		    fillData();
        }
        catch (IOException e)
        {
        }
	}

    private void fillData() {
    	Cursor c = mDbAdapter.queryAllEntries();
    	startManagingCursor(c);
    	
    	String[] from = new String[] { EntryDBAdapter.KEY_WORD, EntryDBAdapter.KEY_DEFINITION };
    	int[] to = new int[] { R.id.EntryWord, R.id.EntryDefinition };
    	
    	SimpleCursorAdapter entries = new SimpleCursorAdapter(this, R.layout.entry_row, c, from, to);
    	setListAdapter(entries);
	}
}
