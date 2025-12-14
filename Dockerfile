# --- GIAI ĐOẠN 1: Build thủ công (Không dùng Ant của NetBeans) ---
# Dùng image có sẵn JDK và Tomcat để có đủ thư viện biên dịch
FROM tomcat:9.0-jdk8-openjdk AS build
WORKDIR /app

# Copy toàn bộ source code vào
COPY . .

# 1. Tạo thư mục chứa file .class sau khi compile
RUN mkdir -p web/WEB-INF/classes

# 2. Tạo thư mục chứa thư viện và copy các file .jar vào đó
# (Để web chạy được thì thư viện phải nằm trong WEB-INF/lib)
RUN mkdir -p web/WEB-INF/lib && cp lib/*.jar web/WEB-INF/lib/

# 3. Biên dịch Code (Compile)
# -cp: Chỉ định thư viện (gồm lib của bạn và lib của Tomcat như servlet-api)
# -d: Nơi xuất file .class
# lệnh find: tìm tất cả file .java trong source để compile
RUN find src -name "*.java" > sources.txt && \
    javac -cp "web/WEB-INF/lib/*:/usr/local/tomcat/lib/*" -d web/WEB-INF/classes @sources.txt

# 4. Đóng gói thành file .war
# -C web .: Chuyển vào thư mục web và nén tất cả lại
RUN jar -cvf ROOT.war -C web .

# --- GIAI ĐOẠN 2: Run (Chạy web) ---
FROM tomcat:9.0-jre8-openjdk-slim

# Xóa ứng dụng mặc định của Tomcat cho sạch
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy file .war vừa tạo ở trên vào thư mục chạy của Tomcat
COPY --from=build /app/ROOT.war /usr/local/tomcat/webapps/ROOT.war

# Mở cổng 8080
EXPOSE 8080

# Chạy server
CMD ["catalina.sh", "run"]
