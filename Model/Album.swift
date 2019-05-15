import Foundation


struct album {
    private(set) public var title: String
    private(set) public var artist: String
    private(set) public var imageName: String
    
    init(title: String, artist: String, imageName: String) {
        self.title = title
        self.artist = artist
        self.imageName = imageName
    }
}
