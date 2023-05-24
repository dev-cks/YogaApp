//
//  VMBodyDetectorOptions.hpp
//  PoseSDK
//
//  Created by Sergii Kutnii on 21.10.2021.
//

#ifndef VMBodyDetectorOptions_hpp
#define VMBodyDetectorOptions_hpp

#include <stdio.h>
#include <CoreFoundation/CoreFoundation.h>

#ifdef __cplusplus
extern "C" {
#endif

///TensorFlow computation engine type
typedef enum VMEngineType {
    
    ///CPU engine (default)
    VMCPUEngine = 0,
    
    ///Metal engine
    VMMetalEngine
} VMEngineType;

///An opaque pointer to human detection algorithm options structure
typedef void* VMHumanDetectorOptionsRef;

///Create a new human detector configuration structure
VMHumanDetectorOptionsRef VMHumanDetectorOptionsCreate();

///Delete a human detector options structure
void VMHumanDetectorOptionsDelete(VMHumanDetectorOptionsRef options);

///Get human detector input bitmap width in pixels
size_t VMHumanDetectorOptionsGetInputWidth(VMHumanDetectorOptionsRef options);

///Set human detector input bitmap width in pixels
void VMHumanDetectorOptionsSetInputWidth(VMHumanDetectorOptionsRef options, size_t width);

///Get human detector input bitmap height in pixels
size_t VMHumanDetectorOptionsGetInputHeight(VMHumanDetectorOptionsRef options);

///Set human detector input bitmap height in pixels
void VMHumanDetectorOptionsSetInputHeight(VMHumanDetectorOptionsRef options, size_t height);

///Get human detector options input tensor index
int32_t VMHumanDetectorOptionsGetInputIndex(VMHumanDetectorOptionsRef options);

///Set human detector options input tensor index
void VMHumanDetectorOptionsSetInputIndex(VMHumanDetectorOptionsRef options, int32_t index);

///Get human detector options input tensor index
int32_t VMHumanDetectorOptionsGetResultIndex(VMHumanDetectorOptionsRef options);

///Set human detector options input tensor index
void VMHumanDetectorOptionsSetResultIndex(VMHumanDetectorOptionsRef options, int32_t index);

///Get human detector options confidence tensor index
int32_t VMHumanDetectorOptionsGetConfidenceIndex(VMHumanDetectorOptionsRef options);

///Get human detector options confidence tensor index
void VMHumanDetectorOptionsSetConfidenceIndex(VMHumanDetectorOptionsRef options, int32_t index);

///Get human detector options confidence threshold value.
///Confidence threshold is the minimum confidence value to consider human detection successfu
float VMHumanDetectorOptionsGetConfidenceThreshold(VMHumanDetectorOptionsRef options);

///Set human detector options confidence threshold value
void VMHumanDetectorOptionsSetConfidenceThreshold(VMHumanDetectorOptionsRef options, float threshold);

///Get number of CPU threads to use for human detection
unsigned int VMHumanDetectorOptionsGetNumThreads(VMHumanDetectorOptionsRef options);

///Set number of CPU threads to use for human detection
void VMHumanDetectorOptionsSetNumThreads(VMHumanDetectorOptionsRef options, unsigned int numThreads);

///Get computation engine type to use for human detection
VMEngineType VMHumanDetectorOptionsGetEngineType(VMHumanDetectorOptionsRef options);

///Set computation engine type to use for human detection
void VMHumanDetectorOptionsSetEngineType(VMHumanDetectorOptionsRef options, VMEngineType engine);

///Returns a copy of human detector model file path as a CFString.
///Caller is responsible for releasing the returned string.
CFStringRef VMHumanDetectorOptionsCopyModelPath(VMHumanDetectorOptionsRef options);

///Set human detector model file path. The path string is copied.
void VMHumanDetectorOptionsSetModelPath(VMHumanDetectorOptionsRef options, CFStringRef path);

///An opaque pointer to a keypoint detector options structure
typedef void* VMKeypointDetectorOptionsRef;

///Create a new keypoint detector options structure
VMKeypointDetectorOptionsRef VMKeypointDetectorOptionsCreate();

///Delete a keypoint detector options structure
void VMKeypointDetectorOptionsDelete(VMKeypointDetectorOptionsRef options);

///Get keypoint detector input bitmap width
size_t VMKeypointDetectorOptionsGetInputWidth(VMKeypointDetectorOptionsRef options);

///Set keypoint detector input bitmap width
void VMKeypointDetectorOptionsSetInputWidth(VMKeypointDetectorOptionsRef options, size_t width);

///Get keypoint detector input bitmap height
size_t VMKeypointDetectorOptionsGetInputHeight(VMKeypointDetectorOptionsRef options);

///Set keypoint detector input bitmap height
void VMKeypointDetectorOptionsSetInputHeight(VMKeypointDetectorOptionsRef options, size_t height);

///Get keypoint detector input tensor index
int32_t VMKeypointDetectorOptionsGetInputIndex(VMKeypointDetectorOptionsRef options);

///Set keypoint detector input tensor index
void VMKeypointDetectorOptionsSetInputIndex(VMKeypointDetectorOptionsRef options, int32_t index);

///Get keypoint detector result tensor index
int32_t VMKeypointDetectorOptionsGetResultIndex(VMKeypointDetectorOptionsRef options);

///Set keypoint detector result tensor index
void VMKeypointDetectorOptionsSetResultIndex(VMKeypointDetectorOptionsRef options, int32_t index);

///Copy keypoint detector model source file path.
///Caller is responsible for releasing the returned value.
CFStringRef VMKeypointDetectorOptionsCopyModelPath(VMKeypointDetectorOptionsRef options);

///Set keypoint detector model source file path. The string is copied.
void VMKeypointDetectorOptionsSetModelPath(VMKeypointDetectorOptionsRef options, CFStringRef path);

///Get number of CPU threads to use for keypoint detection
unsigned int VMKeypointDetectorOptionsGetNumThreads(VMKeypointDetectorOptionsRef options);

///Set number of CPU threads to use for keypoint detection
void VMKeypointDetectorOptionsSetNumThreads(VMKeypointDetectorOptionsRef options, unsigned int numThreads);

///Get computation engine to use for keypoint detection
VMEngineType VMKeypointDetectorOptionsGetEngineType(VMKeypointDetectorOptionsRef options);

///Set computation engine to use for keypoint detection
void VMKeypointDetectorOptionsSetEngineType(VMKeypointDetectorOptionsRef options, VMEngineType engine);

///RGB alpha-less color value
typedef struct VMColorData {
    ///Red component
    float red;
    
    ///Green component
    float green;
    
    ///Blue component
    float blue;
} VMColorData;

///Color statistics of an image set.
typedef struct VMColorStats {
    ///Average values by component
    VMColorData average;
    
    //Per-component standard deviations
    VMColorData stdDev;
} VMColorStats;

///Get statistical data used for keypoint detector input normalization
VMColorStats VMKeypointDetectorOptionsGetColorStats(VMKeypointDetectorOptionsRef options);

///Get statistical data used for keypoint detector input normalization
void VMKeypointDetectorOptionsSetColorStats(VMKeypointDetectorOptionsRef options, const VMColorStats* stats);

///Get the number of detected keypoints
size_t VMKeypointDetectorOptionsGetKeypointCount(VMKeypointDetectorOptionsRef options);

/**
 Set the number of keypoints detected by the model.
 
The scene will always contain the number of keypoints specified by this parameter
 but keypoint confidence values will indicate how reliable the detection was.
 The value must be within the model-determined bounds.
 
 - SeeAlso:
    - ``VMSceneImplGetKeypointCount``
    - ``VMSceneImplGetKeypointAtIndex``
    - ``VMKeypoint``
    - ``VMBodyPart``
 */
void VMKeypointDetectorOptionsSetKeypointCount(VMKeypointDetectorOptionsRef options, size_t count);

///An opaque pointer to body detector options structure
typedef void* VMBodyDetectorOptionsRef;

///Create a body detector options structure instance
VMBodyDetectorOptionsRef VMBodyDetectorOptionsCreate();

///Copy a body detector options structure instance
VMBodyDetectorOptionsRef VMBodyDetectorOptionsCopy(VMBodyDetectorOptionsRef  instance);

///Delete a body detector options structure instance
void VMBodyDetectorOptionsDelete(VMBodyDetectorOptionsRef options);

///Get human detector options structure pointer
VMHumanDetectorOptionsRef
VMBodyDetectorOptionsGetHumanDetectorOptions(VMBodyDetectorOptionsRef options);

///Set human detector options values
void
VMBodyDetectorOptionsSetHumanDetectorOptions(VMBodyDetectorOptionsRef options,
                                             VMHumanDetectorOptionsRef hdOptions);

///Get keypoint detector options structure pointer
VMKeypointDetectorOptionsRef
VMBodyDetectorOptionsGetKeypointDetectorOptions(VMBodyDetectorOptionsRef options);

///Set keypoint detector options values
void
VMBodyDetectorOptionsSetKeypointDetectorOptions(VMBodyDetectorOptionsRef options,
                                                VMKeypointDetectorOptionsRef kpOptions);

#ifdef __cplusplus
}
#endif

#endif /* VMBodyDetectorOptions_hpp */
