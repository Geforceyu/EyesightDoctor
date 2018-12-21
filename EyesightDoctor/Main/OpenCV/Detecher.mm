//
//  Detecher.m
//  EyesightDoctor
//
//  Created by Chonghua Yu on 2018/9/27.
//  Copyright © 2018年 Chonghua Yu. All rights reserved.
//

#import "Detecher.h"
#ifdef __cplusplus
#import <opencv2/opencv.hpp>
#endif
#import <opencv2/videoio/cap_ios.h>
using namespace cv;

@interface Detecher ()<CvVideoCameraDelegate>

@property (nonatomic, strong) CvVideoCamera * videoCamera;

@end

@implementation Detecher
{
    CascadeClassifier _eyeCascade;
    CascadeClassifier _faceCascade;
    CascadeClassifier _glassesCascade;
    CascadeClassifier _leftEyeCascade;
    CascadeClassifier _rightEyeCascade;
    CascadeClassifier _noseCascade;
}

- (void)startDetecherWithView:(UIView *)view
{
    self.videoCamera = [[CvVideoCamera alloc] initWithParentView:view];
    self.videoCamera.defaultAVCaptureDevicePosition = AVCaptureDevicePositionFront;
    self.videoCamera.defaultAVCaptureSessionPreset = AVCaptureSessionPreset640x480;
    self.videoCamera.defaultAVCaptureVideoOrientation = AVCaptureVideoOrientationPortrait;
    self.videoCamera.defaultFPS = 30;
    self.videoCamera.grayscaleMode = NO;
    self.videoCamera.delegate = self;
    self.videoCamera.rotateVideo = NO;
    self.videoCamera.useAVCaptureVideoPreviewLayer = YES;
    [self setupDetector];
    [self.videoCamera start];
}
- (void)stop
{
    [self.videoCamera stop];
    self.videoCamera = nil;
}
//设置检测器
- (void)setupDetector{
    
    //脸部检测
    NSString *faceCascadePath = [[NSBundle mainBundle] pathForResource:@"haarcascade_frontalface_alt2"
                                                                ofType:@"xml"];
    const CFIndex CASCADE_NAME_LEN = 2048;
    char *CASCADE_NAME = (char *) malloc(CASCADE_NAME_LEN);
    CFStringGetFileSystemRepresentation( (CFStringRef)faceCascadePath, CASCADE_NAME, CASCADE_NAME_LEN);
    _faceCascade.load(CASCADE_NAME);
    
    //眼部检测
//    NSString *eyesCascadePath = [[NSBundle mainBundle] pathForResource:@"haarcascade_eye"
//                                                                ofType:@"xml"];
//    CFStringGetFileSystemRepresentation( (CFStringRef)eyesCascadePath, CASCADE_NAME, CASCADE_NAME_LEN);
//
//    _eyeCascade.load(CASCADE_NAME);
    
    //眼镜检测
    NSString *glassesCascadePath = [[NSBundle mainBundle] pathForResource:@"haarcascade_eye_tree_eyeglasses" ofType:@"xml"];
    CFStringGetFileSystemRepresentation((CFStringRef)glassesCascadePath, CASCADE_NAME, CASCADE_NAME_LEN);
    _glassesCascade.load(CASCADE_NAME);
    
    //左眼检测
    NSString *leftEyeCascadePath = [[NSBundle mainBundle] pathForResource:@"haarcascade_lefteye_2splits" ofType:@"xml"];
    CFStringGetFileSystemRepresentation((CFStringRef)leftEyeCascadePath, CASCADE_NAME, CASCADE_NAME_LEN);
    _leftEyeCascade.load(CASCADE_NAME);
    
    //右眼检测
    NSString *rightEyeCascadePath = [[NSBundle mainBundle] pathForResource:@"haarcascade_righteye_2splits" ofType:@"xml"];
    CFStringGetFileSystemRepresentation((CFStringRef)rightEyeCascadePath, CASCADE_NAME, CASCADE_NAME_LEN);
    _rightEyeCascade.load(CASCADE_NAME);
    
    //鼻子检测
    NSString *noseCascadePath = [[NSBundle mainBundle] pathForResource:@"haarcascade_mcs_nose" ofType:@"xml"];
    CFStringGetFileSystemRepresentation((CFStringRef)noseCascadePath, CASCADE_NAME, CASCADE_NAME_LEN);
    _noseCascade.load(CASCADE_NAME);
    
    
    free(CASCADE_NAME);
}
- (void)processImage:(cv::Mat &)image
{
    std::vector<cv::Rect> rects =  [self checkFacesWithImage:image];
    if ([self checkFaceIsOkAndCallBackProgressWithRects:rects]) {
        [self checkFaceFeaturesWithRects:rects Image:image];
    }
}
//检测人脸
- (std::vector<cv::Rect>)checkFacesWithImage:(cv::Mat &)image{
    
    std::vector<cv::Rect> rects;
    Mat gray, smallImg( cvRound (image.rows), cvRound(image.cols), CV_8UC1 );
    cvtColor( image, gray, COLOR_BGR2GRAY );
    resize( gray, smallImg, smallImg.size(), 0, 0, INTER_LINEAR );
    equalizeHist( smallImg, smallImg );
    double scalingFactor = 1.1;
    int minRects = 2;
    cv::Size minSize(30,30);
    _faceCascade.detectMultiScale( smallImg, rects,
                                  scalingFactor, minRects, 0,
                                  minSize );
    return rects;
}
//检查脸部的信息
- (void)checkFaceFeaturesWithRects:(std::vector<cv::Rect>)rects Image:(cv::Mat)image
{
    cv::Rect& faceR = rects[0];
    cv::Rect faceZone( cv::Point(faceR.x + 0.12f * faceR.width,
                                    faceR.y + 0.17f * faceR.height),
                         cv::Size(0.76 * faceR.width,
                                  0.4f * faceR.height));
    rects.clear();
    
    std::vector<cv::Rect> glassesRects;
    std::vector<cv::Rect> leftEyeRects;
    std::vector<cv::Rect> rightEyeRects;
    std::vector<cv::Rect> noseRects;
    
    rectangle(image, faceR, Scalar(0,255,0));
    rectangle(image, faceZone, Scalar(0,255,0));
    Mat faceImage(image, faceZone);
    cv::Size width = cv::Size(faceZone.width * 0.2f, faceZone.width * 0.2f);
    cv::Size height = cv::Size(faceZone.width,faceZone.height);
    
    _glassesCascade.detectMultiScale(faceImage, glassesRects, 1.2f, 5, CV_HAAR_SCALE_IMAGE,width,height);
    _leftEyeCascade.detectMultiScale(faceImage, leftEyeRects, 1.2f, 5, CV_HAAR_SCALE_IMAGE,width,height);
    _leftEyeCascade.detectMultiScale(faceImage, rightEyeRects, 1.2f, 5, CV_HAAR_SCALE_IMAGE,width,height);
    _noseCascade.detectMultiScale(faceImage, noseRects, 1.2f, 5,CV_HAAR_SCALE_IMAGE,width,height);
    
    if (glassesRects.size()>0){
        //有眼镜
        if (self.delegate && [self.delegate respondsToSelector:@selector(didDetechHasGlasses:)]) {
            [self.delegate didDetechHasGlasses:YES];
        }
    }else{
        //没有眼镜
        if (self.delegate && [self.delegate respondsToSelector:@selector(didDetechHasGlasses:)]) {
            [self.delegate didDetechHasGlasses:NO];
        }
    }
    if (leftEyeRects.size()>1){
        if (self.delegate && [self.delegate respondsToSelector:@selector(didDetechLeftEyeState:)]) {
            [self.delegate didDetechLeftEyeState:1];
        }
    }else{
        if (self.delegate && [self.delegate respondsToSelector:@selector(didDetechLeftEyeState:)]) {
            [self.delegate didDetechLeftEyeState:0];
        }
    }
    if (rightEyeRects.size()>1) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(didDetechRightEyeState:)]) {
            [self.delegate didDetechRightEyeState:1];
        }
    }else{
        if (self.delegate && [self.delegate respondsToSelector:@selector(didDetechRightEyeState:)]) {
            [self.delegate didDetechRightEyeState:0];
        }
    }
    if (noseRects.size()>0) {
        cv::Rect noseRect = noseRects[0];
        if (self.delegate && [self.delegate respondsToSelector:@selector(didDetechNoseRect:)]) {
            [self.delegate didDetechNoseRect:CGRectMake(noseRect.x, noseRect.y, noseRect.width, noseRect.height)];
        }
    }else{
        
    }
}

//检测眼睛
- (void)checkBlickWithRects:(std::vector<cv::Rect>)rects andImage:(cv::Mat &)image{
    
    cv::Rect& faceR = rects[0];
    cv::Rect faceEyeZone( cv::Point(faceR.x + 0.12f * faceR.width,
                                    faceR.y + 0.17f * faceR.height),
                         cv::Size(0.76 * faceR.width,
                                  0.4f * faceR.height));
    rects.clear();
    rectangle(image, faceR, Scalar(0,255,0));
    rectangle(image, faceEyeZone, Scalar(0,255,0));
    Mat eyeImage(image, faceEyeZone);
    _eyeCascade.detectMultiScale(eyeImage, rects, 1.2f, 5, CV_HAAR_SCALE_IMAGE,
                                 cv::Size(faceEyeZone.width * 0.2f, faceEyeZone.width * 0.2f),
                                 cv::Size(0.5f * faceEyeZone.width, 0.7f * faceEyeZone.height));
//    (int)rects.size()
}

//检测人脸是否符合
- (BOOL)checkFaceIsOkAndCallBackProgressWithRects:(std::vector<cv::Rect>)rects{
    if (!rects.size()) {//没有找到人脸
        if (self.delegate && [self.delegate respondsToSelector:@selector(didnotDetechFace)]) {
            [self.delegate didnotDetechFace];
        }
        return NO;
    }
    if(rects.size() > 1){//多张人脸
        if (self.delegate && [self.delegate respondsToSelector:@selector(didDetechMultiFace)]) {
            [self.delegate didDetechMultiFace];
        }
        return NO;
    }
    cv::Rect& rect = rects[0];
    if (self.delegate && [self.delegate respondsToSelector:@selector(didDetechFaceRect:)]) {
        [self.delegate didDetechFaceRect:CGRectMake(rect.x, rect.y, rect.width, rect.height)];
    }
    return YES;
}
@end
