require 'httparty'
require 'json'
require 'awesome_print'
require 'rest-client'
require 'csv'

headers = {
	cookie: "__uvt=; _s_guit=cabe67530dae7ed9ad7fee3ac6de948aafcb2abf8cfd4dcdadeb0dd4006c; autologin_auth_key=---%0A%3Aid%3A+3309876%0A%3Atoken%3A+%22%246%24NDIBVmJi%24hFAy9Sca7cEtfRjcZq9XIaw.uoJUww%2FCR%2Fq1vgRdH3wLbPesQaW172LfkYJzh1g1NDPr4Pul7ADSu4Xw2IQPT.%22%0A; watcha_fb_joined=true; share_facebook=true; fbm_126765124079533=base_domain=.watcha.net; _ga=GA1.2.1311138704.1510904438; _gid=GA1.2.1300338211.1511237820; _gat=1; _guinness_session=Lzl4Ullybi9PUmI2OElqVEtBUmdhRkpDL05DS1E3MENaUjRtaktmQ1VsSEE4a3BrcHpLRU9DMjluWkpDTXpFVlJvWDBlWnNKeG8vV1BTdU9leVZLN05halpSenZ3RTVHSHlnV3hHcHl3NEJvV3VkSVJvT0loTzdwbVBncUJkZlBQYlAzYkRiSmJuN2R2eDdrNzNzOEdXSEJMcGg4U3Vwa2ljdm5KdUkwaE51cDVNMTh5dFU1ZFdJTzJCMDU5ZzJDLS1tOVNzbjEyemZlazN0eVBLNXlJU0lBPT0%3D--c933fa5b06f4bfca31668490b0795be5087b7841; fbsr_126765124079533=zFJ4Si3iK6U6yC_JOjEVUjfzAiYfmBOSUvMvlCixVus.eyJhbGdvcml0aG0iOiJITUFDLVNIQTI1NiIsImNvZGUiOiJBUURzeVRqS3FCdlhmdG9WTWl6ZzM5MzJNQU1rYUYzdTBrMkdVbjdKVTVPdmF6WF82ZkxDWjNqcE1xZGMwNkN5LW9IdXBMMEhna1JnT3pGUnlvX1d1QXNJc25acnQ5XzNCalhaNW10Rl84a1U3OVFIYlRGQTgtZWN4RHVLdUZidnBmVVVaY1I2aFhybjhBcmpBWHJNSzRaWW9hNVdmdkgwVEdmVHlzc3BqSzBTa2ExV2tlV0diY3NMdm96aHlPV0xlU3d5dTg3QXg0OXRXYVVITjJNMHFyc29mMjJQT3YxS3NqdFpvalVRNkZ0NW9EcW9fbUtJU09hTDMzaEtndUFYeVpCdm9HZHRnNThJaTJqZE92RmUxMktBYXZSdkJaX2djQVNUSzRmd2tZdWJiSG9JYlh0eUd0bk1nNS1CV2VhRk05Tk8yWHh3WFpQUmxnRC0zb0FoNDZJVCIsImlzc3VlZF9hdCI6MTUxMTIzODE5OSwidXNlcl9pZCI6IjE1MDI3OTg3MTk3OTY4NTIifQ; uvts=6m4LCIqC6GZJTSx3"
}

res = HTTParty.get("https://watcha.net/boxoffice.json", :headers => headers)

watcha = JSON.parse(res.body)
list = watcha["cards"]
# ap list.class.to_s

list.each do |item|
	movie = item["items"].first["item"]
	title =  movie["title"]
	image =  movie["poster"]["large"]
	desc = movie["interesting_comment"]["text"] if movie["interesting_comment"]

	CSV.open("movie_list.csv","a+") do |movie|
		movie << [title, image, desc]
	end
end

# title =  watcha["cards"].first["items"].first["item"]["title"]
# image =  watcha["cards"].first["items"].first["item"]["poster"]["large"]
# desc = watcha["cards"].first["items"].first["item"]["interesting_comment"]["text"]

# CSV.open("movie_list.csv","wb") do |movie|
# 	movie << [title, image, desc]
# end