package org.learnnavi.app;

import java.net.MalformedURLException;
import java.net.URL;

import android.os.Bundle;
import android.preference.Preference;
import android.preference.PreferenceActivity;
import android.preference.Preference.OnPreferenceClickListener;

public class Preferences extends PreferenceActivity implements OnPreferenceClickListener, DbDownloadWatcher {
	private DownloadUpdate mDownloadUpdate;
	
	/** Called when the activity is first created. */
	@Override
	public void onCreate(Bundle savedInstanceState) {
	    super.onCreate(savedInstanceState);
	    addPreferencesFromResource(R.xml.userprefs);
	    Preference customPref = (Preference)findPreference("force_update");
	    customPref.setOnPreferenceClickListener(this);

        mDownloadUpdate = (DownloadUpdate)getLastNonConfigurationInstance();
        if (mDownloadUpdate != null)
        	mDownloadUpdate.reParent(this, this);
	}

    @Override
    public Object onRetainNonConfigurationInstance()
    {
    	if (mDownloadUpdate != null)
    		mDownloadUpdate.unParent();
    	return mDownloadUpdate;
    }

    @Override
	public boolean onPreferenceClick(Preference preference) {
    	if (mDownloadUpdate != null)
    		return true;
    	
		// Handle dialog box button clicks
		// Only called for YES button clicks
		URL DBurl = null;
		try
		{
			// Start background download process
			DBurl = new URL("http://learnnaviapp.com/database/database.sqlite");
			mDownloadUpdate = new DownloadUpdate(this, this);
			mDownloadUpdate.execute(DBurl);
		}
		catch (MalformedURLException ex)
		{
		}
		return true;
	}

	@Override
	public void downloadComplete(boolean success) {
		// Callback from update download
		mDownloadUpdate = null;
		
		if (success)
		{
			EntryDBAdapter.reloadDB(this);
		}
	}
}
