package buffs
{
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	
	import interfaces.IOwned;
	
	import players.Warlock;
	
	import users.User;

	public class ChannelingBuff extends TimedBuff
	{
		public static const INTERUPTED:String = "channelBuffInterupted";
		
		public function ChannelingBuff(duration:uint, isDebuff:Boolean=false)
		{
			super(duration, isDebuff);
		}
		
		override protected function onStart():void
		{
			if (target is IOwned)
				IOwned(target).owner.addEventListener(User.INPUT_ACTION, actionInputed);
		}
		
		private function actionInputed(event:Event):void
		{
			dispatchEvent(new Event(INTERUPTED));
		}
		
		override protected function onEnd():void
		{
			if (target is IOwned)
				IOwned(target).owner.removeEventListener(User.INPUT_ACTION, actionInputed);
		}
	}
}