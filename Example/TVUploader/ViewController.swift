//
//  ViewController.swift
//  TVUploader
//
//  Created by Tomoya Hirano on 08/29/2016.
//  Copyright (c) 2016 Tomoya Hirano. All rights reserved.
//

import UIKit
import TVUploader

class ViewController: UIViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let videoUrl1 = NSBundle.mainBundle().URLForResource("sample", withExtension: "mp4")!
    let info1 = TVVideoInfo(videoUrl: videoUrl1)
    //video info
    print(info1)
    
    //validation
    TVValidater(videoInfo: info1, postType: .Async).validationCheckTask().success { (safes) in
      print(safes)
      }.failure { (error, isCancelled) in
        print(error)
    }

    let api = TVUploaderAPI(OAuthConsumerKey: "",
                           consumerSecret: "",
                           oauthToken: "",
                           oauthTokenSecret: "")
    //upload video
    api.asyncVideoUpload(videoUrl1).success { (mediaId) -> TVUploaderAPI.PostTask in
      return api.postStatusUpdateTask("", mediaId: mediaId)
    }.success { (_) in
      print("video1 upload success")
    }.failure { (error, isCancelled) in
      print("video1 upload failure")
    }
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
}
