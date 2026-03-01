# supabase

## For facbook Auth in supabase

1. Go to https://developers.facebook.com/apps/
2. Create a new app
   - i. for app to create in app detail give some name
   - ii. in usecase select auth facbook
   - iii. business usecase select none
   - iv. the in requirment just select none an clicked save
   - v. the give your app paswword

3. Go to settings -> Basic
4. Copy App ID and App Secret
5. Go to https://supabase.com/dashboard/project/your-project-id/auth/providers
6. Click on Facebook
7. Paste App ID and App Secret
8. Click on Save

---

### afther this when need the following steps to enable the auth in app

1. go to use case and clicked customize
2. past the supabse facbook url in valid auth redirect url field snd save
3. go to quick start select android -> next the again next
4. the add flutter app package name e.g = `com.example.supabase` and aslo mainactivity name e.g = `.MainActivity`
5. now we need hash key for this go to url= https://code.google.com/archive/p/openssl-for-windows/downloads download it add to enviroment variable
6. copy this command to cmd:

   ```bash
   keytool -exportcert -alias androiddebugkey -keystore "%USERPROFILE%\.android\debug.keystore" -storepass android -keypass android | "C:\Program Files\openssl\bin\openssl.exe" sha1 -binary | "C:\Program Files\openssl\bin\openssl.exe" base64
   ```

   and paste it in cmd and copy the output

7. it will give key copy and pst -> sae -> continue then next
8. now in app -> main-> res-> values-> create string xml and past the code

   ```xml
   <string name="app_name">supabase_tutorial</string>
   <string name="facebook_app_id">client_id</string>
   <string name="fb_login_protocol_scheme">fbclient_id</string>
   <string name="facebook_client_token">client_token</string>
   ```

   client token will be in setting-> advance

9. add the code in app->main->AndroidManifest.xml

   ```xml
               <meta-data
               android:name="flutterEmbedding"
               android:value="2" />
           <meta-data
               android:name="com.facebook.sdk.ApplicationId"
               android:value="@string/facebook_app_id"/>
           <meta-data
               android:name="com.facebook.sdk.ClientToken"
               android:value="@string/facebook_client_token"/>
           <intent-filter>
                   <data android:scheme="devcode" android:host="fblogin" />
                   <action android:name="android.intent.action.VIEW"/>
                   <category android:name="android.intent.category.DEFAULT"/>
                   <category android:name="android.intent.category.BROWSABLE"/>
               </intent-filter>    //this is for facebook the 12 pint url made from here
           <activity
               android:name="com.facebook.FacebookActivity"
               android:configChanges=
                   "keyboard|keyboardHidden|screenLayout|screenSize|orientation"
               android:label="@string/app_name" />
           <activity
               android:name="com.facebook.CustomTabActivity"
               android:exported="true">
               <intent-filter>
                   <action android:name="android.intent.action.VIEW" />
               <category android:name="android.intent.category.DEFAULT" />
               <category android:name="android.intent.category.BROWSABLE" />
               <data android:scheme="@string/fb_login_protocol_scheme" />
           </intent-filter>
       </activity>
   ```

10. add this to on top of app->main->AndroidManifest.xml

    ```xml
    <uses-permission android:name="android.permission.INTERNET" />

    <uses-permission android:name="com.google.android.gms.permission.AD_ID" tools:node="remove"/>
    ```

11. then next next upto end
12. REDIRECT URI == `decode://fblogin`
13. add thie abve url in supabase url configuration
14. create a deepLink file and add this code

    ```dart
    void deepLink({required BuildContext context}) {
      final appLink = AppLinks();
      appLink.uriLinkStream.listen((uri) {
        if (uri.toString().contains('fblogin')) {
          if (!context.mounted) return;
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
          );
          print(uri);
        }
      });
    }
    ```

    now call the function in signup screen init state

---

## For Apple Auth in supabase

1. Go to https://developer.apple.com/account/
2. Create a new app
3. Go to settings -> Basic
4. Copy App ID and App Secret
5. Go to https://supabase.com/dashboard/project/your-project-id/auth/providers
6. Click on Apple
7. Paste App ID and App Secret
8. Click on Save
