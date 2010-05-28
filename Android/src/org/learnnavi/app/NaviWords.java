package org.learnnavi.app;

import android.content.ContentProvider;
import android.content.ContentValues;
import android.database.Cursor;
import android.net.Uri;

public class NaviWords extends ContentProvider {
	public static final Uri CONTENT_URI = Uri.parse("content://org.learnnavi.mobile.naviword");
	private static Boolean mSearchType = null;
	
	@Override
	public int delete(Uri arg0, String arg1, String[] arg2) {
		return 0;
	}

	@Override
	public String getType(Uri uri) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public Uri insert(Uri uri, ContentValues values) {
		return null;
	}

	@Override
	public boolean onCreate() {
		return true;
	}

	@Override
	public Cursor query(Uri uri, String[] projection, String selection,
			String[] selectionArgs, String sortOrder) {
		// Brain dead, assume it is from a suggest query
		EntryDBAdapter instance = EntryDBAdapter.getInstance(getContext()); 
		if (instance.isOpen())
			return instance.queryForSuggest(selectionArgs[0], mSearchType);
		return instance.queryNull();
	}

	@Override
	public int update(Uri uri, ContentValues values, String selection,
			String[] selectionArgs) {
		return 0;
	}
	
	public static void setSearchType(Boolean type)
	{
		mSearchType = type;
	}
}
