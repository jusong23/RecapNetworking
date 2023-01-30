//: [Previous](@previous)

import Foundation

enum EncodingError: Error {
   case unknown
   case invalidRange
}

struct Employee: Codable {
   var name: String
   var age: Int
   var address: String?
   
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        
        guard (30...60).contains(age) else {
            throw EncodingError.invalidRange
        } // 인코딩 시 범위 벗어나면 에러처리
        
        try container.encode(age, forKey: .age)
        try container.encodeIfPresent(address, forKey: .address) // Optional
    }
}

let p = Employee(name: "James", age: 30, address: "Seoul")


let encoder = JSONEncoder()
encoder.outputFormatting = .prettyPrinted

do {
   let jsonData = try encoder.encode(p)
   if let jsonStr = String(data: jsonData, encoding: .utf8) {
      print(jsonStr)
   }
} catch {
   print(error)
}






//: [Next](@next)

