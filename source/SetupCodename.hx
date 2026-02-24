package;

import openfl.display.Sprite;
import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.Lib;
import openfl.events.Event;
import sys.io.File;
import sys.FileSystem;

class SetupCodename extends Sprite {

    private var status:TextField;

    public function new() {
        super();
        addEventListener(Event.ADDED_TO_STAGE, init);
    }

    private function init(e:Event):Void {
        removeEventListener(Event.ADDED_TO_STAGE, init);

        // Create popup text
        status = new TextField();
        status.defaultTextFormat = new TextFormat(null, 20, 0xFFFFFF);
        status.width = stage.stageWidth;
        status.height = 50;
        status.y = stage.stageHeight / 2 - 25;
        status.text = "Starting setup...";
        addChild(status);

        // Request storage permission for Android
        #if android
        import lime.system.JNI;
        import lime.system.System;
        var perms = ["android.permission.READ_EXTERNAL_STORAGE", "android.permission.WRITE_EXTERNAL_STORAGE"];
        for (perm in perms) {
            var granted = JNI.callStaticMethod("org/haxe/lime/GameActivity", "checkPermission", "(Ljava/lang/String;)Z", [perm]);
            if (!granted) {
                JNI.callStaticMethod("org/haxe/lime/GameActivity", "requestPermission", "(Ljava/lang/String;I)V", [perm, 0]);
            }
        }
        #end

        setupFolders();
    }

    private function setupFolders():Void {
        var basePath = Sys.systemPath() + "/CodenameEngine-v1.0.1";
        var assetsPath = basePath + "/assets";
        var modsPath = basePath + "/mods";

        // Create folders if they don't exist
        if (!FileSystem.exists(basePath)) {
            FileSystem.createDirectory(basePath);
            status.text = "Created main folder...";
        }
        if (!FileSystem.exists(assetsPath)) {
            FileSystem.createDirectory(assetsPath);
            status.text = "Created assets folder...";
        }
        if (!FileSystem.exists(modsPath)) {
            FileSystem.createDirectory(modsPath);
            status.text = "Created mods folder...";
        }

        // Copy files from original assets/mods if they exist
        var sourceAssets = "assets";
        var sourceMods = "mods";
        copyFolder(sourceAssets, assetsPath);
        copyFolder(sourceMods, modsPath);

        status.text = "Setup complete!";
    }

    private function copyFolder(src:String, dest:String):Void {
        if (!FileSystem.exists(src)) return;

        for (file in FileSystem.readDirectory(src)) {
            var srcFile = src + "/" + file;
            var destFile = dest + "/" + file;

            if (FileSystem.isDirectory(srcFile)) {
                FileSystem.createDirectory(destFile);
                copyFolder(srcFile, destFile);
            } else {
                try {
                    File.copy(srcFile, destFile);
                    status.text = "Copied: " + file;
                } catch(e:Dynamic) {
                    trace("Error copying file: " + file + " - " + e);
                }
            }
        }
    }
}
