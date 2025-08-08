# Enhanced OSRS Automation Suite

A comprehensive automation tool that integrates with RuneLite's Ping & Tick Logger plugin for optimal timing and performance.

## 🚀 Features

### ⚡ **Smart Window Detection**
- Automatically finds and connects to RuneLite window
- Works with fixed and resizable mode
- Handles multiple monitor setups
- Robust fallback detection methods

### 🙏 **Prayer Flicking**
- Tick-perfect prayer flicking using real-time tick data
- Automatic prayer orb detection
- Customizable timing and human-like variation
- **Hotkey: F12**

### ⚔️ **Special Attacks**
- Automatic special attack activation
- Smart coordinate detection
- Customizable special energy thresholds
- **Hotkey: F11**

### 🌿 **Herb Cleaning**
- Automated herb cleaning with inventory management
- Configurable inventory slots
- Supports various cleaning tools
- **Hotkey: F10**

### 🎒 **Gear Switching**
- Pre-configured gear switch combinations
- Combat style switching (Melee/Ranged/Magic)
- Inventory slot mapping
- **Hotkey: F9**

### 🏠 **Emergency Features**
- Instant teleport activation
- Panic buttons for dangerous situations
- Health/prayer threshold monitoring
- **Hotkey: F8**

## 📖 Quick Start

### 1. **Prerequisites**
- RuneLite with Ping & Tick Logger plugin enabled
- Be logged into OSRS
- Files must exist: `~/.runelite/ping.txt` and `~/.runelite/tick.txt`

### 2. **Launch**
```cmd
cd "C:\Users\hp\Development\osrs_ahk_clicker"
.\enhanced_osrs_automation_suite.ahk
```

### 3. **Configuration**
- Edit `automation_config.ini` for custom settings
- Use "Detect" button to map coordinates
- Enable desired automation features

## 🎮 Controls

### **Main Hotkeys**
| Key | Function | Description |
|-----|----------|-------------|
| F12 | Prayer Flicking | Toggle tick-perfect prayer flicking |
| F11 | Special Attack | Activate special attack |
| F10 | Herb Cleaning | Clean herbs automatically |
| F9  | Gear Switch | Cycle through gear combinations |
| F8  | Emergency Teleport | Instant panic teleport |
| Esc | Exit | Close the automation suite |

### **GUI Controls**
- **Checkboxes**: Enable/disable automation features
- **Manual Buttons**: Trigger actions once
- **Detect Button**: Map RuneLite window coordinates
- **Activity Log**: Monitor all automation activity

## ⚙️ Configuration

### **Timing Settings**
```ini
[Timing]
MinClickGap=30        ; Minimum delay between clicks
MaxClickGap=50        ; Maximum delay between clicks
JitterMax=10          ; Random timing variation
DefaultTick=600       ; Fallback tick length
```

### **Coordinate Mapping**
```ini
[Coordinates]
PrayerOffsetX=-180    ; Prayer orb position
PrayerOffsetY=85      ; Relative to window
InventoryBaseX=-180   ; Inventory area
InventoryBaseY=-250   ; Position mapping
```

### **Inventory Setup**
```ini
[Inventory Tags]
HerbSlot=1           ; Herbs to clean
CleaningToolSlot=2   ; Pestle & mortar
WeaponSlot=3         ; Primary weapon
FoodSlot=28          ; Emergency food
```

### **Gear Switches**
```ini
[Gear Switching]
Switch1=3,4,5|Melee Combat     ; Weapon, shield, amulet
Switch2=6,7,8|Ranged Combat    ; Bow, arrows, gear
Switch3=9,10,11|Magic Combat   ; Staff, runes, robes
```

## 🎯 Advanced Features

### **Pixel Detection** (Optional)
- Enable `UsePixelDetection=true` in config
- Automatically detects UI elements by color
- More robust than coordinate-based detection
- Requires initial calibration

### **Health Monitoring**
- Automatic health threshold detection
- Emergency teleport when health is low
- Prayer point monitoring
- Special energy tracking

### **Smart Timing**
- Uses real-time tick length from RuneLite
- Adapts to server lag and performance
- Tick-perfect automation timing
- Human-like variation patterns

## 🛡️ Safety Features

### **Built-in Protections**
- Maximum clicks per second limiting
- Window focus requirements
- Emergency stop mechanisms
- Activity logging for review

### **Panic Systems**
- Instant teleport on F8
- Automatic stopping on window loss
- Health threshold emergency actions
- Manual override controls

## 🔧 Troubleshooting

### **Window Not Detected**
1. Ensure RuneLite is running and visible
2. Try clicking "Detect" button
3. Check if window title contains "RuneLite"
4. Restart the automation suite

### **Coordinates Wrong**
1. Use "Detect" button to remap
2. Adjust offsets in `automation_config.ini`
3. Test with manual buttons first
4. Check screen resolution and scaling

### **Timing Issues**
1. Verify ping.txt and tick.txt files exist
2. Enable Ping & Tick Logger plugin
3. Log into OSRS to generate data
4. Check file permissions

### **Files Not Found**
1. Ensure RuneLite plugin is enabled
2. Log into OSRS (files created on login)
3. Check path: `%USERPROFILE%\.runelite\`
4. Verify plugin configuration

## ⚠️ Important Notes

### **Jagex Rules Compliance**
- This tool is for educational purposes
- Use responsibly and at your own risk
- Follow all game rules and guidelines
- Consider detection risks

### **Performance Tips**
- Close unnecessary programs
- Use fixed screen mode for consistency
- Regular coordinate recalibration
- Monitor activity logs

### **Best Practices**
- Start with manual testing
- Use conservative timing settings
- Monitor for game updates
- Keep backups of working configurations

## 📝 Version History

- **v1.0** - Initial release with prayer flicking
- **v2.0** - Added window detection and special attacks
- **v3.0** - Comprehensive automation suite with all features

## 🤝 Support

For issues and improvements:
1. Check the troubleshooting section
2. Review activity logs
3. Test with manual controls first
4. Verify RuneLite plugin status

---

**Happy Gaming!** 🎮

*Remember to use automation responsibly and in accordance with game rules.*
