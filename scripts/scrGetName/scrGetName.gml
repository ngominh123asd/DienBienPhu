function scrGetName(){

    var Ho = choose(
        "Nguyễn",
        "Trần",
        "Lê",
        "Phạm",
        "Hoàng",
        "Võ",
        "Vũ",
        "Đặng",
        "Bùi",
        "Đỗ"
    );

    var TenDem = choose(
        "Minh",
        "Gia",
        "Quốc",
        "Thanh",
        "Đức",
        "Ngọc",
        "Bảo",
        "Anh",
        "Tiến",
        "Hữu"
    );

    var Ten = choose(
        "Huy",
        "An",
        "Khánh",
        "Linh",
        "Vy",
        "Quân",
        "Đạt",
        "Phúc",
        "Trang",
        "Khoa",
        "Long",
        "Nhi"
    );

    return Ho + " " + TenDem + " " + Ten;
}