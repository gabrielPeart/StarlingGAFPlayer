/**
 * Created by Nazar on 05.03.14.
 */
package com.catalystapps.gaf.display
{
	import flash.utils.getQualifiedClassName;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;

	import starling.textures.Texture;

	/**
	 * @private
	 */
	public class GAFScale9Texture implements IGAFTexture
	{
		//--------------------------------------------------------------------------
		//
		//  PUBLIC VARIABLES
		//
		//--------------------------------------------------------------------------

		//--------------------------------------------------------------------------
		//
		//  PRIVATE VARIABLES
		//
		//--------------------------------------------------------------------------

		/**
		 * @private
		 */
		private static const DIMENSIONS_ERROR: String = "The width and height of the scale9Grid must be greater than zero.";
		/**
		 * @private
		 */
		private static const HELPER_RECTANGLE:Rectangle = new Rectangle();
		
		private var _id: String;
		private var _texture: Texture;
		private var _pivotMatrix: Matrix;
		private var _scale9Grid: Rectangle;

		private var _topLeft: Texture;
		private var _topCenter: Texture;
		private var _topRight: Texture;
		private var _middleLeft: Texture;
		private var _middleCenter: Texture;
		private var _middleRight: Texture;
		private var _bottomLeft: Texture;
		private var _bottomCenter: Texture;
		private var _bottomRight: Texture;

		//--------------------------------------------------------------------------
		//
		//  CONSTRUCTOR
		//
		//--------------------------------------------------------------------------

		public function GAFScale9Texture(id: String, texture: Texture, pivotMatrix: Matrix, scale9Grid: Rectangle)
		{
			this._id = id;
			this._pivotMatrix = pivotMatrix;

			if (scale9Grid.width <= 0 || scale9Grid.height <= 0)
			{
				throw new ArgumentError(DIMENSIONS_ERROR);
			}
			this._texture = texture;
			this._scale9Grid = scale9Grid;
			this.initialize();
		}

		//--------------------------------------------------------------------------
		//
		//  PUBLIC METHODS
		//
		//--------------------------------------------------------------------------
		public function copyFrom(newTexture: IGAFTexture): void
		{
			if (newTexture is GAFScale9Texture)
			{
				this._id = newTexture.id;
				this._texture = newTexture.texture;
				this._pivotMatrix.copyFrom(newTexture.pivotMatrix);
				this._scale9Grid.copyFrom((newTexture as GAFScale9Texture).scale9Grid);
				this._topLeft = (newTexture as GAFScale9Texture).topLeft;
				this._topCenter = (newTexture as GAFScale9Texture).topCenter;
				this._topRight = (newTexture as GAFScale9Texture).topRight;
				this._middleLeft = (newTexture as GAFScale9Texture).middleLeft;
				this._middleCenter = (newTexture as GAFScale9Texture).middleCenter;
				this._middleRight = (newTexture as GAFScale9Texture).middleRight;
				this._bottomLeft = (newTexture as GAFScale9Texture).bottomLeft;
				this._bottomCenter = (newTexture as GAFScale9Texture).bottomCenter;
				this._bottomRight = (newTexture as GAFScale9Texture).bottomRight;
			}
			else
			{
				throw new Error("Incompatiable types GAFScale9Texture and "+getQualifiedClassName(newTexture));
			}
		}
		//--------------------------------------------------------------------------
		//
		//  PRIVATE METHODS
		//
		//--------------------------------------------------------------------------

		private function initialize(): void
		{
			var textureFrame: Rectangle = this._texture.frame;
			if(!textureFrame)
			{
				textureFrame = HELPER_RECTANGLE;
				textureFrame.setTo(0, 0, this._texture.width, this._texture.height);
			}
			var leftWidth: Number = this._scale9Grid.left;
			var centerWidth: Number = this._scale9Grid.width;
			var rightWidth: Number = textureFrame.width - this._scale9Grid.width - this._scale9Grid.x;
			var topHeight: Number = this._scale9Grid.y;
			var middleHeight: Number = this._scale9Grid.height;
			var bottomHeight: Number = textureFrame.height - this._scale9Grid.height - this._scale9Grid.y;

			var regionLeftWidth: Number = leftWidth + textureFrame.x;
			var regionTopHeight: Number = topHeight + textureFrame.y;
			var regionRightWidth: Number = rightWidth - (textureFrame.width - this._texture.width) - textureFrame.x;
			var regionBottomHeight: Number = bottomHeight - (textureFrame.height - this._texture.height) - textureFrame.y;

			var hasLeftFrame: Boolean = regionLeftWidth != leftWidth;
			var hasTopFrame: Boolean = regionTopHeight != topHeight;
			var hasRightFrame: Boolean = regionRightWidth != rightWidth;
			var hasBottomFrame: Boolean = regionBottomHeight != bottomHeight;

			var topLeftRegion: Rectangle = new Rectangle(0, 0, regionLeftWidth, regionTopHeight);
			var topLeftFrame: Rectangle = (hasLeftFrame || hasTopFrame) ? new Rectangle(textureFrame.x, textureFrame.y, leftWidth, topHeight) : null;
			this._topLeft = Texture.fromTexture(this._texture, topLeftRegion, topLeftFrame);

			var topCenterRegion: Rectangle = new Rectangle(regionLeftWidth, 0, centerWidth, regionTopHeight);
			var topCenterFrame: Rectangle = hasTopFrame ? new Rectangle(0, textureFrame.y, centerWidth, topHeight) : null;
			this._topCenter = Texture.fromTexture(this._texture, topCenterRegion, topCenterFrame);

			var topRightRegion: Rectangle = new Rectangle(regionLeftWidth + centerWidth, 0, regionRightWidth, regionTopHeight);
			var topRightFrame: Rectangle = (hasTopFrame || hasRightFrame) ? new Rectangle(0, textureFrame.y, rightWidth, topHeight) : null;
			this._topRight = Texture.fromTexture(this._texture, topRightRegion, topRightFrame);

			var middleLeftRegion: Rectangle = new Rectangle(0, regionTopHeight, regionLeftWidth, middleHeight);
			var middleLeftFrame: Rectangle = hasLeftFrame ? new Rectangle(textureFrame.x, 0, leftWidth, middleHeight) : null;
			this._middleLeft = Texture.fromTexture(this._texture, middleLeftRegion, middleLeftFrame);

			var middleCenterRegion: Rectangle = new Rectangle(regionLeftWidth, regionTopHeight, centerWidth, middleHeight);
			this._middleCenter = Texture.fromTexture(this._texture, middleCenterRegion);

			var middleRightRegion: Rectangle = new Rectangle(regionLeftWidth + centerWidth, regionTopHeight, regionRightWidth, middleHeight);
			var middleRightFrame: Rectangle = hasRightFrame ? new Rectangle(0, 0, rightWidth, middleHeight) : null;
			this._middleRight = Texture.fromTexture(this._texture, middleRightRegion, middleRightFrame);

			var bottomLeftRegion: Rectangle = new Rectangle(0, regionTopHeight + middleHeight, regionLeftWidth, regionBottomHeight);
			var bottomLeftFrame: Rectangle = (hasLeftFrame || hasBottomFrame) ? new Rectangle(textureFrame.x, 0, leftWidth, bottomHeight) : null;
			this._bottomLeft = Texture.fromTexture(this._texture, bottomLeftRegion, bottomLeftFrame);

			var bottomCenterRegion: Rectangle = new Rectangle(regionLeftWidth, regionTopHeight + middleHeight, centerWidth, regionBottomHeight);
			var bottomCenterFrame: Rectangle = hasBottomFrame ? new Rectangle(0, 0, centerWidth, bottomHeight) : null;
			this._bottomCenter = Texture.fromTexture(this._texture, bottomCenterRegion, bottomCenterFrame);

			var bottomRightRegion: Rectangle = new Rectangle(regionLeftWidth + centerWidth, regionTopHeight + middleHeight, regionRightWidth, regionBottomHeight);
			var bottomRightFrame: Rectangle = (hasBottomFrame || hasRightFrame) ? new Rectangle(0, 0, rightWidth, bottomHeight) : null;
			this._bottomRight = Texture.fromTexture(this._texture, bottomRightRegion, bottomRightFrame);
		}

		//--------------------------------------------------------------------------
		//
		// OVERRIDDEN METHODS
		//
		//--------------------------------------------------------------------------

		//--------------------------------------------------------------------------
		//
		//  EVENT HANDLERS
		//
		//--------------------------------------------------------------------------

		//--------------------------------------------------------------------------
		//
		//  GETTERS AND SETTERS
		//
		//--------------------------------------------------------------------------

		public function get id(): String
		{
			return _id;
		}

		public function get pivotMatrix(): Matrix
		{
			return _pivotMatrix;
		}

		public function get texture(): Texture
		{
			return _texture;
		}

		public function get scale9Grid(): Rectangle
		{
			return _scale9Grid;
		}

		public function get topLeft(): Texture
		{
			return _topLeft;
		}

		public function get topCenter(): Texture
		{
			return _topCenter;
		}

		public function get topRight(): Texture
		{
			return _topRight;
		}

		public function get middleLeft(): Texture
		{
			return _middleLeft;
		}

		public function get middleCenter(): Texture
		{
			return _middleCenter;
		}

		public function get middleRight(): Texture
		{
			return _middleRight;
		}

		public function get bottomLeft(): Texture
		{
			return _bottomLeft;
		}

		public function get bottomCenter(): Texture
		{
			return _bottomCenter;
		}

		public function get bottomRight(): Texture
		{
			return _bottomRight;
		}

		public function clone(): IGAFTexture
		{
			return new GAFScale9Texture(_id, _texture, _pivotMatrix.clone(), _scale9Grid);
		}

		//--------------------------------------------------------------------------
		//
		//  STATIC METHODS
		//
		//--------------------------------------------------------------------------
	}
}