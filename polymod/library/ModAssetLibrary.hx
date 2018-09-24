/**
 * Copyright (c) 2018 Level Up Labs, LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 *
 */

package polymod.library;

import haxe.xml.Fast;
import haxe.xml.Printer;
import haxe.io.Bytes;
import polymod.library.Util.MergeRules;
import polymod.AssetLibrary;
import polymod.AssetType;
#if unifill
import unifill.Unifill;
#end

typedef ModAssetLibraryParams = {
	/**
	 * full path to the mod's root directory
	 */
	dir:String,

	/**
	 * (optional) if we can't find something, should we try the default asset library?
	 */
	?fallback:AssetLibrary,

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

/**
 *
 * @author
 */
class ModAssetLibrary extends AssetLibrary
{
	/****VARS****/

	private var type(default, null) = new Map<String,AssetType>();

	private var dir:String;
	private var dirs:Array<String> = null;
	private var fallBackToDefault:Bool = true;
	private var fallback:AssetLibrary = null;
	private var mergeRules:MergeRules = null;
	private var ignoredFiles:Array<String> = null;

	/****PUBLIC****/

	/**
	 * Activating a mod is as simple as substituting the default asset library for this one!
	 * @param	params
	 */

	public function new(params:ModAssetLibraryParams)
	{
		dir = params.dir;
		if (params.dirs != null)
		{
			dirs = params.dirs;
		}
		fallback = params.fallback;
		mergeRules = params.mergeRules;
		ignoredFiles = params.ignoredFiles != null ? params.ignoredFiles.copy() : [];
		super();
		fallBackToDefault = fallback != null;
		init();
	}

	public override function exists (id:String, type:String):Bool
	{
		var e = check(id, type);
		if (!e && fallBackToDefault)
		{
			return fallback.exists(id, type);
		}
		return e;
	}

	public override function getAudioBuffer (id:String):AudioBuffer
	{
		// if (check(id))
		// {
		// 	return AudioBuffer.fromFile (file(id));
		// }
		// else if(fallBackToDefault)
		// {
		// 	return fallback.getAudioBuffer(id);
		// }
		return null;
	}

	public override function getBytes (id:String):Bytes
	{
		// if (check(id))
		// {
		// 	#if (openfl >= "8.0.0")
		// 	return Bytes.fromFile (file(id));
		// 	#else
		// 	return Bytes.readFile (file(id));
		// 	#end
		// }
		// else if (fallBackToDefault)
		// {
		// 	return fallback.getBytes(id);
		// }
		return null;
	}

	/**
	 * Get text without consideration of any modifications
	 * @param	id
	 * @param	theDir
	 * @return
	 */
	public function getTextDirectly (id:String, directory:String = ""):String
	{
		// var bytes = null;

		// if (checkDirectly(directory,id))
		// {
		// 	#if (openfl >= "8.0.0")
		// 	bytes = Bytes.fromFile (file(id, directory));
		// 	#else
		// 	bytes = Bytes.readFile (file(id, directory));
		// 	#end
		// }
		// else if (fallBackToDefault)
		// {
		// 	bytes = fallback.getBytes(id);
		// }

		// if (bytes == null)
		// {
		// 	return null;
		// }
		// else
		// {
		// 	return bytes.getString (0, bytes.length);
		// }

		return null;
	}

	public override function getFont (id:String):Font
	{
		// if (check(id))
		// {
		// 	return Font.fromFile (file(id));
		// }
		// else if (fallBackToDefault)
		// {
		// 	return fallback.getFont(id);
		// }
		return null;
	}

	public override function getImage (id:String):Image
	{
		// if (check(id))
		// {
		// 	return Image.fromFile (file(id));
		// }
		// else if (fallBackToDefault)
		// {
		// 	return fallback.getImage(id);
		// }
		return null;
	}


	public override function getPath (id:String):String
	{
		// if (check(id))
		// {
		// 	return file(id);
		// }
		// else if (fallBackToDefault)
		// {
		// 	return fallback.getPath(id);
		// }
		return null;
	}


	public override function getText (id:String):String
	{
		var modText = null;

		if (check(id))
		{
			modText = super.getText(id);
		}
		else if (fallBackToDefault)
		{
			modText = fallback.getText(id);
		}

		if (modText != null)
		{
			var theDirs = dirs != null ? dirs : [dir];
			modText = Util.mergeAndAppendText(modText, id, theDirs, getTextDirectly, mergeRules);
		}

		return modText;
	}

	public override function loadBytes (id:String):Future<Bytes>
	{
		// if (check(id))
		// {
		// 	return Bytes.loadFromFile (file(id));
		// }
		// else if (fallBackToDefault)
		// {
		// 	return fallback.loadBytes(id);
		// }
		// return Bytes.loadFromFile("");
        return null;
	}

	public override function loadFont(id:String):Future<Font>
	{
		// if (check(id)) {

		// 	#if (js && html5)
		// 	return Font.loadFromName (paths.get (file(id)));
		// 	#else
		// 	return Font.loadFromFile (paths.get (file(id)));
		// 	#end

		// } else if (fallBackToDefault) {

		// 	return fallback.loadFont(id);

		// }
		// #if (js && html5)
		// return Font.loadFromName (paths.get (""));
		// #else
		// return Font.loadFromFile (paths.get (""));
		// #end
        return null;
	}

	public override function loadImage(id:String):Future<Image>
	{
		// if (check(id)) {

		// 	return Image.loadFromFile(file(id));

		// } else if(fallBackToDefault) {

		// 	return fallback.loadImage(id);

		// }
		// return Image.loadFromFile("");
        return null;
	}

	public override function loadAudioBuffer(id:String)
	{
		// if (check(id)) {

		// 	//return
		// 	if (pathGroups.exists(file(id))) {

		// 		return AudioBuffer.loadFromFiles (pathGroups.get(file(id)));

		// 	} else {

		// 		return AudioBuffer.loadFromFile(paths.get(file(id)));

		// 	}

		// } else if (fallBackToDefault) {

		// 	return fallback.loadAudioBuffer(id);

		// }
		// return AudioBuffer.loadFromFile("");
        return null;
	}

	public override function loadText(id:String):Future<String>
	{
		// if (check(id)) {

		// 	var request = new HTTPRequest<String> ();
		// 	return request.load (paths.get (file(id)));

		// }
		// else if (fallBackToDefault) {

		// 	return fallback.loadText(id);

		// }
		// var request = new HTTPRequest<String> ();
		// return request.load ("");
        return null;
	}

	public override function isLocal (id:String, type:String):Bool
	{
		if (check(id))
		{
			return true;
		}
		else if (fallBackToDefault)
		{
			return fallback.isLocal(id, type);
		}
		return false;
	}

	public function listModFiles (type:String):Array<String>
	{
		var requestedType = type != null ? cast (type, AssetType) : null;
		var items = [];

		for (id in this.type.keys ())
		{
			if (id.indexOf("_append") == 0 || id.indexOf("_merge") == 0) continue;
			if (requestedType == null || exists (id, requestedType))
			{
				items.push (id);
			}
		}

		return items;
	}

	public override function list (type:String):Array<String>
	{
		var otherList = fallBackToDefault ? fallback.list(type) : [];

		var requestedType = type != null ? cast (type, AssetType) : null;
		var items = [];

		for (id in this.type.keys ())
		{
			if (id.indexOf("_append") == 0 || id.indexOf("_merge") == 0) continue;
			if (requestedType == null || exists (id, requestedType))
			{
				items.push (id);
			}
		}

		for (otherId in otherList)
		{
			if (items.indexOf(otherId) == -1)
			{
				if (requestedType == null || fallback.exists(otherId, type))
				{
					items.push(otherId);
				}
			}
		}

		return items;
	}

    // TODO (DK)
	private function clearCache()
	{
		// OpenFLAssets.cache.clear();

		// for (key in LimeAssets.cache.audio.keys())
		// {
		// 	LimeAssets.cache.audio.remove(key);
		// }
		// for (key in LimeAssets.cache.font.keys())
		// {
		// 	LimeAssets.cache.font.remove(key);
		// }
		// for (key in LimeAssets.cache.image.keys())
		// {
		// 	LimeAssets.cache.image.remove(key);
		// }

		// for (key in cachedAudioBuffers.keys())
		// {
		// 	cachedAudioBuffers.remove(key);
		// }
		// for (key in cachedBytes.keys())
		// {
		// 	cachedBytes.remove(key);
		// }
		// for (key in cachedFonts.keys())
		// {
		// 	cachedFonts.remove(key);
		// }
		// for (key in cachedImages.keys())
		// {
		// 	cachedImages.remove(key);
		// }
		// for (key in cachedText.keys())
		// {
		// 	cachedText.remove(key);
		// }
	}

	private function init():Void
	{
		clearCache();
		type = new Map<String, AssetType>();
		if (dirs != null)
		{
			for (d in dirs)
			{
				_initMod(d);
			}
		}
		else
		{
			_initMod(dir);
		}
	}

	private function _initMod(d:String):Void
	{
		if (d == null) return;

		var all:Array<String> = null;

		if (d == "" || d == null)
		{
			all = [];
		}

		try
		{
			if (PolymodFileSystem.exists(d))
			{
				all = PolymodFileSystem.readDirectoryRecursive(d);
			}
			else
			{
				all = [];
			}
		}
		catch (msg:Dynamic)
		{
			throw new Error("ModAssetLibrary._initMod(" + dir + ") failed : " + msg);
		}
		for (f in all)
		{
			var doti = Util.uLastIndexOf(f,".");
			var ext:String = doti != -1 ? f.substring(doti+1) : "";
			ext = ext.toLowerCase();
			switch(ext)
			{
				case "mp3", "ogg", "wav": type.set(f, AssetType.SOUND);
				case "jpg", "png":type.set(f, AssetType.IMAGE);
				case "txt", "xml", "json", "tsv", "csv", "mpf", "tsx", "tmx", "vdf": type.set(f, AssetType.TEXT);
				case "ttf", "otf": type.set(f, AssetType.FONT);
				default: type.set(f, AssetType.BINARY);
			}
		}
	}

	/**
	 * Check if the given asset exists
	 * (If using multiple mods, it will return true if ANY of the mod folders contains this file)
	 * @param	id
	 * @return
	 */
	private function check(id:String, type:String=null):Bool
	{
		if(ignoredFiles.length > 0 && ignoredFiles.indexOf(id) != -1) return false;
		var exists = false;
		id = Util.stripAssetsPrefix(id);
		if (dirs == null)
		{
			exists = PolymodFileSystem.exists(dir + Util.sl() + id);
		}
		else
		{
			for (d in dirs)
			{
				if (PolymodFileSystem.exists(d + Util.sl() + id))
				{
					exists = true;
				}
			}
		}
		if (exists && type != null && type != BINARY)
		{
			exists = (this.type.get(id) == type);
		}
		return exists;
	}

	private function checkType(id:String):AssetType
	{
		if (this.type.exists(id))
		{
			var value = this.type.get(id);
			if (value != null)
			{
				return value;
			}
		}
		if (fallBackToDefault)
		{
			return @:privateAccess fallback.types.get(id);
		}
		return null;
	}

	private function checkDirectly(dir:String,id:String):Bool
	{
		id = Util.stripAssetsPrefix(id);
		if (dir == null || dir == "")
		{
			return PolymodFileSystem.exists(id);
		}
		else
		{
			var thePath = Util.uCombine([dir, Util.sl(), id]);
			if (PolymodFileSystem.exists(thePath))
			{
				return true;
			}
		}
		return false;
	}

	/**
	 * Get the filename of the given asset id
	 * (If using multiple mods, it will check all the mod folders for this file, and return the LAST one found)
	 * @param	id
	 * @return
	 */
	private function file(id:String, theDir:String = ""):String
	{
		id = Util.stripAssetsPrefix(id);

		if (theDir != "")
		{
			return theDir + Util.sl() + id;
		}
		else if (dirs == null)
		{
			return dir + Util.sl() + id;
		}
		else
		{
			var theFile = "";
			for (d in dirs)
			{
				var thePath = d + Util.sl() + id;
				if (PolymodFileSystem.exists(thePath))
				{
					theFile = thePath;
				}
			}
			return theFile;
		}
		return id;
	}
}
