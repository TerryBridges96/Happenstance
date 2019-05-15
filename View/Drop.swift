import CoreLocation
import Firebase

class Drop: Equatable {

    let song: String
    let coordinate: CLLocationCoordinate2D
    let uuid: String
    let songId: String
    let artist: String
    let genre: String
    let artwork: String

    init(snapshot: DataSnapshot){
        let data = snapshot.value as! [String: Any]
        uuid = snapshot.key
        song = data["song"] as! String
        songId = data["songId"] as! String
        coordinate = CLLocationCoordinate2D(latitude: data["lat"] as! Double, longitude: data["lng"] as! Double)
        artist = data["artist"] as! String
        genre = data["genre"] as! String
        artwork = data["artwork"] as! String
    }
    
    
    static func ==(lhs: Drop, rhs: Drop) -> Bool {
        return lhs.uuid == rhs.uuid
    }
}


