package polymod;

import kha.Image;
import kha.AssetError;

using StringTools;

class PolymodAssets {
    static var libs: Map<String, AssetLibrary> = new Map();

    // static var loadImageFromPathOrg: String -> Bool -> (Image -> Void) -> (AssetError -> Void) -> haxe.PosInfos -> Void;
    static var backupImages: Map<String, Dynamic> = new Map();

    public static function registerLibrary( libId: String, lib: AssetLibrary ) {
        trace('foo2');
        libs.set(libId, lib);

        // update kha.Assets.images, blobs, sounds, videos, fonts
        // update loadImage(), loadImageFromPath(), Assets.images.FIELD, Assets.images.get()

        var assets = kha.Assets;

        for (f in lib.images) {
            var id = f
                .replace('.png', '')
                .replace('.', '_')
                .replace('-', '_')
                .replace('/', '_')
                .replace('\\', '_')
                ;


            var oldCached = Reflect.field(assets.images, id);
            var oldDesc = Reflect.copy(Reflect.field(assets.images, '${id}Description'));
            // var name = Reflect.field(assets.images, '${id}Name');

                // img/bee.png
                    // img_bee -> WebGLImage
                    // img_beeDescription {
                        // files: ['img/bee.png]
                        // name: "img_bee"
                        // original_height: 72
                        // original_width: 72,
                        // type: "image"
                    //}
                    // img_beeName
                    // TODO (DK) where are the Load/Unload functions?


            if (!backupImages.exists(id)) {
                backupImages.set(id, { cached: oldCached, desc: oldDesc/*, name: name*/ });
            }


            // this is missing the ./mod1 folder
            Reflect.setField(assets.images, id, null); // cleared cache // TODO (DK) unload backup image?
            var desc = Reflect.field(assets.images, '${id}Description');

            if (desc != null) {
                Reflect.setField(desc, 'files', ['${lib.dirs[0]}/$f']);
            }
        }

        // openfl.utils.Assets.getBitmapData('foo.png');
            // cached
                // ? from cache
                // : LimeAssets.getImage(id, false);
                    // getAsset(id, IMAGE, useCache)
                        // new LibrarySymbol(id)
                            // ...
                            // symbol.library.getAsset(symbolName, type)
                                // getImage(id)
                                    // Image.fromFile(...)

        // var getImageAPI = kha.Assets.images.get;
        // var getImage = function( id: String ) : Image {
        //     for (l in libs) {
        //         if (l.images.exists(id)) {
        //             var img = l.images.get(id);

        //             if (img != null) {
        //                 return img;
        //             } else {
        //                 kha.LoaderImpl.loadImageFromDescription({}, function( img ) {

        //                 }, function( err ) {

        //                 });

        //                 kha.Assets.loadImage(id, function( img ) {
        //                     l.images.set(id, img);
        //                 });

        //                 return null;
        //             }
        //         }
        //     }

        //     return getImageAPI(id);
        // }

        // Reflect.setField(kha.Assets.images, 'get', getImage);


        // var loadImageFromPathAPI = assets.loadImageFromPath;
        // var loadImageFromPath = function( path: String, readable: Bool, done: Image -> Void, ?failed: AssetError -> Void, ?pos: haxe.PosInfos ) {
        //     // trace('foo');
        //     var foundInMods = false;

        //     if (foundInMods) {

        //     } else {
        //         loadImageFromPathAPI(path, readable, done, failed, pos);
        //     }
        // }
        // Reflect.setField(assets, 'loadImageFromPath', loadImageFromPath);

        // kha.Assets.loadImageFromPath('foo', false, null, null);
    }

    // public static function listLibraryFiles( id: String ) : Array<String> {
    // }

    public static function getLibrary( id ) : Null<AssetLibrary> {
        return libs.get(id);
    }

    public static function clearCache() {
        trace('TODO (DK) implement me');
    }
}
