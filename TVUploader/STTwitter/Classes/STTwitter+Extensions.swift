//
//  STTwitter+Extensions.swift
//  Pods
//
//  Created by Tomoya Hirano on 2016/08/29.
//
//

import Foundation
import STTwitter
import SwiftTask
import Unbox

internal extension STTwitterAPI {
  typealias INITVideoTask = Task<Float, (String, Int), ErrorType>
  typealias APPENDVideoTask = Task<Float, String, ErrorType>
  typealias FINALIZEVideoTask = Task<Float, String, ErrorType>
  typealias AsyncINITVideoTask = Task<Float, String, ErrorType>
  typealias AsyncFINALIZEVideoTask = Task<Float, String, ErrorType>
  typealias AsyncSTATUSVideoTask = Task<Float, String, ErrorType>

  func asyncInitTask(videoMediaURL: NSURL) -> AsyncINITVideoTask {
    return AsyncINITVideoTask {
      [weak self] (progress, fulfill, reject, configure) in
      self?.postMediaUploadAsyncINITWithVideoURL(videoMediaURL, successBlock: {
        (responce) in
        fulfill(responce.mediaIdString)
      }, errorBlock: {
        (error) in
        reject(error)
      })
    }
  }


  func initTask(videoMediaURL: NSURL) -> INITVideoTask {
    return INITVideoTask {
      [weak self] (progress, fulfill, reject, configure) in
      self?.postMediaUploadINITWithVideoURL(videoMediaURL, successBlock: {
        (mediaId, expiresAfterSecs) in
        fulfill(mediaId, expiresAfterSecs)
      }, errorBlock: {
        (error) in
        reject(error)
      })
    }
  }

  func appendTask(videoUrl: NSURL, mediaId: String) -> APPENDVideoTask {
    return APPENDVideoTask {
      [weak self] (progress, fulfill, reject, configure) in
      self?.postMediaUploadAPPENDWithVideoURL(videoUrl, mediaID: mediaId, uploadProgressBlock: {
        (bytesWritten, accumulatedBytesWritten, dataLength) in
        progress(Float(accumulatedBytesWritten) / Float(dataLength))
      }, successBlock: {
        (responce) in
        fulfill(mediaId)
      }, errorBlock: {
        (error) in
        reject(error)
      })
    }
  }

  func finalizeTask(mediaId: String) -> FINALIZEVideoTask {
    return FINALIZEVideoTask {
      [weak self] (progress, fulfill, reject, configure) in
      self?.postMediaUploadFINALIZEWithMediaID(mediaId, successBlock: {
        (mediaId, size, expiresAfter, videoType) in
        fulfill(mediaId)
      }, errorBlock: {
        (error) in
        reject(error)
      })
    }
  }
  
  func asyncFinalizeTask(mediaId: String) -> AsyncFINALIZEVideoTask {
    return AsyncFINALIZEVideoTask {
      [weak self] (progress, fulfill, reject, configure) in
      self?.postMediaUploadAsyncFINALIZEWithMediaID(mediaId, successBlock: {
        (responce) in
        fulfill(responce.mediaIdString)
        }, errorBlock: {
          (error) in
          reject(error)
      })
    }
  }

  func asyncStatusTask(mediaId: String) -> AsyncSTATUSVideoTask {
    return AsyncSTATUSVideoTask {
      [weak self] (progress, fulfill, reject, configure) in
      self?.asyncStatusCoroutine(mediaId, success: { mediaId in
        fulfill(mediaId)
        }, failure: { error in
        reject(error)
      })
    }
  }
  
  func asyncStatusCoroutine(mediaId: String, success: ((mediaId: String) -> Void), failure: ((error: ErrorType) -> Void)) {
    postMediaUploadAsyncSTATUSWithMediaID(mediaId, successBlock: { [weak self]
      (response) in
      if let state = response.processingInfo?.state where state == "succeeded" {
        success(mediaId: mediaId)
        return
      }
      //TODO: succeededじゃない場合の処理
      if let pi = response.processingInfo, cas = pi.checkAfterSecs {
        let checkAfterSec = Double(cas)
        NSThread.sleepForTimeInterval(checkAfterSec)
        self?.asyncStatusCoroutine(mediaId, success: success, failure: failure)
      }
      }, errorBlock: {
        (error) in
        failure(error: error)
    })
  }
}

