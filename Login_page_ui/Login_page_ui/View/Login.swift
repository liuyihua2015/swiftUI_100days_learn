//
//  Login.swift
//  Login_page_ui
//
//  Created by liuyihua on 2021/6/22.
//

import SwiftUI

struct Login: View {
    
    @State var email = ""
    @State var password = ""
    
    var body: some View {
        
        VStack{
        
            Text("Sign In!")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(Color("dark"))
                //lette r Spacing
                .kerning(1.9)
                .frame(maxWidth:.infinity,alignment:.leading)
            
            //email and  password
            VStack(alignment:.leading, spacing: 8, content: {
                
                Text("User Name")
                    .fontWeight(.bold)
                    .foregroundColor(.gray)
        
                TextField("ijustine@gmail.com", text: $email)
                    .font(.system(size: 20,weight: .bold))
                    .foregroundColor(Color("dark"))
                    .padding(.top,5)
                
                Divider()

            }).padding(.top,25)
            
            //email and  password
            VStack(alignment:.leading, spacing: 8, content: {
                
                Text("Password")
                    .fontWeight(.bold)
                    .foregroundColor(.gray)
        
                SecureField("123456", text: $password)
                    .font(.system(size: 20,weight: .bold))
                    .foregroundColor(Color("dark"))
                    .padding(.top,5)
                
                Divider()
 
            }).padding(.top,20)
            
            
            //Forget password
            
            Button(action: {}, label: {
                Text("Forget password?")
                    .fontWeight(.bold)
                    .foregroundColor(.gray)
            })
            
            // this line will reduce the use of unwanted hstack and spacers ...
            // try to use this and reduce the code in swiftUI
            .frame(maxWidth: .infinity, alignment: .trailing)
            .padding(.top,10)
            
            //NEXT BUTTON ...
            Button(action: {}, label: {
                Image(systemName: "arrow.right")
                    .font(.system(size: 24,weight: .bold))
                    .foregroundColor(.white)
                    .padding()
                    .background(Color("dark"))
                    .clipShape(Circle())
                //shadow...
                    .shadow(color: Color("lightBlue"), radius: 5, x: 0.0, y: 0.0)
            })
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.top,10)
        }
        .padding()
    }
}

struct Login_Previews: PreviewProvider {
    static var previews: some View {
        Login()
    }
}
