package projectiles
{
	import Box2D.Collision.Shapes.b2Shape;
	import Box2D.Dynamics.Contacts.b2Contact;
	import Box2D.Dynamics.b2Fixture;
	import Box2D.Dynamics.b2FixtureDef;
	
	import com.mistermartinez.entities.CollisionEvent;
	import com.mistermartinez.entities.Entity;
	import com.mistermartinez.entities.b2Entity;
	import com.mistermartinez.entities.b2VisibleEntity;
	import com.mistermartinez.interfaces.IAdvancedSpatial;
	import com.mistermartinez.interfaces.ICollidable;
	import com.mistermartinez.interfaces.IEntity;
	import com.mistermartinez.math.Vector2D;
	import com.mistermartinez.utils.FrameTimer;
	
	import components.CProperty;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	
	import players.Warlock;
	
	import properties.Properties;
	
	import skills.Skill;
	
	public class WarlockProjectile extends b2VisibleEntity
	{
		public static const VALID_HIT:String = "onValidHit";
		public static const LAUNCH_SUCCESS:String = "launchSuccess"
		public var damage:Number;
		public var push:Number;
		public var radius:Number;
		public var skill:Skill;
		public var owner:Warlock;
		public var doesDieOnHit:Boolean;
		protected var _durationTimer:FrameTimer;
		private var _duration:Number;
		
		public function WarlockProjectile(position:Vector2D=null, graphic:DisplayObject=null, damage:Number = 0, push:Number = 0)
		{
			super(position, graphic, true);
			_durationTimer = new FrameTimer();
			_durationTimer.addEventListener(FrameTimer.TIMER_COMPLETE, expiredDurationTimer);
			this.damage = damage;
			this.push = push;
			this.duration = duration;
		}
	
		public function get duration():Number
		{
			return _duration;
		}

		public function set duration(value:Number):void
		{
			_duration = value;
			_durationTimer.steps = _duration * Config.FRAME_RATE;
		}
		
		override public function collided(into:ICollidable):Boolean
		{
			super.collided(into);
			if (true)//into is Player)
			{
				if (into is IEntity)
					applyDamage(IEntity(into));
				if (into is IAdvancedSpatial)
					applyPush(IAdvancedSpatial(into));
				dispatchEvent(new CollisionEvent(VALID_HIT, this, into));
				onValidHit(into);
				if (doesDieOnHit)
					isDead = true;
				return true;
			}
			return false;
		}
		
		override public function onEndContact(entity:b2Entity, contact:b2Contact):void
		{
			super.onEndContact(entity, contact);
			if (owner && entity == owner)
				dispatchEvent(new CollisionEvent(LAUNCH_SUCCESS,this, entity, contact));
		}
		
		protected function applyDamage(entity:IEntity):void
		{
			var healthComponent:CProperty = CProperty(entity.getComponentByName(Properties.HEALTH));
			if (healthComponent)
				healthComponent.modify(-damage, this);
		}
		
		protected function applyPush(advancedSpatial:IAdvancedSpatial):void
		{
			var velocity:Vector2D = advancedSpatial.position.clone().subtract(position);
			velocity.normalize();
			velocity.multiply(push);
			advancedSpatial.applyForce(velocity);
		}
		
		protected function expiredDurationTimer(event:Event):void
		{
			isDead = true;
		}
		
		protected function onValidHit(target:ICollidable):void
		{
			
		}
		
		
		override public function destroy():void
		{
			super.destroy();
			_durationTimer.stop();
			_durationTimer.removeEventListener(FrameTimer.TIMER_COMPLETE, expiredDurationTimer);
			_durationTimer = null;
		}
		
	}
}