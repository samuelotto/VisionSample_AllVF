PROGRAM _INIT
	// This sample-task loads the image from a camera and saves it as bmp file. This can be necessary, if the mappVision HMI cannot be used,
	// e.g. because of the object is moving and the trigger is fired via application or mappMotion.
	// Note: This sample is a code-sample. It should be understood and adapted to the personal needs.
	// A sample with much more functions can also be found here (branch "basic"): https://github.com/br-automation-com/mappVision-Demo/blob/basic/Logical/Vision/Vi_image/Main.st
	
	// Calculation of buffer-sizes
	// Max image size: 5MP sensor resolution is 2592x2048 Pixel --> 5.308.416 raw Pixels + ~10.000 Byte Overhead --> 5.320.000 Bytes
	// Notes:
		// Linesensor: The image could be bigger, depending on used number of lines
END_PROGRAM
PROGRAM _CYCLIC
	CASE Step OF
	
		0: // Wait
			IF CmdSaveRawBmpFile THEN
				CmdSaveRawBmpFile := FALSE;
				ViBaseGetImage_0(Execute := FALSE);
				brsmemset(ADR(BufferForBinaryImageData), 0, SIZEOF(BufferForBinaryImageData));
				Step := 10;
			END_IF
			
		// Load image from camera into variable (internal buffer)
		10:
			ViBaseGetImage_0.MpLink := ADR(VCMyCam);
			ViBaseGetImage_0.Execute := TRUE;
			ViBaseGetImage_0.Type := viBASE_IMAGE_TYPE_BMP;
			// Quality level is not relevant for bmp file
			ViBaseGetImage_0.Timeout := T#20s; // Depending on PLK-cycle time and image size, the timeout needs to be increased
			ViBaseGetImage_0.Buffer := ADR(BufferForBinaryImageData);
			ViBaseGetImage_0.BufferSize := SIZEOF(BufferForBinaryImageData);
			ViBaseGetImage_0();
			IF ViBaseGetImage_0.Done THEN
				Step := 20;
			ELSIF ViBaseGetImage_0.Error THEN
				Status := ViBaseGetImage_0.StatusID;
				IF ViBaseGetImage_0.StatusID = viBASE_ERR_NO_IMG_AVAILABLE THEN // No image --> could happen after startup before first trigger.
					Step := 0;
				ELSE
					Status := ViBaseGetImage_0.StatusID;
					Step := 100;
				END_IF
			END_IF
			
		// Save image
		20: 
			FileDelete_0.enable := TRUE;
			FileDelete_0.pDevice := ADR('CF');
			FileDelete_0.pName := ADR('Image.bmp');
			FileDelete_0();
			IF FileDelete_0.status = 0 OR FileDelete_0.status = fiERR_FILE_NOT_FOUND THEN
				Step := 21;
			ELSIF FileDelete_0.status <> ERR_FUB_BUSY THEN
				Status := FileDelete_0.status;
				Step := 100;
			END_IF
		21:
			FileCreate_0.enable := TRUE;
			FileCreate_0.pDevice := FileDelete_0.pDevice;
			FileCreate_0.pFile := FileDelete_0.pName;
			FileCreate_0();
			IF FileCreate_0.status = 0 THEN
				Step := 22;
			ELSIF FileCreate_0.status <> ERR_FUB_BUSY THEN
				Status := FileCreate_0.status;
				Step := 100;
			END_IF
		22:
			FileWrite_0.enable := TRUE;
			FileWrite_0.ident := FileCreate_0.ident;
			FileWrite_0.pSrc := ADR(BufferForBinaryImageData);
			FileWrite_0.len := ViBaseGetImage_0.BufferLen;
			FileWrite_0();
			IF FileWrite_0.status = 0 THEN
				Step := 23;
			ELSIF FileWrite_0.status <> ERR_FUB_BUSY THEN
				Status := FileWrite_0.status;
				Step := 100;
			END_IF
		23:
			FileClose_0.enable := TRUE;
			FileClose_0.ident := FileCreate_0.ident;
			FileClose_0();
			IF FileClose_0.status = 0 THEN
				Step := 0;
			ELSIF FileClose_0.status <> ERR_FUB_BUSY THEN
				Status := FileClose_0.status;
				Step := 0;
			END_IF

		100: // Error
			CmdSaveRawBmpFile := FALSE;
			// ToDo: Implement some errorhandling here
	END_CASE
END_PROGRAM