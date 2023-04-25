import UIKit
import OnLaunch

class ViewController: UIViewController {

    @IBAction func checkForMessagesActions(_ sender: Any) {
        OnLaunch.check()
    }
}

