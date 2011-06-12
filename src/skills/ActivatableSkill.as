package skills
{
	import com.mistermartinez.utils.FrameTimer;
	
	import flash.events.Event;
	
	import flashx.textLayout.utils.CharacterUtil;
	
	import interfaces.ITimed;
	
	public class ActivatableSkill extends Skill implements IActivatable
	{
		public var hotKey:uint;
		protected var _rechargeTimer:FrameTimer;
		protected var _activationTimer:FrameTimer;
		
		public function ActivatableSkill(rechargeDuration:Number = 0, activationDuration:Number = 0)
		{
			_rechargeTimer = new FrameTimer();
			_rechargeTimer.addEventListener(FrameTimer.TIMER_COMPLETE, onRechargeTimerComplete);
			this.rechargeDuration = rechargeDuration;
			_activationTimer = new FrameTimer();
			_activationTimer.addEventListener(FrameTimer.TIMER_COMPLETE, onActivationTimerComplete);
			this.activationDuration = activationDuration;
		}
		
		public function get timer():FrameTimer
		{
			return _rechargeTimer;
		}
		
		public function get isActive():Boolean
		{
			return _activationTimer.isRunning;;
		}
		
		public function get isRecharging():Boolean
		{
			return _rechargeTimer.isRunning;
		}
		
		protected function set rechargeDuration(value:Number):void
		{
			_rechargeTimer.steps = value * Config.FRAME_RATE;
		}
		
		protected function set activationDuration(value:Number):void
		{
			_activationTimer.steps = value * Config.FRAME_RATE;
		}
		
		public function activate():Boolean
		{
			if (isActive || isRecharging || !warlock)
				return false;
			_activationTimer.reset();
			_activationTimer.start();
			dispatchEvent(new Event(Skill.ACTIVATE));
			onActivation();
			return true;
		}
		
		public function deactivate():void
		{
			_activationTimer.stop();
			startRecharge();
			dispatchEvent(new Event(Skill.DEACTIVATE));
			onDeactivation();
		}
		
		protected function startRecharge():void
		{
			_rechargeTimer.reset();
			_rechargeTimer.start();
		}
		
		protected function onActivationTimerComplete(event:Event):void
		{
			deactivate();
		}
		
		protected function onRechargeTimerComplete(event:Event):void
		{
			
		}
		
		protected function onActivation():void
		{
			
		}
		
		protected function onDeactivation():void
		{
			
		}
		
		override public function destroy():void
		{
			//deactivate();
			super.destroy();
			_rechargeTimer.stop();
		}
	}
}