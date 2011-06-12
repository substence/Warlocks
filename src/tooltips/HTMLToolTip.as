package tooltips
{
	import mx.controls.ToolTip;
	
	public class HTMLToolTip extends ToolTip
	{
		override protected function commitProperties():void
		{  
			super.commitProperties();  
			textField.htmlText = text;  
		} 
	}
}