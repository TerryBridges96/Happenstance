import MapKit

class DropAnnotation: NSObject, MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D
    var uuid: String!
    var title: String?
    var drop: Drop!
    var artist: String?
    var genre: String?
    var artwork: String?
    
    init(_ drop: Drop) {
        self.drop = drop
        coordinate = drop.coordinate
        uuid = drop.uuid
        title = drop.song
        artist = drop.artist
        genre = drop.genre
        artwork = drop.artwork
        
        super.init()
    }
    
    static func ==(lhs: DropAnnotation, rhs: DropAnnotation) -> Bool {
        return lhs.uuid == rhs.uuid
    }
    
}
