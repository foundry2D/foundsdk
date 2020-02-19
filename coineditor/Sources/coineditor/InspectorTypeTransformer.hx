package coineditor;

import haxe.ui.data.transformation.IItemTransformer;
#if found
import echo.data.Options.ShapeOptions;
#end

class InspectorTypeTransformer implements IItemTransformer<Dynamic> {
    public function new() {
    }

    public function transformFrom(data:Dynamic):Dynamic {
        var o:Dynamic = null;
        if (Std.is(data, String)) {
            o = { tfield: data };
        } else if (Std.is(data, Int) || Std.is(data, Float) || Std.is(data, Bool)) {
            o = { value: data };
        } else if(Reflect.hasField(data,"type") && Reflect.hasField(data,"class_name")){//TTrait
            var par:Array<String>=[];
            if(Reflect.hasField(data,"props")){
                var a:Array<String> = data.props; 
                for(p in a){
                    par.push(this.transformFrom(p));
                }
            }
            var name = "";
            if(data.type == "VisualScript"){
                var t:Array<String> = data.class_name.split("/");
                name = t[t.length-1].split('.')[0];
            } else {
                var t:Array<String> = data.class_name.split(".");
                name = t[t.length-1];
            }
            o = {type: "img/"+data.type.toLowerCase(), name: name,nameClass: data.class_name,props: par};
        }else if(Reflect.hasField(data,"kinematic") && Reflect.hasField(data,"mass")){
            o = {};
            for(field in Reflect.fields(data)){
                if(field != "shapes")
                    Reflect.setField(o,field,this.transformFrom(Reflect.field(data,field)));
            }
            var par:Array<Dynamic>=[];
            if(Reflect.hasField(data,"shapes")){
                var a:Array<ShapeOptions> = data.shapes; 
                for(p in a){
                    par.push(this.transformFrom(p));
                }
                o.shapes = par;
            }
        }else if(Reflect.hasField(data,"solid") && Reflect.hasField(data,"type")){
            o = {};
            for( field in Reflect.fields(data)){
                if(field != "width" && field != "height")
                    Reflect.setField(o,field,this.transformFrom(Reflect.field(data,field)));
                else
                    Reflect.setField(o,field.charAt(0),this.transformFrom(Reflect.field(data,field)));
            }
        }else {
            o = data;
        }
        return o;
    }

}