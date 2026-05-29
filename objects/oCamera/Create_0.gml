/// @description Init

Camera = camera_create();

ZoomFactor = 2;
CamInitW = 160;
CamInitH = 90;

//Max depth -2500,2500

var vm = matrix_build_lookat(x,y,1,x,y,10,0,1,0)
var pm = matrix_build_projection_ortho(CamInitW * ZoomFactor, CamInitH * ZoomFactor, -2600, 2600)

camera_set_view_mat(Camera,vm);
camera_set_proj_mat(Camera,pm);

view_camera[0] = Camera;

xTo = x;
yTo = y;

DestX = x;  
DestY = y;