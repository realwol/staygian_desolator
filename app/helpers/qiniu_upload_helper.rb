module QiniuUploadHelper
	require 'mini_magick'
	class QiNiu
		def self.upload(uri, position=nil, x_pos=nil, y_pos=nil)
			name = Time.now.to_i
			image = MiniMagick::Image.open uri
			path = Rails.root.join('public', "#{name}.jpg")
			image.combine_options do |c|
				# Do not cut in the first time
				unless position
				  c.gravity position
				  c.draw "rectangle 0,0 #{get_x_end x_pos},#{get_y_end y_pos}"
				  c.fill 'white'
				  c.resize '1001x1001'
			  else
				  c.resize '1001x1001'
				end
			end
			image.write path

			key = Time.now.to_i
			put_policy = Qiniu::Auth::PutPolicy.new('amazon', key, '31536000', '')

			uptoken = Qiniu::Auth.generate_uptoken put_policy
			code, result, response_headers = Qiniu::Storage.upload_with_put_policy(put_policy, path, key,'')
			File.delete path

			if code == 200
			  "http://7xj377.com1.z0.glb.clouddn.com/#{result["key"]}"
			else
				false
			end
		end

		def self.update(uri, position, x_pos, y_pos)
      image = MiniMagick::Image.open uri
      path = Rails.root.join('public', "#{name}.jpg")
      image.combine_options do |c|
        c.gravity position
        c.draw "rectangle 0,0 #{get_x_end(x_pos)},#{get_y_end(y_pos)}"
        c.fill 'white'
        c.resize '1001x1001'
			end
			image.write path

			key = uri[(uri.index('com/')+4)..-1]
			put_policy = Qiniu::Auth::PutPolicy.new('amazon', key, '31536000', '')

			uptoken = Qiniu::Auth.generate_uptoken put_policy
			code, result, response_headers = Qiniu::Storage.upload_with_put_policy(put_policy, path, key,'')
			File.delete path

			if code == 200
			  "http://7xj377.com1.z0.glb.clouddn.com/#{result["key"]}"
			else
				false
			end
		end

		def self.get_x_end x
			x.to_i * (1001.0/450)
		end

		def self.get_y_end y
			y.to_i * (1001.0/350)
		end
	end
end