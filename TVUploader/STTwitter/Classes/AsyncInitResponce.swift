//
// Created by Tomoya Hirano on 2016/08/30.
//

import Foundation
import Unbox

internal struct AsyncInitResponce: Unboxable {
  var expiresAfterSecs = 0
  var mediaId = 0
  var mediaIdString = ""
  
  init(unboxer: Unboxer) {
    self.expiresAfterSecs = unboxer.unbox("expires_after_secs")
    self.mediaId = unboxer.unbox("media_id")
    self.mediaIdString = unboxer.unbox("media_id_string")
  }
}
