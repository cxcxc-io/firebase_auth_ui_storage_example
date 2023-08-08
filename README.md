# flutter_application_1

此應用是一個簡單且功能完備的應用，具有註冊、登入、發送驗證信、上傳物件、列出物件、刪除物件以及下載物件等功能。  

# 功能介紹

- **註冊**：新用戶可以在此進行註冊。
- **登入**：已註冊用戶可以進行登入。
- **發送驗證信**：用戶註冊後，系統將發送驗證信至用戶註冊的電子郵箱，用戶點擊驗證連結後即可完成驗證。
- **上傳物件**：登入後，用戶可以選擇物件上傳至服務器。
- **列出物件**：用戶可以查看已上傳的物件清單。
- **刪除物件**：用戶可以刪除已上傳的物件。  
- **下載物件**：用戶可以下載已上傳的物件。  

# 第一次使用流程  
## 清除套件設定  
```
flutter clean  
flutter pub get  
```    

## 啟用與連入本地模擬環境  
```
docker-compose up -d  
docker exec -it firebase-emulator.cxcxc.xingming /bin/bash  
```  

## 登入firebase
```
firebase login --reauth
```  

## 透過flutterfire命令列，註冊專案  
```
dart pub global activate flutterfire_cli

PATH="$PATH":"$HOME/.pub-cache/bin"  

flutterfire configure  
```  

## 啟用模擬器，並匯入firestore 測試資料集  
```
firebase init
<!-- 若要調整專案, 使用 firebase use <project_id> -->
firebase emulators:start
<!-- 若無法啟動, 檢查 firebase.json -->
```  

## 更新 firebase.json  
```  
{
  "storage": {
    "rules": "storage.rules"
  },
  "emulators": {
    "auth": {
      "host": "0.0.0.0",
      "port": 9099
    },
    "storage": {
      "host": "0.0.0.0",
      "port": 9199
    },
    "ui": {
      "host": "0.0.0.0",
      "enabled": true,
      "port": 4000
    },
    "singleProjectMode": true
  }
}
```  

## 添加開發時網路相關權限
android\app\src\debug\AndroidManifest.xml   
```   
<manifest xmlns:android="http://schemas.android.com/apk/res/android">
    <!-- The INTERNET permission is required for development. Specifically,
         the Flutter tool needs it to communicate with the running application
         to allow setting breakpoints, to provide hot reload, etc.
    -->
    
    <!-- 若使用 Android 需在此添加 -->
    <application
    android:usesCleartextTraffic="true">
    </application>
    <!-- 若使用 Android 需在此添加 -->


    <uses-permission android:name="android.permission.INTERNET"/>

</manifest>
```   

## 設置最低SDK版本、啟用 multidex
android\app\build.gradle
```
android {
  defaultConfig {
    // minSdkVersion flutter.minSdkVersion
    minSdkVersion 19 
    multiDexEnabled true
  }
}
...
dependencies {
    ...
    implementation 'com.android.support:multidex:1.0.3'
    ...
}
```

## 在 Android 做 Google 驗證
https://developers.google.com/android/guides/client-auth?hl=zh-tw
需取得憑證的 SHA-1 指紋
```
cd android
<!-- 以下命令須安裝JAVA，並設定JAVA_HOME環境變數 -->
.\gradlew signingReport
// 取得 Task :app:signingReport 的 sha1
// 至 firebase 填寫 sha1值
// 注意：在firebase emulator 無法使用 google Auth功能, 若要看見效果, 可至 lib\utils\config.dart 設定 const bool USE_EMULATOR = false;  並在google 登入試試
```

## 設定 
lib/utils/config.dart
* 未來若要生產用需要全改為環境變數較為安全，避免反向工程
* 因開發用, 若要在開發時啟動環境變數, 需額外設定 IDE 環境變數的設定  
  
```
// 判定是否啟用模擬器，開發時需啟用；生產時須關閉
const bool USE_EMULATOR = true;
// 設定 ip, 若是使用實體手機進行測試, 需更換 ip 為電腦 ip
const String IP = "localhost";
// 判定是否為開發階段
// 定義, 生產階段時, info 以上的 log 才打印出來; 開發階段時, 所有 log 都打印出來
const bool IS_DEVELOPMENT_STAGE = true;
// 桶子名稱
const String BUCKET_NAME = "test_bucket";
// Google Provider Client ID
const String GOOGLE_PROVIDER_CLIENT_ID = "<Firebase Google Provider ID>";
```