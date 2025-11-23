# Polargraph Controller - Processing 4 Compatible

This is a **Processing 4.4.10 compatible** version of the Polargraph Controller, migrated from the original Processing 2.x codebase.

## What's New

This version has been fully updated to work with Processing 4, including:
- Modern window management using `surface` API
- Fixed all deprecated AWT frame handling
- Updated event handling for Processing 4
- Serial port refresh functionality
- Bug fixes for popup windows

## Requirements

- **Processing 4.4.10** or later
- **Arduino IDE** (for uploading firmware)
- **ControlP5** library (install via Processing's Library Manager)
- **Geomerative** library (install via Processing's Library Manager)

## Installation

### 1. Install Processing 4
Download and install Processing 4 from [processing.org](https://processing.org/download)

### 2. Install Required Libraries
Open Processing and install these libraries via **Sketch → Import Library → Add Library**:
- ControlP5
- Geomerative

### 3. Open the Sketch
Navigate to `processing-source/polargraphcontroller/polargraphcontroller.pde` and open it in Processing 4.

### 4. Upload Arduino Firmware
1. Open `modified arduino-source/polargraph_server_a1/polargraph_server_a1.ino` in Arduino IDE
2. Configure your hardware in the file (see Hardware Configuration below)
3. Upload to your Arduino

## Hardware Configuration

### For ULN2003 Stepper Drivers (28BYJ-48 motors)

Edit `configuration.ino` to set your pin assignments:

```cpp
// Motor A uses analog pins A0-A3
AccelStepper motorA(8, A0,A1,A2,A3);

// Motor B uses digital pins 8-11
AccelStepper motorB(8, 8,9,10,11);
```

**Wiring:**
- Motor A: IN1→A0, IN2→A1, IN3→A2, IN4→A3
- Motor B: IN1→8, IN2→9, IN3→10, IN4→11

### Disable Servo (if not using pen lift)

In `polargraph_server_a1.ino`, comment out the PENLIFT line:

```cpp
//#define PENLIFT  // Disabled - no servo on this machine
```

## Processing 4 Migration Details

### Major Changes Made

1. **Window Management**
   - Replaced `frame.setResizable()` with `surface.setResizable()`
   - Migrated all secondary windows to use `PApplet.runSketch()`
   - Removed deprecated AWT `Frame` and `init()` patterns

2. **Settings Method**
   - Created `settings()` method for `size()` calls (Processing 4 requirement)
   - Moved all `size()` calls from `setup()` to `settings()`

3. **Type Qualifications**
   - Fully qualified `Serial` to `processing.serial.Serial`
   - Fully qualified `MouseEvent` to `processing.event.MouseEvent`

4. **Event Handling**
   - Removed deprecated `addMouseWheelListener()`
   - Updated `mouseWheel()` to use Processing 4's `MouseEvent` signature

5. **Method Conflicts**
   - Renamed `changeTab()` to `switchPolargraphTab()`
   - Fixed parameter naming conflicts

6. **Bug Fixes**
   - Fixed popup windows closing main application
   - Replaced `frame` references with `null` in JFileChooser dialogs
   - Fixed syntax errors and type ambiguities

### Files Modified

**Processing Source:**
- `polargraphcontroller.pde` - Main sketch
- `ControlFrameSimple.pde` - Secondary window base class
- `SerialPortWindow.pde` - Serial port selection
- `MachineStoreWindow.pde` - Machine store dialog
- `MachineExecWindow.pde` - Machine execute dialog
- `DrawPixelsWindow.pde` - Pixel drawing dialog
- `controlsActionsWindows.pde` - Control windows
- `controlsSetup.pde` - Control panel setup

**Arduino Source:**
- `polargraph_server_a1.ino` - Main firmware
- `configuration.ino` - Pin configuration
- `exec.ino` - Command execution

## Building from Command Line

You can build the sketch using Processing's CLI:

```bash
processing-java --sketch=/path/to/polargraphcontroller --build
```

Or with the snap version:

```bash
processing cli --sketch=/path/to/polargraphcontroller --build
```

## Troubleshooting

### Serial Port Issues
- Use the "Refresh Serial Ports" option in the serial port dropdown
- Check that your Arduino is properly connected
- Verify the correct baud rate (default: 57600)

### Motor Not Moving
- Check pin assignments in `configuration.ino`
- Verify power supply is adequate (5V for 28BYJ-48)
- Test each motor individually
- Check for loose connections

### Window Closing Issues
- Fixed in this version - popup windows no longer close the main application

## Credits

- Original Polargraph by Sandy Noble
- Processing 4 migration by Morten Skogly (2025)

## License

Released under GNU License version 3.

## Links

- [Polargraph Website](http://www.polargraph.co.uk/)
- [Original Repository](https://github.com/euphy/polargraphcontroller)
- [Processing](https://processing.org/)
