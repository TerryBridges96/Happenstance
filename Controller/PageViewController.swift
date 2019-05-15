import UIKit

class PageViewController : UIPageViewController {
    
    var pageheaders = [ "Drop your favourite songs.", "Find dropped songs.", "Like the song?"]
    var pageImages = ["walkthroughScreen1.png", "walkthroughScreen1.png", "walkthroughScreen1.png"]
    var pageDescriptions = ["Like a song? Drop that song on your location for other users to find and listen to!", "Discover a song someone has shared in that location!", "Favourite the song for later reference, or listen to it in our Music Player!"]
    
    
   func preferredStatusBarStyle() ->UIStatusBarStyle {
        
        return .lightContent
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dataSource = self
        
        if let startWalkthroughVC = self.viewControllerAtIndex(index: 0) {
            setViewControllers([startWalkthroughVC], direction: .forward, animated: true, completion: nil)
            
        }
        
    }
    
    func nextPageWithIndex(index: Int)
    {
        if let nextWalkthroughVC = self.viewControllerAtIndex(index: index+1) {
            setViewControllers([nextWalkthroughVC], direction: .forward, animated: true, completion: nil)
        }
    }

    func viewControllerAtIndex(index: Int) -> WalkthroughViewController?
    {
        if index == NSNotFound || index < 0  || index >= self.pageDescriptions.count  
        {
            return nil
        }
    
        
        if let WalkthroughViewController = storyboard?.instantiateViewController(withIdentifier: "WalkthroughViewController") as? WalkthroughViewController{
            WalkthroughViewController.imageName = pageImages[index]
            WalkthroughViewController.headerText = pageheaders[index]
            WalkthroughViewController.descriptionText = pageDescriptions [index]
            WalkthroughViewController.index = index
            
            return WalkthroughViewController
        }
    
            return nil
    }

}
    
    



extension PageViewController : UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController?
    {
        var index = (viewController as! WalkthroughViewController).index
        index -= 1
        return self.viewControllerAtIndex(index: index)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController?
    {
        var index = (viewController as! WalkthroughViewController).index
        index += 1
        return self.viewControllerAtIndex(index: index)
    }
    
    
    }
    
    
    


