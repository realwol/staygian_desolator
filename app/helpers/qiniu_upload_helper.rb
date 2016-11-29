module QiniuUploadHelper
	require 'mini_magick'

	class QiNiu

    # upload image from client
    def self.upload_from_client(path)
			key = SecureRandom.hex(10)
			put_policy = Qiniu::Auth::PutPolicy.new('amazonclient', key, '31536000', '')

			uptoken = Qiniu::Auth.generate_uptoken put_policy
			code, result, response_headers = Qiniu::Storage.upload_with_put_policy(put_policy, path, key,'')
			File.delete path

			if code == 200
			  "http://updateclient.diewei2016.com/#{result["key"]}"
			else
				false
			end
    end

    # used in product grasp
		def self.upload(uri, position=nil, x_pos=nil, y_pos=nil)
			image = MiniMagick::Image.open uri
			image.combine_options do |c|
				# Do not cut in the first time
				unless position
				  # c.gravity position
				  c.draw "rectangle #{x_start},#{y_start} #{get_x_end x_pos},#{get_y_end y_pos}"
				  c.fill 'white'
				  c.resize '1001x1001'
			  else
				  c.resize '1001x1001'
				end
			end
			key = SecureRandom.hex(10)
			put_policy = Qiniu::Auth::PutPolicy.new('amazonnew', key, '31536000', '')

			uptoken = Qiniu::Auth.generate_uptoken put_policy
			code, result, response_headers = Qiniu::Storage.upload_with_put_policy(put_policy, image.path, key,'')
			if code == 200
			  "http://image.diewei2016.com/#{result["key"]}"
			else
				false
			end
		end

    # used in product update
		def self.update(uri, position, x_pos, y_pos)
      image = MiniMagick::Image.open uri
			x_start, y_start = get_start position
      unless position.blank? || x_pos.blank? || y_pos.blank?
	      image.combine_options do |c|
	        # c.gravity position
				  c.draw "rectangle #{x_start},#{y_start} #{get_x_end x_pos},#{get_y_end y_pos}"
	        c.fill 'white'
	        c.resize '1001x1001'
				end
			end

      key = SecureRandom.hex(10)
			put_policy = Qiniu::Auth::PutPolicy.new('amazonupdate', key, '31536000', '')
			uptoken = Qiniu::Auth.generate_uptoken put_policy
			code, result, response_headers = Qiniu::Storage.upload_with_put_policy(put_policy, image.path, key,'')
			if code == 200
			  "http://updateimage.diewei2016.com/#{result["key"]}"
			else
				false
			end
		end

		def self.get_x_end x
			(x.to_i + 5) * (1001.0/450)
		end

		def self.get_y_end y
			(y.to_i + 5) * (1001.0/350)
		end

		def self.get_start position
			if position.blank?
				x = 0
				y = 0
			else
				case position
				when 'NorthWest'
					x = 0
					y = 0
				when 'NorthEast'
					x = 1002
					y = 0
				when 'SouthEast'
					x = 1002
					y = 1002
				when 'SouthWest'
					x = 0
					y = 1002
				end
			end
			return x, y
		end
	end
end
