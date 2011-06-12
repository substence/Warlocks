package buffs
{
	public interface IBuffable
	{
		function addBuff(buff:Buff):void;
		function removeBuff(buff:Buff):void;
		function get buffs():Vector.<Buff>;
	}
}