# TVUploader

[![CI Status](http://img.shields.io/travis/Tomoya Hirano/TVUploader.svg?style=flat)](https://travis-ci.org/Tomoya Hirano/TVUploader)
[![Version](https://img.shields.io/cocoapods/v/TVUploader.svg?style=flat)](http://cocoapods.org/pods/TVUploader)
[![License](https://img.shields.io/cocoapods/l/TVUploader.svg?style=flat)](http://cocoapods.org/pods/TVUploader)
[![Platform](https://img.shields.io/cocoapods/p/TVUploader.svg?style=flat)](http://cocoapods.org/pods/TVUploader)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

TVUploader is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "TVUploader"
```

## Usage

###Print the video information

```swift
    let videoUrl1 = NSBundle.mainBundle().URLForResource("sample1", withExtension: "mp4")!
    let info1 = TVVideoInfo(videoUrl: videoUrl1)
    print(info1)
```

infomation example
```
---- Video Track Infomation ---
File Path: file://TVUploader_Example.app/sample.mp4
Duration:  2.83182222222222sec
File Size: 0.0930662MB (97587B)
Dimension: 320.0 x 180.0 [width x height]
Aspect Ratio: 1.77778
Channel Count: 2
FPS: 24.0128
--------------------------
```

###Video format validation for Twitter

```swift    
    TVValidater(videoInfo: info1, postType: .Async).validationCheckTask().success { (safes) in
        print(safes)
      }.failure { (error, isCancelled) in
        print(error)
    }
```

validation result example of success
```
[TVUploader.TVValidater.FormatValid.durationValid, TVUploader.TVValidater.FormatValid.fileSizeValid, TVUploader.TVValidater.FormatValid.dimensionsValid, TVUploader.TVValidater.FormatValid.aspectRatioValid, TVUploader.TVValidater.FormatValid.frameRateValid, TVUploader.TVValidater.FormatValid.audioChannelValid, TVUploader.TVValidater.FormatValid.audioFormatValid]
```

validation result example of failure
It will be called at the time verification fails.
```
Optional(TVUploader.TVValidater.FormatError.InvalidDuration)
```

###post video to twitter
Supports synchronous and asynchronous(chunked) upload.
```swift
    let api = TVUploaderAPI(OAuthConsumerKey: "",
                           consumerSecret: "",
                           oauthToken: "",
                           oauthTokenSecret: "")
    api.asyncVideoUpload(videoUrl1).success { (mediaId) -> TVUploaderAPI.PostTask in
      return api.postStatusUpdateTask("", mediaId: mediaId)
    }.success { (_) in
      print("video1 upload success")
    }.failure { (error, isCancelled) in
      print("video1 upload failure")
    }
```

##TODO
- [ ] upload progress
- [ ] video File Optimizer
- [ ] open GOP validater
- [ ] progressive scan validater
- [ ] pixel aspect ratio validater
- [ ] audio channels validater
- [ ] audio format validater
- [ ] git support
- [ ] image support

## Author

Tomoya Hirano, cromteria@gmail.com

## License
TVUploader is available under the MIT license. See the LICENSE file for more info.
