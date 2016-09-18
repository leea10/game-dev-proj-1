package;

/**
 * Interface for objects that have a direct affect
 * on another object when triggered.
 * @author ...
 */
interface Trigger  
{
	public var _receiver:Receiver;
	public function trigger():Void;
}