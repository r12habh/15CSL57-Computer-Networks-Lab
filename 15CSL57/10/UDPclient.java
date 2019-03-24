import java.io.*;
import java.net.*;


public class UDPclient {

	public static DatagramSocket ds;
	public static byte buffer[] = new byte[1024];
	public static int clientport = 1029, serverport = 2040;
	public static void main(String args[]) throws Exception
	{
		ds = new DatagramSocket(serverport);
		System.out.println("Server is waiting. ");
		BufferedReader dis = new BufferedReader(new InputStreamReader(System.in));
		InetAddress ia = InetAddress.getLocalHost();
		while(true)
		{
			System.out.println("Client: ");
			String str = dis.readLine();
			if(str.equals("end"))
			{
				break;
			}
			buffer = str.getBytes();
			ds.send(new DatagramPacket(buffer, str.length(), ia, clientport));
			DatagramPacket p = new DatagramPacket(buffer, buffer.length);
			ds.receive(p);
			String psx = new String(p.getData(), 0, p.getLength());
			System.out.println("Server: " + psx);
		}
	}
}

