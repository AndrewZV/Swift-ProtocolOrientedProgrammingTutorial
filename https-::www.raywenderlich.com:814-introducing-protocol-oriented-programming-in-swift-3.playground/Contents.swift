//***RACING PARTICIPANTS***
protocol Bird: CustomStringConvertible {    //In OOP would be a Sub Class of Flyable, Protocols can conform to Standard Library Protocols too
    var name: String { get }
    var canFly: Bool { get }
}
extension Bird {
    //Flyable birds automatically assigned canFly bool by seeing if they conform to Flyable!
    var canFly: Bool { return self is Flyable }
}
extension CustomStringConvertible where Self: Bird {    //Prevents the need to add a description protocol to everything that conforms to Bird
    var description: String {       //CustomStringConvertible requires a desciption Property
        return canFly ? "I am a \(name) and I can fly!" : "I am a \(name) and I can't fly!"
    }
}

protocol Flyable {                          //In OOP, would be a Base Class
    var airspeedVelocity: Double { get }
}

struct FlappyBird: Bird, Flyable {  //Swift allows us to conform to more than one protocol, so structs can be decorated with default behaviours from multiple
    let name: String
    let flappyAmplitude: Double
    let flappyFrequency: Double
    
    var airspeedVelocity: Double {                      //Computed Property
        return 3 * flappyFrequency * flappyAmplitude
    }
}

struct Penguin: Bird {  //Penguin can't fly so is a Bird but not Flyable (good thing not using inheritance!)
    let name: String
}

struct SwiftBird: Bird, Flyable {
    var name: String { return "Swift \(version)"}
    let version: Double
    
    //Swift is Faster every version!
    var airspeedVelocity: Double { return version * 1000.0 }
}

//Enums cannot contain stored properties (e.g. var name: String) only COMPUTED!
enum UnladenSwallow: Bird, Flyable {    //Enums can conform to protocols too
    case african
    case european
    case unknown
    
    var name: String {
        switch self {
        case .african:
            return "African"
        case .european:
            return "European"
        case .unknown:
            return "What do you mean? African or European?"
        }
    }
    
    var airspeedVelocity: Double {
        switch self {
        case .african:
            return 10.0
        case .european:
            return 9.9
        case .unknown:
            fatalError("Unknown Swallow Type!")
        }
    }
}
extension UnladenSwallow {  //We don't want .unknown to return true for canFly so add an extension
    var canFly: Bool {
        return self != .unknown
    }
}

class Motorcyle {
    var name: String
    var speed: Double
    
    init(name: String) {
        self.name = name
        speed = 200
    }
}

//***RACING MODELLING***
protocol Racer {
    var speed: Double { get } //speed is the only thing racers care about
}

extension FlappyBird: Racer {
    var speed: Double {
        return airspeedVelocity
    }
}

extension SwiftBird: Racer {
    var speed: Double {
        return airspeedVelocity
    }
}

extension Penguin: Racer {
    var speed: Double {
        return 42
    }
}

extension UnladenSwallow: Racer {
    var speed: Double {
        return canFly ? airspeedVelocity : 0
    }
}

extension Motorcyle: Racer {}   //Already has speed set

let racers: [Racer] = [
    UnladenSwallow.african,
    UnladenSwallow.european,
    UnladenSwallow.unknown,
    Penguin(name: "King Penguin"),
    SwiftBird(version: 3.0),
    FlappyBird(name: "Felipe", flappyAmplitude: 3.0, flappyFrequency: 20.0),
    Motorcyle(name: "Giacomo")
]

//Find the top speed of racers
    //func topSpeed(of racers: [Racer]) -> Double {
    //   return racers.max(by: { $0.speed < $1.speed })?.speed ?? 0
    //}
    //topSpeed(of: racers[1...3]) //ERROR - [Racer] doesn't have ClosedRange subscript

    //More Generic
    //func topSpeed<RacerType: Sequence>(of racers: RacerType) -> Double where RacerType.Iterator.Element == Racer {  //RacerType is the Generic Type and can be any type that conforms to the Sequence protocol
    //     return racers.max(by: { $0.speed < $1.speed })?.speed ?? 0
    //}
extension Sequence where Iterator.Element == Racer {    //extends the Sequence type from Standard Library
    func topSpeed() -> Double {     //Function only available to Sequences of type Racer
        return self.max(by: { $0.speed < $1.speed })?.speed ?? 0
    }
}

print(racers.topSpeed())

protocol Score: Comparable {
    var value: Int { get }
}

struct RacingScore: Score {
    let value: Int
    
    static func < (lhs: RacingScore, rhs: RacingScore) -> Bool {        //Can compare two scores that have not been explicitly defined
        return lhs.value < rhs.value
    }
}
