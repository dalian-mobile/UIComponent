//  Created by Luke Zhao on 8/23/20.

import UIKit

public struct VisibleFrameInsets: Component {
  let insets: UIEdgeInsets
  let child: Component
  
  public init(insets: UIEdgeInsets, child: Component) {
    self.insets = insets
    self.child = child
  }
  
  public func layout(_ constraint: Constraint) -> RenderNode {
    VisibleFrameInsetRenderNode(insets: insets, child: child.layout(constraint))
  }
}

public struct DynamicVisibleFrameInset: Component {
  let insetProvider: (CGRect) -> UIEdgeInsets
  let child: Component
  
  public init(insetProvider: @escaping (CGRect) -> UIEdgeInsets, child: Component) {
    self.insetProvider = insetProvider
    self.child = child
  }

  public func layout(_ constraint: Constraint) -> RenderNode {
    DynamicVisibleFrameInsetRenderNode(insetProvider: insetProvider, child: child.layout(constraint))
  }
}

struct VisibleFrameInsetRenderNode: RenderNode {
  let insets: UIEdgeInsets
  let child: RenderNode
  var size: CGSize {
    child.size
  }
  var children: [RenderNode] {
    [child]
  }
  var positions: [CGPoint] {
    [.zero]
  }
  func views(in frame: CGRect) -> [Renderable] {
    child.views(in: frame.inset(by: insets))
  }
}

struct DynamicVisibleFrameInsetRenderNode: RenderNode {
  let insetProvider: (CGRect) -> UIEdgeInsets
  let child: RenderNode
  var size: CGSize {
    child.size
  }
  var children: [RenderNode] {
    [child]
  }
  var positions: [CGPoint] {
    [.zero]
  }
  func views(in frame: CGRect) -> [Renderable] {
    child.views(in: frame.inset(by: insetProvider(frame)))
  }
}

public extension Component {
  func visibleInset(_ amount: CGFloat) -> Component {
    VisibleFrameInsets(insets: UIEdgeInsets(top: amount, left: amount, bottom: amount, right: amount), child: self)
  }
  func visibleInset(h: CGFloat = 0, v: CGFloat = 0) -> Component {
    VisibleFrameInsets(insets: UIEdgeInsets(top: v, left: h, bottom: v, right: h), child: self)
  }
  func visibleInset(_ insets: UIEdgeInsets) -> Component {
    VisibleFrameInsets(insets: insets, child: self)
  }
  func visibleInset(_ insetProvider: @escaping (CGRect) -> UIEdgeInsets) -> Component {
    DynamicVisibleFrameInset(insetProvider: insetProvider, child: self)
  }
}
