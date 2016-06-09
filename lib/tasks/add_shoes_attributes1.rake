# not used
namespace :add_data do
	desc 'add_shoes_attributes1'
	task :add_shoes_attributes1 => :environment do
		new_array = []
		new_array << {name:'内增高', england:'Wedge', germany:'Keilabsatz', france:'compensé', spain:'Plataforma', italy:'zeppa'}
		new_array << {name:'侧拉链', england:'Zip', germany:'Reißverschluss', france:'fermeture eclair', spain:'Cremallera', italy:'cerniera'}
		new_array << {name:'前拉链', england:'Zip', germany:'Reißverschluss', france:'fermeture eclair', spain:'Cremallera', italy:'cerniera'}
		new_array << {name:'后拉链', england:'Zip', germany:'Reißverschluss', france:'fermeture eclair', spain:'Cremallera', italy:'cerniera'}
		new_array << {name:'前系带', england:'Lace-Up', germany:'Schnürsenkel', france:'lacets', spain:'Cordones', italy:'con cordoncino'}
		new_array << {name:'前系带', england:'Lace-Up', germany:'Schnürsenkel', france:'lacets', spain:'Cordones', italy:'con cordoncino'}
		new_array << {name:'后系带', england:'Slip On', germany:'Ohne Verschluss', france:'boucle', spain:'Sin cordones', italy:'senza chiusura'}
		new_array << {name:'男孩', england:'Boys', germany:'Jungen', france:'garçons', spain:'Niños adolescentes', italy:'bambina'}
		new_array << {name:'女孩', england:'Girls', germany:'Mädchen', france:'filles', spain:'Niños adolescentes', italy:'bambina'}
		new_array << {name:'男人', england:'Mens', germany:'Herren', france:'hommes', spain:'Hombre', italy:'uomo'}
		new_array << {name:'女人', england:'Womens', germany:'Damen', france:'femmes', spain:'Mujer', italy:'donna'}
		new_array << {name:'舞蹈鞋', england:'Ballroom', germany:'Standard & Latein', france:'danse classique', spain:'Ballet', italy:'balletto'}
		new_array << {name:'爵士&现代舞', england:'Jazz & Modern', germany:'Jazz & Modern', france:'modern jazz', spain:'Jazz y contemporáneo', italy:'jazz e moderno'}
		new_array << {name:'封闭脚趾', england:'Closed-Toe', germany:'Geschlossen', france:'bout fermé', spain:'Cerrado', italy:'chiuse davanti'}
		new_array << {name:'鱼嘴', england:'Peep-Toe', germany:'Peep-Toe', france:'bout ouvert', spain:'Punta abierta', italy:'peep toe'}
		new_array << {name:'防水台', england:'Platform', germany:'Durchgängiges Plateau', france:'plateau', spain:'Plataforma', italy:'con plateau'}
		new_array << {name:'雪地靴', england:'Snow Boots', germany:'Schneestiefel', france:'bottes de neige', spain:'Botas de nieve', italy:'stivali da neve'}
		new_array << {name:'军靴', england:'Combat Boots', germany:'Combat Boots', france:'rangers', spain:'Botas militares', italy:'anifibi'}
		new_array << {name:'高帮', england:'High-Top', germany:'High-top', france:'montants', spain:'Zapatilla alta', italy:'a collo alto'}
		new_array << {name:'低帮', england:'Low-Top', germany:'Low-top', france:'basses', spain:'Caña baja', italy:'a collo basso'}
		new_array << {name:'脚斗士-镂空', england:'Gladiator', germany:'Römersandalen', france:'spartiates', spain:'Romana', italy:'alla schiava'}
		new_array << {name:'松糕底', england:'Flatform', germany:'Plateau', france:'plateforme', spain:'Plano', italy:'flatform'}
		new_array << {name:'布鞋', england:'Espadrille', germany:'Espadrilles', france:'espadrilles', spain:'Alpargata', italy:'espadrillas'}
		new_array << {name:'磨砂靴', england:'Desert Boots', germany:'Desert Boots', france:'desert boots', spain:'Botines Desert', italy:'derby'}
		new_array << {name:'休闲靴', england:'Chukka Boots', germany:'Chukka Boots', france:'chukka', spain:'Botas Chukka', italy:'stivali chukka'}
		new_array << {name:'皮鞋', england:'Brogue', germany:'Brogue', france:'', spain:'Brogue', italy:'Brogue'}
		new_array << {name:'自行车靴', england:'Biker Boots', germany:'Biker Boots', france:'bottes motard', spain:'Botas de estilo motero', italy:'stivali da motociclista'}
		new_array << {name:'绒面革', england:'Nubuck', germany:'Nubukleder', france:'nubuck', spain:'', italy:'pelle nubuk'}
		new_array << {name:'漆革', england:'Patent Leather', germany:'Lackleder', france:'vernis', spain:'', italy:'pelle verniciata'}
		new_array << {name:'光滑的皮', england:'Smooth Leather', germany:'Glattleder', france:'cuir souple', spain:'', italy:'pelle liscia'}
		new_array << {name:'麂皮绒', england:'Suede', germany:'Wildleder', france:'suède', spain:'', italy:'pelle scamosciata'}
		new_array << {name:'脚踝', england:'Ankle', germany:'Kurzschaft', france:'cheville', spain:'Tobillo', italy:'alla caviglia'}
		new_array << {name:'小腿', england:'Mid-Calf', germany:'Halbschaft', france:'mi-mollet', spain:'Media pierna', italy:'al polpaccio'}
		new_array << {name:'膝盖高', england:'Knee-High', germany:'Langschaft', france:'genoux', spain:'Rodilla', italy:'al ginocchio'}
		new_array << {name:'过膝', england:'Over-the-Knee', germany:'Over-Knee', france:'cuissarde', spain:'Sobre la rodilla', italy:'sopra il ginocchio'}
		new_array << {name:'正常', england:'Regular', germany:'Normal', france:'normale', spain:'Normal', italy:'normale'}
		new_array << {name:'窄', england:'Narrow', germany:'Schmal', france:'etroite', spain:'Estrecha', italy:'stretta'}
		new_array << {name:'超宽', england:'Extra Wide', germany:'Extra weit', france:'extra-large', spain:'Extra ancha', italy:'molto larga'}
		new_array << {name:'可调整', england:'Adjustable', germany:'Verstellbar', france:'ajustable', spain:'Ajustable', italy:'regolabile'}
		new_array << {name:'宽', england:'Wide', germany:'Weit', france:'large', spain:'Ancha', italy:'larga'}
		new_array << {name:'单鞋', england:'cold lining', germany:'Kalt gefüttert', france:'non doublé', spain:'Con forro no acolchado', italy:'senza imbottitura'}
		new_array << {name:'暖鞋', england:'warm lining', germany:'Warm gefüttert', france:'doublé chaud', spain:'Con forro acolchado', italy:'con imbottitura calda'}
		new_array << {name:'脚踝绑带', england:'ankle-strap', germany:'ankle-strap', france:'bride cheville', spain:'Tira de tobillo', italy:'cinturino alla caviglia'}
		new_array << {name:'脚踝包裹', england:'ankle-wrap', germany:'ankle-wrap', france:'bride cheville', spain:'Tira de tobillo', italy:''}
		new_array << {name:'后跟带', england:'slingback', germany:'adjustable-strap', france:'chaussures ouvertes à larrière', spain:'Destalonado', italy:''}
		new_array << {name:'T型带', england:'t-strap', germany:'t-strap', france:'lanière en t', spain:'Tira vertical', italy:'cinturino a t'}
		new_array << {name:'人字', england:'thong', germany:'thong', france:'lanière en t', spain:'Tira de dedo', italy:''}
		new_array << {name:'0.5', england:'1 centimetres', germany:'0.5 cm', france:'1 centimetres', spain:'1 cm', italy:'0.5 cm'}
		new_array << {name:'1', england:'1 centimetres', germany:'1 cm', france:'1 centimetres', spain:'1 cm', italy:'1 cm'}
		new_array << {name:'1.5', england:'2 centimetres', germany:'1.5 cm', france:'2centimetres', spain:'2 cm', italy:'1.5 cm'}
		new_array << {name:'2', england:'2 centimetres', germany:'2 cm', france:'2 centimetres', spain:'2 cm', italy:'2 cm'}
		new_array << {name:'2.5', england:'3 centimetres', germany:'2.5 cm', france:'3 centimetres', spain:'3 cm', italy:'2.5 cm'}
		new_array << {name:'3', england:'3 centimetres', germany:'3 cm', france:'3 centimetres', spain:'3 cm', italy:'3 cm'}
		new_array << {name:'3.5', england:'4 centimetres', germany:'3.5 cm', france:'4 centimetres', spain:'4 cm', italy:'3.5 cm'}
		new_array << {name:'4', england:'4 centimetres', germany:'4 cm', france:'4 centimetres', spain:'4 cm', italy:'4 cm'}
		new_array << {name:'4.5', england:'5 centimetres', germany:'4.5 cm', france:'5 centimetres', spain:'5 cm', italy:'4.5 cm'}
		new_array << {name:'5', england:'5 centimetres', germany:'5 cm', france:'5 centimetres', spain:'5 cm', italy:'5 cm'}
		new_array << {name:'5.5', england:'6 centimetres', germany:'5.5 cm', france:'6 centimetres', spain:'6 cm', italy:'5.5 cm'}
		new_array << {name:'6', england:'6 centimetres', germany:'6 cm', france:'6 centimetres', spain:'6 cm', italy:'6 cm'}
		new_array << {name:'6.5', england:'7 centimetres', germany:'6.5 cm', france:'7 centimetres', spain:'7 cm', italy:'6.5 cm'}
		new_array << {name:'7', england:'7 centimetres', germany:'7 cm', france:'7 centimetres', spain:'7 cm', italy:'7 cm'}
		new_array << {name:'7.5', england:'8 centimetres', germany:'7.5 cm', france:'8 centimetres', spain:'8 cm', italy:'7.5 cm'}
		new_array << {name:'8', england:'8 centimetres', germany:'8 cm', france:'8 centimetres', spain:'8 cm', italy:'8 cm'}
		new_array << {name:'8.5', england:'9 centimetres', germany:'8.5 cm', france:'9 centimetres', spain:'9 cm', italy:'8.5 cm'}
		new_array << {name:'9', england:'9 centimetres', germany:'9 cm', france:'9 centimetres', spain:'9 cm', italy:'9 cm'}
		new_array << {name:'9.5', england:'10 centimetres', germany:'9.5 cm', france:'10 centimetres', spain:'10 cm', italy:'9.5 cm'}
		new_array << {name:'10', england:'10 centimetres', germany:'10 cm', france:'10 centimetres', spain:'10 cm', italy:'10 cm'}
		new_array << {name:'10.5', england:'11 centimetres', germany:'10.5 cm', france:'11 centimetres', spain:'11 cm', italy:'10.5 cm'}
		new_array << {name:'11', england:'11 centimetres', germany:'11 cm', france:'11 centimetres', spain:'11 cm', italy:'11 cm'}
		new_array << {name:'11.5', england:'12 centimetres', germany:'11.5 cm', france:'12 centimetres', spain:'12 cm', italy:'11.5 cm'}
		new_array << {name:'12', england:'12 centimetres', germany:'12 cm', france:'12 centimetres', spain:'12 cm', italy:'12 cm'}
		new_array << {name:'12.5', england:'13 centimetres', germany:'12.5 cm', france:'13 centimetres', spain:'13 cm', italy:'12.5 cm'}
		new_array << {name:'13', england:'13 centimetres', germany:'13 cm', france:'13 centimetres', spain:'13 cm', italy:'13 cm'}
		new_array << {name:'13.5', england:'14 centimetres', germany:'13.5 cm', france:'14 centimetres', spain:'14 cm', italy:'13.5 cm'}
		new_array << {name:'14', england:'14 centimetres', germany:'14 cm', france:'14 centimetres', spain:'14 cm', italy:'14 cm'}
		new_array << {name:'14.5', england:'15 centimetres', germany:'14.5 cm', france:'15 centimetres', spain:'15 cm', italy:'14.5 cm'}
		new_array << {name:'15', england:'15 centimetres', germany:'15 cm', france:'15 centimetres', spain:'15 cm', italy:'15 cm'}

		ShoesAttributesValue.create(new_array)
	end
end