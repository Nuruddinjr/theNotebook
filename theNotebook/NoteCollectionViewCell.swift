//
//  NoteCollectionViewCell.swift
//  theNotebook
//
//  Created by Nuruddin on 4/25/17.
//  Copyright © 2017 IUTlab. All rights reserved.
//

import UIKit

class NoteCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var featuredImageView: UIImageView!
    @IBOutlet weak var noteTitleLabel: UILabel!
    @IBOutlet weak var backgroundColorView: UIView!
    
   
    
    var note: Note?{
        didSet{
            self.updateUI()
        }
        
    }
    
    
    private func updateUI(){
        if let note = note {
            featuredImageView.image = note.featuredImage
            noteTitleLabel.text = note.title
            backgroundColorView.backgroundColor = note.color

        }
        else {
            featuredImageView.image = nil
            noteTitleLabel.text = nil
            backgroundColorView.backgroundColor = nil
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.layer.cornerRadius = 3.0
        layer.shadowRadius = 10
        layer.shadowOpacity = 0.4
        layer.shadowOffset = CGSize(width: 5, height: 10)
        self.clipsToBounds = false
        
    }
}
