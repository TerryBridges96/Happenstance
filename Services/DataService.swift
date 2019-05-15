import Firebase
import Foundation
import StoreKit
import MediaPlayer

let database = Database.database().reference()

class DataService {
    
    static let shared = DataService()
    
    private init() { }
     var base = database
     var _feed = database.child("feed")
     var _users = database.child("users")
    
    var DB_Base: DatabaseReference {
        return base
    }
    
    var feed: DatabaseReference {
        return _feed
    }
    
    var users: DatabaseReference {
        return _users
    }
    
    
    func createDBUser(uid: String, userData: Dictionary<String,Any>) {
        users.child(uid).updateChildValues(userData)
    }
    
    
    
    
    
    private let categories = [
        Category(title: "FIND SONGS", imageName: "findSongs.png"),
        Category(title: "COMMUNITY", imageName: "socialFeed.png"),
        Category(title: "FAVOURITE SONGS", imageName: "favourite.png"),
        Category(title: "PROFILE", imageName: "profile.png"),
    
    ]
    
    let systemMusicPlayer = MPMusicPlayerController.systemMusicPlayer
    
    
     let favourites = [
        album(title: "Isolation", artist: "Joy Division", imageName: "download-1"),
        album(title:"Awful Things", artist: "Lil Peep", imageName: "lilpeep"),
        album(title:"Levels", artist:"Avicii", imageName: "avicii"),
        album(title:"hu", artist: "uh", imageName:"lilpeep"),
        album(title:"hu", artist: "uh", imageName: "avicii"),
        album(title:"hu", artist: "uh", imageName: "avicii"),
        album(title:"hu", artist: "uh", imageName: "lilpeep"),
        album(title:"hu", artist: "uh", imageName: "avicii")
        ]
    
    
    func getCategories() -> [Category] {
        return categories
    }
    
     private let favourite = [album]()
    
    func getAlbums(forCategoryTitle title:String) -> [album]{
        switch title {
        case "FAVOURITE SONGS":
            return getFavourites()
        default:
            return getFavourites()
        } 
    }
    
    func getFavourites() -> [album] {
        return favourites
    }
    
    func getUsername(forUI uid: String, handler: @escaping (_ username: String) ->()){
        users.observeSingleEvent(of: .value) { (userSnapshot) in
            guard let userSnapshot = userSnapshot.children.allObjects as? [DataSnapshot] else { return }
            for user in userSnapshot {
                if user.key == uid {
                    handler(user.childSnapshot(forPath: "pic").value as! String)
                }
            }
            
        }

    }
    
    
    func uploadPost(withMessage messsge: String, forUID uid: String, withGroupKey groupKey: String?, sendComplete: @escaping (_ status: Bool) -> ()){
        if groupKey != nil {
        } else {
            feed.childByAutoId().updateChildValues(["content": messsge, "senderId": uid])
            sendComplete(true)
        }
        
    }
    
    func getAllMessages(handler: @escaping(_ messages: [Message]) -> ()) {
        var messageArray = [Message]()
        feed.observeSingleEvent(of: .value) {(feedMessageSnapshot) in
            guard let feedMessageSnapshot = feedMessageSnapshot.children.allObjects as? [DataSnapshot] else {return}
            
            for message in feedMessageSnapshot {
                let content = message.childSnapshot(forPath: "content").value as! String
                let senderId = message.childSnapshot(forPath: "senderId").value as! String
                let message = Message(content: content, senderId: senderId)
                messageArray.append(message)
                
            }
            handler(messageArray)
        }
    }
    
    
    
}
