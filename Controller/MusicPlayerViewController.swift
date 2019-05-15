import StoreKit
import MediaPlayer
import UIKit

class MusicPlayerViewController: UIViewController {
    
    let applicationMusicPlayer = MPMusicPlayerController.applicationMusicPlayer

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let myMediaPlayer = MPMusicPlayerApplicationController.applicationQueuePlayer
        // Add a playback queue containing all songs on the device
        myMediaPlayer.setQueue(with: MPMediaQuery.songs())
        // Start playing from the beginning of the queue
        myMediaPlayer.play()
        
        
        self.appleMusicCheckIfDeviceCanPlayback()
        self.appleMusicRequestPermission()
        
        appleMusicPlayTrackId(ids: ["201234458"])
     
    }

    // Check if the device is capable of playback
    func appleMusicCheckIfDeviceCanPlayback() {
        let serviceController = SKCloudServiceController()
        serviceController.requestCapabilities { (capability:SKCloudServiceCapability, err:Error?) in
            if capability.contains(SKCloudServiceCapability.musicCatalogPlayback) {
                print("The user has an Apple Music subscription and can playback music!")
                
            } else if  capability.contains(SKCloudServiceCapability.addToCloudMusicLibrary) {
                print("The user has an Apple Music subscription, can playback music AND can add to the Cloud Music Library")
                
            } else {
                print("The user doesn't have an Apple Music subscription available. Now would be a good time to prompt them to buy one?")
                
            }
        }
    }
// Request permission from the user to access the Apple Music library
    
    func appleMusicRequestPermission() {
        
        
        
        SKCloudServiceController.requestAuthorization { (status:SKCloudServiceAuthorizationStatus) in
            
            switch status {
                
            case .authorized:
                
                print("All good - the user tapped 'OK', so you're clear to move forward and start playing.")
                
            case .denied:
                
                print("The user tapped 'Don't allow'. Read on about that below...")
                
            case .notDetermined:
                
                print("The user hasn't decided or it's not clear whether they've confirmed or denied.")
                
            case .restricted:
                
                print("User may be restricted; for example, if the device is in Education mode, it limits external Apple Music usage. This is similar behaviour to Denied.")
                
          
            
            }
            
        }
}
    
    func appleMusicPlayTrackId(ids:[String]) {
        
        applicationMusicPlayer.setQueue(with: ids)
        applicationMusicPlayer.play()
        
    }
    
    
    // Fetch the user's storefront ID
    func appleMusicFetchStorefrontRegion() {
        
        let serviceController = SKCloudServiceController()
        serviceController.requestStorefrontIdentifier { (storefrontId: String?, error: Error?) in
            
            guard error == nil else {
                
                print("An error occured. Handle it here.")
                return
                
            }
            
            guard let storefrontId = storefrontId else {
                
                print("Handle the error - the callback didn't contain a storefront ID.")
                return
                
            }
            
//         let indexRange = Range(storefrontId.startIndex...storefrontId.index(storefrontId.startIndex, offsetBy: 5))
//         let trimmedId = storefrontId.substringWithRange(indexRange)
            
//            print("Success! The Storefront ID fetched was: \(trimmedId)")
            
        }
        
    }
    
//    let selectedAnnotation = Drop.self
//    var annotation = ViewController.addAnnotations.self
    
//    func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        if let destination = segue.destination as? MusicPlayerViewController {
//            destination.annotation = selectedAnnotation
//        }
//    }
    
}



