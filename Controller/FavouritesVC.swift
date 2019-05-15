
import UIKit

class FavouritesVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    
    @IBOutlet weak var albumCollection: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        albumCollection.dataSource = self
        albumCollection.delegate = self
        
        let nib = UINib(nibName: "AlbumCell", bundle: nil)
        albumCollection.register(nib, forCellWithReuseIdentifier: "AlbumCell")
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return DataService.shared.favourites.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AlbumCell", for: indexPath) as! AlbumArtwork
        let alubum = DataService.shared.favourites[indexPath.row]
        
        cell.updateViews(album: alubum)
        
        return cell
    }

}


