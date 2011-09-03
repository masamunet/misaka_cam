package assets
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.media.Video;
	
	import jp.maaash.ObjectDetection.ObjectDetector;
	import jp.maaash.ObjectDetection.ObjectDetectorEvent;
	import jp.maaash.ObjectDetection.ObjectDetectorOptions;
	import jp.progression.casts.CastSprite;
	import jp.progression.commands.display.AddChild;
	import jp.progression.commands.display.RemoveAllChildren;
	
	public class Detector extends CastSprite
	{
		private static const _SCALE:Number = 1;
		private var _video:Video;
		private var _detector:ObjectDetector;
		private var _matrix:Matrix;
		
		private var _bitmapData:BitmapData;
		private var _bitmap:Bitmap;
		
		private var _rect:Rectangle;
		private var _faceWarp:FaceWarp;
		
		public function Detector(video:Video, initObject:Object=null)
		{
			_video = video;
			super(initObject);
		}


		protected override function atCastAdded():void
		{
			_matrix = new Matrix();
			_matrix.scale(_SCALE, _SCALE);
			
			_bitmapData = new BitmapData(_video.width * _SCALE, _video.height * _SCALE);
			_bitmap = new Bitmap(_bitmapData);
			
			_faceWarp = new FaceWarp(_bitmapData);
			
			_detector = new ObjectDetector();
			var options:ObjectDetectorOptions = new ObjectDetectorOptions();
			options.min_size = 40;
			_detector.options = options;
			_detector.addEventListener(ObjectDetectorEvent.DETECTION_COMPLETE, _onCompleteHandler);
			_detector.addEventListener(ObjectDetectorEvent.HAARCASCADES_LOAD_COMPLETE, _onLoadComplateHandler);
			_detector.loadHaarCascades("face.zip");
			addCommand(
				new AddChild(this, _faceWarp)
			);
		}

		private function _onLoadComplateHandler(event:ObjectDetectorEvent):void
		{
			_detector.removeEventListener(ObjectDetectorEvent.HAARCASCADES_LOAD_COMPLETE, _onLoadComplateHandler);
			addEventListener(Event.ENTER_FRAME, _onEnterFrameHandler);
		}
		
		private function _onEnterFrameHandler(e:Event):void
		{
			removeEventListener(Event.ENTER_FRAME, _onEnterFrameHandler);
			_bitmapData.draw(_video, _matrix);
			_detector.detect(_bitmap);
		}

		private function _onCompleteHandler(event:ObjectDetectorEvent):void
		{
			if(event.rects.length > 0){
				_rect = event.rects[0] as Rectangle;
				/*
				graphics.clear();
				graphics.lineStyle(0, 0xFFFF00);
				graphics.drawRect(
					_rect.x * _SCALE,
					_rect.y * _SCALE,
					_rect.width * _SCALE,
					_rect.height * _SCALE
				);
				*/
				
				var originalWidth:Number = _rect.width
				_rect.width *= 0.7;
				_rect.width = int(_rect.width);
				_rect.x += (originalWidth - _rect.width) * 0.5;
				
				/*
				var originalHeight:Number = _rect.height;
				_rect.height *= 0.8;
				_rect.y += (originalHeight - _rect.height) * 0.9;
				*/
				_faceWarp.drawFace(_rect);
				_faceWarp.x = _rect.x;
				_faceWarp.y = _rect.y;
				_faceWarp.visible = true;
			}else{
				graphics.clear();
				_faceWarp.visible = false;
			}
			addEventListener(Event.ENTER_FRAME, _onEnterFrameHandler);
		}

		protected override function atCastRemoved():void
		{
			addCommand(
				new RemoveAllChildren(this),
				function():void{
					removeEventListener(Event.ENTER_FRAME, _onEnterFrameHandler);
					_detector.removeEventListener(ObjectDetectorEvent.HAARCASCADES_LOAD_COMPLETE, _onLoadComplateHandler);
					_detector.removeEventListener(ObjectDetectorEvent.DETECTION_COMPLETE, _onCompleteHandler);
					_detector = null;
					_matrix = null;
					
					_bitmap = null;
					_bitmapData.dispose();
					_bitmapData = null;
					
					_faceWarp = null;
					
					_rect = null;
					
					graphics.clear();
				}
			);
		}

	}
}