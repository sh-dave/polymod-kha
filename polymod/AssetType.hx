package polymod;

@:enum abstract AssetType(String) to String {
    var SOUND = 'sound';
    var IMAGE = 'image';
    var FONT = 'font';
    var BINARY = 'binary';
    var TEXT = 'text';
}
