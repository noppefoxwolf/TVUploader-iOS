//
//  ProcessingInfo.swift
//  Pods
//
//  Created by Tomoya Hirano on 2016/08/30.
//
//

import Foundation
import Unbox

internal struct ProcessingInfo: Unboxable {
  var state = ""
  var checkAfterSecs: Int? = nil
  var progressPercent: Int? = nil
  
  init(unboxer: Unboxer) {
    state = unboxer.unbox("state")
    checkAfterSecs = unboxer.unbox("check_after_secs")
    progressPercent = unboxer.unbox("progress_percent")
  }
}