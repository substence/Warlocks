package skills
{
	import com.mistermartinez.interfaces.IDestroyable;
	import com.mistermartinez.interfaces.IUpdatable;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import flashx.textLayout.elements.InlineGraphicElement;
	
	import players.Warlock;

	public class Skill extends EventDispatcher implements IUpdatable, IDestroyable
	{
		public static const DEACTIVATE:String = "skillDeactivated";
		public static const ACTIVATE:String = "skillActivated";
		public static const MAX_LEVEL:uint = 6;
		public static const LEVEL_CHANGED:String = "skillLevelChanged";
		public var name:String;
		public var tags:Vector.<String>;
		public var icon:DisplayObject;
		public var range:Number;
		public var desription:String;
		public var warlock:Warlock;
		protected var _level:int;
		
		public function Skill()
		{
			_level = 1;
			name = "Name";
			tags = new Vector.<String>();
			icon = new Sprite();
			range = Number.MAX_VALUE;
			desription = "This is the description";
		}

		public function get level():int
		{
			return _level;
		}
			
		public function set level(value:int):void
		{
			if (value < 1)
				value = 1;
			_level = value;
			dispatchEvent(new Event(LEVEL_CHANGED));
			onLevelChange();
		}
		
		public function unEquip():void
		{
			warlock = null;
			onUnEquip();
		}
		
		public function equip(warlock:Warlock):void
		{
			this.warlock = warlock;
			onEquip();
		}
		
		protected function onEquip():void
		{
			
		}
		
		protected function onUnEquip():void
		{
			
		}
		
		public function upgrade():void
		{
			level = _level + 1;
		}
		
		public function downgrade():void
		{
			level = _level - 1;
		}
		
		public function update():void
		{
			
		}
		
		public function destroy():void
		{
			
		}
		
		protected function onLevelChange():void
		{
			
		}
		
		protected function addTag(... args):void
		{
			for (var i:int = 0; i < args.length; i++) 
			{
				tags.push(args[i]);
			}
		}
	}
}