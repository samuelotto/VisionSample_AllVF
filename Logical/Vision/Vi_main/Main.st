PROGRAM _INIT
	// This sample-task triggers a camera and optional one or more external lights
	// Nettime needs to be used when external lights are used. In this sample it is used.
	// In the vision application the trigger source needs to switched to "NetTime" --> here it is done in the CodeReader
	// The Vision componenents of the lights need NOT to be connected to the Lights in the Physical View. But to use external lights with the mappVision HMI it needs to be connected --> here done with CodeReader
	// For the handling with the camera see the chart in the help: https://help.br-automation.com/#/en/4/machine_vision%2Fmapp_vision%2Fprogramming%2Fvfs%2Fhardware_funktion_-_standardkonfiguration_kamera.html
	
	// Use some default values. Note: The light parameters (color, exposure time, ...) could be different for camera and the lights. E.g. switch camera light off, when the backlight is used.
	VisionCtrl.Parameters.FlashColor := 1; // red
	VisionCtrl.Parameters.FlashSegment := 15; // 15 = all Segments
	VisionCtrl.Parameters.ExposureTime := 150; // [µs]
	VisionCtrl.Parameters.SetFocus := 15000; // [10µm]
	
	BacklightCtrl.Parameters.FlashColor := 1; // red
	BacklightCtrl.Parameters.ExposureTime := 150;
	
	LightBarCtrl.Parameters.FlashColor := 1; // red
	LightBarCtrl.Parameters.ExposureTime := 150; // [µs]
	LightBarCtrl.Parameters.SetAngle := 45; // [°]

	RTInfo_0(enable := TRUE); // Gets the actual task-class cycle time in µs on the output RTInfo_0.cycle_time
END_PROGRAM
PROGRAM _CYCLIC
	
	// Fire Trigger with "CmdTriggerImage" which could be set from the user-application
	IF CmdTriggerImage AND VisionCtrl.Status.CameraReady AND NOT VisionCtrl.Status.ImageProcessingActive THEN
		CmdTriggerImage := FALSE;
		VisionCtrl.Parameters.SetNettime := ActNettime_SoC + 5 * RTInfo_0.cycle_time; // Trigger the camera some cycles in the future because of some delays. See doumentation for more information.
		VisionCtrl.Cmd.AcquireImage := TRUE;
		// Trigger the lights only if available. In a real application check the ready in the "IF" above. Because of this sample could be used without lights, it only flashes if available
		IF BacklightCtrl.Status.LightReady THEN
			BacklightCtrl.Cmd.FlashTrigger := TRUE;
			BacklightCtrl.Parameters.SetNettime := VisionCtrl.Parameters.SetNettime;
		END_IF
		IF LightBarCtrl.Status.LightReady THEN
			LightBarCtrl.Cmd.FlashTrigger := TRUE;
			LightBarCtrl.Parameters.SetNettime := VisionCtrl.Parameters.SetNettime;
		END_IF
	END_IF
	// Reset the trigger-commands, when the camera has accepted the acquisition
	IF VisionCtrl.Status.AcceptedAcquisitionCnt <> AcceptedAcquisitionCntOld THEN
		AcceptedAcquisitionCntOld := VisionCtrl.Status.AcceptedAcquisitionCnt;
		VisionCtrl.Cmd.AcquireImage := FALSE;
		BacklightCtrl.Cmd.FlashTrigger := FALSE;
		LightBarCtrl.Cmd.FlashTrigger := FALSE;
	END_IF
	// Load the image from the camera (task Vi_Image --> CmdShowImageMappView) when the image is ready
	IF VisionCtrl.Status.CompletedAcquisitionCnt <> CompletedAcquisitionCntOld THEN
		CompletedAcquisitionCntOld := VisionCtrl.Status.CompletedAcquisitionCnt;
		CmdShowImageMappView := TRUE;
	END_IF
	
	// Do something with the results, when the camera has processed the image (used the configured vision functions)
	IF EDGENEG(VisionCtrl.Status.ImageProcessingActive) THEN
		// Do something with the camera outputs
	END_IF

END_PROGRAM