package components
{
	import interfaces.IPropertyModifier;

	public class CModifiableProperty extends CProperty
	{
		private var _modifiers:Vector.<IPropertyModifier>;

		public function CModifiableProperty(maximum:Number=Number.MAX_VALUE, minimum:Number=0, value:Number=-1)
		{
			super(maximum, minimum, value);
			_modifiers = new Vector.<IPropertyModifier>();
		}
		
		override public function get value():Number
		{
			var tempValue:Number = _value;
			for (var i:int = 0; i < _modifiers.length; i++)
			{
				tempValue = _modifiers[i].modifier(tempValue);
			}
			return tempValue;
		}
		
		public function get modifiers():Vector.<IPropertyModifier>
		{
			return _modifiers;
		}
		
		public function addModifier(modifier:IPropertyModifier, priority:Number = 0):void
		{
			_modifiers.push(modifier);
		}
		
		public function removeModifier(modifier:IPropertyModifier):void
		{
			var index:int = _modifiers.indexOf(modifier);
			if (index >= 0)
				_modifiers.splice(index, 1);
		}
		
		public function getModifierByType(type:Class):IPropertyModifier
		{
			for (var i:int = 0; i < _modifiers.length; i++)
			{
				if (_modifiers[i] is type)
					return _modifiers[i];
			}
			return null;
		}
	}
}