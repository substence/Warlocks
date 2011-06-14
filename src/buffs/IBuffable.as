package buffs
{
	public interface IBuffable
	{
		function addBuff(buff:Buff):Boolean;
		function removeBuff(buff:Buff):void;
		function get buffs():Vector.<Buff>;
	}
}