/// @description Zoom in

if ZoomFactor > 0.5{
	ZoomFactor -= .05;
}

//Reset camera
var vm = matrix_build_lookat(x,y,1,x,y,10,0,1,0)
var pm = matrix_build_projection_ortho(CamInitW * ZoomFactor,CamInitH * ZoomFactor,-2600,2600)

camera_set_view_mat(Camera,vm);
camera_set_proj_mat(Camera,pm);	