//
// Created by Tomoya Hirano on 2016/08/30.
//

import Foundation
import AVFoundation
import SwiftTask

public protocol FormatSafe {}

public class TVValidater {
  public enum FormatValid: FormatSafe {
    case durationValid
    case fileSizeValid
    case dimensionsValid
    case aspectRatioValid
    case frameRateValid
    case audioChannelValid
    case audioFormatValid
  }
  
  public enum FormatWarning: FormatSafe {
    case UnsafeDimentions
    case UnsafeAspectRatio
    case UnsafeAudioChannel
  }

  public enum FormatError: ErrorType {
    case InvalidDuration
    case InvalidFileSize
    case InvalidFrameRate
    case InvalidAudioFormat
  }

  

  public enum PostType {
    case Sync
    case Async

    func getDurationRange() -> (min:Float64, max:Float64) {
      switch self {
      case .Sync: return (min: 0.5, max: 30.0)
      case .Async: return (min: 0.5, max: 140.0)
      }
    }

    func getFileSizeLimit() -> UInt64 {
      switch self {
      case .Sync: return 15 * 1024 * 1024
      case .Async: return 512 * 1024 * 1024
      }
    }

    func getDimensionsLimit() -> (min:(width:Int, height:Int), max:(width:Int, height:Int)) {
      return (min: (width: 32, height: 32), max: (width: 1280, height: 1024))
    }

    func getAspectRatioLimit() -> (min:Float, max:Float) {
      return (min: 1.0 / 3.0, max: 3.0 / 1.0)
    }

    func getMaxFrameRate() -> Float {
      return 40.0
    }
    //open GOP
    //Progressive scan
    //pixel aspect ratio
    //mono stereo
    //must AAC-LC
  }

  enum RecomendedFormat {
    case LandscapeHd
    case Landscape
    case LandscapeSd
    case PortraitHd
    case Portrait
    case PortraitSd

    func getVideoBitrateK() -> Int {
      switch self {
      case .LandscapeHd: return 2048
      case .Landscape: return 768
      case .LandscapeSd: return 256
      case .PortraitHd: return 1024
      case .Portrait: return 768
      case .PortraitSd: return 256
      }
    }

    func getAudioBitrateK() -> Int {
      switch self {
      case .LandscapeHd: return 128
      case .Landscape: return 64
      case .LandscapeSd: return 64
      case .PortraitHd: return 96
      case .Portrait: return 64
      case .PortraitSd: return 64
      }
    }

    func getVideoSize() -> CGSize {
      switch self {
      case .LandscapeHd: return CGSizeMake(1280, 720)
      case .Landscape: return CGSizeMake(640, 360)
      case .LandscapeSd: return CGSizeMake(320, 180)
      case .PortraitHd: return CGSizeMake(640, 640)
      case .Portrait: return CGSizeMake(480, 480)
      case .PortraitSd: return CGSizeMake(240, 240)
      }
    }
  }

  private var videoInfo: TVVideoInfo
  private var postType: PostType
  public init(videoInfo: TVVideoInfo, postType: PostType) {
    self.videoInfo = videoInfo
    self.postType  = postType
  }
  
  public typealias ValidationCheckTask = Task<(completedCount: Int, totalCount: Int), Array<FormatSafe>, FormatError>
  public func validationCheckTask() -> ValidationCheckTask {
    return Task.all([
      durationValidate(),
      fileSizeValidate(),
      dimensionsValidate(),
      aspectRatioValidate(),
      frameRateValidate(),
      audioChannelValidate(),
      audioFormatValidate()])
  }
  
  typealias ValidationTask = Task<Float, FormatSafe, FormatError>
  func durationValidate() -> ValidationTask {
    return ValidationTask { (progress, fulfill, reject, configure) in
      let range = self.postType.getDurationRange()
      let duration = self.videoInfo.duration
      let isValid = range.min...range.max ~= duration
      if isValid {
        fulfill(FormatValid.durationValid)
      } else {
        reject(FormatError.InvalidDuration)
      }
    }
  }
  
  func fileSizeValidate() -> ValidationTask {
    return ValidationTask { (progress, fulfill, reject, configure) in
      let limit = self.postType.getFileSizeLimit()
      let size  = self.videoInfo.fileSize
      let isValid = size <= limit
      if isValid {
        fulfill(FormatValid.fileSizeValid)
      } else {
        reject(FormatError.InvalidFileSize)
      }
    }
  }
  
  func dimensionsValidate() -> ValidationTask {
    return ValidationTask { (progress, fulfill, reject, configure) in
      let limit = self.postType.getDimensionsLimit()
      let dimention = self.videoInfo.dimension
      let isValidWidth  = Int(limit.min.width)...Int(limit.max.width) ~= Int(dimention.width)
      let isValidHeight = Int(limit.min.height)...Int(limit.max.height) ~= Int(dimention.height)
      if isValidWidth && isValidHeight {
        fulfill(FormatValid.dimensionsValid)
      } else {
        fulfill(FormatWarning.UnsafeDimentions)
      }
    }
  }
  
  func aspectRatioValidate() -> ValidationTask {
    return ValidationTask { (progress, fulfill, reject, configure) in
      let limit = self.postType.getAspectRatioLimit()
      let ratio  = self.videoInfo.aspectRatio
      let isValid = limit.min...limit.max ~= ratio
      if isValid {
        fulfill(FormatValid.aspectRatioValid)
      } else {
        fulfill(FormatWarning.UnsafeAspectRatio)
      }
    }
  }
  
  func frameRateValidate() -> ValidationTask {
    return ValidationTask { (progress, fulfill, reject, configure) in
      let limit = self.postType.getMaxFrameRate()
      let fps  = self.videoInfo.fps
      let isValid = fps <= limit
      if isValid {
        fulfill(FormatValid.frameRateValid)
      } else {
        reject(FormatError.InvalidFrameRate)
      }
    }
  }
  
  func audioChannelValidate() -> ValidationTask {
    return ValidationTask { (progress, fulfill, reject, configure) in
      let limit = [1, 2]
      let channelCount  = self.videoInfo.channelCount
      let isValid = limit.contains(channelCount)
      if isValid {
        fulfill(FormatValid.audioChannelValid)
      } else {
        fulfill(FormatWarning.UnsafeAudioChannel)
      }
    }
  }
  
  func audioFormatValidate() -> ValidationTask {
    return ValidationTask { (progress, fulfill, reject, configure) in
      let formats = ["AAC-LC"]
      let audioFormat  = self.videoInfo.getAudioFormat()
      let isValid = formats.contains(audioFormat)
      if isValid {
        fulfill(FormatValid.audioFormatValid)
      } else {
        reject(FormatError.InvalidAudioFormat)
      }
    }
  }
}

public class TVVideoInfo: CustomStringConvertible {
  private var videoUrl: NSURL
  private let asset: AVURLAsset
  private(set) var duration: Float64 = 0
  private(set) var fileSize: UInt64 = 0
  private(set) var dimension: CGSize = CGSizeZero
  private(set) var aspectRatio: Float = 1.0
  private(set) var channelCount: Int = 0
  private(set) var fps: Float = 0.0
  private(set) var audioFormat: String = ""
  
  public init(videoUrl: NSURL) {
    self.videoUrl = videoUrl
    asset = AVURLAsset(URL: videoUrl)
    duration = getDuration()
    fileSize = getFileSize()
    dimension = getVideoDimensions()
    aspectRatio = Float(dimension.width / dimension.height)
    channelCount = getAudioChannelCount()
    fps = getFps()
    audioFormat = getAudioFormat()
  }
  
  private func getDuration() -> Float64 {
    let cmTime = asset.duration
    let duration = CMTimeGetSeconds(cmTime)
    return duration
  }
  
  private func getFileSize() -> UInt64 {
    do {
      var attr: NSDictionary = try NSFileManager.defaultManager().attributesOfItemAtPath(videoUrl.path!)
      return attr.fileSize()
    } catch {
      return 0
    }
  }
  
  private func getFps() -> Float {
    return asset.videoTrack?.nominalFrameRate ?? 0.0
  }
  
  private func getVideoDimensions() -> CGSize {
    return asset.videoTrack?.naturalSize ?? CGSizeZero
  }
  
  private func getAudioChannelCount() -> Int {
    //TODO: しっかり検出する
    return 2
  }
  
  private func getAudioFormat() -> String {
    //TODO: しっかり検出する
    return "AAC-LC"
  }
  
  public var description: String {
    get {
      return "---- Video Track Infomation ---\n" +
        "File Path: \(videoUrl.absoluteString)\n" +
        "Duration:  \(duration)sec\n" +
        "File Size: \(Float(fileSize) / 1024.0 / 1024.0)MB (\(fileSize)B)\n" +
        "Dimension: \(dimension.width) x \(dimension.height) [width x height]\n" +
        "Aspect Ratio: \(aspectRatio)\n" +
        "Channel Count: \(channelCount)\n" +
        "FPS: \(fps)\n" +
      "--------------------------\n"
    }
  }
}

extension AVURLAsset {
  var videoTrack: AVAssetTrack? { get { return tracksWithMediaType(AVMediaTypeVideo).first } }
}
