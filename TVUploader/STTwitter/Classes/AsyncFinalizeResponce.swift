//
//  AsyncFinalizeResponce.swift
//  Pods
//
//  Created by Tomoya Hirano on 2016/08/30.
//
//

import Foundation
import Unbox

internal struct AsyncFinalizeResponce: Unboxable {
  var mediaId = 0
  var mediaIdString = ""
  var size: Int? = nil
  var expiresAfterSecs: Int? = nil
  var video: Video? = nil
  var processingInfo: ProcessingInfo? = nil
  
  init(unboxer: Unboxer) {
    mediaId = unboxer.unbox("media_id")
    mediaIdString = unboxer.unbox("media_id_string")
    size = unboxer.unbox("size")
    expiresAfterSecs = unboxer.unbox("expires_after_secs")
    video = unboxer.unbox("video")
    processingInfo = unboxer.unbox("processing_info")
  }
}

internal struct AsyncSTATUSResponce: Unboxable {
  var mediaId = 0
  var mediaIdString = ""
  var size: Int? = nil
  var expiresAfterSecs: Int? = nil
  var video: Video? = nil
  var processingInfo: ProcessingInfo? = nil
  
  init(unboxer: Unboxer) {
    mediaId = unboxer.unbox("media_id")
    mediaIdString = unboxer.unbox("media_id_string")
    size = unboxer.unbox("size")
    expiresAfterSecs = unboxer.unbox("expires_after_secs")
    video = unboxer.unbox("video")
    processingInfo = unboxer.unbox("processing_info")
  }
}