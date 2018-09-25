package polymod.fs;

import polymod.library.Util;

class ElectronFileSystem {
    static var fs: Dynamic = untyped require('fs');
    static var cwd = untyped require('electron').remote.app.getAppPath();

    public function new() {
    }

    public static function exists( path: String ) : Bool {
        return fs.existsSync('$cwd/$path');
    }

    public static function isDirectory( path: String ) : Bool {
        var p = '$cwd/$path';
        return fs.existsSync(p) && fs.lstatSync(p).isDirectory();
    }

    public static function readDirectory( path: String ) : Array<String> {
        return fs.readdirSync('$cwd/$path');
    }

    public static function readDirectoryRecursive( path: String ) : Array<String> {
		var all = _readDirectoryRecursive(path);

        for (i in 0...all.length) {
			var f = all[i];
			var stri = Util.uIndexOf(f, '$path/');

			if (stri == 0) {
				f = Util.uSubstr(f, Util.uLength('$path/'), Util.uLength(f));
				all[i] = f;
			}
		}
		return all;
    }


    public static function getFileContent( path: String ) : String {
        return fs.readFileSync('$cwd/$path', { encoding: 'utf8' });
    }

	static function _readDirectoryRecursive( path: String ) : Array<String> {
		if (exists(path) && isDirectory(path)) {
			var all = readDirectory(path);

            if (all == null) {
                return [];
            }

			var results = [];

            for (thing in all) {
				if (thing == null) {
                    continue;
                }

				var pathToThing = path + Util.sl() + thing;

                if (isDirectory(pathToThing)) {
					var subs = _readDirectoryRecursive(pathToThing);

                    if (subs != null) {
						results = results.concat(subs);
					}
				} else {
					results.push(pathToThing);
				}
			}

			return results;
		}

		return [];
	}
}
