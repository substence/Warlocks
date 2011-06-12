package skills.finalSkills
{
	import buffs.WindWalkBuff;
	
	import com.mistermartinez.utils.NumberRange;
	
	import skills.ActivatableSkill;
	import skills.SkillTypes;
	
	public class WindWalkSkill extends ActivatableSkill
	{
		[Embed(source="assets/icons/windWalk.jpg")]
		public var iconClass:Class;
		private const _ACTIVATION_DURATION_RANGE:NumberRange = new NumberRange(2, 4);
		private const _RECHARGE_DURATION_RANGE:NumberRange = new NumberRange(8, 4);
		private const _MOVESPEED_AMOUNT_RANGE:NumberRange = new NumberRange(1.5, 2);
		private var _buff:WindWalkBuff;
		private var _moveSpeedAmount:Number;
		
		public function WindWalkSkill()
		{
			name = "Wind Walk";
			addTag(SkillTypes.MOVEMENT);
			icon = new iconClass();
			desription = "Go invisible and walk faster for a short duration";
			hotKey = String("W").charCodeAt();
			level = 1;
		}
		
		override protected function onLevelChange():void
		{
			const levelPercent:Number = _level / MAX_LEVEL;
			activationDuration = _ACTIVATION_DURATION_RANGE.getNumberInRangeFromPercent(levelPercent);
			rechargeDuration = _RECHARGE_DURATION_RANGE.getNumberInRangeFromPercent(levelPercent);
			_moveSpeedAmount = _MOVESPEED_AMOUNT_RANGE.getNumberInRangeFromPercent(levelPercent);
		}
		
		override protected function onActivation():void
		{
			_buff = new WindWalkBuff(_activationTimer.durationInSeconds, _moveSpeedAmount);
			warlock.addBuff(_buff);
		}
		
		override protected function onDeactivation():void
		{
			warlock.removeBuff(_buff);
			_buff = null;
		}
	}
}