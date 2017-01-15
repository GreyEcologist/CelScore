//
// This is a generated file, do not edit!
// Generated by R.swift, see https://github.com/mac-cain13/R.swift
//

import Foundation
import Rswift
import UIKit

/// This `R` struct is generated and contains references to static resources.
struct R: Rswift.Validatable {
  fileprivate static let applicationLocale = hostingBundle.preferredLocalizations.first.flatMap(Locale.init) ?? Locale.current
  fileprivate static let hostingBundle = Bundle(for: R.Class.self)
  
  static func validate() throws {
    try font.validate()
    try intern.validate()
  }
  
  /// This `R.color` struct is generated, and contains static references to 0 color palettes.
  struct color {
    fileprivate init() {}
  }
  
  /// This `R.file` struct is generated, and contains static references to 2 files.
  struct file {
    /// Resource file `TAOverlay.bundle`.
    static let tAOverlayBundle = Rswift.FileResource(bundle: R.hostingBundle, name: "TAOverlay", pathExtension: "bundle")
    /// Resource file `icomoon2.ttf`.
    static let icomoon2Ttf = Rswift.FileResource(bundle: R.hostingBundle, name: "icomoon2", pathExtension: "ttf")
    
    /// `bundle.url(forResource: "TAOverlay", withExtension: "bundle")`
    static func tAOverlayBundle(_: Void = ()) -> Foundation.URL? {
      let fileResource = R.file.tAOverlayBundle
      return fileResource.bundle.url(forResource: fileResource)
    }
    
    /// `bundle.url(forResource: "icomoon2", withExtension: "ttf")`
    static func icomoon2Ttf(_: Void = ()) -> Foundation.URL? {
      let fileResource = R.file.icomoon2Ttf
      return fileResource.bundle.url(forResource: fileResource)
    }
    
    fileprivate init() {}
  }
  
  /// This `R.font` struct is generated, and contains static references to 1 fonts.
  struct font: Rswift.Validatable {
    /// Font `icomoon`.
    static let icomoon = Rswift.FontResource(fontName: "icomoon")
    
    /// `UIFont(name: "icomoon", size: ...)`
    static func icomoon(size: CGFloat) -> UIKit.UIFont? {
      return UIKit.UIFont(resource: icomoon, size: size)
    }
    
    static func validate() throws {
      if R.font.icomoon(size: 42) == nil { throw Rswift.ValidationError(description:"[R.swift] Font 'icomoon' could not be loaded, is 'icomoon2.ttf' added to the UIAppFonts array in this targets Info.plist?") }
    }
    
    fileprivate init() {}
  }
  
  /// This `R.image` struct is generated, and contains static references to 76 images.
  struct image {
    /// Image `Anonymous`.
    static let anonymous = Rswift.ImageResource(bundle: R.hostingBundle, name: "Anonymous")
    /// Image `angryFace`.
    static let angryFace = Rswift.ImageResource(bundle: R.hostingBundle, name: "angryFace")
    /// Image `arrow_down`.
    static let arrow_down = Rswift.ImageResource(bundle: R.hostingBundle, name: "arrow_down")
    /// Image `arrow_up`.
    static let arrow_up = Rswift.ImageResource(bundle: R.hostingBundle, name: "arrow_up")
    /// Image `arrow_white`.
    static let arrow_white = Rswift.ImageResource(bundle: R.hostingBundle, name: "arrow_white")
    /// Image `astronaut_red`.
    static let astronaut_red = Rswift.ImageResource(bundle: R.hostingBundle, name: "astronaut_red")
    /// Image `big_crown_blue`.
    static let big_crown_blue = Rswift.ImageResource(bundle: R.hostingBundle, name: "big_crown_blue")
    /// Image `celscore_big_white`.
    static let celscore_big_white = Rswift.ImageResource(bundle: R.hostingBundle, name: "celscore_big_white")
    /// Image `celscore_black`.
    static let celscore_black = Rswift.ImageResource(bundle: R.hostingBundle, name: "celscore_black")
    /// Image `celscore_white`.
    static let celscore_white = Rswift.ImageResource(bundle: R.hostingBundle, name: "celscore_white")
    /// Image `cloud_big_blue`.
    static let cloud_big_blue = Rswift.ImageResource(bundle: R.hostingBundle, name: "cloud_big_blue")
    /// Image `cloud_big_red`.
    static let cloud_big_red = Rswift.ImageResource(bundle: R.hostingBundle, name: "cloud_big_red")
    /// Image `cloud_red`.
    static let cloud_red = Rswift.ImageResource(bundle: R.hostingBundle, name: "cloud_red")
    /// Image `contract_blue_big`.
    static let contract_blue_big = Rswift.ImageResource(bundle: R.hostingBundle, name: "contract_blue_big")
    /// Image `contract_red_big`.
    static let contract_red_big = Rswift.ImageResource(bundle: R.hostingBundle, name: "contract_red_big")
    /// Image `court_red`.
    static let court_red = Rswift.ImageResource(bundle: R.hostingBundle, name: "court_red")
    /// Image `court_small_white`.
    static let court_small_white = Rswift.ImageResource(bundle: R.hostingBundle, name: "court_small_white")
    /// Image `court_white`.
    static let court_white = Rswift.ImageResource(bundle: R.hostingBundle, name: "court_white")
    /// Image `cross`.
    static let cross = Rswift.ImageResource(bundle: R.hostingBundle, name: "cross")
    /// Image `crown_black`.
    static let crown_black = Rswift.ImageResource(bundle: R.hostingBundle, name: "crown_black")
    /// Image `crown_blue_mini`.
    static let crown_blue_mini = Rswift.ImageResource(bundle: R.hostingBundle, name: "crown_blue_mini")
    /// Image `crown_filling_blue`.
    static let crown_filling_blue = Rswift.ImageResource(bundle: R.hostingBundle, name: "crown_filling_blue")
    /// Image `crown_filling_red`.
    static let crown_filling_red = Rswift.ImageResource(bundle: R.hostingBundle, name: "crown_filling_red")
    /// Image `crown_filling_yellow`.
    static let crown_filling_yellow = Rswift.ImageResource(bundle: R.hostingBundle, name: "crown_filling_yellow")
    /// Image `crown_red_mini`.
    static let crown_red_mini = Rswift.ImageResource(bundle: R.hostingBundle, name: "crown_red_mini")
    /// Image `crown_white`.
    static let crown_white = Rswift.ImageResource(bundle: R.hostingBundle, name: "crown_white")
    /// Image `emptyCircle`.
    static let emptyCircle = Rswift.ImageResource(bundle: R.hostingBundle, name: "emptyCircle")
    /// Image `facebooklogo`.
    static let facebooklogo = Rswift.ImageResource(bundle: R.hostingBundle, name: "facebooklogo")
    /// Image `formula_blue_big`.
    static let formula_blue_big = Rswift.ImageResource(bundle: R.hostingBundle, name: "formula_blue_big")
    /// Image `geometry_red`.
    static let geometry_red = Rswift.ImageResource(bundle: R.hostingBundle, name: "geometry_red")
    /// Image `happyFace`.
    static let happyFace = Rswift.ImageResource(bundle: R.hostingBundle, name: "happyFace")
    /// Image `head_red`.
    static let head_red = Rswift.ImageResource(bundle: R.hostingBundle, name: "head_red")
    /// Image `heart_black`.
    static let heart_black = Rswift.ImageResource(bundle: R.hostingBundle, name: "heart_black")
    /// Image `heart_white`.
    static let heart_white = Rswift.ImageResource(bundle: R.hostingBundle, name: "heart_white")
    /// Image `ic_add_black`.
    static let ic_add_black = Rswift.ImageResource(bundle: R.hostingBundle, name: "ic_add_black")
    /// Image `ic_add_white`.
    static let ic_add_white = Rswift.ImageResource(bundle: R.hostingBundle, name: "ic_add_white")
    /// Image `ic_close_white`.
    static let ic_close_white = Rswift.ImageResource(bundle: R.hostingBundle, name: "ic_close_white")
    /// Image `ic_menu_white`.
    static let ic_menu_white = Rswift.ImageResource(bundle: R.hostingBundle, name: "ic_menu_white")
    /// Image `ic_search_white`.
    static let ic_search_white = Rswift.ImageResource(bundle: R.hostingBundle, name: "ic_search_white")
    /// Image `info_black`.
    static let info_black = Rswift.ImageResource(bundle: R.hostingBundle, name: "info_black")
    /// Image `info_button`.
    static let info_button = Rswift.ImageResource(bundle: R.hostingBundle, name: "info_button")
    /// Image `info_white`.
    static let info_white = Rswift.ImageResource(bundle: R.hostingBundle, name: "info_white")
    /// Image `jurors_blue_big`.
    static let jurors_blue_big = Rswift.ImageResource(bundle: R.hostingBundle, name: "jurors_blue_big")
    /// Image `jurors_red_big`.
    static let jurors_red_big = Rswift.ImageResource(bundle: R.hostingBundle, name: "jurors_red_big")
    /// Image `mic_blue`.
    static let mic_blue = Rswift.ImageResource(bundle: R.hostingBundle, name: "mic_blue")
    /// Image `mic_red`.
    static let mic_red = Rswift.ImageResource(bundle: R.hostingBundle, name: "mic_red")
    /// Image `mic_yellow`.
    static let mic_yellow = Rswift.ImageResource(bundle: R.hostingBundle, name: "mic_yellow")
    /// Image `nosmileFace`.
    static let nosmileFace = Rswift.ImageResource(bundle: R.hostingBundle, name: "nosmileFace")
    /// Image `nuclear_red`.
    static let nuclear_red = Rswift.ImageResource(bundle: R.hostingBundle, name: "nuclear_red")
    /// Image `observatory_red`.
    static let observatory_red = Rswift.ImageResource(bundle: R.hostingBundle, name: "observatory_red")
    /// Image `planet_red`.
    static let planet_red = Rswift.ImageResource(bundle: R.hostingBundle, name: "planet_red")
    /// Image `profile_black`.
    static let profile_black = Rswift.ImageResource(bundle: R.hostingBundle, name: "profile_black")
    /// Image `profile_white`.
    static let profile_white = Rswift.ImageResource(bundle: R.hostingBundle, name: "profile_white")
    /// Image `sadFace`.
    static let sadFace = Rswift.ImageResource(bundle: R.hostingBundle, name: "sadFace")
    /// Image `scale_black`.
    static let scale_black = Rswift.ImageResource(bundle: R.hostingBundle, name: "scale_black")
    /// Image `scale_white`.
    static let scale_white = Rswift.ImageResource(bundle: R.hostingBundle, name: "scale_white")
    /// Image `score_black`.
    static let score_black = Rswift.ImageResource(bundle: R.hostingBundle, name: "score_black")
    /// Image `score_logo`.
    static let score_logo = Rswift.ImageResource(bundle: R.hostingBundle, name: "score_logo")
    /// Image `score_white`.
    static let score_white = Rswift.ImageResource(bundle: R.hostingBundle, name: "score_white")
    /// Image `smileFace`.
    static let smileFace = Rswift.ImageResource(bundle: R.hostingBundle, name: "smileFace")
    /// Image `spaceship_blue_big`.
    static let spaceship_blue_big = Rswift.ImageResource(bundle: R.hostingBundle, name: "spaceship_blue_big")
    /// Image `spaceship_red_big`.
    static let spaceship_red_big = Rswift.ImageResource(bundle: R.hostingBundle, name: "spaceship_red_big")
    /// Image `spaceship_red`.
    static let spaceship_red = Rswift.ImageResource(bundle: R.hostingBundle, name: "spaceship_red")
    /// Image `sphere_blue_big`.
    static let sphere_blue_big = Rswift.ImageResource(bundle: R.hostingBundle, name: "sphere_blue_big")
    /// Image `sphere_blue_mini`.
    static let sphere_blue_mini = Rswift.ImageResource(bundle: R.hostingBundle, name: "sphere_blue_mini")
    /// Image `sphere_blue`.
    static let sphere_blue = Rswift.ImageResource(bundle: R.hostingBundle, name: "sphere_blue")
    /// Image `sphere_red_big`.
    static let sphere_red_big = Rswift.ImageResource(bundle: R.hostingBundle, name: "sphere_red_big")
    /// Image `sphere_red_mini`.
    static let sphere_red_mini = Rswift.ImageResource(bundle: R.hostingBundle, name: "sphere_red_mini")
    /// Image `sphere_red`.
    static let sphere_red = Rswift.ImageResource(bundle: R.hostingBundle, name: "sphere_red")
    /// Image `sphere_yellow`.
    static let sphere_yellow = Rswift.ImageResource(bundle: R.hostingBundle, name: "sphere_yellow")
    /// Image `star_black`.
    static let star_black = Rswift.ImageResource(bundle: R.hostingBundle, name: "star_black")
    /// Image `star_icon`.
    static let star_icon = Rswift.ImageResource(bundle: R.hostingBundle, name: "star_icon")
    /// Image `topView`.
    static let topView = Rswift.ImageResource(bundle: R.hostingBundle, name: "topView")
    /// Image `twitterlogo`.
    static let twitterlogo = Rswift.ImageResource(bundle: R.hostingBundle, name: "twitterlogo")
    /// Image `worker_blue_big`.
    static let worker_blue_big = Rswift.ImageResource(bundle: R.hostingBundle, name: "worker_blue_big")
    /// Image `worker_red_big`.
    static let worker_red_big = Rswift.ImageResource(bundle: R.hostingBundle, name: "worker_red_big")
    
    /// `UIImage(named: "Anonymous", bundle: ..., traitCollection: ...)`
    static func anonymous(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.anonymous, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "angryFace", bundle: ..., traitCollection: ...)`
    static func angryFace(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.angryFace, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "arrow_down", bundle: ..., traitCollection: ...)`
    static func arrow_down(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.arrow_down, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "arrow_up", bundle: ..., traitCollection: ...)`
    static func arrow_up(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.arrow_up, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "arrow_white", bundle: ..., traitCollection: ...)`
    static func arrow_white(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.arrow_white, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "astronaut_red", bundle: ..., traitCollection: ...)`
    static func astronaut_red(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.astronaut_red, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "big_crown_blue", bundle: ..., traitCollection: ...)`
    static func big_crown_blue(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.big_crown_blue, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "celscore_big_white", bundle: ..., traitCollection: ...)`
    static func celscore_big_white(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.celscore_big_white, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "celscore_black", bundle: ..., traitCollection: ...)`
    static func celscore_black(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.celscore_black, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "celscore_white", bundle: ..., traitCollection: ...)`
    static func celscore_white(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.celscore_white, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "cloud_big_blue", bundle: ..., traitCollection: ...)`
    static func cloud_big_blue(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.cloud_big_blue, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "cloud_big_red", bundle: ..., traitCollection: ...)`
    static func cloud_big_red(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.cloud_big_red, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "cloud_red", bundle: ..., traitCollection: ...)`
    static func cloud_red(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.cloud_red, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "contract_blue_big", bundle: ..., traitCollection: ...)`
    static func contract_blue_big(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.contract_blue_big, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "contract_red_big", bundle: ..., traitCollection: ...)`
    static func contract_red_big(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.contract_red_big, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "court_red", bundle: ..., traitCollection: ...)`
    static func court_red(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.court_red, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "court_small_white", bundle: ..., traitCollection: ...)`
    static func court_small_white(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.court_small_white, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "court_white", bundle: ..., traitCollection: ...)`
    static func court_white(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.court_white, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "cross", bundle: ..., traitCollection: ...)`
    static func cross(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.cross, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "crown_black", bundle: ..., traitCollection: ...)`
    static func crown_black(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.crown_black, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "crown_blue_mini", bundle: ..., traitCollection: ...)`
    static func crown_blue_mini(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.crown_blue_mini, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "crown_filling_blue", bundle: ..., traitCollection: ...)`
    static func crown_filling_blue(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.crown_filling_blue, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "crown_filling_red", bundle: ..., traitCollection: ...)`
    static func crown_filling_red(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.crown_filling_red, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "crown_filling_yellow", bundle: ..., traitCollection: ...)`
    static func crown_filling_yellow(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.crown_filling_yellow, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "crown_red_mini", bundle: ..., traitCollection: ...)`
    static func crown_red_mini(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.crown_red_mini, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "crown_white", bundle: ..., traitCollection: ...)`
    static func crown_white(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.crown_white, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "emptyCircle", bundle: ..., traitCollection: ...)`
    static func emptyCircle(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.emptyCircle, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "facebooklogo", bundle: ..., traitCollection: ...)`
    static func facebooklogo(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.facebooklogo, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "formula_blue_big", bundle: ..., traitCollection: ...)`
    static func formula_blue_big(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.formula_blue_big, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "geometry_red", bundle: ..., traitCollection: ...)`
    static func geometry_red(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.geometry_red, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "happyFace", bundle: ..., traitCollection: ...)`
    static func happyFace(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.happyFace, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "head_red", bundle: ..., traitCollection: ...)`
    static func head_red(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.head_red, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "heart_black", bundle: ..., traitCollection: ...)`
    static func heart_black(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.heart_black, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "heart_white", bundle: ..., traitCollection: ...)`
    static func heart_white(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.heart_white, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "ic_add_black", bundle: ..., traitCollection: ...)`
    static func ic_add_black(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.ic_add_black, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "ic_add_white", bundle: ..., traitCollection: ...)`
    static func ic_add_white(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.ic_add_white, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "ic_close_white", bundle: ..., traitCollection: ...)`
    static func ic_close_white(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.ic_close_white, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "ic_menu_white", bundle: ..., traitCollection: ...)`
    static func ic_menu_white(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.ic_menu_white, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "ic_search_white", bundle: ..., traitCollection: ...)`
    static func ic_search_white(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.ic_search_white, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "info_black", bundle: ..., traitCollection: ...)`
    static func info_black(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.info_black, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "info_button", bundle: ..., traitCollection: ...)`
    static func info_button(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.info_button, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "info_white", bundle: ..., traitCollection: ...)`
    static func info_white(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.info_white, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "jurors_blue_big", bundle: ..., traitCollection: ...)`
    static func jurors_blue_big(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.jurors_blue_big, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "jurors_red_big", bundle: ..., traitCollection: ...)`
    static func jurors_red_big(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.jurors_red_big, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "mic_blue", bundle: ..., traitCollection: ...)`
    static func mic_blue(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.mic_blue, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "mic_red", bundle: ..., traitCollection: ...)`
    static func mic_red(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.mic_red, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "mic_yellow", bundle: ..., traitCollection: ...)`
    static func mic_yellow(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.mic_yellow, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "nosmileFace", bundle: ..., traitCollection: ...)`
    static func nosmileFace(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.nosmileFace, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "nuclear_red", bundle: ..., traitCollection: ...)`
    static func nuclear_red(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.nuclear_red, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "observatory_red", bundle: ..., traitCollection: ...)`
    static func observatory_red(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.observatory_red, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "planet_red", bundle: ..., traitCollection: ...)`
    static func planet_red(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.planet_red, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "profile_black", bundle: ..., traitCollection: ...)`
    static func profile_black(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.profile_black, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "profile_white", bundle: ..., traitCollection: ...)`
    static func profile_white(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.profile_white, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "sadFace", bundle: ..., traitCollection: ...)`
    static func sadFace(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.sadFace, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "scale_black", bundle: ..., traitCollection: ...)`
    static func scale_black(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.scale_black, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "scale_white", bundle: ..., traitCollection: ...)`
    static func scale_white(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.scale_white, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "score_black", bundle: ..., traitCollection: ...)`
    static func score_black(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.score_black, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "score_logo", bundle: ..., traitCollection: ...)`
    static func score_logo(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.score_logo, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "score_white", bundle: ..., traitCollection: ...)`
    static func score_white(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.score_white, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "smileFace", bundle: ..., traitCollection: ...)`
    static func smileFace(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.smileFace, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "spaceship_blue_big", bundle: ..., traitCollection: ...)`
    static func spaceship_blue_big(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.spaceship_blue_big, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "spaceship_red", bundle: ..., traitCollection: ...)`
    static func spaceship_red(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.spaceship_red, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "spaceship_red_big", bundle: ..., traitCollection: ...)`
    static func spaceship_red_big(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.spaceship_red_big, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "sphere_blue", bundle: ..., traitCollection: ...)`
    static func sphere_blue(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.sphere_blue, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "sphere_blue_big", bundle: ..., traitCollection: ...)`
    static func sphere_blue_big(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.sphere_blue_big, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "sphere_blue_mini", bundle: ..., traitCollection: ...)`
    static func sphere_blue_mini(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.sphere_blue_mini, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "sphere_red", bundle: ..., traitCollection: ...)`
    static func sphere_red(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.sphere_red, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "sphere_red_big", bundle: ..., traitCollection: ...)`
    static func sphere_red_big(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.sphere_red_big, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "sphere_red_mini", bundle: ..., traitCollection: ...)`
    static func sphere_red_mini(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.sphere_red_mini, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "sphere_yellow", bundle: ..., traitCollection: ...)`
    static func sphere_yellow(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.sphere_yellow, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "star_black", bundle: ..., traitCollection: ...)`
    static func star_black(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.star_black, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "star_icon", bundle: ..., traitCollection: ...)`
    static func star_icon(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.star_icon, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "topView", bundle: ..., traitCollection: ...)`
    static func topView(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.topView, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "twitterlogo", bundle: ..., traitCollection: ...)`
    static func twitterlogo(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.twitterlogo, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "worker_blue_big", bundle: ..., traitCollection: ...)`
    static func worker_blue_big(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.worker_blue_big, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "worker_red_big", bundle: ..., traitCollection: ...)`
    static func worker_red_big(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.worker_red_big, compatibleWith: traitCollection)
    }
    
    fileprivate init() {}
  }
  
  /// This `R.nib` struct is generated, and contains static references to 1 nibs.
  struct nib {
    /// Nib `LaunchScreen`.
    static let launchScreen = _R.nib._LaunchScreen()
    
    /// `UINib(name: "LaunchScreen", in: bundle)`
    static func launchScreen(_: Void = ()) -> UIKit.UINib {
      return UIKit.UINib(resource: R.nib.launchScreen)
    }
    
    fileprivate init() {}
  }
  
  /// This `R.reuseIdentifier` struct is generated, and contains static references to 0 reuse identifiers.
  struct reuseIdentifier {
    fileprivate init() {}
  }
  
  /// This `R.segue` struct is generated, and contains static references to 0 view controllers.
  struct segue {
    fileprivate init() {}
  }
  
  /// This `R.storyboard` struct is generated, and contains static references to 0 storyboards.
  struct storyboard {
    fileprivate init() {}
  }
  
  /// This `R.string` struct is generated, and contains static references to 0 localization tables.
  struct string {
    fileprivate init() {}
  }
  
  fileprivate struct intern: Rswift.Validatable {
    fileprivate static func validate() throws {
      try _R.validate()
    }
    
    fileprivate init() {}
  }
  
  fileprivate class Class {}
  
  fileprivate init() {}
}

struct _R: Rswift.Validatable {
  static func validate() throws {
    try nib.validate()
  }
  
  struct nib: Rswift.Validatable {
    static func validate() throws {
      try _LaunchScreen.validate()
    }
    
    struct _LaunchScreen: Rswift.NibResourceType, Rswift.Validatable {
      let bundle = R.hostingBundle
      let name = "LaunchScreen"
      
      func firstView(owner ownerOrNil: AnyObject?, options optionsOrNil: [NSObject : AnyObject]? = nil) -> UIKit.UIView? {
        return instantiate(withOwner: ownerOrNil, options: optionsOrNil)[0] as? UIKit.UIView
      }
      
      static func validate() throws {
        if UIKit.UIImage(named: "celscore_big_white") == nil { throw Rswift.ValidationError(description: "[R.swift] Image named 'celscore_big_white' is used in nib 'LaunchScreen', but couldn't be loaded.") }
      }
      
      fileprivate init() {}
    }
    
    fileprivate init() {}
  }
  
  struct storyboard {
    fileprivate init() {}
  }
  
  fileprivate init() {}
}