import MetalKit


class Renderer {
    
    static var device : MTLDevice!
    static var commandQueue : MTLCommandQueue!
    static var library : MTLLibrary!
    static var mandelbrot : MandelBrotSettings = MandelBrotSettings(boundaries: [UInt32(0), UInt32(0)], scale: 1, CConst: [Preferences.CConst[0], Preferences.CConst[0]], maxItt: Preferences.maxItterations)

    
    var ComputePipelineState : MTLComputePipelineState

    
    
    init(metalView : MTKView) {
        
        Renderer.device = MTLCreateSystemDefaultDevice()
        Renderer.commandQueue = Renderer.device.makeCommandQueue()
        
        
        let library = Renderer.device.makeDefaultLibrary()
        Renderer.library = library
        let kernel = library?.makeFunction(name: "MandelBrot")
        
        do{
            ComputePipelineState = try Renderer.device.makeComputePipelineState(function: kernel!)
        }catch {
         fatalError("Fail")
        }
        
        
        
        
        
    }
    func render (view : MTKView){
        
        guard let commandBuffer = Renderer.commandQueue.makeCommandBuffer() else {return}
        let commandEncoder = commandBuffer.makeComputeCommandEncoder()!
        guard let drawable: CAMetalDrawable = view.currentDrawable else { return }

        
        
        var threadsPerGrid: MTLSize
        var threadsPerThreadgroup: MTLSize

        let w: Int = ComputePipelineState.threadExecutionWidth
        let h: Int = ComputePipelineState.maxTotalThreadsPerThreadgroup / w
        
        commandEncoder.setComputePipelineState(ComputePipelineState)
        commandEncoder.setTexture(drawable.texture, index: 0)
        commandEncoder.setTexture(drawable.texture, index: 1)
        commandEncoder.setBytes(&Renderer.mandelbrot, length: MemoryLayout<MandelBrotSettings>.stride, index: 10)
        threadsPerGrid = MTLSize(width: drawable.texture.width, height: drawable.texture.height, depth: 1)
        threadsPerThreadgroup = MTLSize(width: w, height: h, depth: 1)
        commandEncoder.dispatchThreads(threadsPerGrid, threadsPerThreadgroup: threadsPerThreadgroup)
        
        commandEncoder.endEncoding()
        commandBuffer.present(drawable)
        commandBuffer.commit()


        
    }
    
}
