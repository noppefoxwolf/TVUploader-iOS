//
//  Video.swift
//  Pods
//
//  Created by Tomoya Hirano on 2016/08/30.
//
//

import Foundation
import Unbox

internal struct Video: Unboxable {
  var videoType = ""
  init(unboxer: Unboxer) {
    videoType = unboxer.unbox("video_type")
  }
}