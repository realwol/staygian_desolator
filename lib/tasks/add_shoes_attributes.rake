# not used
namespace :add_data do
	desc 'add_shoes_attributes'
	task :add_shoes_attributes => :environment do
		new_array = []
		new_array << {name:'二层猪皮', england:'Leather', germany:'Leder', france:'cuir', spain:'Cuero', italy:'Leather'}
		new_array << {name:'塑胶', england:'Synthetic', germany:'Synthetik', france:'synthétique', spain:'Sintético', italy:'sintetico'}
		new_array << {name:'太空革', england:'Leather', germany:'Leder', france:'synthétique', spain:'Cuero', italy:'Leather'}
		new_array << {name:'头层牛皮', england:'Leather', germany:'Leder', france:'cuir', spain:'Cuero', italy:'Leather'}
		new_array << {name:'孔雀皮', england:'Leather', germany:'Leder', france:'cuir', spain:'Cuero', italy:'Leather'}
		new_array << {name:'树脂', england:'Rubber', germany:'Synthetik', france:'synthétique', spain:'Sintético', italy:'sintetico'}
		new_array << {name:'毛线', england:'Wool', germany:'Wolle', france:'laine', spain:'Lana', italy:'Wool'}
		new_array << {name:'毛线', england:'Wool', germany:'Wolle', france:'laine', spain:'Lana', italy:'Wool'}
		new_array << {name:'牛二层皮覆膜', england:'Leather', germany:'Leder', france:'cuir', spain:'Cuero', italy:'Leather'}
		new_array << {name:'牛仔布', england:'Canvas', germany:'Canvas', france:'toile', spain:'Lona', italy:'Tela'}
		new_array << {name:'牛反绒（磨砂皮）', england:'Velvet', germany:'Samt', france:'velours', spain:'Terciopelo', italy:'velluto'}
		new_array << {name:'珍珠鱼皮', england:'Leather', germany:'Leder', france:'cuir', spain:'Cuero', italy:'Leather'}
		new_array << {name:'网布', england:'Canvas', germany:'Canvas', france:'toile', spain:'Lona', italy:'Tela'}
		new_array << {name:'羊反绒（羊猄）', england:'Velvet', germany:'Samt', france:'velours', spain:'Terciopelo', italy:'velluto'}
		new_array << {name:'羊皮（除反羊绒/羊猄）', england:'Leather', germany:'Leder', france:'cuir', spain:'Cuero', italy:'Leather'}
		new_array << {name:'羊驼皮', england:'Leather', germany:'Leder', france:'cuir', spain:'Cuero', italy:'Leather'}
		new_array << {name:'藤草', england:'Synthetic', germany:'Synthetik', france:'synthétique', spain:'Terciopelo', italy:'sintetico'}
		new_array << {name:'蛇皮', england:'Leather', germany:'Leder', france:'cuir', spain:'Cuero', italy:'Leather'}
		new_array << {name:'蜥蜴皮', england:'Leather', germany:'Leder', france:'cuir', spain:'Cuero', italy:'Leather'}
		new_array << {name:'袋鼠皮', england:'Leather', germany:'Leder', france:'cuir', spain:'Cuero', italy:'Leather'}
		new_array << {name:'裘皮', england:'Leather', germany:'Leder', france:'cuir', spain:'Cuero', italy:'Leather'}
		new_array << {name:'西施绒', england:'Velvet', germany:'Samt', france:'velours', spain:'Terciopelo', italy:'velluto'}
		new_array << {name:'超细纤维', england:'Synthetic', germany:'Synthetik', france:'synthétique', spain:'Sintético', italy:'sintetico'}
		new_array << {name:'马皮', england:'Leather', germany:'Leder', france:'cuir', spain:'Cuero', italy:'Leather'}
		new_array << {name:'鳗鱼皮', england:'Leather', germany:'Leder', france:'cuir', spain:'Cuero', italy:'Leather'}
		new_array << {name:'鹿皮', england:'Leather', germany:'Leder', france:'cuir', spain:'Cuero', italy:'Leather'}
		new_array << {name:'麂皮', england:'Leather', germany:'Leder', france:'cuir', spain:'Cuero', italy:'Leather'}
		new_array << {name:'头层猪皮', england:'Leather', germany:'Leder', france:'cuir', spain:'Cuero', italy:'Leather'}
		new_array << {name:'PU', england:'Leather', germany:'Leder', france:'cuir', spain:'Cuero', italy:'Leather'}
		new_array << {name:'鸵鸟皮', england:'Leather', germany:'Leder', france:'cuir', spain:'Cuero', italy:'Leather'}
		new_array << {name:'鳄鱼皮', england:'Leather', germany:'Leder', france:'cuir', spain:'Cuero', italy:'Leather'}
		new_array << {name:'布', england:'Canvas', germany:'Canvas', france:'toile', spain:'Lona', italy:'Tela'}
		new_array << {name:'马毛', england:'Velvet', germany:'Wolle', france:'laine', spain:'Lana', italy:'Wool'}
		new_array << {name:'绸缎', england:'Silk', germany:'Satin', france:'satin', spain:'Seda', italy:'seta'}
		new_array << {name:'绒面', england:'Velvet', germany:'Samt', france:'velours', spain:'Terciopelo', italy:'velluto'}
		new_array << {name:'呢子', england:'Felt', germany:'Filz', france:'feutre', spain:'Fieltro', italy:'feltro'}
		new_array << {name:'亮片布', england:'Canvas', germany:'Canvas', france:'toile', spain:'Lona', italy:'Tela'}
		new_array << {name:'灯芯绒', england:'Velvet', germany:'Samt', france:'velours', spain:'Terciopelo', italy:'velluto'}
		new_array << {name:'其他', england:'Synthetic', germany:'Synthetik', france:'synthétique', spain:'Sintético', italy:'sintetico'}
		new_array << {name:'混合材质', england:'Synthetic', germany:'Synthetik', france:'synthétique', spain:'Sintético', italy:'sintetico'}
		new_array << {name:'纯羊毛', england:'Wool', germany:'Wolle', france:'laine', spain:'Cuero y Tela', italy:'tessuto'}
		new_array << {name:'羊毛羊绒混纺', england:'Textile', germany:'Futtermix', france:'fourrure', spain:'Cuero y Tela', italy:'sintetico'}
		new_array << {name:'羊皮', england:'Leather', germany:'Leder', france:'cuir', spain:'Cuero', italy:'Leather'}
		new_array << {name:'羊皮毛一体', england:'Manmade', germany:'Futtermix', france:'fourrure', spain:'Cuero y Tela', italy:'sintetico'}
		new_array << {name:'超纤皮', england:'Manmade', germany:'Kunstfell', france:'manmade', spain:'Cuero artesanal', italy:'sintetico'}
		new_array << {name:'EVA', england:'EVA', germany:'EVA', france:'Synthétique', spain:'Espuma EVA', italy:'EVA'}
		new_array << {name:'EVA发泡胶', england:'EVA', germany:'EVA', france:'Synthétique', spain:'Espuma EVA', italy:'EVA'}
		new_array << {name:'MD', england:'EVA', germany:'EVA', france:'Synthétique', spain:'Espuma EVA', italy:'EVA'}
		new_array << {name:'PVC', england:'Manmade', germany:'Kunststoff', france:'Synthétique', spain:'Hecho a mano', italy:'Sintetico'}
		new_array << {name:'TPR（牛筋）', england:'Gum Rubber', germany:'Gummi', france:'Caoutchouc', spain:'Goma', italy:'Gomma'}
		new_array << {name:'tpu', england:'Gum Rubber', germany:'Gummi', france:'Synthétique', spain:'Hecho a mano', italy:'Sintetico'}
		new_array << {name:'塑料', england:'Manmade', germany:'Kunststoff', france:'Synthétique', spain:'Hecho a mano', italy:'Sintetico'}
		new_array << {name:'橡胶发泡', england:'Gum Rubber', germany:'Gummi', france:'Caoutchouc', spain:'Goma', italy:'Gomma'}
		new_array << {name:'聚氨酯', england:'Gum Rubber', germany:'Gummi', france:'Synthétique', spain:'Hecho a mano', italy:'Sintetico'}
		new_array << {name:'橡胶', england:'Gum Rubber', germany:'Gummi', france:'Caoutchouc', spain:'Goma', italy:'Gomma'}
		new_array << {name:'千层底', england:'Manmade', germany:'Kork', france:'Synthétique', spain:'Hecho a mano', italy:'Sintetico'}
		new_array << {name:'泡沫', england:'Manmade', germany:'Gummi', france:'Synthétique', spain:'Hecho a mano', italy:'Sintetico'}
		new_array << {name:'木', england:'Wood', germany:'Holz', france:'Synthétique', spain:'Corcho', italy:'Legno'}
		new_array << {name:'复合底', england:'Manmade', germany:'Gummi', france:'Synthétique', spain:'Hecho a mano', italy:'Sintetico'}
		new_array << {name:'真皮', england:'Bast', germany:'Bast', france:'Cuir', spain:'Cuero', italy:'Cuoio'}
		new_array << {name:'平底', england:'Wedge', germany:'Keilabsatz', france:'compensé', spain:'Plataforma', italy:'zeppa'}
		new_array << {name:'摇摇底', england:'Wedge', germany:'Keilabsatz', france:'compensé', spain:'Plataforma', italy:'zeppa'}
		new_array << {name:'松糕底', england:'Wedge', germany:'Keilabsatz', france:'compensé', spain:'Plataforma', italy:'zeppa'}
		new_array << {name:'平跟', england:'Wedge', germany:'Keilabsatz', france:'compensé', spain:'Plataforma', italy:'zeppa'}
		new_array << {name:'坡跟', england:'Wedge', germany:'Keilabsatz', france:'compensé', spain:'Plataforma', italy:'zeppa'}
		new_array << {name:'方跟', england:'Block Heel', germany:'Blockabsatz', france:'bloc', spain:'Tacón ancho', italy:'tacco a blocco'}
		new_array << {name:'粗跟', england:'Block Heel', germany:'Blockabsatz', france:'bloc', spain:'Tacón ancho', italy:'tacco a blocco'}
		new_array << {name:'细跟', england:'Cone Heel', germany:'Stiletto', france:'aiguille', spain:'Mini tacón', italy:'tacco a spillo'}
		new_array << {name:'酒杯跟', england:'Kitten Heel', germany:'Stiletto', france:'aiguille', spain:'Mini tacón', italy:'spillo'}
		new_array << {name:'马蹄跟', england:'Block Heel', germany:'Blockabsatz', france:'bloc', spain:'Tacón ancho', italy:'tacco a blocco'}
		new_array << {name:'异型跟', england:'Block Heel', germany:'Blockabsatz', france:'bloc', spain:'Plataforma', italy:'zeppa'}
		new_array << {name:'锥形跟', england:'Cone Heel', germany:'Trichterabsatz', france:'cônique', spain:'Tacón embudo', italy:'tacco a cono'}
		new_array << {name:'镂空跟', england:'Stiletto', germany:'Blockabsatz', france:'bloc', spain:'Tacón ancho', italy:'tacco a blocco'}
		new_array << {name:'一字式扣带', england:'Buckle', germany:'Schnalle', france:'bouton', spain:'Hebilla', italy:'fibbia'}
		new_array << {name:'丁字式扣带', england:'Buckle', germany:'Schnalle', france:'bouton', spain:'Hebilla', italy:'fibbia'}
		new_array << {name:'套脚', england:'Slip On', germany:'Ohne Verschluss', france:'boucle', spain:'Sin cordones', italy:'senza chiusura'}
		new_array << {name:'松紧带', england:'Slip On', germany:'Ohne Verschluss', france:'boucle', spain:'Sin cordones', italy:'senza chiusura'}
		new_array << {name:'系带', england:'Lace-Up', germany:'Schnürsenkel', france:'lacets', spain:'Cordones', italy:'con cordoncino'}
		new_array << {name:'魔术贴', england:'Hook & Loop', germany:'Klettverschluss', france:'scratch', spain:'Velcro', italy:'a strappo'}
		new_array << {name:'拉链', england:'Zip', germany:'Reißverschluss', france:'fermeture eclair', spain:'Cremallera', italy:'cerniera'}
		new_array << {name:'秋冬', england:'Autumn-Winter', germany:'Herbst-Winter', france:'automne-hiver', spain:'Otoño/invierno', italy:'autunno/inverno'}
		new_array << {name:'春夏', england:'Spring-Summer', germany:'Frühling-Sommer', france:'printemps-été', spain:'Primavera/verano', italy:'primavera/estate'}

		ShoesAttributesValue.create(new_array)
	end
end