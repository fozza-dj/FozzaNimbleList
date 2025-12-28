//
//  MusouHero.swift
//  FozzaNimbleList
//
//  Created by ByteDance on 2025/12/28.
//

enum MusouHero: Int, CaseIterable, Codable {
    // MARK: - DYNASTY WARRIORS
    // MARK: - Wei (1-)
    case xiaHouDun = 1     // 夏侯惇
    case caoCao = 2        // 曹操
    case xiaHouYuan = 3    // 夏侯渊
    case dianWei = 4       // 典韦
    case xuZhu = 5         // 许褚
    case caoRen = 6        // 曹仁
    case zhangLiao = 7     // 张辽
    case xuHuang = 8       // 徐晃
    case zhangHe = 9       // 张郃
    case yueJin = 10       // 乐进
    case xunYu = 11        // 荀彧
    case guoJia = 12       // 郭嘉
    case jiaXu = 13        // 贾诩
    case caoPi = 14        // 曹丕
    case zhenJi = 15       // 甄姬
    case wangYi = 16       // 王异
    case yuJin = 17        // 于禁
    
    // MARK: - Wu (101-)
    case zhouYu = 101      // 周瑜
    case sunJian = 102     // 孙坚
    case sunCe = 103       // 孙策
    case sunQuan = 104     // 孙权
    case sunShangXiang = 105 // 孙尚香
    case daQiao = 106      // 大乔
    case xiaoQiao = 107    // 小乔
    case luSu = 108        // 鲁肃
    case luMeng = 109      // 吕蒙
    case luXun = 110       // 陆逊
    case huangGai = 111    // 黄盖
    case taiShiCi = 112    // 太史慈
    case ganNing = 113     // 甘宁
    case zhouTai = 114     // 周泰
    case lingTong = 115    // 凌统
    case lianShi = 116     // 练师
    
    // MARK: - Shu (201-)
    case zhaoYun = 201     // 赵云
    case liuBei = 202      // 刘备
    case guanYu = 203      // 关羽
    case zhangFei = 204    // 张飞
    case zhugeLiang = 205  // 诸葛亮
    case maChao = 206      // 马超
    case huangZhong = 207  // 黄忠
    case weiYan = 208      // 魏延
    case yueYing = 209     // 月英
    case pangTong = 210    // 庞统
    case xuShu = 211       // 徐庶
    case guanPing = 212    // 关平
    case guanYinPing = 213 // 关银屏
    case faZheng = 214     // 法正
    case jiangWei = 215    // 姜维
    case xingCai = 216     // 星彩
    
    // MARK: - Jin (301-)
    case simaYi = 301      // 司马懿
    case zhangChunHua = 302 // 张春华
    case simaShi = 303     // 司马师
    case simaZhao = 304    // 司马昭
    case wangYuanji = 305  // 王元姬
    case zhongHui = 306    // 钟会
    
    // MARK: - Other (401-)
    case zhangJiao = 401    // 张角
    case dongZhuo = 402    // 董卓
    case yuanShao = 403    // 袁绍
    case luBu = 404        // 吕布
    case diaoChan = 405    // 貂蝉
    case luLingqi = 406    // 吕玲绮
    case chenGong = 407    // 陈宫
    case mengHuo = 408     // 孟获
    case zhuRong = 409     // 祝融
    case zuoCi = 410       // 左慈
    
    // MARK: - SAMURAI WARRIORS
    // MARK: - Oda (501-)
    case nobunagaOda = 501  // 织田信长
    case no = 502           // 浓姬
    case mitsuhideAkechi = 503 // 明智光秀
    case ranmaruMori = 504  // 森兰丸
    case oichi = 505        // 阿市
    case katsuieShibata = 506 // 柴田胜家
    case toshiieMaeda = 507 // 前田利家
    case keijiMaeda = 508   // 前田庆次
    case gracia = 509       // 细川玉子 (伽罗奢)
    
    // MARK: - Toyotomi (601-)
    case hideyoshiToyotomi = 601 // 丰臣秀吉
    case nene = 602              // 宁宁
    case hanbeiTakenaka = 603    // 竹中半兵卫
    case kanbeiKuroda = 604      // 黑田官兵卫
    case mitsunariIshida = 605   // 石田三成
    case sakonShima = 606        // 岛左近
    case yoshitsuguOtani = 607   // 大谷吉继
    case kiyomasaKato = 608      // 加藤清正
    case matureYukimuraSanada = 609 // 真田幸村(壮年)
    case chacha = 610            // 茶茶
    
    // MARK: - Tokugawa / Hojo (701-)
    case ieyasuTokugawa = 701    // 德川家康
    case hanzoHattori = 702      // 服部半藏
    case tadakatsuHonda = 703    // 本多忠胜
    case ina = 704               // 稻姬
    case naotoraIi = 705         // 井伊直虎
    case naomasaIi = 706         // 井伊直政
    case takatoraTodo = 707      // 藤堂高虎
    case ujiyasuHojo = 708       // 北条氏康
    case kai = 709               // 甲斐姬
    case kotaroFuma = 710        // 风魔小太郎
    
    // MARK: - Uesugi / Takeda (801-)
    case yukimuraSanada = 801    // 真田幸村
    case kunoichi = 802          // 女忍
    case shingenTakeda = 803     // 武田信玄
    case kenshinUesugi = 804     // 上杉谦信
    case kanetsuguNaoe = 805     // 直江兼续
    case masayukiSanada = 806    // 真田昌幸
    case nobuyukiSanada = 807    // 真田信之
    case sasuke = 808            // 佐助
    
    // MARK: - Other_SW (901-)
    case masamuneDate = 901      // 伊达政宗
    case nagamasaAzai = 902      // 浅井长政
    case magoichiSaika = 903     // 杂贺孙市
    case yoshimotoImagawa = 904  // 今川义元
    case goemonIshikawa = 905    // 石川五右卫门
    case okuni = 906             // 阿国
    case motonariMori = 907      // 毛利元就
    case takakageKobayakawa = 908 // 小早川隆景
    case ginchiyoTachibana = 909 // 立花訚千代
    case muneshigeTachibana = 910 // 立花宗茂
    case yoshihiroShimazu = 911  // 岛津义弘
    case toyohisaShimazu = 912   // 岛津丰久
    case motochikaChosokabe = 913 // 长宗我部元亲
    
    // MARK: - Guest (1001-)
    case sophie = 1001           // 索菲
    case ryza = 1002             // 莱莎
    case yumia = 1003            // 尤米雅
    case ryuHayabusa = 1004      // 隼龙
    case ayane = 1005            // 绫音
    case rachel = 1006           // 瑞秋
    case momiji = 1007           // 红叶
}
