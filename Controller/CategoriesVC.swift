import UIKit
import UserNotifications

class CategoriesVC: UIViewController, UITableViewDataSource, UITableViewDelegate {

@IBOutlet weak var categoryTable: UITableView!

override func viewDidLoad() {
    super.viewDidLoad()
    categoryTable.dataSource = self
    categoryTable.delegate = self
    displayWalkthroughs()
    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge], completionHandler: {didAllow, error in
    })
     addNavBarImage()
    }
    
    func addNavBarImage() {
        let navController = navigationController
        
        let image = #imageLiteral(resourceName: "bannerheadr")
        let imageView = UIImageView(image:image)
        
        let bannerWidth = navController?.navigationBar.frame.size.width
        let bannerheight = navController?.navigationBar.frame.size.height
        
        let bannerX = bannerWidth! / 2 - image.size.width / 2
        let bannerY = bannerWidth! / 2 - image.size.height / 2
        
        imageView.frame = CGRect(x: bannerX, y: bannerY, width: bannerWidth!, height: bannerheight!)
        imageView.contentMode = .scaleAspectFit
        
        navigationItem.titleView = imageView
        
    }
    
    
    func displayWalkthroughs() {
        let userDefaults = UserDefaults.standard
        let displayedWalkthrough = userDefaults.bool(forKey: "DisplayedWalkthrough")
        
        if !displayedWalkthrough {
            if let pageViewController = storyboard?.instantiateViewController(withIdentifier: "PageViewController")
            {
                self.present (pageViewController, animated: true, completion: nil)
                
            }
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DataService.shared.getCategories().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell") as? CategoryCell {
                let category = DataService.shared.getCategories()[indexPath.row]
            cell.updateViews(category: category)
            return cell
        } else {
            return CategoryCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let category = DataService.shared.getCategories()[indexPath.row]
        performSegue(withIdentifier: category.title, sender: category)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is FavouritesVC {
            
        }
    }
    
}
