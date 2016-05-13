//
//  LXKDateSwitch.swift
//  UBossSeller
//
//  Created by 李现科 on 16/4/21.
//  Copyright © 2016年 ulaiber. All rights reserved.
//

import Foundation

class LXKDateSwitch {
    
    enum WeekDay: String {
        
        case Sunday = "周日"
        case Monday = "周一"
        case Tuesday = "周二"
        case Wednesday = "周三"
        case Thursday = "周四"
        case Friday = "周五"
        case Saturday = "周六"
        case Unknown = "未知"
        
        init(weekdayComponent: Int) {
            switch weekdayComponent {
            case 1:
                self = .Sunday
            case 2:
                self = .Monday
            case 3:
                self = .Tuesday
            case 4:
                self = .Wednesday
            case 5:
                self = .Thursday
            case 6:
                self = .Friday
            case 7:
                self = .Saturday
            default:
                self = .Unknown
            }
        }
    }
    
    static let sharedInstance = LXKDateSwitch()
    private let calendar: NSCalendar = {
        let calendar = NSCalendar(identifier: NSCalendarIdentifierGregorian)!
        calendar.timeZone = NSTimeZone.localTimeZone()
        calendar.locale = NSLocale.currentLocale()
        return calendar
    }()
    
    private init() {}
    
    static func transformToDate(dateFormat format: String) -> (fromString: String) -> NSDate? {
        let formatter = NSDateFormatter()
        formatter.dateFormat = format
        return {(fromString: String) -> NSDate? in
            formatter.dateFromString(fromString)
        }
    }
    
    static func transformToString(dateFormat format: String) -> (fromDate: NSDate) -> String {
        let formatter = NSDateFormatter()
        formatter.dateFormat = format
        return {(fromDate: NSDate) -> String in
            formatter.stringFromDate(fromDate)
        }
    }
    
    func firstDayOfMonth(date: NSDate) -> NSDate {
        let componentsOfCurrentDate = calendar.components([.Year, .Month, .Day, .Weekday, .WeekOfMonth], fromDate: date)
        let componentsOfNewDate = NSDateComponents()
        componentsOfNewDate.year = componentsOfCurrentDate.year
        componentsOfNewDate.month = componentsOfCurrentDate.month
        componentsOfNewDate.weekOfMonth = 1
        componentsOfNewDate.day = 1
        return calendar.dateFromComponents(componentsOfNewDate)!
    }

    func lastDayOfMonth(date: NSDate) -> NSDate {
        let componentsOfCurrentDate = calendar.components([.Year, .Month, .Day, .Weekday, .WeekOfMonth], fromDate: date)
        let componentsOfNewDate = NSDateComponents()
        componentsOfNewDate.year = componentsOfCurrentDate.year
        componentsOfNewDate.month = componentsOfCurrentDate.month + 1
        componentsOfNewDate.day = 0
        return calendar.dateFromComponents(componentsOfNewDate)!
    }
    
    func firstDayOfYear(date: NSDate) -> NSDate {
        let componentsOfCurrentDate = calendar.components([.Year, .Month, .Day, .Weekday, .WeekOfMonth], fromDate: date)
        let componentsOfNewDate = NSDateComponents()
        componentsOfNewDate.year = componentsOfCurrentDate.year
        componentsOfNewDate.month = 1
        return calendar.dateFromComponents(componentsOfNewDate)!
    }
    
    func lastDayOfYear(date: NSDate) -> NSDate {
        let componentsOfCurrentDate = calendar.components([.Year, .Month, .Day, .Weekday, .WeekOfMonth], fromDate: date)
        let componentsOfNewDate = NSDateComponents()
        componentsOfNewDate.year = componentsOfCurrentDate.year + 1
        componentsOfNewDate.month = 1
        componentsOfNewDate.day = 0
        return calendar.dateFromComponents(componentsOfNewDate)!
    }

    func addDays(days: Int, toDate date: NSDate) -> NSDate {
        let components = NSDateComponents()
        components.day = days
        return calendar.dateByAddingComponents(components, toDate: date, options: .MatchStrictly)!
    }
    
    func addMonths(months: Int, toDate date: NSDate) -> NSDate {
        let components = NSDateComponents()
        components.month = months
        return calendar.dateByAddingComponents(components, toDate: date, options: .MatchStrictly)!
    }
    
    func addYears(years: Int, toDate date: NSDate) -> NSDate {
        let components = NSDateComponents()
        components.year = years
        return calendar.dateByAddingComponents(components, toDate: date, options: .MatchStrictly)!
    }

    func weekdayOfDate(date: NSDate) -> Int {
        return calendar.component(.Weekday, fromDate: date)
    }
    
    func dayOfDate(date: NSDate) -> Int {
        return calendar.component(.Day, fromDate: date)
    }
    
    func monthOfDate(date: NSDate) -> Int {
        return calendar.component(.Month, fromDate: date)
    }
    
    func yearOfDate(date: NSDate) -> Int {
        return calendar.component(.Year, fromDate: date)
    }
    
    func unwrapUnits(date: NSDate, units: [NSCalendarUnit:Int]) -> NSDate? {
        let components = calendar.componentsInTimeZone(calendar.timeZone, fromDate: date)
        for (unit, value) in units {
            components[unit.rawValue] = value
        }
        return calendar.dateFromComponents(components)
    }
    
    func date(dateA: NSDate, isTheSameDayThanDate dateB: NSDate) -> Bool {
        let componentsOfDateA = calendar.components([.Year, .Month, .Day], fromDate: dateA)
        let componentsOfDateB = calendar.components([.Year, .Month, .Day], fromDate: dateB)
        return componentsOfDateA.year == componentsOfDateB.year && componentsOfDateA.month == componentsOfDateB.month && componentsOfDateA.day == componentsOfDateB.day
    }
    
    func date(dateA: NSDate, isTheSameMonthThanDate dateB: NSDate) -> Bool {
        let componentsOfDateA = calendar.components([.Year, .Month], fromDate: dateA)
        let componentsOfDateB = calendar.components([.Year, .Month], fromDate: dateB)
        return componentsOfDateA.year == componentsOfDateB.year && componentsOfDateA.month == componentsOfDateB.month
    }
    
    func date(dateA: NSDate, isTheSameYearThanDate dateB: NSDate) -> Bool {
        let componentsOfDateA = calendar.components([.Year], fromDate: dateA)
        let componentsOfDateB = calendar.components([.Year], fromDate: dateB)
        return componentsOfDateA.year == componentsOfDateB.year
    }
    
    func daysFromDate(dateA: NSDate, toDate dateB: NSDate) -> Int {
        return calendar.components([.Day], fromDate: dateA, toDate: dateB, options: .MatchStrictly).day
    }
}

extension NSCalendarUnit: Hashable {
    public var hashValue: Int {
        get {
            return Int(self.rawValue)
        }
    }
    
}

extension NSDateComponents {
    subscript(unit: NSCalendarUnit.RawValue) -> Int {
        get {
            switch NSCalendarUnit(rawValue: unit) {
            case NSCalendarUnit.Era:
                return self.era
            case NSCalendarUnit.Year:
                return self.year
            case NSCalendarUnit.YearForWeekOfYear:
                return self.yearForWeekOfYear
            case NSCalendarUnit.Quarter:
                return self.quarter
            case NSCalendarUnit.Month:
                return self.month
            case NSCalendarUnit.WeekOfYear:
                return self.weekOfYear
            case NSCalendarUnit.WeekOfMonth:
                return self.weekOfMonth
            case NSCalendarUnit.Weekday:
                return self.weekday
            case NSCalendarUnit.WeekdayOrdinal:
                return self.weekdayOrdinal
            case NSCalendarUnit.Day:
                return self.day
            case NSCalendarUnit.Hour:
                return self.hour
            case NSCalendarUnit.Minute:
                return self.minute
            case NSCalendarUnit.Second:
                return self.second
            case NSCalendarUnit.Nanosecond:
                return self.nanosecond
            case NSCalendarUnit.Calendar, NSCalendarUnit.TimeZone:
                return Int.allZeros
            default:
                return Int.allZeros
            }
        }
        set {
            switch NSCalendarUnit(rawValue: unit) {
            case NSCalendarUnit.Era:
                self.era = newValue
            case NSCalendarUnit.Year:
                self.year = newValue
            case NSCalendarUnit.YearForWeekOfYear:
                self.yearForWeekOfYear = newValue
            case NSCalendarUnit.Quarter:
                self.quarter = newValue
            case NSCalendarUnit.Month:
                self.month = newValue
            case NSCalendarUnit.WeekOfYear:
                self.weekOfYear = newValue
            case NSCalendarUnit.WeekOfMonth:
                self.weekOfMonth = newValue
            case NSCalendarUnit.Weekday:
                self.weekday = newValue
            case NSCalendarUnit.WeekdayOrdinal:
                self.weekdayOrdinal = newValue
            case NSCalendarUnit.Day:
                self.day = newValue
            case NSCalendarUnit.Hour:
                self.hour = newValue
            case NSCalendarUnit.Minute:
                self.minute = newValue
            case NSCalendarUnit.Second:
                self.second = newValue
            case NSCalendarUnit.Nanosecond:
                self.nanosecond = newValue
            case NSCalendarUnit.Calendar, NSCalendarUnit.TimeZone:
                break
            default:
                break
            }
        }
    }
}

extension NSDate {
    
    var tomorrow: NSDate {
        get {
            return NSDate(timeInterval: 24 * 60 * 60, sinceDate: self)
        }
    }
    
    var yestoday: NSDate {
        get {
            return NSDate(timeInterval: -24 * 60 * 60, sinceDate: self)
        }
    }
}




