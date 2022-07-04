//
//  ViewController.swift
//  Element
//
//  Created by Juhel on 28/06/2022.
//

import Foundation

//Scheduler Model
struct Scheduler {
    let hour: String
    let minute: String
    let config: String
}

//let simulatedTime = "16:10"

let dateFormatter = DateFormatter()

var scheduler = [Scheduler]()

func runCron() {
    for parser in scheduler {
        if parser.config.contains("daily") {
            runMeDaily(scheduler: parser)
        } else if parser.config.contains("hourly") {
            runMeHourly(scheduler: parser)
        } else if parser.config.contains("every_minute") {
            runMeEveryMinute(scheduler: parser)
        } else {
            runMeSixtyTimes(scheduler: parser)
        }
    }
}

//Format the string input in to a date object
func formatStringToTime(currentTime: String) -> Date? {
    dateFormatter.dateFormat = "HH:mm"
    if let date = dateFormatter.date(from: currentTime) {
        return date
    }
    return nil

}

//MARK:- Run Me Daily

func runMeDaily(scheduler: Scheduler) {
    let currentTime = CommandLine.arguments[1]
    //let currentTime = simulatedTime
    if let time = formatStringToTime(currentTime: currentTime) {
        let testTime = "\(scheduler.hour):\(scheduler.minute)"
        
        dateFormatter.dateFormat = "HH:mm"
        let someDateTime = dateFormatter.date(from: testTime)!
        
        let diffComponents = Calendar.current.dateComponents([.hour, .minute], from: time, to: someDateTime) //Check difference between now and desired time
        
        let hours = diffComponents.hour
        let minutes = diffComponents.minute
        
        if hours! < 0 || minutes! < 0 {
            print("\(testTime) tomorrow - \(scheduler.config)")
            return
        }
        
        print("\(testTime) today - \(scheduler.config)")
        return
    }
    
    print("Check time format")
}

//MARK:- Run Me Hourly

func runMeHourly(scheduler: Scheduler){
    let currentTime = CommandLine.arguments[1]
    //let currentTime = simulatedTime
    if let time = formatStringToTime(currentTime: currentTime) {
        let currentHour = currentTime.prefix(2) //get the current hour
        let minsPastTheHour = scheduler.minute
        
        dateFormatter.dateFormat = "HH:mm"
        let someDateTime = dateFormatter.date(from: "\(currentHour):\(minsPastTheHour)")!
        
        let diffComponents = Calendar.current.dateComponents([.hour, .minute], from: time, to: someDateTime)
        
        let hours = diffComponents.hour
        let minutes = diffComponents.minute
        
        
        if hours! < 0 || minutes! < 0 {
            
            let nextHour = Int(currentHour)! + 1
            
            //Display time appropriately if 12am
            if nextHour == 24 {
                print("00:\(minsPastTheHour) tomorrow - \(scheduler.config)")
                return
            }
            
            print("\(String(nextHour)):\(minsPastTheHour) today - \(scheduler.config)")
            return
        }
        
        print("\(currentHour):\(minsPastTheHour) today - \(scheduler.config)")
        return
    }
    
    print("Check time format")
}

//MARK:- Run Me Every Minute

func runMeEveryMinute(scheduler: Scheduler) {
    let currentTime = CommandLine.arguments[1]
    //let currentTime = simulatedTime
    //Display current time if in correct format as scheduler is for every minute
    if formatStringToTime(currentTime: currentTime) != nil {
        print("\(currentTime) today - \(scheduler.config)")
        return
    }
    print("Check time format")
}

//MARK:- Run Me Sixty Times

func runMeSixtyTimes(scheduler: Scheduler) {
    let currentTime = CommandLine.arguments[1]
    //let currentTime = simulatedTime
    if let time = formatStringToTime(currentTime: currentTime) {
        let currentMin = currentTime.suffix(2) //get the current mins past the hour
        let atHour = scheduler.hour
        
        dateFormatter.dateFormat = "HH:mm"
        
        var someDateTime = Date()
        
        if currentTime.prefix(2) != atHour {
            someDateTime = dateFormatter.date(from: "\(atHour):00")!
        } else {
            someDateTime = dateFormatter.date(from: "\(atHour):\(currentMin)")!
        }
        
        let diffComponents = Calendar.current.dateComponents([.hour, .minute], from: time, to: someDateTime)
        
        let hours = diffComponents.hour
        
        switch hours! {
        case ..<0:
            print("\(atHour):00 tomorrow - \(scheduler.config)")
            return
        case 0:
            print("\(atHour):\(currentMin) today - \(scheduler.config)")
            return
        default:
            print("\(atHour):00 today - \(scheduler.config)")
            return
        }
    }
    
    print("Check time format")
}


//schedulers
let scheduler1 = Scheduler(hour: "1", minute: "30", config: "/bin/run_me_daily")
scheduler.append(scheduler1)
let scheduler2 = Scheduler(hour: "*", minute: "45", config: "/bin/run_me_hourly")
scheduler.append(scheduler2)
let scheduler3 = Scheduler(hour: "*", minute: "*", config: "/bin/run_me_every_minute")
scheduler.append(scheduler3)
let scheduler4 = Scheduler(hour: "19", minute: "*", config: "/bin/run_me_sixty_times")
scheduler.append(scheduler4)
runCron()


