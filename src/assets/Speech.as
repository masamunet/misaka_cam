package assets
{
	import flash.display.Bitmap;
	
	import jp.progression.casts.CastSprite;
	import jp.progression.commands.display.AddChild;
	import jp.progression.commands.display.RemoveAllChildren;
	
	import mx.controls.Image;
	
	public class Speech extends CastSprite
	{
		[Embed(source="/../png/speech0.png", mimeType="image/png")]
		private var Image0:Class;
		[Embed(source="/../png/speech1.png", mimeType="image/png")]
		private var Image1:Class;
		[Embed(source="/../png/speech2.png", mimeType="image/png")]
		private var Image2:Class;
		[Embed(source="/../png/speech3.png", mimeType="image/png")]
		private var Image3:Class;
		
		public function Speech(initObject:Object=null)
		{
			super(initObject);
		}


		protected override function atCastAdded():void
		{
			var images:Vector.<Bitmap> = new Vector.<Bitmap>();
			images.push(new Image0());
			images.push(new Image1());
			images.push(new Image2());
			images.push(new Image3());
			addCommand(
				new AddChild(this, images[int(Math.random() * images.length)])
			);
		}

		protected override function atCastRemoved():void
		{
			addCommand(
				new RemoveAllChildren(this)
			);
		}

	}
}