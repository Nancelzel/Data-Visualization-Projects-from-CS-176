// Nancy Cao
// Code to visualize meteorite landing locations, when they were found,
// and their mass.
// 4 data fields used: Mass, year, latitude, longitude
// The data is from "Meteorite_Landings.csv"

Table table;            // table of meteorite data from csv file
int numRows;            // number of rows from the table
PImage bg;              // background image
String[] mClass;        // array of classes
float[] mass;           // array of masses (g)
int[] year;             // array of year of discoveries
float[] lat;            // array of latitiudes
float[] lon;            // array of longitudes
int yearLow = 1750;     // starting year
int yearHigh = 2013;    // ending year
int curYear = yearLow;  // current year iteration
int massLow = 0;        // starting mass
int massHigh = 10000;   // ending mass
int curMass = massLow;  // current mass iteration
int massCount = 10;     // mass range iteration
int mode = 0;           // mode 0 = iterate by year, mode 1 = iterate by mass
int counter = 0;        // counter used for naming frames

/* This function loads the data from "Meteorite_Landings.csv" into arrays
 * Arguments: None
 * Returns nothing.
 */
void loadData() {
  
  table = loadTable("Meteorite_Landings.csv", "header");
  numRows = table.getRowCount();
  
  // Arrays to store mass, year, latititude, and longitude
  float[] massField = new float[numRows];
  int[] yearField = new int[numRows];
  float[] latField = new float[numRows];
  float[] longField = new float[numRows];
  
  int i = 0; // counter to iterate through rows
  
  // Iterate through every row and extract necessary data
  for (TableRow row : table.rows()) {
    
    massField[i] = row.getFloat("mass (g)");
    
    latField[i] = row.getFloat("reclat");
    longField[i] = row.getFloat("reclong");
    
    String field = row.getString("year");
    
    // Parsing year out since year is stored as MO/DY/YEAR HR:MN:SD AM
    if (!field.equals("")) {
      String date = field.split(" ")[0];
      yearField[i] = Integer.parseInt(date.split("/")[2]);
    }
    else {
      yearField[i] = 0;
    }
    
    i++;
  }
  
  mass = massField;
  year = yearField;
  lat = latField;
  lon = longField;
}

/* This function sets up the visualization by loading the data as
 * well as the map image.
 * Arguments: None.
 * Returns nothing
 */
void setup() {
  
  loadData();
  
  size(1000, 500);
 
  bg = loadImage("map.jpg");
}

/* This function draws the map into the background and determines which mode
 * (iterate by year or by mass) it is in before mapping out the appropriate
 * meteorites for the appropriate year/mass range.
 * Arguments: None.
 * Returns nothing.
 */
void draw() {
  background(bg);
  
  // Determine to iterate by year or by mass. 
  if(mode == 0) {
    
    frameRate(10);
    textSize(13);
    fill(0);
    text("Meteorite Findings from 1913-2013", 10, 15);
    text("Year: " + Integer.toString(curYear), 30, 35);
    textSize(13);
    text("Created by Nancy Cao", 860, 495);
    
    for(int i = 0; i < numRows; i++) {
      
      // Don't map meteorites with unknown landing sites
      if(lat[i] != 0 && lon[i] != 0) {
        
        // Map meteorite if it coincides with current year
        if(year[i] == curYear) {
          
          float latScale = (lat[i] + 180) / 360.0 * 1000;
          float longScale = (lon[i] + 180) / 360.0 * 500;
  
          float massValue = mass[i];
         
          // Get mass ratio to determine color of dot
          if(massValue <= 10000) {
            massValue /= 10000;
          }
          else {
            massValue = 1;
          }
          
          fill(massValue * 256, 0, 0);
          ellipse(latScale, longScale, 10, 10);
        }
      }
    }
    
    // Create gradient for mass
    fill(0);
    textSize(9);
    text("Mass of meteorite", 90, 480);
    text("0 kg", 3, 485);
    text("> 1 kg", 230, 485);
    
    for(int x = 0; x < 256; x++) {
      stroke(x, 0, 0);
      line(x, 490, x, 499);
    }
    
    curYear++;
  
    // After iterating to highest year, switch to iterating through mass
    if(curYear > yearHigh) {
      curYear = 1750;
      mode = 1;
    }
  }
  else {
    frameRate(40);
    
    textSize(13);
    fill(0);
    text("Mass of Meteorite Findings", 10, 15);
    text("Mass: " + Integer.toString(curMass) + " to " +
          Integer.toString(curMass + 10) + " g", 30, 35);
    textSize(13);
    text("Created by Nancy Cao", 860, 495);
    
    for(int i = 0; i < numRows; i++) {
      
      // Don't map meteorites with unknown landing sites
      if(lat[i] != 0 && lon[i] != 0) {
        
        // Map meteorite if it coincides within mass range
        if(mass[i] >= curMass && mass[i] < (curMass + 10)) {
          
          float latScale = (lat[i] + 180) / 360.0 * 1000;
          float longScale = (lon[i] + 180) / 360.0 * 500;
  
          float yearValue = (year[i] - 1750) / 263.0;
          
          fill(yearValue * 256, 0, 0);
          ellipse(latScale, longScale, 10, 10);
        }
      }
    }
    
    // Create gradient for year
    fill(0);
    textSize(9);
    text("Year", 100, 480);
    text("1750", 3, 485);
    text("2013", 230, 485);
    
    for(int x = 0; x < 256; x++) {
      stroke(x, 0, 0);
      line(x, 490, x, 499);
    }
    
    massCount--;
    
    // Go to next range if current range has been examined
    if(massCount == 0) {
      curMass += 10;
      massCount = 10;
    }
  
  
    // After iterating to highest mass, switch to iterating through year
    if(curMass > massHigh) {
      curMass = 0;
      mode = 0;
    }
  }
  
  
  //saveFrame("frames/frame-" + counter + ".jpg");
  counter++;
}