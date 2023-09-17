import MetalKit

class Core : NSObject{
    
    var renderer : Renderer
    
    
    init(metalView : MTKView){
        
        
        self.renderer = Renderer()
        
        
        super.init()
        
        metalView.delegate = self
        
    }
    
}
extension Core : MTKViewDelegate  {
    func mtkView(_ view: MTKView, drawableSizeWillChange _: CGSize) {}
    
    func draw(in view: MTKView) {
    
        
        
        
        
    }
    
}
