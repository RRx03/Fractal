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


float randomFunc(device uint *state) {
    
    *state = *state * (*state + 973654) * (*state + 577872) * (*state + 398327) + 2345678;
    return *state / 4294967295.0;
}


kernel void MandelBrot (texture2d<half, access::read> textureIn [[texture(1)]],
                    texture2d<half, access::write> textureOut [[texture(0)]],
                    constant Common &common [[buffer(10)]],
                    constant MandelBrotSettings &mandelbrot [[buffer(11)]],
                    device Random &random [[buffer(12)]],
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
                    device Random &random [[buffer(12)]],
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
                    device Random *random [[buffer(12)]],
                    uint2 id [[thread_position_in_grid]]){
    #define Points 3
    device uint *state = &random[0].state;
    *state = id.y*common.boundaries.x+id.x;
    float2 SIZE = float2(common.boundaries);
    
    float2 mandelBrotAffixes[Points];
    for (int i = 0; i < Points; i++){
        mandelBrotAffixes[i] = 2*(float2(id)+float2(randomFunc(state), randomFunc(state))-SIZE/2)/(SIZE*common.scale);
    }
    float grayScales[Points];
    float resultantGrayScale = 0;
    for (int i = 0; i < Points; i++){
        grayScales[i] = ComputeMandelBrot(mandelBrotAffixes[i], mandelbrot.CConst, mandelbrot.maxItt);
        resultantGrayScale += grayScales[i]/mandelbrot.maxItt;
    }
    resultantGrayScale /= Points;
    textureOut.write(half4(resultantGrayScale, resultantGrayScale, resultantGrayScale, 1), id);

    
    
    
}

