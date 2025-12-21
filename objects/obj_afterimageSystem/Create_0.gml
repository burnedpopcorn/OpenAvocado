afterimages = ds_list_create();
depth = 15;
uniformLight = shader_get_uniform(shd_fullshade, "lightest");
uniformDark = shader_get_uniform(shd_fullshade, "darkest");

enum AfterImage
{
	Mach3 = 0,
	Blur = 1,
	UNUSED1 = 2,
	UNUSED2 = 3,
	BuzzSaw = 4,
}