package org.learnnavi.app;

import android.app.Dialog;
import android.app.ListActivity;
import android.app.SearchManager;
import android.content.Intent;
import android.database.Cursor;
import android.graphics.Typeface;
import android.os.Bundle;
import android.text.Html;
import android.text.SpannableString;
import android.text.Spanned;
import android.view.Menu;
import android.view.MenuInflater;
import android.view.MenuItem;
import android.view.View;
import android.view.Window;
import android.view.View.OnClickListener;
import android.widget.Adapter;
import android.widget.Button;
import android.widget.ListView;
import android.widget.SimpleCursorAdapter;
import android.widget.TextView;

public class Dictionary extends ListActivity implements OnClickListener {
	private Dialog mEntryDialog;
	private Button mToNaviButton;
	private String mCurSearch;
	private String mCurSearchNavi;
	
	private boolean mDbIsOpen = false;
	private boolean mToNavi = false;

	/** Called when the activity is first created. */
	@Override
	public void onCreate(Bundle savedInstanceState) {
	    super.onCreate(savedInstanceState);

        setDefaultKeyMode(DEFAULT_KEYS_SEARCH_LOCAL);
        
        setContentView(R.layout.dictionary);

        Button cancelsearch = (Button)findViewById(R.id.CancelSearch);
        cancelsearch.setOnClickListener(this);

        mToNaviButton = (Button)findViewById(R.id.DictionaryType);
        mToNaviButton.setOnClickListener(this);
        
        checkIntentForSearch(getIntent());

	    EntryDBAdapter.getInstance(this).openDataBase();
	    mDbIsOpen = true;
	    fillData();
	}
	
	@Override
	public void onStart()
	{
		super.onStart();
		NaviWords.setSearchType(mToNavi);	
	}
	
	@Override
	public void onStop()
	{
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
	
	public boolean onSearchRequested()
	{
    	startSearch(getCurSearch(), true, null, false);
    	return true;
	}
	
	protected void onNewIntent(Intent intent)
	{
		if (checkIntentForSearch(intent))
			fillData();
	}
	
	private void setCurSearch(String search)
	{
		if (mToNavi)
			mCurSearch = search;
		else
			mCurSearchNavi = search;
	}
	
	private String getCurSearch()
	{
		if (mToNavi)
			return mCurSearch;
		else
			return mCurSearchNavi;
	}
	
	private boolean checkIntentForSearch(Intent intent)
	{
		if (Intent.ACTION_VIEW.equals(intent.getAction()))
		{
			String id = intent.getDataString();
			try
			{
		    	checkForEntryDialog();
		        fillFields(EntryDBAdapter.getInstance(this).querySingleEntry(Integer.parseInt(id)), mEntryDialog);
		        mEntryDialog.show();
			}
			catch (Exception ex)
			{
			}
			return false;
		}
		if (Intent.ACTION_SEARCH.equals(intent.getAction()))
		{
			String search = intent.getStringExtra(SearchManager.QUERY);
			if (search == "")
				search = null;
			setCurSearch(search);
			return true;
		}
		else
		{
			setCurSearch(null);
			return false;
		}
	}

    private void fillData() {
    	Cursor c;
    	Cursor ci;
    	String cursearch = getCurSearch();
    	
		Button cancel = (Button)findViewById(R.id.CancelSearch);
    	if (cursearch != null)
    	{
    		cancel.setVisibility(Button.VISIBLE);
    		cancel.setText(getString(R.string.CancelSearch).replace("$F$", cursearch));
    	}
    	else
    		cancel.setVisibility(Button.GONE);
    	
    	if (mToNavi)
    	{
    		mToNaviButton.setText(R.string.ToNavi);
      		c = EntryDBAdapter.getInstance(this).queryAllEntryToNaviLetters(cursearch);
      		ci = EntryDBAdapter.getInstance(this).queryAllEntriesToNavi(cursearch);
    	}
    	else
    	{
    		mToNaviButton.setText(R.string.FromNavi);
      		c = EntryDBAdapter.getInstance(this).queryAllEntryLetters(cursearch);
      		ci = EntryDBAdapter.getInstance(this).queryAllEntries(cursearch);
    	}
    	startManagingCursor(c);
    	
    	String[] fromword = new String[] { EntryDBAdapter.KEY_WORD, EntryDBAdapter.KEY_DEFINITION };
    	int[] toword = new int[] { R.id.EntryWord, R.id.EntryDefinition };
    	String[] fromletter = new String[] { EntryDBAdapter.KEY_LETTER };
    	int[] toletter = new int[] { R.id.DictionaryCategory };
    	
    	Adapter items = new SimpleCursorAdapter(this, R.layout.entry_row, ci, fromword, toword);
    	CategoryNameCursorAdapter entries = new CategoryNameCursorAdapter(this, c, items, R.layout.entry_category, fromletter, toletter);
    	setListAdapter(entries);
	}
    
    // For now, deny any HTML display from the dictionary
    private String escapeHtml(String source)
    {
    	// Create a string from the source, since it's not
    	// doing it from HTML, it's a literal string
    	SpannableString s = new SpannableString(source);
    	// Turning it to HTML replaces any HTML code with entities
    	String ret = Html.toHtml(s);
    	// Remove the wrapping paragraph
    	if (ret.startsWith("<p>"))
    	{
    		ret = ret.substring(3, ret.lastIndexOf("</p>"));
    	}
    	
    	return ret;
    }
    
    private Spanned formatString(String orig)
    {
    	// ** Was used to format simple tex markup
    	//    But new DB versions don't do that
    	//    Can be replaced with a call to escapeHtml
    	//    Or nothing at all, since now no HTML formatting is in use
    	StringBuilder ret = new StringBuilder("");
    	int idx = orig.indexOf('{');
    	while (idx > 0)
    	{
    		int idx2 = orig.indexOf('}', idx);
    		if (idx2 < 0)
    			break;
    		int idx3 = orig.indexOf(' ', idx);
    		if (idx3 < 0)
    			idx3 = idx2;
    		String formattype = orig.substring(idx, idx3);
    		String formattedtext;
    		if (idx3 < idx2)
    			formattedtext = orig.substring(idx3 + 1, idx2);
    		else
    			formattedtext = "";
    		
    		if (idx > 0)
    			ret.append(escapeHtml(orig.substring(0, idx)));

    		if (formattype.equals("{it") || formattype.equals("{\\it"))
    			ret.append("<i>" + escapeHtml(formattedtext) + "</i>");
    		else if (formattype.equals("{\bf") || formattype.equals("{\\bf"))
    			ret.append("<b>" + escapeHtml(formattedtext) + "</b>");
    		else
    			ret.append(escapeHtml(formattedtext));
    		
    		orig = orig.substring(idx2 + 1);
    		
    		idx = orig.indexOf('{');
    	}

    	if (orig.length() > 0)
			ret.append(escapeHtml(orig));
    	
    	return Html.fromHtml(ret.toString());
    }
    
	private void fillFields(Cursor entry, Dialog d) {
		if (!entry.moveToFirst())
			return;
		TextView text = (TextView)d.findViewById(R.id.EntryWord);
		text.setText(entry.getString(entry.getColumnIndexOrThrow(EntryDBAdapter.KEY_WORD)) + "  ");
		
		text = (TextView)d.findViewById(R.id.EntryPartOfSpeech);
		text.setText(entry.getString(entry.getColumnIndexOrThrow(EntryDBAdapter.KEY_PART)));

		text = (TextView)d.findViewById(R.id.EntryIPA);
		String ipastr = entry.getString(entry.getColumnIndexOrThrow(EntryDBAdapter.KEY_IPA));
		if (ipastr != null && ipastr != "")
			ipastr = "[" + ipastr.replace('\'', '\u02bc') + "]";
		text.setText(ipastr);

		text = (TextView)d.findViewById(R.id.EntryDefinition);
		text.setText(formatString(entry.getString(entry.getColumnIndexOrThrow(EntryDBAdapter.KEY_DEFINITION))));
	}
	
	private void checkForEntryDialog()
	{
        if (mEntryDialog == null)
        {
        	mEntryDialog = new Dialog(this, android.R.style.Theme_Dialog);
        	mEntryDialog.requestWindowFeature(Window.FEATURE_NO_TITLE);
            mEntryDialog.setContentView(R.layout.dictionary_entry);
            Button done = (Button)mEntryDialog.findViewById(R.id.DoneButton);
            done.setOnClickListener(this);
    		TextView text = (TextView)mEntryDialog.findViewById(R.id.EntryIPA);
    		text.setTypeface(Typeface.createFromAsset(getAssets(), "ipafont.ttf"));
        }
	}
    
	@Override
    protected void onListItemClick (ListView l, View v, int position, long id) {
    	super.onListItemClick (l, v, position, id);
    	checkForEntryDialog();
        fillFields(EntryDBAdapter.getInstance(this).querySingleEntry((int)id), mEntryDialog);
        mEntryDialog.show();
    }
    
	@Override
	public void onClick(View v) {
		if (v.getId() == R.id.DoneButton)
		{
			mEntryDialog.hide();
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
}
