package terrains
{
	import com.mistermartinez.interfaces.IDrawable;
	import com.mistermartinez.interfaces.IUpdatable;
	import com.mistermartinez.math.Vector2D;

	public interface ITerrainLayer extends IUpdatable, IDrawable
	{
		function get maxDimensions():Vector2D;
		function resize(dimensions:Vector2D):void;
	}
}