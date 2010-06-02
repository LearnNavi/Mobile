package org.learnnavi.app;

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
        
        // Get references to the animator and set the first page
        mAnimator = (ViewAnimator)findViewById(R.id.ViewAnimator01);
        mMainIndex = loadPage(R.layout.main, R.id.MainView);

        // Display the first page
        // ** If this ever supports landscape orientation,
        //    this will need to be modified to load the page
        //    displayed on orientation changes
        mAnimator.setAnimateFirstView(false);
        mAnimator.setDisplayedChild(mMainIndex);

        // Set the callback and alpha for the buttons
        setupButton(R.id.ResourcesButton);
        setupButton(R.id.DictionaryButton);

        // Check if the dictionary needs to be re-loaded
        recheckDb();

        // Start background thread to check for updated dictionaries
        CheckDictionaryVersion cdv = new CheckDictionaryVersion(this);
        cdv.execute(DBVersion);

        // Load the remaining pages - on demand loading was causing pauses
        // Perhaps find some way to load these one at a time after the main page loads
		loadResourcesPage();
		loadDisclaimerPage();
		loadAboutPage();
		loadAnimations();
    }

    @Override
    public boolean onKeyDown (int keyCode, KeyEvent event) 
    {
        // Check for the back key press
        // Normally it's best not to override back, but this is providing a user experience
        // of backing out of options that wouldn't otherwise be possible with the view animator

    	// Back action is set to the ID of the back button to simulate pressing
    	// Or 0 for default back behavior (Back to previous activity - typically the home screen)
    	if (mBackAction > 0)
    	{
    		// Per 2.1 recommendations, start tracking if a back button is pressed, but
    		// do not act immediately.
    		if (keyCode == KeyEvent.KEYCODE_BACK && event.getRepeatCount() == 0)
    		{
    			mTrackingBack = true;
    			return true;
    		}
    	}
   		mTrackingBack = false;
   		
    	return super.onKeyDown(keyCode, event);
    }

    @Override
    public boolean onKeyUp (int keyCode, KeyEvent event) 
    {
    	if (mBackAction > 0 && mTrackingBack && keyCode == KeyEvent.KEYCODE_BACK)
    	{
    		// Perform the back action now
    		// Clear mBackAction before calling the handler, as it may set it again
    		// But do clear it, because it won't always set it
    		int action = mBackAction;
    		mBackAction = 0;
    		mTrackingBack = false;
    		
    		// Pretend like a button was pressed
    		handleButtonClick(action);
    		return true;
    	}
    	else
    		mTrackingBack = false;
    	return super.onKeyUp(keyCode, event);
    }
    
	@Override
	public boolean onCreateOptionsMenu(Menu menu) {
		// Load the options menu, very basic stuff
	    MenuInflater inflater = getMenuInflater();
	    inflater.inflate(R.menu.main_menu, menu);
	    return true;
	}
	
	/* Handles item selections */
	@Override
	public boolean onOptionsItemSelected(MenuItem item) {
		// Nothing earth shattering here
	    switch (item.getItemId()) {
	    case R.id.BetaInfo:
	    	// Place holder menu item
			Intent newIntent = new Intent(Intent.ACTION_VIEW,
					Uri.parse("http://forum.learnnavi.org/mobile-apps/"));
			startActivity(newIntent);
			return true;
	    }
	    return false;
	}	

	// Helper to load a view for the view animator, and return the newly added index
    private int loadPage(int resource, int id)
    {
    	View.inflate(this, resource, mAnimator);
    	return mAnimator.indexOfChild(findViewById(id));
    }

    // Initialize the animations for use by the view animator
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
    	// Only load it once
    	if (mResourcesIndex >= 0)
    		return;

    	// Load the resources page and initialize the callback and alpha of its buttons
    	mResourcesIndex = loadPage(R.layout.resources, R.id.ResourcesView);
    	
        setupButton(R.id.ReturnFromResourcesButton);
        setupButton(R.id.LearnNaviOrgButton);
        setupButton(R.id.DisclaimerButton);
        setupButton(R.id.AboutButton);
    }
    
    private void loadAboutPage()
    {
    	// Only load it once
    	if (mAboutIndex >= 0)
    		return;
    	
    	// Load the about page and initialize the callback and alpha of its button
    	mAboutIndex = loadPage(R.layout.about, R.id.AboutView);

    	// Set the version strings in about
		TextView ver = (TextView)findViewById(R.id.VersionTextView);
		ver.setText(getVersionString());
		ver = (TextView)findViewById(R.id.DBVersionTextView);
		ver.setText(getDBVersionString());
    	
    	setupButton(R.id.ReturnFromAboutButton);
    }
    
    private void loadDisclaimerPage()
    {
    	// Only load it once
    	if (mDisclaimerIndex >= 0)
    		return;
    	
    	// Load the disclaimer page and initialize the callback and alpha of its button
    	mDisclaimerIndex = loadPage(R.layout.disclaimer, R.id.DisclaimerView);
    	
    	setupButton(R.id.ReturnFromDisclaimerButton);
    }

    // Switch views by sliding the view in from the right
    private void SlideLeftTo(int index)
    {
    	mAnimator.setOutAnimation(this, R.anim.slide_left_out);
    	mAnimator.setInAnimation(this, R.anim.slide_left_in);
    	mAnimator.setDisplayedChild(index);
    }

    // Switch views by sliding the view in from the left
    private void SlideRightTo(int index)
    {
    	mAnimator.setOutAnimation(this, R.anim.slide_right_out);
    	mAnimator.setInAnimation(this, R.anim.slide_right_in);
    	mAnimator.setDisplayedChild(index);
    }

    // Switch views by doing a page flip left
    private void FlipTo(int index)
    {
    	mAnimator.setOutAnimation(mFlipLeftOut);
    	mAnimator.setInAnimation(mFlipLeftIn);
    	mAnimator.setDisplayedChild(index);
    }

    // Switch views by doing a page flip right
    private void FlipFrom(int index)
    {
    	mAnimator.setOutAnimation(mFlipRightOut);
    	mAnimator.setInAnimation(mFlipRightIn);
    	mAnimator.setDisplayedChild(index);
    }

	private void setupButton(int id)
	{
		// Set button callback and alpha
		Button button = (Button)findViewById(id);
        button.setOnClickListener(this);
        button.getBackground().setAlpha(192);
	}
    
    private String getFullVersionString()
    {
    	// Loads the defined string resource and substitutes versions identifiers
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
    	// Loads the defined string resource and substitutes versions identifiers
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
    	// Loads the defined string resource and substitutes versions identifiers
        String verstr = getString(R.string.DBVersionString);

        return verstr.replace("$D$", DBVersion);
    }
    
    private String DBVersion;
    
	@Override
	public void onClick(View v) {
		handleButtonClick(v.getId());
	}

	// Perform actions for button click, depending on the id of the button
	private void handleButtonClick(int id)
	{
		switch (id)
		{
		//
		// Main view
		// Presses from any other view is ignored
		//
		case R.id.ResourcesButton:
			if (mAnimator.getDisplayedChild() != mMainIndex)
				break;
			// Slide from main page to resources
			// Back button to return to main page
			SlideRightTo(mResourcesIndex);
			mBackAction = R.id.ReturnFromResourcesButton;
			break;
		case R.id.DictionaryButton:
			if (mAnimator.getDisplayedChild() != mMainIndex)
				break;
			// Launch new activity of dictionary browser
			Intent newIntent = new Intent();
			newIntent.setClass(this, Dictionary.class);
			startActivity(newIntent);
			break;
		//
		// Resource view
		// Presses from any other view is ignored
		//
		case R.id.ReturnFromResourcesButton:
			if (mAnimator.getDisplayedChild() != mResourcesIndex)
				break;
			// Slide from resources page to main page
			// Back button default action
			SlideLeftTo(mMainIndex);
			mBackAction = 0;
			break;
		case R.id.LearnNaviOrgButton:
			if (mAnimator.getDisplayedChild() != mResourcesIndex)
				break;
			// Launch new web browser activity on learnnavi.org
			newIntent = new Intent(Intent.ACTION_VIEW,
					Uri.parse("http://www.learnnavi.org"));
			startActivity(newIntent);
			break;
		case R.id.DisclaimerButton:
			if (mAnimator.getDisplayedChild() != mResourcesIndex)
				break;
			// Page flip to disclaimer view
			// Back button returns to resources view
			FlipTo(mDisclaimerIndex);
			mBackAction = R.id.ReturnFromDisclaimerButton;
			break;
		case R.id.AboutButton:
			if (mAnimator.getDisplayedChild() != mResourcesIndex)
				break;
			// Page flip to about view
			// Back button returns to resources view
			FlipTo(mAboutIndex);
			mBackAction = R.id.ReturnFromAboutButton;
			break;
		//
		// About view
		// Presses from any other view is ignored
		//
		case R.id.ReturnFromAboutButton:
			if (mAnimator.getDisplayedChild() != mAboutIndex)
				break;
			// Page flip back to resources view
			// Back button returns to main view
			FlipFrom(mResourcesIndex);
			mBackAction = R.id.ReturnFromResourcesButton;
			break;
		//
		// Disclaimer view
		// Presses from any other view is ignored
		//
		case R.id.ReturnFromDisclaimerButton:
			if (mAnimator.getDisplayedChild() != mDisclaimerIndex)
				break;
			// Page flip back to resources view
			// Back button returns to main view
			FlipFrom(mResourcesIndex);
			mBackAction = R.id.ReturnFromResourcesButton;
			break;
		}
	}

	// Callback when an update is available
	public void updateAvailable() {
		// Create a simple alert prompt asking to update
		// ** Once a menu option to enable/disable is in place,
		//    this dialog should include a check box to disable checking
		AlertDialog.Builder alert = new AlertDialog.Builder(this);
		alert.setMessage(R.string.UpdateAvailable);
		alert.setNegativeButton(android.R.string.no, null);
		alert.setPositiveButton(android.R.string.yes, this);
		alert.create().show();
	}

	@Override
	public void onClick(DialogInterface arg0, int arg1) {
		// Handle dialog box button clicks
		// Only called for YES button clicks
		URL DBurl = null;
		try
		{
			// Start background download process
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
		// Forces the DB to be generated if it doesn't exist and returns the version
		DBVersion = EntryDBAdapter.getInstance(this).getDBVersion();

		// Update the version string for beta releases
        TextView version = (TextView)findViewById(R.id.FullVersionTextView);
        version.setText(getFullVersionString());
	}
}