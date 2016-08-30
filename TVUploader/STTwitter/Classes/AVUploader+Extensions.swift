//
//  AVUploader+Extensions.swift
//  Pods
//
//  Created by Tomoya Hirano on 2016/08/30.
//
//

import Foundation
import STTwitter
import SwiftTask
import Unbox

public class TVUploaderAPI: STTwitterAPI {}
public extension TVUploaderAPI {
  enum UploadState {
    case INIT
    case APPEND(Float, Float)
    case FINALIZE
    case STATUS(Int)
    case SUCCESSS
    case FAILURE
  }
  
  typealias SyncVideoUploadTask = Task<Float, String, ErrorType>
  func syncVideoUpload(videoUrl: NSURL) -> SyncVideoUploadTask {
    return initTask(videoUrl).success { (mediaId, expiresAfterSecs) -> APPENDVideoTask in
      return self.appendTask(videoUrl, mediaId: mediaId)
      }.progress{ (oldProgress, newProgress) in
      }.success{ (mediaId) -> FINALIZEVideoTask in
      return self.finalizeTask(mediaId)
    }
  }
  
  typealias AsyncVideoUploadTask = Task<Float, String, ErrorType>
  func asyncVideoUpload(videoUrl: NSURL) -> AsyncVideoUploadTask {
    return asyncInitTask(videoUrl).success { (mediaId) -> APPENDVideoTask in
      return self.appendTask(videoUrl, mediaId: mediaId)
      }.progress{ (oldProgress, newProgress) in
        print(oldProgress, newProgress)
      }.success{ (mediaId) -> AsyncFINALIZEVideoTask in
        return self.asyncFinalizeTask(mediaId)
      }.success{ (mediaId) -> AsyncSTATUSVideoTask in
        return self.asyncStatusTask(mediaId)
    }
  }
  
  typealias PostTask = Task<Float, String, ErrorType>
  func postStatusUpdateTask(tweet: String, inReplyToStatusID: String = "", mediaId: String) -> PostTask {
    return PostTask { [weak self] (progress, fulfill, reject, configure) in
      self?.postStatusUpdate(tweet,
        inReplyToStatusID: inReplyToStatusID,
        mediaIDs: [mediaId],
        latitude: "",
        longitude: "",
        placeID: "",
        displayCoordinates: 0,
        trimUser: 0,
        successBlock: {
          (responce) in
          fulfill(String(responce))
        }, errorBlock: {
          (error) in
          reject(error)
      })
    }
  }
}