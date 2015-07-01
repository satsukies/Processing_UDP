import hypermedia.net.*;

UDP udp;
int portNo = 31416;
String ipAddress = "localhost";

int SEND_BUFFER_SIZE = 8;
byte[] sendBuffer = new byte[SEND_BUFFER_SIZE];
    
void setup(){
  size(800, 600);
  
  /* Initialize UDP Client */
  udp = new UDP(this);
  udp.setBuffer(SEND_BUFFER_SIZE);    // 8byte(int x 2)
  background(255);
}

void draw(){
  background(255);
  if ( mousePressed == true ){
    send();
    ellipse( mouseX, mouseY, 10, 10 );
    println("S:" + mouseX + " " + mouseY);
  }
}

/* Send */
void send(){
  byte[] tmpArray;
  tmpArray = intToByteArray(mouseX);
  sendBuffer[0] = tmpArray[0];
  sendBuffer[1] = tmpArray[1];
  sendBuffer[2] = tmpArray[2];
  sendBuffer[3] = tmpArray[3];
  tmpArray = intToByteArray(mouseY);
  sendBuffer[4] = tmpArray[0];
  sendBuffer[5] = tmpArray[1];
  sendBuffer[6] = tmpArray[2];
  sendBuffer[7] = tmpArray[3];    

  /* send message here */
  udp.send(sendBuffer, ipAddress, portNo);
}

/* byte[] to int(OMAJINAI) */
int byteArrayToInt(byte[] b) {
  return b[3] & 0xFF | (b[2] & 0xFF) << 8 | (b[1] & 0xFF) << 16 | (b[0] & 0xFF) << 24;
}

/* int to byte[](OMAJINAI) */
byte[] intToByteArray(int a){
  return new byte[] {
    (byte) ((a >> 24) & 0xFF), (byte) ((a >> 16) & 0xFF), (byte) ((a >> 8) & 0xFF),(byte) (a & 0xFF)
  };
}

