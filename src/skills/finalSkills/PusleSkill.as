package skills.finalSkills
{
	import Box2D.Collision.Shapes.b2CircleShape;
	import Box2D.Dynamics.b2FixtureDef;
	
	import art.VectorArt;
	
	import buffs.ChannelingBuff;
	import buffs.TimedBuff;
	
	import com.greensock.TweenLite;
	import com.mistermartinez.entities.b2Entity;
	import com.mistermartinez.utils.Box2DHandler;
	import com.mistermartinez.utils.NumberRange;
	import com.mistermartinez.utils.UpdateHandler;
	import com.mistermartinez.utils.sceneHandler.SceneLayersLibrary;
	
	import flash.display.Graphics;
	import flash.display.LineScaleMode;
	import flash.display.Shape;
	import flash.events.Event;
	
	import mx.effects.Tween;
	
	import projectiles.WarlockProjectile;
	
	import properties.Properties;
	
	import skills.ActivatableSkill;
	import skills.Skill;
	import skills.SkillTypes;
	
	public class PusleSkill extends ActivatableSkill
	{
		private const _DAMAGE_RANGE:NumberRange = new NumberRange(.25, .35);
		private const _PUSH_RANGE:NumberRange = new NumberRange(.2, .5);
		private const _RECHARGE_DURATION_RANGE:NumberRange = new NumberRange(4, 2);
		private const _RANGE:uint = 50;
		private const _CHANNEL_TIME:uint = 2;
		[Embed(source="assets/icons/pulse.jpg")]
		public var iconClass:Class;
		private var _damage:Number;
		private var _push:Number;
		private var _buff:ChannelingBuff;
		private var _hitSensor:WarlockProjectile;
		private var _graphic:Shape;
		
		public function PusleSkill(rechargeDuration:Number=0, activationDuration:Number=0)
		{
			super(rechargeDuration, GameDirector.MATCH_DURATION);
			name = "Pulse";
			addTag(SkillTypes.SELF_AE, SkillTypes.DAMAGE, SkillTypes.CHANNEL, SkillTypes.SELF_DAMAGE);
			icon = new iconClass();
			desription = "After a delay, does does damage to EVERYONE around you, including yourself.";
			hotKey = String("G").charCodeAt();
			range = _RANGE;
			level = 1;
		}
		
		override public function update():void
		{
			super.update();
			if (_buff)
			{
				_buff.charges++;
				range = getChargePercent() * _RANGE;
			}
		}
		
		private function getChargePercent():Number
		{
			return _buff.charges / (_CHANNEL_TIME * UpdateHandler.TICKS_PER_SECOND);
		}
		
		override protected function onActivation():void
		{
			_buff =  new ChannelingBuff(_CHANNEL_TIME);
			_buff.addEventListener(ChannelingBuff.INTERUPTED, onInterrupt);
			_buff.addEventListener(TimedBuff.TIMER_COMPLETE, onChannelComplete);
			warlock.addBuff(_buff);
		}
		
		private function onInterrupt(event:Event):void
		{
			deactivate();
		}
		
		private function onChannelComplete(event:Event):void
		{
			//maybe add more charges?
			deactivate();
		}
		
		override protected function onDeactivation():void
		{
			createHitSensor();
			_buff.removeEventListener(ChannelingBuff.INTERUPTED, onInterrupt);
			_buff.removeEventListener(TimedBuff.TIMER_COMPLETE, onChannelComplete);
			warlock.removeBuff(_buff);
		}
		
		private function createHitSensor():void
		{
			createPulseGraphic();
			var chargePercent:Number = getChargePercent();
			var damage:Number = chargePercent * _damage;
			var push:Number = chargePercent * _push;
			_hitSensor = new WarlockProjectile(warlock.position, null, damage, push);
			var circle:b2CircleShape = new b2CircleShape();
			circle.SetRadius(range / Box2DHandler.DRAW_SCALE);
			_hitSensor.addFixture(b2Entity.createFixtureDefinition(circle));
			_hitSensor.groupIndex = warlock.groupIndex;
			_hitSensor.fixture.SetSensor(true);
			_hitSensor.isDead = true;
			warlock.addChild(_hitSensor);
		}
		
		override protected function onLevelChange():void
		{
			const levelPercent:Number = _level / MAX_LEVEL;
			rechargeDuration = 2;
			_damage = _DAMAGE_RANGE.getNumberInRangeFromPercent(levelPercent) * Properties.MAX_DAMAGE;
			_push = _PUSH_RANGE.getNumberInRangeFromPercent(levelPercent) * Properties.MAX_RANGE;
		}
		
		private function createPulseGraphic():void
		{
			_graphic = new Shape();
			var color:uint = warlock.user.color;
			_graphic.graphics.lineStyle(1, color, .8, false, LineScaleMode.NONE);
			_graphic.graphics.beginFill(color, .25);
			_graphic.graphics.drawCircle(0,0, 1);
			_graphic.x = warlock.graphic.x;
			_graphic.y = warlock.graphic.y;
			TweenLite.to(_graphic, .45, {alpha: 0, width:range * 3, height:range * 3, onComplete:destroyPulseGraphic});
			SceneLayersLibrary.foreground.addChild(_graphic);
		}
		
		private function destroyPulseGraphic():void
		{
			if (_graphic)
			{
				SceneLayersLibrary.foreground.removeChild(_graphic);
				_graphic = null;
			}
		}
	}
}