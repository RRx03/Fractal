import MetalKit


class Renderer {
    
    static var device : MTLDevice!
    static var commandQueue : MTLCommandQueue!
    static var library : MTLLibrary!
    static var mandelbrot : MandelBrotSettings = MandelBrotSettings(maxItt: MandelBrotPreferences.maxItterations, COffset: [MandelBrotPreferences.initialCOffset[0], MandelBrotPreferences.initialCOffset[1]])
    static var reverseMandelBrot : ReverseMandelBrotSettings = ReverseMandelBrotSettings(maxItt: ReverseMandelBrotPreferences.maxItterations, CConst: [ReverseMandelBrotPreferences.CConst[0], ReverseMandelBrotPreferences.CConst[1]])
    static var common : Common = Common(boundaries: [UInt32(0), UInt32(0)], scale: Preferences.initialScale)
    
    var ComputePipelineStateMandelBrot : MTLComputePipelineState
    var ComputePipelineStateMandelBrotOffset : MTLComputePipelineState
    var ComputePipelineStateReverseMandelBrot : MTLComputePipelineState


    
    
    init(metalView : MTKView) {
        
        Renderer.device = MTLCreateSystemDefaultDevice()
        Renderer.commandQueue = Renderer.device.makeCommandQueue()
        
        
        let library = Renderer.device.makeDefaultLibrary()
        Renderer.library = library
        let MandelBrotFractal = library?.makeFunction(name: "MandelBrot")
        let MandelBrotOffsetFractal = library?.makeFunction(name: "MandelBrotOffset")
        let ReverseMandelBrotFractal = library?.makeFunction(name: "ReverseMandelBrot")


        
        do{
            ComputePipelineStateMandelBrot = try Renderer.device.makeComputePipelineState(function: MandelBrotFractal!)
            ComputePipelineStateMandelBrotOffset = try Renderer.device.makeComputePipelineState(function: MandelBrotOffsetFractal!)
            ComputePipelineStateReverseMandelBrot = try Renderer.device.makeComputePipelineState(function: ReverseMandelBrotFractal!)


        }catch {
         fatalError("Fail")
        }
        
        
        
        
        
    }
    func render (view : MTKView){
        
        guard let commandBuffer = Renderer.commandQueue.makeCommandBuffer() else {return}
        let commandEncoder = commandBuffer.makeComputeCommandEncoder()!
        guard let drawable: CAMetalDrawable = view.currentDrawable else { return }

        switch(Preferences.fractalID){
            
        case 1:
            
            var threadsPerGrid: MTLSize
            var threadsPerThreadgroup: MTLSize

            let w: Int = ComputePipelineStateMandelBrotOffset.threadExecutionWidth
            let h: Int = ComputePipelineStateMandelBrotOffset.maxTotalThreadsPerThreadgroup / w
            
            commandEncoder.setComputePipelineState(ComputePipelineStateMandelBrotOffset)
            commandEncoder.setTexture(drawable.texture, index: 0)
            commandEncoder.setTexture(drawable.texture, index: 1)
            commandEncoder.setBytes(&Renderer.common, length: MemoryLayout<Common>.stride, index: 10)
            commandEncoder.setBytes(&Renderer.mandelbrot, length: MemoryLayout<MandelBrotSettings>.stride, index: 11)
            threadsPerGrid = MTLSize(width: drawable.texture.width, height: drawable.texture.height, depth: 1)
            threadsPerThreadgroup = MTLSize(width: w, height: h, depth: 1)
            commandEncoder.dispatchThreads(threadsPerGrid, threadsPerThreadgroup: threadsPerThreadgroup)
            break;
            
            
        case 2:
            
            var threadsPerGrid: MTLSize
            var threadsPerThreadgroup: MTLSize

            let w: Int = ComputePipelineStateReverseMandelBrot.threadExecutionWidth
            let h: Int = ComputePipelineStateReverseMandelBrot.maxTotalThreadsPerThreadgroup / w
            
            commandEncoder.setComputePipelineState(ComputePipelineStateReverseMandelBrot)
            commandEncoder.setTexture(drawable.texture, index: 0)
            commandEncoder.setTexture(drawable.texture, index: 1)
            commandEncoder.setBytes(&Renderer.common, length: MemoryLayout<Common>.stride, index: 10)
            commandEncoder.setBytes(&Renderer.reverseMandelBrot, length: MemoryLayout<ReverseMandelBrotSettings>.stride, index: 11)
            threadsPerGrid = MTLSize(width: drawable.texture.width, height: drawable.texture.height, depth: 1)
            threadsPerThreadgroup = MTLSize(width: w, height: h, depth: 1)
            commandEncoder.dispatchThreads(threadsPerGrid, threadsPerThreadgroup: threadsPerThreadgroup)
            break;
        
            
            
        default:
            var threadsPerGrid: MTLSize
            var threadsPerThreadgroup: MTLSize

            let w: Int = ComputePipelineStateMandelBrot.threadExecutionWidth
            let h: Int = ComputePipelineStateMandelBrot.maxTotalThreadsPerThreadgroup / w
            
            commandEncoder.setComputePipelineState(ComputePipelineStateMandelBrot)
            commandEncoder.setTexture(drawable.texture, index: 0)
            commandEncoder.setTexture(drawable.texture, index: 1)
            commandEncoder.setBytes(&Renderer.common, length: MemoryLayout<Common>.stride, index: 10)
            commandEncoder.setBytes(&Renderer.mandelbrot, length: MemoryLayout<MandelBrotSettings>.stride, index: 11)
            threadsPerGrid = MTLSize(width: drawable.texture.width, height: drawable.texture.height, depth: 1)
            threadsPerThreadgroup = MTLSize(width: w, height: h, depth: 1)
            commandEncoder.dispatchThreads(threadsPerGrid, threadsPerThreadgroup: threadsPerThreadgroup)
            
        }
        
        
        
        commandEncoder.endEncoding()
        commandBuffer.present(drawable)
        commandBuffer.commit()


        
    }
    
}
