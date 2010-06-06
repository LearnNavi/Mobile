package org.learnnavi.app;

import android.graphics.Camera;
import android.graphics.Matrix;
import android.view.animation.Animation;
import android.view.animation.Transformation;

public class PageFlip3d extends Animation {
	private final float mFromDegrees;
	private final float mToDegrees;
	private final float mCenterX;
	private final float mCenterY;
	private final float mDepth;
	private int mScaleX;
	private int mScaleY;
	private Camera mCamera;

	public PageFlip3d(float fromDegrees, float toDegrees, float centerX,
			float centerY) {
		mFromDegrees = fromDegrees;
		mToDegrees = toDegrees;
		mCenterX = centerX;
		mCenterY = centerY;
		mDepth = 1.0f;
	}

	public PageFlip3d(float fromDegrees, float toDegrees, float centerX,
			float centerY, float depthZ) {
		mFromDegrees = fromDegrees;
		mToDegrees = toDegrees;
		mCenterX = centerX;
		mCenterY = centerY;
		mDepth = depthZ;
	}
	
	@Override
	public void initialize(int width, int height, int parentWidth,
			int parentHeight) {
		super.initialize(width, height, parentWidth, parentHeight);
		// Store the passed in dimensions and initialize the camera
		mCamera = new Camera();
		mScaleX = width;
		mScaleY = height;
	}

	@Override
	protected void applyTransformation(float interpolatedTime, Transformation t) {
		final float fromDegrees = mFromDegrees;
		float degrees = fromDegrees
				+ ((mToDegrees - fromDegrees) * interpolatedTime);

		// Scale the center by the size to get the pixel center
		final float centerX = mCenterX * mScaleX;
		final float centerY = mCenterY * mScaleY;
		final Camera camera = mCamera;

		final Matrix matrix = t.getMatrix();

		camera.save();

		// Use the camera to get the matrix rotation along the Y axis
		camera.rotateY(degrees);
		camera.getMatrix(matrix);

		camera.restore();

		// Apply matrix translation to the result to set the center.
		matrix.preTranslate(-centerX, -centerY);
		matrix.postTranslate(centerX, centerY);
		
		// Scale so the edge points JUST fit on screen
		float sidepoint = (mScaleX * (1.0f - mDepth)) / 2.0f;
		float[] points = new float[] { sidepoint, 0, sidepoint, mScaleY, mScaleX - sidepoint, 0, mScaleX - sidepoint, mScaleY };
		matrix.mapPoints(points);
		matrix.preScale(mDepth, 1.0f, centerX, centerY);
		if (points[1] < 0)
		{
			float scale = mScaleY / (points[3] - points[1]);
			matrix.postScale(scale / mDepth, scale, centerX, centerY);
		}
		else if (points[5] < 0)
		{
			float scale = mScaleY / (points[7] - points[5]);
			matrix.postScale(scale / mDepth, scale, centerX, centerY);
		}
		else
			matrix.postScale(1.0f / mDepth, 1.0f, centerX, centerY);
	}
}