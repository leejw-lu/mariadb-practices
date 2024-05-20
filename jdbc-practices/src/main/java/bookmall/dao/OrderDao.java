package bookmall.dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import bookmall.vo.BookVo;
import bookmall.vo.OrderBookVo;
import bookmall.vo.OrderVo;

public class OrderDao {
	private Connection getConnection() throws SQLException {
		Connection conn=null;
		
		try {
			Class.forName("org.mariadb.jdbc.Driver");
			
			String url="jdbc:mariadb://192.168.0.207:3306/bookmall?charset=utf-8"; 
			conn = DriverManager.getConnection(url, "bookmall", "bookmall");
		} catch (ClassNotFoundException e) {
			System.out.println("드라이버 로딩 실패:" + e);
		}
		
		return conn;
	}

	public int insert(OrderVo vo) {
	      int result = 0;
	      
	      try (
	    	Connection conn = getConnection();
	        PreparedStatement pstmt1 = conn.prepareStatement("insert into orders values(null, ?, ?, ?, ?, ?)");
	        PreparedStatement pstmt2 = conn.prepareStatement("select last_insert_id() from dual");
	      ){
	    	 //바인딩
	         pstmt1.setString(1, vo.getNumber());
	         pstmt1.setString(2, vo.getStatus());
	         pstmt1.setLong(3, vo.getPayment());
	         pstmt1.setString(4, vo.getShipping());
	         pstmt1.setLong(5, vo.getUserNo());

	         result = pstmt1.executeUpdate();
	         
	         ResultSet rs = pstmt2.executeQuery();
	         vo.setNo(rs.next() ? rs.getLong(1) : null);
	         rs.close();
	      } catch (SQLException e) {
	         System.out.println("error:"+e);
	      }
	      
	      return result;
	   }

	public void insertBook(OrderBookVo vo) {
		try (
			Connection conn = getConnection();
		    PreparedStatement pstmt1 = conn.prepareStatement("insert into order_book values(?, ?, ?, ?)");
		){
			//바인딩
			pstmt1.setLong(1, vo.getQuantity());
			pstmt1.setLong(2, vo.getPrice());
		    pstmt1.setLong(3, vo.getBookNo());
		    pstmt1.setLong(4, vo.getOrderNo());
		    
		    pstmt1.executeUpdate();
		    
		 } catch (SQLException e) {
		         System.out.println("error:"+e);
		 }
	}
}
