package org.learnnavi.app;

import android.app.Activity;
import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;

public class Resources extends Activity implements OnClickListener {

	/** Called when the activity is first created. */
	@Override
	public void onCreate(Bundle savedInstanceState) {
	    super.onCreate(savedInstanceState);
	
        setContentView(R.layout.resources);

        Button button = (Button)findViewById(R.id.ReturnHomeButton);
        button.setOnClickListener(this);
        button = (Button)findViewById(R.id.LearnNaviOrgButton);
        button.setOnClickListener(this);
        button = (Button)findViewById(R.id.DisclaimerButton);
        button.setOnClickListener(this);
        button = (Button)findViewById(R.id.AboutButton);
        button.setOnClickListener(this);
	}

	@Override
	public void onClick(View v) {
		switch (v.getId())
		{
		case R.id.ReturnHomeButton:
			finish();
			break;
		case R.id.LearnNaviOrgButton:
			Intent myIntent = new Intent(Intent.ACTION_VIEW,
					Uri.parse("http://www.learnnavi.org"));
			startActivity(myIntent);
			break;
		case R.id.DisclaimerButton:
			myIntent = new Intent();
			myIntent.setClass(this, AboutDisclaimer.class);
			startActivity(myIntent);
			break;
		case R.id.AboutButton:
			myIntent = new Intent();
			myIntent.setClass(this, AboutDisclaimer.class);
			myIntent.putExtra(AboutDisclaimer.KEY_ISABOUT, true);
			startActivity(myIntent);
			break;
		}
	}

}
