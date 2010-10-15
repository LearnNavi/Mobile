package org.learnnavi.app;

import java.net.MalformedURLException;
import java.net.URL;

import android.app.Activity;
import android.app.AlertDialog;
import android.app.Dialog;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.content.pm.PackageManager.NameNotFoundException;
import android.net.Uri;
import android.os.Bundle;
import android.view.GestureDetector;
import android.view.KeyEvent;
import android.view.Menu;
import android.view.MenuInflater;
import android.view.MenuItem;
import android.view.MotionEvent;
import android.view.View;
import android.view.GestureDetector.SimpleOnGestureListener;
import android.view.View.OnClickListener;
import android.view.View.OnTouchListener;
import android.view.animation.AccelerateInterpolator;
import android.view.animation.Animation;
import android.view.animation.DecelerateInterpolator;
import android.widget.Button;
import android.widget.TextView;
import android.widget.ViewAnimator;

public class Kelutral extends Activity implements OnClickListener, DialogInterface.OnClickListener {
	static public final int UPDATEREQ_DLG = 101;
	// Really half the duration of the flip
	static public final int FLIPANIM_SPEED = 500;
	static public final float FLIPANIM_DEPTH = 0.4f;
	// For detecting fling gestures between screens
    private static final int SWIPE_MIN_DISTANCE = 120;
    private static final int SWIPE_MAX_OFF_PATH = 250;
    private static final int SWIPE_THRESHOLD_VELOCITY = 200;
    private GestureDetector mGestureDetector;
    private MyGestureDetector mMyGestureDetector;
    
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
	
	private DownloadUpdate mDownloadUpdate;
	
    /** Called when the activity is first created. */
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.kelutral_main);

        mMyGestureDetector = new MyGestureDetector();
        mGestureDetector = new GestureDetector(mMyGestureDetector);
        
        // Get references to the animator and set the first page
        mAnimator = (ViewAnimator)findViewById(R.id.ViewAnimator01);
        mAnimator.setOnTouchListener(mMyGestureDetector);
        mAnimator.setLongClickable(true);

        int showindex;
        if (savedInstanceState != null && savedInstanceState.containsKey("CurrentView"))
        {
        	int curpage = savedInstanceState.getInt("CurrentView");
        	showindex = loadPage(curpage);
        	switch (curpage)
        	{
        	case R.id.ResourcesView:
        		mBackAction = R.id.ReturnFromResourcesButton;
        		break;
        	case R.id.AboutView:
        		mBackAction = R.id.ReturnFromAboutButton;
        		break;
        	case R.id.DisclaimerView:
        		mBackAction = R.id.ReturnFromDisclaimerButton;
        		break;
        	}
        }
        else
        {
        	showindex = loadPage(R.id.MainView);
        }

        // Display the first page
        // ** If this ever supports landscape orientation,
        //    this will need to be modified to load the page
        //    displayed on orientation changes
        mAnimator.setAnimateFirstView(false);
        mAnimator.setDisplayedChild(showindex);

        // Check if the dictionary needs to be re-loaded
        recheckDb();

        if (savedInstanceState == null || !savedInstanceState.containsKey("SkipDBCheck") || !savedInstanceState.getBoolean("SkipDBCheck"))
        {
            // Start background thread to check for updated dictionaries
            CheckDictionaryVersion cdv = new CheckDictionaryVersion(this);
            cdv.execute(DBVersion);
        }
        
        mDownloadUpdate = (DownloadUpdate)getLastNonConfigurationInstance();
        if (mDownloadUpdate != null)
        	mDownloadUpdate.reParent(this);
    }
    
    @Override
    public Object onRetainNonConfigurationInstance()
    {
    	if (mDownloadUpdate != null)
    		mDownloadUpdate.unParent();
    	return mDownloadUpdate;
    }
    
    @Override
    public void onResume()
    {
    	super.onResume();
    	
        // Load the remaining pages - on demand loading was causing pauses
        // Perhaps find some way to load these one at a time after the main page loads
		loadMainPage();
		loadResourcesPage();
		loadDisclaimerPage();
		loadAboutPage();
		loadAnimations();
    }
    
	@Override
	public void onSaveInstanceState(Bundle savedInstanceState)
	{
		// Save the search and direction
		// Future: Save the part of speech filter
		// Other things like position of the scroll is handled automatically
		super.onSaveInstanceState(savedInstanceState);

		savedInstanceState.putInt("CurrentView", mAnimator.getChildAt(mAnimator.getDisplayedChild()).getId());
		savedInstanceState.putBoolean("SkipDBCheck", true);
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
    private int findPage(int id)
    {
    	View retview = findViewById(id);
    	retview.setDrawingCacheEnabled(true);
    	return mAnimator.indexOfChild(retview);
    }
    
    // Initialize the animations for use by the view animator
    private void loadAnimations()
    {
    	mFlipRightOut = new PageFlip3d(0.0f, 90.0f, 0.5f, 0.5f, FLIPANIM_DEPTH);
    	mFlipRightOut.setDuration(FLIPANIM_SPEED);
    	mFlipRightOut.setStartOffset(50);
    	mFlipRightOut.setInterpolator(new AccelerateInterpolator());
    	
    	mFlipRightIn = new PageFlip3d(-90.0f, 0.0f, 0.5f, 0.5f, FLIPANIM_DEPTH);
    	mFlipRightIn.setDuration(FLIPANIM_SPEED);
    	mFlipRightIn.setStartOffset(FLIPANIM_SPEED + 50);
    	mFlipRightIn.setInterpolator(new DecelerateInterpolator());
    	
    	mFlipLeftOut = new PageFlip3d(0.0f, -90.0f, 0.5f, 0.5f, FLIPANIM_DEPTH);
    	mFlipLeftOut.setDuration(FLIPANIM_SPEED);
    	mFlipLeftOut.setStartOffset(50);
    	mFlipLeftOut.setInterpolator(new AccelerateInterpolator());
    	
    	mFlipLeftIn = new PageFlip3d(90.0f, 0.0f, 0.5f, 0.5f, FLIPANIM_DEPTH);
    	mFlipLeftIn.setDuration(FLIPANIM_SPEED);
    	mFlipLeftIn.setStartOffset(FLIPANIM_SPEED + 50);
    	mFlipLeftIn.setInterpolator(new DecelerateInterpolator());
    }
    
    private int loadPage(int id)
    {
    	// Load a page by ID and return the index
    	switch (id)
    	{
    	case R.id.ResourcesView:
    		loadResourcesPage();
    		return mResourcesIndex;
    	case R.id.AboutView:
    		loadAboutPage();
    		return mAboutIndex;
    	case R.id.DisclaimerView:
    		loadDisclaimerPage();
    		return mDisclaimerIndex;
    	case R.id.MainView:
   		default:
    		loadMainPage();
    		return mMainIndex;
    	}
    }

    private void loadMainPage()
    {
    	// Only load it once
    	if (mMainIndex >= 0)
    		return;

    	// Load the main page and initialize the callback and alpha of its buttons
        mMainIndex = findPage(R.id.MainView);
        
        if (DBVersion != null)
        {
			// Update the version string for beta releases
	        TextView version = (TextView)findViewById(R.id.FullVersionTextView);
	       	version.setText(getFullVersionString());
        }
        
        // Set the callback and alpha for the buttons
        setupButton(R.id.ResourcesButton);
        setupButton(R.id.DictionaryButton);
    }
    
    private void loadResourcesPage()
    {
    	// Only load it once
    	if (mResourcesIndex >= 0)
    		return;

    	// Load the resources page and initialize the callback and alpha of its buttons
    	mResourcesIndex = findPage(R.id.ResourcesView);
    	
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
    	mAboutIndex = findPage(R.id.AboutView);

    	// Set the version strings in about
		TextView ver = (TextView)findViewById(R.id.VersionTextView);
		ver.setText(getVersionString());
		if (DBVersion != null)
		{
			ver = (TextView)findViewById(R.id.DBVersionTextView);
			ver.setText(getDBVersionString());
		}
    	
    	setupButton(R.id.ReturnFromAboutButton);
    }
    
    private void loadDisclaimerPage()
    {
    	// Only load it once
    	if (mDisclaimerIndex >= 0)
    		return;
    	
    	// Load the disclaimer page and initialize the callback and alpha of its button
    	mDisclaimerIndex = findPage(R.id.DisclaimerView);
    	
    	setupButton(R.id.ReturnFromDisclaimerButton);
    }

    // Switch views by sliding the view in from the right
    private void slideLeftTo(int index)
    {
    	mAnimator.setOutAnimation(this, R.anim.slide_left_out);
    	mAnimator.setInAnimation(this, R.anim.slide_left_in);
    	mAnimator.setDisplayedChild(index);
    }

    // Switch views by sliding the view in from the left
    private void slideRightTo(int index)
    {
    	mAnimator.setOutAnimation(this, R.anim.slide_right_out);
    	mAnimator.setInAnimation(this, R.anim.slide_right_in);
    	mAnimator.setDisplayedChild(index);
    }

    // Switch views by doing a page flip left
    private void flipTo(int index)
    {
    	mAnimator.setOutAnimation(mFlipLeftOut);
    	mAnimator.setInAnimation(mFlipLeftIn);
    	mAnimator.setDisplayedChild(index);
    }

    // Switch views by doing a page flip right
    private void flipFrom(int index)
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
		if (mDownloadUpdate != null)
			return;
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
			slideRightTo(mResourcesIndex);
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
			slideLeftTo(mMainIndex);
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
			flipTo(mDisclaimerIndex);
			mBackAction = R.id.ReturnFromDisclaimerButton;
			break;
		case R.id.AboutButton:
			if (mAnimator.getDisplayedChild() != mResourcesIndex)
				break;
			// Page flip to about view
			// Back button returns to resources view
			flipTo(mAboutIndex);
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
			flipFrom(mResourcesIndex);
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
			flipFrom(mResourcesIndex);
			mBackAction = R.id.ReturnFromResourcesButton;
			break;
		}
	}

	@Override
	protected Dialog onCreateDialog(int id)
	{
		if (id == UPDATEREQ_DLG)
		{
			// Create a simple alert prompt asking to update
			// ** Once a menu option to enable/disable is in place,
			//    this dialog should include a check box to disable checking
			AlertDialog.Builder alert = new AlertDialog.Builder(this);
			alert.setMessage(R.string.UpdateAvailable);
			alert.setNegativeButton(android.R.string.no, null);
			alert.setPositiveButton(android.R.string.yes, this);
			return alert.create();
		}
		return super.onCreateDialog(id);
	}

	@Override
	public void onClick(DialogInterface arg0, int arg1) {
		// Handle dialog box button clicks
		// Only called for YES button clicks
		URL DBurl = null;
		try
		{
			// Start background download process
			DBurl = new URL("http://learnnaviapp.com/database/database.sqlite");
			mDownloadUpdate = new DownloadUpdate(this);
			mDownloadUpdate.execute(DBurl);
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
        if (version != null)
        	version.setText(getFullVersionString());
        version = (TextView)findViewById(R.id.DBVersionTextView);
        if (version != null)
        	version.setText(getDBVersionString());

	}
	
	public void downloadComplete(boolean success)
	{
		// Callback from update download
		mDownloadUpdate = null;
		
		if (success)
		{
			EntryDBAdapter.reloadDB(this);
			recheckDb();
		}
	}
	
    class MyGestureDetector extends SimpleOnGestureListener implements OnTouchListener
    {
        @Override
        public boolean onFling(MotionEvent e1, MotionEvent e2, float velocityX, float velocityY)
        {
            try
            {
                if (Math.abs(e1.getY() - e2.getY()) > SWIPE_MAX_OFF_PATH)
                    return false;
                // right to left swipe
                if(e1.getX() - e2.getX() > SWIPE_MIN_DISTANCE && Math.abs(velocityX) > SWIPE_THRESHOLD_VELOCITY)
                {
                	if (mAnimator.getDisplayedChild() == mMainIndex)
                	{
                		handleButtonClick(R.id.ResourcesButton);
                	}
                	else if (mAnimator.getDisplayedChild() == mResourcesIndex)
                	{
                		handleButtonClick(R.id.AboutButton);
                	}
                }
                else if (e2.getX() - e1.getX() > SWIPE_MIN_DISTANCE && Math.abs(velocityX) > SWIPE_THRESHOLD_VELOCITY)
                {
                	if (mBackAction > 0)
                	{
	            		int action = mBackAction;
	            		mBackAction = 0;
	            		mTrackingBack = false;
	            		
	            		// Pretend like a button was pressed
	            		handleButtonClick(action);
                	}
                }
            }
            catch (Exception e)
            {
                // nothing
            }
            return false;
        }
        
        @Override
        public boolean onTouch(View v, MotionEvent event)
        {
            return mGestureDetector == null ? false : mGestureDetector.onTouchEvent(event);
        }
    }
}