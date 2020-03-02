todo list 0: 绑定自己的手机号 √
拿到美国区开发者账号后，
登陆https://appleid.apple.com/
索取验证码
进入后，点击安全 -> 添加受信任的电话号码 
接着，生成App上传密码：xxx-yyy-zzz（后面使用Application Loader上传ipa包到appstore时要用到）

todo list 1: 退出旧的开发者账号 √
1.1 退出developer.apple.com上中国区的开发者账号 
    重新登陆developer.apple.com/account/ios/profile/limited/create
    会向第0步里的电话号码发送验证码

    退出itunesconnect  
    重新登陆 https://itunesconnect.apple.com/

    退出xcode上的开发者账号（xcode一直别登陆开发者账号，调试就用模拟器，打包就用描述文件 ）

1.2 开发者网站上面 创建证书 √
    1.打开Mac系统的 钥匙串访问 -> 左上角菜单：证书助理 -> 从证书颁发机构获取证书
      创建csr文件，选择存到磁盘
      常用名称：KoreanAlphabet
      邮箱写appleid的那个就行

    2.创建开发证书dev 和 生产证书dis
    3.下载证书，双击导入

// 1.3 添加真机设备？算了，直接用模拟器算了 （可以略过） 

1.4 创建应用ID，即注册appid √
    net.vwhm.koreanalphabet

// 1.5 创建描述文件？算了，直接用模拟器算了 （可以略过） 

todo list 2: 因为开发者官网 与 itunesconnect不能实时同步，
             所以，这次就先跳过itunesconnect那一步

todo list 3: Logo √
    先在iconfont上找图标，https://www.iconfont.cn
    如果没有，打开PS，自己设计一个Logo
    设计appicon 1024*1024  
    然后一键生成所有图标：http://icon.wuruihong.com/
    下载并解压

todo list 4: 新建xcode工程，create a new project √
			 选择Tapped App
			 Product name: koreanalphabet (跟前面的appid一致)
             存放到：/usr/beyond/iOS_APP/meiguo3目录

             然后先关闭xcode

todo list 5: 复制podfile，√
             修改target为 koreanalphabet
             然后执行pod install 
             打开koreanalphabet.xcworkspace，


todo list 6: 将Assets.xcassets里原来的Appicon右键删除 √
             将前面第3步解压后的 AppIcon.appiconset 拖进来
             运行到模拟器上iPhone8   

todo list 6: 打开pod工程，开始编码和测试 
6.1 把appicon图片拖进来，Assets.xcassets √
    设置只支持iPhone且竖屏 √
6.2 工程新建目录：View,Model,Controller,Tool,Resources √
6.3 打开main.storyboard，√
    分别设置底部的tab文字： Alpabet 和 Me
    图标下拉选择系统内置的：book.circle.fill 和 person.circle.fill

    // 默认图标，选中图标
    // 在iconfont上找图标，下载svg，通过Sketch导出为@2x @3x图标
    // Tab图标设计规范 https://www.jianshu.com/p/0ce2d11ef195
    // 75*75 @3x
    // 50*50 @2x
6.4 打开启动界面 LaunchScreen.storyboard， √
    修改设备尺寸为： iPhone8
    加一个图标log和一个文字 
    LaunchScreen.xib加一个imageView
    90*90,距离顶边120，垂直居中
    新建一个目录：图片
    把appicon@3x.png（180*180px）拖到Resources目录里，以供imageView引用     

6.5 设置顶部的状态条Status Bar Style 为 light content √
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
} 
6.6 修改控制器名称 √
FirstViewController -> KoreanAlphaViewController
注意修改：.h .m 以及 main.storyboard中的class

SecondViewController -> MeViewController
注意修改：.h .m 以及 main.storyboard中的class

6.7 把美国白包2中的View,Model,Controller,Resources目录中的复用代码，拷贝过来，放到对应目录下 √

6.8 开始实现第1个页面中的代码 √
背影图片 高斯模糊 调整配色
http://www.peise.net/tools/web/  三角形配色

6.9 点击按钮后，韩语语音朗读，需要联网， 从百度翻译返回字母的发音 √
报错：NSLocalizedDescription=The resource could not be loaded because the App Transport Security policy requires the use of a secure connection.}
解决办法1： 通过python脚本把所有的音频都下载下来 ——强烈推荐
解决办法2： 更改项目的App Transport Security policy __不推荐
打开info.plist, 右键 -> open as -> source code
<key>NSAppTransportSecurity</key>
    <dict>
        <key>NSAllowsArbitraryLoads</key>
        <true/>
        <key>NSExceptionDomains</key>
        <dict>
            <key>yourdomain.com</key>
            <dict>
                <key>NSIncludesSubdomains</key>
                <true/>
                <key>NSThirdPartyExceptionRequiresForwardSecrecy</key>
                <false/>
            </dict>
       </dict>
  </dict>

但是，因为百度翻译加了限制，所以还是报错：
/*
-[JuziReadTool connection:didFailWithError:] [Line 375] 
        Connection failed: Error Domain=NSURLErrorDomain Code=-1202 "The certificate for this server is invalid. You might be connecting to a server that is pretending to be “fanyi.baidu.com” which could put your confidential information at risk." UserInfo={NSURLErrorFailingURLPeerTrustErrorKey=<SecTrustRef: 0x6000008af600>, NSLocalizedRecoverySuggestion=Would you like to connect to the server anyway?, _kCFStreamErrorDomainKey=3, _kCFStreamErrorCodeKey=-9813, NSErrorPeerCertificateChainKey=(
    "<cert(0x7fa59805ae00) s: fanyi.baidu.com i: Charles Proxy CA (12 \U5341\U4e8c\U6708 2016, beyondnoMacBookPro.local)>",
    "<cert(0x7fa598020400) s: Charles Proxy CA (12 \U5341\U4e8c\U6708 2016, beyondnoMacBookPro.local) i: Charles Proxy CA (12 \U5341\U4e8c\U6708 2016, beyondnoMacBookPro.local)>"
), NSUnderlyingError=0x600003568480 {Error Domain=kCFErrorDomainCFNetwork Code=-1202 "The certificate for this server is invalid. You might be connecting to a server that is pretending to be “fanyi.baidu.com” which could put your confidential information at risk." UserInfo={NSErrorFailingURLStringKey=https://fanyi.baidu.com/gettts?lan=kor&text=%EA%B1%B0%20%20!%EA%B1%B0%20%20!%EA%B1%B0%20%20!, NSLocalizedRecoverySuggestion=Would you like to connect to the server anyway?, _kCFNetworkCFStreamSSLErrorOriginalValue=-9813, kCFStreamPropertySSLPeerCertificates=(
    "<cert(0x7fa59805ae00) s: fanyi.baidu.com i: Charles Proxy CA (12 \U5341\U4e8c\U6708 2016, beyondnoMacBookPro.local)>",
    "<cert(0x7fa598020400) s: Charles Proxy CA (12 \U5341\U4e8c\U6708 2016, beyondnoMacBookPro.local) i: Charles Proxy CA (12 \U5341\U4e8c\U6708 2016, beyondnoMacBookPro.local)>"
), _kCFStreamPropertySSLClientCertificateState=0, kCFStreamPropertySSLPeerTrust=<SecTrustRef: 0x6000008af600>, NSLocalizedDescription=The certificate for this server is invalid. You might be connecting to a server that is pretending to be “fanyi.baidu.com” which could put your confidential information at risk., _kCFStreamErrorDomainKey=3, NSErrorFailingURLKey=https://fanyi.baidu.com/gettts?lan=kor&text=%EA%B1%B0%20%20!%EA%B1%B0%20%20!%EA%B1%B0%20%20!, _kCFStreamErrorCodeKey=-9813}}, NSLocalizedDescription=The certificate for this server is invalid. You might be connecting to a server that is pretending to be “fanyi.baidu.com” which could put your confidential information at risk., NSErrorFailingURLKey=https://fanyi.baidu.com/gettts?lan=kor&text=%EA%B1%B0%20%20!%EA%B1%B0%20%20!%EA%B1%B0%20%20!, NSErrorFailingURLStringKey=https://fanyi.baidu.com/gettts?lan=kor&text=%EA%B1%B0%20%20!%EA%B1%B0%20%20!%EA%B1%B0%20%20!, NSErrorClientCertificateStateKey=0}
*/

这个时候：如果使用百度翻译提供的api 加入它的开发者，通过密钥 可以进行调用
但是 需要审核app，实在太麻烦了ORZ

一开始尝试使用mac自带的curl， 发现还是无法下载音频
           curl 示例1： curl -o beyond.jpg http://vwhm.net/beyond.jpg
           curl 示例2： curl -O http://vwhm.net/beyond.jpg 将保持原来的文件名
           curl 示例3: 
           http://fanyi.baidu.com/gettts?lan=kor&text=ㅏ  !ㅏ  !ㅏ  !
           http://fanyi.baidu.com/gettts?lan=kor&text=%E3%85%8F%20%20!%E3%85%8F%20%20!%E3%85%8F%20%20!
           
           curl -o 1.mp3 https://fanyi.baidu.com/gettts?lan=kor&text=ㅏ  !ㅏ  !ㅏ  !
           curl -A "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_3) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/80.0.3987.87 Safari/537.36" -o 6.mp3 -b cookie1.txt https://fanyi.baidu.com/gettts?lan=kor&text=%E3%85%8F%20%20!%E3%85%8F%20%20!%E3%85%8F%20%20! 


good__最后，强烈推荐使用python脚本，批量下载下来, 然后放到ipa包内，这样朗读的时候就不需要联网去下载了
代码如下：
import urllib
arr = ["ㅏ","ㅑ","ㅓ","ㅕ","ㅗ","ㅛ","ㅜ","ㅠ","ㅡ","ㅣ","ㄱ","가","갸","거","겨","고","교","구","규","그","기","ㄴ","나","냐","너","녀","노","뇨","누","뉴","느","니","ㄷ","다","댜","더","뎌","도","됴","두","듀","드","디","ㄹ","라","랴","러","려","로","료","루","류","르","리","ㅁ","마","먀","머","며","모","묘","무","뮤","므","미","ㅂ","바","뱌","버","벼","보","뵤","부","뷰","브","비","ㅅ","사","샤","서","셔","소","쇼","수","슈","스","시","ㅇ","아","야","어","여","오","요","우","유","으","이","ㅈ","자","쟈","저","져","조","죠","주","쥬","즈","지","ㅊ","차","챠","처","쳐","초","쵸","추","츄","츠","치","ㅋ","카","캬","커","켜","코","쿄","쿠","큐","크","키","ㅌ","타","탸","터","텨","토","툐","투","튜","트","티","ㅍ","파","퍄","퍼","펴","포","표","푸","퓨","프","피","ㅎ","하","햐","허","혀","호","효","후","휴","흐","히","ㄲ","까","꺄","꺼","껴","꼬","꾜","꾸","뀨","끄","끼","ㄸ","따","땨","떠","뗘","또","뚀","뚜","뜌","뜨","띠","ㅃ","빠","뺘","뻐","뼈","뽀","뾰","뿌","쀼","쁘","삐","ㅆ","싸","쌰","써","쎠","쏘","쑈","쑤","쓔","쓰","씨","ㅉ","짜","쨔","쩌","쪄","쪼","쬬","쭈","쮸","쯔","찌","ㅐ","ㅒ","ㅔ","ㅖ","ㅘ","ㅙ","ㅚ","ㅝ","ㅞ","ㅟ","ㅢ","ㄱ","개","걔","게","계","과","괘","괴","궈","궤","귀","긔","ㄴ","내","냬","네","녜","놔","놰","뇌","눠","눼","뉘","늬","ㄷ","대","댸","데","뎨","돠","돼","되","둬","뒈","뒤","듸","ㄹ","래","럐","레","례","롸","뢔","뢰","뤄","뤠","뤼","릐","ㅁ","매","먜","메","몌","뫄","뫠","뫼","뭐","뭬","뮈","믜","ㅂ","배","뱨","베","볘","봐","봬","뵈","붜","붸","뷔","븨","ㅅ","새","섀","세","셰","솨","쇄","쇠","숴","쉐","쉬","싀","ㅇ","애","얘","에","예","와","왜","외","워","웨","위","의","ㅈ","재","쟤","제","졔","좌","좨","죄","줘","줴","쥐","즤","ㅊ","채","챼","체","쳬","촤","쵀","최","춰","췌","취","츼","ㅋ","캐","컈","케","켸","콰","쾌","쾨","쿼","퀘","퀴","킈","ㅌ","태","턔","테","톄","톼","퇘","퇴","퉈","퉤","튀","틔","ㅍ","패","퍠","페","폐","퐈","퐤","푀","풔","풰","퓌","픠","ㅎ","해","햬","헤","혜","화","홰","회","훠","훼","휘","희","ㄲ","깨","꺠","께","꼐","꽈","꽤","꾀","꿔","꿰","뀌","끠","ㄸ","때","떄","떼","뗴","똬","뙈","뙤","뚸","뛔","뛰","띄","ㅃ","빼","뺴","뻬","뼤","뽜","뽸","뾔","뿨","쀄","쀠","쁴","ㅆ","쌔","썌","쎄","쎼","쏴","쐐","쐬","쒀","쒜","쒸","씌","ㅉ","째","쨰","쩨","쪠","쫘","쫴","쬐","쭤","쮀","쮜","쯰","ㄱ","ㄴ","ㄷ","ㄹ","ㅁ","ㅂ","ㅇ","가","각","간","갇","갈","감","갑","강","나","낙","난","낟","날","남","납","낭","다","닥","단","닫","달","담","답","당","라","락","란","랃","랄","람","랍","랑","마","막","만","맏","말","맘","맙","망","바","박","반","받","발","밤","밥","방","사","삭","산","삳","살","삼","삽","상","아","악","안","앋","알","암","압","앙","자","작","잔","잗","잘","잠","잡","장","차","착","찬","찯","찰","참","찹","창","카","칵","칸","칻","칼","캄","캅","캉","타","탁","탄","탇","탈","탐","탑","탕","파","팍","판","팓","팔","팜","팝","팡","하","학","한","핟","할","함","합","항"]
for alpha in arr:
    url = 'http://fanyi.baidu.com/gettts?lan=kor&text='+alpha+'  !'+alpha+'  !'+alpha+'  !'
    urllib.urlretrieve(url, alpha+".mp3")

6.9 开始实现tab的第2个界面 √
    直接照搬美国白包2中的代码即可
--------------------------    
todo list 7:隐私政策：privacy.html,放到 Linux服务器 √
    将本机的privacy.html scp 至 服务器
    ssh root@47.75.103.58
    password:
    cd /usr/local/nginx/html/vwhm_net_wwwroot/app/
    mkdir koreanalpha

    切回本地终端：
    cd /Users/beyond/iOS_APP/meiguo3
    scp /Users/beyond/iOS_APP/meiguo3/privacy.html root@47.75.103.58:/usr/local/nginx/html/vwhm_net_wwwroot/app/koreanalpha
    输入密码

    此时，再将url地址 http://vwhm.net/app/koreanalpha/privacy.html，填回itunesconnect
--------------------------    
todo list 9: 尾声，上传项目源代码到git
新建 .gitignore
在里面写上Pods
表示Pods目录不需要git来管理,因为它是pod install自动生成的

git init
git add --all
git commit -m 'iOS 美国区白包3 Korean Alpha 第一次提交(itunesconnect不能实时同步appid,尚未创建应用)'
git remote add origin https://github.com/ixixii/iOS_APP_MeiGuo_Korean_Alpha.git
git push -u origin master
git push origin master

--------------------------
todo list 2: 转到itunesconnect创建应用 (开发者网站上注册appid后，不一定itunesconnect会实时更新)
    转到itunesconnect,创建应用,新建app
    起名：ThaiAlpha （可能会提示名称已被注册）
    主要语言：英文
    


    名称：ThaiAlpha
    副标题：Thai Alpha Learning
    类别：教育/工具
    价格：免费
    年龄分级：4+

    此时，再将隐私政策的url地址 http://vwhm.net/app/koreanalpha/privacy.html，填回itunesconnect

--------------------------

todo list 7: 打包ipa，Xcode不用登陆开发者账号，使用distribution provisoning file就行

			使用Application uploder上传ipa 
			打包上传时，不用XCODE，而是推荐使用Application uploder，但是需要用app专用密码登陆才行
			url: https://appleid.apple.com/
    		

todo list 8: 8种语言本地化 后，提交苹果审核
			关键词，记得要填写
			英文美国
			It is an Thai alphabet learning software. For those who are interested in Thai, this tool is necessary. It can help you quickly and firmly master Thai alphabet, including their pronunciation and writing scientifically and efficiently.



			中文简体
			一款泰语字母学习软件，对于那些对泰语感兴趣的人士来说这款工具是必备品，它能科学高效地帮您快速并且牢固地掌握泰语字母，包括他们的发音和书写

			中文繁体
			一款泰語字母學習軟體，對於那些對泰語感興趣的人士來說這款工具是必備品，它能科學高效地幫您快速並且牢固地掌握泰語字母，包括他們的發音和書寫

			英文英国
			英文加拿大
			英文澳大利亚

			日文
			タイ語のアルファベット学習ソフトは、タイ語に興味がある人にとって必要なツールです。科学的に効率的に迅速かつ確実にタイ語のアルファベットをマスターします。彼らの発音と書き込みが含まれます。

			韩文
			태국어 알파벳 학습 소프트웨어, 태국어에 흥미를 느끼는 사람들에게 이 공구는 필수품입니다. 그것은 과학적 효율적으로 당신에게 빠른 속도와 태국어 알파벳, 그들의 발음과 글씨를 포함하여 쓰기 포함합니다.


			版权：Alva Denise



todo list 10: 清理战场
    注销Application uploader, 
    developer.apple.com
    https://appstoreconnect.apple.com/login

    准备登陆下一个账号，写第3个美国区白包			


