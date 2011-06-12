package components
{
	import Entities.FieldEntity;
	import Entities.PhysicsEntity;
	import Entities.VisiblePhysicsEntity;
	
	import Utils.Math2;
	
	import com.mistermartinez.components.Component;
	import com.mistermartinez.interfaces.IAdvancedSpatial;

	public class CFaceVelocity extends Component
	{
		private var _entity:IAdvancedSpatial;
		
		public function CFaceVelocity(entity:IAdvancedSpatial)
		{
			_entity = entity;
		}
		
		public function update():void
		{
			var angle:Number = _entity.velocity.angle * MathX.DEG2RAD;
			_entity.rotation = angle;
		}
		
		override protected function onUnregister():void
		{
			_entity = null;
		}	
	}
}