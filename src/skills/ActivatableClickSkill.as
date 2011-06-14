package skills
{
	import com.mistermartinez.interfaces.ISpatial;
	import com.mistermartinez.math.Vector2D;
	import com.mistermartinez.utils.DummySpatial;
	import com.mistermartinez.utils.InputHandler;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mouse.MouseView;

	public class ActivatableClickSkill extends ActivatableSkill
	{
		protected var _doesQuickActivate:Boolean;
		protected var _isClickMode:Boolean;

		public function ActivatableClickSkill(rechargeDuration:Number = 1)
		{
			super(rechargeDuration);
			_doesQuickActivate = Config.HAS_EASY_ACTIVATION;
		}
		
		override protected function onActivation():void
		{
			if (_isClickMode)//isActive)
			{
				secondaryActivation();
			}
			else
			{
				MouseView.changeMouseCursor(MouseView.ATTACK);
				_isClickMode = true;
				if (_doesQuickActivate)
				{
					secondaryActivation();
					deactivate();
				}
				else
				{
					warlock.user.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
				}
			}
		}
		
		private function onMouseUp(event:MouseEvent):void
		{
			activate();
		}
		
		override protected function onDeactivation():void
		{
			_isClickMode = false;
			MouseView.changeMouseCursor(MouseView.DEFAULT);
			startRecharge();
			if (!_doesQuickActivate)
				warlock.user.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		}
		
		protected function secondaryActivation(event:MouseEvent = null):void
		{
			var mousePosition:Vector2D = InputHandler.instance.mousePosition;
			var warlockPosition:Vector2D = warlock.position;
			mousePosition.subtract(warlockPosition);
			mousePosition.truncate(range);
			mousePosition.add(warlockPosition);
			onSecondaryActivation(new DummySpatial(mousePosition.x, mousePosition.y));
			startRecharge();
		}
		
		override protected function canActivate():Boolean
		{
			return !isRecharging && warlock;
		}
		
		protected function onSecondaryActivation(target:ISpatial):void
		{
			
		}
	}
}