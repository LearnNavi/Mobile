package org.learnnavi.app;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;

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
    }
    
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