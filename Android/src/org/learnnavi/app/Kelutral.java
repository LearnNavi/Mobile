package org.learnnavi.app;

import java.io.IOException;
import java.net.MalformedURLException;
import java.net.URL;

import android.app.Activity;
import android.app.AlertDialog;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.content.pm.PackageManager.NameNotFoundException;
import android.net.Uri;
import android.os.Bundle;
import android.view.KeyEvent;
import android.view.Menu;
import android.view.MenuInflater;
import android.view.MenuItem;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.animation.AccelerateInterpolator;
import android.view.animation.Animation;
import android.view.animation.DecelerateInterpolator;
import android.widget.Button;
import android.widget.TextView;
import android.widget.ViewAnimator;

public class Kelutral extends Activity implements OnClickListener, DialogInterface.OnClickListener {
	private int mMainIndex = -1;
	private int mResourcesIndex = -1;
	private int mAboutIndex = -1;
	private int mDisclaimerIndex = -1;
	private ViewAnimator mAnimator;
	private Animation mFlipRightOut;
	private Animation mFlipRightIn;
	private Animation mFlipLeftOut;
	private Animation mFlipLeftIn;
	private int mBackAction = -1;
	private boolean mTrackingBack = false;
	
    /** Called when the activity is first created. */
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.kelutral_main);
        
        mAnimator = (ViewAnimator)findViewById(R.id.ViewAnimator01);
        mMainIndex = loadPage(R.layout.main, R.id.MainView);
        
        mAnimator.setAnimateFirstView(false);
        mAnimator.setDisplayedChild(mMainIndex);
        
        setupButton(R.id.ResourcesButton);
        setupButton(R.id.DictionaryButton);
        
        recheckDb();
        
        CheckDictionaryVersion cdv = new CheckDictionaryVersion(this);
        cdv.execute(DBVersion);
        
		loadResourcesPage();
		loadDisclaimerPage();
		loadAboutPage();
		loadAnimations();
    }

    @Override
    public boolean onKeyDown (int keyCode, KeyEvent event) 
    {
    	if (mBackAction > 0)
    	{
    		if (keyCode == KeyEvent.KEYCODE_BACK && event.getRepeatCount() == 0)
    		{
    			mTrackingBack = true;
    			return true;
    		}
    	}
    	else
    		mTrackingBack = false;
    	return super.onKeyDown(keyCode, event);
    }

    @Override
    public boolean onKeyUp (int keyCode, KeyEvent event) 
    {
    	if (mBackAction > 0 && mTrackingBack && keyCode == KeyEvent.KEYCODE_BACK)
    	{
    		int action = mBackAction;
    		mBackAction = 0;
    		mTrackingBack = false;
    		handleButtonClick(action);
    		return true;
    	}
    	else
    		mTrackingBack = false;
    	return super.onKeyUp(keyCode, event);
    }
    
	@Override
	public boolean onCreateOptionsMenu(Menu menu) {
	    MenuInflater inflater = getMenuInflater();
	    inflater.inflate(R.menu.main_menu, menu);
	    return true;
	}
	
	/* Handles item selections */
	@Override
	public boolean onOptionsItemSelected(MenuItem item) {
	    switch (item.getItemId()) {
	    case R.id.BetaInfo:
			Intent newIntent = new Intent(Intent.ACTION_VIEW,
					Uri.parse("http://forum.learnnavi.org/mobile-apps/"));
			startActivity(newIntent);
			return true;
	    }
	    return false;
	}	
    
    private int loadPage(int resource, int id)
    {
    	View.inflate(this, resource, mAnimator);
    	return mAnimator.indexOfChild(findViewById(id));
    }
    
    private void loadAnimations()
    {
    	mFlipRightOut = new PageFlip3d(0.0f, 90.0f, 0.5f, 0.5f);
    	mFlipRightOut.setDuration(350);
    	mFlipRightOut.setInterpolator(new AccelerateInterpolator());
    	
    	mFlipRightIn = new PageFlip3d(-90.0f, 0.0f, 0.5f, 0.5f);
    	mFlipRightIn.setDuration(350);
    	mFlipRightIn.setStartOffset(350);
    	mFlipRightIn.setInterpolator(new DecelerateInterpolator());
    	
    	mFlipLeftOut = new PageFlip3d(0.0f, -90.0f, 0.5f, 0.5f);
    	mFlipLeftOut.setDuration(350);
    	mFlipLeftOut.setInterpolator(new AccelerateInterpolator());
    	
    	mFlipLeftIn = new PageFlip3d(90.0f, 0.0f, 0.5f, 0.5f);
    	mFlipLeftIn.setDuration(350);
    	mFlipLeftIn.setStartOffset(350);
    	mFlipLeftIn.setInterpolator(new DecelerateInterpolator());
    }
    
    private void loadResourcesPage()
    {
    	if (mResourcesIndex >= 0)
    		return;
    	
    	mResourcesIndex = loadPage(R.layout.resources, R.id.ResourcesView);
    	
        setupButton(R.id.ReturnFromResourcesButton);
        setupButton(R.id.LearnNaviOrgButton);
        setupButton(R.id.DisclaimerButton);
        setupButton(R.id.AboutButton);
    }
    
    private void loadAboutPage()
    {
    	if (mAboutIndex >= 0)
    		return;
    	
    	mAboutIndex = loadPage(R.layout.about, R.id.AboutView);
    	
		TextView ver = (TextView)findViewById(R.id.VersionTextView);
		ver.setText(getVersionString());
		ver = (TextView)findViewById(R.id.DBVersionTextView);
		ver.setText(getDBVersionString());
    	
    	setupButton(R.id.ReturnFromAboutButton);
    }
    
    private void loadDisclaimerPage()
    {
    	if (mDisclaimerIndex >= 0)
    		return;
    	
    	mDisclaimerIndex = loadPage(R.layout.disclaimer, R.id.DisclaimerView);
    	
    	setupButton(R.id.ReturnFromDisclaimerButton);
    }
    
    private void SlideLeftTo(int index)
    {
    	mAnimator.setOutAnimation(this, R.anim.slide_left_out);
    	mAnimator.setInAnimation(this, R.anim.slide_left_in);
    	mAnimator.setDisplayedChild(index);
    }

    private void SlideRightTo(int index)
    {
    	mAnimator.setOutAnimation(this, R.anim.slide_right_out);
    	mAnimator.setInAnimation(this, R.anim.slide_right_in);
    	mAnimator.setDisplayedChild(index);
    }

    private void FlipTo(int index)
    {
    	mAnimator.setOutAnimation(mFlipLeftOut);
    	mAnimator.setInAnimation(mFlipLeftIn);
    	mAnimator.setDisplayedChild(index);
    }

    private void FlipFrom(int index)
    {
    	mAnimator.setOutAnimation(mFlipRightOut);
    	mAnimator.setInAnimation(mFlipRightIn);
    	mAnimator.setDisplayedChild(index);
    }

	private void setupButton(int id)
	{
		Button button = (Button)findViewById(id);
        button.setOnClickListener(this);
        button.getBackground().setAlpha(192);
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

        return verstr.replace("$D$", DBVersion);
    }
    
    private String DBVersion;
    
	@Override
	public void onClick(View v) {
		handleButtonClick(v.getId());
	}
	
	private void handleButtonClick(int id)
	{
		switch (id)
		{
		case R.id.ResourcesButton:
			if (mAnimator.getDisplayedChild() != mMainIndex)
				break;
			SlideRightTo(mResourcesIndex);
			mBackAction = R.id.ReturnFromResourcesButton;
			break;
		case R.id.DictionaryButton:
			if (mAnimator.getDisplayedChild() != mMainIndex)
				break;
			Intent newIntent = new Intent();
			newIntent.setClass(this, Dictionary.class);
			startActivity(newIntent);
			break;
		case R.id.ReturnFromResourcesButton:
			if (mAnimator.getDisplayedChild() != mResourcesIndex)
				break;
			SlideLeftTo(mMainIndex);
			mBackAction = 0;
			break;
		case R.id.LearnNaviOrgButton:
			if (mAnimator.getDisplayedChild() != mResourcesIndex)
				break;
			newIntent = new Intent(Intent.ACTION_VIEW,
					Uri.parse("http://www.learnnavi.org"));
			startActivity(newIntent);
			break;
		case R.id.DisclaimerButton:
			if (mAnimator.getDisplayedChild() != mResourcesIndex)
				break;
			FlipTo(mDisclaimerIndex);
			mBackAction = R.id.ReturnFromDisclaimerButton;
			break;
		case R.id.AboutButton:
			if (mAnimator.getDisplayedChild() != mResourcesIndex)
				break;
			FlipTo(mAboutIndex);
			mBackAction = R.id.ReturnFromAboutButton;
			break;
		case R.id.ReturnFromAboutButton:
			if (mAnimator.getDisplayedChild() != mAboutIndex)
				break;
			FlipFrom(mResourcesIndex);
			mBackAction = R.id.ReturnFromResourcesButton;
			break;
		case R.id.ReturnFromDisclaimerButton:
			if (mAnimator.getDisplayedChild() != mDisclaimerIndex)
				break;
			FlipFrom(mResourcesIndex);
			mBackAction = R.id.ReturnFromResourcesButton;
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
		DBVersion = EntryDBAdapter.getInstance(this).getDBVersion();

        TextView version = (TextView)findViewById(R.id.FullVersionTextView);
        version.setText(getFullVersionString());
	}
}