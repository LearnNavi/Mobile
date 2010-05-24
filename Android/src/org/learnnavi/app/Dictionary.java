package org.learnnavi.app;

import java.io.IOException;

import android.app.Dialog;
import android.app.ListActivity;
import android.database.Cursor;
import android.os.Bundle;
import android.text.Html;
import android.text.SpannableString;
import android.text.Spanned;
import android.view.View;
import android.view.Window;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.ListView;
import android.widget.SimpleCursorAdapter;
import android.widget.TextView;

public class Dictionary extends ListActivity implements OnClickListener {
	private EntryDBAdapter mDbAdapter;
	private Dialog mEntryDialog;
	private Button mToNaviButton;
	
	private boolean mToNavi = false;

	/** Called when the activity is first created. */
	@Override
	public void onCreate(Bundle savedInstanceState) {
	    super.onCreate(savedInstanceState);
	
        setContentView(R.layout.dictionary);
        mToNaviButton = (Button)findViewById(R.id.DictionaryType);
        mToNaviButton.setOnClickListener(this);
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
    	Cursor c;
    	if (mToNavi)
    	{
    		mToNaviButton.setText(R.string.ToNavi);
      		c = mDbAdapter.queryAllEntriesToNavi();
    	}
    	else
    	{
    		mToNaviButton.setText(R.string.FromNavi);
      		c = mDbAdapter.queryAllEntries();
    	}
    	startManagingCursor(c);
    	
    	String[] from = new String[] { EntryDBAdapter.KEY_WORD, EntryDBAdapter.KEY_DEFINITION };

    	int[] to = new int[] { R.id.EntryWord, R.id.EntryDefinition };
    	
    	SimpleCursorAdapter entries = new SimpleCursorAdapter(this, R.layout.entry_row, c, from, to);
    	setListAdapter(entries);
	}
    
    private String escapeHtml(String source)
    {
    	SpannableString s = new SpannableString(source);
    	String ret = Html.toHtml(s);
    	if (ret.startsWith("<p>"))
    	{
    		ret = ret.substring(3, ret.lastIndexOf("</p>"));
    	}
    	
    	return ret;
    }
    
    private Spanned formatString(String orig)
    {
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
		text.setText(entry.getString(entry.getColumnIndexOrThrow(EntryDBAdapter.KEY_WORD)));
		
		text = (TextView)d.findViewById(R.id.EntryPartOfSpeech);
		text.setText(entry.getString(entry.getColumnIndexOrThrow(EntryDBAdapter.KEY_PART)));

		text = (TextView)d.findViewById(R.id.EntryIPA);
		text.setText(entry.getString(entry.getColumnIndexOrThrow(EntryDBAdapter.KEY_IPA)));

		text = (TextView)d.findViewById(R.id.EntryDefinition);
		text.setText(formatString(entry.getString(entry.getColumnIndexOrThrow(EntryDBAdapter.KEY_DEFINITION))));
	}
    
    @Override
    protected void onListItemClick(ListView l, View v, int position, long id) {
        super.onListItemClick(l, v, position, id);

        if (mEntryDialog == null)
        {
        	mEntryDialog = new Dialog(this, android.R.style.Theme_Dialog);
        	mEntryDialog.requestWindowFeature(Window.FEATURE_NO_TITLE);
            mEntryDialog.setContentView(R.layout.dictionary_entry);
            Button done = (Button)mEntryDialog.findViewById(R.id.DoneButton);
            done.setOnClickListener(this);
        }
        fillFields(mDbAdapter.querySingleEntry((int)id), mEntryDialog);
        mEntryDialog.show();
    }
    
	@Override
	public void onClick(View v) {
		if (v.getId() == R.id.DoneButton)
		{
			mEntryDialog.hide();
			return;
		}
		
		mToNavi = !mToNavi;
		fillData();
	}
}
