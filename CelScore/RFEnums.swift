//
//  RFEnums.swift
//  RFZodiacExt
//
//  Created by Rich Fellure on 3/6/15.
//  Copyright (c) 2015 RichApps. All rights reserved.
//

import Foundation


//MARK: Error
enum SettingsError: Int, Error { case noCelebrityModels, noRatingsModel, noUserRatingsModel, outOfBoundsVariance, noUser }
enum SettingType: Int { case defaultListIndex = 0, loginTypeIndex, publicService, onCountdown, firstLaunch, firstDetail, firstConsensus, firstPublic, firstFollow, firstInterest, firstCompleted, first25, first50, first75, firstVoteDisable, firstSocialDisable, firstTrollWarning }
enum RatingsError: Int, Error { case ratingsNotFound = 0, userRatingsNotFound, ratingValueOutOfBounds, ratingIndexOutOfBounds }
enum ListError: Int, Error { case emptyList = 0, indexOutOfBounds, noLists }
enum CelebrityError: Int, Error { case notFound = 0 }
enum NetworkError: Int, Error { case notConnected = 1 }


//MARK: Misc.
enum RatingsType { case ratings, userRatings }
enum AWSDataType { case celebrity, list, ratings }
enum CognitoDataSet: String { case facebookInfo, twitterInfo, userRatings, userSettings }

//MARK: SocialLogin
enum SocialLogin: Int {
    case none = 0
    case facebook = 1
    case twitter = 2
    
    func serviceUnavailable() -> String {
        switch self {
        case .facebook: return "Sharing on Facebook is unavailable. Please check the settings and make sure your Facebook account is accessible."
        case .twitter: return "Sharing on Twitter is unavailable. Please check the settings and make sure your Twitter account is accessible."
        default: return "Social sharing is unavailable. Please check the settings and make sure your social accounts are accessible."
        }
    }
    
    func getTitle() -> String {
        switch self {
        case .facebook: return "Facebook"
        case .twitter: return "Twitter"
        default: return ""
        }
    }
}

//MARK: OverlayInfo
enum OverlayInfo {
    case welcomeUser
    case menuAccess
    case loginSuccess
    case maxFollow
    case firstDetail
    case firstFollow
    case firstConsensus
    case firstPublic
    case firstInterest
    case firstCompleted
    case firstVoteDisable
    case firstTrollWarning
    case first25
    case first50
    case first75
    case noSharing
    case voteHelp
    case infoSource
    case logoutUser
    case loginError
    case networkError
    case timeoutError
    case permissionError
    
    func message(_ social: String = "") -> String {
        switch self {
        case .welcomeUser: return "1. To give someone the power and title of a king or queen.\n2. To declare or acknowledge someone as the best.\n3. To bring to a successful conclusion.\n\nEvery night at 9pm PST, we crown the King of Hollywood."
        case .firstDetail: return "1. To acknowledge with a social gathering or enjoyable activity.\n2. To perform a religious ceremony publicly and duly.\n3. To honor or praise publicly.\n\nEveryday we celebrate the stars, every night we crown a monarch."
        case .menuAccess: return "1. To bring together to form a unit.\n2. To enter into or engage in battle.\n3. To become a member of a group or organization.\n\nRegistration to Celeb&Noble is for Hollywood royalty and loyal fans only."
        case .loginSuccess: return "Your registration was successful!"
        case .maxFollow: return "You've reached the maximum number of celebrities you can follow on CNN."
        case .firstFollow: return "You can now see CNN updates in the Today View.\n\nSwipe down from the top of your screen to display the view."
        case .firstConsensus: return "We came here to chew gum and build consensus, and we’re all out of bubblegum.\n\nThe consensus has been enabled and will show up after every vote."
        case .firstPublic: return "There are only two types of opinions: public opinion, and opinion that doesn’t matter because it wasn’t made public.\n\nYou can share your opinion by long pressing on a star's information."
        case .firstInterest: return "Your selection is automatically saved."
        case .first25: return "You've cast your votes on 25% of the celebrities on CNN.\n\nThank you for celebrating."
        case .first50: return "You've cast your votes on 50% of the celebrities on CNN.\n\nThank you for celebrating."
        case .first75: return "You've cast your votes on 75% of the celebrities on CNN.\n\nThank you for celebrating."
        case .voteHelp: return "The voting button\nis for registered users to send and update theirs votes.\n\nEach vote must have all ten qualities."
        case .infoSource: return "The profile view\n(middle button in the menu)\nis based on data from search engine results.\n\nIf the information is outdated or inaccurate please let us know by filling a report in the settings."
        case .firstCompleted: return "You've cast your votes on every celebrity on CNN.\n\nThank you for celebrating."
        case .noSharing: return "You can share any of the information below the menu by long pressing on the item.\n\nTo enable sharing, go to settings and select the\nPublic Service mode."
        case .firstVoteDisable: return "You need to first register on Celeb&Noble."
        case .firstTrollWarning: return "Warning: below a certain level of negative votes, all your votes will be discarded."
        case .logoutUser: return "Thank you for celebrating."
        case .loginError: return "Unable to log in.\n\nIn Settings, check your network connection and that the CelebrityScore is enabled with your \(social) account.\n\nLog in again, and please contact us if the problem persists."
        case .networkError: return "Unable to connect to the cloud.\n\nIn Settings, check your network connection.\n\nPlease contact us if the problem persists."
        case .timeoutError: return "Unable to connect to the cloud.\n\nIn Settings, check your network connection and that the CelebrityScore is enabled with your \(social) account.\n\nPlease contact us if the problem persists."
        case .permissionError: return "Unable to authenticate using your \(social) account.\n\nIn Settings, check that the CelebrityScore is enabled with your \(social) account.\n\nPlease contact us if the problem persists."
        }
    }
    
    func logo() -> UIImage {
        switch self {
        case .welcomeUser: return R.image.big_crown_blue()!
        case .menuAccess: return R.image.contract_red_big()!
        case .loginSuccess: return R.image.hourglass_black()!
        case .maxFollow: return R.image.observatory_red()!
        case .firstFollow: return R.image.sphere_red()!
        case .firstDetail: return R.image.celebration_cup_blue()!
        case .firstConsensus: return R.image.worker_blue_big()!
        case .firstPublic: return R.image.sphere_blue_big()!
        case .firstInterest: return R.image.geometry_red()!
        case .first25: return R.image.sphere_red()!
        case .first50: return R.image.sphere_red()!
        case .first75: return R.image.sphere_red()!
        case .voteHelp: return R.image.mic_blue()!
        case .infoSource: return R.image.head_red()!
        case .firstCompleted: return R.image.sphere_red()!
        case .noSharing: return R.image.sphere_blue()!
        case .firstVoteDisable: return R.image.mic_red()!
        case .firstTrollWarning: return R.image.nuclear_red()!
        case .logoutUser: return R.image.sphere_blue()!
        case .loginError: return R.image.cloud_red()!
        case .networkError: return R.image.cloud_red()!
        case .timeoutError: return R.image.cloud_red()!
        case .permissionError: return R.image.cloud_red()!
        }
    }
    
    static func getOptions() -> TAOverlayOptions {
        return [.overlaySizeRoundedRect, .overlayDismissTap, .overlayAnimateTransistions, .overlayShadow]
    }
}

//MARK: GaugeFace
enum GaugeFace: Int {
    case grin
    case bigSmile
    case smile
    case noSmile
    case sadFace
    case angry
    case awaking
    case tongueOut
    case shades
    
    func emoji() -> String {
        switch self {
        case .grin: return ""
        case .bigSmile: return ""
        case .smile: return ""
        case .noSmile: return ""
        case .sadFace: return ""
        case .angry: return ""
        case .awaking: return ""
        case .tongueOut: return ""
        case .shades: return ""
        }
    }
}

//MARK: Info
enum Info: Int {
    case firstName
    case middleName
    case lastName
    case from
    case birthdate
    case height
    case zodiac
    case status
    case throne
    case networth
    
    static func getAll() -> [String] {
        return [
            firstName.name(),
            middleName.name(),
            lastName.name(),
            from.name(),
            birthdate.name(),
            height.name(),
            zodiac.name(),
            status.name(),
            throne.name(),
            networth.name()
        ]
    }
    
    func name() -> String {
        switch self {
        case .firstName: return "First Name"
        case .middleName: return "Middle Name"
        case .lastName: return "Last Name"
        case .from: return "From"
        case .birthdate: return "Date of Birth"
        case .height: return "Height"
        case .zodiac: return "Zodiac"
        case .status: return "Status"
        case .throne: return "On The Throne"
        case .networth: return "Networth"
        }
    }
    
    func text() -> String {
        switch self {
        case .firstName: return "first name is"
        case .middleName: return "middle name is"
        case .lastName: return "last name is"
        case .from: return "is from"
        case .birthdate: return "was born"
        case .height: return "height is"
        case .zodiac: return "zodiac sign is"
        case .status: return "relationship status is"
        case .throne: return "day(s) on the throne are"
        case .networth: return "networth is"
        }
    }
}

//MARK: Qualities
enum Qualities: Int {
    case talent
    case originality
    case authenticity
    case generosity
    case roleModel
    case hardWork
    case smarts
    case charisma
    case elegance
    case sexAppeal
    
    static func getAll(isMale: Bool = true) -> [String] {
        return [
            talent.name(),
            originality.name(),
            authenticity.name(),
            generosity.name(),
            roleModel.name(),
            hardWork.name(),
            smarts.name(),
            charisma.name(),
            elegance.name(isMale: isMale),
            sexAppeal.name(isMale: isMale)
        ]
    }

    func name(isMale: Bool = true) -> String {
        switch self {
        case .talent: return "Talent"
        case .originality: return "Originality"
        case .authenticity: return "Authenticity"
        case .generosity: return "Generosity"
        case .roleModel: return "Role Model"
        case .hardWork: return "Work Ethic"
        case .smarts: return "Smarts"
        case .charisma: return "Charisma"
        case .elegance: return isMale == true ? "Style" : "Elegance"
        case .sexAppeal: return isMale == true ? "Handsome" : "Beauty"
        }
    }
    
    func text(isMale: Bool = true) -> String {
        switch self {
        case .talent: return "talent is"
        case .originality: return "originality is"
        case .authenticity: return "authenticity is"
        case .generosity: return "generosity is"
        case .roleModel: return "as a role model is"
        case .hardWork: return "work ethic is"
        case .smarts: return "smarts are"
        case .charisma: return "charisma is"
        case .elegance: return isMale == true ? "style is" : "elegance is"
        case .sexAppeal: return isMale == true ? "handsomeness is" : "beauty is"
        }
    }
}

//MARK: ListInfo
enum ListInfo : Int {
    case publicOpinion
    case hollywood
    case hipHop
    case sports
    case music
    case television
    case news
    
    static func getAllNames() -> [String] {
        return [
            publicOpinion.name(),
            hollywood.name(),
            hipHop.name(),
            sports.name(),
            music.name(),
            television.name(),
            news.name()
        ]
    }
    
    static func getAllIDs() -> [String] {
        return [
            publicOpinion.getId(),
            hollywood.getId(),
            hipHop.getId(),
            sports.getId(),
            music.getId(),
            television.getId(),
            news.getId()
        ]
    }
    
    static func getCount() -> Int {
        var max: Int = 0
        while let _ = ListInfo(rawValue: max) { max += 1 }
        return max
    }
    
    func name() -> String {
        switch self {
        case .publicOpinion: return "Public Opinion"
        case .hollywood: return "Hollywood"
        case .hipHop: return "Hip Hop"
        case .sports: return "Sports"
        case .music: return "Music"
        case .television: return "Television"
        case .news: return "New"
        }
    }
    
    func getId() -> String {
        switch self {
        case .publicOpinion: return "0001"
        case .hollywood: return "0004"
        case .hipHop: return "0007"
        case .sports: return "0002"
        case .music: return "0003"
        case .television: return "0005"
        case .news: return "0006"
        }
    }
    
    func getIndex() -> Int {
        switch self {
        case .publicOpinion: return 0
        case .hollywood: return 1
        case .hipHop: return 2
        case .sports: return 3
        case .music: return 4
        case .television: return 5
        case .news: return 6
        }
    }
}

//MARK: Zodiac
enum Zodiac : Int {
    case aries
    case taurus
    case gemini
    case cancer
    case leo
    case virgo
    case libra
    case scorpio
    case sagittarius
    case capricorn
    case aquarius
    case pisces

    func name() -> String {
        switch self {
        case .aries: return "Aries"
        case .taurus: return "Taurus"
        case .gemini: return "Gemini"
        case .cancer: return "Cancer"
        case .leo: return "Leo"
        case .virgo: return "Virgo"
        case .libra: return "Libra"
        case .scorpio: return "Scorpio"
        case .sagittarius: return "Sagittarius"
        case .capricorn: return "Capricorn"
        case .aquarius: return "Aquarius"
        case .pisces: return "Pisces"
        }
    }

    func symbol() -> String {
        switch self {
            case .aries: return "♈"
            case .taurus: return "♉"
            case .gemini: return "♊"
            case .cancer: return "♋"
            case .leo: return "♌"
            case .virgo: return "♍"
            case .libra: return "♎"
            case .scorpio: return "♏"
            case .sagittarius: return "♐"
            case .capricorn: return "♑"
            case .aquarius: return "♒"
            case .pisces: return "♓"
        }
    }
}
