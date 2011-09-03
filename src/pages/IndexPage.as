package pages
{
	import assets.Speech;
	import assets.UserCamera;
	
	import jp.progression.casts.CastSprite;
	import jp.progression.commands.display.AddChild;
	import jp.progression.commands.display.RemoveAllChildren;
	
	public class IndexPage extends CastSprite
	{
		private var _camera:UserCamera;
		private var _speech:Speech;
		public function IndexPage(initObject:Object=null)
		{
			super(initObject);
		}


		protected override function atCastAdded():void
		{
			_camera = new UserCamera();
			_speech = new Speech();
			addCommand(
				new AddChild(this, _camera),
				function():void{
					_camera.height = stage.stageHeight;
					_camera.scaleX = _camera.scaleY;
					_camera.x = (stage.stageWidth - _camera.width) * 0.5;
					
					_camera.scaleX *= -1;
					_camera.x += _camera.width;
				},
				new AddChild(this, _speech)
			);
		}

		protected override function atCastRemoved():void
		{
			addCommand(
				new RemoveAllChildren(this),
				function():void{
					_camera = null;
				}
			);
		}

	}
}