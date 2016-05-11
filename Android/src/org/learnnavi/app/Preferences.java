package org.learnnavi.app;

import java.net.MalformedURLException;
import java.net.URL;

import android.os.Bundle;
import android.preference.Preference;
import android.preference.PreferenceActivity;
import android.preference.Preference.OnPreferenceClickListener;

import android.view.MenuItem;
import android.content.Intent;
//import android.content.ContentResolver;
import android.content.res.Configuration;
import android.content.pm.ActivityInfo;
import android.content.Context;
/*import android.provider.Settings;
import android.content.SharedPreferences;
import android.preference.PreferenceManager;
import android.content.res.Configuration;*/



public class Preferences extends PreferenceActivity implements OnPreferenceClickListener, DbDownloadWatcher {
	private DownloadUpdate mDownloadUpdate;
	
	/** Called when the activity is first created. */
	@Override
	public void onCreate(Bundle savedInstanceState) {
	    super.onCreate(savedInstanceState);
	    addPreferencesFromResource(R.xml.userprefs);
	    Preference customPref = findPreference("force_update");
	    customPref.setOnPreferenceClickListener(this);

        mDownloadUpdate = (DownloadUpdate)getLastNonConfigurationInstance();
        if (mDownloadUpdate != null)
        	mDownloadUpdate.reParent(this, this);	
			
        //Auto Rotate Locky thingy
		//SharedPreferences prefs = PreferenceManager.getDefaultSharedPreferences(getBaseContext());
		//if(prefs.getBoolean("auto_rotate", false)){
			//this.setRequestedOrientation(ActivityInfo.SCREEN_ORIENTATION_PORTRAIT);
			//this.setRequestedOrientation(ActivityInfo.SCREEN_ORIENTATION_SENSOR);
			if(! isTablet(this))
				this.setRequestedOrientation(ActivityInfo.SCREEN_ORIENTATION_PORTRAIT);
			//else
				//this.setRequestedOrientation(ActivityInfo.SCREEN_ORIENTATION_SENSOR);
		//}else{
			//this.setRequestedOrientation(ActivityInfo.SCREEN_ORIENTATION_SENSOR);
		//}		
		
	}
	
	/* Handles action bar item selections */
	@Override
	public boolean onOptionsItemSelected(MenuItem item) {
	    switch (item.getItemId()) {
			case android.R.id.home:
				// app icon in action bar clicked; go home 
				Intent intent = new Intent(this, Kelutral.class); 
				intent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP); 
				startActivity(intent); 
				return true;	
	    }
	    return false;
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
	
	public boolean isTablet(Context context){
		boolean xlarge = ((context.getResources().getConfiguration().screenLayout & Configuration.SCREENLAYOUT_SIZE_MASK) == 4); 
		boolean large = ((context.getResources().getConfiguration().screenLayout & Configuration.SCREENLAYOUT_SIZE_MASK) == Configuration.SCREENLAYOUT_SIZE_LARGE); 
		return (xlarge || large); 
	}
}
