package
{
	import com.mistermartinez.interfaces.IUpdatable;
	import com.mistermartinez.math.Vector2D;
	import com.mistermartinez.utils.UIHandler;
	import com.mistermartinez.utils.sceneHandler.SceneHandler;
	import com.mistermartinez.utils.sceneHandler.SceneLayersLibrary;
	
	import components.CKeyboardControl;
	
	import players.Warlock;
	
	import skills.ActivatableClickProjectileSkill;
	import skills.finalSkills.FireballSkill;
	import skills.finalSkills.LinkSkill;
	import skills.finalSkills.TeleportSkill;
	import skills.finalSkills.WindWalkSkill;
	
	import terrains.GenericLavaTerrainLayer;
	import terrains.GenericTerrainLayer;
	import terrains.Terrain;
	
	import users.User;

	public class GameDirector implements IUpdatable
	{
		public static const MATCH_DURATION:Number = 20 * 60;
		public var warlocks:Vector.<Warlock>;
		public var user:User;
		public var ai:User;
		public var terrain:Terrain;
		
		public function GameDirector()
		{
/*			terrain = new Terrain(200);
			var terrainLayer:GenericTerrainLayer = new GenericTerrainLayer(new Vector2D(640, 480));
			terrain.addLayer(new GenericLavaTerrainLayer(new Vector2D(640, 480)));
			terrain.addLayer(terrainLayer);
			terrain.activeLayer = terrainLayer;
			SceneLayersLibrary.foreground.addChild(terrain.graphic);*/
			//
			warlocks = new Vector.<Warlock>();
			user = setupUser(new User(), new Vector2D(320, 100));
			user.addComponent(new CKeyboardControl(user));
			user.warlock.addSkill(new FireballSkill());
			user.warlock.addSkill(new TeleportSkill());
			user.warlock.addSkill(new WindWalkSkill());
			user.warlock.addSkill(new LinkSkill());
			user.warlock.addComponent(new CKeyboardControl(user));
			ai = setupUser(new User(0x00FF00), new Vector2D(320, 200));
			//UIHandler.instance.changeUI(new UIPlaying(this));
		}
		
		public function update():void
		{
			user.update();
			ai.update();
			//terrain.update();
		}
		
		private function setupUser(user:User, position:Vector2D):User
		{
			var warlock:Warlock = new Warlock(position, user);
			SceneHandler.instance.addChildByLabel(warlock.graphic, SceneLayersLibrary.FOREGROUND);
			user.warlock = warlock;
			warlocks.push(warlock);
			return user;
		}
	}
}