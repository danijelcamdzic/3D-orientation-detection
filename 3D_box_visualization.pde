import java.awt.event.KeyEvent;
import java.io.IOException;
import processing.serial.*;

Serial UARTPort;
float roll, pitch,yaw;      // Used to store roll, pitch and yaw
String serial_data="";      // Receiving data from the microcontroller in a string

void setup() {
  size( 1200, 650, P3D );   // Size of the window
  UARTPort = new Serial(this, "COM3", 115200);  // The port is COM3
  UARTPort.bufferUntil('\n');
}

void draw() {
  translate(width/2, height/2, 0);
  background(255);
  textSize(20);
  text("Pitch: " + int(pitch) + "     Roll: " + int(roll) + "     Yaw: " + int(yaw), -120, 300);
  
  // Correctly moving the box as per real-life motion directions
  rotateZ(radians(pitch));  
  rotateX(radians(-roll));
  rotateY(radians(yaw));
  
  // Drawing the box that represent the sensor
  textSize(50);  
  fill(0, 150, 150);
  box (200, 50, 200);
  fill(0, 0, 0);
}

void serialEvent (Serial UARTPort) { 
  // Reading until we reach a new line dictated by the microcontroller
  serial_data = UARTPort.readStringUntil('\n');
  
  if (serial_data != null) {
    serial_data = trim(serial_data);
    String parts[] = split(serial_data, '/');
    if (parts.length > 1) {
      roll = float(parts[0]);      // Getting roll
      pitch = float(parts[1]);     // Getting pitch
      yaw = float(parts[2]);       // Getting yaw
    }
  }
}
