import MetalKit

class Core : NSObject{
    
    var renderer : Renderer
    var lastTime: Double = CFAbsoluteTimeGetCurrent()

    init(metalView : MTKView){
        
        
        self.renderer = Renderer(metalView: metalView)
        
        
        super.init()
        
        metalView.device = Renderer.device
        metalView.framebufferOnly = false
        metalView.delegate = self
        
    }
    
}
extension Core : MTKViewDelegate  {
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        Renderer.common.boundaries.x = UInt32(size.width)
        Renderer.common.boundaries.y = UInt32(size.height)
    }
    
    func draw(in view: MTKView) {
        
        
        let currentTime = CFAbsoluteTimeGetCurrent()
        let deltaTime = Float(currentTime - lastTime)
        lastTime = currentTime
        
        Renderer.common.scale += Preferences.scaleFactor*deltaTime
        
        if (Preferences.fractalID == 1 || Preferences.fractalID == 0){
            Renderer.mandelbrot.COffset[0] += MandelBrotPreferences.COffsetFactors[0]*deltaTime
            Renderer.mandelbrot.COffset[1] += MandelBrotPreferences.COffsetFactors[1]*deltaTime
        }
        

        renderer.render(view: view)
        
        
        
    }
    
}
