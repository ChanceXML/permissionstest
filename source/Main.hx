package;

import openfl.display.Sprite;
import openfl.events.Event;
import openfl.Lib;
import sys.FileSystem;
import sys.io.File;
import openfl.text.TextField;
import openfl.text.TextFormat;

#if android
import openfl.permissions.Permissions;
#end

class Main extends Sprite {

    public function new() {
        super();
        addEventListener(Event.ADDED_TO_STAGE, init);
    }

    function init(e:Event):Void {
        removeEventListener(Event.ADDED_TO_STAGE, init);

        #if android
        Permissions.requestPermission("android.permission.WRITE_EXTERNAL_STORAGE");
        #end

        var basePath = "/storage/emulated/0/CodenameEngine-v1.0.1";

        try {
            if (!FileSystem.exists(basePath)) {
                FileSystem.createDirectory(basePath);
            }

            if (!FileSystem.exists(basePath + "/assets")) {
                FileSystem.createDirectory(basePath + "/assets");
            }

            if (!FileSystem.exists(basePath + "/mods")) {
                FileSystem.createDirectory(basePath + "/mods");
            }

            showMessage("SUCCESS!\nFolders created.");
        } catch (e:Dynamic) {
            showMessage("FAILED:\n" + e);
        }
    }

    function showMessage(msg:String):Void {
        var tf = new TextField();
        tf.defaultTextFormat = new TextFormat("_sans", 28, 0xFFFFFF);
        tf.width = stage.stageWidth;
        tf.height = stage.stageHeight;
        tf.text = msg;
        addChild(tf);
    }
}
