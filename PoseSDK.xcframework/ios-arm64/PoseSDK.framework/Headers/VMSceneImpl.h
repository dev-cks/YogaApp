//
//  Scene.h
//  PoseSDK
//
//  Created by Sergii Kutnii on 23.09.2021.
//

#ifndef Scene_h
#define Scene_h

#include <stdbool.h>
#include <QuartzCore/QuartzCore.h>
#include <CoreMedia/CoreMedia.h>

#ifdef __cplusplus
extern "C" {
#endif


/**
 * Represents a body part detected in an image
 *
 * Fields:
 *  - **location**
 *  - **confidence**
 */
typedef struct VMKeypoint {
    ///Body part location in source image's coordinates
    CGPoint location;
    
    ///Detection reliability
    float confidence;
} VMKeypoint;

///An opaque scene object pointer
typedef void* VMSceneImplRef;

///Creates an empty scene object
VMSceneImplRef VMSceneImplCreate();

///Deletes a scene object
void VMSceneImplDelete(VMSceneImplRef object);

///Scene width getter
size_t VMSceneImplGetWidth(VMSceneImplRef object);

///Scene height getter
size_t VMSceneImplGetHeight(VMSceneImplRef object);

///Determine whether a human body was detected in an image
bool VMSceneImplIsBodyPresent(VMSceneImplRef object);

/**
 Returns the bounding rectangle of the detected body.
 If no body was detected, the result is undefined.
 
 - SeeAlso: ``VMSceneImplIsBodyPresent``
 */
CGRect VMSceneImplGetBodyBounds(VMSceneImplRef object);

///Get the number of keypoints detected in a scene
size_t VMSceneImplGetKeypointCount(VMSceneImplRef object);

/**
 Get the keypoint at the specified index.
 
 @param scene The scene object to query
 @param index Index of the keypoint.
    The value must be smaller than the keypoint count, otherwise undefined behavior occurs.
    See ``VMBodyPart`` for indices semantics.
 */
VMKeypoint VMSceneImplGetKeypointAtIndex(VMSceneImplRef scene, size_t index);

///Get detection timestamp
CMTime VMSceneImplGetTimestamp(VMSceneImplRef scene);

///Set detection timestamp
void VMSceneImplSetTimestamp(VMSceneImplRef scene, const CMTime *timestamp);

#ifdef __cplusplus
}
#endif

#endif /* Scene_h */
