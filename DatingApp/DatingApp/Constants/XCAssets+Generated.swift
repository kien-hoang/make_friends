// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

#if os(macOS)
  import AppKit
#elseif os(iOS)
  import UIKit
#elseif os(tvOS) || os(watchOS)
  import UIKit
#endif

// Deprecated typealiases
@available(*, deprecated, renamed: "ColorAsset.Color", message: "This typealias will be removed in SwiftGen 7.0")
internal typealias AssetColorTypeAlias = ColorAsset.Color
@available(*, deprecated, renamed: "ImageAsset.Image", message: "This typealias will be removed in SwiftGen 7.0")
internal typealias AssetImageTypeAlias = ImageAsset.Image

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Asset Catalogs

// swiftlint:disable identifier_name line_length nesting type_body_length type_name
internal enum Asset {
  internal enum Authentication {
    internal enum InitUser {
      internal static let initUserAdd = ImageAsset(name: "init_user_add")
    }
    internal enum Signup {
      internal static let icCalendar = ImageAsset(name: "ic_calendar")
      internal static let icHideEye = ImageAsset(name: "ic_hide_eye")
      internal static let icUnhideEye = ImageAsset(name: "ic_unhide_eye")
    }
  }
  internal enum Colors {
    internal enum Global {
      internal static let black100 = ColorAsset(name: "black100")
      internal static let gray777777 = ColorAsset(name: "gray777777")
      internal static let gray9A9A9A = ColorAsset(name: "gray9A9A9A")
      internal static let grayF1F1F1 = ColorAsset(name: "grayF1F1F1")
      internal static let grayF2F2F7 = ColorAsset(name: "grayF2F2F7")
      internal static let redD41717 = ColorAsset(name: "redD41717")
      internal static let white100 = ColorAsset(name: "white100")
    }
  }
  internal enum Global {
    internal static let icAddImage = ImageAsset(name: "ic_add_image")
    internal static let icAddVideo = ImageAsset(name: "ic_add_video")
    internal static let icDefaultBack = ImageAsset(name: "ic_default_back")
    internal static let icDefaultClose = ImageAsset(name: "ic_default_close")
    internal static let icDefaultNext = ImageAsset(name: "ic_default_next")
    internal static let icDownArrow = ImageAsset(name: "ic_down_arrow")
    internal static let icLightLogo = ImageAsset(name: "ic_light_logo")
    internal static let icLocation = ImageAsset(name: "ic_location")
    internal static let icPlaceholderLogo = ImageAsset(name: "ic_placeholder_logo")
    internal static let icPlayVideo = ImageAsset(name: "ic_play_video")
    internal static let icSearch = ImageAsset(name: "ic_search")
    internal static let swipeBack = ImageAsset(name: "swipe_back")
    internal static let swipeDislike = ImageAsset(name: "swipe_dislike")
    internal static let swipeLike = ImageAsset(name: "swipe_like")
    internal static let swipeNext = ImageAsset(name: "swipe_next")
  }
  internal enum Profile {
    internal static let icEditProfile = ImageAsset(name: "ic_edit_profile")
    internal static let icSetting = ImageAsset(name: "ic_setting")
    internal static let icVerified = ImageAsset(name: "ic_verified")
    internal static let profileAdd = ImageAsset(name: "profile_add")
    internal static let profileDownArrow = ImageAsset(name: "profile_down_arrow")
    internal static let profileGender = ImageAsset(name: "profile_gender")
  }
}
// swiftlint:enable identifier_name line_length nesting type_body_length type_name

// MARK: - Implementation Details

internal final class ColorAsset {
  internal fileprivate(set) var name: String

  #if os(macOS)
  internal typealias Color = NSColor
  #elseif os(iOS) || os(tvOS) || os(watchOS)
  internal typealias Color = UIColor
  #endif

  @available(iOS 11.0, tvOS 11.0, watchOS 4.0, macOS 10.13, *)
  internal private(set) lazy var color: Color = {
    guard let color = Color(asset: self) else {
      fatalError("Unable to load color asset named \(name).")
    }
    return color
  }()

  #if os(iOS) || os(tvOS)
  @available(iOS 11.0, tvOS 11.0, *)
  internal func color(compatibleWith traitCollection: UITraitCollection) -> Color {
    let bundle = BundleToken.bundle
    guard let color = Color(named: name, in: bundle, compatibleWith: traitCollection) else {
      fatalError("Unable to load color asset named \(name).")
    }
    return color
  }
  #endif

  fileprivate init(name: String) {
    self.name = name
  }
}

internal extension ColorAsset.Color {
  @available(iOS 11.0, tvOS 11.0, watchOS 4.0, macOS 10.13, *)
  convenience init?(asset: ColorAsset) {
    let bundle = BundleToken.bundle
    #if os(iOS) || os(tvOS)
    self.init(named: asset.name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    self.init(named: NSColor.Name(asset.name), bundle: bundle)
    #elseif os(watchOS)
    self.init(named: asset.name)
    #endif
  }
}

internal struct ImageAsset {
  internal fileprivate(set) var name: String

  #if os(macOS)
  internal typealias Image = NSImage
  #elseif os(iOS) || os(tvOS) || os(watchOS)
  internal typealias Image = UIImage
  #endif

  @available(iOS 8.0, tvOS 9.0, watchOS 2.0, macOS 10.7, *)
  internal var image: Image {
    let bundle = BundleToken.bundle
    #if os(iOS) || os(tvOS)
    let image = Image(named: name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    let name = NSImage.Name(self.name)
    let image = (bundle == .main) ? NSImage(named: name) : bundle.image(forResource: name)
    #elseif os(watchOS)
    let image = Image(named: name)
    #endif
    guard let result = image else {
      fatalError("Unable to load image asset named \(name).")
    }
    return result
  }

  #if os(iOS) || os(tvOS)
  @available(iOS 8.0, tvOS 9.0, *)
  internal func image(compatibleWith traitCollection: UITraitCollection) -> Image {
    let bundle = BundleToken.bundle
    guard let result = Image(named: name, in: bundle, compatibleWith: traitCollection) else {
      fatalError("Unable to load image asset named \(name).")
    }
    return result
  }
  #endif
}

internal extension ImageAsset.Image {
  @available(iOS 8.0, tvOS 9.0, watchOS 2.0, *)
  @available(macOS, deprecated,
    message: "This initializer is unsafe on macOS, please use the ImageAsset.image property")
  convenience init?(asset: ImageAsset) {
    #if os(iOS) || os(tvOS)
    let bundle = BundleToken.bundle
    self.init(named: asset.name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    self.init(named: NSImage.Name(asset.name))
    #elseif os(watchOS)
    self.init(named: asset.name)
    #endif
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
