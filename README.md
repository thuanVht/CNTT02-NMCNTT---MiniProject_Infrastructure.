# Hệ thống quản trị hạ tầng GreenTech

Hệ thống tự động lọc nhật ký (log) lỗi nghiêm trọng từ server và quản lý danh mục phần cứng của 100 trạm cảm biến IoT. Tài liệu này hướng dẫn nhân viên mới chạy hệ thống mà không cần hỏi lại.

## Cấu trúc thư mục

```text
greentech-system/
├── docs/      README.md, srs-he-thong.docx, huong-dan-su-dung.md
├── scripts/   auto_report.bat
├── data/      log-he-thong.log, quan-ly-thiet-bi.xlsx, bang-thoi-gian-tai-log.xlsx
├── backup/    bao-cao-su-co.txt (do script tự sinh)
├── .env.example  (mẫu cấu hình, không chứa mật khẩu thật)
├── .gitignore    (chặn .env)
└── .env       (không có trên GitHub, xem mục Cài đặt)
```

## Yêu cầu

- Windows với CMD hoặc PowerShell (script `.bat` dùng lệnh `findstr`)
- Git
- Microsoft Excel để mở `data/quan-ly-thiet-bi.xlsx`

## Cài đặt

```bat
git clone <duong-dan-repo-greentech-system>
cd greentech-system
```

Tệp `.env` chứa thông tin nhạy cảm nên **không** được đưa lên GitHub. Hãy xin tệp này từ nhóm trưởng (Quốc Anh) hoặc sao chép từ tệp mẫu rồi điền giá trị thật:

```bat
copy .env.example .env
```

Thư mục `backup` đã có sẵn trong repo (tệp `.gitkeep`). Nếu bị thiếu, script sẽ tự tạo lại khi chạy.

## Cách chạy script lọc log

Chạy script từ thư mục gốc `greentech-system`. Script tự chuyển về thư mục gốc nên chạy từ `scripts\` hoặc nhấp đúp vào tệp cũng được:

```bat
cd greentech-system
scripts\auto_report.bat
```

Script sẽ lọc các dòng có mức `[CRITICAL]` và `[ERROR]` (gồm cả lỗi 404 và TIMEOUT) từ `data\log-he-thong.log` và ghi nối vào `backup\bao-cao-su-co.txt`. Mỗi lần chạy thêm một khối mới kèm ngày giờ, báo cáo cũ không bị ghi đè.

Kiểm tra kết quả:

```bat
type backup\bao-cao-su-co.txt
```

## Checklist kiểm tra thiết bị

- [ ] Kiểm tra kết nối cảm biến
- [ ] Kiểm tra dung lượng RAM còn trống
- [ ] Chạy `scripts\auto_report.bat` và mở báo cáo trong `backup/`
- [ ] Sao lưu báo cáo vào `backup/`
- [ ] Kiểm tra bảng `quan-ly-thiet-bi.xlsx` không còn lỗi `#N/A`

## Thông số phần cứng

Danh mục linh kiện lấy từ sheet `danh-muc-linh-kien` trong `data/quan-ly-thiet-bi.xlsx`:

| Mã linh kiện | Tên thiết bị | Đơn giá (VND) | Loại lưu trữ |
|--------------|--------------|---------------|--------------|
| CPU-INTEL-01 | CPU Intel Core i5 | 1.500.000 | Không |
| CPU-AMD-01 | CPU AMD Ryzen 5 | 1.600.000 | Không |
| RAM-16G-01 | RAM 16GB DDR4 | 450.000 | Không |
| RAM-32G-01 | RAM 32GB DDR4 | 850.000 | Không |
| SSD-500G-01 | SSD 500GB NVMe | 600.000 | SSD |
| HDD-2TB-01 | HDD 2TB SATA | 550.000 | HDD |

Trạng thái 100 trạm (`tram-01` đến `tram-100`) nằm ở sheet `trang-thai-tram`. Cột `ten_thiet_bi` tự điền bằng `VLOOKUP(TRIM(...))`.

## Tài liệu liên quan

- [Hướng dẫn sử dụng](huong-dan-su-dung.md): các bước làm việc hằng ngày và cách xử lý lỗi thường gặp.
- `docs/srs-he-thong.docx`: tài liệu đặc tả đầy đủ (mô hình IPO/DIKW, 4 module, các bẫy dữ liệu).
- `data/bang-thoi-gian-tai-log.xlsx`: bảng ước lượng thời gian tải log theo tốc độ mạng (Mbps chia 8 ra MB/s).

## Quy tắc chung

- Tên thư mục và tệp theo kebab-case, không dấu, không khoảng trắng.
- Chỉ dùng đường dẫn tương đối, không dùng kiểu `C:\Users\...`.
- Khi ghi log luôn dùng `>>`, không dùng `>`.
- Không commit tệp `.env`.
- Tệp `.docx` và `.xlsx` không merge được trên Git, mỗi tệp chỉ một người sửa.

## Nhóm thực hiện

Nhóm trưởng: Quốc Anh · Nhóm phó: Bách · Thành viên: Anh Khiêm, Tấn Khiêm, Bảo, Thuận, Thu.
