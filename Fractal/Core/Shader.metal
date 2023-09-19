#include "../Application/Common.h"
#include <metal_stdlib>
using namespace metal;

float2 MandelBrotItt(float2 Z, float2 CConst){
    return float2(Z.x*Z.x-Z.y*Z.y+CConst.x, 2*Z.x*Z.y+CConst.y);
}

float ComputeMandelBrot(float2 Z, float2 CConst, uint maxItt){
    uint itt = 0;
    while ((Z.x*Z.x - Z.y*Z.y < 4.0) && itt < maxItt){
        Z = MandelBrotItt(Z, CConst);
        itt+=1;
    }
    float mod = length(Z);
    float smoothValue = float(itt) - log2(max(1.0, (mod)));
    return smoothValue;
    
}

kernel void MandelBrot (texture2d<half, access::read> textureIn [[texture(1)]],
                    texture2d<half, access::write> textureOut [[texture(0)]],
                    constant Common &common [[buffer(10)]],
                    constant MandelBrotSettings &mandelbrot [[buffer(11)]],
                    uint2 id [[thread_position_in_grid]]){
    
    
    float2 SIZE = float2(common.boundaries);
    float2 mandelBrotAffix = 2*(float2(id)-SIZE/2)/(SIZE*common.scale);
    uint grayScale = ComputeMandelBrot(float2(0, 0), mandelBrotAffix, mandelbrot.maxItt);
    float grayNormalised = float(grayScale)/mandelbrot.maxItt;
    textureOut.write(half4(grayNormalised, grayNormalised, grayNormalised, 1), id);

    
    
    
}

kernel void MandelBrotOffset (texture2d<half, access::read> textureIn [[texture(1)]],
                    texture2d<half, access::write> textureOut [[texture(0)]],
                    constant Common &common [[buffer(10)]],
                    constant MandelBrotSettings &mandelbrot [[buffer(11)]],
                    uint2 id [[thread_position_in_grid]]){
    
    
    float2 SIZE = float2(common.boundaries);
    float2 mandelBrotAffix = 2*(float2(id)-SIZE/2)/(SIZE*common.scale);
    uint grayScale = ComputeMandelBrot(mandelbrot.COffset, mandelBrotAffix, mandelbrot.maxItt);
    float grayNormalised = float(grayScale)/mandelbrot.maxItt;
    textureOut.write(half4(grayNormalised, grayNormalised, grayNormalised, 1), id);

    
    
    
}

kernel void ReverseMandelBrot (texture2d<half, access::read> textureIn [[texture(1)]],
                    texture2d<half, access::write> textureOut [[texture(0)]],
                    constant Common &common [[buffer(10)]],
                    constant ReverseMandelBrotSettings &mandelbrot [[buffer(11)]],
                    uint2 id [[thread_position_in_grid]]){
    
    
    float2 SIZE = float2(common.boundaries);
    float2 mandelBrotAffix = 2*(float2(id)-SIZE/2)/(SIZE*common.scale);
    uint grayScale = ComputeMandelBrot(mandelBrotAffix, mandelbrot.CConst, mandelbrot.maxItt);
    float grayNormalised = float(grayScale)/mandelbrot.maxItt;
    textureOut.write(half4(grayNormalised, grayNormalised, grayNormalised, 1), id);

    
    
    
}

