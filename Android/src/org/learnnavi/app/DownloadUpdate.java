package org.learnnavi.app;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.net.URL;
import java.net.URLConnection;

import android.app.AlertDialog;
import android.app.ProgressDialog;
import android.content.DialogInterface;
import android.content.DialogInterface.OnClickListener;
import android.os.AsyncTask;

public class DownloadUpdate extends AsyncTask<URL, Integer, File> implements OnClickListener {
	private Kelutral mContext;
	private String mError;
	ProgressDialog mProgress;
	
	public DownloadUpdate(Kelutral context)
	{
		mContext = context;
	}
	
	@Override
	protected void onPreExecute()
	{
		if (!isCancelled())
		{
			mProgress = new ProgressDialog(mContext);
			mProgress.setCancelable(true);
			mProgress.setMax(1000);
			mProgress.setTitle(R.string.DownloadingUpdate);
			mProgress.setButton(ProgressDialog.BUTTON_NEGATIVE, mContext.getText(android.R.string.cancel), this);
			mProgress.show();
		}
	}

	@Override
	protected File doInBackground(URL... params) {
		File outfile = null;
		try
		{
			int curprogress = -1;
			URLConnection connection = params[0].openConnection();
			connection.setDoInput(true);
			connection.connect();
			int totallen = connection.getContentLength();
			int totread = 0;
			
			InputStream i = connection.getInputStream();
			outfile = new File("/data/data/org.learnnavi.app", "dbupdate.sqlite");
			FileOutputStream f = new FileOutputStream(outfile);
			
			byte[] buffer = new byte[1024];
			int read;
			while (!isCancelled() && (read = i.read(buffer)) > 0)
			{
				totread += read;
				f.write(buffer, 0, read);
				if (totallen != 0)
				{
					int progress = (int)((long)totread * 1000 / totallen);
					if (progress != curprogress)
					{
						curprogress = progress;
						publishProgress(curprogress);
					}
				}
			}
			f.close();
			
			if (isCancelled())
			{
				outfile.delete();
				return null;
			}
			
			return outfile;
		}
		catch (IOException ex)
		{
			if (outfile != null && outfile.exists())
				outfile.delete();
			mError = ex.getLocalizedMessage();
		}
		return null;
	}
	
	@Override
	protected void onProgressUpdate(Integer... values)
	{
		if (!isCancelled() && values[0] >= 0 && values[0] <= 1000)
			mProgress.setProgress(values[0]);
	}
	
	@Override
	protected void onPostExecute(File result)
	{
		mProgress.hide();
		if (!isCancelled())
		{
			if (result == null || !result.exists())
			{
				if (mError != null)
				{
					AlertDialog.Builder alert = new AlertDialog.Builder(mContext);
					alert.setCancelable(true);
					alert.setMessage(mError);
					alert.setNeutralButton(android.R.string.ok, null);
					alert.create().show();
				}
			}
			else
			{
				result.renameTo(new File("/data/data/org.learnnavi.app/databases/", "dictionary.sqlite"));
				mContext.recheckDb();
			}
		}
	}

	@Override
	public void onClick(DialogInterface dialog, int which) {
		cancel(false);
	}
}
