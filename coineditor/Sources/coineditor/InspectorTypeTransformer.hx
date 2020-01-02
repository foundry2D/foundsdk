package coineditor;

import haxe.ui.data.transformation.IItemTransformer;

class InspectorTypeTransformer implements IItemTransformer<Dynamic> {
    public function new() {
    }

    public function transformFrom(i:Dynamic):Dynamic {
        var o:Dynamic = null;
        if (Std.is(i, String)) {
            o = { tfield: i };
        } else if (Std.is(i, Int) || Std.is(i, Float) || Std.is(i, Bool)) {
            o = { value: i };
        } else if(Reflect.hasField(i,"type") && Reflect.hasField(i,"class_name")){//TTrait
            var par:Array<String>=[];
            if(Reflect.hasField(i,"props")){
                var a:Array<String> = i.props; 
                for(p in a){
                    par.push(this.transformFrom(p));
                }
            }
            var t:Array<String> = i.class_name.split(".");
            o = {type: "img/"+i.type.toLowerCase(), name: t[t.length-1],nameClass: i.class_name,props: par};
        }else {
            o = i;
        }
        return o;
    }

}