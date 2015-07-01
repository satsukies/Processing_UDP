import hypermedia.net.*;

UDP udp;
int portNo = 31416;

/* Network Data */
class NetworkData{
  int x;    // 4byte integer
  int y;    // 4byte integer
}

boolean flagReceived = false;

NetworkData receiveBuffer;

void setup(){
  
  size(800, 600);
  
  /* Initialize UDP Server */
  udp = new UDP(this, portNo);
  udp.setBuffer(8);
  udp.setReceiveHandler("received");
  udp.listen(true);
  
  receiveBuffer = new NetworkData();
  receiveBuffer.x = receiveBuffer.y = 0;
  background(255);
}

void draw(){
  if (flagReceived == true){
    point( receiveBuffer.x, receiveBuffer.y );
    ellipse( receiveBuffer.x, receiveBuffer.y, 10, 10 );
    flagReceived = false;
  }
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

/* UDP receive callback function */
void received(byte[] data, String hostIP, int portNo){
  byte[] tmpArray = new byte[4];
  tmpArray[0] = data[0];
  tmpArray[1] = data[1];
  tmpArray[2] = data[2];
  tmpArray[3] = data[3];
  receiveBuffer.x = byteArrayToInt(tmpArray);
  tmpArray[0] = data[4];
  tmpArray[1] = data[5];
  tmpArray[2] = data[6];
  tmpArray[3] = data[7];  
  receiveBuffer.y = byteArrayToInt(tmpArray);
  flagReceived = true;
  println("R:" + receiveBuffer.x + " " + receiveBuffer.y);
}

