package skills
{
	import com.mistermartinez.utils.FrameTimer;
	
	import interfaces.ITimed;

	public interface IActivatable extends ITimed
	{
		function get isActive():Boolean;
		function get isRecharging():Boolean;
		function activate():Boolean;
		function deactivate():void;
	}
}