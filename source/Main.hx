package;

import openfl.display.Sprite;
import openfl.events.Event;
import openfl.text.TextField;
import openfl.text.TextFormat;
import sys.FileSystem;

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

        var path = "/storage/emulated/0/TestStorageFolder";

        try {
            if (!FileSystem.exists(path)) {
                FileSystem.createDirectory(path);
            }
            showText("SUCCESS\nFolder created.");
        } catch (e:Dynamic) {
            showText("FAILED\n" + e);
        }
    }

    function showText(msg:String):Void {
        var tf = new TextField();
        tf.defaultTextFormat = new TextFormat("_sans", 28, 0xFFFFFF);
        tf.width = stage.stageWidth;
        tf.height = stage.stageHeight;
        tf.text = msg;
        addChild(tf);
    }
}
