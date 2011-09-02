package pages
{
	import assets.UserCamera;
	
	import jp.progression.casts.CastSprite;
	import jp.progression.commands.display.AddChild;
	import jp.progression.commands.display.RemoveAllChildren;
	
	public class IndexPage extends CastSprite
	{
		private var _camera:UserCamera;
		public function IndexPage(initObject:Object=null)
		{
			super(initObject);
		}


		protected override function atCastAdded():void
		{
			_camera = new UserCamera();
			addCommand(
				new AddChild(this, _camera),
				function():void{
					_camera.width = stage.stageWidth;
					_camera.scaleY = _camera.scaleX;
				}
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