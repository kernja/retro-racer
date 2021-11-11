# Downloadable Content

`Retro Racer` allowed users to expand gameplay by offering downloadable content (DLC) for free. This functionality was implemented through static `.zip` files that were downloaded and extracted into a local folder named `/download`.

The DLC content has been added to the repo twice:

* `/deployed` demonstrates how the content should be deployed to a server

* `/src` contains the extracted contents of the files in the `/deployed` folder

## How DLC worked

1. The game would download `listings.zip` from the server and extract the contents into the local `/download` folder 

2. The game would parse the extracted `/download/listings.txt` file to find supported maps

	* `100` map files are from the first release of `Retro Racer`
	
	* `110+120` map files are from subsequent releases of `Retro Racer` and utilize run-length encoding to optimize loading
	
3. After the user selects a map to preview, the game would:

	* Download and display the course preview image from the server
	
	* Display the course name
	
	* Display the course creator
	
4. After the user selects the map to play, the game would:

	* Download the bundled course data as a `.zip` file
	
	* Extract the bundled course data into the local `/download` folder
	
	* Load the `/download/map.rrc` file
	
		* If provided, load the `/download/imageList.txt` file and any other assets
	
	* Start gameplay
	
	
## listings.zip file format

`listings.zip` contains a comma-separated named `listings.txt` that contained the tracks that were available for download. `listings.txt` had the following fields:

* Version ID

	* `100`
	
	* `110+120`
	
* Map name

* File path (to download bundled course data from the server as a `.zip` file)

* File path (to download the preview image from the server)

* Course creator 
	
* Difficulty level

	* `0` = Easy
	
	* `1` = Medium
	
	* `2` = Hard
	
## Bundled course data

The bundled course data `.zip` file must contain a map file to load. The map name must be `map.rrc` for the course to be successfully loaded. All other files are optional, however an `imageList.txt` file can be included to enable the loading of custom image assets.