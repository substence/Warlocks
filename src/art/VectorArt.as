package art
{
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.filters.GlowFilter;

	public class VectorArt
	{
		public static function getCircle(size:uint, color:uint, doesGlow:Boolean = false):Sprite
		{
			var container:Sprite = new Sprite();
			var fill:Shape = new Shape();
			fill.graphics.beginFill(color);
			fill.graphics.drawCircle(-size, -size, size * 2);
			fill.graphics.endFill();
			if (doesGlow)
				fill.filters = [new GlowFilter(color, 1, size, size, 3, 3)];
			fill.alpha = .25;
			var outline:Shape = new Shape();
			outline.graphics.lineStyle(1, color);
			outline.graphics.drawCircle(-size, -size, size * 2);
			container.addChild(fill);
			container.addChild(outline);
			return container;
		}
		
		public static function getSquare(size:uint, color:uint, doesGlow:Boolean = false):Sprite
		{
			var container:Sprite = new Sprite();
			var fill:Shape = new Shape();
			fill.graphics.beginFill(color);
			fill.graphics.drawRect(-size * .5, -size * .5, size, size);
			fill.graphics.endFill();
			if (doesGlow)
				fill.filters = [new GlowFilter(color, 1, size, size, 3, 3)];
			fill.alpha = .25;
			var outline:Shape = new Shape();
			outline.graphics.lineStyle(1, color);
			outline.graphics.drawRect(-size * .5, -size * .5, size, size);
			container.addChild(fill);
			container.addChild(outline);
			return container;
		}
	}
}