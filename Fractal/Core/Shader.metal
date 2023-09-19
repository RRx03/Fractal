#include "../Application/Common.h"
#include <metal_stdlib>
using namespace metal;

float2 computeItteration(float2 Z, float2 CConst){
    return float2(Z.x*Z.x-Z.y*Z.y+CConst.x, 2*Z.x*Z.y+CConst.y);
}

uint computeItterations(float2 Z, float2 CConst, uint maxItt){
    uint itt = 0;
    while ((Z.x*Z.x - Z.y*Z.y < 4.0) && itt < maxItt){
        Z = computeItteration(Z, CConst);
        itt+=1;
    }
    return itt;
    
}

kernel void Kernel (texture2d<half, access::read> textureIn [[texture(1)]],
                    texture2d<half, access::write> textureOut [[texture(0)]],
                    constant Settings &settings [[buffer(10)]],
                    uint2 id [[thread_position_in_grid]]){
    
    
    float2 signedPositions = float2(id)-float2(settings.boundaries)/2;
    signedPositions /= float2(settings.boundaries)/2;
    
    float2 Const = float2(signedPositions.x, signedPositions.y);
    uint grayScale = computeItterations(float2(0, 0), Const, settings.maxItt);
    float grayValue = float(grayScale)/settings.maxItt;
    
    textureOut.write(half4(grayValue, grayValue, grayValue, 1), id);

    
    
    
}

