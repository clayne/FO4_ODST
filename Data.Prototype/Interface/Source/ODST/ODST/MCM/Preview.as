﻿package
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import AS3.*;

	public class Preview extends MovieClip
	{
		public static const MenuName:String = "PauseMenu"; // use root menu?

		public var PrimaryTexture:TextureLoader;
		public static const PrimaryMountID:String = "ODST_EmblemPrimary";

		public var SecondaryTexture:TextureLoader;
		public static const SecondaryMountID:String = "ODST_EmblemSecondary";

		public var BackgroundTexture:TextureLoader;
		public static const BackgroundMountID:String = "ODST_EmblemBackground";


		public function Preview()
		{
			Debug.WriteLine("Preview", "ctor", "Constructor Code", "Hello");

			PrimaryTexture.ImageMountID = PrimaryMountID;
			PrimaryTexture.Load("ProjectHelljumper\\H3ODST\\1Decals\\Decals\\Primary\\Spartan1.dds");

			SecondaryTexture.ImageMountID = SecondaryMountID;
			SecondaryTexture.Load("ProjectHelljumper\\H3ODST\\1Decals\\Decals\\Primary\\Spartan2.dds");

			BackgroundTexture.ImageMountID = BackgroundMountID;
			BackgroundTexture.Load("ProjectHelljumper\\H3ODST\\1Decals\\Decals\\Background\\Shield.dds");
		}


	}
}
