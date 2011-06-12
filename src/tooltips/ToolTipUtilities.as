package tooltips
{
	public class ToolTipUtilities
	{
		public static function getVariableText(value:Number):String
		{
			return "<font color='#0000FF'><b>" + Math.round(value) + "</b></font>";
		}
	}
}