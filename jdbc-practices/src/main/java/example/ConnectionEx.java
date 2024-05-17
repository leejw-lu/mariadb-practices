package example;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class ConnectionEx {

	public static void main(String[] args) {
		Connection connection=null;
	
		try {
			//1. JDBC Driver 로딩
			Class.forName("org.mariadb.jdbc.Driver");
			
			//2. 연결하기
			String url="jdbc:mariadb://192.168.0.207:3306/webdb?charset=utf-8"; 
			connection = DriverManager.getConnection(url, "webdb", "webdb");
			
			System.out.println("success!!");
		} catch (ClassNotFoundException e) {
			System.out.println("드라이버 로딩 실패:" + e);
		} catch (SQLException e) {
			System.out.println("error:" + e);
		} finally {
			if(connection!=null) {
				try {
					connection.close();
				} catch(SQLException e) {
					System.out.println("error:" + e);
				}
			}
		}
	}

}
