//
//  CurrentTrackModelView.swift
//  AudioPlayer
//
//  Created by Слава Орлов on 18.11.2023.
//
import UIKit

extension UIButton {
    
    static func createButton(title: String? , image: UIImage?, titleColor: UIColor, _ highlighted: UIColor?) -> UIButton {
        
        lazy var button = UIButton()
        
        button.setTitle(title, for: .normal)
                
        button.setImage(image, for: .normal)
        
        button.setTitleColor(titleColor, for: .normal)
        
        button.setTitleColor(highlighted, for: .highlighted)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }
    
}
