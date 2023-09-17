import MetalKit


class Renderer {
    
    static var device : MTLDevice!
    static var commandQueue : MTLCommandQueue!
    static var library : MTLLibrary!
    
    
    init() {
        
        Renderer.device = MTLCreateSystemDefaultDevice()
        Renderer.commandQueue = Renderer.device.makeCommandQueue()
        
        
        
        
        
        
    }
    
}
