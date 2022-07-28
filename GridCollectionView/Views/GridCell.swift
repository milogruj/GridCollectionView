//
//  CustomCell.swift
//  GridCollectionView
//
//  Created by Milos Grujic on 7.7.22..
//

import UIKit

protocol GridCellDelegate: Any {
    func textViewDidChangeText(newText: String, requiresResize: Bool)
    func textViewDidPinch(cellHeight: CGFloat)
}

class GridCell: UICollectionViewCell {

    let inputTextView = UITextView()

    private var textViewHeight: CGFloat = .zero
    
    var cellHeight: CGFloat = .zero {
        didSet {
            textViewHeight = cellHeight
        }
    }
 
    var delegate: GridCellDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .orange

        addInputTextView()
        layoutInputTextView()
        addPinchGesture()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addInputTextView() {
        inputTextView.delegate = self
        inputTextView.isScrollEnabled = false
        inputTextView.backgroundColor = .clear
        inputTextView.returnKeyType = .done
        contentView.addSubview(inputTextView)
    }
    
    func layoutInputTextView() {
        inputTextView.translatesAutoresizingMaskIntoConstraints = false
        inputTextView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        inputTextView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        inputTextView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        inputTextView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }
    
    func addPinchGesture() {
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(self.handlePinch(sender:)))
        inputTextView.addGestureRecognizer(pinchGesture)
    }
    
    @objc func handlePinch(sender: UIPinchGestureRecognizer) {
        
        if sender.state == .began || sender.state == .changed {
            let currentScale = self.inputTextView.frame.size.width / self.inputTextView.bounds.size.width
            let newScale = currentScale*sender.scale
            let transform = CGAffineTransform(scaleX: newScale, y: newScale)
            self.inputTextView.transform = transform
            sender.scale = 1

            let fittingSize = inputTextView.sizeThatFits(CGSize(width: inputTextView.frame.width, height: CGFloat.greatestFiniteMagnitude))
            cellHeight = fittingSize.height

            delegate?.textViewDidPinch(cellHeight: cellHeight)
        }
    }
}

extension GridCell: UITextViewDelegate {

    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        
        let fittingSize = textView.sizeThatFits(CGSize(width: inputTextView.frame.width, height: CGFloat.greatestFiniteMagnitude))
        textViewHeight = fittingSize.height
        
        return true
    }

    func textViewDidChange(_ textView: UITextView) {
        
        var shouldResize = false

        let fittingSize = textView.sizeThatFits(CGSize(width: inputTextView.frame.width, height: CGFloat.greatestFiniteMagnitude))
        
        //if the current height is not equal to
        if textViewHeight != fittingSize.height {
            shouldResize = true
            //save the new height
            textViewHeight = fittingSize.height
        }
        
        delegate?.textViewDidChangeText(newText: textView.text, requiresResize: shouldResize)
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n") {
            textView.resignFirstResponder()
        }
        return true
    }
}

    
