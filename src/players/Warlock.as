package players
{
	import art.VectorArt;
	
	import buffs.Buff;
	import buffs.IBuffable;
	
	import com.mistermartinez.entities.Entity;
	import com.mistermartinez.entities.b2VisibleEntity;
	import com.mistermartinez.interfaces.IDrawable;
	import com.mistermartinez.math.Vector2D;
	import com.mistermartinez.utils.InputHandler;
	import com.mistermartinez.utils.sceneHandler.SceneLayersLibrary;
	
	import components.CBoundsController;
	import components.CModifiableProperty;
	import components.CProperty;
	
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	
	import interfaces.IOwned;
	
	import properties.Properties;
	
	import skills.ActivatableClickSkill;
	import skills.ActivatableSkill;
	import skills.ISkillable;
	import skills.Skill;
	
	import users.User;
	
	public class Warlock extends b2VisibleEntity implements IOwned, IBuffable, ISkillable
	{
		public static const DEFAULT_HEALTH:uint = 100;
		public static const DEFAULT_MOVESPEED:uint = 150;
		public static const REACHED_MOVETARGET:String = "warlockReachedMoveTarget";
		public static const ACTIVATED_SKILL:String = "warlockActivatedSkill";
		public static var groupIndex:int = -1;
		public var user:User;
		public var moveTarget:Vector2D;
		private var _activeSkill:ActivatableSkill;
		private var _skills:Vector.<Skill>;
		private var _buffs:Vector.<Buff>;
		private var _activeSkills:Vector.<ActivatableSkill>;
		private var _children:Vector.<Entity>;
		private var _moveSpeedProperty:CModifiableProperty;
		
		public function Warlock(position:Vector2D, user:User)
		{
			super(position);
			_bodyDefinition.linearDamping = 5;
			_children = new Vector.<Entity>();
			_skills = new Vector.<Skill>();
			_buffs = new Vector.<Buff>();
			_activeSkills = new Vector.<ActivatableSkill>();
			graphic = VectorArt.getSquare(20, user.color);
			addShapeFromDisplayObject(graphic);
			groupIndex = Warlock.groupIndex;
			this.user = user;
			//
			user.addEventListener(KeyboardEvent.KEY_UP, onKeyDown);
			Warlock.groupIndex--;
			addComponent(new CBoundsController(this, CBoundsController.STOP));
			addComponent(new CModifiableProperty(DEFAULT_HEALTH, 0), Properties.HEALTH);
			_moveSpeedProperty = CModifiableProperty(addComponent(new CModifiableProperty(DEFAULT_MOVESPEED, 0), Properties.MOVE_SPEED));
		}
		
		public function get activeSkill():ActivatableSkill
		{
			return _activeSkill;
		}
		
		public function set activeSkill(value:ActivatableSkill):void
		{
			if (_activeSkill == value)
				return;
			if (_activeSkill)
			{
				//if (_activeSkill is ActivatableClickSkill)
				_activeSkill.removeEventListener(ActivatableSkill.DEACTIVATE, deactivateActiveSkill);
				//_activeSkill.cancel();
			}
			_activeSkill = value;
			if (_activeSkill)
			{
				_activeSkill.addEventListener(ActivatableSkill.DEACTIVATE, deactivateActiveSkill);
				dispatchEvent(new Event(ACTIVATED_SKILL));
			}
		}

		public function get skills():Vector.<Skill>
		{
			return _skills;
		}
		
		public function get buffs():Vector.<Buff>
		{
			return _buffs;
		}

		public function get owner():User
		{
			return user;
		}
		
		public function addSkill(skill:Skill):void
		{
			_skills.push(skill);
			skill.equip(this);
			if (skill is ActivatableSkill)
			{
				var activeSkill:ActivatableSkill = ActivatableSkill(skill);
				_activeSkills.push(activeSkill);
				activeSkill.hotKey = String(_activeSkills.length).charCodeAt();
			}
		}
		
		public function addBuff(buff:Buff):Boolean
		{
			var index:int = _buffs.indexOf(buff);
			if (index >= 0)
			{
				_buffs[index].charges += buff.charges;
				return false;
			}
			var existingBuff:Buff = getBuffByType(Object(buff).constructor);
			if (existingBuff)
			{
				existingBuff.charges += buff.charges;
				return false;
			}
			_buffs.push(buff);
			buff.equip(this);
			return true;
		}
		
		private function getBuffByType(type:Class):Buff
		{
			for (var i:int = 0; i < _buffs.length; i++) 
			{
				var buff:Buff = _buffs[i];
				if (buff is type)
					return buff;
			}
			return null;
		}
		
		public function removeBuff(buff:Buff):void
		{
			var index:int = _buffs.indexOf(buff);
			if (index < 0)
				return;
			_buffs.splice(index, 1);
			buff.unEquip();
			buff.destroy();
		}
		
		public function removeSkill(skill:Skill):void
		{
			var index:int = _skills.indexOf(skill);
			if (index < 0)
				return;
			_skills.splice(index, 1);
			skill.unEquip();
			if (skill is ActivatableSkill)
			{
				var activeSkill:ActivatableSkill = ActivatableSkill(skill);
				_activeSkills.splice(_activeSkills.indexOf(activeSkill), 1);
				activeSkill.hotKey = 0;
			}
			skill.destroy();
		}
		
		private function deactivateActiveSkill(event:Event = null):void
		{
			_activeSkill.removeEventListener(ActivatableSkill.DEACTIVATE, deactivateActiveSkill);
			_activeSkill = null;
		}
		
		public function addChild(child:Entity):void
		{
			child.addEventListener(Entity.ENTITY_DESTROYED, childDestroyed);
			_children.push(child);
			if (child is IDrawable && IDrawable(child).graphic)
				SceneLayersLibrary.foreground.addChild(IDrawable(child).graphic);
		}
		
		public function removeChild(child:Entity):void
		{
			child.removeEventListener(Entity.ENTITY_DESTROYED, childDestroyed);
			_children.splice(_children.indexOf(child), 1);
			if (child is IDrawable && IDrawable(child).graphic)
				SceneLayersLibrary.foreground.removeChild(IDrawable(child).graphic)
		}
		
		private function childDestroyed(event:Event):void
		{
			removeChild(Entity(event.target));
		}
		
		private function onKeyDown(event:KeyboardEvent):void
		{
			var keyPressed:uint = event.keyCode;
			checkSkillActivate(keyPressed);
		}
		
		public function purchaseSkill(skill:Skill):Boolean
		{
			if (user.points >= skill.cost && _skills.indexOf(skill) == -1)
			{
				user.points -= skill.cost;
				addSkill(skill);
				return true;
			}
			return false;
		}
		
		public function upgradeSkill(skill:Skill):Boolean
		{
			if (user.points >= skill.upgradeCost && skill.level < Skill.MAX_LEVEL)
			{
				user.points -= skill.upgradeCost;
				skill.upgrade();
				return true;
			}
			return false;
		}
		
		private function checkSkillActivate(keyPressed:uint):void
		{
			var length:uint = _activeSkills.length;
			for (var i:int = 0; i < length; i++) 
			{
				var skill:ActivatableSkill = _activeSkills[i];
				if (keyPressed == skill.hotKey)
				{
					if (skill.activate())
						activeSkill = skill;
				}
			}
		}
		
		override public function update():void
		{
			super.update();
			for (var i:int = 0; i < _children.length; i++) 
			{
				_children[i].update();
			}
			for (i = 0; i < _skills.length; i++) 
			{
				_skills[i].update();
			}
			moveTowardsTarget();
		}
		
		private function moveTowardsTarget():Boolean
		{
			if (!moveTarget)
				return false;
			if (position.distanceTo(moveTarget) < 1)
			{
				moveTarget = null;
				dispatchEvent(new Event(REACHED_MOVETARGET));
				return false;
			}
			var force:Vector2D = moveTarget.clone().subtract(position);
			force.normalize();
			force.multiply(moveSpeed);
			force.subtract(velocity);
			applyForce(force); 
			return true;
		}
		
		public function get moveSpeed():Number
		{
			return _moveSpeedProperty.value;
		}
		
		override public function destroy():void
		{
			super.destroy();
			user.removeEventListener(KeyboardEvent.KEY_UP, onKeyDown);
		}		
	}
}