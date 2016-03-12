//
//  ImageView.swift
//  Memoria
//
//  Created by Matan Cohen on 3/8/16.
//  Copyright © 2016 MACMatan. All rights reserved.
//

import Foundation
import UIKit

class ImageView : UIImageView {
    override init(image: UIImage?) {
        super.init(image : image)
        self.contentMode = UIViewContentMode.ScaleAspectFill
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
