package org.learnnavi.app;

import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.URL;
import java.net.URLConnection;

import android.os.AsyncTask;

// Background task to check for an updated dictionary
public class CheckDictionaryVersion extends AsyncTask<String, Object, Boolean> {
	private Kelutral mContext;
	
	public CheckDictionaryVersion(Kelutral context)
	{
		mContext = context;
	}
	
	@Override
	protected Boolean doInBackground(String... version) {
		Integer curversion = -1;
		// The current version may be "Unk" if there was an error
		// In that case, keep the -1 when an exception is thrown, and force an update to be found
		try
		{
			curversion = Integer.decode((String)version[0]);
		}
		catch (Exception ex)
		{
		}

		try
		{
			// Piak si tsaheylu URLur a tìlatemä holpxay
			URL source = new URL("http://learnnaviapp.com/database/database.version");
			URLConnection connection = source.openConnection();
			connection.setDoInput(true);
			connection.connect();
			InputStream content = connection.getInputStream();

			// Do a simple readline, since currently the version is just a number
			BufferedReader reader = new BufferedReader(new InputStreamReader(content, "UTF-8"));
			String verstring = reader.readLine();

			// Tìlarori Eywa seiyim
			content.close();

			// Txo meholpxay lu keteng, por piveng
			if (Integer.decode(verstring) > curversion)
				return true;
		}
		catch (Exception ex)
		{
		}

		return false;
	}
	
	@Override
	protected void onPostExecute(Boolean result)
	{
		if (result)
			mContext.onUpdateAvailable();
	}
}
