package com.natejc.utils
{
	import flash.display.FrameLabel;
	import flash.display.MovieClip;


	/**
	 * A group of simple display related utilities.
	 * 
	 * @author	Nate Chatellier
	 */
	public class DisplayUtils
	{
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * This acts the same as addFrameScript, except that it works with a frame label instead of a frame number. 
		 * It connects a particular frame label to execute a function whenever the playhead of the MovieClip reaches that frame label.
		 * Note: this connection should only ever happen once, likely when the object is constructed.
		 * Warning: Connecting a frame script in this way will override any other code already on the timeline (such as a <code>stop()</code> command).
		 * Warning: Using this function (or the addFrameScript function) can prevent your object from being garbage collected. Pass null as the $functionToExecute to get around this during cleanup.
		 *
		 * @param	$mc						The MovieClip that contains the frame label.
		 * @param	$sFrameLabel			The name of the frame label that should trigger the function call.
		 * @param	$functionToExecute		The function that is to be executed when the frame label is reached.
		 */
		public static function addLabelScript($mc:MovieClip, $sFrameLabel:String, $functionToExecute:Function):void
		{
			var aLabels:Array = $mc.currentLabels;
			
			for (var i:uint = 0; i < aLabels.length; i++)
			{
				if (FrameLabel(aLabels[i]).name == $sFrameLabel)
				{
					$mc.addFrameScript(FrameLabel(aLabels[i]).frame - 1, $functionToExecute);
					return;
				}
			}
			
			trace("*** WARNING in DisplayUtils::addLabelScript() --> The frame label \"" + $sFrameLabel + "\" does not exist on " + $mc);
		}
		
		/* ---------------------------------------------------------------------------------------- */

	}
}

