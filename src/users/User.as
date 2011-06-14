package users
{
	import com.mistermartinez.entities.Entity;
	import com.mistermartinez.interfaces.ISpatial;
	import com.mistermartinez.utils.InputHandler;
	
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.ui.Keyboard;
	
	import players.Warlock;

	public class User extends Entity
	{
		public static const INPUT_ACTION:String = "inputAction";
		public var leftKeys:Vector.<int> = Vector.<int>([Keyboard.A, Keyboard.LEFT]);
		public var upKeys:Vector.<int> = Vector.<int>([Keyboard.W, Keyboard.UP]);
		public var rightKeys:Vector.<int> = Vector.<int>([Keyboard.D, Keyboard.RIGHT]);
		public var downKeys:Vector.<int> = Vector.<int>([Keyboard.S, Keyboard.DOWN]);
		//public var weaponKeys:Vector.<int> = Vector.<int>([Keyboard.NUMBER_1, Keyboard.NUMBER_2, Keyboard.NUMBER_3, Keyboard.NUMBER_4, Keyboard.NUMBER_5, Keyboard.NUMBER_6, Keyboard.NUMBER_7]);
		private var _warlock:Warlock;
		public var color:uint;
		[Bindable]
		public var points:uint;
		
		public function User(color:uint = 0xFF0000)
		{
			this.color = color;
			this.points = 10;
			InputHandler.instance.addEventListener(KeyboardEvent.KEY_DOWN, echoInputEvent);
			InputHandler.instance.addEventListener(KeyboardEvent.KEY_UP, echoInputEvent);
			InputHandler.instance.addEventListener(MouseEvent.MOUSE_UP, echoInputEvent);
		}
		
		public function get warlock():Warlock
		{
			return _warlock;
		}

		public function set warlock(value:Warlock):void
		{
			_warlock = value;
			_warlock.user = this;
		}

		private function echoInputEvent(event:*):void
		{
			dispatchEvent(new Event(INPUT_ACTION));
			dispatchEvent(event);
		}
		
		override public function update():void
		{
			super.update();
			if (_warlock)
				_warlock.update();
		}
		
		override public function destroy():void
		{
			super.destroy();
			InputHandler.instance.removeEventListener(KeyboardEvent.KEY_DOWN, echoInputEvent);
			InputHandler.instance.removeEventListener(KeyboardEvent.KEY_UP, echoInputEvent);
			InputHandler.instance.removeEventListener(MouseEvent.MOUSE_UP, echoInputEvent);
		}
	}
}