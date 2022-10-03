//
//  M2PSearchBar.swift
//  iOSComponents
//
//  Created by Shiny on 28/09/22.
//

import Speech


public class M2PSearchBar: UIView {
    
    let contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 12
        stackView.backgroundColor = .clear
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    let textFieldView = M2PInputField()
    
    let cancelButtonView = UIView()
    
    let cancelButton: UIButton = {
        let button = UIButton()
        button.setTitle("Cancel", for: .normal)
        button.setTitleColor( UIColor.linksText , for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()

    // MARK: Voice recognition - related
    let audioEngine = AVAudioEngine()
    let speechRecognizer: SFSpeechRecognizer? = SFSpeechRecognizer()
    let audioRecognitionRequest = SFSpeechAudioBufferRecognitionRequest()
    var recognitionTask: SFSpeechRecognitionTask?
    var timer: Timer?
    var inputNode: AVAudioInputNode?
    // MARK: Audio player - related
    var audioPlayer: AVAudioPlayer?
    
    // MARK: Textfield data - related
    var oldTextBeforeMicOn = ""
    
    // MARK: Public call backs
    public var M2PonClickCancel: (() -> ())?
    public var M2PonClickMic: (() -> ())?
    public var M2PonSearchTextChange: ((String) -> ())?
    
    // MARK: Initializers
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupView()
    }
    
    // MARK: Setups
    
    private func setupView() {
        setupTextFieldView()
        
        // Content Stack View
        self.addSubview(contentStackView)
        setContentStackViewConstraints()
        // Content stack view - subview addition
        contentStackView.addArrangedSubview(textFieldView)
        
        cancelButton.addTarget(self, action: #selector(self.onClickCancel), for: .touchUpInside)
    }

    private func setupTextFieldView() {
        let config = M2PInputFieldConfig(placeholder: "Search", fieldStyle: .Form_Default)
        
        textFieldView.M2Psetup(type: .Default_TextField, config: config)
        textFieldView.M2PsetLeftImage(image: getImage(name: "search_Image.png") , size: CGSize(width: 20, height: 20))
        textFieldView.M2PsetRightImage(image: getImage(name: "mic.png"))
        
        textFieldView.leftImageView.tintColor = UIColor.DavysGrey66
        textFieldView.rightImageView.tintColor = UIColor.DavysGrey66
        textFieldView.translatesAutoresizingMaskIntoConstraints = false
        textFieldView.contentView.backgroundColor = .backgroundLightVarient
        textFieldView.contentView.layer.borderWidth = 0
        
        setupForTextFieldViewActions()
    }
    
    private func setupForTextFieldViewActions() {

        setupLongGestureRecognizerOnMic()
        
        textFieldView.M2PdidTextFieldValueUpdated = { text in
            if text == "" {
                self.M2PonSearchTextChange?(text)
                print("##Change called: \(text)")
            }
        }
        
        textFieldView.textField.addTarget(self, action: #selector(self.onTextFieldEditingBegin), for: .editingDidBegin)
        textFieldView.textField.addTarget(self, action: #selector(self.onTextFieldEditingEnd) , for: .editingDidEnd)
        textFieldView.textField.addTarget(self, action: #selector(onTextFieldEditingChange), for: .editingChanged)
    }
    
    // MARK: Actions
    
    @objc private func onTextFieldEditingBegin() {
        textFieldView.contentView.layer.borderWidth = 1
        textFieldView.M2PsetRightImage(image: nil)
        addCancel()
    }
    
    @objc private func onTextFieldEditingEnd() {
        textFieldView.contentView.layer.borderWidth = 0
    }
    
    @objc private func onTextFieldEditingChange() {
        let text = textFieldView.textField.text ?? ""
        M2PonSearchTextChange?(text)
        print("##Editing Change called : \(text)")
    }
    
    private func addCancel() {
        cancelButtonView.widthAnchor.constraint(equalToConstant: 60).isActive = true
        contentStackView.addArrangedSubview(cancelButtonView)
        
        cancelButtonView.addSubview(cancelButton)
        setCancelButtonConstarints()
    }
    
    private func removeCancel() {
        if contentStackView.arrangedSubviews.count > 1 {
            UIView.animate(withDuration: 0.15) {
                self.contentStackView.arrangedSubviews[1].removeFromSuperview()
            }
        }
    }
    
    @objc private func onClickCancel() {
        removeCancel()
        textFieldView.M2PsetRightImage(image: getImage(name: "mic.png"))
        textFieldView.contentView.layer.borderWidth = 0
        textFieldView.textField.endEditing(true)
        
        M2PonClickCancel?()
    }
    
    private func setupLongGestureRecognizerOnMic() {
          let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPressOnMic))
        longPressGesture.delaysTouchesBegan = true
        // longPressGesture.delegate = self
        self.textFieldView.rightView.addGestureRecognizer(longPressGesture)
    }
    
    @objc private func handleLongPressOnMic(gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began {
            print("## Began")
            onClickMic()
        }else if gesture.state == .ended {
            print("## Ended")
            onMicOff()
        }
    }
    
    
    private func onClickMic() {
        textFieldView.contentView.layer.borderWidth = 1
        textFieldView.M2PSetInputFieldState(isActive: true)
        textFieldView.rightImageView.tintColor = UIColor.linksText
        textFieldView.textField.placeholder = "Listening..."
        oldTextBeforeMicOn = textFieldView.textField.text ?? ""
        textFieldView.textField.text = ""
        
        playStartRecordSound()
        recordAndRecognizeSpeech()
        M2PonClickMic?()
    }
    
    private func onMicOff() {
        textFieldView.contentView.layer.borderWidth = 0
        textFieldView.M2PSetInputFieldState(isActive: false)
        textFieldView.rightImageView.tintColor = UIColor.DavysGrey66
        textFieldView.textField.placeholder = "Search"
        
        playRecordingStoppedSound()
        stopRecording()
        
        if textFieldView.textField.text == "" && !oldTextBeforeMicOn.isEmpty {
            textFieldView.textField.text = oldTextBeforeMicOn
            oldTextBeforeMicOn = ""
        }
    }
    
    // MARK: Audio player - related
    
    private func playStartRecordSound() {
        guard let audioPath = M2PComponentsBundle.shared.currentBundle.path(forResource: "record_ON", ofType: "wav") else {
            return
        }
        let record_ON_Sound = NSURL(fileURLWithPath: audioPath) as URL
        audioPlayer = try? AVAudioPlayer(contentsOf: record_ON_Sound)
        audioPlayer?.play()
    }
    
    private func playRecordingStoppedSound() {
        guard let audioPath = M2PComponentsBundle.shared.currentBundle.path(forResource: "record_OFF", ofType: "wav") else {
            return
        }
        let record_OFF_Sound = NSURL(fileURLWithPath: audioPath) as URL
        audioPlayer = try? AVAudioPlayer(contentsOf: record_OFF_Sound)
        audioPlayer?.play()
    }
    
    // MARK: Voice recognition - related
    
    private func recordAndRecognizeSpeech() {
        
        let audioSession = AVAudioSession.sharedInstance()
        try? audioSession.setCategory(.playAndRecord, options: .defaultToSpeaker)
        try? audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        
        guard let recognizer = SFSpeechRecognizer() else {
            return
        }
        guard recognizer.isAvailable else {
            return
        }
        
        audioRecognitionRequest.shouldReportPartialResults = true
        
        recognitionTask = speechRecognizer?.recognitionTask(with: audioRecognitionRequest, resultHandler: { result_, error in
            if let result = result_ {
                let baseString = result.bestTranscription.formattedString
                if self.audioEngine.isRunning{
                    self.textFieldView.textField.text = baseString
                    self.M2PonSearchTextChange?(baseString)
                }
                print("##Change called Result: \(baseString)")
            }
            // if error != nil || result_?.isFinal == true {
                // self.stopRecording()
            // }
        })
        
        inputNode = audioEngine.inputNode
        
        let recordingFormat = inputNode?.outputFormat(forBus: 0)
        inputNode?.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer: AVAudioPCMBuffer, when: AVAudioTime) in
            self.audioRecognitionRequest.append(buffer)
        }
        
        print("Begin recording")
        audioEngine.prepare()
        
        do {
            try audioEngine.start()
        }
        catch {
            return
        }
        
        
    }
    
    func stopRecording() {
        if audioEngine.isRunning {
            audioEngine.stop()
            inputNode?.removeTap(onBus: 0)
            audioRecognitionRequest.endAudio()
            // Cancel the previous task if it's running
            if let recognitionTask = recognitionTask {
                recognitionTask.cancel()
                self.recognitionTask = nil
            }
            print("Listening stopped")
        }
        
    }
    
    // MARK: Helper methods
    
    private func getImage(name: String) -> UIImage? {
        let bundle = M2PComponentsBundle.shared.currentBundle
        let image = UIImage(named: name, in: bundle, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
        
        return image
    }
    
    // MARK: Constraints
    
    private func setContentStackViewConstraints() {
        contentStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        contentStackView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        contentStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        contentStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
    
    private func setCancelButtonConstarints() {
        cancelButton.centerXAnchor.constraint(equalTo: cancelButtonView.centerXAnchor).isActive = true
        cancelButton.centerYAnchor.constraint(equalTo: textFieldView.contentView.centerYAnchor).isActive = true
        cancelButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        cancelButton.widthAnchor.constraint(equalToConstant: 60).isActive = true
    }
    
}
