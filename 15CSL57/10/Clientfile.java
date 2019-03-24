import java.io.*;
import java.net.*;

public class Clientfile {

	public static void main(String[] args)
	{
		try
		{
			BufferedReader in = new BufferedReader(new InputStreamReader(System.in));
			Socket clsct = new Socket("127.0.0.1", 1390);
			DataInputStream din = new DataInputStream(clsct.getInputStream());
			DataOutputStream dout = new DataOutputStream(clsct.getOutputStream());
			System.out.println("Enter file name: ");
			String str1 = in.readLine();
			dout.writeBytes(str1+'\n');
			System.out.println("Enter the new file name: ");
			String str2 = in.readLine();
			FileWriter f = new FileWriter(str2);
			while(true)
			{
				String str = din.readLine();
				if(str1.equals("-1")) break;
				System.out.println(str);
				char buffer[] = new char[str.length()];
				str.getChars(0, str.length(), buffer, 0);
				f.write(buffer, 0, buffer.length);
			}
			f.close();
			clsct.close();
		}
		catch (Exception e) {
			// TODO: handle exception
			System.out.println(e);
		}
	}
}

