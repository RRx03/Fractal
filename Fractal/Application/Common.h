

#ifndef Common_h
#define Common_h
#import <simd/simd.h>

typedef struct {
    simd_uint2 boundaries;
    simd_float2 range;
    simd_float2 CConst;
    uint maxItt;
    
    
}Settings;


#endif /* Common_h */
