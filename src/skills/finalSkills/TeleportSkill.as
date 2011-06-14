package skills.finalSkills
{
	import art.VectorArt;
	
	import com.greensock.TweenLite;
	import com.greensock.easing.Linear;
	import com.mistermartinez.interfaces.ISpatial;
	import com.mistermartinez.math.Vector2D;
	import com.mistermartinez.utils.InputHandler;
	import com.mistermartinez.utils.NumberRange;
	import com.mistermartinez.utils.sceneHandler.SceneLayersLibrary;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.filters.BlurFilter;
	import flash.geom.Matrix;
	
	import mx.core.BitmapAsset;
	
	import properties.Properties;
	
	import skills.ActivatableClickSkill;
	import skills.ActivatableSkill;
	import skills.SkillTypes;

	public class TeleportSkill extends ActivatableClickSkill
	{
		[Embed(source="assets/icons/teleport.jpg")]
		public var iconClass:Class;
		private const _RECHARGE_DURATION_RANGE:NumberRange = new NumberRange(4, 2);
		private const _RANGE_DURATION_RANGE:NumberRange = new NumberRange(.2, .6);
		private var _fade:Sprite;
		
		public function TeleportSkill(rechargeDuration:Number=1)
		{
			name = "Teleport";
			addTag(SkillTypes.MOVEMENT);
			icon = new iconClass() as DisplayObject;
			desription = "Teleport to target position(limited by range).";
			hotKey = String("G").charCodeAt();
			activationDuration = GameDirector.MATCH_DURATION;
			level = 1;
		}
		
		override protected function onSecondaryActivation(target:ISpatial):void
		{
			warlock.position = target.position;
			addFadeGraphic();
			deactivate();
		}
		
		private function addFadeGraphic():void
		{
			var warlockGraphic:DisplayObject = warlock.graphic;
			_fade = new Sprite();
			_fade.x = warlockGraphic.x;
			_fade.y = warlockGraphic.y;
			var bitmapClone:Bitmap = cloneDisplayObject(warlockGraphic);
			bitmapClone.x -= warlockGraphic.width * .5;
			bitmapClone.y -= warlockGraphic.height * .5;
			_fade.addChild(bitmapClone);
			var line:Shape = new Shape();
			line.graphics.lineStyle(1, warlock.user.color, .25);
			line.graphics.lineTo(warlock.position.x - warlockGraphic.x, warlock.position.y - warlockGraphic.y);
			_fade.addChild(line);
			SceneLayersLibrary.foreground.addChild(_fade);
			TweenLite.to(_fade, .25, {alpha:0, onComplete:removeFadeGraphic});
		}
		
		private function removeFadeGraphic():void
		{
			SceneLayersLibrary.foreground.removeChild(_fade);
		}
		
		private function cloneDisplayObject(displayObject:DisplayObject):Bitmap
		{
			var warlockBitmapData:BitmapData = new BitmapData(displayObject.width, displayObject.height, true);
			var matrix:Matrix = new Matrix();
			matrix.translate(displayObject.width * .5, displayObject.height * .5);
			warlockBitmapData.draw(displayObject, matrix);
			return new Bitmap(warlockBitmapData);;
		}
		
		override protected function onLevelChange():void
		{
			const levelPercent:Number = _level / MAX_LEVEL;
			rechargeDuration = _RECHARGE_DURATION_RANGE.getNumberInRangeFromPercent(levelPercent);
			range = _RANGE_DURATION_RANGE.getNumberInRangeFromPercent(levelPercent) * Properties.MAX_RANGE;
		}
	}
}