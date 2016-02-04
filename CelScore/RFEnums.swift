//
//  RFEnums.swift
//  RFZodiacExt
//
//  Created by Rich Fellure on 3/6/15.
//  Copyright (c) 2015 RichApps. All rights reserved.
//

import Foundation


public enum CelebList : Int {
    case PublicOpinion
    case Ubuntu
    case Hollywood
    case Sports
    case Music
    case Television
    case Candidates
    
    //MARK: Methods
    public static func getAll() -> [String] {
        return [PublicOpinion.name(), Ubuntu.name(), Hollywood.name(), Sports.name(), Music.name(), Television.name(), Candidates.name()]
    }
    
    public static func getCount() -> Int {
        var max: Int = 0
        while let _ = CelebList(rawValue: max) { max += 1 }
        return max
    }
    
    public func name() -> String {
        switch self {
        case .PublicOpinion: return "#PublicOpinon"
        case .Ubuntu: return "#Ubuntu"
        case .Hollywood: return "#Hollywood"
        case .Sports: return "#Sports"
        case .Music: return "#Music"
        case .Television: return "#Television"
        case .Candidates: return "#Candidates"
        }
    }
    
    public func getId() -> String {
        switch self {
        case .PublicOpinion: return "0001"
        case .Ubuntu: return "0007"
        case .Hollywood: return "0004"
        case .Sports: return "0002"
        case .Music: return "0003"
        case .Television: return "0005"
        case .Candidates: return "0006"
        }
    }
}

public enum Zodiac : Int {
    case Aries
    case Taurus
    case Gemini
    case Cancer
    case Leo
    case Virgo
    case Libra
    case Scorpio
    case Sagittarius
    case Capricorn
    case Aquarius
    case Pisces

    //MARK: Methods
    public func name() -> String {
        switch self {
        case .Aries: return "Aries"
        case .Taurus: return "Taurus"
        case .Gemini: return "Gemini"
        case .Cancer: return "Cancer"
        case .Leo: return "Leo"
        case .Virgo: return "Virgo"
        case .Libra: return "Libra"
        case .Scorpio: return "Scorpio"
        case .Sagittarius: return "Sagittarius"
        case .Capricorn: return "Capricorn"
        case .Aquarius: return "Aquarius"
        case .Pisces: return "Pisces"
        }
    }

    public func compatableTypes() -> [Zodiac] {
        switch self {
        case .Aries: return [.Gemini, .Sagittarius, .Leo, .Aquarius]
        case .Taurus: return [.Capricorn, .Pisces, .Virgo, .Cancer]
        case .Gemini: return [.Aquarius, .Libra, .Aries, .Leo]
        case .Cancer: return [.Pisces, .Taurus, .Scorpio, .Virgo]
        case .Leo: return [.Sagittarius, .Aries, .Gemini, .Libra]
        case .Virgo: return [.Taurus, .Capricorn, .Cancer]
        case .Libra: return [.Gemini, .Aquarius, .Leo, .Sagittarius]
        case .Scorpio: return [.Pisces, .Cancer, .Capricorn, .Virgo]
        case .Sagittarius: return [.Leo, .Aries, .Libra, .Aquarius]
        case .Capricorn: return [.Taurus, .Virgo, .Pisces, .Scorpio]
        case .Aquarius: return [.Gemini, .Libra, .Sagittarius, .Aries]
        case .Pisces: return [.Cancer, .Scorpio, .Taurus, .Capricorn]
        }
    }

    public func symbol() -> String {
        switch self {
            case .Aries: return "♈"
            case .Taurus: return "♉"
            case .Gemini: return "♊"
            case .Cancer: return "♋"
            case .Leo: return "♌"
            case .Virgo: return "♍"
            case .Libra: return "♎"
            case .Scorpio: return "♏"
            case .Sagittarius: return "♐"
            case .Capricorn: return "♑"
            case .Aquarius: return "♒"
            case .Pisces: return "♓"
        }
    }
}