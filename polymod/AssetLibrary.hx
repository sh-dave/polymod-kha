package polymod;

import haxe.io.Bytes; // lime.utils.Bytes
import polymod.PolymodCore.PolymodError;

class Error {
    public function new( msg: String ) {
    }
}

class AudioBuffer {
}

class Font {
}

class Image {
}

class Future<T> {
}

class AssetLibrary {
    var types: Map<String, Dynamic>;

    public function new() {
		trace('foo');
	}

	public function exists (id:String, type:String):Bool { return false; }
	public function getAudioBuffer (id:String):AudioBuffer { return null; }
	public function getBytes (id:String):Bytes { return null; }
	public function getFont (id:String):Font { return null; }
	public function getImage (id:String):Image { return null; }
	public function getPath (id:String):String { return null; }
	public function getText (id:String):String { return null; }
	public function loadBytes (id:String):Future<Bytes> { return null; }
	public function loadFont(id:String):Future<Font> { return null; }
	public function loadImage(id:String):Future<Image> { return null; }
	public function loadAudioBuffer(id:String) {}
	public function loadText(id:String):Future<String> { return null; }
	public function isLocal (id:String, type:String):Bool { return false; }
	public function list (type:String):Array<String> { return null; }
}
