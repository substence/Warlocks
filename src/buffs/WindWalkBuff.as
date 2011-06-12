package buffs
{
	import com.mistermartinez.interfaces.IDrawable;
	import com.mistermartinez.interfaces.IEntity;
	
	import components.CModifiableProperty;
	
	import properties.Properties;

	public class WindWalkBuff extends TimedBuff
	{
		private var _modifier:WindWalkMoveSpeedModifier;
		private var _moveSpeedAmount:Number;
		
		public function WindWalkBuff(duration:uint, moveSpeedAmount:Number)
		{
			super(duration);
			name = "Wind Walking";
			description = "Invisible to enemies and increased movement. Still able to be hit";
			_moveSpeedAmount = moveSpeedAmount;
		}
		
		override protected function onStart():void
		{
			setTargetAlpha(.33);
			var property:CModifiableProperty = getMoveSpeedProperty();
			if (property)
			{
				_modifier = new WindWalkMoveSpeedModifier(_moveSpeedAmount);
				property.addModifier(_modifier);
			}
		}
		
		override protected function onComplete():void
		{
			setTargetAlpha(1);
			var property:CModifiableProperty = getMoveSpeedProperty();
			if (property)
				property.removeModifier(_modifier);
		}
		
		private function getMoveSpeedProperty():CModifiableProperty
		{
			if(target is IEntity)
				return CModifiableProperty(IEntity(target).getComponentByName(Properties.MOVE_SPEED));
			return null;
		}
		
		private function setTargetAlpha(value:uint):void
		{
			if (target is IDrawable)
				IDrawable(target).graphic.alpha = value;
		}
	}
}
import interfaces.IPropertyModifier;

class WindWalkMoveSpeedModifier implements IPropertyModifier
{
	private var _modifyAmount:Number;
	
	public function WindWalkMoveSpeedModifier(modifyAmount:Number)
	{
		_modifyAmount = modifyAmount;
	}
	
	public function modifier(value:Number):Number
	{
		return value * _modifyAmount;
	}
}