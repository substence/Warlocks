package mouse
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;
	import flash.ui.MouseCursorData;
	
	import mx.core.BitmapAsset;
	
	public class MouseView
	{
		[Embed(source="assets/cursors/target.gif")]
		private static const attackBitmap:Class;
		public static const ATTACK:String = "mouseCursorAttack";
		public static const DEFAULT:String = MouseCursor.ARROW;
		
		public function MouseView()
		{
			
		}
		
		public static function init():void
		{
			if (!Mouse.supportsNativeCursor)
				return;
			addMouseCursorByType(ATTACK, attackBitmap);
			
		}
		
		public static function addMouseCursorByType(name:String, bitmapClass:Class):void
		{
			var bitmap:BitmapAsset = (new attackBitmap()) as BitmapAsset;
			var bitmapData:BitmapData = new BitmapData(bitmap.width, bitmap.height);
			bitmapData.draw(bitmap);
			var cursorData:MouseCursorData = new MouseCursorData();
			cursorData.data = Vector.<BitmapData>([new targetCursor()]);
			cursorData.hotSpot = new Point(bitmap.width * .5, bitmap.height * .5);
			addMouseCursor(name, cursorData);
		}
		
		public static function addMouseCursor(name:String, cursorData:MouseCursorData):void
		{
			Mouse.registerCursor(name, cursorData);
		}
		
		public static function changeMouseCursor(name:String):void
		{
			if (!Mouse.supportsNativeCursor)
				return;
			Mouse.cursor = name;
		}
	}
}