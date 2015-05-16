module QiniuUploadHelper
	require 'mini_magick'
	class QiNiu
		def self.upload(uri, cut_type)
			name = Time.now.to_i
			image = MiniMagick::Image.open uri
			path = Rails.root.join('public', "#{name}.jpg")
			cut_position = get_cut_position cut_type
			image.combine_options do |c|
				# Do not cut in the first time
				# c.gravity cut_position
				# c.draw 'rectangle 0,0 400,200'
				# c.fill 'whites'
				c.resize '1200x1200'
			end
			image.write path

			key = Time.now.to_i
			put_policy = Qiniu::Auth::PutPolicy.new('amazon', key, '31536000', '')

			uptoken = Qiniu::Auth.generate_uptoken put_policy
			code, result, response_headers = Qiniu::Storage.upload_with_put_policy(put_policy, path, key,'')
			File.delete path

			if code == 200
			  image_link = "http://7xj377.com1.z0.glb.clouddn.com/#{result["key"]}"
			else
				false
			end
		end

		def self.get_cut_position cut_type
			'NorthWest'
		end
	end
end