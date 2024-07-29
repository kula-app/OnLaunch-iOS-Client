import OnLaunch
import UIKit

class ViewController: UIViewController {
    @IBAction func checkForMessagesActions(_: Any) {
        OnLaunch.check()
    }
}
