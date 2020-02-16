//
//  FillViewProvider.swift
//  CollectionKit2
//
//  Created by Luke Zhao on 2019-01-24.
//  Copyright © 2019 Luke Zhao. All rights reserved.
//

import UIKit

public class FillViewProvider<View: UIView>: SimpleViewProvider<View> {
	public init(
		id: String = UUID().uuidString,
		animator: Animator? = nil,
		width: CGFloat? = nil,
		height: CGFloat? = nil,
		view: View
	) {
		super.init(id: id, animator: animator,
							 width: width == nil ? .fill : .absolute(width!),
							 height: height == nil ? .fill : .absolute(height!),
							 view: view)
	}
}
