package players
{
	import com.mistermartinez.interfaces.ISpatial;
	import com.mistermartinez.math.Vector2D;

	public interface IUserControlled
	{
		function attack(target:ISpatial):Boolean;
		function move(direction:Vector2D):void;
	}
}