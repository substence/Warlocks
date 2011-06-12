package skills
{
	public interface ISkill
	{
		function get level():Number;
		function upgrade():void;
		function downgrade():void;
	}
}