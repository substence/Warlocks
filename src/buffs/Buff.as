package buffs
{
	import com.mistermartinez.interfaces.IDestroyable;

	public class Buff implements IDestroyable
	{
		public var target:IBuffable;
		public var name:String;
		public var description:String;
		public var isDebuff:Boolean;
		
		public function Buff(isDebuff:Boolean = false)
		{
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