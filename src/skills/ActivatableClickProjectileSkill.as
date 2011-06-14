package skills
{
	import Box2D.Dynamics.Joints.b2DistanceJointDef;
	
	import art.VectorArt;
	
	import com.mistermartinez.entities.b2VisibleEntity;
	import com.mistermartinez.interfaces.IAdvancedSpatial;
	import com.mistermartinez.interfaces.ISpatial;
	import com.mistermartinez.math.Vector2D;
	import com.mistermartinez.utils.DummySpatial;
	import com.mistermartinez.utils.InputHandler;
	
	import flash.events.MouseEvent;
	
	import projectiles.WarlockProjectile;

	public class ActivatableClickProjectileSkill extends ActivatableClickSkill
	{
		protected var _launchForce:Number;
		protected var _projectile:WarlockProjectile;
		
		public function ActivatableClickProjectileSkill(rechargeDuration:Number = 1, launchForce:Number = 10)
		{
			super(rechargeDuration);
			_launchForce = launchForce;
		}

		override protected function onSecondaryActivation(target:ISpatial):void
		{
			createProjectile(target);
		}
		
		protected function createProjectile(target:ISpatial):void
		{
			var startingPosition:Vector2D = warlock.position;
			var targetPosition:Vector2D = target.position;
			var projectile:WarlockProjectile = new WarlockProjectile(startingPosition, VectorArt.getCircle(10, 0xFF0000));
			targetPosition.subtract(startingPosition);
			launchProjectile(projectile, targetPosition);
		}
				
		protected function launchProjectile(projectile:IAdvancedSpatial, direction:Vector2D):void
		{
			//projectile.position.add(_position);
			direction.normalize();
			direction.multiply(_launchForce * projectile.mass);
			projectile.applyForce(direction);
		}
	}
}