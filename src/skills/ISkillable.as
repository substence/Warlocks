package skills
{
	public interface ISkillable
	{
		function addSkill(skill:Skill):void;
		function removeSkill(skill:Skill):void;
		function get skills():Vector.<Skill>;
	}
}