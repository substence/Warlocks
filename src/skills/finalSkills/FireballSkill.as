package skills.finalSkills
{
	import art.VectorArt;
	
	import com.mistermartinez.interfaces.ISpatial;
	import com.mistermartinez.math.Vector2D;
	import com.mistermartinez.utils.NumberRange;
	
	import flash.ui.MouseCursor;
	
	import projectiles.WarlockProjectile;
	
	import properties.Properties;
	
	import skills.ActivatableClickProjectileSkill;
	import skills.SkillTypes;

	public class FireballSkill extends ActivatableClickProjectileSkill
	{
		[Embed(source="assets/icons/fireball.jpg")]
		public var iconClass:Class;
		private const _DAMAGE_RANGE:NumberRange = new NumberRange(.1, .25);
		private const _PUSH_RANGE:NumberRange = new NumberRange(.25, .5);
		private const _LAUNCH_FORCE_RANGE:NumberRange = new NumberRange(.5, .75);
		private const _RECHARGE_DURATION_RANGE:NumberRange = new NumberRange(4, 2);
		private var _projectileDamage:uint;
		private var _projectilePush:uint;

		public function FireballSkill()
		{
			name = "Fireball";
			addTag(SkillTypes.PROJECTILE);
			icon = new iconClass();
			desription = "Shoots a fireball in target direction.";
			hotKey = String("G").charCodeAt();
			activationDuration = GameDirector.MATCH_DURATION;
			_launchForce = 200;
			level = 1;
		}
		
		override protected function onLevelChange():void
		{
			const levelPercent:Number = _level / MAX_LEVEL;
			rechargeDuration = _RECHARGE_DURATION_RANGE.getNumberInRangeFromPercent(levelPercent);
			//_launchForce = _LAUNCH_FORCE_RANGE.getNumberInRangeFromPercent(levelPercent) * Properties.MAX_LAUNCH_FORCE;
			_projectileDamage = _DAMAGE_RANGE.getNumberInRangeFromPercent(levelPercent) * Properties.MAX_DAMAGE;
			_projectilePush = _PUSH_RANGE.getNumberInRangeFromPercent(levelPercent) * Properties.MAX_PUSH;
		}
		
		override protected function createProjectile(target:ISpatial):void
		{
			var startingPosition:Vector2D = warlock.position.clone();
			var targetPosition:Vector2D = target.position.clone();
			var projectile:WarlockProjectile = new WarlockProjectile(startingPosition, VectorArt.getCircle(2.5, warlock.user.color), _projectileDamage, _projectilePush);
			projectile.groupIndex = warlock.groupIndex;
			projectile.doesDieOnHit = true;
			warlock.addChild(projectile);
			launchProjectile(projectile, new Vector2D(target.position.x - warlock.position.x, target.position.y - warlock.position.y));
		}
	}
}