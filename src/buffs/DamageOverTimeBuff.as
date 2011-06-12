package buffs
{
	import com.mistermartinez.interfaces.IEntity;
	
	import components.CProperty;
	
	import flash.events.Event;
	
	import properties.Properties;

	public class DamageOverTimeBuff extends TickedBuff
	{
		protected var _damage:Number;
		
		public function DamageOverTimeBuff(frequency:Number, damage:Number, ticks:uint = uint.MAX_VALUE, duration:Number=GameDirector.MATCH_DURATION)
		{
			super(frequency, ticks, duration, true);
			_damage = damage;
		}
		
		override protected function onTick(event:Event):void
		{
			if (target is IEntity)
			{
				var healthComponent:CProperty = CProperty(IEntity(target).getComponentByName(Properties.HEALTH));
				if (healthComponent)
					healthComponent.modify(-_damage);
			}
		}
	}
}