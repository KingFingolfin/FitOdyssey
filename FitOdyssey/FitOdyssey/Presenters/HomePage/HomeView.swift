//
//  LoginView.swift
//  FitOdyssey
//
//  Created by Giorgi on 13.01.25.
//

import FirebaseAuth
import SwiftUI

struct HomeView: View {
    
    
    var body: some View {
        HStack{
            Text("HOME")
        }.background(.red)
        
    }
}


class SettingsViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.title = "Settings"
    }
}
