import UIKit

class AlbumArtwork: UICollectionViewCell {
    
    @IBOutlet weak var albumImage: UIImageView!
    @IBOutlet weak var artistName: UILabel!
    @IBOutlet weak var songTitle: UILabel!
    
    
    func updateViews(album: album) {
        albumImage.image = UIImage(named: album.imageName)
        artistName.text = album.artist
        songTitle.text = album.title
        
    }
}
