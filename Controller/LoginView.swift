import UIKit
import FirebaseAuth
import FBSDKLoginKit
import Firebase

class LoginView: UIViewController, FBSDKLoginButtonDelegate {

    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var loginButton: UIButton!


    override func viewDidLoad() {
        super.viewDidLoad()
        emailText.delegate = self as UITextFieldDelegate
        passwordText.delegate = self as UITextFieldDelegate
        
        let loginButton = FBSDKLoginButton()
        
        view.addSubview(loginButton)
        loginButton.frame = CGRect(x: 43, y: 462, width: view.frame.width - 88, height: 50)
        
        loginButton.delegate = self
        loginButton.readPermissions = ["email", "public_profile"]
        showEmailAddress()
        
    }
   
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("Did LogOut")
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
         self.dismiss(animated: true, completion: nil)
        if ((error) != nil)
        {
            // Process error
        }
        else if result.isCancelled {
            // Handle cancellations
        }
        else {
            // If you ask for multiple permissions at once, you
            // should check if specific permissions missing
            if result.grantedPermissions.contains("email")
            {
                // Do work
            }
        }
    }
    

    
    
    func showEmailAddress() {
        let accessToken = FBSDKAccessToken.current()
        
        guard (accessToken?.tokenString) != nil else { return }
        
        let credentials = FacebookAuthProvider.credential(withAccessToken: (accessToken?.tokenString)!)
        Auth.auth().signIn(with: credentials, completion: { (user, error) in
            if error != nil {
                print("Something went wrong", error ?? "")
                return
            }
            print("Sucess", user ?? "")
        })
        
        FBSDKGraphRequest(graphPath: "/me", parameters: ["fields": "id, name, email"]).start{ (connection, result, err) in
            
            if err != nil {
                print("Failed", err ?? "")
            }
            print(result ?? "")
            
        }
        
    
    
    }


    @IBAction func login(_ sender: Any) {
        if emailText.text != nil && passwordText.text != nil {
            AuthService.shared.loginUser(withEmail: emailText.text!, andPassword: passwordText.text!, loginComplete: {(success, loginError) in
                if success {
                    self.dismiss(animated: true, completion: nil)
                } else {
                    print(String(describing: loginError?.localizedDescription))
                }
                
                AuthService.shared.registerUser(withEmail: self.emailText.text!, andPassword: self.passwordText.text!, userCreationComplete: { (success, registrationError) in
                    if success {
                        AuthService.shared.loginUser(withEmail: self.emailText.text!, andPassword: self.passwordText.text!, loginComplete: { (success, nil) in
                            self.dismiss(animated: true, completion: nil)
                          print("Successfully Registered User")
                        })
                    } else {
                        print(String(describing: registrationError?.localizedDescription))
                    }
                })
                
            })
        }

            }

    

}


extension LoginView: UITextFieldDelegate {
    
}













