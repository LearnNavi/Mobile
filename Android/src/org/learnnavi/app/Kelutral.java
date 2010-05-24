package org.learnnavi.app;

import java.io.IOException;

import android.app.Activity;
import android.content.Intent;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.content.pm.PackageManager.NameNotFoundException;
import android.os.Bundle;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.TextView;

public class Kelutral extends Activity implements OnClickListener {
    /** Called when the activity is first created. */
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.main);
        
        Button button = (Button)findViewById(R.id.ResourcesButton);
        button.setOnClickListener(this);
        button = (Button)findViewById(R.id.DictionaryButton);
        button.setOnClickListener(this);
        EntryDBAdapter tmpdb = new EntryDBAdapter(this);
        try
        {
        	DBVersion = tmpdb.createDataBase();
        }
        catch (IOException ex)
        {
        	DBVersion = "Err";
        }

        TextView version = (TextView)findViewById(R.id.VersionTextView);
        version.setText(getFullVersionString());
    }
    
    private String getFullVersionString()
    {
        String verstr = getString(R.string.VersionString);
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
}