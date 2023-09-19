import MetalKit

class Core : NSObject{
    
    var renderer : Renderer
    
    
    
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
        Renderer.settings.boundaries.x = UInt32(size.width)
        Renderer.settings.boundaries.y = UInt32(size.height)
    }
    
    func draw(in view: MTKView) {
        
        renderer.render(view: view)
        
        
        
    }
    
}
