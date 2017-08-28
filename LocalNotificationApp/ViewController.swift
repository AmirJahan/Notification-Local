import UIKit
import UserNotifications

class ViewController: UIViewController, UNUserNotificationCenterDelegate {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        // grant access by user to receve notifications
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) {(accepted, error) in
            if !accepted {
                print("Notification access denied.")
            }
        }
        
        
        
        
        
        // Simple Notification
//        configureSimpleNotification()
//        showSimpleNotification()
        
        
        // Calendar Notification
                let destDate = Date().addingTimeInterval(10)
                showDatedNotification(at: destDate)
    }
    
    
    private func configureSimpleNotification() {
        UNUserNotificationCenter.current().delegate = self
        
        let action_1 = UNNotificationAction(identifier: "actId_1", title: "Read Later", options: [])
        let action_2 = UNNotificationAction(identifier: "actId_2", title: "Show Details", options: [.foreground])
        
        let myCategory = UNNotificationCategory(identifier: "catId",
                                                actions: [action_1, action_2],
                                                intentIdentifiers: [],
                                                options: [])
        
        UNUserNotificationCenter.current().setNotificationCategories([myCategory])
    }
    
    
    func showSimpleNotification() {
        
        let simpleTrigger = UNTimeIntervalNotificationTrigger(timeInterval: 8, repeats: false)
        let simpleContent = UNMutableNotificationContent()
        simpleContent.title = "Simple Notification"
        simpleContent.body = "This should happen in 8\"!"
        simpleContent.sound = UNNotificationSound.default()
        simpleContent.categoryIdentifier = "catId"
        
        let path = Bundle.main.path(forResource: "cinard",
                                    ofType: "png")
        
        let url = URL(fileURLWithPath: path!)
        
        do {
            let attachment = try UNNotificationAttachment(identifier: "simpleIdentifier",
                                                          url: url,
                                                          options: nil)
            simpleContent.attachments = [attachment]
        } catch {
            print("Error with attachement")
        }
        
        requestFunc(inpIdentifier: "simpleId", inpContent: simpleContent, inpTrigger: simpleTrigger)
    }
    
    
    
    func requestFunc(inpIdentifier: String, inpContent:UNMutableNotificationContent, inpTrigger: UNNotificationTrigger)  {
        
        // Creating notification request
        let request = UNNotificationRequest(identifier:inpIdentifier,
                                            content: inpContent,
                                            trigger: inpTrigger)
        
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        UNUserNotificationCenter.current().add(request) {(error) in
            if let error = error {
                print("error with request: \(error)")
            }
        }
    }
    
    func showDatedNotification(at date: Date) {
        
        let calendar = Calendar(identifier: .gregorian)
        let components = calendar.dateComponents(in: .current, from: date)
        let newComponents = DateComponents(calendar: calendar,
                                           timeZone: .current,
                                           month: components.month,
                                           day: components.day,
                                           hour: components.hour,
                                           minute: components.minute,
                                           second: components.second)
        
        
        let dateTrigger = UNCalendarNotificationTrigger(dateMatching: newComponents, repeats: false)
        
        
        let dateContent = UNMutableNotificationContent()
        dateContent.title = "Date Notification"
        dateContent.body = "This happens at a certain time"
        dateContent.sound = UNNotificationSound.default()
        
        requestFunc(inpIdentifier: "dateId", inpContent: dateContent, inpTrigger: dateTrigger)
    }
    
    // delegate methods
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        switch response.actionIdentifier {
        case "actId_1":
            print("Action one")
            //
        case "actId_2":
            print("Action two")
            self.performSegue(withIdentifier: "goSegue", sender: nil)
        default:
            print("Other Action")
        }
        completionHandler()
    }
}
