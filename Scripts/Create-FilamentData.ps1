# ==========================================
# 1. CONFIGURATION (Edit these as needed)
# ==========================================
$vendor        = "Sunlu"
$filamentClass = "Elite Wood"
$printerSuffix = "@Bambu Lab A1 0.4 nozzle"
$userId        = "3640492178"
$path          = "$env:AppData\BambuStudio\user\$userId\filament\base"
$timestamp     = [int]([DateTimeOffset]::UtcNow.ToUnixTimeSeconds())

# ==========================================
# 2. FILAMENT DATA (Name = @(HEX, SKU))
# ==========================================
$filaments = @{
    "Maple Wood"  = @("#D2B48C", "04750913Z")
    "Walnut Wood" = @("#4B3621", "04750916Z")
    "Wood"        = @("#BA9674", "04750908Z")
    "Cherry Wood" = @("#8B4513", "04450920Z")
}

# ==========================================
# 3. GENERATION LOOP
# ==========================================
foreach ($name in $filaments.Keys) {
    $hex = $filaments[$name][0]
    $sku = $filaments[$name][1]
    
    # Generate Unique IDs
    $shortId = "P" + [Guid]::NewGuid().ToString().Substring(0,7)
    $longId  = "PFUS" + [Guid]::NewGuid().ToString().Replace("-","").Substring(0,16)
    
    # Dynamic Naming Convention
    $fullDisplayName = "$vendor $filamentClass - $name - ($sku) $printerSuffix"
    $safeFile = $fullDisplayName -replace '[\\\/\:\*\?\"\<\>\|]', '_'

    # .JSON CONTENT
    $jsonContent = @"
{
    "activate_air_filtration": ["0"],
    "additional_cooling_fan_speed": ["70"],
    "chamber_temperatures": ["0"],
    "circle_compensation_speed": ["200"],
    "close_fan_the_first_x_layers": ["1"],
    "compatible_printers": ["Bambu Lab A1 0.4 nozzle"],
    "complete_print_exhaust_fan_speed": ["70"],
    "cool_plate_temp": ["35"],
    "cool_plate_temp_initial_layer": ["35"],
    "default_filament_colour": ["$hex"],
    "filament_cost": ["25"],
    "filament_density": ["1.20"],
    "filament_flow_ratio": ["0.98"],
    "filament_id": "$shortId",
    "filament_max_volumetric_speed": ["15"],
    "filament_notes": "$vendor $filamentClass Series",
    "filament_settings_id": ["$fullDisplayName"],
    "filament_type": ["PLA"],
    "filament_vendor": ["$vendor"],
    "from": "User",
    "hot_plate_temp": ["65"],
    "hot_plate_temp_initial_layer": ["65"],
    "inherits": "",
    "name": "$fullDisplayName",
    "nozzle_temperature": ["220"],
    "nozzle_temperature_initial_layer": ["220"],
    "nozzle_temperature_range_high": ["260"],
    "nozzle_temperature_range_low": ["195"],
    "pressure_advance": ["0.025"],
    "textured_plate_temp": ["65"],
    "textured_plate_temp_initial_layer": ["65"],
    "version": "2.4.0.10"
}
"@

    # .INFO CONTENT
    $infoContent = @"
sync_info = 
user_id = 
setting_id = $longId
base_id = 
updated_time = $timestamp
"@

    # File Writing
    $jsonPath = Join-Path $path "$safeFile.json"
    $infoPath = Join-Path $path "$safeFile.info"
    
    $jsonContent | Out-File -FilePath $jsonPath -Encoding utf8
    $infoContent | Out-File -FilePath $infoPath -Encoding utf8
    
    Write-Host "Created: $fullDisplayName" -ForegroundColor Cyan
}

Write-Host "`nSuccessfully created files in: $path" -ForegroundColor Green
