package;

/**
 * An interface for objects that activate/deactivate when another
 * given object is triggered.
 * @author
 */
interface Receiver 
{
	public function activate():Void;
	public function deactivate():Void;
}