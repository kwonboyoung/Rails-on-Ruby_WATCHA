1. git bash
2. cd ~/project
3. vagrant up
4. vagrant ssh
5. [vagrant] cd /vagrant -- window이 ~/project와 연결되어 있음
6. 프로젝트 생성

```ruby
rails new real_board[프로젝트 이름] --skip-bundle[초기 번들링 하지 않음]
```

```ruby
gem 'awesome_print'
gem 'pry-rails'
gem 'rails_db'
gem 'better_errors'
```

* cd [프로젝트 이름] -> bundle install

```ruby
rails g scaffold movie title desc:text
```

* 새로운 git bash

* windows cd ~/project/[프로젝트 이름] -> atom .(프로젝트 atom으로 열기)

  ```ruby
  rake db:migrate
  ```



- gem 'devise'

  ```ruby
  ubuntu@ubuntu-xenial:/vagrant/real_board$ rails g devise:install
  ubuntu@ubuntu-xenial:/vagrant/real_board$ rails g devise USER
  ubuntu@ubuntu-xenial:/vagrant/real_board$ rake db:migrate
  ```

  - layout -> application.html

    ```ruby
    <%= link_to '홈으로', root_path %>
    <% if user_signed_in? %>
    <%= link_to '로그아웃', destroy_user_session_path, method: :delete %>
    <%= current_user.email%>님 환영합니다♥
    <%else%>
    <%= link_to '로그인', new_user_session_path %>
    <%end%>
    ```

  - model -> movie.rb

    ```ruby
    class Movie < ActiveRecord::Base
    	mount_uploader :user_id, PhotoUploader
    end
    ```

  - movies_controller => index와 show를 빼고 로그인해야해!!

    ```ruby
    before_action :authenticate_user!, except: [:index, :show]
    ```

  ​

- gem 'carrierwave'

  ```ruby
  ubuntu@ubuntu-xenial:/vagrant/real_board$ rails g uploader Photo
  ubuntu@ubuntu-xenial:/vagrant/real_board$ rails g migration add_image_url_to_movies image_url:string
  ubuntu@ubuntu-xenial:/vagrant/real_board$ rails g migration add_user_id_to_movies user_id:integer
  ubuntu@ubuntu-xenial:/vagrant/real_board$ rake db:migrate
  ```

  - movies_controller.rb

    ```ruby
    def movie_params
      params.require(:movie).permit(:title, :desc, :photo_url)
    end
    ```

  - index.html.erb

    ```ruby
    <%= image_tag "#{movie.image_url}",  height: '64', width: '64'  %>
    ```

  - form.html.erb

    ```ruby
    <div class="field">
      <%= f.label :image_url %><br>
      <%= f.file_field :image_url %>
    </div>

    ```

  - show.html.erb

    ```ruby
    <p>
      <strong>ImageUrl:</strong>
      <%= @movie.image_url %>
    </p>
    ```

    ​

- gem 'kaminari'

  ```ruby
  view->index.html.erb에서
  <%= paginate @movies %>
  ```

  ```ruby
  movies_controller.rb에서
  def index
    # @movies=Movie.all
    # :id => :desc 를 줄여서 id: :desc
    @movies = Movie.order(id: :desc).page params[:page]
  end
  ```



- db id 역순서

  ```ruby
  movies_controller.rb에서
    def index
      # @movies=Movie.all
      # :id => :desc 를 줄여서 id: :desc
      @movies = Movie.order(id: :desc).page params[:page]
    end
  ```



* gem 'devise-i18n' => 국제화 대응(internationalization)

```ruby
config-> application.rb에서
config.time_zone = 'Seoul'
config.i18n.default_locale = :ko
```

```ruby
ubuntu@ubuntu-xenial:/vagrant/real_board$ rails g devise:i18n:locale ko
ubuntu@ubuntu-xenial:/vagrant/real_board$ rails g devise:i18n:views
```

 => devise.views.ko.yml 에서 글귀를 바꿀 수 있음



* crawling 연습

  - chrome extension에 json viewer 다운받으면 쉬움.

  ```ruby
  require 'httparty'
  require 'json'
  require 'awesome_print'
  require 'rest-client'

  headers = {
  	cookie: "__uvt=; _s_guit=cabe67530dae7ed9ad7fee3ac6de948aafcb2abf8cfd4dcdadeb0dd4006c; autologin_auth_key=---%0A%3Aid%3A+3309876%0A%3Atoken%3A+%22%246%24NDIBVmJi%24hFAy9Sca7cEtfRjcZq9XIaw.uoJUww%2FCR%2Fq1vgRdH3wLbPesQaW172LfkYJzh1g1NDPr4Pul7ADSu4Xw2IQPT.%22%0A; watcha_fb_joined=true; share_facebook=true; fbm_126765124079533=base_domain=.watcha.net; _ga=GA1.2.1311138704.1510904438; _gid=GA1.2.1300338211.1511237820; _gat=1; _guinness_session=Lzl4Ullybi9PUmI2OElqVEtBUmdhRkpDL05DS1E3MENaUjRtaktmQ1VsSEE4a3BrcHpLRU9DMjluWkpDTXpFVlJvWDBlWnNKeG8vV1BTdU9leVZLN05halpSenZ3RTVHSHlnV3hHcHl3NEJvV3VkSVJvT0loTzdwbVBncUJkZlBQYlAzYkRiSmJuN2R2eDdrNzNzOEdXSEJMcGg4U3Vwa2ljdm5KdUkwaE51cDVNMTh5dFU1ZFdJTzJCMDU5ZzJDLS1tOVNzbjEyemZlazN0eVBLNXlJU0lBPT0%3D--c933fa5b06f4bfca31668490b0795be5087b7841; fbsr_126765124079533=zFJ4Si3iK6U6yC_JOjEVUjfzAiYfmBOSUvMvlCixVus.eyJhbGdvcml0aG0iOiJITUFDLVNIQTI1NiIsImNvZGUiOiJBUURzeVRqS3FCdlhmdG9WTWl6ZzM5MzJNQU1rYUYzdTBrMkdVbjdKVTVPdmF6WF82ZkxDWjNqcE1xZGMwNkN5LW9IdXBMMEhna1JnT3pGUnlvX1d1QXNJc25acnQ5XzNCalhaNW10Rl84a1U3OVFIYlRGQTgtZWN4RHVLdUZidnBmVVVaY1I2aFhybjhBcmpBWHJNSzRaWW9hNVdmdkgwVEdmVHlzc3BqSzBTa2ExV2tlV0diY3NMdm96aHlPV0xlU3d5dTg3QXg0OXRXYVVITjJNMHFyc29mMjJQT3YxS3NqdFpvalVRNkZ0NW9EcW9fbUtJU09hTDMzaEtndUFYeVpCdm9HZHRnNThJaTJqZE92RmUxMktBYXZSdkJaX2djQVNUSzRmd2tZdWJiSG9JYlh0eUd0bk1nNS1CV2VhRk05Tk8yWHh3WFpQUmxnRC0zb0FoNDZJVCIsImlzc3VlZF9hdCI6MTUxMTIzODE5OSwidXNlcl9pZCI6IjE1MDI3OTg3MTk3OTY4NTIifQ; uvts=6m4LCIqC6GZJTSx3"
  }

  res = HTTParty.get("https://watcha.net/boxoffice.json", :headers => headers)

  watcha = JSON.parse(res.body)
  ap watcha

  # 키 찾을 때
  title =  watcha["cards"].first["items"].first["item"].keys

  # title 뽑기
  title = watcha["cards"][0]["items"][0]["item"]["title"]

  # desc 뽑기
  desc = watcha["cards"][0]["items"][0]["item"]["interesting_comment"]["text"]

  # image 뽑기
  image = watcha["cards"].first["items"].first["item"]["poster"]["large"]

  # csv 파일로 만들기
  CSV.open("movie_list.csv","wb") do |movie|
    movie << [title, image, desc]
  end

  # 모든 json csv 파일로 읽기
  list = watcha["cards"]
  list.each do |item|
  	movie = item["items"].first["item"]
  	title =  movie["title"]
  	image =  movie["poster"]["large"]
  	desc = movie["interesting_comment"]["text"] if movie["interesting_comment"]

    	# a+ : append / wb : write
  	CSV.open("movie_list.csv","a+") do |movie|
  		movie << [title, image, desc]
  	end
  end
  ```



* csv 파일을 이용하여 seeding

```ruby
# 절대경로 찾는 법
ubuntu@ubuntu-xenial:/vagrant/real_board$ rails console
Loading development environment (Rails 4.2.9)
[1] pry(main)> Rails.root
=> #<Pathname:/vagrant/real_board>
[2] pry(main)> filepath = Rails.root + '/movie_list.csv'
=> #<Pathname:/movie_list.csv>
[3] pry(main)> Rails.root.join('app')
=> #<Pathname:/vagrant/real_board/app>
[4] pry(main)> Rails.root.join('app','view')
=> #<Pathname:/vagrant/real_board/app/view>
[5] pry(main)> Rails.root.join('app','views')
=> #<Pathname:/vagrant/real_board/app/views>
```

```ruby
# seed.rb에서
require 'csv'

CSV.foreach(Rails.root.join('movie_list.csv')) do |row|
	Movie.create(
		title: row[0],
		remote_image_url_url: row[1],
		desc: row[2]
	)
end
```

```ruby
ubuntu@ubuntu-xenial:/vagrant/real_board$ rake db:drop
ubuntu@ubuntu-xenial:/vagrant/real_board$ rake db:migrate
ubuntu@ubuntu-xenial:/vagrant/real_board$ rake db:seed
```



* radio button

  ```ruby
  <%= radio_button_tag(:rating, "1") %>
  <%= label_tag(:point_1, "1") %>
  <%= radio_button_tag(:rating, "2") %>
  <%= label_tag(:point_2, "2") %>
  <%= radio_button_tag(:rating, "3") %>
  <%= label_tag(:point_3, "3") %>
  <%= radio_button_tag(:rating, "4") %>
  <%= label_tag(:point_4, "4") %>
  <%= radio_button_tag(:rating, "5") %>
  <%= label_tag(:point_5, "5") %>
  ```



* m:n 관계 설정

```ruby
ubuntu@ubuntu-xenial:/vagrant/real_board$ rails g model review movie:references comment:text rating:integer user:references
```

```ruby
class Movie < ActiveRecord::Base
	mount_uploader :image_url, PhotoUploader
	has_many :reviews
end

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :reviews
end
```

```ruby
ubuntu@ubuntu-xenial:/vagrant/real_board$ rails c
Loading development environment (Rails 4.2.9)
[1] pry(main)> movie = Movie.first
  Movie Load (1.2ms)  SELECT  "movies".* FROM "movies"  ORDER BY "movies"."id" ASC LIMIT 1
=> #<Movie:0x000055dd8cf90438
 id: 1,
 title: "꾼",
 desc:
  "배우들의 몸짓, 언어, 표정, 감정을 잡아내는 데에 관심이 없다.(황지성 입에 붙은 테이프에만 관심이 있더라!) 끊이지 않는 음악을 타고 이야기는 꾸역꾸역 넘어가는데 그 어떤 정서적 쾌감도 동하질 않는다. 화면빨도 좋고, 배우빨도 서고, 이빨도 좀 까는데, 여기저기 널린 좋은 것들을 제대로 정리하지 못한다. 장르상 으레 기대하는 액션도 없고 애초에 관객에게 두뇌 싸움을 제안한 듯 하지만 펼쳐 놓은 실타래가 엉켜 어수선할 뿐이다.\n‘황지성’으로 분한 ‘현빈’은 근래 무겁던 탈을 벗고 유쾌한 톤으로 돌아왔다. 역시 양복이 잘 어울리는 귀공자다. ‘배성우(고석동 역)’, ‘박성웅(곽승건 역)’, ‘나나(춘자 역)’도 각자 맡은 바 역할을 무난히 소화해낸다. 다만 ‘박희수’ 역을 맡은 ‘유지태’는 ‘황지성’보다 더 바쁘게 움직여 정신이 사나울 정도다. 주인공보다 더 바쁜 악당역도 오랜만인데 감정 연결이 제대로 이뤄지지 않아 노력한 바가 드러나지 않는다. 좋은 배우인데 아쉽다.\nat MEGABOX 코엑스 컴포트 9관 VIP 시사회, with 김종민",
 created_at: Tue, 21 Nov 2017 16:09:37 KST +09:00,
 updated_at: Tue, 21 Nov 2017 16:09:37 KST +09:00,
 image_url: "vmpxcjcjmlo2wgmgplb6.jpg",
 user_id: nil>
[2] pry(main)> movie.reviews
  Review Load (1.2ms)  SELECT "reviews".* FROM "reviews" WHERE "reviews"."movie_id" = ?  [["movie_id", 1]]
=> []
[3] pry(main)> Review.all
  Review Load (1.1ms)  SELECT "reviews".* FROM "reviews"
=> [#<Review:0x000055dd8ce04128
  id: 1,
  movie_id: 15,
  comment: "와 재미써",
  rating: 3,
  user_id: nil,
  created_at: Tue, 21 Nov 2017 16:23:44 KST +09:00,
  updated_at: Tue, 21 Nov 2017 16:23:44 KST +09:00>]
```



* 평균 평점 매기기

  - 방법 1

  ```ruby
  # controller에서  
  def show
      @sum = 0
     	@movie.reviews.each do |review|
      @sum += review.rating
      end
      if @movie.reviews.count==0
        @avg =0
      else
        @avg =@sum.to_f/@movie.reviews.size
      end
    end
  ```

  ```ruby
  평균 평점 : <%= @avg %>
  ```

  - 방법 2

    ```ruby
    # movie model에서
    def avg
    	total = 0
    	reviews.each do |r| 		
        total += r.rating
    	end
    	if reviews.count==0
    		0 	
        else
    		total.to_f/reviews.count
    	end
    end
    ```

    ```ruby
    평균 평점 : <%= @movie.avg %>
    ```

  - 방법 3

    ```ruby
    평균 평점 : <%= @movie.reviews.average(:rating)%>
    ```

    ​