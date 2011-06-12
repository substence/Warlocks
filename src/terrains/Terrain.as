package terrains
{
	import com.mistermartinez.interfaces.IDestroyable;
	import com.mistermartinez.interfaces.IDrawable;
	import com.mistermartinez.interfaces.IUpdatable;
	import com.mistermartinez.math.Vector2D;
	import com.mistermartinez.utils.FrameTimer;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;

	public class Terrain implements IDrawable, IUpdatable, IDestroyable
	{
		private const _RESIZE_INTERVAL:Number = 1;
		public var duration:uint;
		public var activeLayer:ITerrainLayer;
		private var _timer:FrameTimer;
		private var _layers:Vector.<ITerrainLayer>;
		private var _graphic:Sprite;
		
		public function Terrain(duration:uint)
		{
			this.duration = duration;
			_graphic = new Sprite();
			_timer = new FrameTimer();
			_timer.cycles = duration * Config.FRAME_RATE;
			_timer.steps = 1;
			_timer.addEventListener(FrameTimer.CYCLE_COMPLETE, resizeTerrain);
			_timer.addEventListener(FrameTimer.TIMER_COMPLETE, onTimerComplete);
			_timer.start();
			_layers = new Vector.<ITerrainLayer>();
		}
		
		public function get graphic():DisplayObject
		{
			return _graphic;
		}

		public function set graphic(value:DisplayObject):void
		{
		}

		public function addLayer(layer:ITerrainLayer):void
		{
			_layers.push(layer);
			_graphic.addChild(layer.graphic);
		}
		
		private function onTimerComplete(event:Event):void
		{
			
		}
		
		private function resizeTerrain(event:Event):void
		{
			var percentComplete:Number = _timer.percentComplete;
			var dimensions:Vector2D = activeLayer.maxDimensions.clone().multiply(1 - percentComplete);
			activeLayer.resize(dimensions);
		}
		
		public function draw():void
		{
			
		}
		
		public function update():void
		{
			for (var i:int = 0; i < _layers.length; i++) 
			{
				_layers[i].update();
			}
		}
		
		public function destroy():void
		{
			_timer.stop();
			_timer.removeEventListener(FrameTimer.CYCLE_COMPLETE, resizeTerrain);
			_timer.removeEventListener(FrameTimer.TIMER_COMPLETE, onTimerComplete);
		}
	}
}