package
{
	import com.mistermartinez.core.MML;
	import com.mistermartinez.utils.UpdateHandler;
	
	import flash.display.Sprite;
	
	import skills.ActivatableClickProjectileSkill;
	import skills.ActivatableSkill;
	
	import ui.oldWarlockUI;
	
	[SWF(width="640", height="480", frameRate="50", backgroundColor="#000000")]	
	public class Warlocks extends Sprite
	{
		public function Warlocks()
		{
			MML.initialize(this.stage);
			var gd:GameDirector = new GameDirector();
			UpdateHandler.instance.addUpdatee(gd);
		}
	}
}