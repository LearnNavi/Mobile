package org.learnnavi.app;

import java.util.regex.Matcher;
import java.util.regex.Pattern;

import android.app.Dialog;
import android.app.ListActivity;
import android.app.SearchManager;
import android.content.Intent;
import android.database.Cursor;
import android.graphics.Typeface;
import android.os.Bundle;
import android.view.Menu;
import android.view.MenuInflater;
import android.view.MenuItem;
import android.view.View;
import android.view.Window;
import android.view.View.OnClickListener;
import android.widget.Adapter;
import android.widget.AdapterView;
import android.widget.Button;
import android.widget.ListView;
import android.widget.SimpleCursorAdapter;
import android.widget.Spinner;
import android.widget.TextView;
import android.widget.AdapterView.OnItemSelectedListener;

public class Dictionary extends ListActivity implements OnClickListener, OnItemSelectedListener {
	private final int ENTRY_DIALOG = 100; 
	
	static private Button mToNaviButton;
	static private String mCurSearch;
	static private String mCurSearchNavi;
	
	private int mViewingItem;
	
	private boolean mDbIsOpen = false;
	private boolean mToNavi = false;
	
	static private final Pattern IPAVowelPattern = Pattern.compile("[aeiou\u00e6\u025b\u026a\u0323]");
	static private final Pattern NaviVowelPattern = Pattern.compile("[aeiou\u00e4\u00ec]|ll|rr");

	/** Called when the activity is first created. */
	@Override
	public void onCreate(Bundle savedInstanceState) {
	    super.onCreate(savedInstanceState);

	    // Set it to typing will open up a search box
        setDefaultKeyMode(DEFAULT_KEYS_SEARCH_LOCAL);

        setContentView(R.layout.dictionary);

        // Setup the handler for clicking cancel button (Need a better way to present this)
        Button cancelsearch = (Button)findViewById(R.id.CancelSearch);
        cancelsearch.setOnClickListener(this);

        // Setup the handler for clicking the dictionary direction button
        mToNaviButton = (Button)findViewById(R.id.DictionaryType);
        mToNaviButton.setOnClickListener(this);
        
        // Callback to reload the list on part of speech filter change - this will be called before the activity is done loading
    	Spinner s = (Spinner)findViewById(R.id.Spinner01);
    	s.setOnItemSelectedListener(this);

        // Check if this was created as the result of a search (Shouldn't happen currently)
        checkIntentForSearch(getIntent());

        // Open the DB
	    EntryDBAdapter.getInstance(this).openDataBase();
	    mDbIsOpen = true;
	    
	    // Check if there is saved state and restore it if so
	    if (savedInstanceState != null)
	    {
	    	if (savedInstanceState.containsKey("CurSearch"))
	    		mCurSearch = savedInstanceState.getString("CurSearch");
	    	if (savedInstanceState.containsKey("CurSearchNavi"))
	    		mCurSearchNavi = savedInstanceState.getString("CurSearchNavi");
	    	if (savedInstanceState.containsKey("ToNavi"))
	    		mToNavi = savedInstanceState.getBoolean("ToNavi");
	    	if (savedInstanceState.containsKey("ViewingItem"))
	    		mViewingItem = savedInstanceState.getInt("ViewingItem");
	    }

	    // Populate the list is done automatically by the spinner callback
	}
	
	@Override
	public void onSaveInstanceState(Bundle savedInstanceState)
	{
		// Save the search and direction
		// Future: Save the part of speech filter
		// Other things like position of the scroll is handled automatically
		super.onSaveInstanceState(savedInstanceState);

		savedInstanceState.putString("CurSearch", mCurSearch);
		savedInstanceState.putString("CurSearchNavi", mCurSearchNavi);
		savedInstanceState.putBoolean("ToNavi", mToNavi);
		savedInstanceState.putInt("ViewingItem", mViewingItem);
	}
	
	@Override
	public void onStart()
	{
		// Set the search type according to the current setting when the activity starts
		super.onStart();
		NaviWords.setSearchType(mToNavi);
	}
	
	@Override
	public void onStop()
	{
		// Clear the search type when the activity stops
		super.onStop();
		NaviWords.setSearchType(null);	
	}
	
	@Override
	public boolean onCreateOptionsMenu(Menu menu) {
	    MenuInflater inflater = getMenuInflater();
	    inflater.inflate(R.menu.dictionary_menu, menu);
	    return true;
	}
	
	/* Handles item selections */
	@Override
	public boolean onOptionsItemSelected(MenuItem item) {
	    switch (item.getItemId()) {
	    case R.id.Search:
	    	return onSearchRequested();
	    }
	    return false;
	}	
	
	@Override
	public boolean onSearchRequested()
	{
		// Load up the current search term when the search dialog opens
    	startSearch(getCurSearch(), true, null, false);
    	return true;
	}

	@Override
	protected void onNewIntent(Intent intent)
	{
		// The result of a search, process the resulting search request
		if (checkIntentForSearch(intent))
			fillData();
	}
	
	private void setCurSearch(String search)
	{
		// Set the search term, keeping in mind which direction is being searched
		if (mToNavi)
			mCurSearch = search;
		else
			mCurSearchNavi = search;
	}
	
	private String getCurSearch()
	{
		// Get the search term, keeping in mind which direction is being searched
		if (mToNavi)
			return mCurSearch;
		else
			return mCurSearchNavi;
	}
	
	private boolean checkIntentForSearch(Intent intent)
	{
		if (Intent.ACTION_VIEW.equals(intent.getAction()))
		{
			// View - A suggestion was selected, just open the entry directly
			String id = intent.getDataString();
			try
			{
				showDialogForId(Integer.parseInt(id));
			}
			catch (Exception ex)
			{
			}
			// Don't actually perform a search
			return false;
		}
		if (Intent.ACTION_SEARCH.equals(intent.getAction()))
		{
			// Set (Or clear) the search term from the intent
			String search = intent.getStringExtra(SearchManager.QUERY);
			if (search == "")
				search = null;
			setCurSearch(search);
			// Return true to indicate that it should perform the search
			return true;
		}
		else
		{
			// Don't know what intent is requested, so ignore it
			return false;
		}
	}

    private void fillData() {
    	Cursor c;
    	Cursor ci;
    	String cursearch = getCurSearch();
    	
    	String partOfSpeech = null;
    	Spinner s = (Spinner)findViewById(R.id.Spinner01);
    	switch (s.getSelectedItemPosition())
    	{
    	case 1:
    		partOfSpeech = EntryDBAdapter.FILTER_NOUN;
    		break;
    	case 2:
    		partOfSpeech = EntryDBAdapter.FILTER_PNOUN;
    		break;
    	case 3:
    		partOfSpeech = EntryDBAdapter.FILTER_VERB;
    		break;
    	case 4:
    		partOfSpeech = EntryDBAdapter.FILTER_ADJ;
    		break;
    	case 5:
    		partOfSpeech = EntryDBAdapter.FILTER_ADV;
    		break;
    	}
    	
		Button cancel = (Button)findViewById(R.id.CancelSearch);
    	if (cursearch != null)
    	{
    		// Set the text on the button to reflect the search
    		cancel.setVisibility(Button.VISIBLE);
    		cancel.setText(getString(R.string.CancelSearch).replace("$F$", cursearch));
    	}
    	else
    		// Hide the button, no search active
    		cancel.setVisibility(Button.GONE);
    	
    	if (mToNavi)
    	{
    		// Query the dictionary to Na'vi
    		mToNaviButton.setText(R.string.ToNavi);
      		c = EntryDBAdapter.getInstance(this).queryAllEntryToNaviLetters(cursearch, partOfSpeech);
      		ci = EntryDBAdapter.getInstance(this).queryAllEntriesToNavi(cursearch, partOfSpeech);
    	}
    	else
    	{
    		// Query the dictionary form Na'vi
    		mToNaviButton.setText(R.string.FromNavi);
      		c = EntryDBAdapter.getInstance(this).queryAllEntryLetters(cursearch, partOfSpeech);
      		ci = EntryDBAdapter.getInstance(this).queryAllEntries(cursearch, partOfSpeech);
    	}
    	startManagingCursor(c);
    	startManagingCursor(ci);

    	// Setup the mappings to layout elements
    	String[] fromword = new String[] { EntryDBAdapter.KEY_WORD, EntryDBAdapter.KEY_DEFINITION };
    	int[] toword = new int[] { R.id.EntryWord, R.id.EntryDefinition };
    	String[] fromletter = new String[] { EntryDBAdapter.KEY_LETTER };
    	int[] toletter = new int[] { R.id.DictionaryCategory };

    	// Create the adapter for the items and overall category / item combinations
    	Adapter items = new SimpleCursorAdapter(this, R.layout.entry_row, ci, fromword, toword);
    	CategoryNameCursorAdapter entries = new CategoryNameCursorAdapter(this, c, items, R.layout.entry_category, fromletter, toletter);
    	// Fill out the data
    	setListAdapter(entries);
	}
    
	private void fillFields(int rowid, Dialog d) {
		Cursor entry = EntryDBAdapter.getInstance(this).querySingleEntry(rowid);

		// Nothing to actually display - should never happen
		if (!entry.moveToFirst())
			return;

		String word = entry.getString(entry.getColumnIndexOrThrow(EntryDBAdapter.KEY_WORD));
		// Pad the word with spaces so it doesn't get cut off
		TextView text = (TextView)d.findViewById(R.id.EntryWord);
		text.setText(word + "  ");
		
		text = (TextView)d.findViewById(R.id.EntryPartOfSpeech);
		text.setText(entry.getString(entry.getColumnIndexOrThrow(EntryDBAdapter.KEY_PART)));

		text = (TextView)d.findViewById(R.id.EntryIPA);
		String ipastr = entry.getString(entry.getColumnIndexOrThrow(EntryDBAdapter.KEY_IPA));

		String infixes = null;
		if (ipastr != null && ipastr != "")
		{
			// First establish where the infix positions are, from the IPA
			int firstpart = ipastr.indexOf('\u00b7');
			if (firstpart >= 0)
			{
				int length = ipastr.indexOf(']');
				if (length < 0)
					length = ipastr.length();
				int lastpart = ipastr.lastIndexOf('\u00b7', length);
				// Next count syllables in the word
				Matcher wordmatch = NaviVowelPattern.matcher(word);
				int syllables = 0;
				while (wordmatch.find())
					++syllables;
				// Count the syllables before the infixes
				int pos1 = 0, pos2 = 0;
				Matcher ipamatch = IPAVowelPattern.matcher(ipastr);
				while (ipamatch.find() && ipamatch.start() < lastpart)
				{
					if (ipamatch.start() < firstpart)
						++pos1;
					++pos2;
				}
				// Sanity check
				if (pos2 < syllables)
				{
					wordmatch.reset();
					StringBuilder sb = new StringBuilder();
					// Find the first infix position in the word itself
					for (int loop = 0; loop <= pos1; loop++)
					{
						wordmatch.find();
					}
					sb.append(word.substring(0, wordmatch.start()));
					sb.append("<1>");
					// Find the first infix position in the word itself, if it is different
					if (pos1 != pos2)
					{
						int ofs1 = wordmatch.start();
						for (int loop = pos1; loop < pos2; loop++)
						{
							wordmatch.find();
						}
						sb.append(word.substring(ofs1, wordmatch.start()));
					}
					sb.append("<2>");
					sb.append(word.substring(wordmatch.start()));
					infixes = sb.toString();
				}
			}
		}
		text = (TextView)d.findViewById(R.id.EntryInfixes);
		if (infixes != null)
		{
			text.setText(infixes);
			text.setVisibility(View.VISIBLE);
		}
		else
		{
			text.setVisibility(View.GONE);
		}
		
		// Replace the ejective marker from ' to something more visible in the IPA font, and add [] around the text
		if (ipastr != null && ipastr != "")
			ipastr = "[" + ipastr.replace('\'', '\u02bc') + "]";
		text = (TextView)d.findViewById(R.id.EntryIPA);
		text.setText(ipastr);

		text = (TextView)d.findViewById(R.id.EntryDefinition);
		text.setText(entry.getString(entry.getColumnIndexOrThrow(EntryDBAdapter.KEY_DEFINITION)));
	}
	
	private void showDialogForId(int id)
	{
		mViewingItem = id;
		showDialog(ENTRY_DIALOG);
	}
	
	@Override
	protected void onPrepareDialog(int id, Dialog dialog)
	{
		super.onPrepareDialog(id, dialog);

		if (id == ENTRY_DIALOG)
		{
	        Button done = (Button)dialog.findViewById(R.id.DoneButton);
	        done.setOnClickListener(this);

	        fillFields(mViewingItem, dialog);
		}
	}
	
	@Override
	protected Dialog onCreateDialog(int id)
	{
		if (id == ENTRY_DIALOG)
		{
			Dialog ret = new Dialog(this, android.R.style.Theme_Dialog);
			ret.requestWindowFeature(Window.FEATURE_NO_TITLE);
			ret.setContentView(R.layout.dictionary_entry);
            Button done = (Button)ret.findViewById(R.id.DoneButton);
            done.setOnClickListener(this);
            
            // Load a custom font for the IPA string
    		TextView text = (TextView)ret.findViewById(R.id.EntryIPA);
    		text.setTypeface(Typeface.createFromAsset(getAssets(), "ipafont.ttf"));
    		
	        fillFields(mViewingItem, ret);
    		
    		return ret;
		}
		
		return super.onCreateDialog(id);
	}
	
	@Override
    protected void onListItemClick (ListView l, View v, int position, long id) {
    	super.onListItemClick (l, v, position, id);

    	if (id >= 0)
    	{
	    	// Show the entry
    		showDialogForId((int)id);
    	}
    }
    
	@Override
	public void onClick(View v) {
		if (v.getId() == R.id.DoneButton)
		{
			this.dismissDialog(ENTRY_DIALOG);
			return;
		}
		else if (v.getId() == R.id.CancelSearch)
		{
			setCurSearch(null);
			fillData();
			return;
		}
		
		mToNavi = !mToNavi;
		NaviWords.setSearchType(mToNavi);	
		fillData();
	}

	@Override
	public void onDestroy()
	{
		if (mDbIsOpen)
		{
			mDbIsOpen = false;
			EntryDBAdapter.getInstance(this).close();
		}
		super.onDestroy();
	}

	@Override
	public void onItemSelected(AdapterView<?> arg0, View arg1, int arg2,
			long arg3) {
		fillData();
	}

	@Override
	public void onNothingSelected(AdapterView<?> arg0) {
		// Do nothing
	}
}
