package components
{
	import com.greensock.plugins.HexColorsPlugin;
	import com.mistermartinez.components.Component;
	import com.mistermartinez.interfaces.IAdvancedSpatial;
	import com.mistermartinez.interfaces.IBound;
	import com.mistermartinez.interfaces.IEntity;
	import com.mistermartinez.interfaces.IUpdatable;
	import com.mistermartinez.math.Vector2D;
	
	import flash.display.MovieClip;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;

	public class CBoundsController extends Component implements IUpdatable
	{
		public static const CUSTOM:String = "custom";
		public static const BOUNCE:String = "bounce";
		public static const STOP:String = "stop";		
		public static const DESTROY:String = "destroy";
		public static const DO_NOTHING:String = "doNothing";
		public var slowOnBounce:Number = 1;
		private var _reactionTypes:Dictionary = new Dictionary();
		private var _reactionType:String;
		private var _type:Function;
		private var _entity:IBound;
		
		public function CBoundsController(entity:IBound, reactionType:String = DESTROY)
		{
			_entity = entity;
			//addReactionType(BOUNCE, bounce);
			addReactionType(STOP, stop);			
			addReactionType(DESTROY, destroy);		
			addReactionType(DO_NOTHING, doNothing);									
			setReactionType(reactionType);
			super();
		}
		
		public function setReactionType(value:String):void
		{
			_type = _reactionTypes[value];
			_reactionType = value;
		}
		
		public function addReactionType(key:String, method:Function):void
		{
			_reactionTypes[key] = method;
		}
		
		public function update():void
		{
			if (_reactionType == CUSTOM)
			{
				if (isOOB(_entity))
					_type();
				return;
			}
			_type(_entity);
		}
		
		private function isOOB(bounded:IBound):Boolean
		{
			return bounded.hitBox.intersects(bounded.bounds);
		}
		
		public function destroy(bounded:IBound):void
		{ 
			if (isOOB(bounded))
				IEntity(bounded).destroy();
		}			
		
		public function stop(bounded:IBound):void
		{ 
/*			var hit:Rectangle = bounded.hitBox;
			var bounds:Rectangle = bounded.bounds;
			var position:Vector2D = bounded.position;
			var velocity:Vector2D = bounded.velocity;
			if (hit.x < bounds.x)
			{
				//position.x = bounds.x;
				velocity.x = Math.max(velocity.x, 0);
			}
			else if (hit.right > bounds.width)
			{
				//position.x = bounds.width;
				velocity.x = Math.min(velocity.x, 0);
			}
			if (hit.y < bounds.y)
			{
				//position.y = bounds.y;
				velocity.y = Math.max(velocity.y, 0);
			}
			else if (hit.bottom > bounds.height)
			{
				//position.y = bounds.height;
				velocity.y = Math.min(velocity.y, 0);
			}
			bounded.velocity.equals(velocity);
			bounded.position.equals(position);*/
		}			
		
		public function doNothing(bounded:IBound):void
		{ 	
		}			
		
		override protected function onUnregister():void
		{
			_entity = null;
			_reactionTypes = null;
			_type = null;		
		}
	}
}
/*		public function bounce(bounds:Rectangle, position:b2Vec2):void
		{
			var velocity:b2Vec2 = _entity.body.GetLinearVelocity();
			var bounce:Number = slowOnBounce * -1;
			if (position.x > bounds.width)
			{
				position.x = bounds.width;
				velocity.x *= bounce;
			}
			else if (position.x  < bounds.x)
			{
				position.x = bounds.x;
				velocity.x *= bounce;
			}
			if (position.y > bounds.height)
			{
				position.y = bounds.height;
				velocity.y *= bounce;				
			}
			else if(position.y < bounds.y)
			{
				position.y = bounds.y;				
				velocity.y *= bounce;
			}
			_entity.body.SetXForm(position, _entity.body.GetAngle());
		}*/