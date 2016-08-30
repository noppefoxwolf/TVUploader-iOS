//
//  APIExtensions.swift
//  Pods
//
//  Created by Tomoya Hirano on 2016/08/30.
//
//

import Foundation
import STTwitter
import Unbox

extension STTwitterAPI {
  func postMediaUploadAsyncINITWithVideoURL(videoMediaURL: NSURL, successBlock: ((AsyncInitResponce) -> Void), errorBlock: ((ErrorType) -> Void)) -> STTwitterRequestProtocol? {
    let kBaseURLStringUpload_1_1 = "https://upload.twitter.com/1.1"
    let STTwitterAPIMediaDataIsEmpty = 1
    
    let data = NSData(contentsOfURL: videoMediaURL)
    if (data == nil) {
      let error = NSError(domain: NSStringFromClass(self.dynamicType),
                          code: STTwitterAPIMediaDataIsEmpty,
                          userInfo: [NSLocalizedDescriptionKey: "data is nil"])
      errorBlock(error)
      return nil
    }
    
    var md = [String: String]()
    md["command"] = "INIT"
    md["media_type"] = "video/mp4"
    md["total_bytes"] = "\(data?.length ?? 0)"
    md["media_category"] = "tweet_video"
    return self.postResource("media/upload.json",
                             baseURLString: kBaseURLStringUpload_1_1,
                             parameters: md,
                             uploadProgressBlock: nil,
                             downloadProgressBlock: nil,
                             successBlock: {
                              (rateLimit, response) in
                              do {
                                let responseObject: AsyncInitResponce = try Unbox(response as! UnboxableDictionary)
                                successBlock(responseObject)
                              } catch let error {
                                errorBlock(error)
                              }
      }, errorBlock: {
        (error) in
        errorBlock(error)
    })
  }
  
  func postMediaUploadAsyncFINALIZEWithMediaID(mediaId: String, successBlock: ((AsyncFinalizeResponce) -> Void), errorBlock: ((ErrorType) -> Void)) -> STTwitterRequestProtocol {
    let kBaseURLStringUpload_1_1 = "https://upload.twitter.com/1.1"
    
    var md = [String: String]()
    md["command"] = "FINALIZE"
    md["media_id"] = mediaId
    
    return self.postResource("media/upload.json",
                             baseURLString: kBaseURLStringUpload_1_1,
                             parameters: md,
                             uploadProgressBlock: nil,
                             downloadProgressBlock: nil,
                             successBlock: {
                              (rateLimit, response) in
                              do {
                                let responseObject: AsyncFinalizeResponce = try Unbox(response as! UnboxableDictionary)
                                successBlock(responseObject)
                              } catch let error {
                                errorBlock(error)
                              }
      }, errorBlock: {
        (error) in
        errorBlock(error)
    })
  }
  
  func postMediaUploadAsyncSTATUSWithMediaID(mediaId: String, successBlock: ((AsyncSTATUSResponce) -> Void), errorBlock: ((ErrorType) -> Void)) -> STTwitterRequestProtocol {
    let kBaseURLStringUpload_1_1 = "https://upload.twitter.com/1.1"
    
    var md = [String: String]()
    md["command"] = "STATUS"
    md["media_id"] = mediaId
    self.getResource("media/upload.json", baseURLString: kBaseURLStringUpload_1_1, parameters: md, downloadProgressBlock: nil, successBlock: { (rateLimit, response) in
      
      }) { (error) in
        
    }
    return self.getResource("media/upload.json",
                             baseURLString: kBaseURLStringUpload_1_1,
                             parameters: md,
                             downloadProgressBlock: nil,
                             successBlock: {
                              (rateLimit, response) in
                              do {
                                let responseObject: AsyncSTATUSResponce = try Unbox(response as! UnboxableDictionary)
                                successBlock(responseObject)
                              } catch let error {
                                errorBlock(error)
                              }
      }, errorBlock: {
        (error) in
        errorBlock(error)
    })
  }
}