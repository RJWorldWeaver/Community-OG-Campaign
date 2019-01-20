class AnmReg{
	AnmReg(){}
	AnmReg(string name,string path, string previewpath = ""){
		Name = name.isEmpty() ? path.substr(path.findLast("_")+1,(path.length()-4)-(path.findLast("_")+1)): name;
		Path = path.substr(0,4) == "Data" ? path : "Data/Animations/"+path;
		Previewimagepath = previewpath.isEmpty() ? "Data/images/COGC2018/MNG_Dialogue/loadpreview.png" : previewpath;
	}
	string Name;
	string Path;
	string Previewimagepath;
}

array<AnmReg> Anms = {
	AnmReg("","r_dialogue_thoughtful.anm","Data/images/COGC2018/MNG_Dialogue/Anm-Preview/thoughtful.png"),
	AnmReg("Arms crossed","r_dialogue_armcross.anm","Data/images/COGC2018/MNG_Dialogue/Anm-Preview/Armcross.png"),
	AnmReg("Facepalm","r_dialogue_facepalm.anm","Data/images/COGC2018/MNG_Dialogue/Anm-Preview/Facepalm.png"),
	AnmReg("","r_dialogue_welcome.anm",""),
	AnmReg("","Data/Animations/r_dialogue_handneck.anm","")
	/* AnmReg("","","");
	AnmReg("","","");
	AnmReg("","","");
	AnmReg("","",""); */
};

/* array<string> MorphKeys = {
"sad",
"anger",
"nervous"
}; */
