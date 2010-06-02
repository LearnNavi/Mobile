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
	private int mScaleX;
	private int mScaleY;
	private Camera mCamera;

	// A little non-standard here...  Is there a way to get this definable in XML?
	public PageFlip3d(float fromDegrees, float toDegrees, float centerX,
			float centerY) {
		mFromDegrees = fromDegrees;
		mToDegrees = toDegrees;
		mCenterX = centerX;
		mCenterY = centerY;
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
	}
}