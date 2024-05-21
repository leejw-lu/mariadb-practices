package bookmall.dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

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

	public OrderVo findByNoAndUserNo(Long no, Long userNo) {
		OrderVo vo = null;
	      
	    try (
	    	Connection conn = getConnection();
	        PreparedStatement pstmt = conn.prepareStatement("select no, number, payment, status, shipping from orders where no= ? and user_no= ?");
	      ){
	    	pstmt.setLong(1, no);
	    	pstmt.setLong(2, userNo);
	    	ResultSet rs = pstmt.executeQuery();

	    	if (rs.next()) {
	    		vo=new OrderVo();
	    		Long ordersNo = rs.getLong(1);
	            String number = rs.getString(2);
	            int payment = rs.getInt(3);
	            String status = rs.getString(4);
	            String shipping = rs.getString(5);
	            
	            vo.setNo(ordersNo);
	            vo.setNumber(number);
	            vo.setPayment(payment);
	            vo.setStatus(status);
	            vo.setShipping(shipping);
	    	}
	    	rs.close();
	    	
	      } catch (SQLException e) {
	         System.out.println("error:"+e);
	      }
	      
	   return vo;
	}

	public List<OrderBookVo> findBooksByNoAndUserNo(Long orderNo, Long userNo) {
		List<OrderBookVo> result = new ArrayList<>();
	      
	      try (
	    	Connection conn = getConnection();
	        PreparedStatement pstmt = conn.prepareStatement("select a.no, b.quantity, b.price, b.book_no, c.title from orders a, order_book b, book c where a.no=b.order_no and b.book_no=c.no and b.order_no=? and a.user_no=? ");
	      ){
	    	pstmt.setLong(1, orderNo);
	    	pstmt.setLong(2, userNo);
	    	ResultSet rs = pstmt.executeQuery();
	    	
	        while(rs.next()) {
	            Long orderNo2 = rs.getLong(1);
	            int quantity = rs.getInt(2);
	            int price = rs.getInt(3);
	            Long bookNo = rs.getLong(4);
	            String title = rs.getString(5);
	            
	            OrderBookVo vo = new OrderBookVo();
	            vo.setOrderNo(orderNo2);
	            vo.setQuantity(quantity);
	            vo.setPrice(price);
	            vo.setBookNo(bookNo);
	            vo.setBookTitle(title);

	            result.add(vo);
	         }
	      } catch (SQLException e) {
	         System.out.println("error:"+e);
	      }
	      
	    return result;
	}

	public void deleteBooksByNo(Long no) {
		try (
			Connection conn= getConnection();
			PreparedStatement pstmt= conn.prepareStatement("delete from order_book where order_no = ?");
		) { 
			pstmt.setLong(1, no);
			pstmt.executeUpdate();			
			} catch (SQLException e) {
				System.out.println("error:" + e);
		}
	}

	public void deleteByNo(Long no) {
		try (
			Connection conn= getConnection();
			PreparedStatement pstmt= conn.prepareStatement("delete from orders where no = ?");
		) { 
			pstmt.setLong(1, no);
			pstmt.executeUpdate();			
			} catch (SQLException e) {
				System.out.println("error:" + e);
		}
	}

}
