package org.learnnavi.app;

import java.io.IOException;

import android.app.Activity;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.content.pm.PackageManager.NameNotFoundException;
import android.os.Bundle;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.TextView;

public class AboutDisclaimer extends Activity implements OnClickListener {

	static final String KEY_ISABOUT = "IsAbout";
	
	/** Called when the activity is first created. */
	@Override
	public void onCreate(Bundle savedInstanceState) {
	    super.onCreate(savedInstanceState);

	    Boolean isabout = (savedInstanceState == null) ? null :
            (Boolean) savedInstanceState.getSerializable(KEY_ISABOUT);
		if (isabout == null) {
			Bundle extras = getIntent().getExtras();
			isabout = extras != null ? extras.getBoolean(KEY_ISABOUT)
									: false;
			if (isabout == null)
				isabout = false;
		}
		
		if (isabout)
		{
			setContentView(R.layout.about);
			
			TextView ver = (TextView)findViewById(R.id.VersionTextView);
			ver.setText(getVersionString());
			ver = (TextView)findViewById(R.id.DBVersionTextView);
			ver.setText(getDBVersionString());
		}
		else
		{
			setContentView(R.layout.disclaimer);
		}
		
		Button backbutton = (Button)findViewById(R.id.ReturnHomeButton);
		backbutton.setOnClickListener(this);
	}
	
    private String getVersionString()
    {
        String verstr = getString(R.string.VersionString);
        
        PackageManager pm = getPackageManager();
        try
        {
        	PackageInfo pi = pm.getPackageInfo(getPackageName(), 0);
        	verstr = verstr.replace("$V$", pi.versionName);
        }
        catch (NameNotFoundException ex)
        {
        }
        return verstr;
    }
    
    private String getDBVersionString()
    {
        String verstr = getString(R.string.DBVersionString);

        String dbver;
        EntryDBAdapter tmpdb = new EntryDBAdapter(this);
        try
        {
        	dbver = tmpdb.createDataBase();
        	tmpdb.close();
        }
        catch (IOException ex)
        {
        	dbver = "Err";
        }
        
        return verstr.replace("$D$", dbver);
    }

	@Override
	public void onClick(View v) {
		finish();
	}
}
