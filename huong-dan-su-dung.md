# Hướng dẫn sử dụng hệ thống GreenTech

Tài liệu này dành cho nhân viên mới. Làm lần lượt từ mục 1 đến mục 4 là chạy được toàn bộ hệ thống.

## 1. Chuẩn bị (làm một lần)

| Bước | Việc cần làm | Lệnh hoặc thao tác |
|---|---|---|
| 1 | Cài Git và Microsoft Excel | Tải Git từ trang chủ, cài Excel theo máy công ty |
| 2 | Tải dự án về máy | `git clone <link-repo>` rồi `cd greentech-system` |
| 3 | Tạo tệp cấu hình `.env` | `copy .env.example .env`, sau đó mở `.env` điền giá trị thật |
| 4 | Kiểm tra cây thư mục | `dir` phải thấy `docs`, `scripts`, `data`, `backup` |

> `.env` chứa mật khẩu nên không có trên GitHub. Nếu cần giá trị thật, hỏi nhóm trưởng (Quốc Anh).

## 2. Công việc hằng ngày

| Việc | Cách làm | Kết quả |
|---|---|---|
| Lọc lỗi nghiêm trọng từ log | Mở CMD tại `greentech-system`, chạy `scripts\auto_report.bat` | Báo cáo ghi nối vào `backup\bao-cao-su-co.txt` |
| Đọc báo cáo sự cố | `type backup\bao-cao-su-co.txt` | Danh sách dòng `[CRITICAL]` và `[ERROR]` kèm ngày giờ chạy |
| Tra thông tin thiết bị của trạm | Mở `data\quan-ly-thiet-bi.xlsx`, sheet `trang-thai-tram`, lọc theo `ma_tram` | Cột `ten_thiet_bi` tự hiện tên linh kiện |
| Ước lượng thời gian tải log | Mở `data\bang-thoi-gian-tai-log.xlsx`, đổi ô màu vàng | Bảng tự tính lại (Mbps chia 8 ra MB/s) |
| Sao lưu báo cáo | Chép `backup\bao-cao-su-co.txt` sang nơi lưu trữ của công ty | Có bản dự phòng |

## 3. Cách đọc báo cáo

Mỗi lần chạy script thêm một khối mới vào cuối `bao-cao-su-co.txt`, khối cũ giữ nguyên:

```text
================================================
BAO CAO SU CO GREENTECH - <ngay> <gio>
================================================
2026-10-27 00:00:00.090 [ERROR] sensor-gw-02 TIMEOUT sau 30000ms khi goi tram ST-062
2026-10-27 00:00:00.569 [CRITICAL] db-01 Dung luong dia con 4%, sap day
...
```

| Mức | Ý nghĩa | Nên làm gì |
|---|---|---|
| `[CRITICAL]` | Sự cố nghiêm trọng (đầy ổ đĩa, mất kết nối trạm) | Xử lý ngay, báo quản lý |
| `[ERROR]` kèm `404` | Truy cập tài nguyên không tồn tại | Kiểm tra đường dẫn, tài nguyên bị xóa |
| `[ERROR]` kèm `TIMEOUT` | Trạm hoặc gateway không phản hồi | Kiểm tra kết nối, tra trạm trong Excel để biết thiết bị |

Ví dụ tra trạm: log báo `ST-062`, tìm trạm đó trong sheet `trang-thai-tram` để biết thiết bị lắp tại trạm.

## 4. Xử lý lỗi thường gặp

| Hiện tượng | Nguyên nhân | Cách xử lý |
|---|---|---|
| In `[LOI] Khong tim thay data\log-he-thong.log` | Chưa có tệp log hoặc sai tên | Kiểm tra tệp nằm trong `data\` và tên đúng `log-he-thong.log` |
| Báo cáo không thêm dòng mới | Log chưa có dòng `[CRITICAL]` hoặc `[ERROR]` mới | Kiểm tra log bằng `findstr /c:"[ERROR]" data\log-he-thong.log` |
| Chữ trong CMD bị lỗi dấu | Script cố ý viết không dấu | Bình thường, không cần xử lý |
| Cột `ten_thiet_bi` hiện `#N/A` | Mã linh kiện không có trong `danh-muc-linh-kien` hoặc gõ sai | Sửa mã ở cột `ma_linh_kien`; khoảng trắng thừa đã được `TRIM` xử lý |
| Không push được `.env` | Đúng thiết kế, `.env` nằm trong `.gitignore` | Không cần xử lý, không đưa `.env` lên GitHub |
| Mở `.docx` hoặc `.xlsx` bị xung đột khi merge Git | Hai người cùng sửa một tệp | Mỗi tệp chỉ một người sửa (SRS: Thu; Excel: Tấn Khiêm) |

## 5. Quy tắc cần nhớ

- Tên thư mục và tệp theo kebab-case, không dấu, không khoảng trắng.
- Chỉ dùng đường dẫn tương đối, không dùng kiểu `C:\Users\...`.
- Ghi log luôn dùng `>>`, không dùng `>` (tránh mất báo cáo cũ).
- Không thêm lệnh xóa vào script khi chưa có bước xác nhận.
- Không dùng Merge Cell hoặc hàng trống trong vùng dữ liệu Excel.

## 6. Ai phụ trách phần nào

| Thành viên | Phần phụ trách |
|---|---|
| Quốc Anh (nhóm trưởng) | Cây thư mục, `.env`, repo GitHub, nộp bài |
| Bách (nhóm phó) | `scripts/auto_report.bat` |
| Anh Khiêm | Log mẫu, test script, Output mẫu |
| Tấn Khiêm | `data/quan-ly-thiet-bi.xlsx` |
| Bảo | Dữ liệu 100 trạm, thiết kế cơ sở dữ liệu (SRS mục 4) |
| Thuận | `docs/README.md`, SRS mục 2, 3, 8 |
| Thu | `docs/srs-he-thong.docx` |
