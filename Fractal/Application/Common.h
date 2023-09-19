

#ifndef Common_h
#define Common_h
#import <simd/simd.h>



typedef struct{
    simd_uint2 boundaries;
    float scale;
    
    
} Common;

typedef struct {
    uint state;
    
    
}Random;

typedef struct {
    uint maxItt;
    simd_float2 COffset;
    
}MandelBrotSettings;

typedef struct{
    uint maxItt;
    simd_float2 CConst;
    
} ReverseMandelBrotSettings;
#endif /* Common_h */
