package bookshop.example;

public class Book {
	private int bookNo;
	private String title;
	private String author;
	int stateCode;	//재고 있음. 0이면 재고 없음

	public Book(int bookNo,String title,String author) {
		this.bookNo=bookNo;
		this.title=title;
		this.author=author;
		this.stateCode=1;
	}
	
	public int getBookNo() {
		return bookNo; 
	}

	public void setBookNo(int bookNo) {
		this.bookNo = bookNo;
	}

	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
	}

	public String getAuthor() {
		return author;
	}

	public void setAuthor(String author) {
		this.author = author;
	}

	public int getStateCode() {
		return stateCode;
	}

	public void setStateCode(int stateCode) {
		this.stateCode = stateCode;
	}

	//책 대여
	public void rent(Book b) {
		if (b.getStateCode()==1) {
			b.setStateCode(0);
			System.out.println(b.getTitle()+ "이(가) 대여됐습니다.");
		}
	}
	
	//굿즈 정보 출력
	public void print(Book b) {
		//책번호:1, 책 제목:트와일라잇, 작가:스테파니메이서, 대여 유무: 재고있음
		
		String stock="재고있음";
		if (b.getStateCode()==0) {
			stock="대여중";
		}
		
		System.out.println("책번호:"+b.getBookNo()+", "+ "책 제목:"+ b.getTitle()+
				", 작가:"+ b.getAuthor()+", 대여 유무:"+ stock);
	}


}
