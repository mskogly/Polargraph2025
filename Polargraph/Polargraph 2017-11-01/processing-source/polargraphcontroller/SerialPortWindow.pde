/*------------------------------------------------------------------------
 Class and controllers on the "serial port" subwindow
 ------------------------------------------------------------------------*/

ControlFrameSimple serialPortControlFrame = null;
  
ControlFrameSimple addSerialPortControlFrame(String theName, int theWidth, int theHeight, int theX, int theY, int theColor ) {
  /*
  final Frame f = new Frame( theName );
  final ControlFrameSimple p = new ControlFrameSimple( this, theWidth, theHeight, theColor );
  serialPortControlFrame = p;

  f.add( p );
  p.init();
  f.setTitle(theName);
  f.setSize( p.w, p.h );
  f.setLocation( theX, theY );
  f.addWindowListener( new WindowAdapter() {
    @Override
      public void windowClosing(WindowEvent we) {
      p.dispose();
      f.dispose();
    }
  } 
  );
  f.setResizable( true );
  f.setVisible( true );
  */
  
  final ControlFrameSimple p = new ControlFrameSimple( this, theWidth, theHeight, theColor );
  serialPortControlFrame = p;
  
  String[] args = {"--location=" + theX + "," + theY, theName};
  PApplet.runSketch(args, p);
  
  // sleep a little bit to allow p to call setup.
  // otherwise a nullpointerexception might be caused.
  try {
    Thread.sleep( 100 );
  } 
  catch(Exception e) {
  }

  ScrollableList sl = p.cp5().addScrollableList("dropdown_serialPort")
    .setPosition(10, 10)
    .setSize(150, 150)
    .setBarHeight(20)
    .setItemHeight(16)
    .plugTo(this, "dropdown_serialPort");  

  sl.addItem("Refresh Serial Ports", -2);
  sl.addItem("No serial connection", -1);

  String[] ports = processing.serial.Serial.list();
  
  for (int i = 0; i < ports.length; i++) {
    println("Adding " + ports[i]);
    sl.addItem(ports[i], i);
  }
  
  int portNo = getSerialPortNumber();
  println("portNo: " + portNo);
  if (portNo < 0 || portNo >= ports.length)
    portNo = -1;

  // set the value of the actual control
  sl.setValue(portNo);

  sl.setOpen(false);
  return p;
}


void dropdown_serialPort(int selectionIndex) 
{
  println("In dropdown_serialPort, selectionIndex: " + selectionIndex);
  
  if (selectionIndex == 0) {
    println("Refreshing serial ports...");
    ScrollableList sl = serialPortControlFrame.cp5().get(ScrollableList.class, "dropdown_serialPort");
    sl.clear();
    sl.addItem("Refresh Serial Ports", -2);
    sl.addItem("No serial connection", -1);
    
    String[] ports = processing.serial.Serial.list();
    for (int i = 0; i < ports.length; i++) {
      println("Adding " + ports[i]);
      sl.addItem(ports[i], i);
    }
    sl.setOpen(true);
    return;
  }

  // Map selection index to port index
  // 0: Refresh
  // 1: No connection (-1)
  // 2: Port 0 (0)
  int newSerialPort = selectionIndex - 2;
  
  if (newSerialPort == -1) {
    println("Disconnecting serial port.");
    useSerialPortConnection = false;
    if (myPort != null)
    {
      myPort.stop();
      myPort = null;
    }
    drawbotReady = false;
    drawbotConnected = false;
    serialPortNumber = newSerialPort;
  } 
  else if (newSerialPort != getSerialPortNumber()) {
    println("About to connect to serial port in slot " + newSerialPort);
    // Print a list of the serial ports, for debugging purposes:
    if (newSerialPort < processing.serial.Serial.list().length) {
      try {
        drawbotReady = false;
        drawbotConnected = false;
        if (myPort != null) {
          myPort.stop();
          myPort = null;
        }
        
        if (getSerialPortNumber() >= 0) {
           String[] currentPorts = processing.serial.Serial.list();
           if (getSerialPortNumber() < currentPorts.length) {
             println("closing " + currentPorts[getSerialPortNumber()]);
           }
        }

        serialPortNumber = newSerialPort;
        String portName = processing.serial.Serial.list()[serialPortNumber];

        myPort = new processing.serial.Serial(this, portName, getBaudRate());
        //read bytes into a buffer until you get a linefeed (ASCII 10):
        myPort.bufferUntil('\n');
        useSerialPortConnection = true;
        println("Successfully connected to port " + portName);
      }
      catch (Exception e) {
        println("Attempting to connect to serial port in slot " + getSerialPortNumber() 
          + " caused an exception: " + e.getMessage());
      }
    } else {
      println("No serial ports found or invalid index.");
      useSerialPortConnection = false;
    }
  } else {
    println("no serial port change.");
  }
}

