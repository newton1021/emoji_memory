import UIKit

var greeting = "Hello, playground"
let today = Calendar.current.startOfDay(for: Date())
let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: today)!
let sunday = Calendar.current.date(byAdding: .day, value: -Calendar.current.component(.weekday, from: Date()), to: tomorrow)!
let firstOfMonth = Calendar.current.date(byAdding: .day, value: -Calendar.current.component(.day, from: Date()), to: tomorrow)!


