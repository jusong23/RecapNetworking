import UIKit

struct Person: Codable{
   var firstName: String
   var lastName: String
   var birthDate: Date
   var address: String?
}

let p = Person(firstName: "John", lastName: "Doe", birthDate: Date(timeIntervalSince1970: 1234567), address: "Seoul")

//
let encoder = JSONEncoder() // struct Person 객체를 JSON 문자열로 바꿔줌(Encoding)
encoder.outputFormatting = .prettyPrinted

do {
    let jsonData = try encoder.encode(p) //JSON 문자열을 바이너리 형태로

    print(jsonData)
    
    if let jsonStr = String(data: jsonData, encoding: .utf8) {
        print(jsonStr)
    }
    
} catch {
    print(error)
}
//

// swift 객체(struct) -> JSON -> 바이너리

//: [Next](@next)
