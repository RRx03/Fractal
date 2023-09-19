#include "../Application/Common.h"
#include <metal_stdlib>
using namespace metal;

float2 MandelBrotItt(float2 Z, float2 CConst){
    return float2(Z.x*Z.x-Z.y*Z.y+CConst.x, 2*Z.x*Z.y+CConst.y);
}

uint ComputeMandelBrot(float2 Z, float2 CConst, uint maxItt){
    uint itt = 0;
    while ((Z.x*Z.x - Z.y*Z.y < 4.0) && itt < maxItt){
        Z = MandelBrotItt(Z, CConst);
        itt+=1;
    }
    return itt;
    
}

kernel void MandelBrot (texture2d<half, access::read> textureIn [[texture(1)]],
                    texture2d<half, access::write> textureOut [[texture(0)]],
                    constant MandelBrotSettings &mandelbrot [[buffer(10)]],
                    uint2 id [[thread_position_in_grid]]){
    
    
    
    
    float2 signedPositions = float2(id)-float2(mandelbrot.boundaries)/2;
    signedPositions /= float2(mandelbrot.boundaries)/2;
    
    float2 Const = float2(signedPositions.x, signedPositions.y)/mandelbrot.scale;
    uint grayScale = ComputeMandelBrot(float2(0, 0), Const, mandelbrot.maxItt);
    float grayValue = float(grayScale)/mandelbrot.maxItt; //Modifier Gradient
    
    textureOut.write(half4(grayValue, grayValue, grayValue, 1), id);

    
    
    
}

