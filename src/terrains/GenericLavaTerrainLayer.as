package terrains
{
	import com.mistermartinez.math.Vector2D;
	
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	
	public class GenericLavaTerrainLayer implements ITerrainLayer
	{
		private var _maxDimensions:Vector2D;
		private var _graphic:Sprite;
		
		public function GenericLavaTerrainLayer(dimensions:Vector2D)
		{
			_graphic = new Sprite();
			_maxDimensions = dimensions;
			resize(_maxDimensions);
		}
		
		public function get maxDimensions():Vector2D
		{
			return _maxDimensions;
		}
		
		public function get graphic():DisplayObject
		{
			return _graphic;
		}
		
		public function set graphic(value:DisplayObject):void
		{
			
		}
		
		public function resize(dimensions:Vector2D):void
		{
			_graphic.graphics.clear();
			_graphic.graphics.beginFill(0xFF0000);
			_graphic.graphics.drawRect(0, 0, dimensions.x, dimensions.y);
		}
		
		public function update():void
		{
			
		}
		
		public function draw():void
		{
			
		}
	}
}