//
//  SecondViewController.swift
//  Tinkoff Chat
//
//  Created by Владислав Макуха on 22.09.2021.
//

import UIKit

class SecondViewController: UIViewController {
    
    let logFor = Log()
    
    var someProperties: String?

    @IBAction func CloseSecondVC(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    // Срабатывает после загрузки View
    override func viewDidLoad() {
        super.viewDidLoad()
        logFor.DLog(message: "View moved from init to viewDidLoad")
        // Do any additional setup after loading the view.
    }
    
    // Срабатывает перед появлением View на экране
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        logFor.DLog(message: "View moved from viewDidLoad to viewWillAppear")
    }
    
    // Срабатывает перед тем, как размер View поменяется под размер экрана
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        logFor.DLog(message: "View moved from viewWillAppear to viewWillLayoutSubviews")
    }
    
    // Тут срабатывает AutoLayout
    
    // Срабатывает после того, как размер View изменился под размер экрана
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        logFor.DLog(message: "View moved from viewWillLayoutSubviews to viewDidLayoutSubviews")
    }
    
    // Срабатывает, когда View появляется на экране
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        logFor.DLog(message: "View moved from viewDidLayoutSubviews to viewDidAppear")
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        logFor.DLog(message: "View moved from viewDidAppear to viewWillDisappear")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        logFor.DLog(message: "View moved from viewWillAppear to deinit")

    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
