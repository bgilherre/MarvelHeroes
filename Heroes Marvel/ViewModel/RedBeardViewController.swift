//
//  RedBeardViewController.swift
//  Heroes Marvel
//
//  Created by Borja Gil Herrero on 17/12/2018.
//  Copyright © 2018 Alsis GHE. All rights reserved.
//

import UIKit
import Redbeard

class RedBeardViewController: UIViewController ,RBManagedFormViewDelegate{

    @IBOutlet var formView: RBManagedFormView!
    let usernameField :RBManagedFormTextFieldSchema = RBManagedFormTextFieldSchema()
    let passwordField:RBManagedFormTextFieldSchema = RBManagedFormTextFieldSchema()
    let genderField:RBManagedFormListFieldSchema = RBManagedFormListFieldSchema()
    let profilePicField:RBManagedFormPhotoFieldSchema  = RBManagedFormPhotoFieldSchema()
    let submitButton:RBManagedFormSubmitButtonSchema  = RBManagedFormSubmitButtonSchema()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //usernameField.fieldName = "username";
        usernameField.placeholder = "Usuario"
        usernameField.label = "Usuario"

        passwordField.placeholder = "Password"
        passwordField.secureTextEntry = true
        passwordField.label = "Password"
        
        let validacion: RBManagedFormValidationRuleSchema = RBManagedFormValidationRuleSchema.rule(withStringLengthMinimumLength: 6, failureMessage: "El password debe tener al menos 6 caracteres")

        passwordField.validationRules = [validacion]

        genderField.stringItems = [ "Hombre", "Mujer" ]
        genderField.label = "Genero"
        
        profilePicField.label = "Foto de perfil"
        
        submitButton.title = "ENVIAR"
        
        
        
        let schema:RBManagedFormSchema = RBManagedFormSchema.init(items: [usernameField, passwordField, genderField, profilePicField, submitButton])
        
        //submitButton.click
        
        self.formView.setFormSchema(schema)
        
        formView.delegate = self
        formView.validationViewType = RBManagedFormValidationViewType.tooltip
        formView.toolbarEnabled = true
        //formView.validateForm()
    }
    
    func managedFormViewWasSubmitted(_ formView: RBManagedFormView) {

        formView.validateForm()
            
        //formView.
        
        print("patata")
    }
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
