package buffs
{
	import com.mistermartinez.utils.FrameTimer;
	import com.mistermartinez.utils.UpdateHandler;
	
	import flash.events.Event;

	public class TickedBuff extends TimedBuff
	{
		protected var _tickTimer:FrameTimer;
		
		public function TickedBuff(frequency:Number, ticks:uint = uint.MAX_VALUE, duration:Number = -1, isDebuff:Boolean=false)
		{
			super(duration == -1 ? GameDirector.MATCH_DURATION : duration, isDebuff);
			_tickTimer = new FrameTimer(UpdateHandler.TICKS_PER_SECOND * frequency, ticks);
			_tickTimer.addEventListener(FrameTimer.CYCLE_COMPLETE, onTick);
			_tickTimer.addEventListener(FrameTimer.TIMER_COMPLETE, onTicksComplete);
		}
		
		override protected function onEquip():void
		{
			super.onEquip();
			_tickTimer.start();
		}
		
		override protected function onUnEquip():void
		{
			super.onUnEquip();
			_tickTimer.stop();
		}
		
		protected function onTick(event:Event):void
		{
			
		}
		
		protected function onTicksComplete(event:Event):void
		{
			target.removeBuff(this);
		}
		
		override public function destroy():void
		{
			super.destroy();
			_tickTimer.stop();
			_tickTimer.removeEventListener(FrameTimer.CYCLE_COMPLETE, onTick);
			_tickTimer.removeEventListener(FrameTimer.TIMER_COMPLETE, onTicksComplete);
			_tickTimer = null;
		}
	}
}