import UIKit

class WalkthroughViewController: UIViewController
{
    
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var startButton: UIButton!
    
    var index = 0
    var headerText = ""
    var imageName = ""
    var descriptionText = ""
    
   func preferedStatusBarStyle() -> UIStatusBarStyle
    {
        return .lightContent
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        headerLabel.text = headerText
        descriptionLabel.text = descriptionText
        imageView.image = UIImage(named: imageName)
        pageControl.currentPage = index
        
    
        startButton.isHidden = (index == 2) ? false : true
        nextButton.isHidden = (index == 2) ? true : false
        startButton.layer.cornerRadius = 5.0
        startButton.layer.masksToBounds = true
    }
    
    @IBAction func startClicked(_ sender: Any) {
        
        let userDefaults = UserDefaults.standard
        userDefaults.set(true, forKey:  "DisplayedWalkthrough")
        
        let loginView = self.storyboard?.instantiateViewController(withIdentifier: "LoginView") as? LoginView
        self.present(loginView!, animated: true, completion: nil)
    }
    
    
    @IBAction func nextClicked(_ sender: Any)
    {
     let pageViewController = self.parent as! PageViewController
        pageViewController.nextPageWithIndex(index: index)
    }
}

