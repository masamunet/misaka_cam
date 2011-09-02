package scenes {
	import jp.progression.commands.display.AddChildAt;
	import jp.progression.commands.display.RemoveChild;
	import jp.progression.scenes.SceneObject;
	
	import pages.IndexPage;

	
	/**
	 * ...
	 * @author ...
	 */
	public class IndexScene extends SceneObject {
		
		private var _page:IndexPage;
		/**
		 * 新しい IndexScene インスタンスを作成します。
		 */
		public function IndexScene() {
			// シーンタイトルを設定します。
			title = "misawa_face";
		}
		
		/**
		 * シーン移動時に目的地がシーンオブジェクト自身もしくは子階層だった場合に、階層が変更された直後に送出されます。
		 * このイベント処理の実行中には、ExecutorObject を使用した非同期処理が行えます。
		 */
		override protected function atSceneLoad():void {
			_page = new IndexPage();
			addCommand(
				new AddChildAt(container, _page, 10)
			);
		}
		
		/**
		 * シーン移動時に目的地がシーンオブジェクト自身もしくは親階層だった場合に、階層が変更される直前に送出されます。
		 * このイベント処理の実行中には、ExecutorObject を使用した非同期処理が行えます。
		 */
		override protected function atSceneUnload():void {
			addCommand(
				new RemoveChild(container, _page),
				function():void{
					_page = null;
				}
			);
		}
	}
}
