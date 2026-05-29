/// @description Init

ShowText = 1;

var Minutes = floor(oCont_Room.TimePlayed / 60 / 60);
var Seconds = floor(oCont_Room.TimePlayed / 60) - (Minutes * 60);
		
if Minutes < 10 { Minutes = "0" + string(Minutes); }
if Seconds < 10 { Seconds = "0" + string(Seconds); }
		
var PlayedString = string(Minutes) + ":" + string(Seconds);
		
Text = "Ngày 7 tháng 5 năm 1954, quân ta giành thắng lợi quyết định tại Điện Biên Phủ. Lá cờ chiến thắng tung bay trên nóc hầm chỉ huy địch, khép lại 56 ngày đêm chiến đấu anh dũng.\n\nThời gian hoàn thành: " + string(PlayedString) + "\n\nNhấn Enter để về màn hình chính.";