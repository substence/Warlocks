package terrains
{
	import com.mistermartinez.math.Vector2D;
	
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	
	public class GenericTerrainLayer implements ITerrainLayer
	{
		private var _maxDimensions:Vector2D;
		private var _graphic:Sprite;
		
		public function GenericTerrainLayer(dimensions:Vector2D)
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
			var radius:Number = Math.min(dimensions.x, dimensions.y) * .5;
			_graphic.graphics.clear();
			_graphic.graphics.beginFill(0xCCCCCC);
			_graphic.graphics.drawCircle( _maxDimensions.x * .5,  _maxDimensions.y * .5, radius);
		}
		
		public function update():void
		{
			
		}
		
		public function draw():void
		{
			
		}
	}
}