//MNGMNGMNG no ascii shrek this time
//declare variables: "Hey, Computer, there are these variables and they store this kind of data"
float lvlHDRWPt;
float lvlHDRBPt;
float lvlBloomMult;
vec3  lvlSunPos;
vec3  lvlSunTint;
float lvlSunAmbient;
vec3  lvlSkyTint;
float lvlSaturation;
float lvlFog;
float lvlSkyBrightness;

ScriptParams@ lvlParams;

//in this case, we immediately tell the computer the actual data those variables store.
bool inside = false;
bool enabled = true;
bool init = true;

//this function gets called when an "event" happens (e.g. "enter" or "exit" of a movement object (a character))
//the function receives two arguments: a string stating which event just happened and a handle to 
//the movement object that caused the event to happen
void HandleEvent(string event, MovementObject @mo){
	
	//we set the "inside" variable based on if the event is "enter" or "exit"
    if(mo.controlled && event == "enter"){
        inside = true;
    } else if(mo.controlled && event == "exit"){
        inside = false;
    }
//end of function declaration
}

//resets "inside" on levelreset
void Reset(){
	if(params.GetInt("Reset on reset") == 1){
		inside = false;
	}
}

//receiving messages for enabling via dialogue
void ReceiveMessage(string msg){
	if(msg == "enable"){
		enabled = true;
	}else if(msg == "trigger"){
		inside = true;
	}else if(msg == "detrigger"){
		inside = false;
	}
}

float MixParam;
vec3 SunPosPar;
vec3 SunTintPar;
vec3 SkyTintPar;
//called every 30th of a second iirc
void Draw(){
	if(init){
		init = false;
			
		//...It should assign some data to those variables (the data returned by those functions)
		@lvlParams = level.GetScriptParams();
		
		lvlHDRWPt = GetHDRWhitePoint();
		lvlHDRBPt = GetHDRBlackPoint();
		lvlBloomMult = GetHDRBloomMult();
		lvlSunPos = GetSunPosition();
		lvlSunTint	= GetSunColor();
		lvlSunAmbient = GetSunAmbient();
		lvlSkyTint	= GetSkyTint();
		lvlSaturation = lvlParams.GetFloat("Saturation");
		lvlFog = lvlParams.GetFloat("Fog amount");
		lvlSkyBrightness = lvlParams.GetFloat("Sky Brightness");
	}
	//make it easier to edit sunposition etc. with H 
	if(EditorModeActive() && GetInputPressed(0, "H") && ReadObjectFromID(hotspot.GetID()).IsSelected()){
		Log(error, "Oof yes");
		vec3 sp = GetSunPosition();
		vec3 sc = GetSunColor();
		vec3 skt= GetSkyTint();
		
		params.SetString("Sun Position",sp.x+" "+sp.y+" "+sp.z);
		params.SetString("Sun Tint",sc.x+" "+sc.y+" "+sc.z);
		params.SetString("Sky Tint",skt.x+" "+skt.y+" "+skt.z);
		
		SetParameters();
	}
	if(!enabled || EditorModeActive()){	return;	}
	
    if(inside){
		//interpolate smoothly from the current to the wanted values if the player is inside the hotspot
        SetHDRWhitePoint(mix(GetHDRWhitePoint(), params.GetFloat("HDR White point"),	MixParam));
        SetHDRBlackPoint(mix(GetHDRBlackPoint(), params.GetFloat("HDR Black point"), 	MixParam));
        SetHDRBloomMult(mix(GetHDRBloomMult(), params.GetFloat("HDR Bloom multiplier"),	MixParam));
		SetSunPosition(mix(GetSunPosition(),SunPosPar,MixParam));
		SetSunColor(mix(GetSunColor(),SunTintPar,MixParam));
		SetSunAmbient(mix(GetSunAmbient(), params.GetFloat("Sun Ambient"),	MixParam));
		SetSkyTint(mix(GetSkyTint(),SkyTintPar,MixParam));
		lvlParams.SetFloat("Saturation",	mix(lvlParams.GetFloat("Saturation"),params.GetFloat("Saturation"),MixParam));		
		lvlParams.SetFloat("Fog amount",	mix(lvlParams.GetFloat("Fog amount"),params.GetFloat("Fog amount"),MixParam));
		lvlParams.SetFloat("Sky Brightness",mix(lvlParams.GetFloat("Sky Brightness"),params.GetFloat("Sky Brightness"),MixParam));
		//lvlParams.SetInt("Sky Rotation",	mix(,,MixParam)	);

    }else{
		//return to the starting values
		SetHDRWhitePoint(mix(GetHDRWhitePoint(), lvlHDRWPt, MixParam));
		SetHDRBlackPoint(mix(GetHDRBlackPoint(), lvlHDRBPt, MixParam));
		SetHDRBloomMult(mix(GetHDRBloomMult(), lvlBloomMult,MixParam));
		SetSunPosition(mix(GetSunPosition(),lvlSunPos,MixParam));
		SetSunColor(mix(GetSunColor(),lvlSunTint,MixParam));
		SetSunAmbient(mix(GetSunAmbient(), lvlSunAmbient,	MixParam));
		SetSkyTint(mix(GetSkyTint(),lvlSkyTint,MixParam));
		lvlParams.SetFloat("Saturation",	mix(lvlParams.GetFloat("Saturation"),lvlSaturation,MixParam));		
		lvlParams.SetFloat("Fog amount",	mix(lvlParams.GetFloat("Fog amount"),lvlFog,MixParam));
		lvlParams.SetFloat("Sky Brightness",mix(lvlParams.GetFloat("Sky Brightness"),lvlSkyBrightness,MixParam));
		//lvlParams.SetInt("Sky Rotation",	mix(g,g,MixParam)	);
	}
//end of function declaration
}
//The function that gets called at the beginning of the level and
//each time you change the script parameters in the editor: SetParameters
void SetParameters() {
	params.AddIntCheckbox("Reset on reset",true);
    params.AddFloatSlider("HDR White point",lvlHDRWPt,"min:0,max:2,step:0.001,text_mult:100");
    params.AddFloatSlider("HDR Black point",lvlHDRBPt,"min:0,max:2,step:0.001,text_mult:100");
	params.AddFloatSlider("HDR Bloom multiplier",lvlBloomMult,"min:0,max:2,step:0.001,text_mult:100");
	params.AddString("Sun Position",lvlSunPos.x+" "+lvlSunPos.y+" "+lvlSunPos.z);
	params.AddString("Sun Tint",lvlSunTint.x+" "+lvlSunTint.y+" "+lvlSunTint.z);
	params.AddFloatSlider("Sun Ambient",lvlSunAmbient,"min:0,max:2,step:0.001,text_mult:100");
	params.AddString("Sky Tint",lvlSkyTint.x+" "+lvlSkyTint.y+" "+lvlSkyTint.z);
	params.AddFloatSlider("Saturation",lvlSaturation,"min:0,max:2,step:0.001,text_mult:100");
	params.AddFloatSlider("Fog amount",lvlFog,"min:0,max:2,step:0.001,text_mult:100");
	params.AddFloatSlider("Sky Brightness",lvlSkyBrightness,"min:0,max:2,step:0.001,text_mult:100");
    //params.AddFloatSlider("Sky Rotation",BloomMult,"min:0,max:5,step:0.001,text_mult:100"); Sky Rotation is int, prolly not to useful

	//looks like we're calling functions on a magical variable called "params" we never declared?
	//as always a quick glance at the ashotspot_doc.h file helps a lot. We can see there on the second last line
	//that this variable is a reference to the hotspots script params that is automagically available in the script. (like every other function/var in that file)
	params.AddFloatSlider("Mix",0.01f,"min:0,max:1,step:0.001,text_mult:100");
	MixParam = params.GetFloat("Mix");
	
	//not too elegant but required since params can't do vec3s
	array<string>@ cmps = params.GetString("Sun Position").split(" ");
	SunPosPar.x = atof(cmps[0]);
	SunPosPar.y = atof(cmps[1]);
	SunPosPar.z = atof(cmps[2]);
	
	@cmps = params.GetString("Sun Tint").split(" ");
	SunTintPar.x = atof(cmps[0]);
	SunTintPar.y = atof(cmps[1]);
	SunTintPar.z = atof(cmps[2]);
	
	@cmps = params.GetString("Sky Tint").split(" ");
	SkyTintPar.x = atof(cmps[0]);
	SkyTintPar.y = atof(cmps[1]);
	SkyTintPar.z = atof(cmps[2]);
	
//end of function declaration
}
