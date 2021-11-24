import UIKit

class TextFieldTableViewCell: UITableViewCell {

    @IBOutlet weak var titleTextField: UITextField!
    
    static let identifier = "titleTableViewCell"
    var delegate: TitleTableViewCellDelegate!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        titleTextField.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    static func nib() -> UINib {
        return UINib(nibName: "TextFieldTableViewCell", bundle: nil)
    }
    
    func setCell(placeholder: String, textAlignment: NSTextAlignment) {
        titleTextField.placeholder = placeholder
        titleTextField.textAlignment = textAlignment
    }
}

extension TextFieldTableViewCell: UITextFieldDelegate {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super .touchesBegan(touches, with: event)
        titleTextField.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        titleTextField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let title = titleTextField.text else { return }
        delegate.setText(for: title)
    }
    
}
