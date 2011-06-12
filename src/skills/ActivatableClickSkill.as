package skills
{
	import com.mistermartinez.interfaces.ISpatial;
	import com.mistermartinez.math.Vector2D;
	import com.mistermartinez.utils.DummySpatial;
	import com.mistermartinez.utils.InputHandler;
	
	import flash.events.MouseEvent;

	public class ActivatableClickSkill extends ActivatableSkill
	{
		public function ActivatableClickSkill(rechargeDuration:Number = 1)
		{
			super(rechargeDuration);
		}
		
		override protected function onActivation():void
		{
			if (Config.HAS_EASY_ACTIVATION)
			{
				onClick();
				return;
			}
			warlock.user.addEventListener(MouseEvent.MOUSE_UP, onClick);
		}
		
		override protected function onDeactivation():void
		{
			removeOnClickListeer();
		}
		
		private function removeOnClickListeer():void
		{
			if (!Config.HAS_EASY_ACTIVATION && warlock.user.hasEventListener(MouseEvent.MOUSE_UP))
				warlock.user.removeEventListener(MouseEvent.MOUSE_UP, onClick);
		}
		
		protected function onClick(event:MouseEvent = null):void
		{
			removeOnClickListeer();
			var mousePosition:Vector2D = InputHandler.instance.mousePosition;
			var warlockPosition:Vector2D = warlock.position;
			mousePosition.subtract(warlockPosition);
			mousePosition.truncate(range);
			mousePosition.add(warlockPosition);
			onClickActivation(new DummySpatial(mousePosition.x, mousePosition.y));
		}
		
		protected function onClickActivation(target:ISpatial):void
		{
			deactivate();
		}
	}
}