# Bambu Studio Bulk Filament Generator
Bambu Studio’s UI for creating custom filaments is notoriously slow and tedious. This project allows you to bypass the UI by using a PowerShell script and an AI LLM to bulk-generate filament profiles directly in your configuration folders.

## How it Works
1. The Script - `Create-FilamentData.ps1` acts as a template that handles the file system logic, ID generation, and directory placement.
2. The AI - You feed the script and a specific prompt to an LLM (like Gemini). The AI researches the colors, adjusts the technical print settings, and populates the script with the data.
3. The Result - You run the generated script, and your Bambu Studio inventory is instantly updated.

## Prerequisites
1. Find your User ID - Bambu Studio stores profiles under a numeric ID. Navigate to: `%AppData%\BambuStudio\user\` You will see a folder named with a long string of numbers (e.g., `123456789`). This is your User ID.
2. Locate the Base Directory - The script will place files in: `%AppData%\BambuStudio\user\<YourID>\filament\base`

## The AI "Power-Prompt" Template
Copy the content of `Create-FilamentData.ps1` into your LLM of choice, then follow up with this prompt:

```
### TASK
Act as a 3D printing expert. Use the provided PowerShell script as a template to generate custom filament profiles for Bambu Studio. 

### METADATA
- Vendor: "[Insert e.g., Elegoo]"
- Filament Class: "[Insert e.g., Matte PLA]"
- Printer Suffix: "[Insert e.g., @Bambu Lab A1 0.4 nozzle]"
- User ID: "[Insert your Numeric ID]"

### COLOR DATA TO RESEARCH
Please research the HEX codes for the following filaments. If exact data isn't available, provide the closest community-verified match:
1. [Color Name] - [SKU/Part Number]
2. [Color Name] - [SKU/Part Number]
...

### TECHNICAL CONSTRAINTS
1. MATERIAL LOGIC: Adjust the "nozzle_temperature", "filament_max_volumetric_speed", and "pressure_advance" within the script based on the material type (e.g., Wood PLA needs different flow/temps than Matte PLA).
2. DIRECTORY: Ensure the script targets the `\filament\base` subfolder.
3. UNIQUE IDS: The script must generate a unique $shortId and $longId for every entry to prevent Bambu Studio from overwriting profiles.

### OUTPUT
Provide the fully updated PowerShell script ready to be copied and run.
```

## Usage Instructions
1. Copy the Script - Copy the PowerShell code provided by the AI.
2. Run PowerShell and paste in the code (or save as .ps1 and execute).
3. If prompted for execution policy, use: `Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope Process`.
4. Restart Bambu Studio: The software scans for new files only on startup.
