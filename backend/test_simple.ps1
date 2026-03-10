# Test Order + Payment
$BASE_URL = "http://localhost:3000"

# 1. Get menu
Write-Host "`n=== STEP 1: Get Menu ===" -ForegroundColor Cyan
$menusRes = Invoke-RestMethod -Uri "$BASE_URL/api/menu" -Method Get
$menus = $menusRes.data
Write-Host "Found $($menus.Count) items"
Write-Host "Mon 1: $($menus[0].tenMon) - $($menus[0].gia)k"
Write-Host "Mon 2: $($menus[1].tenMon) - $($menus[1].gia)k"

# 2. Create Order
Write-Host "`n=== STEP 2: Create Order ===" -ForegroundColor Cyan
$orderData = @{
    soBan = 5
    danhSachMon = @(
        @{ monAn = $menus[0]._id; soLuong = 2; ghiChuDacBiet = "Không cay" }
        @{ monAn = $menus[1]._id; soLuong = 1; ghiChuDacBiet = "" }
    )
} | ConvertTo-Json -Depth 5

Write-Host "Request data:"
Write-Host $orderData

$createRes = Invoke-RestMethod -Uri "$BASE_URL/api/orders" -Method Post -Body $orderData -ContentType "application/json"
$order = $createRes.data
$orderId = $order._id

Write-Host "✅ Order created:"
Write-Host "  ID: $orderId"
Write-Host "  Status: $($order.trangThai)"
Write-Host "  Total: $($order.tongTien)đ"

# 3. Update Status Flow
$statusFlow = @(
    "da_xac_nhan",
    "dang_che_bien",
    "bep_hoan_tat",
    "da_giao_mon",
    "yeu_cau_thanh_toan",
    "hoan_tat"
)

foreach ($status in $statusFlow) {
    Start-Sleep -Milliseconds 500
    Write-Host "`n=== Update to: $status ===" -ForegroundColor Yellow
    
    $updateData = @{ trangThai = $status } | ConvertTo-Json
    $updateRes = Invoke-RestMethod -Uri "$BASE_URL/api/staff/orders/$orderId/status" -Method Patch -Body $updateData -ContentType "application/json"
    
    Write-Host "✅ Status updated: $($updateRes.data.trangThai)"
}

Write-Host "`n=== ✅ TEST COMPLETE ===" -ForegroundColor Green
