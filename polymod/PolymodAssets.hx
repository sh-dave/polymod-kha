package polymod;

import polymod.library.ModAssetLibrary;

import kha.Image;
import kha.AssetError;

class PolymodAssets {
    static var libs: Map<String, AssetLibrary> = new Map();

    static var loadImageFromPathOrg: String -> Bool -> (Image -> Void) -> (AssetError -> Void) -> haxe.PosInfos -> Void;

    public static function registerLibrary( id: String, lib: AssetLibrary ) {
        trace('foo2');
        libs.set(id, lib);

        // update kha.Assets.images, blobs, sounds, videos, fonts
        // update kha.Assets.loadImageFromPath

        var assets = kha.Assets;

        loadImageFromPathOrg = assets.loadImageFromPath;

        var f = function( path: String, readable: Bool, done: Image -> Void, ?failed: AssetError -> Void, ?pos: haxe.PosInfos ) {
            trace('foo');
        }

        Reflect.setField(assets, 'loadImageFromPath', f);

        kha.Assets.loadImageFromPath('foo', false, null, null);
    }

    // public static function listLibraryFiles( id: String ) : Array<String> {
    // }

    public static function getLibrary( id ) : Null<AssetLibrary> {
        return libs.get(id);
    }
}
