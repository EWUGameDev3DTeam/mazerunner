/**
 * This class provides a static reference to the Stage that can be accessed from any time, anywhere.
 * 
 * @author	Nate Chatellier, natejc@natejc.com
 * 
 * @see		http://blog.natejc.com
 * 
 * Released under the MIT License:
 * Copyright (c) 2008 Nate Chatellier
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

package com.natejc.utils
{
	import flash.display.Stage;

	
// **********************************************************************************
// **********************************************************************************


	/**
	 * This class provides a static reference to the Stage that can be accessed from any time, anywhere.
	 * 
	 * @usage	Make sure you set StageRef.stage (usually in the Document Class's constructor) before attempting to get the value.
	 * 
	 * @author	Nate Chatellier
	 */
	public class StageRef
	{
		protected static var	_stage	:Stage;		// Stores the reference to the Stage.
		
		
	// **********************************************************************************

		
		/**
		 * Constructs the StageRef object. This class is a static class and should not be instantiated.
		 */
		public function StageRef()
		{
			throw new Error("StageRef is a static class and should not be instantiated.");

		} // END CONSTRUCTOR
		
		
	// **********************************************************************************
	
	
		/**
		 * Gets/Sets the stage reference.
		 *
		 * @param	stageRef	The static stage reference.
		 * @return				The static stage reference.
		 */
		public static function get stage():Stage
		{
			return _stage;
		} // END FUNCTION GET stage
	
		
	// **********************************************************************************
		
	
		public static function set stage(stageRef:Stage):void
		{
			_stage = stageRef;
		} // END FUNCTION SET stage
		
		
// **********************************************************************************
// **********************************************************************************


	} // END CLASS StageRef
} // END PACKAGE

