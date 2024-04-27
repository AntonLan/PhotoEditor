//
//  RegistrationView.swift
//  PhotoEditor
//
//  Created by Anton Gerasimov on 27.04.2024.
//

import SwiftUI

struct RegistrationView: View {
    @State var viewModel = RegistrationViewModel()
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            Spacer()
            
            VStack {
                TextField("Enter your email", text: $viewModel.email)
                    .autocapitalization(.none)
                    .modifier(TextFieldModifier())
                
                
                SecureField("Enter your password", text: $viewModel.password)                      .modifier(TextFieldModifier())
                
                TextField("Enter your full name", text: $viewModel.fullName)
                    .modifier(TextFieldModifier())
                
                TextField("Enter your user name", text: $viewModel.userName)
                    .autocapitalization(.none)
                    .modifier(TextFieldModifier())
            }
            
            Button {
                Task { try await viewModel.createUser() }
            } label: {
                Text("Sing Up")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .frame(width: 352, height: 44)
                    .background(.black)
                    .cornerRadius(8)
            }
            .padding(.vertical)
            
            Spacer()
            
            Divider()
            
            Button {
                dismiss()
            } label: {
                HStack(spacing: 3) {
                    Text("Already have an account?")
                    
                    Text("Sing In")
                        .fontWeight(.semibold)
                }
                .foregroundColor(.black)
                .font(.footnote)
            }
            .padding(.vertical, 16)
        }
    }
}

#Preview {
    RegistrationView()
}

