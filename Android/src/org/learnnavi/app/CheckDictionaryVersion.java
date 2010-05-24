package org.learnnavi.app;

import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.URL;
import java.net.URLConnection;

import android.os.AsyncTask;

public class CheckDictionaryVersion extends AsyncTask<String, Object, Boolean> {
	private Kelutral mContext;
	
	public CheckDictionaryVersion(Kelutral context)
	{
		mContext = context;
	}
	
	@Override
	protected Boolean doInBackground(String... version) {
		Integer curversion = -1;
		try
		{
			curversion = Integer.decode((String)version[0]);
		}
		catch (Exception ex)
		{
		}

		try
		{
			URL source = new URL("http://learnnaviapp.com/database/version");
			URLConnection connection = source.openConnection();
			connection.setDoInput(true);
			connection.connect();
			InputStream content = connection.getInputStream();
			
			BufferedReader reader = new BufferedReader(new InputStreamReader(content, "UTF-8"));
			String verstring = reader.readLine();
			
			content.close();
			
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
			mContext.updateAvailable();
	}
}
