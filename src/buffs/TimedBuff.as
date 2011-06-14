package buffs
{
	import com.mistermartinez.utils.FrameTimer;
	
	import flash.events.Event;
	
	import interfaces.ITimed;

	public class TimedBuff extends Buff implements ITimed
	{
		public static const TIMER_COMPLETE:String = "buffTimerComplete";
		private var _timer:FrameTimer;
		
		public function TimedBuff(duration:uint = 0, isDebuff:Boolean = false)
		{
			super(isDebuff);
			timer = new FrameTimer();
			this.duration = duration;
		}
		
		public function set timer(value:FrameTimer):void
		{
			if (_timer)
				_timer.removeEventListener(FrameTimer.TIMER_COMPLETE, onTimerComplete);
			_timer = value;
			_timer.addEventListener(FrameTimer.TIMER_COMPLETE, onTimerComplete);
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
			onEnd();
		}
		
		private function onTimerComplete(event:Event):void
		{
			//target.removeBuff(this);
			dispatchEvent(new Event(TIMER_COMPLETE));
		}
		
		protected function onStart():void
		{
			
		}
		
		protected function onEnd():void
		{
			
		}
		
		override public function destroy():void
		{
			super.destroy();
			if (_timer)
			{
				_timer.stop();
				_timer.removeEventListener(FrameTimer.TIMER_COMPLETE, onTimerComplete);
				_timer = null;
			}
		}
	}
}