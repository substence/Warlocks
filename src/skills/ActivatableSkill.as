package skills
{
	import com.mistermartinez.utils.FrameTimer;
	
	import flash.events.Event;
	
	import flashx.textLayout.utils.CharacterUtil;
	
	import interfaces.ITimed;
	
	public class ActivatableSkill extends Skill implements IActivatable
	{
		public static const DEACTIVATE:String = "skillDeactivated";
		public static const ACTIVATE:String = "skillActivated";
		public static const CANCEL:String = "skillCanceled";
		public var hotKey:uint;
		protected var _canCancel:Boolean;
		protected var _rechargeTimer:FrameTimer;
		protected var _activationTimer:FrameTimer;
		
		public function ActivatableSkill(rechargeDuration:Number = 0, activationDuration:Number = 0)
		{
			_canCancel = true;
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
			onActivateAttempt();
			if (!canActivate())
				return false;
			_activationTimer.reset();
			_activationTimer.start();
			dispatchEvent(new Event(ACTIVATE));
			onActivation();
			return true;
		}
		
		protected function canActivate():Boolean
		{
			return !(isActive || isRecharging || !warlock);
		}
		
		protected function onActivateAttempt():void
		{
			
		}
		
		public function cancel():Boolean
		{
			if (isActive && _canCancel)
			{
				dispatchEvent(new Event(CANCEL));
				onCancel();
				deactivate();
				return true;
			}
			return false;
		}
		
		public function deactivate():void
		{
			_activationTimer.stop();
			onDeactivation();
			dispatchEvent(new Event(DEACTIVATE));
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
		
		
		protected virtual function onCancel():void
		{
			
		}
		
		protected virtual function onActivation():void
		{
			
		}
		
		protected virtual function onDeactivation():void
		{
			startRecharge();
		}
		
		override public function destroy():void
		{
			//deactivate();
			super.destroy();
			_rechargeTimer.stop();
		}
	}
}