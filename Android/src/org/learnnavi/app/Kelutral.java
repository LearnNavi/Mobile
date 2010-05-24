package org.learnnavi.app;

import java.io.IOException;
import java.net.MalformedURLException;
import java.net.URL;
import java.net.URLConnection;

import android.app.Activity;
import android.app.AlertDialog;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.content.pm.PackageManager.NameNotFoundException;
import android.os.Bundle;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.TextView;

public class Kelutral extends Activity implements OnClickListener, DialogInterface.OnClickListener {
    /** Called when the activity is first created. */
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.main);
        
        Button button = (Button)findViewById(R.id.ResourcesButton);
        button.setOnClickListener(this);
        button = (Button)findViewById(R.id.DictionaryButton);
        button.setOnClickListener(this);
        
        recheckDb();
        
        CheckDictionaryVersion cdv = new CheckDictionaryVersion(this);
        cdv.execute(DBVersion);
    }
    
    private String getFullVersionString()
    {
        String verstr = getString(R.string.VersionStringBeta);
        verstr = verstr.replace("$D$", DBVersion);
        
        PackageManager pm = getPackageManager();
        try
        {
        	PackageInfo pi = pm.getPackageInfo(getPackageName(), 0);
        	verstr = verstr.replace("$V$", pi.versionName);
        	verstr = verstr.replace("$S$", Integer.toString(pi.versionCode));
        }
        catch (NameNotFoundException ex)
        {
        }
        return verstr;
    }
    
    private String DBVersion;
    
	@Override
	public void onClick(View v) {
		switch (v.getId())
		{
		case R.id.ResourcesButton:
			Intent newIntent = new Intent();
			newIntent.setClass(this, Resources.class);
			startActivity(newIntent);
			break;
		case R.id.DictionaryButton:
			newIntent = new Intent();
			newIntent.setClass(this, Dictionary.class);
			startActivity(newIntent);
			break;
		}
	}

	public void updateAvailable() {
		AlertDialog.Builder alert = new AlertDialog.Builder(this);
		alert.setMessage(R.string.UpdateAvailable);
		alert.setNegativeButton(android.R.string.no, null);
		alert.setPositiveButton(android.R.string.yes, this);
		alert.create().show();
	}

	@Override
	public void onClick(DialogInterface arg0, int arg1) {
		URL DBurl = null;
		try
		{
			DBurl = new URL("http://learnnaviapp.com/database/dictionary.sqlite");
			DownloadUpdate du = new DownloadUpdate(this);
			du.execute(DBurl);
		}
		catch (MalformedURLException ex)
		{
			return;
		}
	}

	public void recheckDb() {
        EntryDBAdapter tmpdb = new EntryDBAdapter(this);
        try
        {
        	DBVersion = tmpdb.createDataBase();
        	tmpdb.close();
        }
        catch (IOException ex)
        {
        	DBVersion = "Err";
        }

        TextView version = (TextView)findViewById(R.id.VersionTextView);
        version.setText(getFullVersionString());
	}
}