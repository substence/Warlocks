package skills.finalSkills
{
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.Joints.*;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2Fixture;
	
	import art.VectorArt;
	
	import buffs.DamageOverTimeBuff;
	import buffs.IBuffable;
	
	import com.mistermartinez.entities.CollisionEvent;
	import com.mistermartinez.entities.Entity;
	import com.mistermartinez.interfaces.ICollidable;
	import com.mistermartinez.interfaces.IEntity;
	import com.mistermartinez.interfaces.ISpatial;
	import com.mistermartinez.math.Vector2D;
	import com.mistermartinez.utils.Box2DHandler;
	import com.mistermartinez.utils.FrameTimer;
	import com.mistermartinez.utils.InputHandler;
	import com.mistermartinez.utils.NumberRange;
	
	import interfaces.IFullDescription;
	
	import mx.events.CollectionEvent;
	
	import physics.b2SoftJoint;
	
	import players.Warlock;
	
	import projectiles.WarlockProjectile;
	
	import properties.Properties;
	
	import skills.ActivatableClickProjectileSkill;
	import skills.SkillTypes;
	
	import tooltips.ToolTipUtilities;
	
	public class LinkSkill extends ActivatableClickProjectileSkill implements IFullDescription
	{
		private const _MAX_FORCE:NumberRange = new NumberRange(30, 20);
		private const _ACTIVATION_DURATION_RANGE:NumberRange = new NumberRange(10, 15);
		private const _RECHARGE_DURATION_RANGE:NumberRange = new NumberRange(8, 4);
		private const _DAMAGE_RANGE:NumberRange = new NumberRange(.01, .05);
		private const _TIMEOUT_DURATION:Number = 10;
		[Embed(source="assets/icons/link.jpg")]
		public var iconClass:Class;
		private var _joint:b2MouseJoint;
		private var _target:ISpatial;
		private var _damage:Number;
		private var _buff:DamageOverTimeBuff;
		private var _maxForce:Number;

		
		public function LinkSkill(rechargeDuration:Number=1, launchForce:Number=10)
		{
			super(rechargeDuration, launchForce);
			name = "Link";
			addTag(SkillTypes.PROJECTILE);
			icon = new iconClass();
			desription = "Shoots a link in target direction, if link collides with an enemy they will be pulled towards the caster, inflicting damage as the target is drug.";
			hotKey = String("L").charCodeAt();
			_launchForce = 600;
			level = 1;
		}
		
		public function get fullDescription():String
		{
			return "Shoots a link in the target direction with a max length of " + ToolTipUtilities.getVariableText(_maxForce) + " dealing " + ToolTipUtilities.getVariableText(_damage) + 
				" damage every second.<p></p>Maximum link duration of " + ToolTipUtilities.getVariableText(_activationTimer.durationInSeconds) + " seconds.";
		}
		
		override protected function onLevelChange():void
		{
			const levelPercent:Number = _level / MAX_LEVEL;
			rechargeDuration = _RECHARGE_DURATION_RANGE.getNumberInRangeFromPercent(levelPercent);
			activationDuration = _ACTIVATION_DURATION_RANGE.getNumberInRangeFromPercent(levelPercent);
			_damage = _DAMAGE_RANGE.getNumberInRangeFromPercent(levelPercent) * Properties.MAX_DAMAGE;
			_maxForce = _MAX_FORCE.getNumberInRangeFromPercent(levelPercent);
			//_projectileDamage = _DAMAGE_RANGE.getNumberInRangeFromPercent(levelPercent) * Properties.MAX_DAMAGE;
		}
		
		override public function update():void
		{
			super.update();
			if (_joint)
				_joint.SetTarget(warlock.body.GetWorldCenter());
			if (_target)
				_target.position = _projectile.position;
		}
		
		override protected function createProjectile(target:ISpatial):void
		{
			var startingPosition:Vector2D = warlock.position.clone();
			var targetPosition:Vector2D = target.position.clone();
			_projectile = new WarlockProjectile(startingPosition, VectorArt.getCircle(2.5, 0x00FF00));
			_projectile.owner = warlock;
			_projectile.fixture.SetSensor(true);
			warlock.addChild(_projectile);
			launchProjectile(_projectile, new Vector2D(target.position.x - warlock.position.x, target.position.y - warlock.position.y));
			createJoint(_projectile);
			_projectile.addEventListener(WarlockProjectile.LAUNCH_SUCCESS, onLaunchSuccess);
		}
		
		private function onLaunchSuccess(event:CollisionEvent):void
		{
			_projectile.removeEventListener(WarlockProjectile.LAUNCH_SUCCESS, onLaunchSuccess);
			_projectile.addEventListener(CollisionEvent.COLLIDED, onProjectileCollide);
			_projectile.addEventListener(WarlockProjectile.VALID_HIT, onProjectileValidHit);
		}
		
		private function onProjectileValidHit(event:CollisionEvent):void
		{
			var target:ICollidable = event.b;
			if (_target || target == warlock)
				return;
			if (target is ISpatial)
			{
				_target = ISpatial(target);
				_projectile.position = _target.position;
				if (target is IBuffable)
				{
					_buff = new DamageOverTimeBuff(.33, _damage); 
					IBuffable(target).addBuff(_buff);
				}
			}
		}
		
		private function onProjectileCollide(event:CollisionEvent):void
		{
			var target:ICollidable = event.b;
			if (target == warlock || (_target && _target == target))
				deactivate();
		}
		
		override protected function onDeactivation():void
		{
			if (_joint)
			{
				Box2DHandler.instance.world.DestroyJoint(_joint);
				_joint = null;
			}
			if (_projectile)
			{
				_projectile.removeEventListener(CollisionEvent.COLLIDED, onProjectileCollide);
				_projectile.removeEventListener(WarlockProjectile.VALID_HIT, onProjectileValidHit);
				_projectile.isDead = true;
			}
			if (_buff)
			{
				IBuffable(_target).removeBuff(_buff);
				_buff = null;
			}
			_target = null;
		}
		
		private function createJoint(projectile:WarlockProjectile):void
		{
			var warlockBody:b2Body = warlock.body;
			var warlockPosition:b2Vec2 = warlockBody.GetWorldCenter();
			var jointDefinition:b2MouseJointDef = new b2MouseJointDef();
			jointDefinition.collideConnected = true;
			jointDefinition.bodyA = warlockBody;
			jointDefinition.bodyB = projectile.body;
			jointDefinition.target.Set(warlockPosition.x, warlockPosition.y);
			jointDefinition.maxForce = _maxForce * projectile.body.GetMass();
			jointDefinition.dampingRatio = 2;
			_joint = Box2DHandler.instance.world.CreateJoint(jointDefinition) as b2MouseJoint;
		}
	}
}