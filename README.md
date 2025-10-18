# Main objective of project
The main objective of this project is to analyze the drivers of differences in 
nurse shark coloration. I plan to do this by analyzing correlations between 
environmental and biological factors and color data extracted from photos of 
nurse sharks out in the field. This script processes the raw color dataset to 
prepare it for further visualization and analysis in upcoming assignments.

## Contents of project's repository 
- `scripts/`: R scripts for analysis and wrangling the data set
- `results/`: Output figures and tables
- `data/`: Processed data set saved in `.rds` format for future use  
- `README.md`: Project summary and data description

## Column names of clean data, data type, description of columns
Column Name    | Data Type | Description                                        
---------------|-----------|--------------------------------------------------
tag            | character | Unique shark identifier                            
catch_date     | Date      | Date when shark was caught                         
photo_type     | factor    | Type of photograph taken                           
photo_wb       | factor    | White balance setting used in the photo            
hex            | character | Hexadecimal color code                             
h              | numeric   | Hue value from HSB color model                     
s              | numeric   | Saturation value from HSB color model          
br             | numeric   | Brightness value from HSB color model            
r              | numeric   | Red channel value (0–255)                        
g              | numeric   | Green channel value (0–255)                      
b              | numeric   | Blue channel value (0–255)                       
avg_rgb        | numeric   | Average RGB value = (R + G + B)/3                
color_shade    | factor    | Grouped color category based on avg_rgb: dark, 
                           | medium, or light 

## Author
Wendy Miyazaki
wxm344@miami.edu
