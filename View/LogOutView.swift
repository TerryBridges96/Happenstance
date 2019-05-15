import UIKit
import FirebaseAuth

class ViewController2: UIViewController {
    
  
   
   

    @IBAction func logOut(_ sender: Any) {
        try! Auth.auth().signOut()
        performSegue(withIdentifier: "segue2", sender: self)
    
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print ("Auth.auth().currentUser?.email")
        
    }
}

