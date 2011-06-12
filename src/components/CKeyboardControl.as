package components{		import com.mistermartinez.components.Component;
	import com.mistermartinez.interfaces.IUpdatable;
	import com.mistermartinez.math.Vector2D;
	import com.mistermartinez.utils.InputHandler;
	
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	
	import players.Warlock;
	
	import users.User;
	public class CKeyboardControl extends Component implements IUpdatable	{				private var _user:User;		private var _isMouseSet:Boolean;				public function CKeyboardControl(user:User)		{						_user = user;		}				public function update():void		{			onKeyDown(null);		}				protected function onKeyUp(event:KeyboardEvent):void		{			var player:Warlock = _user.warlock;			if (!player)				return;			if (!_isMouseSet)				player.moveTarget = null;			}		protected function onKeyDown(event:KeyboardEvent):void		{					var player:Warlock = _user.warlock;			if (!player)				return;			var direction:Vector2D = new Vector2D();			var input:InputHandler = InputHandler.instance;			if (input.areAnyKeysDown(_user.leftKeys))				direction.x -= 1;			if (input.areAnyKeysDown(_user.rightKeys))				direction.x += 1;			if (input.areAnyKeysDown(_user.upKeys))				direction.y -= 1;			if (input.areAnyKeysDown(_user.downKeys))				direction.y += 1;			if (direction.x != 0 || direction.y != 0)			{				direction.multiply(100);				player.moveTarget = player.position.add(direction);				_isMouseSet = false;			}		}				protected function onMouseClick(event:MouseEvent):void		{			var player:Warlock = _user.warlock;			if (!player)				return;/*			player.moveTarget = InputHandler.instance.mousePosition;			_isMouseSet = true;*/		}				override protected function onUnregister():void		{			_user = null;			//_user.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);			_user.removeEventListener(KeyboardEvent.KEY_UP, onKeyUp);			_user.removeEventListener(MouseEvent.MOUSE_UP, onMouseClick);		}				override protected function onRegister():void		{			//_user.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);			_user.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);			_user.addEventListener(MouseEvent.MOUSE_UP, onMouseClick);		}	}}