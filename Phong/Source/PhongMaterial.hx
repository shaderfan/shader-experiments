package;

import away3d.materials.MaterialBase;
import away3d.materials.passes.MaterialPassBase;
import away3d.core.managers.Stage3DProxy;
import away3d.cameras.Camera3D;
import away3d.core.base.IRenderable;

import openfl.Vector;
import openfl.geom.Matrix3D;
import openfl.display3D.Context3DProgramType;
import openfl.display3D.Context3D;

class PhongMaterial extends MaterialBase {
  public function new() {
    super();
    addPass(new PhongPass());
  }
}

class PhongPass extends MaterialPassBase {
  private var data:Vector<Float>;
  private var mat:Matrix3D;

  public function new() {
    super();

    mat = new Matrix3D();

    data = new Vector();
    data.push(0.0);
    data.push(1.0);
    data.push(0.0);
    data.push(1.0);
  }

  override public function getVertexCode():String {
    return '

      m44 op, va0, vc0

    ';
  }

  override public function getFragmentCode(animCode:String):String {
    return '

      mov oc, fc0

    ';
  }

  override public function activate(stage3DProxy:Stage3DProxy, camera:Camera3D):Void {
    super.activate(stage3DProxy,camera);
    stage3DProxy._context3D.setProgramConstantsFromVector(
      Context3DProgramType.FRAGMENT, 0, data, 1);
  }

  override public function render(renderable:IRenderable, 
                                  stage3DProxy:Stage3DProxy, 
                                  camera:Camera3D, 
                                  viewProjection:Matrix3D) {

    var ctx:Context3D = stage3DProxy._context3D;

    mat.copyFrom(renderable.sceneTransform);
    mat.append(viewProjection);

    renderable.activateVertexBuffer(0, stage3DProxy);
    ctx.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 0, mat, true);
    ctx.drawTriangles(renderable.getIndexBuffer(stage3DProxy), 0, renderable.numTriangles);
  }

  override public function deactivate(stage3DProxy:Stage3DProxy):Void {
    super.deactivate(stage3DProxy);
  }

}
