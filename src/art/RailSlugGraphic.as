package art
{
	import com.greensock.TweenMax;
	import com.mistermartinez.math.Vector2D;
	
	import flash.display.Shape;
	import flash.display.Sprite;
	
	public class RailSlugGraphic extends Sprite
	{
		private var _core:Shape;
		private var _outter:Shape;
		
		public function RailSlugGraphic(color:uint, from:Vector2D, to:Vector2D)
		{
			_core = new Shape();
			_core.graphics.lineStyle(1, color);
			addChild(_core);
			TweenMax.to(_core, 1.25, {blurFilter:{blurX:30, blurY:30, alpha:0}});
			_outter = new Shape();
			_outter.graphics.lineStyle(1, color);
			addChild(_outter);
			TweenMax.to(_outter, 1.75, {alpha:0});
			_core.graphics.lineTo(to.x - from.x , to.y - from.y);
			_outter.graphics.lineTo(to.x - from.x, to.y - from.y);
		}
	}
}