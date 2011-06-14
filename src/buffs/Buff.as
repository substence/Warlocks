package buffs
{
	import com.mistermartinez.interfaces.IDestroyable;
	
	import flash.display.DisplayObject;
	import flash.events.EventDispatcher;

	public class Buff extends EventDispatcher implements IDestroyable
	{
		public var target:IBuffable;
		public var name:String;
		public var description:String;
		public var icon:DisplayObject;
		public var isDebuff:Boolean;
		public var charges:uint;
		
		public function Buff(isDebuff:Boolean = false)
		{
			name = "Buff";
			description = "This is a buff";
			charges = 0;
			this.isDebuff = isDebuff;
		}
		
		public function equip(target:IBuffable):void
		{
			this.target = target;
			onEquip();
		}
		
		public function unEquip():void
		{
			onUnEquip();
			this.target = null;
		}
		
		protected function onEquip():void
		{
			
		}
		
		protected function onUnEquip():void
		{
			
		}
		
		public function destroy():void
		{
			
		}
	}
}