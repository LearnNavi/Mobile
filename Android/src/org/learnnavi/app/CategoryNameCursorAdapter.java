package org.learnnavi.app;

import android.content.Context;
import android.database.Cursor;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Adapter;
import android.widget.BaseAdapter;
import android.widget.SimpleCursorAdapter;

public class CategoryNameCursorAdapter extends BaseAdapter {
	private Cursor mGroupCursor;
	private Adapter mItemAdapter;
	private Adapter mGroupAdapter;
	private int[] mGroupCounts;

	private int mGroupCountCol;
	
	public CategoryNameCursorAdapter(Context context, Cursor groupcursor, Adapter itemAdapter, int groupLayout, String[] groupFrom, int[] groupTo)
	{
		mGroupCursor = groupcursor;
		mItemAdapter = itemAdapter;
		mGroupAdapter = new SimpleCursorAdapter(context, groupLayout, groupcursor, groupFrom, groupTo);
		
		mGroupCountCol = groupcursor.getColumnIndexOrThrow("_count");
		
		mGroupCounts = new int[groupcursor.getCount()];
		for (int loop = 0; loop < mGroupCounts.length; loop++)
			mGroupCounts[loop] = -1;
	}

	@Override
	public int getCount() {
		return mGroupAdapter.getCount() + mItemAdapter.getCount();
	}

	@Override
	public boolean isEnabled(int position)
	{
		int groupno = 0;
		int relativepos = position;
		while (mGroupCounts[groupno] + 1 <= relativepos)
		{
			if (mGroupCounts[groupno] < 0)
			{
				mGroupCursor.moveToPosition(groupno);
				mGroupCounts[groupno] = mGroupCursor.getInt(mGroupCountCol);
				continue;
			}
			
			relativepos -= mGroupCounts[groupno] + 1;
			groupno++;
		}
		
		if (relativepos != 0)
			return true;
		return false;
	}
	
	@Override
	public int getViewTypeCount() {
		return mItemAdapter.getViewTypeCount() + mGroupAdapter.getViewTypeCount();
	}
	
	@Override
	public int getItemViewType(int position)
	{
		int groupno = 0;
		int relativepos = position;
		while (mGroupCounts[groupno] + 1 <= relativepos)
		{
			if (mGroupCounts[groupno] < 0)
			{
				mGroupCursor.moveToPosition(groupno);
				mGroupCounts[groupno] = mGroupCursor.getInt(mGroupCountCol);
				continue;
			}
			
			relativepos -= mGroupCounts[groupno] + 1;
			groupno++;
		}
		
		if (relativepos != 0)
			return mItemAdapter.getItemViewType(position - groupno - 1) + 1;
		
		return mGroupAdapter.getItemViewType(groupno);
	}
	
	@Override
	public Object getItem(int position) {
		int groupno = 0;
		int relativepos = position;
		while (mGroupCounts[groupno] + 1 <= relativepos)
		{
			if (mGroupCounts[groupno] < 0)
			{
				mGroupCursor.moveToPosition(groupno);
				mGroupCounts[groupno] = mGroupCursor.getInt(mGroupCountCol);
				continue;
			}
			
			relativepos -= mGroupCounts[groupno] + 1;
			groupno++;
		}
		
		if (relativepos != 0)
			return mItemAdapter.getItem(position - 1 - groupno);
		return mGroupAdapter.getItem(groupno);
	}

	@Override
	public long getItemId(int position) {
		int groupno = 0;
		int relativepos = position;
		while (mGroupCounts[groupno] + 1 <= relativepos)
		{
			if (mGroupCounts[groupno] < 0)
			{
				mGroupCursor.moveToPosition(groupno);
				mGroupCounts[groupno] = mGroupCursor.getInt(mGroupCountCol);
				continue;
			}
			
			relativepos -= mGroupCounts[groupno] + 1;
			groupno++;
		}
		
		if (relativepos != 0)
			return mItemAdapter.getItemId(position - 1 - groupno);
		
		return -mGroupAdapter.getItemId(groupno);
	}

	@Override
	public View getView(int position, View convertView, ViewGroup parent) {
		int groupno = 0;
		int relativepos = position;
		while (mGroupCounts[groupno] + 1 <= relativepos)
		{
			if (mGroupCounts[groupno] < 0)
			{
				mGroupCursor.moveToPosition(groupno);
				mGroupCounts[groupno] = mGroupCursor.getInt(mGroupCountCol);
				continue;
			}
			
			relativepos -= mGroupCounts[groupno] + 1;
			groupno++;
		}
		
		if (relativepos != 0)
			return mItemAdapter.getView(position - groupno - 1, convertView, parent);
		return mGroupAdapter.getView(groupno, convertView, parent);
	}
}
