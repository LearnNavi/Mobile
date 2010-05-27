package org.learnnavi.app;

import android.content.Context;
import android.database.Cursor;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Adapter;
import android.widget.BaseAdapter;
import android.widget.SimpleCursorAdapter;

// Provide a simple list view with two types of entries, a category header and regular
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

		// Initialize the counts to 0, fill them in only as needed
		mGroupCounts = new int[groupcursor.getCount()];
		for (int loop = 0; loop < mGroupCounts.length; loop++)
			mGroupCounts[loop] = -1;
	}

	@Override
	public int getCount() {
		// Total number of items is the combination of categories AND regular items
		return mGroupAdapter.getCount() + mItemAdapter.getCount();
	}

	@Override
	public boolean isEnabled(int position)
	{
		int groupno = 0;
		int relativepos = position;
		// Find if it is a category header by counting through categories
		while (mGroupCounts[groupno] + 1 <= relativepos)
		{
			// If this is the first time checking the count, load it up
			if (mGroupCounts[groupno] < 0)
			{
				mGroupCursor.moveToPosition(groupno);
				mGroupCounts[groupno] = mGroupCursor.getInt(mGroupCountCol);
				continue;
			}

			// Track the position within the category to distinguish header from entry
			relativepos -= mGroupCounts[groupno] + 1;
			groupno++;
		}

		// Don't allow headers to be clicked or selected
		if (relativepos != 0)
			return true;
		return false;
	}
	
	@Override
	public int getViewTypeCount() {
		// View types are used to optimize reuse of resources, so the right type of
		// view gets passed to the correct adapter for re-use.
		return mItemAdapter.getViewTypeCount() + mGroupAdapter.getViewTypeCount();
	}
	
	@Override
	public int getItemViewType(int position)
	{
		int groupno = 0;
		int relativepos = position;
		// Find if it is a category header by counting through categories
		while (mGroupCounts[groupno] + 1 <= relativepos)
		{
			// If this is the first time checking the count, load it up
			if (mGroupCounts[groupno] < 0)
			{
				mGroupCursor.moveToPosition(groupno);
				mGroupCounts[groupno] = mGroupCursor.getInt(mGroupCountCol);
				continue;
			}

			// Track the position within the category to distinguish header from entry
			relativepos -= mGroupCounts[groupno] + 1;
			groupno++;
		}

		// Return the view type for the item, offset by the number of group headers passed
		if (relativepos != 0)
			return mItemAdapter.getItemViewType(position - groupno - 1);
		
		// Return the view type for the group header
		// Offset it by the number of types in the normal items, so it is distinct
		return mGroupAdapter.getItemViewType(groupno) + mItemAdapter.getViewTypeCount();
	}
	
	@Override
	public Object getItem(int position) {
		int groupno = 0;
		int relativepos = position;
		// Find if it is a category header by counting through categories
		while (mGroupCounts[groupno] + 1 <= relativepos)
		{
			// If this is the first time checking the count, load it up
			if (mGroupCounts[groupno] < 0)
			{
				mGroupCursor.moveToPosition(groupno);
				mGroupCounts[groupno] = mGroupCursor.getInt(mGroupCountCol);
				continue;
			}

			// Track the position within the category to distinguish header from entry
			relativepos -= mGroupCounts[groupno] + 1;
			groupno++;
		}

		// Return the item, offset by the number of group headers passed
		if (relativepos != 0)
			return mItemAdapter.getItem(position - 1 - groupno);
		// Return the group header item
		return mGroupAdapter.getItem(groupno);
	}

	@Override
	public long getItemId(int position) {
		int groupno = 0;
		int relativepos = position;
		// Find if it is a category header by counting through categories
		while (mGroupCounts[groupno] + 1 <= relativepos)
		{
			// If this is the first time checking the count, load it up
			if (mGroupCounts[groupno] < 0)
			{
				mGroupCursor.moveToPosition(groupno);
				mGroupCounts[groupno] = mGroupCursor.getInt(mGroupCountCol);
				continue;
			}

			// Track the position within the category to distinguish header from entry
			relativepos -= mGroupCounts[groupno] + 1;
			groupno++;
		}

		// Return the item ID for the item, offset by the number of group headers passed
		if (relativepos != 0)
			return mItemAdapter.getItemId(position - 1 - groupno);
		
		// Since the categories re-use the item IDs, but the ID itself is unimportant,
		// just negate it to make it unique within the list.
		return -mGroupAdapter.getItemId(groupno);
	}

	@Override
	public View getView(int position, View convertView, ViewGroup parent) {
		int groupno = 0;
		int relativepos = position;
		// Find if it is a category header by counting through categories
		while (mGroupCounts[groupno] + 1 <= relativepos)
		{
			// If this is the first time checking the count, load it up
			if (mGroupCounts[groupno] < 0)
			{
				mGroupCursor.moveToPosition(groupno);
				mGroupCounts[groupno] = mGroupCursor.getInt(mGroupCountCol);
				continue;
			}

			// Track the position within the category to distinguish header from entry
			relativepos -= mGroupCounts[groupno] + 1;
			groupno++;
		}

		// Return the view offset by the number of group headers passed
		if (relativepos != 0)
			return mItemAdapter.getView(position - groupno - 1, convertView, parent);
		// Return the view for the group header
		return mGroupAdapter.getView(groupno, convertView, parent);
	}
}
