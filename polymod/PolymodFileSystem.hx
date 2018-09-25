package polymod;

#if kha_debug_html5
typedef PolymodFileSystem = polymod.fs.ElectronFileSystem;
#elseif kha_kore
typedef PolymodFileSystem = polymod.fs.SysFileSystem;
#end
