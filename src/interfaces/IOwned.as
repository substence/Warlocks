package interfaces
{
	import users.User;

	public interface IOwned
	{
		function get owner():User;
	}
}