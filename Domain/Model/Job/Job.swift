//
//  Job.swift
//  Domain
//
//  Created by Dao Van Nha on 04/11/2023.
//

import Foundation
import UIKit

public enum JobValue: String {
    case water
    case electricity
    case refrigeration
    case orther
    case turner
    case machine
    case miller
    case planer
    case noun
    case farrier
    case welder
    case electricwelder
    case carpenter
    case thone
    case betong
    case cotthep
    case sonvoi
    
    public init?(rawValue: String) {
        switch rawValue {
        case "water":
            self = .water
        case "electricity":
            self = .electricity
        case "refrigeration":
            self = .refrigeration
        case "turner":
            self = .turner
        case "machine":
            self = .machine
        case "miller":
            self = .miller
        case "planer":
            self = .planer
        case "noun":
            self = .noun
        case "farrier":
            self = .farrier
        case "welder":
            self = .welder
        case "electricwelder":
            self = .electricwelder
        case "carpenter":
            self = .carpenter
        case "thone":
            self = .thone
        case "betong":
            self = .betong
        case "cotthep":
            self = .cotthep
        case "sonvoi":
            self = .sonvoi
        default :
            self = .orther
        }
    }
    
    public var title: String {
        switch self {
        case .water:
            return "Thợ nước"
        case .electricity:
            return "Thợ điện"
        case .refrigeration:
            return "Điện điện gia dụng"
        case .orther:
            return "Khác"
        case .turner:
            return "Thợ tiện"
        case .machine:
            return "Thợ nguội"
        case .miller:
            return "Thợ phay"
        case .planer:
            return "Thợ bào"
        case .noun:
            return "Thợ rèn"
        case .farrier:
            return "Thợ gò"
        case .welder:
            return "Thợ hàn xì"
        case .electricwelder:
            return "Thợ hàn điện"
        case .carpenter:
            return "Thợ mộc"
        case .thone:
            return "Thợ nề"
        case .betong:
            return "Thợ bê tông"
        case .cotthep:
            return "Thợ cốt thép"
        case .sonvoi:
            return "Thợ sơn vôi"
        }
    }
    
    public var knowledge: [Double: [String]] {
        switch self {
        case .water:
            return [1: ["- Hiểu biết về hệ thống cấp và thoát nước:",
                        "- Kiến thức về vật liệu và công cụ",
                        "- Kiến thức về cách lắp đặt thiết bị nước",
                        "- Kỹ năng chẩn đoán và sửa chữa sự cố",
                        "- Kiến thức về tiêu chuẩn xây dựng và vệ sinh"]]
        case .electricity:
            return [1:["- Kiến thức về Hệ thống Điện",
                       "- Cách Lắp Đặt và Sửa Chữa Điện",
                       "- Đọc Bản Vẽ Kỹ Thuật",
                       "- An Toàn Điện",
                       "- Kiến thức về Vật Liệu và Công Cụ",
                       "- Kiến Thức Về Tiết Kiệm Năng Lượng"]]
        case .refrigeration:
            return [1: ["Hiểu về dòng điện, điện áp, trở kháng, và các nguyên lý cơ bản của điện tử",
                        "Đọc và hiểu sơ đồ mạch điện tử, bao gồm các ký hiệu, linh kiện, và cách chúng tương tác với nhau.",
                        "Nhận biết, kiểm tra và thay thế linh kiện điện tử như resistor, capacitor, transistor, IC, v.v.",
                        "Sử dụng các dụng cụ và thiết bị đo lường như multimeter, oscilloscope, và các công cụ sửa chữa khác.",
                        "Hiểu rõ về cấu trúc và nguyên lý hoạt động của các thiết bị gia đình như tivi, tủ lạnh, máy giặt, máy lạnh, v.v."]]
        case .orther:
            return [:]
        case .turner:
            return [2: ["- Thuộc tên và công dụng các phụ tùng đi theo với máy.",
                        "- Biết cách gá lắp nó lên máy.",
                        "- Biết tính chất kim thuộc, thêm các loại thép.",
                        "- Biết sử dụng hộp số khoảng tiện và hộp số răng.",
                        "- Biết sử dụng và bảo quản máy."],
                    3: ["- Hiểu biết bậc 2, thêm:",
                        "- Biết đặc tính các loại thép thông dụng, sơ lược thép làm dao tiện.",
                        "- Đọc được bản vẽ dễ, có đủ dấu đúng sai, nhằn sáng.",
                        "- Biết sơ lược tốc độ tiện các loại kim, sắt, gang, đồng, thép.",
                        "- Biết rõ cấu tạo của máy mình dùng, biết cách bảo quản tốt giữ cho máy và công việc làm bảo đảm chính xác.",
                        "- Đọc được thước cặp 1/50 và pan-mer (pal-mer)."],
                    4: ["- Trình độ hiểu biết thợ bậc 3, thêm:",
                        "- Đọc được bản vẽ của mình làm.",
                        "- Biết đặc tính các loại thép dụng cụ (trừ thép gió và các -buýt).",
                        "- Tính được các loại răng Ăng-lê trên máy Ăng-lê, Pháp.",
                        "- Biết phép tính côn, điều chỉnh bàn dao đúng góc côn ấn định."],
                    5: ["- Có trình độ thợ bậc 4 và thêm:",
                        "- Sử dụng các loại đo độ chính xác 1/100 (sâu lỗ, đo răng mô-duyn (module)).",
                        "- Hiểu được các quy định về đúng sai lắp ghép thông thường.",
                        "- Đọc được các hình chiếu vẽ bộ phận tiện khó vừa đủ các dấu.",
                        "- Sơ lược về lý thuyết gọt cắt.",
                        "- Tính răng và tính côn thành thạo.",
                        "- Biết sử dụng véc-ni-ê (vernier) bàn máy được bảo đảm .",
                        "- Đặc tính các loại thép gió, dao cac-buya, cách sử dụng, mài."],
                    6: ["- Có trình độ thợ bậc 5 và thêm:",
                        "- Sử dụng thạo các loại đồ đo chính xác 1/100",
                        "- Sử dụng thành thạo các loại máy tiện trơn. Phát hiện được các bệnh ở các bộ phận ảnh hưởng đến tính chất chính xác của công việc.",
                        "- Đọc được bản vẽ của việc mình làm được.",
                        "- Hiểu được lý thuyết gọt cắt và các góc của dao.",
                        "- Biết rõ đặc tính các loại thép dụng cụ. Hiểu sơ lược về nhiệt luyện các loại đó."],
                    7: ["- Có trình độ bậc 6, thêm:",
                        "- Sử dụng được đúng cách bất cứ một loại máy tiện nào sau khi đã nghiên cứu kiểm tra được độ chính xác của máy theo quy định kiểm nghiệm.",
                        "- Phát hiện được việc sửa chữa bảo đảm chính xác.",
                        "- Áp dụng được lý luận gọt cắt vào thực tế. Nắm được ảnh hưởng giữa các yếu tố, ảnh hưởng lẫn nhau giữa góc cắt, tốc độ khoảng tiện v.v…",
                        "- Hiểu rõ tính chất thép dụng cụ và cách tôi luyện (sử dụng tôi thép gió, cac-buya).",
                        "- Nắm được sức máy, sức dao đạt được hiệu suất tốc độ.",
                        "- Nắm được trọng điểm của công việc để chú ý đặc biệt khi gá lắp – đo kích thước.",
                        "- Phát hiện các bệnh làm giảm sút phẩm của công việc và chỉnh máy chữa được các bệnh đó (rung, gằn, méo, v.v…)",
                        "- Có khả năng nghiên cứu trình tự của một bộ phận công việc khó, chuẩn bị đầy đủ và bố trí dao trên các loại máy tiện."],
                    8: ["- Hiểu biết về cơ bản các phép đúng sai, nhẵn sáng.",
                        "- Thông thạo về phương pháp gá lắp và tiện trong mọi trường hợp khó khăn của nghề tiện hiện nay.",
                        "- Hiểu biết về lý luận gọt, cắt các loại kim,",
                        "- Đọc và phân tích các bản vẽ khó."]]
        case .machine:
            return [2: ["- Biết cách sử dụng các dụng cụ thông  thường, thứ nào vào việc ấy.",
                        "- Biết cách lấy dấu vật đơn giản nhất (như một “plaque” vuông) trên bàn máy.",
                        "- Biết sử dụng thước cập 1/10.",
                        "- Biết sử dụng rửa đục đúng quy cách.",
                        "- Biết tên và phân loại được các loại kim thuộc thông thường.",
                        "- Phân định được vít và ê-cu mấy đầu răng, răng phải, răng trái."],
                    3: ["- Biết cách lấy dấu đúng quy cách các bộ phận đơn giản (do bậc mình phải làm).",
                        "- Biết được tình trạng tốt xấu các loại dụng cụ thông thường.",
                        "- Biết sơ qua về máy công cụ đơn giản như máy khoan, bảo, tiện, mài.",
                        "- Đọc được bản vẽ dễ và đơn giản.",
                        "- Biết cách chuyển từ thước mét ra thước Anh và ngược lại.",
                        "- Biết được các dấu trên bản vẽ (các dấu này thể hiện các yêu cầu kỹ thuật).",
                        "- Biết phương pháp rèn, tôi dụng cụ thông thường (tôi ở lò rèn)."],
                    4: ["- Biết cách lấy dấu các bộ phận máy thông thường theo bản vẽ: đài dao tiện, đầu ngựa máy tiện, pở-la-tô (plateau) máy khoan.",
                        "- Biết cách sử dụng pan-me (palmer) thước cập 1/50.",
                        "- Biết sự cấu tạo của máy khoan, phay, bào, tiện loại thường.",
                        "- Biết đặc điểm và tình chất các kim loại thông thường không kể thép dụng cụ.",
                        "- Hiểu sơ lược về phép đúng sai, lắp ghép."],
                    5: ["- Lấy dấu được các bộ phận do mình phải làm (theo bản vẽ).",
                        "- Nhận thức được những trọng điểm hay chỗ quan trọng trong bộ phận máy do mình chế tạo. Phân tích các kích thích quan trọng.",
                        "- Vẽ tay được các bảng vẽ dễ.",
                        "- Biết chế tạo theo phép đúng sai.",
                        "- Hiểu biết về tất cả các loại dụng cụ đo lường như pan-me (palmer), com-pa-ra-tơ (com-parateur), tăm-pông (tampon), ca-líp (caliber), giô-giơ (jauge)"],
                    6: ["- Nắm vững những phương pháp lấy dấu, phương pháp chế tạo các bộ phận máy do bậc mình phải làm.",
                        "- Đọc và phân tích được các bảng vẽ phức tạp và vẽ tay được các bộ phận thông thường cần 2, 3 mặt chính diện, trên, dưới.",
                        "- Biết sự cấu tạo của các máy phức tạp (các loại máy công cụ hiện đại).",
                        "- Có khả năng hướng dẫn thợ cấp dưới."],
                    7: ["- Biết nguyên lý cấu tạo các máy công cụ.",
                        "- Có trình độ hiểu biết về nghề để hướng dẫn cho thợ bậc dưới về phương pháp công tác và các đều cần biết tối thiểu để làm việc.",
                        "- Đọc được toàn bộ bảng vẽ từ bộ phận lẻ đến bảng vẽ lắp toàn bộ.",
                        "- Nghiên cứu và biến chế các bộ phận máy hư hỏng trong xí nghiệp.",
                        "- Biết phương pháp sử dụng và bảo quản tất cả mọi dụng cụ đo lường.",
                        "- Hiểu được nguyên lý cấu tạo và sử dụng thông thạo các loại dụng cụ đo lường, kiểm tra chính xác 1/100 và can étalon chính xác 5/1000"],
                    8: ["- Hiểu biết thông thạo mọi vấn đề về nghề nguội. Hướng dẫn thợ bậc dưới những hiểu biết nói trên.",
                        "- Chế biến và thay thế các bộ phận máy trong trường hợp khó khăn."]]
        case .miller:
            return [3: ["- Có trình độ thợ nguội bậc 2:",
                        "- Hiểu được cấu tạo của máy mình dùng và bảo quản được tốt.",
                        "- Biết đặc tính sắt, thép và các kim loại thường dùng.",
                        "- Biết 2 kiểu dao thông thường làm rãnh phay mặt phẳng.",
                        "- Đọc được bản vẽ dễ."],
                    4: ["- Có trình độ thợ bậc 3 và thêm:",
                        "- Sơ lược về lý thuyết đúng sai lắp ghép.",
                        "- Đọc được bản vẽ việc mình làm.",
                        "- Biết được đặc tính thép dụng cụ.",
                        "- Biết sử dụng véc-ni-ê (vernier) bàn máy.",
                        "-Tính poup-pê-đi-vi-dơ (poupée diviseur) để chọn đĩa (các phần chia chẵn)."],
                    5: ["- Có trình độ thợ bậc 4 thêm:",
                        "- Biết tên và công dụng các loại dao phay (kể cả dao phay răng).",
                        "- Nắm vững các dấu trên bản vẽ khó vừa.",
                        "- Sơ lược về lý thuyết gọt, cắt.",
                        "- Sơ lược về lý thuyết, về tính và lấy dấu (tracer) bánh xe răng khế phẳng.",
                        "- Đặc tính của thép gió, các-buya.",
                        "- Biết phương pháp gá lắp trên máy đúng quy cách.",
                        "- Biết sơ lược về nhiệt luyện thép dụng cụ, thép gió, sơ lược về đá mài và chọn đá."],
                    6: ["- Có trình độ bậc 5 thêm:",
                        "- Biết được các góc, các loại dao, biết cách bố trí mài đúng quy định.",
                        "- Biết cấu tạo các loại máy phay (đứng, nằm,và vạn năng) (trừ máy phay côn và gléason) và sử dụng được nếu làm tới, dấu đục, dấu lăn crémaillère, bàn chia nằm…",
                        "- Đọc các bản vẽ khó.",
                        "- Biết phép tính toán côn, dùng các bản vẽ tam giác lượng.",
                        "- Biết tính răng côn, chọn dao."],
                    7: ["- Có trình độ bậc 6 thêm:",
                        "- Biết lý thuyết răng chéo, tính được răng chéo (các kích thước).",
                        "- Tính lắp được bánh xe và xoay bàn để phay được răng chéo.",
                        "- Sử dụng thạo các thước đo chính xác 1/100.",
                        "- Nắm vững về đá mài, chọn đá mài dao thích hợp.",
                        "- Áp dụng lý luận gọt cắt, chọn dao, chọn tốc độ, khoảng tiện hợp lý đạt hiệu suất tối đa.",
                        "- Nắm vững các quy định bảng vẽ, đúng sai, lắp ghép.",
                        "- Sử dụng được các máy phay đặc biệt làm răng như phay răng cô-ních-cờ (conique), phay răng bằng dao phờ-re-xơ-me-rơ (frainemère), máy phay 2 đầu máy v.v… (nếu có chỉ dẫn một lần đầu hay được nghiên cứu tìm hiểu).",
                        "- Biết kiểm tra độ chính xác máy như các bệnh của máy ảnh hưởng đến phần công việc.",
                        "- Biết tính chia gần đúng và dùng được pê-đi-vi-đơ (poupée diviseur) có đi-vi-dông đít-phê-răng-xi-en (division différentielle) để chia các răng lẻ không có đĩa chia.",
                        "- Sử dụng các bản lập thành.",
                        "- Biết tính răng xít xăng phanh (vis sans fin) và ru-ơ (roue)."],
                    8: ["- Có trình độ bậc 7 thêm:",
                        "- Có nhiều kinh nghiệm về phay.",
                        "- Nắm vững lý thuyết phay gọt cắt, biết cách áp dụng, sử dụng các đồ đo chính xác 1/100, can è-ta-lông (cale étalon).",
                        "- Tính răng thông thạo (các loại) kiểm tra được bản vẽ.",
                        "- Đặc tính kim loại.",
                        "- Đặc tính thép dụng cụ",
                        "- Đặc tính nhiệt luyện.",
                        "- Mọi phương pháp kiểm tra máy, kiểm nghiệm sản phẩm.",
                        "- Sử dụng thạo các loại máy phay kể cả máy phay đặc biệt làm răng chéo (gléason)."]]
        case .planer:
            return [3: ["- Có trình độ thợ nguội cấp 2.",
                        "- Hiểu rõ được cấu tạo máy mình dùng, biết được công dụng và vận chuyển của từng ổ. Có thể kiểm tra thấy và chỉnh độ của các bộ phận. Biết giữ gìn tra dầu tốt.",
                        "- Biết rõ đặc tính các loại kim khí thường dùng: sắt,thép",
                        "- Sơ lược về thép dụng cụ (thép làm dao).",
                        "- Sử dụng được véc-ni-ê (vernier) của máy."],
                    4: ["- Có trình độ bậc 3 thêm.",
                        "- Biết rõ đặc tính thép dụng cụ (thép nước, thép gió) nắm được nhiệt độ rèn, biết sơ về nhiệt luyện.",
                        "- Sơ lược về kỹ nghệ họa, đúng sai lắp ghép và các dấu dùng trên bản vẽ.",
                        "- Biết sơ lược về máy đục và máy bào giường."],
                    5: ["- Có trình độ bậc 4 thêm:",
                        "- Nắm vững phương pháp gá, lắp đúng quy cách.",
                        "- Nắm vững các dấu trên bảng vẽ khó.",
                        "- Sơ lược về lý thuyết gọt cắt, nắm vững các góc cắt các loại dao, có thể dùng ở các máy bào khác cùng loại hoặc ở máy đúc, bào giường nếu có chỉ dẫn lần đầu.",
                        "- Sử dụng được thước đo độ"],
                    6: ["- Có trình độ thợ bậc 5 thêm:",
                        "- Nắm vững lý thuyết về bào (lý thuyết gọt cắt áp dụng cho việc bào kể cả máy bào giường) cho chạy tự động.",
                        "- Rèn và nhiệt luyện đúng quy định đối với các loại thép làm dụng cụ.",
                        "- Đọc và phân tích bảng vẽ khó"]]
        case .noun:
            return [3: ["- Sơ lược đặc tính các loại kim khí thường làm: sắt, thép, nhiệt độ rèn.",
                        "- Sử dụng than thích hợp cho mỗi công việc.",
                        "- Xem bảng vẽ dễ có kích thước, hiểu được dấu đúng sai.",
                        "- Đo được bằng thước lá com-pa (compas) ngoài."],
                    4: ["- Trình độ hiểu biết bậc 3 thêm:",
                        "- Tính chất các loại kim có thể rèn, nhiệt độ rèn.",
                        "- Nhận được mẫu sắt nướng tương đương với nhiệt độ rèn."],
                    5: ["- Có trình độ bậc 4 thêm:",
                        "- Đọc được bảng vẽ thông thường.",
                        "- Tính được nguyên liệu đầy đủ không lãnh phí.",
                        "- Chuẩn bị các đồ nghề cần thiết cho việc rèn, bộ phận máy dễ hay một sản phẩm nào thông thường.",
                        "- Biết sơ lược cấu tạo và cách điều khiển máy búa, đồ nghề trên máy búa."],
                    6: ["- Có trình độ hiểu biết bậc 5 và thêm:",
                        "- Đọc được bảng vẽ tương đối khó.",
                        "- Ấn định được quá trình công việc, dự kiến mức.",
                        "- Chuẩn bị đồ nghề cho một việc rèn bộ phận tương đối khó."],
                    7: ["- Có trình độ hiểu biết thợ bậc 6 và thêm:",
                        "- Đọc được bảng vẽ khó, phức tạp.",
                        "- Nắm vững đặc tính kim loại - nhiệt độ nướng rèn, ủ non đối với từng loại thép xây dựng và thép dụng cụ.",
                        "- Biết rõ nguyên nhân các bệnh về rèn và tránh được (hãm, nút…)",
                        "- Chữa được các sản phẩm của thợ bậc dưới làm chưa đạt yêu cầu.",
                        "- Đề ra được những ý kiến về đập nóng."],
                    8: ["- Có trình độ thợ bậc 7 và thêm:",
                        "- Có nhiều kinh nghiệm về rèn.",
                        "- Xem và phân tích các bảng vẽ phức tạp, vẽ tay được các đồ nghề để chuẩn bị cho việc rèn.",
                        "- Nắm vững đặc tính thép, sử dụng thép dụng cụ, nhiệt luyện, nhiệt độ rèn nướng.",
                        "- Tính thạo nguyên liệu.",
                        "- Biết và sử dụng được thạo các kiểu lò, kiểu búa, kiểu máy rèn, dập nóng."]]
        case .farrier:
            return [2: ["- Pha át-xít (acide) hàn, biết cách nướng mỏ hàn.",
                        "- Hiểu công dụng các đồ nghề.",
                        "- Lấy dấu được các đồ dùng thông thường như thùng gánh nước."],
                    3: ["- Có trình độ bậc 2 và thêm:",
                        "- Biết sự cấu tạo thông thường và tác dụng của máy cắt tôn, máy đột và máy uốn tôn.",
                        "- Biết phương pháp lấy dấu thông thường để cắt.",
                        "- Biết cách sử dụng một số dụng cụ thông thường về gò.",
                        "- Biết thường thức tính chất kim thuộc thường dùng."],
                    4: ["- Trình độ hiểu biết thợ bậc 3 và thêm:",
                        "- Biết tính chất các loại kim thuộc dùng về gò như tôle, đồng đỏ…",
                        "- Xem bảng vẽ dễ và lấy dấu được những công việc mình làm."],
                    5: ["- Trình độ hiểu biết thợ bậc 4 và thêm:",
                        "- Biết ôn độ cần đốt nóng để gò các loại kim thuộc như sắt, tôle, nhuôm, đồng đỏ v.v…",
                        "- Biết tính toán vật liệu và lấy dấu cắt sắt, tôle để gò 1 đồ vật thông thường không bị thừa thiếu.",
                        "- Xem bảng vẽ và lấy dấu được những công việc mình làm."],
                    6: ["- Trình độ hiểu biết thợ bậc 5 và thêm:",
                        "- Biết sử dụng các loại máy móc về gò và biết đề phòng hiện tượng hư hỏng.",
                        "- Biết tính chất các loại kim thuộc.",
                        "- Biết cải tiến được các dụng cụ về gò.",
                        "- Xem bảng vẽ tương đối khó.",
                        "- Hiểu biết về hình học thông thường."],
                    7: ["- Có trình độ hiểu biết thợ bậc 6 và thêm:",
                        "- Biết lý thuyết phương pháp về gò và có kinh nghiệm trong nghề.",
                        "- Xem và phân tích bảng vẽ khó.",
                        "- Biết một số hình học khó để áp dụng trong việc khai triển về gò các thể tương giao."],
                    8: ["- Trình độ hiểu biết thợ bậc 7 và thêm:",
                        "- Tính và lấy dấu, gò được những công việc lớn, khó như đóng tầu thủy đường sông."]]
        case .welder:
            return [3: ["- Biết sơ qua tính chất của các loại kim thuộc thường dùng.",
                        "- Biết phương pháp hàn thông thường.",
                        "- Biết tác dụng của đồng hồ hơi.",
                        "- Biết phân biệt được các loại que hàn để hàn tùy theo các loại kim khí."],
                    4: ["- Trình độ hiểu biết thợ bậc 3 và thêm:",
                        "- Biết sự co giản của kim thuộc sau khi hàn.",
                        "- Biết phương pháp thí nghiệm sau khi hàn những ống sắt bị sứt nẻ.",
                        "- Biết tính chất nguyên liệu thường dùng.",
                        "- Biết sự cấu tạo thông thường của máy hàn.",
                        "- Biết phương pháp điều chỉnh ngọn lửa để cắt hoặc hàn đồ vật tùy theo dầy mỏng to nhỏ."],
                    5: ["- Trình độ hiểu biết thợ bậc 4 và thêm:",
                        "- Biết phương pháp sửa chữa mỏ hàn và biết cách thức sử dụng các loại mỏ hàn cho thích hợp.",
                        "- Biết sự cấu tạo của máy hàn.",
                        "- Biết phương pháp sử dụng hơi gaz và sức ép cao và biết sức phản ứng của hơi gaz khi hàn.",
                        "- Xem được bảng vẽ dễ.",
                        "- Biết sự co dãn của đồ vật làm và phương pháp sửa chữa những đồ vật bị vênh, cong sau khi hàn xong."],
                    6: ["- Có đủ trình độ hiểu biết thợ bậc 5 và thêm:",
                        "- Biết phương pháp hàn các loại kim thuộc.",
                        "- Biết vẽ công việc nguội thông thường.",
                        "- Biết phương pháp đề phòng để khi hàn đồ vật khỏi bị cong.",
                        "- Biết tính chất của các loại kim khí để khi hàn hoặc cắt các mối không bị bọt và chính xác.",
                        "- Biết qua cách sử dụng các bộ phận máy đem hàn để tránh được sự lãng phí hàn lớn, nhỏ, hoặc cong, co dãn.",
                        "- Xem được bảng vẽ khó."],
                    7: ["- Có trình độ hiểu biết thợ bậc 6 và thêm:",
                        "- Thông thạo lý luận về hàn.",
                        "- Có năng lực cải tiến dụng cụ trong nghề.",
                        "- Xem được bảng vẽ tương đối khó."]]
        case .electricwelder:
            return [3: ["- Biết sử dụng dụng cụ về hàn điện",
                        "- Biết tác dụng và sự nguy hiểm của luồng điện.",
                        "- Biết tên và tác dụng của đồng hồ đo điện (như volmètre, ampèremètre).",
                        "- Biết chọn que hàn tốt xấu để hàn và biết pha trộn thuốc làm que hàn và biết cho chạy máy."],
                    4: ["- Trình độ hiểu biết thợ bậc 3 và thêm:",
                        "- Biết tính chất của que hàn và phương pháp học que hàn.",
                        "- Biết sự cấu tạo thông thường của máy hàn điện.",
                        "- Biết sức co dãn của các đồ vật sau khi hàn.",
                        " - Biết tính chất nguyên vật liệu thường dùng."],
                    5: ["- Có trình độ hiểu biết thợ bậc 4 và thêm:",
                        "- Biết sự co dãn của đồ vật hàn và biết phương pháp sửa chữa những đồ vật bị vênh cong sau khi hàn xong.",
                        "- Xem bản vẽ dễ."],
                    6: ["- Trình độ hiểu biết thợ bậc 5 và thêm:",
                        "- Biết phương pháp hàn nối hai đầu ống với nhau và giữ được độ chếch chính xác.",
                        "- Biết phương pháp sửa chữa máy hàn điện khi bị hư hỏng nhẹ.",
                        "- Biết về nguội bậc 3.",
                        "- Biết đọc bảng vẽ thông thường."],
                    7: ["- Trình độ hiểu biết thợ bậc 6 và thêm:",
                        "- Biết sử dụng được các loại máy hàn điện.",
                        "- Biết tính chất các loại kim thuộc.",
                        "- Xem bảng vẽ khó và phức tạp."]]
        case .carpenter:
            return [4: ["- Biết sử dụng dụng cụ và các máy móc về mộc và biết phương pháp giữ gìn bảo quản máy.",
                        "- Biết phân tích phẩm chất về các thớ gỗ.",
                        "- Biết cách thức giũa lưỡi cưa.",
                        "- Xem bảng vẽ dễ."],
                    5: [ "Trình độ hiểu biết thợ bậc 4 và thêm:",
                         "- Biết phương pháp luộc gỗ, sấy gỗ, phơi gỗ để khi làm khuôn không bị co dãn, hoặc mọt.",
                         "- Xem bảng vẽ thông thường."],
                    6: ["- Trình độ hiểu biết thợ bậc 5 và thêm:",
                        "- Thông thạo việc sử dụng dụng cụ và máy móc làm về đồ mộc.",
                        "- Biết tính chất và sự co dãn của các loại gỗ làm mẫu.",
                        "- Có kinh nghiệm luộc gỗ, sấy gỗ.",
                        "- Xem bảng vẽ tương đối khó."],
                    7: ["- Trình độ hiểu biết thợ bậc 6 và thêm:",
                        "- Biết thông thạo tính chất các loại gỗ để làm mẫu.",
                        "- Xem bảng vẽ khó và phân tích bảng vẽ được nhanh chóng.",
                        "- Biết tính toán độ co dãn của kim khí làm mẫu"],
                    8: ["- Trình độ hiểu biết thợ bậc 7 và thêm:",
                        "- Biết vẽ tay được các bảng vẽ và phân tích nhanh được các bảng vẽ khó, phức tạp.",
                        "- Biết tính toán thông thạo độ co dãn của các loại kim khí để làm mẫu."]]
        case .thone:
            return [
                2: ["- Cách tính liều lượng và yêu cầu kĩ thuật trộn vữa xây trát.",
                    "- Các loại gạch ngói thường dùng xây dựng, phân biệt được tốt, xấu để sử dụng cho hợp lí.",
                    "- Cách làm một số việc đơn giản như: đào móng nhà bình thường, đổ bê tông gạch vỡ, tôi vôi..."],
                3: ["Hiểu biết các công việc của bậc dưới và thêm",
                    "- Các loại rửa, mác vữa trong xây dựng.",
                    "- Phương pháp xây, trát, láng, lát, ốp, hoàn thiện trang trí bề mặt cho các bộ phận của công trình",
                    "- Lắp dựng và tháo dỡ giàn giáo.",
                    "- Phương pháp gia công và lắp đặt một số cấu kiện bê tông đơn giản như dầm đơn, lanh tô, ô văng.",
                    "- Thi công bê tông cho các bộ phận đơn giản.",
                    "- Các tiêu chuẩn đánh giá chất lượng trong công tác xây trát hoàn thiện.",
                    "- Sử dụng và bảo quản vật liệu đúng quy định về đảm bảo yêu cầu kĩ thuật.",
                    "- Các quy phạm kĩ thuật an toàn lao động trong nghề nề, quy định chung trong quy phạm an toàn về xây dựng.",
                    "- Xem được bản vẽ đơn giản và tính tiên lượng công việc của bậc.",
                    "- Một số kĩ thuật và công nghệ mới được ứng dụng trong nghề nề."],
                4: ["Hiểu biết các công việc của bậc dưới và thêm",
                    "— Đọc bản vẽ nhà ở thông thường, tính được khối lượng, nhân công.",
                    "— Biết giác móng nhà ở đến 2 tầng, chuyển nivô (thăng bằng) chuyển tim cốt vào vị trí chính xác để đặt kết cấu hoặc xây.",
                    "— Biết tổ chức quản lý, phân công lao động công việc cho một tốp thợ để thi công nhà ở 1-3 tầng"],
                5: ["Hiểu biết các công việc của bậc dưới và thêm",
                    "- Đọc bản vẽ phần xây dựng, tổ chức quản lý tốt một tổ thợ thi công các loại nhà có yêu cầu cao về các việc thuộc nghề nề đạt chất lượng kĩ thuật, vật tư sử dụng hợp lí, đảm bảo an toàn.",
                    "- Giác móng theo bản vẽ cho các loại nhà ở (không dùng máy trắc đạc) thông thường.",
                    "- Chống thấm bằng bi tum và các loại vật liệu khác theo đúng yêu cầu kĩ thuật.",
                    "- Có biện pháp xử lý, sửa chữa các hư hỏng thông thường thuộc nghề nề (không thuộc về xử lý kết cấu chịu lực)."],
                6: ["Hiểu biết các công việc của bậc dưới và thêm",
                    "- Đọc bản vẽ phần xây dựng và các phần liên quan như nước, điện, phát hiện được sai sót thông thường trong bản vẽ, chỉ dẫn cho thợ bậc dưới làm đúng yêu cầu của thiết kế.",
                    "- Làm mẫu, lấy mực cho các việc nề phức tạp."],
                7: ["Hiểu biết các công việc của bậc dưới và thêm",
                    "- Toàn bộ các công việc, các quy trình công nghệ, tiêu chuẩn đánh giá chất lượng, quy phạm kĩ thuật an toàn lao động trong nghề nề.",
                    "- Thông qua bản vẽ thiết kế, lập biện pháp tổ chức thi công, tự quản lý tổ chức một đội, thi công được các nhà cao tầng (làm các việc thuộc nghề nề và các việc của nghề khác như mộc, sắt, bê tông không đòi hỏi kĩ thuật cao).",
                    "- Phục hồi được những hoa văn, phù điêu, cảnh người và thú, thiên nhiên trên các công trình văn hoá nghệ thuật (có sự hướng dẫn của nghệ nhân chuyên ngành)."]]
        case .betong:
            return [2:["- Dùng vật liệu đúng quy cách, quy trình, theo từng loại bê tông.",
                       "- Phát hiện được vật liệu không đúng quy cách để loại bỏ.",
                       "- Bảo quản bê tông trong lúc làm và sau khi làm (bảo dưỡng)."],
                    3:["Hiểu biết các công việc của bậc dưới và thêm",
                       "- Tính năng tác dụng nguyên lí làm việc của một số máy trộn bê tông thông thường, máy đầm bê tông (đầm dùi, đầm bàn).",
                       "- Biết ngừng đổ bê tông đúng chỗ và đổ tiếp đúng yêu cầu kĩ thuật.",
                       "- Đọc được bản vẽ thông thường. Biết kích thước cao, thấp, rộng, hẹp, liên hệ với các bộ phận (sắt buộc cốp pha) để đảm bảo chất lượng sản phẩm bê tông đúng thiết kế.",
                       "- Các tiêu chuẩn đánh giá chất lượng trong công tác bê tông.",
                       "- Các quy phạm kĩ thuật an toàn trong công tác bê tông, các quy định chung trong quy phạm an toàn về xây dựng.",
                       "- Hiểu được một số yêu cầu kĩ thuật các nghề liên quan như: nề, mộc, sắt."],
                    4:["Hiểu biết các công việc của bậc dưới và thêm",
                       "- Sử dụng các loại vật liệu, (cát, đá, sỏi...) thích hợp với các loại bê tông đúng yêu cầu kĩ thuật...",
                       "- Biết được mác bê tông, liều lượng pha chế, độ sụt...",
                       "- Đọc được bản vẽ không phức tạp của nghề nề và thép.",
                       "- Đọc được bản vẽ bê tông với việc mình phải làm."],
                    5:["Hiểu biết các công việc của bậc dưới và thêm",
                       "- Tổ chức được một dây chuyền đổ bê tông khép kín theo công nghệ trạm trộn, vận chuyển bê tông, đổ bê tông vào công trình bằng phương tiện chuyên dùng đúng kĩ thuật, chất lượng tốt, đảm bảo an toàn."]]
        case .cotthep:
            return [2:["Hiểu biết các công việc của bậc dưới và thêm",
                       "- Biết tên và tác dụng của những dụng cụ làm thép.",
                       "- Biết cắt thép bằng máy.",
                       "- Biết sử dụng tời kéo làm thẳng thép.",
                       "- Phân biệt được các loại thép tròn."],
                    3:["Hiểu biết các công việc của bậc dưới và thêm",
                       "- Phân biệt được thép non già.",
                       "- Biết tính năng, tác dụng của thép tròn, thép hình sử dụng vào việc thích hợp và bảo quản.",
                       "- Sử dụng được các loại dụng cụ như máy uốn, cắt, đột cắt thép tròn và sát hình và phương pháp bảo quản.",
                       "- Xem được bản vẽ thông thường cho công việc mình làm.",
                       "- Các quy phạm kĩ thuật an toàn trong công tác gia công và lắp buộc thép, các quy định chung trong quy phạm an toàn về xây dựng",
                       "- Khái niệm cơ bản về sử dụng máy hàn và hàn hồ quang.",
                       "- Các tiêu chuẩn đánh giá chất lượng trong công tác nghiệm thu sản phẩm về thép.",
                       "- Phân biệt được thép ở vị trí chịu nén, kéo để đặt thép đúng vị trí."],
                    4:["Hiểu biết các công việc của bậc dưới và thêm",
                       "- Sử dụng được máy khoan, máy cắt, máy uốn thép bằng hơi hoặc bằng điện.",
                       "- Biết tính để uốn néo sắt và nối sắt theo thiết kế.",
                       "- Đọc được bản vẽ chi tiết công việc mình làm."],
                    5:["Hiểu biết các công việc của bậc dưới và thêm",
                       "- Đọc được các bản vẽ phức tạp về công tác cốt thép, phát hiện được những sai sót trong bản vẽ và trong thi công có biện pháp giải quyết nhanh.",]]
        case .sonvoi:
            return [2: ["- Phân biệt được các loại sơn thông thường trong xây dựng.",
                        "- Phương pháp gắn các khe hở, trát vá nhỏ đánh bóng, tạo được bề mặt phẳng nhẵn, quét vôi, sơn lót."],
                    3: ["Hiểu biết các công việc của bậc dưới và thêm",
                        "- Sử dụng các loại sơn hợp lí cho từng loại công tác.",
                        "- Phương pháp pha sơn màu.",
                        "- Các quy phạm kĩ thuật an toàn trong công tác sơn vôi, các quy định chung trong quy phạm an toàn về xây dựng.",
                        "- Các tiêu chuẩn đánh giá chất lượng trong công tác sơn vôi."],
                    4: ["Hiểu biết các công việc của bậc dưới và thêm",
                        "- Phương pháp sơn bóng, phương pháp pha chế các loại ma tít.",
                        "- Tự quản lý tổ chức một tổ sản xuất thi công về sơn vôi cho công trình độc lập cỡ vừa và nhỏ.",
                        "- Hiểu tính chất các loại sơn và sử dụng vào từng chỗ đúng kĩ thuật."],
                    5: ["Hiểu biết các công việc của bậc dưới và thêm",
                        "- Kẻ vẽ được các biển quảng cáo đảm bảo kĩ thuật và mĩ thuật.",
                        "- Hoàn thiện bề mặt công trình theo công nghệ bả ma tít, đánh bóng, lăn sơn cho những công trình yêu cầu kĩ thuật mĩ thuật cao đặc biệt.",
                        "- Chỉ dẫn cho thợ bậc dưới làm các việc khó về sơn vôi.",
                        "- Làm được các công việc nghề nề tuơng đương 3/7."]]
        }
    }
    
    public var practice: [Double: [String]] {
        switch self {
        case .water:
            return [1: ["- Lắp đặt và sửa chữa ống nước",
                        "- Lắp đặt và sửa chữa thiết bị nước",
                        "- Kiểm tra và chẩn đoán sự cố",
                        "- Sửa chữa rò rỉ",
                        "- Lắp đặt và bảo dưỡng hệ thống thoát nước"]]
        case .electricity:
            return [1: ["- Lắp đặt và sửa chữa hệ thống cấp điện, bao gồm các ổ cắm, công tắc, bảng điều khiển, và các thành phần khác.",
                        "- Kiểm tra và bảo dưỡng hệ thống điện để đảm bảo hoạt động ổn định.",
                        "- Lắp đặt và sửa chữa các thiết bị điện như đèn, quạt, máy sưởi, và các thiết bị khác.",
                        "- Kiểm tra và đảm bảo thiết bị đạt các tiêu chuẩn an toàn.",
                        "- Kiểm tra hệ thống điện để xác định sự cố và nguyên nhân gây ra vấn đề.", "Chẩn đoán sự cố và đề xuất giải pháp sửa chữa.",
                        "- Lắp đặt và sửa chữa hệ thống chiếu sáng, bao gồm đèn, bóng đèn, và các thiết bị chiếu sáng khác.",
                        "- Đọc và hiểu bản vẽ kỹ thuật điện để thực hiện các công việc lắp đặt và sửa chữa theo đúng yêu cầu.",
                        "- Áp dụng các biện pháp an toàn để ngăn chặn nguy cơ giật điện, cháy nổ, và các rủi ro khác.",
                        "- Liên lạc và hợp tác với các bên liên quan như kiến trúc sư, kỹ sư điện, và các nhà thầu xây dựng khác."]]
        case .refrigeration:
            return [1: ["- Kiểm tra và chẩn đoán lỗi hoạt động của thiết bị điện trong gia đình.",
                        "- Thực hiện các công việc bảo dưỡng định kỳ để giữ cho thiết bị hoạt động trơn tru và kéo dài tuổi thọ.",
                        "- Sửa chữa các lỗi trong hệ thống và thay thế linh kiện hỏng hoặc lỗi.",
                        "- Kiểm tra và xác định linh kiện có thể cần được thay thế.",
                        "- Lắp đặt và cài đặt thiết bị điện mới, như tivi, máy giặt, tủ lạnh, và các thiết bị khác.",
                        "- Kiểm tra và điều chỉnh các thiết bị điện tử để đảm bảo chúng hoạt động đúng cách.",
                        "- Lắp đặt hệ thống điện mới trong những công trình xây dựng hoặc khi có nâng cấp hệ thống."]]
        case .orther:
            return [:]
        case .turner:
            return [2: ["- Gá dao đúng cách trên bàn dao.",
                        "- Mài được dao răng ngoài đúng dáng và góc độ theo chỉ dẫn.",
                        "- Cho máy chạy tự động được.",
                        "- Biết điều chỉnh hãm tự động.",
                        "- Tiện được răng nhọn thường của vít, bu-loong.",
                        "- Gá được bằng la-tô (plateau) 3 vú – 4 vú rà được tròn đạt yêu cầu.",
                        "- Làm được đồ hàng loạt để trên máy tiện như rông-đen (rondelle), chốt chính xác 2/10.",
                        "- Khoan được trên máy và ren được trên máy."],
                    3: ["- Có đủ khả năng bậc 2, thêm:",
                        "- Làm răng nhọn có bu-loong và ê-cu đúng dường và kích thước.",
                        "- Mài được các kiểu dao theo quy định đúng góc (có chỉ dẫn lúc đầu).",
                        "- Tiện được côn thông thường không có lắp ghép.",
                        "- Tiện trơn có lắp ghép với độ chính xác 1/10.",
                        "- Làm được trên các máy khác nếu có chỉ dẫn lúc đầu.",
                        "- Tính và lắp được bánh xe tiện răng chẵn dễ (nếu máy không có hộp số tiện răng)."],
                    4: ["- Có đủ khả năng bậc 3, thêm:",
                        "- Gá tiện các vật tương đối khó như pa-ly-ê, cút-đơ (palier, coudre), v.v…",
                        "- Tiện được loại răng vuông cả ê-cu đúng yêu cầu kỹ thuật.",
                        "- Tiện côn cả ruột lẫn vỏ, loại côn tương đối chính xác như rô-bi-nê (robinet) vòi nước.",
                        "- Đo được chính xác bằng pan-me (palmer) hay thước cặp 1/50.",
                        "- Tiện trơn có lắp ghép chính xác 1/20."],
                    5: ["- Có khả năng thợ bậc 4 và thêm:",
                        "- Tiện trơn lắp ghép chính xác 1/50 các bộ phận hình thù cồng kềnh phức tạp, gá khó như thân bơm nước.",
                        "- Tiện các lỗ, các trục lệch tâm trong đúng sai ấn định.",
                        "- Tiện các loại răng mô-duyn – hình thang, hình tam giác, v.v… có cả ê-cu .",
                        "- Tiện đúng tiết diện, góc độ và độ chính xác, nhẵn sáng yêu cầu.",
                        "- Tiện vít và ê-cu hai đầu răng vuông, ta-rô, phi-li-e (taraud, filière).",
                        "- Đọc được các bảng vẽ khó vừa. Biết phân tích các kích thước quan trọng.",
                        "- Tiện côn dụng cụ (côn morse) cả ruột lẫn vỏ.",
                        "- Gá, lắp và sửa được các bộ phận máy phức tạp như: láng lại lỗ, láng lại mặt, v.v…"],
                    6: ["- Có khả năng thợ bậc 5 và thêm:",
                        "- Tiện trơn lắp ghép chính xác 1/100 (loại đồ kiểm).",
                        "- Gá lắp các bộ phận khó, tiện theo vạch dấu, điều chỉnh theo tay, đo được chính xác theo yêu cầu bảng vẽ. Ví dụ: một bộ phận có một vấu lệch tâm.",
                        "- Bảo đảm đúng sai vị trí loại 5/100 lệch tầm méo - động tác côn, thẳng kẽ v.v… Ví dụ: tiện 1 sơ-mi, xi-lanh (chemise, cylindre) phải bảo đảm lỗ đúng tầm so với vỏ ngoài.",
                        "- Tiện các loại răng nhiều đầu răng. Tiện răng đổ kiểm."],
                    7: ["- Có khả năng bậc 6 và thêm:",
                        "- Tiện được trơn, côn và răng có lắp ghép chính xác 1/100 và nhẵn sáng.",
                        "- Tiện được các dao dáng từ đơn giản đến phức tạp.",
                        "- Tiện các đường kính lệch tâm, chính xác trong đúng sai ấn định.",
                        "- Tiện được bảo đảm các loại răng nhiều dấu, các tiết diện, các cỡ to nhỏ lẻ không hợp với hộp số.",
                        "- Dùng kiểu dao, cho ăn dầy, mỏng, cho máy chạy nhanh, chậm cho tiện hợp lý đúng với sức cắt, đạt hiệu suất cao của dao cắt.",
                        "- Đọc bản vẽ khó, phân tích đầy đủ các kích thước quan trọng."],
                    8: ["- Có nhiều kinh nghiệm và giải quyết được tất cả những khó khăn về kỹ thuật trong nghề tiện hiện nay.",
                        "Nghiên cứu và sử dụng được các loại máy tiện hiện nay."]]
        case .machine:
            return [2: ["- Làm được một “pleque” vuông, ke, nhưng châm chước về mức chính xác."                ,
                        "- Tự chữa lấy được đục bạt, mũi vạch biết mài mũi khoan ruột gà, pointeau và đục rãnh,",
                        "- Rèn bu-loong và ê-cu 15 trở xuống, bảo đảm không cháy răng.",
                        "- Dưới sự chỉ dẫn, làm đồ hàng loạt dễ và không đòi hỏi chính xác."],
                    3: ["- Sửa chữa và tôi được các dụng cụ thông thường như đục bằng, đục rảnh, mũi vạch.",
                        "- Đục, giũa, cưa, ren, răng đúng quy cách.",
                        "- Bảo đảm mặt giũa phẳng và đường đục thẳng (chừng 40, 50 ly)",
                        "- Làm được cờ-la-vét (clavette) đóng chặt 50 ly.",
                        "- Làm được mộng vuông đơn, bảo đảm kích thước đúng sai 1/10.",
                        "- Làm hàng loạt những bộ phận dễ, có kiểm tra kích thước bằng đồ kiểm như giũa, bu-loong, lục lăng, vuông và chìa khóa (clé) thường 1/10",
                        "- Sử dụng được máy bào, máy khoan và biết sử dụng hóc-tắc để bào, chữa.",
                        "- Chữa được lỗ khoan lệch tâm, bào được mặt phẳng."],
                    4: ["- Sửa chữa và tự làm lấy được các dụng cụ đặc biệt vào công việc mình làm." ,
                        "- Làm được mộng mang cá đơn với đúng sai 1/10. Rà được các mặt phẳng làm mộng mang cá vuông chính xác 1/10, rà được mặt quy-lát, bào máp (marbre ) nhỏ.",
                        "- Lấy dấu và chế tạo các bộ phận máy thường theo bảng vẽ như bàn dao.",
                        "- Chế tạo hàng loạt các bộ phận khó thường chính xác 2/10 và kiểm tra bằng ga-ba-ri và ca-líp (gabarít và calibre) như ê-kê (equerre), kim điện v.v…",
                        "- Bào các bộ phận có đường lượn, khoan các lỗ khoan chệch.",
                        "- Làm được ta-rô (taraud), bàn ren",
                        "- Tháo lắp và sửa chữa các loại máy công cụ thông thường, không phức tạp lắm như máy tiện, khoan, bào (trừ các bộ phận khó)."],
                    5: ["- Rà lắp được các ổ máy chính xác 1/20 như băng máy tiện.",
                        "- Làm được đồ kỹ (nhẵn bóng)",
                        "- Làm các bộ phận hàng loạt hình thù phức tạp những ổ cơ cấu đơn giản như : ê-ke (équerre) có mũ, ê-tô phải-ra-len (étau parallèle), kim lồng, bàn dao máy tiện.",
                        "- Làm các đồ kiểm chính xác 1/20",
                        "- Làm các khuôn dẫn các hình khai triển dễ.",
                        "- Có cơ sở căn bản và kinh nghiệm tháo lắp sửa chữa các máy công cụ đơn giản, các trục chuyền v.v…",
                        "- Chia và làm được răng bánh xe thường.",
                        "- Mộng lục lăng."],
                    6: ["- Làm được các bộ phận hàng loạt hình thù phức tạp và cơ cấu phức tạp (Ví dụ: quy-lát súng liên thanh).",
                        "- Làm các dụng cụ đồ kiểm với độ chính xác 2/100.",
                        "- Tháo lắp sửa chữa được tất cả các loại máy công cụ trong xí nghiệp, (loại máy công cụ thông thường, máy hiện đại thì phải có chỉ dẫn).",
                        "- Xem bảng vẽ và lắp được các loại máy hiện đại thuộc loại đơn giản, tìm được phương pháp sử dụng, đề ra được phương pháp bảo quản.",
                        "- Rà, lắp theo bảng vẽ những ổ máy khó đúng yêu cầu kỹ thuật lắp ghép, vận chuyển.",
                        "- Làm được nhẵn mặt gương.",
                        "- Làm được mộng măng cá kép",
                        "- Tôi được các bộ phận chính xác như : đà cứng và tôi rắn."],
                    7: ["- Cải tiến được các đồ nghề dụng cụ đặc biệt để giải đáp yêu cầu của tất cả mọi việc về nguội trong xí nghiệp, như định đoạt mẫu dụng cụ, các góc cắt theo từng kim loại, các đồ gá v.v…",
                        "- Xem bảng vẽ và lắp được các loại máy công cụ hiện đại. Sau khi đã nghiên cứu hoặc được chỉ dẫn biết cách bảo quản giữ gìn, sử dụng được các bảng hướng dẫn.",
                        "- Nhận định những hư hỏng của các loại máy và có biện pháp sửa chữa.",
                        "- Làm những bộ phận hàng loạt phức tạp chính xác 5/1000 và cơ cấu phức tạp.",
                        "- Tìm hiểu và tháo lắp được tất cả các loại máy đặc biệt như turbine v.v…"],
                    8: ["- Hiểu biết thông thạo mọi vấn đề về nghề nguội. Hướng dẫn thợ bậc dưới những hiểu biết nói trên.",
                        "- Chế biến và thay thế các bộ phận máy trong trường hợp khó khăn."]]
        case .miller:
            return [3: ["- Gá các bộ phận để phay mặt, trực tiếp lên bàn hay dùng ê-tô theo vạch dấu ,",
                        "- Phay được mặt phẳng rộng dưới 100x200 hoặc các rãnh ca-vét thẳng ở trục chuyền chính xác 2/10.",
                        "- Rà được dao quạt nhiều lưỡi.",
                        "- Gá được dao trôn.",
                        "- Đo được thước cặp, com-pa ngoài và lỗ chính xác 1/20."],
                    4: ["- Có đủ khả năng bậc 3 thêm",
                        "- Sử dụng được đầu máy chia (poupée diviseur) phay 4 cạnh, lục lăng và chia được số chẵn (không phải chọn đĩa)",
                        "- Gá thẳng trục giữa đầu máy chia.",
                        "- Phay mặt phẳng chính xác 1/10",
                        "- Phay rãnh ca-vét chôn (2 đầu tròn)."],
                    5: ["- Có khả năng thợ bậc 4 thêm:",
                        "- Chọn đĩa, chia các số lẻ, điều chỉnh được tay gạt chia (aliade)",
                        "- Phay được răng thẳng, chọn được số dao, kiểm tra lại, chọn được thước đo răng mô-duyn (module) chính xác 1/100",
                        "- Phay các bộ phận có nhiều bậc khác nhau sát kích thước đúng tới 1/10 (không phải sửa nguội nhiều) dùng véc-ni-ê (vernier) bàn máy và thước đo.",
                        "- Mài các dao phay thông thường trên máy mài riêng.",
                        "- Phay được răng cán-nơ-luya (calnelure) ở trục."],
                    6: ["- Có khả năng bậc 5 thêm :",
                        "- Làm được răng cờ-rê-may-e (crémaillère).",
                        "- Làm được răng pignon conique, răng chéo thẳng.",
                        "- Làm được răng lỗ bằng máy đục, đánh và mài lấy dao.",
                        "- Gá được và phay bộ phận phức tạp nhiều, hố, bậc nhiều kích thước có liên quan tới sát quy định, sửa nguội ít.",
                        "- Khoan, doa các lỗ khoảng cách tâm chính xác 1/10",
                        "- Sử dụng được nhiều dao một lúc, mài các loại dao kể cả dao chính dáng."],
                    7: ["- Có khả năng thợ bậc 6 thêm:",
                        "- Phay các loại răng chéo, chữ V.",
                        "- Mài các loại dao phay khó, sử dụng thạo các kiểu máy mài dao phay. Dùng dao cho chạy máy, dùng tốc độ cắt hợp lý.",
                        "- Đọc bảng vẽ khó, phân tích được trọng điểm cần chú ý trong khi làm.",
                        "- Phay được ru-ơ (roue) và vít xăng phanh (vic sans fin)"],
                    8: ["- Có khả năng thợ bậc 7 và thêm:",
                        "- Giải quyết được mọi khó khăn mắc mứu về vấn đề kỹ thuật phay như gá, lắp khó, giữ đúng vị trí các bề mặt các lỗ, phay chính xác.",
                        "- Phay được răng côn-níc-cờ (conique), chéo lượn, pi-nhông (pignon) và cua-ron đát-ta-cờ (corrone dlattaque) (nếu không có máy riêng)"]]
        case .planer:
            return [3: ["- Sử dụng máy và các phụ tùng thành thạo",
                        "- Biết gá, rà và bào theo vạch dấu các bộ phận khó vừa.",
                        "- Bào các mặt phẳng to vừa, dầy vừa, song hàng tới kìch thước chính xác 0.10.",
                        "- Đọc bảng vẽ đơn giản.",
                        "- Chữa lấy và mài lấy được các kiểu dao.",
                        "- Đọc hiểu được quy trình chế tạo của việc mình và làm đúng."],
                    4: ["- Có khả năng bậc 3 thêm:",
                        "- Gá, rà và bào theo bảng vẽ các bộ phận khó.",
                        "- Bào các mặt phẳng to, chính xác 0.10. Bào các cạnh ke với nhau (không mê) 0.20 dài 100m/m.",
                        "- Đọc được bảng vẽ việc mình làm.",
                        "- Bào được mang cá không có lắp ghép"],
                    5: ["- Có khả năng thợ bậc 4 và thêm:",
                        "- Bào các góc đúng độ, các đường lượn đúng dáng, về gọn không thành bậc",
                        "- Áp dụng tốc độ, khoang tiện hợp lý.",
                        "- Đọc các bản vẽ khó, quy trình chế tạo khó, làm đúng yêu cầu kỹ thuật.",
                        "- Hướng dẫn được thợ mới.",
                        "- Lấy dấu được các bộ phận mình làm",
                        "- Bào mang cá và các mặt phẳng song hàng có lắp ghép, chỉ cần sửa nguội sơ qua."],
                    6: ["- Có khả năng bậc 5 thêm:",
                        "- Có nhiều kinh nghiệm về bào giải quyết được mọi mắc mứu khó khăn trong kỹ thuật bào.",
                        "- Làm thông thạo mọi công việc khó trên các loại máy bào (kể cả máy bào giường) cho chạy tự động"]]
        case .noun:
            return [3: ["- Đánh búa nhịp rèn các bộ phận máy, hay cháy sắt",
                        "- Tốp được sắt tròn 20m/m trở xuống.",
                        "- Rèn các đồ hàng loạt hình trụ đơn giản hay có 2 bậc dài đều nhau trên 50m/m",
                        "- Pha được sắt nguội hay nóng",
                        "- Chữa đục thợ nguội (đục bẹt, đục rãnh)."],
                    4: ["- Có khả năng bậc 3 thêm:",
                        "- Rèn được các bộ phận tiết diện vuông, chữ nhật, bẻ gập đầu góc thẳng ke (équerre, boulon, écrou các loại).",
                        "- Hình bánh giầy, hình trụ 3 bậc, hình bạc rỗng dầy v.v… đinh thuyền, ca-vét có gót.",
                        "- Cháy được sắt thường (nối 2 đầu cùng 1 tiết diện)",
                        "- Đánh búa cái thông thạo (nếu là thợ chuyên môn đánh búa).",
                        "- Sử dụng được búa máy hơi, búa ván để vuốt thép],"],
                    5: ["- Có khả năng bậc 4 và thêm:",
                        "- Rèn hình trụ từ 4, 5 bậc trở lên và dài 55m/m trở xuống đúng yêu cầu kỹ thuật không lệch, các bạc mỏng rộng dài, bạc to rỗng, hình trụ hai bậc ngắn, hình vuông hay chữ nhật nhiều bậc, tay lơ-việc-e (levier) nhỏ có hai đầu to, uốn các thép rèn đúng đường.",
                        "- Sử dụng được máy búa hơi, búa ván và rèn được các bộ phận máy thông thường trên bàn máy."],
                    6: ["- Có khả năng thợ bậc 5 và thêm:",
                        "- Rèn lấy đồ nghề chuẩn bị cho việc rèn của mình",
                        "- Theo bảng vẽ: rèn được các hình:",
                        ". Nhiều bậc, tiết diện khác nhau, (trục cầm, biên nhỏ đầu đặc)",
                        ". Hình U có thêm đuôi (chape)",
                        ". Bạc rỗng nhỏ, dài",
                        ". Hình vuông, chữ nhật có lỗ tròn."],
                    7: ["- Có khả năng thợ bậc 6 và thêm:",
                        "- Theo bảng vẽ rèn các bộ phận từ nhỏ đến lớn, khó, tính phức tạp như : bạc rỗng có nhiều bậc, lơ-việc-e (levier) 3 vấu, trục 2 khuỷu, chầy và cối dập nổi phức tạp có nhiều tiết diện khác nhau nhiều bậc giáp với nhau đồng tâm hay lệch tâm.",
                        "- Sử dụng được máy-rèn và dập nóng các bộ phận dễ (bu-loong, ê-của, ri-ve).",
                        "- Cháy được sắt với thép và cháy hàm ếch ban rộng 100m/m trở lên"],
                    8: ["- Có khả năng thợ bậc 7 và thêm:",
                        "- Giải quyết mọi khó khăn, mắc mứu về kỹ thuật rèn.",
                        "- Chuẩn bị và chỉnh được khuôn mẫu cho máy rèn, dập nóng cho thợ bậc dưới làm"]]
        case .farrier:
            return [2: ["- Gò được thùng gánh nước, viền được vành thùng có lợi.",
                        "- Hàn được thiếc.",
                        "- Sử dụng được máy cắt tôn tay.",
                        "- Dàn được tôn thẳng như tôn mái nhà."],
                    3: ["- Sử dụng được máy cắt tôn, máy khoan, đá mài lửa.",
                        "- Làm được công việc gò thông thường như chậu giặt loe miệng.",
                        "- Đánh được búa cái.",
                        "- Sửa chữa, tôi được dụng cụ thường dùng.",
                        "- Hàn vẩy được các đồ vật dễ thông thường.",
                        "- Sử dụng được dụng cụ đo thông thường.",
                        "- Gò được đờ-mi bu-lơ (demi - boule) đồng đỏ."],
                    4: ["- Có năng lực làm được thợ bậc 3 và thêm:",
                        "- Làm được công việc cắt sắt, tôle, uốn tôle và đột bằng máy.",
                        "- Uốn được coc-ni-e (cornìere) từ 60 ly, ống tuyp (tube) từ 70m/m trở xuống.",
                        "- Biết gò các đồ vật thông thường bằng tôle dầy từ 5 ly trở xuống như gò thùng ga (gaz) máy nổ v.v…",
                        "- Hàn vẩy được rắc-co, mặt bích lệch",
                        "- Gò được tai xe vận tải (garde – boue Monotoba)"],
                    5: ["- Có năng lực thợ bậc 4 và thêm:",
                        "- Gò được tôle dầy từ 5 đến 8 ly, gò hình cône chếch, thẳng (turbulure) gò được ca-bô, ca-lăng, ca-bin (capot, calendre, cabine) xe vận tải.",
                        "- Hàn được vẩy đồng các mối khó.",
                        "- Lấy dấu được vì cầu, vì nhà, tán ri-vê (rivet) ngược, uốn cot-ni-e (cornìere) từ 70m/m trở lên và uốn ống từ 70m/m đến 120m/m."],
                    6: ["- Có năng lực làm thợ bậc 5 và thêm:",
                        "- Co được mặt sàng (plaque turbularie) làm được bệ xe ca (carosserie) chở khách như xe skoda.",
                        "- Hướng dẫn được công tác chuyên môn cho thợ cấp dưới.",
                        "- Lấy dấu khai triển cắt tôle để gò được những đồ vật tương đối khó."],
                    7: ["- Khả năng làm được thợ bậc 6 và thêm:",
                        "- Vẽ được các bộ phận khai triển lấy dấu và gò, nắn lại được tất cả các bộ phận, phụ tùng khó trong toàn bộ đầu máy các bệ xe du lịch lịch khó."],
                    8: ["- Khả năng làm được các công việc khó của bậc 7 và thêm:",
                        "- Giải quyết được mọi khó khăn về kỹ thuật gò.",
                        "- Có nhiều kinh nghiệm trong nghề."]]
        case .welder:
            return [3: ["- Hàn đắp được những bộ phận thông thường tôn dầy từ 2 đến 3 ly.",
                        "- Cho đất vào nồi hàn và điều chỉnh ngọn lửa."],
                    4: ["- Khả năng thợ bậc 3 và thêm:",
                        "- Hàn được những đồ vật thông thường tôn dầy 1 ly kể cả hàn lấp lỗ đồ vật dầy.",
                        "- Cắt tháo được các ống trong nồi sup-de và các bộ phận khó.",
                        "- Sử dụng được các loại que hàn để hàn theo các vật hàn dầy mỏng cho thích hợp."],
                    5: ["- Có đủ khả năng thợ bậc 4 và thêm:",
                        "- Cắt được tôle dầy 20 ly trung bình, hàn được tôle dưới 1 ly",
                        "- Xác định được độ nóng của đồ vật khi cần đốt nóng để hàn và độ nguội dần của đồ vật.",
                        "- Hàn được nồi xúp-de, hàn đứng và hàn các góc trong nồi.",
                        "- Hàn máng trục (cousinet) nứt nẻ, hàn nối 2 đầu ống.",
                        "- Biết chọn lọc các thứ thuốc để hàn.",
                        "- Kiểm tra và sửa chữa máy hàn khi hỏng."],
                    6: ["- Có khả năng thợ bậc 5 và thêm:",
                        "- Biết nung và để nguội dần các loại phụ tùng khi hàn khỏi bị vênh, cong.",
                        "- Hàn được những phụ tùng chịu sức chấn động mạnh và chịu sức nặng nhiều, hàn đắp lông cốt, răng bánh xe, hàn được ngửa những chỗ cần thiết.",
                        "- Hàn được những chỗ phức tạp như nắp quy lát (culasse), xi lanh (cylindre) ô tô, các-te (cartère) dầu v.v…",
                        "- Sửa chữa các bộ phận máy máy hàn khi hư hỏng nhẹ chư chữa mỏ hàn, robinét mỏ hàn, đồng hồ bơi.",
                        "- Hàn nồi tô-le 5-10 ly trở lên.",
                        "- Có kinh nghiệm về hàn.",
                        "- Hàn và được nồi xúp-de các bộ phận trong lò và hàn  được đồ nhôm mỏng."],
                    7: ["- Có đủ khả năng thợ bậc 6 và thêm:",
                        "- Làm được các công việc hàn tất cả những vật khó phức tạp và hàn được bất kỳ ở trường hợp nào (hàn nhanh, tốt, bảo đảm kỹ thuật)",
                        "- Có nhiều kinh nghiệm về hàn."]]
        case .electricwelder:
            return [3: ["- Hàn lấp được chỗ mặt bằng, những chỗ lồi lõm và những chỗ không quan trọng.",
                        "- Tẩy rửa được các mối hàn bị sần sùi.",
                        "- Cho máy chạy và điều chỉnh được luồng điện để hàn."],
                    4: ["- Có năng lực thợ bậc 3 và thêm:",
                        "- Hàn được những đồ vật thông thường (kể cả hàn lấp lỗ được các đồ vật dầy: hàn vành bandage, trục long cốt, pignon, nối chassis ô-tô).",
                        "- Sửa chữa luồng điện khí bị hỏng thường.",
                        "- Hàn được tôn dầy từ 1 ly trở trên."],
                    5: ["- Có năng lực thợ bậc 4 và thêm:",
                        "- Hàn được nồi xúp-de, hàn đứng, hàn ngửa, hàn các góc trong nồi .",
                        "- Hàn được go bandege (boudin) và hàn những sắt có góc (nói chung).",
                        "- Hàn được máng trục (coussinet) bị nứt nẻ và hàn nổi được đầu ống hơi nồi sô-đi-e (chau-dìere)."],
                    6: ["- Có năng lực thợ bậc 5 và thêm:",
                        "- Hàn được những kim thuộc mầu như: đồng, gang, nhôm và biết được sức co dãn của nó.",
                        "- Cắt được sắt, thép bằng hàn điện.",
                        "- Có kinh nghiệm về hàn điện."],
                    7: ["- Có năng lực thợ bậc 6 và thêm:",
                        "- Hàn được bất cứ ở trường hợp nào khó khăn phức tạp.",
                        "- Hàn được những bộ phận phụ tùng tinh vi khó, những bộ phận chấn động và chịu sức nặng nhiều."]]
        case .carpenter:
            return [4: ["- Làm được các mẫu thường như: ghi lò, guốc hãm, đầu ngựa máy tiện (lypre và cheval) coussinét v.v…",
                        "- Ghép gỗ, ghép mộng nối nhau."],
                    5: ["- Khả năng làm được công việc thợ bậc 4 và thêm:",
                        "- Làm được mẫu pa-li-e (palier), bàn dao tiện, vòi nước (robinet), van (vanne) 3 nhánh v.v…"],
                    6: ["- Khả năng làm được thợ bậc 5 và thêm:",
                        "- Làm được các mẫu khó (như bloc cylindre của đầu máy, ống collecteur đầu máy, đầu máy tiện)",
                        "- Sửa chữa chấp vá, cải tiến các mẫu cũ."],
                    7: ["- Khả năng làm được thợ bậc 6 và thêm:",
                        "- Làm được các mẫu khó phức tạp (như bloc culinder của máy bơm gió, máy bơm ACF.1).",
                        "- Hướng dẫn được công việc cho thợ cấp dưới.",
                        "- Có tương đối kinh nghiệm trong nghề."],
                    8: ["- Khả năng làm được công việc thợ bậc 7 và thêm:",
                        "- Có nhiều kinh nghiệm trong nghề.",
                        "- Giải quyết được mọi khó khăn trong ngành.",
                        "- Làm được kế hoạch nhân công nguyên vật liệu trong ban.",
                        "- Làm được tất cả các loại mẫu khó tinh vi, phức tạp để đúc."]]
        case .thone:
            return [2: ["- Xây tường gạch dây từ 11 cm trở lên có bắt mỏ sẵn.",
                        "- Trát tường phẳng, láng nền có mỏ sẵn.",
                        "- Mạng vôi rơm trần nhà, lát lối đi bằng gạch thường, lợp ngói máy có hướng dẫn, bắc giáo thông thường cho nhà 1 tầng, quét vôi nhà phụ tạm."],
                    3: ["Làm được những công việc của cấp dưới và thêm",
                        "- Bắt mỏ để xây các loại tường, xây móng bằng đá hộc có chiều rộng trên 60cm, xây bếp đun củi, đun than có ống khói.",
                        "- Láng nền, trát tường, trần, gờ chỉ đơn giản ở nơi yêu cầu kĩ thuật mĩ thuật bình thường.",
                        "- Lợp ngói, xây trát bờ chẩy, bờ nóc.",
                        "- Dựng các loại cửa thông thường.",
                        "- Bắc giáo xây trát nhà 1-2 tầng.",
                        "- Lát gạch hoa có người bắt mỏ sẵn cho các phòng, nhà thông thường không có yêu cầu về kĩ thuật và mĩ thuật cao.",
                        "- Pha chế vôi mầu đơn giản."],
                    4: ["Làm được những công việc của cấp dưới và thêm",
                        "- Xây trát trụ tròn, vuông chuẩn xác bằng gạch, đá",
                        "- Trát trần, tường bằng vữa xi măng cát, trát vẩy, trát các gờ chỉ, phào thông thường.",
                        "- Trát granito, đá rửa cầu thang, cột, tường, sàn.",
                        "- Pha chế vôi mầu các loại",
                        "- Lát gạch hoa có ghép hình trang trí, ốp dán gạch men, ốp đá đơn giản (không đòi hỏi chọn hoa văn, vân thớ cầu kì).",
                        "- Lợp ngói cho các loại mái.",
                        "- Lắp đặt được các thiết bị vệ sinh thông thường.",
                        "- Gia công lắp buộc các cấu kiện, bằng thép, ghép cốp pha dầm, cột, sàn cho những công trình không đòi hỏi kĩ thuật và độ chính xác cao."],
                    5: ["Làm được những công việc của cấp dưới và thêm",
                        "- Xây tường, xây trụ tròn, vuông bằng gạch để trần không trát.",
                        "- Xây lò hơi, ống khói cao 25m trở xuống theo bản vẽ, xây gạch chịu lửa (cả gia công gạch) ở bộ phận phức tạp.",
                        "- Lắp đặt thiết bị vệ sinh.",
                        "- Pha chế mầu và trát granito có kẻ ô hoặc xen hoa văn trang trí, trát granitin chuẩn xác.",
                        "- Làm ban công, ô văng có đường cong, trát các loại gờ chỉ, phào phức tạp.",
                        "- Hoàn thiện nhà bằng công nghệ bả matít, mài và lăn sơn theo các mẫu.",
                        "- Đánh nivô, bố trí hoa văn, bắt mỏ lát gạch hoa các mầu, ốp đá, gạch men cho công trình có yêu cầu kĩ thuật cao.",
                        "- Gia công và ốp các loại gạch đá trang trí cho cột, mặt tường, đắp chữ lồi lõm đảm bảo kĩ mĩ thuật.",
                        "- Chống thấm mái và các khu vệ sinh, xử lý chống thấm dột đúng yêu cầu kĩ thuật."],
                    6: ["Làm được những công việc của cấp dưới và thêm",
                        "- Ốp lát các loại gạch đá cao cấp, trát gờ, chỉ, phào phức tạp cho các công trình nghệ thuật, đặc biệt.",
                        "- Đắp mô hình, phù điêu, hoa văn trang trí, gia công đúc sẵn các hoa văn để dán vào công trình.",
                        "- Kiểm tra được kích thước, tim cốt của những công trình phức tạp để thi công đúng thiết kế.",
                        "- Lấy mực, xây ống khói cao trên 25m, xây cầu thang xoắn ốc, xây trụ, ra gờ của các công trình có hình dạng đặc biệt và phức tạp."],
                    7: ["Làm được những công việc của cấp dưới và thêm",
                        "- Toàn bộ các công việc, các quy trình công nghệ, tiêu chuẩn đánh giá chất lượng, quy phạm kĩ thuật an toàn lao động trong nghề nề.",
                        "- Thông qua bản vẽ thiết kế, lập biện pháp tổ chức thi công, tự quản lý tổ chức một đội, thi công được các nhà cao tầng (làm các việc thuộc nghề nề và các việc của nghề khác như mộc, sắt, bê tông không đòi hỏi kĩ thuật cao).",
                        "- Phục hồi được những hoa văn, phù điêu, cảnh người và thú, thiên nhiên trên các công trình văn hoá nghệ thuật (có sự hướng dẫn của nghệ nhân chuyên ngành)."]]
        case .betong:
            return [2:["- Trộn, đổ và đầm bê tông bằng tay (hoặc bằng máy có hướng dẫn). San bê tông các loại công trình thông thường như: móng, nền, sàn, cột... đúng kích thước và quy cách kĩ thuật, đảm bảo an toàn.",
                       "- Tháo lắp được cốp pha bê tông đúc sẵn."],
                    3:["Làm được những công việc của cấp dưới và thêm",
                       "- Đổ bê tông móng công trình, bệ máy có chừa chân bu lông, bê tông máng nước, đài nước.",
                       "- Sử dụng thành thạo đầm dùi, đầm bàn để đầm bê tông đảm bảo chất lượng."],
                    4:["Làm được những công việc của cấp dưới và thêm",
                       "- Đúc được các mẫu thử bê tông theo đúng quy định.",
                       "- Phát hiện được những sai lầm về liều lượng pha chế, về mác bê tông, về đổ và đầm bê tông.",
                       "- Phát hiện được sai sót của cốp pha, cốt thép."],
                    5:["Làm được những công việc của cấp dưới và thêm",
                       "- Đổ bê tông theo công nghệ làm nhẵn bề mặt không trát, đúng yêu cầu kĩ thuật, mĩ thuật.",
                       "Làm được một số công việc của nghề liên quan:",
                       "+ Đối với nghề nề: xây, trát các bộ phận thông thường không yêu cầu cao về kĩ thuật.",
                       "+ Đối với mộc: Lắp ghép và tháo dỡ cốp pha gỗ và kim loại (đối với công trình yêu cầu kĩ thuật không cao, kết cấu không phức tạp).",
                       "+ Đối với thép: Hiểu và làm được tương đương thợ sắt bậc 3 (trừ các việc liên quan đến thép hình)."]]
            
        case .cotthep:
            return [2:["- Quai được búa từ 3 - 6 kg chính xác.",
                       "- Lấy được dấu làm cọc để uốn thép đai vuông, vai bò mỏ thép đến đường kính 15mm đúng kích thước bản vẽ thi công.",
                       "- Chia khoảng cách để rải thép lanh tô, ô văng, cột, dầm sàn thông thường, buộc và lắp vào vị trí theo bản vẽ thiết kế (có hướng dẫn).",
                       "- Rửa và mài một số dụng cụ thông thường như (đục, chạm) làm được vam để uốn thép đường kính dưới 15 mm.",
                       "- Đánh được bật cửa, chặt được thép tròn, thép hình, đục lỗ có dấu sẵn."],
                    3:["Làm được những công việc của cấp dưới và thêm",
                       "- Tự chế các loại đồ dùng theo công việc của mình, gia công được bản lề goong và bản lề lá.",
                       "- Rải buộc, lắp dựng được cốt thép cột, xà dầm sàn thông thường.",
                       "- Lấy được mức dấu, đục được các lỗ tròn, vuông chính xác bằng tay.",
                       "- Làm được cửa hoa bằng thép tròn, dẹt theo đúng bản vẽ thiết kế.",
                       "- Hàn điện thông thường (hàn đính, hàn liên kết)."],
                    4:["Làm được những công việc của cấp dưới và thêm",
                       "- Rải và buộc sắt cột, dầm, sàn, cầu thang, máng nước, bệ máy thông thường theo thiết kế.",
                       "- Lấy mực làm vì kèo sắt thông thường, sản xuất được cốp pha tôn định hình, các loại gông thép, bu lông phục vụ cho công tác lắp cốp pha tôn.",
                       "- Làm cổng sắt, cửa hoa bằng thép hình, bằng ống nước có hoa văn kiểu cách phức tạp."],
                    5:["Làm được những công việc của cấp dưới và thêm",
                       "- Lấy mực để làm và hướng dẫn bậc dưới làm các loại vì kèo bằng sắt tròn, sắt hình phức tạp (vì kèo có quá giang uốn cong).",
                       "- Làm sắt cầu thang các kiểu, cốt sắt bể ngầm, bể lọc, bệ máy phức tạp",
                       "- Làm được các sản phẩm từ vật liệu nhôm như cửa, tủ...",
                       "- Làm được giàn giáo thép theo đúng yêu cầu của thiết kế.",
                       "- Làm được các công việc của nghề mộc, nề tương đương bậc 2."]]
        case .sonvoi:
            return [2:["- Pha được các loại sơn lót, matít theo công thức có hướng dẫn, pha chế các mầu thông thường để quét.",
                       "- Quét sơn đường ống, các loại cửa gỗ, quét vôi màu tường cho những công trình yêu cầu kĩ thuật bình thường."],
                    3:["Làm được những công việc của cấp dưới và thêm",
                       "- Pha chế được các mầu vôi, màu sơn theo yêu cầu, điều chỉnh được màu đậm nhạt, chấm kính mờ.",
                       "- Sơn được các cấu kiện kim loại, các loại cửa gỗ theo các màu.",
                       "- Kẻ được chữ và tô màu theo mẫu bảo đảm kĩ thuật.",
                       "- Quét được vôi trần, vôi màu cho những chỗ phào, gờ chỉ.",
                       "- Kẻ được chỉ thẳng to từ 5 mm trở lên.",
                       "- Biết nhuộm gỗ và đánh được véc ni.",
                       "- Làm được vôi dập, vôi quay, kẻ giả gạch xây.",
                       "- Pha chế được ma tít theo công thức.",
                       "- Hoàn thiện nhà bằng công nghệ bả ma tít, mài và lăn sơn."],
                    4:["Làm được những công việc của cấp dưới và thêm",
                       "- Kẻ được chỉ nhỏ dưới 5 mm, kẻ được đường cong.",
                       "- Kẻ được chữ số và các kiểu hoa.",
                       "- Pha chế các màu sơn, vôi quay, vôi cồn theo yêu cầu.",
                       "- Làm được vân giả mày đá, sơn xì.",
                       "- Sửa chữa được những chỗ quét sơn, quét vôi mới và cũ đồng màu chính xác.",
                       "- Làm được các công việc của nghề nề tương đương bậc 2/7."],
                    5:["Làm được những công việc của cấp dưới và thêm",
                       "- Kẻ vẽ được các biển quảng cáo đảm bảo kĩ thuật và mĩ thuật.",
                       "- Hoàn thiện bề mặt công trình theo công nghệ bả ma tít, đánh bóng, lăn sơn cho những công trình yêu cầu kĩ thuật mĩ thuật cao đặc biệt.",
                       "- Chỉ dẫn cho thợ bậc dưới làm các việc khó về sơn vôi.",
                       "- Làm được các công việc nghề nề tuơng đương 3/7."]]
        }
    }
}

public struct Job: DomainModel {
    public private(set) var id: Int = 0
    public private(set) var code: String = ""
    public private(set) var name: String = ""
    public private(set) var type: JobValue = .orther
    
    public init() {}
    
    public init(id: Int,
                code: String,
                name: String,
                type: JobValue ) {
        self.id = id
        self.code = code
        self.name = name
        self.type = type
    }
}
