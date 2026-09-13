//
//  LoginView.swift
//  FeedList_Scrolling
//
//  Created by Akhil Gupta on 9/12/26.
//

import SwiftUI

enum FocusLoginPage: Hashable {
    case userName
    case password
}

struct LoginView: View {
    @Environment(AppDependencies.self) var appDependencies
    @State private var viewModel: LoginViewModel
    
    @State var userName: String = ""
    @State var password: String = ""
    @State private var displayAlert = false
    @State private var isLoggedIn = false
    @FocusState var focusLoginPage: FocusLoginPage?
   
    
    init(loginService: LoginServiceProtocol) {
        _viewModel = State(initialValue: LoginViewModel(loginService: loginService))
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                TextField("UserName", text: $userName)
                    .autocorrectionDisabled()
                    .padding()
                    .background(Color(.systemGray6))
                    .clipShape(.rect(cornerRadius: 10))
                    .focused($focusLoginPage, equals: .userName)
                
                SecureField("Password", text: $password)
                    .autocorrectionDisabled()
                    .padding()
                    .background(Color(.systemGray6))
                    .clipShape(.rect(cornerRadius: 10))
                    .focused($focusLoginPage, equals: .password)
                
                Button {
                    signIn()
                    guard !userName.isEmpty, !password.isEmpty else { return }
                    Task {
                        await viewModel.login(username: userName, password: password)
                        if viewModel.errorMessage != nil {
                            displayAlert = true
                            isLoggedIn = false
                        } else {
                            isLoggedIn = true
                            displayAlert = false
                        }
                    }
                } label :{
                    Text("Login")
                        .frame(maxWidth: .infinity, minHeight: 30)
                }
                .buttonStyle(.borderedProminent)
                .buttonBorderShape(.roundedRectangle)
                .padding(.top, 10)
            }
            .padding()
            .alert("Error", isPresented: $displayAlert) {
                Button("OK", role: .cancel) {
                    viewModel.errorMessage = nil
                }
            } message: {
                Text(viewModel.errorMessage ?? "An unknown error occurred.")
            }
            .onAppear {
                focusLoginPage = .userName
            }
//            .navigationDestination(isPresented: $isLoggedIn) {
//                FeedView(feedsService: appDependencies.feedService)
//            }
            .navigationDestination(item: $viewModel.loginResponse) { response in
                FeedView(feedsService: appDependencies.feedService, userName: response.userName ?? "N/A")
            }
        }
    }
    
    func signIn() {
        if userName.isEmpty {
            focusLoginPage = .userName
        } else if password.isEmpty {
            focusLoginPage = .password
        } else {
            focusLoginPage = nil
        }
    }
}


#if DEBUG
struct MockLoginService: LoginServiceProtocol {
    func login(userName: String, password: String) async throws -> LoginResponse? {
        LoginResponse(feeds: nil, userName: "akhil", error: nil)
    }
}
#endif

#Preview("Login Success") {
    LoginView(loginService: MockLoginService())
        .environment(AppDependencies())
}
    
