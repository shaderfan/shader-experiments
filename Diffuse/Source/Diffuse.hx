package;

import away3d.containers.*;
import away3d.entities.*;
import away3d.materials.*;
import away3d.primitives.*;
import away3d.utils.*;
import away3d.primitives.SphereGeometry;
//import away3d.materials.ColorMaterial;

import openfl.display.*;
import openfl.events.*;
import openfl.geom.Vector3D;
import openfl.Lib.getTimer;

import DiffuseMaterial;

class Diffuse extends Sprite {
  //engine variables
  private var _view:View3D;
  
  //scene objects
  private var _plane:Mesh;

  private var sphere:Mesh;

  private var thn:Int;
  private var now:Int;
  private var amt:Int;
  
  /**
   * Constructor
   */
  public function new() {
    super();
    
    stage.scaleMode = StageScaleMode.NO_SCALE;
    stage.align = StageAlign.TOP_LEFT;
    
    //setup the view
    _view = new View3D();
    addChild(_view);
    
    //setup the camera
    _view.camera.z = -600;
    _view.camera.y = 500;
    _view.camera.lookAt(new Vector3D());
    
    //setup the scene
    /*
    _plane = new Mesh(new PlaneGeometry(700, 700), new TextureMaterial(Cast.bitmapTexture("assets/floor_diffuse.jpg")));
    _view.scene.addChild(_plane);
    */

    sphere = new Mesh(
      new SphereGeometry(100,8,8),
      new DiffuseMaterial()
    );

    _view.scene.addChild(sphere);

    addChild(new away3d.debug.AwayStats(_view));

    thn = getTimer();
    amt = 0;
    
    //setup the render loop
    addEventListener(Event.ENTER_FRAME, _onEnterFrame);
    stage.addEventListener(Event.RESIZE, onResize);
    onResize();
  }
  
  /**
   * render loop
   */
  private function _onEnterFrame(e:Event):Void {
    now = getTimer();
    amt += now - thn;
    thn = now;
    while(amt >= 16) {
      sphere.rotationY += 1;
      amt -= 16;
    }
    
    _view.render();
  }
  
  /**
   * stage listener for resize events
   */
  private function onResize(event:Event = null):Void
  {
    _view.width = stage.stageWidth;
    _view.height = stage.stageHeight;
  }
}
