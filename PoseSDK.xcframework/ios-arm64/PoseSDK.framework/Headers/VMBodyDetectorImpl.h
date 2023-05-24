//
//  VMBodyDetectorImpl.h
//  PoseSDK
//
//  Created by Sergii Kutnii on 23.09.2021.
//

#ifndef VMBodyDetectorImpl_h
#define VMBodyDetectorImpl_h

#include <QuartzCore/QuartzCore.h>
#include "VMSceneImpl.h"
#include "VMBodyDetectorOptions.h"

#ifdef __cplusplus
extern "C" {
#endif

///An opaque body detector pointer
 typedef void* VMBodyDetectorImplRef;


///Create a new body detector object with given options
VMBodyDetectorImplRef VMBodyDetectorCreate(VMBodyDetectorOptionsRef options);


 ///Delete a body detector implementation object
void VMBodyDetectorDestroy(VMBodyDetectorImplRef detector);

/**
 Detect pose information in a CoreGraphics image.
 
 The algorithm first runs human detection.
 If it was successful as indicated by confidence above the ``VMHumanDetectorOptions.confidenceThreshold`` value,
 keypoint detection is performed.
 
 @param detector Opaque body detector implementation pointer created with ``VMBodyDetectorCreate``
 @param frame Image to process
 @param result Result pointer.
 
***Usage**
 ```swift
 var options = VMBodyDetectorOptions()
 //Populate options with values
 
 let detector = VMBodyDetectorCreate(options)
 defer {
    VMBodyDetectorDestroy(detector)
 }
 
 let scene = VMSceneImplCreate()
 defer {
    VMSceneImplDelete(scene)
 }
 
 let frame = SomeImageProducingMethod()
 VMBodyDetectorProcess(detector, frame, scene)
 
 if VMSceneImplIsBodyPresent(scene) {
    //Process detection results
 }
 ```
 */
void VMBodyDetectorProcess(VMBodyDetectorImplRef detector, CGImageRef frame, VMSceneImplRef result);

#ifdef __cplusplus
}
#endif

#endif /* VMBodyDetectorImpl_h */
