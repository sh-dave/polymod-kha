package polymod;

import polymod.AssetType;
import polymod.library.Util;

#if unifill
import unifill.Unifill;
#end

typedef AssetLibraryParams = {
	/**
	 * full path to the mod's root directory
	 */
	dir:String,

	/**
	 * (optional) if we can't find something, should we try the default asset library?
	 */
	?fallback: Dynamic, // AssetLibrary, // TODO (DK)

	/**
	 * (optional) to combine mods, provide multiple paths to several mod's root directories.
	 * This takes precedence over the "Dir" parameter and the order matters -- mod files will load from first to last, with last taking precedence
	 */
	?dirs:Array<String>,

	/**
	 * (optional) formatting rules for merging various data formats
	 */
	?mergeRules:MergeRules,

	/**
 	 * (optional) list of files it ignore in this mod asset library (get the fallback version instead)
	 */
	 ?ignoredFiles:Array<String>
}

class AssetLibrary {
	public var images: Map<String, String> = new Map();

	public var dir: String;
	public var dirs: Array<String>;
	public var fallBackToDefault = true;
	public var fallback: Dynamic; // AssetLibrary; // TODO (DK)
	public var mergeRules: MergeRules;
	public var ignoredFiles: Array<String>;

	public function new( params: AssetLibraryParams ) {
		dir = params.dir;

		if (params.dirs != null) {
			dirs = params.dirs;
		}

		fallback = params.fallback;
		mergeRules = params.mergeRules;
		ignoredFiles = params.ignoredFiles != null ? params.ignoredFiles.copy() : [];
		fallBackToDefault = fallback != null;
		init();
	}

	public function listModFiles( type: AssetType ) : Array<String> {
		trace('TODO (DK) implement me');
		return [];
	}

	function init() {
		// clearCache();
		// types = new Map<String, AssetType>();

		if (dirs != null) {
			for (d in dirs) {
				initMod(d);
			}
		} else {
			initMod(dir);
		}
	}

	function initMod( d: String ) {
		if (d == null) {
			return;
		}

		var all: Array<String> = [];

		try {
			all = PolymodFileSystem.exists(d)
				? PolymodFileSystem.readDirectoryRecursive(d)
				: [];
		} catch (msg: Dynamic) {
			throw new Error('ModAssetLibrary._initMod($dir) failed : $msg');
		}

		for (f in all) {
			var doti = Util.uLastIndexOf(f,".");
			var ext:String = doti != -1 ? f.substring(doti+1) : "";
			ext = ext.toLowerCase();

			switch ext {
				case "mp3", "ogg", "wav":
					// types.set(f, AssetType.SOUND);
				case "jpg", "png":
					// types.set(f, AssetType.IMAGE);
					images.set(f, f);
				case "txt", "xml", "json", "tsv", "csv", "mpf", "tsx", "tmx", "vdf":
					// types.set(f, AssetType.TEXT);
				case "ttf", "otf":
					// types.set(f, AssetType.FONT);
				default:
					// types.set(f, AssetType.BINARY);
			}
		}
	}
}
