package assets
{
	import flash.display.Sprite;
	import flash.events.StatusEvent;
	import flash.media.Camera;
	import flash.media.Video;
	
	import jp.progression.casts.CastSprite;
	import jp.progression.commands.display.AddChild;
	import jp.progression.commands.display.RemoveAllChildren;
	
	public class UserCamera extends CastSprite
	{
		private var _camera:Camera;
		private var _video:Video;
		private var _container:Sprite;
		
		private var _detector:Detector;
		public function UserCamera(initObject:Object=null)
		{
			super(initObject);
		}


		protected override function atCastAdded():void
		{
			_camera = Camera.getCamera();
			if(!(!_camera)){
				_camera.addEventListener(StatusEvent.STATUS, _onCameraStatusHandler);
				_video = new Video(_camera.width, _camera.height);
				_video.attachCamera(_camera);
//				_video.scaleX *= -1;
//				_video.x = _video.width;
				_container = new Sprite();
				_detector = new Detector(_video);
				addCommand(
					new AddChild(_container, _video),
					new AddChild(this, _container),
					new AddChild(this, _detector)
				);
			}
		}

		private function _onCameraStatusHandler(event:StatusEvent):void
		{
			
		}

		protected override function atCastRemoved():void
		{
			addCommand(
				new RemoveAllChildren(this),
				function():void{
					if(!(!_camera)){
						_camera.removeEventListener(StatusEvent.STATUS, _onCameraStatusHandler);
						_camera = null;
					}
					if(!(!_video.parent)){
						_video.parent.removeChild(_video);
					}
					_video = null;
					_container = null;
					_detector = null;
				}
			);
		}

	}
}