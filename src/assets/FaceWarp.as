package assets
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BitmapDataChannel;
	import flash.display.BlendMode;
	import flash.display.GradientType;
	import flash.display.Sprite;
	import flash.filters.BevelFilter;
	import flash.filters.DisplacementMapFilter;
	import flash.filters.DisplacementMapFilterMode;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	
	import jp.progression.casts.CastBitmap;
	
	import org.osmf.layout.AbsoluteLayoutFacet;
	
	import spark.primitives.Rect;
	
	public class FaceWarp extends CastBitmap
	{
		private static const _DISP_WIDTH:int = 50;
		private static const _DISP_HEIGHT:int = 50;
		private static const _ZERO_POINT:Point = new Point(0, 0);
		private var _targetBitmapData:BitmapData;
		
		private var _grad:Sprite;
		private var _gradBitmap:BitmapData;
		/*
		[Embed(source="/../png/disp4.png",mimeType="image/png")]
		private var LoadImage:Class;
		*/
		private var _fil:DisplacementMapFilter;
		
		public function FaceWarp(targetBitmapData:BitmapData, bitmapData:BitmapData=null, pixelSnapping:String="auto", smoothing:Boolean=false, initObject:Object=null)
		{
			_targetBitmapData = targetBitmapData;
			super(bitmapData, pixelSnapping, smoothing, initObject);
		}
		
		public function drawFace(rect:Rectangle):void
		{
			var pixels:ByteArray = _targetBitmapData.getPixels(rect);
			var sampleBitmapData:BitmapData = new BitmapData(rect.width, rect.height);
			var horz:int = rect.height;
			var vart:int = rect.width;
			pixels.position = 0;
			for(var h:int = 0; h < horz; h++){
				for(var v:int = 0; v < vart; v++){
					sampleBitmapData.setPixel(v, h, pixels.readUnsignedInt());
				}
			}
			
			var sX:Number = rect.width / _gradBitmap.width;
			var sY:Number = rect.height / _gradBitmap.height;
			var mat:Matrix = new Matrix();
			mat.scale(sX, sY);
			var disp:BitmapData = new BitmapData(rect.width, rect.height);
			disp.draw(_gradBitmap, mat);
			
			if(_fil.mapBitmap){
				_fil.mapBitmap.dispose();
			}
			_fil.mapBitmap = disp;
			
			sampleBitmapData.applyFilter(
				sampleBitmapData,
				new Rectangle(0, 0, sampleBitmapData.width, sampleBitmapData.height),
				_ZERO_POINT,
				_fil
				);
			if(bitmapData){
				bitmapData.dispose();
			}
			bitmapData = sampleBitmapData;
//			bitmapData = disp;
		}
		
		public function clearFace():void
		{
			bitmapData.dispose();
		}


		protected override function atCastAdded():void
		{
			
			var gWidth:int = 50;
			var gHeight:int = 50;
			var base:Sprite = new Sprite();
			base.graphics.beginFill(0x008080);
			base.graphics.drawRect(0, 0, gWidth, gHeight);
			base.graphics.endFill();
			
			var spX:Sprite = new Sprite();
			var mat:Matrix = new Matrix();
			mat.createGradientBox(gWidth, gHeight, 0, 0, 0);
			spX.graphics.beginGradientFill(
				GradientType.LINEAR,
				[0x008000, 0x00000, 0x008000, 0x00FF00, 0x008000],
				[1, 1, 1, 1, 1],
				[0, 1, 127, 254, 255],
				mat
			);
			spX.graphics.drawRect(0, 0, gWidth, gHeight);
			spX.graphics.endFill();
			
			var spY:Sprite = new Sprite();
			mat.createGradientBox(gWidth, gHeight, Math.PI/180*90, 0, 0);
			spY.graphics.beginGradientFill(
				GradientType.LINEAR,
				[0x000080, 0x000000, 0x000080, 0x0000FF, 0x000080],
				[1, 1, 1, 1, 1],
				[0, 1, 127, 254, 255],
				mat
			);
			spY.graphics.drawRect(0, 0, gWidth, gHeight);
			spY.graphics.endFill();
			
			spY.blendMode = BlendMode.ADD;
			_grad = new Sprite();
			
			var maskSp:Sprite = new Sprite();
			maskSp.cacheAsBitmap = true;
			mat.createGradientBox(gWidth, gHeight, 0, 0, 0);
			maskSp.graphics.beginGradientFill(
				GradientType.RADIAL,
				[0xFFFFFF, 0xFFFFFF],
				[1, 0],
				[200, 254],
				mat
			);
			maskSp.graphics.drawRect(0, 0, gWidth, gHeight);
			maskSp.graphics.endFill();
			
			var spContainer:Sprite = new Sprite();
			spContainer.cacheAsBitmap = true;
			spContainer.addChild(spX);
			spContainer.addChild(spY);
			spContainer.mask = maskSp;
			
			
			
			_grad.addChild(base);
			_grad.addChild(spContainer);
			_grad.addChild(maskSp);
			
			
			_gradBitmap = new BitmapData(gWidth, gHeight);
			_gradBitmap.draw(_grad);
			
			/*
			var image:Bitmap = new LoadImage();
			_gradBitmap = image.bitmapData;
			*/
			
			_fil = new DisplacementMapFilter(
				null,
				_ZERO_POINT,
				BitmapDataChannel.GREEN,
				BitmapDataChannel.BLUE,
				20,
				10,
				DisplacementMapFilterMode.CLAMP
			);
		}

		protected override function atCastRemoved():void
		{
			_targetBitmapData = null;
			
			_fil = null;
			
			_grad = null;
			_gradBitmap.dispose();
			_gradBitmap = null;
		}

	}
}