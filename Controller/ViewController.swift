import UIKit
import Firebase
import MapKit
import CoreLocation
import GeoFire
import MediaPlayer
import StoreKit
import UserNotifications

class ViewController: UIViewController, CLLocationManagerDelegate {

    let ref = Database.database().reference().child("drops")
    var drops = [Drop]()
    
    let systemMusicPlayer = MPMusicPlayerController.systemMusicPlayer
    
    @IBOutlet weak var mapView: MKMapView!
   
    let locationManager = CLLocationManager()
    var userLocation: CLLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
       
        
        locationManager.requestAlwaysAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
       // mapView.userTrackingMode = .follow
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
        
        
        
        let myMediaPlayer = MPMusicPlayerApplicationController.applicationQueuePlayer
        // Add a playback queue containing all songs on the device
        myMediaPlayer.setQueue(with: MPMediaQuery.songs())
        // Start playing from the beginning of the queue
        myMediaPlayer.play()
        
        
        self.appleMusicCheckIfDeviceCanPlayback()
        self.appleMusicRequestPermission()
        
        
 

        
}
    
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
    
    
    func loadData(for location: CLLocation) {
        
        let rootRef = Database.database().reference()

        let geoRef = GeoFire(firebaseRef: rootRef.child("dropLocations"))
        let query = geoRef.query(at: location, withRadius: 20)

        query.observe(.keyEntered, with: { key, location in
            
            rootRef.child("drops/\(key)").observeSingleEvent(of: .value, with: { snapshot in
                let newDrop = Drop(snapshot: snapshot)
                
                if !self.drops.contains(newDrop) {
                    self.drops.append(newDrop)
                    self.addAnnotations(for: newDrop)
                    
                }
            })
        })
    }
    
    func testDistance(for location: CLLocation) {
        
        let annotations = mapView.annotations
        
        for annotation in annotations {
            let annotationCoordinate = CLLocation(latitude: annotation.coordinate.latitude, longitude: annotation.coordinate.longitude)
            if annotationCoordinate.distance(from: location) > 1 * 1000 {
                mapView.removeAnnotation(annotation)
                self.drops.removeAll()
            }
        }
        
    }
    
    
    
    func addAnnotations(for drop: Drop) {
        let annotation = DropAnnotation(drop)
        self.mapView.addAnnotation(annotation)
    }
    
    
    func removeAnnotations() {
        let addAnnotations = self.mapView.annotations
        self.mapView.removeAnnotations(addAnnotations)
    }
    
    
    func locationManager( _ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let location = locations.last else { return }
        loadData(for: location)
        testDistance(for: location)
        print(mapView.annotations.count)
    }



    @IBAction func dropBtn(_ sender: Any) {
        guard let userLocation = mapView.userLocation.location else { return }
        
        
        guard let mediaitem = systemMusicPlayer.nowPlayingItem else {
            print("No song currently playing")
            return
        }
        
        guard let title = mediaitem.title else { return }
        guard let artist = mediaitem.artist else { return }
        guard let genre = mediaitem.genre else { return }
        guard let artwork = mediaitem.artwork else { return }
        
        
        let ref = Database.database().reference(withPath: "drops")
        
        let data: [String: Any] = [
            "lat": userLocation.coordinate.latitude,
            "lng": userLocation.coordinate.longitude,
            "song": title,
            "songId": mediaitem.playbackStoreID,
            "artist": artist,
            "genre": genre,
            "artwork": artwork
            
        ]
        
        ref.childByAutoId().setValue(data) { error, ref in
            let rootRef = Database.database().reference()
            let geoRef = GeoFire(firebaseRef: rootRef.child("dropLocations"))
            geoRef.setLocation(userLocation, forKey: ref.key)
            
        }
        
        let content = UNMutableNotificationContent()
        content.title = "You have recently dropped a song!"
        content.body = "Check back to see if anyone else has dropped a song near you!"
        content.badge = 1

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        let request = UNNotificationRequest(identifier: "timerDone", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        
    }
    
    func createDBUser(uid: String, userData: Dictionary<String,Any>) {
        Database.database().reference().child("users").child(uid).updateChildValues(userData)
    }
    
    
    @IBAction func stopMusic(_ sender: Any) {
        applicationMusicPlayer.stop()
    }
    

    @IBAction func favouriteSongBtn(_ sender: Any) {
        // If no song is playing dont procede
        guard let mediaItem = systemMusicPlayer.nowPlayingItem else {
            print("No song currently playing")
            return
        }
        // If song is playing pull down the songs artwork and send it to Data Service Array
        guard let artwork = mediaItem.artwork else { return }
        print(artwork)
        
    }
    
    
    let applicationMusicPlayer = MPMusicPlayerController.applicationMusicPlayer

}
extension ViewController: MKMapViewDelegate  {
    
    
    func appleMusicPlayTrackId(ids:[String]) {
        
        applicationMusicPlayer.setQueue(with: ids)
        applicationMusicPlayer.play()
        
    }
    
    

    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        print("selected annotation")
        guard let dropAnnotation = view.annotation as? DropAnnotation else { return }
      
        appleMusicPlayTrackId(ids: [dropAnnotation.drop.songId])
          print("songPlaying")
        
    
        }
    }
    

