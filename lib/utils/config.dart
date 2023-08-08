// 判定是否啟用模擬器，開發時需啟用；生產時須關閉
const bool USE_EMULATOR = true;
// 設定 ip, 若是使用實體手機進行測試, 需更換 ip 為電腦 ip
const String IP = "localhost";
// const String IP = "192.168.22.117";
// 判定是否為開發階段
// 定義, 生產階段時, info 以上的 log 才打印出來; 開發階段時, 所有 log 都打印出來
const bool IS_DEVELOPMENT_STAGE = true;
// 桶子名稱
const String BUCKET_NAME = "test_bucket";
// Google Provider Client ID
const String GOOGLE_PROVIDER_CLIENT_ID = "";
