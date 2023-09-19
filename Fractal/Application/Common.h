

#ifndef Common_h
#define Common_h
#import <simd/simd.h>

typedef struct {
    simd_uint2 boundaries;
    float scale;
    simd_float2 CConst;
    uint maxItt;
    
    
}MandelBrotSettings;


#endif /* Common_h */
