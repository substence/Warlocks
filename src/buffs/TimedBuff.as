package buffs
{
	import com.mistermartinez.utils.FrameTimer;
	
	import flash.events.Event;
	
	import interfaces.ITimed;

	public class TimedBuff extends Buff implements ITimed
	{
		private var _timer:FrameTimer;
		
		public function TimedBuff(duration:uint, isDebuff:Boolean = false)
		{
			super(isDebuff);
			_timer = new FrameTimer();
			_timer.addEventListener(FrameTimer.TIMER_COMPLETE, onTimerComplete);
			this.duration = duration;
		}
		
		public function get timer():FrameTimer
		{
			return _timer;
		}

		public function set duration(value:uint):void
		{
			_timer.steps = value * Config.FRAME_RATE;
		}
		
		override protected function onEquip():void
		{
			_timer.start();
			onStart();
		}
		
		override protected function onUnEquip():void
		{
			_timer.stop();
			onComplete();
		}
		
		private function onTimerComplete(event:Event):void
		{
			target.removeBuff(this);
		}
		
		protected function onStart():void
		{
			
		}
		
		protected function onComplete():void
		{
			
		}
		
		override public function destroy():void
		{
			super.destroy();
			_timer.stop();
			_timer.removeEventListener(FrameTimer.TIMER_COMPLETE, onTimerComplete);
			_timer = null;
		}
	}
}