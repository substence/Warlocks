package components
{
	import com.mistermartinez.components.Component;
	import com.mistermartinez.entities.Entity;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	public class CProperty extends Component
	{
		public static const MODIFIED:String = "valueModified";
		public static const DECREASED:String = "valueDecreased";
		public static const INCREASED:String = "valueIncreased";
		public static const MINIMIZED:String = "valueMinimized";
		public static const MAXIMIZED:String = "valueMaximized";
		public var doesDispatchEvents:Boolean = true;
		protected var _maximum:Number = Number.MAX_VALUE;
		protected var _value:Number = _maximum;
		protected var _minimum:Number = 0;
		private var _previousValue:Number;
		private var _eventDispatcher:EventDispatcher;
		
		public function CProperty(maximum:Number = Number.MAX_VALUE, minimum:Number = 0, value:Number = -1)
		{
			_eventDispatcher = new EventDispatcher();
			_maximum = maximum;
			_minimum = minimum;
			if (value == -1)
				value = _maximum;
			_value = value;
		}
		
		public function get previousValue():Number
		{
			return _previousValue;
		}

		public function get eventDispatcher():EventDispatcher
		{
			return _eventDispatcher;
		}

		public function set value(value:Number):void
		{
			value = Math.max(_minimum, value);
			value = Math.min(_maximum, value);
			if (value == _value)
				return;
			_previousValue = _value;
			_value = value;
			dispatchEvent(new Event(MODIFIED)); 
			if (_value -_previousValue >= 0)
			{
				dispatchEvent(new Event(INCREASED));
				if (_value == _maximum)
					dispatchEvent(new Event(MAXIMIZED))
			}
			else
			{
				dispatchEvent(new Event(DECREASED));
				if (_value == _minimum)
					dispatchEvent(new Event(MINIMIZED));
			}
		}

		public function get value():Number
		{
			return _value;
		}
		
		public function get maxmimum():Number
		{
			return _maximum;
		}
		
		public function get minimum():Number
		{
			return _minimum;
		}
		
		public function modify(value:Number, source:Entity = null):Number
		{
			this.value += value;
			return this.value;
		}
		
		public function set(value:Number, source:Entity = null):Number
		{
			this.value = value;
			return this.value;
		}
		
		public function minimize(source:Entity = null):Number
		{
			return set(_minimum, source);
		}
		
		public function maximize(source:Entity = null):Number
		{
			return set(_maximum, source);
		}
		
		public function getValuePercentage():Number
		{
			return 1 - ((_maximum - _value) / (_maximum - _minimum));
		}
		
		public function setValuePercentage(percentage:Number):void
		{
			value = percentage * (_maximum - _minimum) + _minimum;
		}
		
		private function dispatchEvent(event:Event):void
		{
			if (!doesDispatchEvents)
				return;
			_eventDispatcher.dispatchEvent(event);
		}
	}
}