//
//  HomeScreen.swift
//  StoreUpload
//
//  Created by Jeremy Ephron on 3/30/19.
//  Copyright © 2019 Kylee Krzanich. All rights reserved.
//

import UIKit

class HomeScreen: AltBGView {
    
    var authToken: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is AddProductScreen {
            let vc = segue.destination as? AddProductScreen
            vc?.authToken = self.authToken
        } else if segue.destination is ViewController {
            let vc = segue.destination as? ViewController
            vc?.authToken = ""
        }
    }
}
