package org.learnnavi.app;

import android.content.ContentProvider;
import android.content.ContentValues;
import android.database.Cursor;
import android.net.Uri;

// Mostly a stubbed content provider currently
public class NaviWords extends ContentProvider {
	public static final Uri CONTENT_URI = Uri.parse("content://org.learnnavi.mobile.naviword");
	private static Boolean mSearchType = null;
	
	// Read-only, no delete allowed
	@Override
	public int delete(Uri arg0, String arg1, String[] arg2) {
		return 0;
	}

	// Stub, not used by search mechanism
	@Override
	public String getType(Uri uri) {
		// TODO Auto-generated method stub
		return null;
	}

	// Read-only, no insert allowed
	@Override
	public Uri insert(Uri uri, ContentValues values) {
		return null;
	}

	// Nothing special to do on create
	@Override
	public boolean onCreate() {
		return true;
	}

	// This only works if the DB is already opened, so it will not work for a global search provider
	@Override
	public Cursor query(Uri uri, String[] projection, String selection,
			String[] selectionArgs, String sortOrder) {
		// Brain dead, assume it is from a suggest query
		EntryDBAdapter instance = EntryDBAdapter.getInstance(getContext()); 
		if (instance.isOpen())
			return instance.queryForSuggest(selectionArgs[0], mSearchType);
		return instance.queryNull();
	}

	// Read-only, no update allowed
	@Override
	public int update(Uri uri, ContentValues values, String selection,
			String[] selectionArgs) {
		return 0;
	}

	// Sets boolean to set whether it should search English or Na'vi words.
	public static void setSearchType(Boolean type)
	{
		mSearchType = type;
	}
}
