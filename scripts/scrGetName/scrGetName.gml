function scrGetName(){
    var base_name = choose(
        "Trần Can",
        "Dương Quảng Châu",
        "Dương Ngọc Chiến",
        "Bùi Đình Cư",
        "Tô Vĩnh Diện",
        "Hoàng Khắc Dược",
        "Bế Văn Đàn",
        "Phan Đình Giót",
        "Đặng Đình Hồ",
        "Trần Đình Hùng",
        "Phùng Văn Khầu",
        "Chu Văn Khâm",
        "Tạ Quốc Luật",
        "Đinh Văn Mẫu",
        "Chu Văn Mùi",
        "Hà Văn Nọa",
        "Hoàng Văn Nô",
        "Đặng Đức Song",
        "Nguyễn Văn Ty",
        "Phan Tư",
        "Nguyễn Văn Thuần",
        "Lâm Viết Hữu",
        "Lê Văn Dỵ"
    );
    
    var num = irandom_range(1, 99);
    var num_str = string(num);
    if (num < 10) {
        num_str = "0" + num_str;
    }
    
    return base_name + " #" + num_str;
}