"""Translations for bundled onboarding sample recipes."""

from translation_data import t


def translations() -> dict[str, dict[str, str]]:
    return {
        "Almond flour": {"en": "Almond flour", **t(
            "Harina de almendras", "Farina d'ametlla", "Farine d'amande", "Amandelmeel", "Mandelmehl", "杏仁粉", "アーモンド粉", "Farina di mandorle", "Farinha de amêndoa", "Миндальная мука"
        )},
        "Almond milk": {"en": "Almond milk", **t(
            "Leche de almendras", "Llet d'ametlla", "Lait d'amande", "Amandelmelk", "Mandelmilch", "杏仁奶", "アーモンドミルク", "Latte di mandorle", "Leite de amêndoa", "Миндальное молоко"
        )},
        "Apple": {"en": "Apple", **t(
            "Manzana", "Poma", "Pomme", "Appel", "Apfel", "苹果", "りんご", "Mela", "Maçã", "Яблоко"
        )},
        "Arborio rice": {"en": "Arborio rice", **t(
            "Arroz arborio", "Arròs arborio", "Riz arborio", "Arboriorijst", "Arborio-Reis", "意大利米", "アルボリオ米", "Riso arborio", "Arroz arborio", "Рис арборио"
        )},
        "Avocado": {"en": "Avocado", **t(
            "Aguacate", "Alvocat", "Avocat", "Avocado", "Avocado", "牛油果", "アボカド", "Avocado", "Abacate", "Авокадо"
        )},
        "Banana": {"en": "Banana", **t(
            "Plátano", "Plàtan", "Banane", "Banaan", "Banane", "香蕉", "バナナ", "Banana", "Banana", "Банан"
        )},
        "Basil pesto": {"en": "Basil pesto", **t(
            "Pesto de albahaca", "Pestó de alfàbrega", "Pesto au basilic", "Basilicumpesto", "Basilikum-Pesto", "罗勒青酱", "バジルのペスト", "Pesto al basilico", "Pesto de manjericão", "Пesto с базиликом"
        )},
        "Bell pepper": {"en": "Bell pepper", **t(
            "Pimiento", "Peberot", "Poivron", "Paprika", "Paprika", "甜椒", "パプリカ", "Peperone", "Pimento", "Болгарский перец"
        )},
        "Black beans": {"en": "Black beans", **t(
            "Frijoles negros", "Mongetes negres", "Haricots noirs", "Zwarte bonen", "Schwarze Bohnen", "黑豆", "黒豆", "Fagioli neri", "Feijão preto", "Чёрная фасоль"
        )},
        "Broccoli": {"en": "Broccoli", **t(
            "Brócoli", "Bròcoli", "Brocoli", "Broccoli", "Brokkoli", "西兰花", "ブロッコリー", "Broccoli", "Brócolos", "Брокколи"
        )},
        "Brown rice": {"en": "Brown rice", **t(
            "Arroz integral", "Arròs integral", "Riz complet", "Zilvervliesrijst", "Vollkornreis", "糙米", "玄米", "Riso integrale", "Arroz integral", "Бурый рис"
        )},
        "Butter": {"en": "Butter", **t(
            "Mantequilla", "Mantega", "Beurre", "Boter", "Butter", "黄油", "バター", "Burro", "Manteiga", "Сливочное масло"
        )},
        "Carrot": {"en": "Carrot", **t(
            "Zanahoria", "Pastanaga", "Carotte", "Wortel", "Karotte", "胡萝卜", "にんじん", "Carota", "Cenoura", "Морковь"
        )},
        "Cheddar cheese": {"en": "Cheddar cheese", **t(
            "Queso cheddar", "Formatge cheddar", "Fromage cheddar", "Cheddarkaas", "Cheddar-Käse", "切达奶酪", "チェダーチーズ", "Formaggio cheddar", "Queijo cheddar", "Сыр чеддер"
        )},
        "Chia seeds": {"en": "Chia seeds", **t(
            "Semillas de chía", "Llavors de xia", "Graines de chia", "Chiazaad", "Chiasamen", "奇亚籽", "チアシード", "Semi di chia", "Sementes de chia", "Семена чиа"
        )},
        "Chicken breast": {"en": "Chicken breast", **t(
            "Pechuga de pollo", "Pit de pollastre", "Blanc de poulet", "Kipfilet", "Hähnchenbrust", "鸡胸肉", "鶏むね肉", "Petto di pollo", "Peito de frango", "Куриная грудка"
        )},
        "Chickpeas": {"en": "Chickpeas", **t(
            "Garbanzos", "Cigrons", "Pois chiches", "Kikkererwten", "Kichererbsen", "鹰嘴豆", "ひよこ豆", "Ceci", "Grão-de-bico", "Нут"
        )},
        "Chili flakes": {"en": "Chili flakes", **t(
            "Copos de chile", "Flocs de xili", "Flocons de piment", "Chilivlokken", "Chiliflocken", "辣椒片", "唐辛子フレーク", "Peperoncino in fiocchi", "Flocos de pimenta", "Хлопья чili"
        )},
        "Cinnamon": {"en": "Cinnamon", **t(
            "Canela", "Canela", "Cannelle", "Kaneel", "Zimt", "肉桂", "シナモン", "Cannella", "Canela", "Корица"
        )},
        "Coconut milk": {"en": "Coconut milk", **t(
            "Leche de coco", "Llet de coco", "Lait de coco", "Kokosmelk", "Kokosmilch", "椰奶", "ココナッツミルク", "Latte di cocco", "Leite de coco", "Кокосовое молоко"
        )},
        "Cod": {"en": "Cod", **t(
            "Bacalao", "Bacallà", "Cabillaud", "Kabeljauw", "Kabeljau", "鳕鱼", "タラ", "Merluzzo", "Bacalhau", "Треска"
        )},
        "Cucumber": {"en": "Cucumber", **t(
            "Pepino", "Cogombre", "Concombre", "Komkommer", "Gurke", "黄瓜", "きゅうり", "Cetriolo", "Pepino", "Огурец"
        )},
        "Cumin": {"en": "Cumin", **t(
            "Comino", "Comí", "Cumin", "Komijn", "Kreuzkümmel", "孜然", "クミン", "Cumino", "Cominho", "Зира"
        )},
        "Dark chocolate": {"en": "Dark chocolate", **t(
            "Chocolate negro", "Xocolata negra", "Chocolat noir", "Pure chocolade", "Zartbitterschokolade", "黑巧克力", "ダークチョコレート", "Cioccolato fondente", "Chocolate negro", "Тёмный шоколад"
        )},
        "Egg": {"en": "Egg", **t(
            "Huevo", "Ou", "Œuf", "Ei", "Ei", "鸡蛋", "卵", "Uovo", "Ovo", "Яйцо"
        )},
        "Egg whites": {"en": "Egg whites", **t(
            "Claras de huevo", "Clares d'ou", "Blancs d'œufs", "Eiwit", "Eiweiß", "蛋白", "卵白", "Albume", "Claras de ovo", "Яичные белки"
        )},
        "Eggs": {"en": "Eggs", **t(
            "Huevos", "Ous", "Œufs", "Eieren", "Eier", "鸡蛋", "卵", "Uova", "Ovos", "Яйца"
        )},
        "Feta cheese": {"en": "Feta cheese", **t(
            "Queso feta", "Formatge feta", "Fromage feta", "Fetakaas", "Feta-Käse", "羊奶酪", "フェタチーズ", "Formaggio feta", "Queijo feta", "Сыр фета"
        )},
        "Flatbread": {"en": "Flatbread", **t(
            "Pan plano", "Pa pla", "Pain plat", "Flatbread", "Fladenbrot", "扁面包", "フラットブレッド", "Pane piadina", "Pão achatado", "Лаваш"
        )},
        "Fresh basil": {"en": "Fresh basil", **t(
            "Albahaca fresca", "Alfàbrega fresca", "Basilic frais", "Verse basilicum", "Frisches Basilikum", "新鲜罗勒", "生バジル", "Basilico fresco", "Manjericão fresco", "Свежий базилик"
        )},
        "Fresh dill": {"en": "Fresh dill", **t(
            "Eneldo fresco", "Anet fresc", "Aneth frais", "Verse dille", "Frischer Dill", "新鲜莳萝", "生ディル", "Aneto fresco", "Endro fresco", "Свежий укроп"
        )},
        "Fresh herbs": {"en": "Fresh herbs", **t(
            "Hierbas frescas", "Herbes fresques", "Herbes fraîches", "Verse kruiden", "Frische Kräuter", "新鲜香草", "生ハーブ", "Erbe fresche", "Ervas frescas", "Свежие травы"
        )},
        "Garlic": {"en": "Garlic", **t(
            "Ajo", "All", "Ail", "Knoflook", "Knoblauch", "大蒜", "にんにく", "Aglio", "Alho", "Чеснок"
        )},
        "Ginger": {"en": "Ginger", **t(
            "Jengibre", "Gingebre", "Gingembre", "Gember", "Ingwer", "姜", "しょうが", "Zenzero", "Gengibre", "Имбирь"
        )},
        "Granola": {"en": "Granola", **t(
            "Granola", "Granola", "Granola", "Granola", "Granola", "格兰诺拉麦片", "グラノーラ", "Granola", "Granola", "Гранола"
        )},
        "Greek yogurt": {"en": "Greek yogurt", **t(
            "Yogur griego", "Iogurt grec", "Yaourt grec", "Griekse yoghurt", "Griechischer Joghurt", "希腊酸奶", "ギリシャヨーグルト", "Yogurt greco", "Iogurte grego", "Греческий йогурт"
        )},
        "Green beans": {"en": "Green beans", **t(
            "Judías verdes", "Mongetes tendres", "Haricots verts", "Sperziebonen", "Grüne Bohnen", "四季豆", "インゲン", "Fagiolini", "Feijão-verde", "Стручковая фасоль"
        )},
        "Ground turkey": {"en": "Ground turkey", **t(
            "Pavo molido", "Gall dindi picat", "Dinde hachée", "Kalkoengehakt", "Putenhackfleisch", "火鸡肉末", "七面鳥のひき肉", "Tacchino macinato", "Peru moído", "Фарш из индейки"
        )},
        "Honey": {"en": "Honey", **t(
            "Miel", "Mel", "Miel", "Honing", "Honig", "蜂蜜", "はちみつ", "Miele", "Mel", "Мёд"
        )},
        "Lemon": {"en": "Lemon", **t(
            "Limón", "Llimona", "Citron", "Citroen", "Zitrone", "柠檬", "レモン", "Limone", "Limão", "Лимон"
        )},
        "Maple syrup": {"en": "Maple syrup", **t(
            "Jarabe de arce", "Xarop d'auró", "Sirop d'érable", "Ahornsiroop", "Ahornsirup", "枫糖浆", "メープルシロップ", "Sciroppo d'acero", "Xarope de ácer", "Кленовый сироп"
        )},
        "Milk": {"en": "Milk", **t(
            "Leche", "Llet", "Lait", "Melk", "Milch", "牛奶", "牛乳", "Latte", "Leite", "Молоко"
        )},
        "Mixed berries": {"en": "Mixed berries", **t(
            "Frutos rojos variados", "Fruits del bosc variats", "Baies mélangées", "Gemengde bessen", "Beerenmischung", "混合浆果", "ミックスベリー", "Frutti di bosco misti", "Frutos vermelhos mistos", "Ягодная смесь"
        )},
        "Mixed greens": {"en": "Mixed greens", **t(
            "Mezcla de lechugas", "Barreja d'enciams", "Salade mélangée", "Gemengde sla", "Blattsalat-Mix", "混合沙拉菜", "ミックスグリーン", "Insalata mista", "Mix de folhas", "Салатный микс"
        )},
        "Mozzarella": {"en": "Mozzarella", **t(
            "Mozzarella", "Mozzarella", "Mozzarella", "Mozzarella", "Mozzarella", "马苏里拉", "モッツァレラ", "Mozzarella", "Mozzarella", "Моцарелла"
        )},
        "Mushrooms": {"en": "Mushrooms", **t(
            "Champiñones", "Bolets", "Champignons", "Champignons", "Pilze", "蘑菇", "きのこ", "Funghi", "Cogumelos", "Грибы"
        )},
        "Olive oil": {"en": "Olive oil", **t(
            "Aceite de oliva", "Oli d'oliva", "Huile d'olive", "Olijfolie", "Olivenöl", "橄榄油", "オリーブオイル", "Olio d'oliva", "Azeite", "Оливковое масло"
        )},
        "Onion": {"en": "Onion", **t(
            "Cebolla", "Ceba", "Oignon", "Ui", "Zwiebel", "洋葱", "玉ねぎ", "Cipolla", "Cebola", "Лук"
        )},
        "Parmesan": {"en": "Parmesan", **t(
            "Parmesano", "Parmesà", "Parmesan", "Parmezaan", "Parmesan", "帕玛森", "パルメザン", "Parmigiano", "Parmesão", "Пармезан"
        )},
        "Pasta": {"en": "Pasta", **t(
            "Pasta", "Pasta", "Pâtes", "Pasta", "Pasta", "意面", "パスタ", "Pasta", "Massa", "Паста"
        )},
        "Peach": {"en": "Peach", **t(
            "Melocotón", "Préssec", "Pêche", "Perzik", "Pfirsich", "桃子", "桃", "Pesca", "Pêssego", "Персик"
        )},
        "Quinoa": {"en": "Quinoa", **t(
            "Quinoa", "Quinoa", "Quinoa", "Quinoa", "Quinoa", "藜麦", "キノア", "Quinoa", "Quinoa", "Киноа"
        )},
        "Red lentils": {"en": "Red lentils", **t(
            "Lentejas rojas", "Llenties vermelles", "Lentilles corail", "Rode linzen", "Rote Linsen", "红扁豆", "レンズ豆", "Lenticchie rosse", "Lentilhas vermelhas", "Красная чечевица"
        )},
        "Rolled oats": {"en": "Rolled oats", **t(
            "Copos de avena", "Flocs de civada", "Flocons d'avoine", "Havermout", "Haferflocken", "燕麦片", "オートミール", "Fiocchi d'avena", "Flocos de aveia", "Овсяные хлопья"
        )},
        "Salmon fillet": {"en": "Salmon fillet", **t(
            "Filete de salmón", "Filet de salmó", "Filet de saumon", "Zalmfilet", "Lachsfilet", "三文鱼片", "サーモンフィレ", "Filetto di salmone", "Filete de salmão", "Филе лосося"
        )},
        "Shredded coconut": {"en": "Shredded coconut", **t(
            "Coco rallado", "Coco ratllat", "Noix de coco râpée", "Geraspte kokos", "Kokosraspeln", "椰丝", "ココナッツフレーク", "Cocco grattugiato", "Coco ralado", "Кокосовая стружка"
        )},
        "Shrimp": {"en": "Shrimp", **t(
            "Camarones", "Gambes", "Crevettes", "Garnalen", "Garnelen", "虾", "エビ", "Gamberetti", "Camarão", "Креветки"
        )},
        "Sourdough bread": {"en": "Sourdough bread", **t(
            "Pan de masa madre", "Pa de massa mare", "Pain au levain", "Desembrood", "Sauerteigbrot", "酸种面包", "サワードウパン", "Pane a lievitazione naturale", "Pão de massa madre", "Хлеб на закваске"
        )},
        "Soy sauce": {"en": "Soy sauce", **t(
            "Salsa de soja", "Salsa de soja", "Sauce soja", "Sojasaus", "Sojasauce", "酱油", "醤油", "Salsa di soia", "Molho de soja", "Соевый соус"
        )},
        "Spaghetti": {"en": "Spaghetti", **t(
            "Espaguetis", "Espaguetis", "Spaghetti", "Spaghetti", "Spaghetti", "意大利面", "スパゲッティ", "Spaghetti", "Esparguete", "Спагетти"
        )},
        "Spinach": {"en": "Spinach", **t(
            "Espinacas", "Espinacs", "Épinards", "Spinazie", "Spinat", "菠菜", "ほうれん草", "Spinaci", "Espinafres", "Шпинат"
        )},
        "Steak": {"en": "Steak", **t(
            "Bistec", "Bistec", "Steak", "Biefstuk", "Steak", "牛排", "ステーキ肉", "Bistecca", "Bife", "Стейк"
        )},
        "Tomato": {"en": "Tomato", **t(
            "Tomate", "Tomàquet", "Tomate", "Tomaat", "Tomate", "番茄", "トマト", "Pomodoro", "Tomate", "Помидор"
        )},
        "Tomatoes": {"en": "Tomatoes", **t(
            "Tomates", "Tomàquets", "Tomates", "Tomaten", "Tomaten", "番茄", "トマト", "Pomodori", "Tomates", "Помидоры"
        )},
        "Tuna": {"en": "Tuna", **t(
            "Atún", "Tonyina", "Thon", "Tonijn", "Thunfisch", "金枪鱼", "ツナ", "Tonno", "Atum", "Тунец"
        )},
        "Vanilla extract": {"en": "Vanilla extract", **t(
            "Extracto de vainilla", "Extracte de vainilla", "Extrait de vanille", "Vanille-extract", "Vanilleextrakt", "香草精", "バニラエキス", "Estratto di vaniglia", "Extrato de baunilha", "Ванильный экстракт"
        )},
        "Vegetable broth": {"en": "Vegetable broth", **t(
            "Caldo de verduras", "Brou de verdures", "Bouillon de légumes", "Groentebouillon", "Gemüsebrühe", "蔬菜高汤", "野菜ブイヨン", "Brodo vegetale", "Caldo de legumes", "Овощной бульон"
        )},
        "Vinegar": {"en": "Vinegar", **t(
            "Vinagre", "Vinagre", "Vinaigre", "Azijn", "Essig", "醋", "酢", "Aceto", "Vinagre", "Уксус"
        )},
        "Zucchini": {"en": "Zucchini", **t(
            "Calabacín", "Carbassó", "Courgette", "Courgette", "Zucchini", "西葫芦", "ズッキーニ", "Zucchina", "Curgete", "Цуккини"
        )},
        "Spaghetti Aglio e Olio": {"en": "Spaghetti Aglio e Olio", **t(
            "Espaguetis aglio e olio", "Espaguetis aglio e olio", "Spaghetti aglio e olio", "Spaghetti aglio e olio", "Spaghetti aglio e olio", "蒜香橄榄油意面", "スパゲッティ・アーリオ・オーリオ", "Spaghetti aglio e olio", "Esparguete aglio e olio", "Спагетти aglio e olio"
        )},
        "Chicken & Broccoli Rice Bowl": {"en": "Chicken & Broccoli Rice Bowl", **t(
            "Bowl de arroz con pollo y brócoli", "Bol d'arròs amb pollastre i bròcoli", "Bol de riz au poulet et brocoli", "Rijstbowl met kip en broccoli", "Reisbowl mit Hähnchen und Brokkoli", "鸡肉西兰花饭碗", "チキンとブロッコリーのライスボウル", "Bowl di riso con pollo e broccoli", "Taça de arroz com frango e brócolos", "Рисовый боул с курицей и брокколи"
        )},
        "Classic Scrambled Eggs": {"en": "Classic Scrambled Eggs", **t(
            "Huevos revueltos clásicos", "Ous remenats clàssics", "Œufs brouillés classiques", "Klassieke roerei", "Klassisches Rührei", "经典炒蛋", "定番スクランブルエッグ", "Uova strapazzate classiche", "Ovos mexidos clássicos", "Классическая яичница-болтунья"
        )},
        "Greek Salad": {"en": "Greek Salad", **t(
            "Ensalada griega", "Amanida grega", "Salade grecque", "Griekse salade", "Griechischer Salat", "希腊沙拉", "ギリシャサラダ", "Insalata greca", "Salada grega", "Греческий салат"
        )},
        "Hearty Lentil Soup": {"en": "Hearty Lentil Soup", **t(
            "Sopa sustanciosa de lentejas", "Sopa contundent de llenties", "Soupe copieuse aux lentilles", "Hartelijke linzensoep", "Herzhafte Linsensuppe", "暖心扁豆汤", "ボリュームたっぷりレンズ豆スープ", "Zuppa di lenticchie sostanziosa", "Sopa fartura de lentilhas", "Сытный суп из чечевицы"
        )},
        "Pan-Seared Salmon": {"en": "Pan-Seared Salmon", **t(
            "Salmón sellado en sartén", "Salmó daurat a la paella", "Saumon poêlé", "Gebakken zalm", "Gebratener Lachs", "香煎三文鱼", "パンで焼いたサーモン", "Salmone in padella", "Salmão salteado", "Обжаренный лосось на сковороде"
        )},
        "Overnight Oats": {"en": "Overnight Oats", **t(
            "Avena de la noche a la mañana", "Civada de la nit al matí", "Flocons d'avoine du lendemain", "Overnight havermout", "Overnight-Haferflocken", "隔夜燕麦", "オーバーナイトオーツ", "Overnight oats", "Aveia da véspera", "Овсянка на ночь"
        )},
        "Tomato Basil Soup": {"en": "Tomato Basil Soup", **t(
            "Sopa de tomate y albahaca", "Sopa de tomàquet i alfàbrega", "Soupe tomate-basilic", "Tomaten-basilicumsoep", "Tomaten-Basilikum-Suppe", "番茄罗勒汤", "トマトバジルスープ", "Zuppa pomodoro e basilico", "Sopa de tomate e manjericão", "Томатный суп с базиликом"
        )},
        "Banana Nice Cream": {"en": "Banana Nice Cream", **t(
            "Helado suave de plátano", "Gelat suau de plàtan", "Nice cream à la banane", "Banaan nice cream", "Banana-Nice-Cream", "香蕉冰淇淋", "バナナナイスクリーム", "Nice cream alla banana", "Nice cream de banana", "Банановое nice cream"
        )},
        "Chickpea Coconut Curry": {"en": "Chickpea Coconut Curry", **t(
            "Curry de garbanzos con coco", "Curry de cigrons amb coco", "Curry de pois chiches au coco", "Kikkererwtencurry met kokos", "Kichererbsen-Kokos-Curry", "鹰嘴豆椰浆咖喱", "ひよこ豆のココナッツカレー", "Curry di ceci al cocco", "Caril de grão-de-bico com coco", "Кокосовое карри с нутом"
        )},
        "Rainbow Veggie Stir-Fry": {"en": "Rainbow Veggie Stir-Fry", **t(
            "Salteado de verduras arcoíris", "Saltat de verdures arc de Sant Martí", "Sauté de légumes arc-en-ciel", "Regenbooggroenten roerbak", "Regenbogen-Gemüsepfanne", "彩虹蔬菜快炒", "レインボー野菜炒め", "Saltato di verdure arcobaleno", "Salteado de legumes arco-íris", "Радужное овощное жаркое"
        )},
        "Avocado Toast": {"en": "Avocado Toast", **t(
            "Tostada de aguacate", "Torrada d'alvocat", "Toast à l'avocat", "Avocadotoast", "Avocado-Toast", "牛油果吐司", "アボカドトースト", "Toast all'avocado", "Tosta de abacate", "Тост с авокадо"
        )},
        "Caprese Salad": {"en": "Caprese Salad", **t(
            "Ensalada caprese", "Amanida caprese", "Salade caprese", "Caprese salade", "Caprese-Salat", "卡普里沙拉", "カプレーゼサラダ", "Insalata caprese", "Salada caprese", "Салат капрезе"
        )},
        "Mushroom Risotto": {"en": "Mushroom Risotto", **t(
            "Risotto de champiñones", "Risotto de bolets", "Risotto aux champignons", "Paddenstoelenrisotto", "Pilzrisotto", "蘑菇意式烩饭", "きのこリゾット", "Risotto ai funghi", "Risotto de cogumelos", "Грибное ризотто"
        )},
        "Turkey Meatballs": {"en": "Turkey Meatballs", **t(
            "Albóndigas de pavo", "Mandonguilles de gall dindi", "Boulettes de dinde", "Kalkoengehaktballetjes", "Puten-Fleischbällchen", "火鸡肉丸", "七面鳥のミートボール", "Polpette di tacchino", "Almôndegas de peru", "Фрикадельки из индейки"
        )},
        "Egg White Omelette": {"en": "Egg White Omelette", **t(
            "Tortilla de claras", "Truita de clares", "Omelette aux blancs d'œufs", "Eiwitomelet", "Eiweiß-Omelett", "蛋白 omelette", "卵白オムレツ", "Frittata di albumi", "Omelete de claras", "Омлет из белков"
        )},
        "Cobb Salad": {"en": "Cobb Salad", **t(
            "Ensalada Cobb", "Amanida Cobb", "Salade Cobb", "Cobb salade", "Cobb-Salat", "科布沙拉", "コブサラダ", "Insalata Cobb", "Salada Cobb", "Салат Cobb"
        )},
        "Zucchini Noodles with Marinara": {"en": "Zucchini Noodles with Marinara", **t(
            "Fideos de calabacín con marinara", "Noodles de carbassó amb marinara", "Courgetti à la marinara", "Courgettenoedels met marinara", "Zucchini-Nudeln mit Marinara", "西葫芦面配马里纳拉酱", "ズッキーニヌードルとマリナーラ", "Spaghetti di zucchine alla marinara", "Noodles de curgete com marinara", "Цуккини-лапша с маринara"
        )},
        "Grilled Lemon Chicken": {"en": "Grilled Lemon Chicken", **t(
            "Pollo a la plancha con limón", "Pollastre a la planxa amb llimona", "Poulet grillé au citron", "Gegrilde citroenkip", "Gegrilltes Zitronenhähnchen", "柠檬烤鸡", "レモングリルチキン", "Pollo alla griglia al limone", "Frango grelhado com limão", "Курица на гриле с лимоном"
        )},
        "Garlic Steak Bites": {"en": "Garlic Steak Bites", **t(
            "Bocados de bistec con ajo", "Trossos de bistec amb all", "Morceaux de steak à l'ail", "Knoflooksteakbites", "Knoblauch-Steakwürfel", "蒜香牛排粒", "ガーリックステーキバイト", "Bocconcini di bistecca all'aglio", "Bocados de bife com alho", "Стейковые кусочки с чесноком"
        )},
        "Shrimp Scampi": {"en": "Shrimp Scampi", **t(
            "Camarones scampi", "Gambes scampi", "Crevettes scampi", "Garnalen scampi", "Garnelen Scampi", "蒜香黄油虾", "シュリンプスカンピ", "Gamberetti scampi", "Camarão scampi", "Креветки scampi"
        )},
        "Spinach Egg Muffins": {"en": "Spinach Egg Muffins", **t(
            "Muffins de huevo con espinacas", "Muffins d'ou amb espinacs", "Muffins aux œufs et épinards", "Spinazie-ei muffins", "Spinat-Ei-Muffins", "菠菜蛋马芬", "ほうれん草エッグマフィン", "Muffin di uova e spinaci", "Muffins de ovo com espinafres", "Яичные маффины со шpinatom"
        )},
        "Tuna Salad Bowl": {"en": "Tuna Salad Bowl", **t(
            "Bowl de ensalada de atún", "Bol d'amanida de tonyina", "Bol de salade au thon", "Tonijnsalade bowl", "Thunfischsalat-Bowl", "金枪鱼沙拉碗", "ツナサラダボウル", "Bowl di insalata di tonno", "Taça de salada de atum", "Салатный боул с тунцом"
        )},
        "Steamed Veggie Medley": {"en": "Steamed Veggie Medley", **t(
            "Verduras al vapor variadas", "Verdures al vapor variades", "Légumes vapeur variés", "Gestoomde groentemix", "Gedämpftes Gemüse", "蒸蔬菜拼盘", "蒸し野菜ミックス", "Verdure miste al vapore", "Legumes cozidos a vapor", "Ассорти овощей на пару"
        )},
        "Berry Smoothie Bowl": {"en": "Berry Smoothie Bowl", **t(
            "Bowl de smoothie de frutos rojos", "Bol de smoothie de fruits del bosc", "Bol smoothie aux baies", "Bessen smoothie bowl", "Beeren-Smoothie-Bowl", "浆果思慕雪碗", "ベリースムージーボウル", "Smoothie bowl ai frutti di bosco", "Taça de smoothie de frutos vermelhos", "Смузи-боул с ягодами"
        )},
        "Baked Cod with Herbs": {"en": "Baked Cod with Herbs", **t(
            "Bacalao al horno con hierbas", "Bacallà al forn amb herbes", "Cabillaud au four aux herbes", "Gebakken kabeljauw met kruiden", "Gebackener Kabeljau mit Kräutern", "香草烤鳕鱼", "ハーブ焼きタラ", "Merluzzo al forno con erbe", "Bacalhau assado com ervas", "Запечённая треска с травами"
        )},
        "Rice and Black Beans": {"en": "Rice and Black Beans", **t(
            "Arroz con frijoles negros", "Arròs amb mongetes negres", "Riz aux haricots noirs", "Rijst met zwarte bonen", "Reis mit schwarzen Bohnen", "米饭配黑豆", "ライスと黒豆", "Riso e fagioli neri", "Arroz com feijão preto", "Рис с чёрной фасолью"
        )},
        "Cucumber Dill Salad": {"en": "Cucumber Dill Salad", **t(
            "Ensalada de pepino y eneldo", "Amanida de cogombre i anet", "Salade de concombre à l'aneth", "Komkommer-dillesalade", "Gurken-Dill-Salat", "黄瓜莳萝沙拉", "きゅうりとディルのサラダ", "Insalata di cetrioli e aneto", "Salada de pepino e endro", "Салат из огурцов с укропом"
        )},
        "Margherita Flatbread": {"en": "Margherita Flatbread", **t(
            "Flatbread margarita", "Pa pla margarita", "Flatbread margherita", "Margherita flatbread", "Margherita-Fladenbrot", "玛格丽特扁面包", "マルゲリータフラットブレッド", "Flatbread margherita", "Pão achatado margherita", "Фlatbread марgherita"
        )},
        "Pesto Pasta": {"en": "Pesto Pasta", **t(
            "Pasta al pesto", "Pasta al pesto", "Pâtes au pesto", "Pasta met pesto", "Pesto-Pasta", "青酱意面", "ペstoパスタ", "Pasta al pesto", "Massa com pesto", "Пasta с pesto"
        )},
        "Chicken Burrito Bowl": {"en": "Chicken Burrito Bowl", **t(
            "Bowl burrito de pollo", "Bol burrito de pollastre", "Bol burrito au poulet", "Kip burrito bowl", "Hähnchen-Burrito-Bowl", "鸡肉墨西哥饭碗", "チキンブリトーボウル", "Burrito bowl di pollo", "Taça burrito de frango", "Burrito-боул с курицей"
        )},
        "Quinoa Power Salad": {"en": "Quinoa Power Salad", **t(
            "Ensalada energética de quinoa", "Amanida energètica de quinoa", "Salade énergisante au quinoa", "Quinoa power salade", "Quinoa-Power-Salat", "藜麦能量沙拉", "キノアパワーサラダ", "Insalata power al quinoa", "Salada power de quinoa", "Энергетический салат с киноа"
        )},
        "Yogurt Berry Parfait": {"en": "Yogurt Berry Parfait", **t(
            "Parfait de yogur y frutos rojos", "Parfait de iogurt i fruits del bosc", "Parfait yaourt et baies", "Yoghurt-bessen parfait", "Joghurt-Beeren-Parfait", "酸奶浆果芭菲", "ヨーグルトベリーパフェ", "Parfait di yogurt e frutti di bosco", "Parfait de iogurte e frutos vermelhos", "Йогуртовый parfait с ягодами"
        )},
        "Chocolate Avocado Mousse": {"en": "Chocolate Avocado Mousse", **t(
            "Mousse de chocolate y aguacate", "Mousse de xocolata i alvocat", "Mousse chocolat-avocat", "Chocolade-avocado mousse", "Schoko-Avocado-Mousse", "巧克力牛油果慕斯", "チョコアボカドムース", "Mousse al cioccolato e avocado", "Mousse de chocolate e abacate", "Шоколадный мусс с авокадо"
        )},
        "Apple Cinnamon Crumble": {"en": "Apple Cinnamon Crumble", **t(
            "Crumble de manzana y canela", "Crumble de poma i canela", "Crumble pomme-cannelle", "Appel-kaneel crumble", "Apfel-Zimt-Crumble", "苹果肉桂酥粒", "アップルシナモンクランブル", "Crumble di mele e cannella", "Crumble de maçã e canela", "Яблочный крамбл с корицей"
        )},
        "Vanilla Chia Pudding": {"en": "Vanilla Chia Pudding", **t(
            "Pudín de chía con vainilla", "Pudin de xia amb vainilla", "Pudding chia à la vanille", "Vanille chia pudding", "Vanille-Chia-Pudding", "香草奇亚籽布丁", "バニラチアプディング", "Budino di chia alla vaniglia", "Pudim de chia com baunilha", "Ванильный пудинг с чиа"
        )},
        "Baked Cinnamon Peaches": {"en": "Baked Cinnamon Peaches", **t(
            "Melocotones al horno con canela", "Préssecs al forn amb canela", "Pêches au four à la cannelle", "Gebakken perziken met kaneel", "Gebackene Pfirsiche mit Zimt", "肉桂烤桃子", "シナモン焼き桃", "Pesche al forno alla cannella", "Pêssegos assados com canela", "Запечённые персики с корицей"
        )},
        "Coconut Almond Cookies": {"en": "Coconut Almond Cookies", **t(
            "Galletas de coco y almendra", "Galetes de coco i ametlla", "Biscuits coco-amande", "Kokos-amandel koekjes", "Kokos-Mandel-Kekse", "椰香杏仁饼干", "ココナッツアーモンドクッキー", "Biscotti al cocco e mandorle", "Bolachas de coco e amêndoa", "Печенье с кокосом и миндалём"
        )},
        "Classic garlic and olive oil pasta — quick weeknight dinner.": {"en": "Classic garlic and olive oil pasta — quick weeknight dinner.", **t(
            "Pasta clásica de ajo y aceite de oliva: cena rápida entre semana.", "Pasta clàssica d'all i oli d'oliva: sopar ràpid entre setmana.", "Pâtes classiques à l'ail et à l'huile d'olive — dîner rapide en semaine.", "Klassieke knoflook- en olijfoliepasta — snel doordeweeks avondeten.", "Klassische Knoblauch-Olivenöl-Pasta — schnelles Abendessen unter der Woche.", "经典蒜香橄榄油意面——快速的工作日晚餐。", "定番のガーリックオリーブオイルパスタ——平日の手軽な夕食。", "Pasta classica aglio e olio — cena veloce infrasettimanale.", "Massa clássica de alho e azeite — jantar rápido durante a semana.", "Классическая пasta с чесноком и оливковым маслом — быстрый ужин в будни."
        )},
        "Balanced bowl with lean protein and greens.": {"en": "Balanced bowl with lean protein and greens.", **t(
            "Bowl equilibrado con proteína magra y verduras.", "Bol equilibrat amb proteïna magra i verdures.", "Bol équilibré avec protéines maigres et légumes verts.", "Evenwichtige bowl met mager eiwit en groente.", "Ausgewogene Bowl mit magerem Protein und Gemüse.", "蛋白质均衡、搭配绿叶蔬菜的饭碗。", "低カロリーたんぱく質と野菜のバランスボウル。", "Bowl equilibrato con proteine magre e verdure.", "Taça equilibrada com proteína magra e legumes.", "Сбалансированный боул с постным белком и зеленью."
        )},
        "Fluffy eggs ready in minutes — perfect for breakfast.": {"en": "Fluffy eggs ready in minutes — perfect for breakfast.", **t(
            "Huevos esponjosos en minutos: perfectos para el desayuno.", "Ous esponjosos en minuts: perfectes per esmorzar.", "Œufs moelleux en quelques minutes — parfaits au petit-déjeuner.", "Luchtige eieren in minuten — perfect voor het ontbijt.", "Fluffige Eier in Minuten — perfekt zum Frühstück.", "几分钟就能做好的松软炒蛋——早餐首选。", "数分でふわふわの卵——朝食にぴったり。", "Uova soffici in pochi minuti — perfette a colazione.", "Ovos fofinhos em minutos — perfeitos ao pequeno-almoço.", "Воздушная яичница за минуты — идеально на завтрак."
        )},
        "Crisp cucumbers, tomatoes, and feta with a lemon dressing.": {"en": "Crisp cucumbers, tomatoes, and feta with a lemon dressing.", **t(
            "Pepinos crujientes, tomates y feta con aliño de limón.", "Cogombres cruixents, tomàquets i feta amb vinagreta de llimona.", "Concombres croquants, tomates et feta avec vinaigrette au citron.", "Knapperige komkommer, tomaten en feta met citroendressing.", "Knackige Gurken, Tomaten und Feta mit Zitronendressing.", "爽脆黄瓜、番茄和羊奶酪，配柠檬 dressing。", "シャキシャキのキュウリ、トマト、フェタにレモンドレッシング。", "Cetrioli croccanti, pomodori e feta con dressing al limone.", "Pepinos crocantes, tomates e feta com molho de limão.", "Хрустящие огурцы, помидоры и фета с лимонной заправкой."
        )},
        "Comforting one-pot soup that keeps well for the week.": {"en": "Comforting one-pot soup that keeps well for the week.", **t(
            "Reconfortante sopa de una olla que aguanta bien toda la semana.", "Sopa reconfortant d'una olla que aguanta bé tota la setmana.", "Soupe réconfortante en un seul pot qui se conserve bien toute la semaine.", "Hartelijke eenpans soep die de hele week goed bewaart.", "Wohltuende Eintopfsuppe, die die ganze Woche hält.", "暖心的一锅汤，可以保存一整周。", "一週間保存できる心温まるワンポットスープ。", "Zuppa confortante in un'unica pentola che si conserva bene per la settimana.", "Sopa reconfortante de uma panela que dura bem a semana toda.", "Сытный суп в одной кастрюле — хорошо хранится всю неделю."
        )},
        "Golden salmon fillets with lemon and herbs.": {"en": "Golden salmon fillets with lemon and herbs.", **t(
            "Filetes de salmón dorados con limón y hierbas.", "Filets de salmó daurats amb llimona i herbes.", "Filets de saumon dorés au citron et aux herbes.", "Goudbruine zalmfilets met citroen en kruiden.", "Goldene Lachsfilets mit Zitrone und Kräutern.", "金黄的三文鱼片，配柠檬和香草。", "レモンとハーブで黄金色のサーモンフィレ。", "Filetti di salmone dorati con limone ed erbe.", "Filetes de salmão dourados com limão e ervas.", "Золотистое филе лосося с лимоном и травами."
        )},
        "No-cook oats with fruit — prep tonight, eat tomorrow.": {"en": "No-cook oats with fruit — prep tonight, eat tomorrow.", **t(
            "Avena sin cocción con fruta: prepárala hoy, cómela mañana.", "Civada sense cocció amb fruita: prepara-la avui, menja-la demà.", "Flocons d'avoine sans cuisson avec fruits — préparez ce soir, mangez demain.", "Havermout zonder koken met fruit — vanavond voorbereiden, morgen eten.", "Haferflocken ohne Kochen mit Obst — heute vorbereiten, morgen essen.", "免煮燕麦配水果——今晚准备，明天享用。", "火を使わないオーツとフルーツ——今夜仕込んで明日食べる。", "Fiocchi d'avena senza cottura con frutta — prepara stasera, mangia domani.", "Aveia sem cozedura com fruta — prepara hoje, come amanhã.", "Овсянка без варки с фруктами — приготовьте сегодня, ешьте завтра."
        )},
        "Smooth tomato soup with fresh basil.": {"en": "Smooth tomato soup with fresh basil.", **t(
            "Sopa suave de tomate con albahaca fresca.", "Sopa suau de tomàquet amb alfàbrega fresca.", "Soupe onctueuse de tomates au basilic frais.", "Romige tomatensoep met verse basilicum.", "Cremige Tomatensuppe mit frischem Basilikum.", "顺滑番茄汤，配新鲜罗勒。", "生バジルのなめらかトマトスープ。", "Zuppa liscia di pomodoro con basilico fresco.", "Sopa cremosa de tomate com manjericão fresco.", "Нежный томатный суп со свежим базиликом."
        )},
        "Two-ingredient frozen banana soft serve.": {"en": "Two-ingredient frozen banana soft serve.", **t(
            "Helado suave de plátano congelado de solo dos ingredientes.", "Gelat suau de plàtan congelat de només dos ingredients.", "Nice cream à la banane congelée en deux ingrédients.", "Twee-ingrediënten bevroren banaan soft serve.", "Gefrorenes Bananen-Softeis aus zwei Zutaten.", "两种食材的冷冻香蕉软冰淇淋。", "材料2つの冷凍バナナソフトクリーム。", "Soft serve di banana congelata con due ingredienti.", "Soft serve de banana congelada com dois ingredientes.", "Мягкое мороженое из замороженного бanana — два ингредиента."
        )},
        "Creamy one-pot curry with chickpeas and spinach.": {"en": "Creamy one-pot curry with chickpeas and spinach.", **t(
            "Curry cremoso de una olla con garbanzos y espinacas.", "Curry cremós d'una olla amb cigrons i espinacs.", "Curry crémeux en un seul pot avec pois chiches et épinards.", "Romige eenpans curry met kikkererwten en spinazie.", "Cremiges Eintopf-Curry mit Kichererbsen und Spinat.", "一锅浓郁咖喱，含鹰嘴豆和菠菜。", "ひよこ豆とほうれん草のクリーミーワンポットカレー。", "Curry cremoso in un'unica pentola con ceci e spinaci.", "Caril cremoso de uma panela com grão-de-bico e espinafres.", "Сливочное карри в одной кастрюле с нутом и шпинатом."
        )},
        "Colorful vegetables tossed in a ginger soy glaze.": {"en": "Colorful vegetables tossed in a ginger soy glaze.", **t(
            "Verduras coloridas salteadas con glaseado de jengibre y soja.", "Verdures colorides saltades amb glacejat de gingebre i soja.", "Légumes colorés enrobés d'un glaçage gingembre-soja.", "Kleurrijke groenten met gember-sojaglazuur.", "Bunte Gemüse mit Ingwer-Soja-Glasur.", "多彩蔬菜，裹上姜味酱油 glaze。", "生姜しょうゆグレーズの彩り野菜。", "Verdure colorate condite con glassa di zenzero e soia.", "Legumes coloridos com glaze de gengibre e soja.", "Яркие овощи в имбирно-соевой глазури."
        )},
        "Smashed avocado on toasted sourdough with chili flakes.": {"en": "Smashed avocado on toasted sourdough with chili flakes.", **t(
            "Aguacate aplastado sobre pan de masa madre tostado con copos de chile.", "Alvocat aixafat sobre pa de massa mare torrat amb flocs de xili.", "Avocat écrasé sur pain au levain grillé avec flocons de piment.", "Gestampte avocado op geroosterd desembrood met chilivlokken.", "Zerdrückte Avocado auf geröstetem Sauerteigbrot mit Chiliflocken.", "捣碎牛油果涂在烤酸种面包上，撒辣椒片。", "サワードウをトーストした上にアボカドをのせ、唐辛子フレークを添える。", "Avocado schiacciato su pane a lievitazione naturale tostato con peperoncino.", "Abacate esmagado sobre pão de massa madre torrado com flocos de pimenta.", "Размятый авокадо на тосте из закваски с хлопьями чili."
        )},
        "Tomatoes, mozzarella, and basil with balsamic.": {"en": "Tomatoes, mozzarella, and basil with balsamic.", **t(
            "Tomates, mozzarella y albahaca con balsámico.", "Tomàquets, mozzarella i alfàbrega amb balsàmic.", "Tomates, mozzarella et basilic au vinaigre balsamique.", "Tomaten, mozzarella en basilicum met balsamico.", "Tomaten, Mozzarella und Basilikum mit Balsamico.", "番茄、马苏里拉和罗勒，配 balsamic。", "トマト、モッツァレラ、バジルにバルサミコ。", "Pomodori, mozzarella e basilico con aceto balsamico.", "Tomates, mozzarella e manjericão com balsâmico.", "Помидоры, моцарелла и базилик с бalsamico."
        )},
        "Creamy arborio rice with sautéed mushrooms.": {"en": "Creamy arborio rice with sautéed mushrooms.", **t(
            "Arroz arborio cremoso con champiñones salteados.", "Arròs arborio cremós amb bolets saltats.", "Riz arborio crémeux aux champignons sautés.", "Romige arboriorijst met gebakken champignons.", "Cremiger Arborio-Reis mit sautierten Pilzen.", "奶油意式烩饭配炒蘑菇。", "きのこと一緒に炒めたクリーミーなアルボリオ米。", "Riso arborio cremoso con funghi saltati.", "Arroz arborio cremoso com cogumelos salteados.", "Сливочный рис арборио с обжаренными грибами."
        )},
        "Lean turkey meatballs in tomato sauce.": {"en": "Lean turkey meatballs in tomato sauce.", **t(
            "Albóndigas de pavo magras en salsa de tomate.", "Mandonguilles de gall dindi magres en salsa de tomàquet.", "Boulettes de dinde maigres à la sauce tomate.", "Mager kalkoengehaktballetjes in tomatensaus.", "Mageres Puten-Fleischbällchen in Tomatensauce.", "低脂火鸡肉丸配番茄酱。", "トマトソースの低脂肪七面鳥ミートボール。", "Polpette di tacchino magre in salsa di pomodoro.", "Almôndegas de peru magras em molho de tomate.", "Постные фрикадельки из индейки в томатном соусе."
        )},
        "Light omelette with spinach and herbs.": {"en": "Light omelette with spinach and herbs.", **t(
            "Tortilla ligera con espinacas y hierbas.", "Truita lleugera amb espinacs i herbes.", "Omelette légère aux épinards et herbes.", "Lichte omelet met spinazie en kruiden.", "Leichtes Omelett mit Spinat und Kräutern.", "轻量欧姆蛋，配菠菜和香草。", "ほうれん草とハーブの軽いオムレツ。", "Frittata leggera con spinaci ed erbe.", "Omelete leve com espinafres e ervas.", "Лёгкий омлет со шпинатом и травами."
        )},
        "Chicken, egg, avocado, and greens with ranch.": {"en": "Chicken, egg, avocado, and greens with ranch.", **t(
            "Pollo, huevo, aguacate y lechugas con ranch.", "Pollastre, ou, alvocat i enciams amb ranch.", "Poulet, œuf, avocat et salade avec ranch.", "Kip, ei, avocado en sla met ranch.", "Hähnchen, Ei, Avocado und Salat mit Ranch.", "鸡肉、鸡蛋、牛油果和沙拉菜，配 ranch。", "チキン、卵、アボカド、グリーンにランチドレッシング。", "Pollo, uovo, avocado e verdure con ranch.", "Frango, ovo, abacate e folhas com ranch.", "Курица, яйцо, авокадо и зелень с ranch."
        )},
        "Spiralized zucchini in a quick tomato sauce.": {"en": "Spiralized zucchini in a quick tomato sauce.", **t(
            "Calabacín en espiral con salsa de tomate rápida.", "Carbassó en espiral amb salsa de tomàquet ràpida.", "Courgettes spiralées dans une sauce tomate rapide.", "Gespiraliseerde courgette in snelle tomatensaus.", "Spiralisierte Zucchini in schneller Tomatensauce.", "螺旋西葫芦配快手番茄酱。", "手早いトマトソースのズッキーニヌードル。", "Zucchine spiralizzate in salsa di pomodoro veloce.", "Curgete espiralizada em molho de tomate rápido.", "Цуккини-спирали в быстром томатном соусе."
        )},
        "Simple grilled chicken with lemon and herbs.": {"en": "Simple grilled chicken with lemon and herbs.", **t(
            "Pollo a la plancha sencillo con limón y hierbas.", "Pollastre a la planxa senzill amb llimona i herbes.", "Poulet grillé simple au citron et aux herbes.", "Eenvoudige gegrilde kip met citroen en kruiden.", "Einfaches gegrilltes Hähnchen mit Zitrone und Kräutern.", "简单的柠檬香草烤鸡。", "レモンとハーブのシンプルなグリルチキン。", "Pollo alla griglia semplice con limone ed erbe.", "Frango grelhado simples com limão e ervas.", "Простая курица на гриле с лимоном и травами."
        )},
        "Seared steak cubes with garlic butter.": {"en": "Seared steak cubes with garlic butter.", **t(
            "Cubos de bistec dorados con mantequilla de ajo.", "Trossos de bistec daurats amb mantega d'all.", "Cubes de steak saisis au beurre à l'ail.", "Aangebakken steakblokjes met knoflookboter.", "Angebratene Steakwürfel mit Knoblauchbutter.", "香煎牛排粒，配蒜香黄油。", "ガーリックバターのステーキキューブ。", "Cubetti di bistecca rosolati con burro all'aglio.", "Cubos de bife salteados com manteiga de alho.", "Обжаренные кубики стейка с чесночным маслом."
        )},
        "Garlicky shrimp with lemon and parsley.": {"en": "Garlicky shrimp with lemon and parsley.", **t(
            "Camarones al ajillo con limón y perejil.", "Gambes amb all, llimona i julivert.", "Crevettes à l'ail avec citron et persil.", "Knoflookgarnalen met citroen en peterselie.", "Knoblauchgarnelen mit Zitrone und Petersilie.", "蒜香虾，配柠檬和 parsley。", "レモンとパセリのガーリックシュリンプ。", "Gamberetti all'aglio con limone e prezzemolo.", "Camarão alho com limão e salsa.", "Креветки с чесноком, лимоном и петрушкой."
        )},
        "Bake-ahead egg cups with spinach and cheese.": {"en": "Bake-ahead egg cups with spinach and cheese.", **t(
            "Tazas de huevo horneadas con espinacas y queso.", "Cups d'ou al forn amb espinacs i formatge.", "Muffins aux œufs cuits à l'avance avec épinards et fromage.", "Vooraf gebakken eimuffins met spinazie en kaas.", "Vorgebackene Eimuffins mit Spinat und Käse.", "可提前烤制的蛋杯，含菠菜和奶酪。", "ほうれん草とチーズの作り置きエッグカップ。", "Coppette di uova al forno con spinaci e formaggio.", "Copos de ovo assados com espinafres e queijo.", "Запекаемые яичные кружки со шpinatom и сыром."
        )},
        "Protein-packed tuna over crisp greens.": {"en": "Protein-packed tuna over crisp greens.", **t(
            "Atún rico en proteínas sobre lechugas crujientes.", "Tonyina rica en proteïnes sobre enciams cruixents.", "Thon riche en protéines sur salade croquante.", "Eiwitrijke tonijn op knapperige sla.", "Proteinreicher Thunfisch auf knackigem Salat.", "高蛋白金枪鱼配爽脆沙拉菜。", "シャキシャキのグリーンの上にたっぷりタンパク質のツナ。", "Tonno ricco di proteine su verdure croccanti.", "Atum rico em proteína sobre folhas crocantes.", "Белковый тунец на хрустящей зелени."
        )},
        "Broccoli, carrots, and green beans steamed until tender.": {"en": "Broccoli, carrots, and green beans steamed until tender.", **t(
            "Brócoli, zanahorias y judías verdes al vapor hasta quedar tiernas.", "Bròcoli, pastanagues i mongetes tendres al vapor fins que quedin tendres.", "Brocoli, carottes et haricots verts vapeur jusqu'à tendreté.", "Broccoli, wortelen en sperziebonen gestoomd tot gaar.", "Brokkoli, Karotten und grüne Bohnen gedämpft bis zart.", "西兰花、胡萝卜和四季豆蒸至 soft。", "ブロッコリー、にんじん、インゲンをやわらかく蒸す。", "Broccoli, carote e fagiolini al vapore fino a cottura morbida.", "Brócolos, cenouras e feijão-verde cozidos a vapor até ficarem tenros.", "Брокколи, морковь и стручковая фасоль на пару до мягкости."
        )},
        "Thick blended berries topped with granola.": {"en": "Thick blended berries topped with granola.", **t(
            "Frutos rojos batidos espesos cubiertos con granola.", "Fruits del bosc batuts espessos coberts amb granola.", "Baies mixées épaisses garnies de granola.", "Dikke gemixte bessen met granola erop.", "Dick pürierte Beeren mit Granola oben drauf.", "浓稠打碎的浆果，顶部撒 granola。", "グラノーラをのせたとろっとしたベリースムージー。", "Frutti di bosco frullati densi con granola sopra.", "Frutos vermelhos batidos espessos com granola por cima.", "Густой ягодный смузи с гранолой сверху."
        )},
        "Flaky cod baked with lemon and parsley.": {"en": "Flaky cod baked with lemon and parsley.", **t(
            "Bacalao tierno al horno con limón y perejil.", "Bacallà escàndol al forn amb llimona i julivert.", "Cabillaud croustillant au four au citron et persil.", "Malse kabeljauw uit de oven met citroen en peterselie.", "Zart blättriger Kabeljau aus dem Ofen mit Zitrone und Petersilie.", " flaky 鳕鱼，柠檬 parsley 烤制。", "レモンとパセリで焼いたほろほろタラ。", "Merluzzo sfaldato al forno con limone e prezzemolo.", "Bacalhau escamoso assado com limão e salsa.", "Нежная треска из духовки с лимоном и петрушкой."
        )},
        "Simple plant-based bowl with seasoned beans.": {"en": "Simple plant-based bowl with seasoned beans.", **t(
            "Bowl vegetal sencillo con frijoles sazonados.", "Bol vegetal senzill amb mongetes condimentades.", "Bol végétal simple aux haricots assaisonnés.", "Eenvoudige plantaardige bowl met gekruide bonen.", "Einfache pflanzliche Bowl mit gewürzten Bohnen.", "简单的 plant-based 饭碗，配调味 beans。", "スパイス香る豆のシンプルなプラントベースボウル。", "Bowl vegetale semplice con fagioli conditi.", "Taça vegetal simples com feijão temperado.", "Простой растительный боул с приправленной фасолью."
        )},
        "Cool cucumber salad with dill and vinegar.": {"en": "Cool cucumber salad with dill and vinegar.", **t(
            "Ensalada fresca de pepino con eneldo y vinagre.", "Amanida fresca de cogombre amb anet i vinagre.", "Salade fraîche de concombre à l'aneth et vinaigre.", "Koele komkommersalade met dille en azijn.", "Kühler Gurkensalat mit Dill und Essig.", "清爽黄瓜沙拉，配莳萝和醋。", "ディルと酢のさっぱりキュウリサラダ。", "Insalata fresca di cetrioli con aneto e aceto.", "Salada fresca de pepino com endro e vinagre.", "Освежающий салат из огурцов с укропом и уксусом."
        )},
        "Crispy flatbread with tomato, mozzarella, and basil.": {"en": "Crispy flatbread with tomato, mozzarella, and basil.", **t(
            "Pan plano crujiente con tomate, mozzarella y albahaca.", "Pa pla cruixent amb tomàquet, mozzarella i alfàbrega.", "Flatbread croustillant tomate, mozzarella et basilic.", "Knapperige flatbread met tomaat, mozzarella en basilicum.", "Knuspriges Fladenbrot mit Tomate, Mozzarella und Basilikum.", "脆扁面包，配番茄、马苏里拉和罗勒。", "トマト、モッツァレラ、バジルのサクサクフラットブレッド。", "Flatbread croccante con pomodoro, mozzarella e basilico.", "Pão achatado crocante com tomate, mozzarella e manjericão.", "Хрустящий flatbread с помидором, моцареллой и базиликом."
        )},
        "Basil pesto tossed with al dente pasta.": {"en": "Basil pesto tossed with al dente pasta.", **t(
            "Pesto de albahaca mezclado con pasta al dente.", "Pestó d'alfàbrega barrejat amb pasta al dente.", "Pesto au basilic mélangé à des pâtes al dente.", "Basilicumpesto gemengd met al dente pasta.", "Basilikum-Pesto mit al dente Pasta vermischt.", "罗勒青酱拌 al dente 意面。", "アルデンテのパスタにバジルペstoを和える。", "Pesto al basilico condito con pasta al dente.", "Pesto de manjericão envolvido em massa al dente.", "Basil pesto с пasta al dente."
        )},
        "Rice, beans, chicken, and salsa in one bowl.": {"en": "Rice, beans, chicken, and salsa in one bowl.", **t(
            "Arroz, frijoles, pollo y salsa en un solo bowl.", "Arròs, mongetes, pollastre i salsa en un sol bol.", "Riz, haricots, poulet et salsa dans un seul bol.", "Rijst, bonen, kip en salsa in één bowl.", "Reis, Bohnen, Hähnchen und Salsa in einer Bowl.", "一碗里有米饭、豆子、鸡肉和莎莎酱。", "ライス、豆、チキン、サルサを一つのボウルに。", "Riso, fagioli, pollo e salsa in un'unica bowl.", "Arroz, feijão, frango e salsa numa taça.", "Рис, фасоль, курица и сальса в одной миске."
        )},
        "Quinoa with chickpeas, cucumber, and lemon.": {"en": "Quinoa with chickpeas, cucumber, and lemon.", **t(
            "Quinoa con garbanzos, pepino y limón.", "Quinoa amb cigrons, cogombre i llimona.", "Quinoa aux pois chiches, concombre et citron.", "Quinoa met kikkererwten, komkommer en citroen.", "Quinoa mit Kichererbsen, Gurke und Zitrone.", "藜麦配鹰嘴豆、黄瓜和柠檬。", "キノアにひよこ豆、キュウリ、レモン。", "Quinoa con ceci, cetriolo e limone.", "Quinoa com grão-de-bico, pepino e limão.", "Киноа с нутом, огурцом и лимоном."
        )},
        "Layered yogurt, berries, and honey.": {"en": "Layered yogurt, berries, and honey.", **t(
            "Yogur, frutos rojos y miel en capas.", "Iogurt, fruits del bosc i mel en capes.", "Yaourt, baies et miel en couches.", "Yoghurt, bessen en honing in lagen.", "Joghurt, Beeren und Honig in Schichten.", "分层酸奶、浆果和蜂蜜。", "ヨーグルト、ベリー、はちみつを重ねる。", "Yogurt, frutti di bosco e miele a strati.", "Iogurte, frutos vermelhos e mel em camadas.", "Слоями йогурт, ягоды и мёд."
        )},
        "Rich dairy-free chocolate mousse.": {"en": "Rich dairy-free chocolate mousse.", **t(
            "Mousse de chocolate rica sin lácteos.", "Mousse de xocolata rica sense lactis.", "Mousse au chocolat riche sans produits laitiers.", "Rijke lactosevrije chocolademousse.", "Reichhaltige laktosefreie Schokoladenmousse.", "浓郁的无乳制品巧克力慕斯。", "濃厚な乳製品不使用チョコムース。", "Mousse al cioccolato ricca senza latticini.", "Mousse de chocolate rica sem lacticínios.", "Насыщенный шоколадный мусс без молочных продуктов."
        )},
        "Baked apples with an oat crumble topping.": {"en": "Baked apples with an oat crumble topping.", **t(
            "Manzanas al horno con cobertura crujiente de avena.", "Pomes al forn amb coberta cruixent de civada.", "Pommes au four avec crumble d'avoine.", "Gebakken appels met havermoutcrumble.", "Gebackene Äpfel mit Haferflocken-Crumble.", "烤苹果配燕麦酥粒 topping。", "オーツクランブルをのせた焼きリンゴ。", "Mele al forno con crumble di avena.", "Maçãs assadas com cobertura crumble de aveia.", "Запечённые яблоки с овсяной крошкой."
        )},
        "Creamy make-ahead chia pudding.": {"en": "Creamy make-ahead chia pudding.", **t(
            "Pudín de chía cremoso para preparar con antelación.", "Pudin de xia cremós per preparar amb antelació.", "Pudding chia crémeux à préparer à l'avance.", "Romige chia pudding om voor te bereiden.", "Cremiger Chia-Pudding zum Vorbereiten.", "可提前准备的奶油奇亚籽布丁。", "作り置きできるクリーミーチアプディング。", "Budino di chia cremoso da preparare in anticipo.", "Pudim de chia cremoso para preparar antecipadamente.", "Сливочный пудинг с чиа — можно приготовить заранее."
        )},
        "Warm peaches with cinnamon and oats.": {"en": "Warm peaches with cinnamon and oats.", **t(
            "Melocotones calientes con canela y avena.", "Préssecs calents amb canela i civada.", "Pêches chaudes à la cannelle et flocons d'avoine.", "Warme perziken met kaneel en havermout.", "Warme Pfirsiche mit Zimt und Haferflocken.", "温桃子配肉桂和燕麦。", "シナモンとオーツの温かい桃。", "Pesche calde con cannella e avena.", "Pêssegos quentes com canela e aveia.", "Тёплые персики с корицей и овсянкой."
        )},
        "Chewy cookies with coconut and almonds.": {"en": "Chewy cookies with coconut and almonds.", **t(
            "Galletas masticables de coco y almendra.", "Galetes mastegables de coco i ametlla.", "Biscuits moelleux coco et amande.", "Kauwige koekjes met kokos en amandel.", "Kauige Kekse mit Kokos und Mandeln.", "椰香杏仁软曲奇。", "ココナッツとアーモンドのもちもちクッキー。", "Biscotti morbidi al cocco e mandorle.", "Bolachas mastigáveis de coco e amêndoa.", "Мягкое печенье с кокосом и миндалём."
        )},
        "Boil salted water and cook spaghetti until al dente.": {"en": "Boil salted water and cook spaghetti until al dente.", **t(
            "Hierve agua con sal y cocina los espaguetis al dente.", "Bull aigua amb sal i cou els espaguetis al dente.", "Portez de l'eau salée à ébullition et cuisez les spaghetti al dente.", "Kook gezouten water en kook spaghetti al dente.", "Salzwasser aufkochen und Spaghetti al dente kochen.", "烧 salted 水，将意大利面煮至弹牙。", "塩を加えたお湯でスパゲッティをアルデンテに茹でる。", "Porta l'acqua salata a ebollizione e cuoci gli spaghetti al dente.", "Ferva água com sal e coza o esparguete al dente.", "Вскипятите подсоленную воду и отварите спагетти al dente."
        )},
        "Slice garlic thinly and gently sauté in olive oil until fragrant.": {"en": "Slice garlic thinly and gently sauté in olive oil until fragrant.", **t(
            "Corta el ajo en láminas finas y sofríelo suavemente en aceite de oliva hasta que huela.", "Talla l'all a làmines fines i sofregeix-lo suaument en oli d'oliva fins que perfumi.", "Émincez l'ail et faites-le revenir doucement dans l'huile d'olive jusqu'à ce qu'il parfume.", "Snijd knoflook dun en fruit zacht in olijfolie tot het geurig is.", "Knoblauch dünn schneiden und sanft in Olivenöl anbraten, bis er duftet.", "将大蒜切薄片，用橄榄油小火慢炒至飘香。", "にんにくを薄切りにし、オリーブオイルで弱火で香りが出るまで炒める。", "Affetta sottilmente l'aglio e fallo soffriggere dolcemente nell'olio d'oliva finché profuma.", "Corte o alho em fatias finas e refogue suavemente no azeite até perfumar.", "Нарежьте чеснок тонкими л slices и обжарьте на оливковом масле до аромата."
        )},
        "Toss drained pasta with the garlic oil. Season and serve.": {"en": "Toss drained pasta with the garlic oil. Season and serve.", **t(
            "Mezcla la pasta escurrida con el aceite de ajo. Sazona y sirve.", "Barreja la pasta escorrida amb l'oli d'all. Condimenta i serveix.", "Mélangez les pâtes égouttées avec l'huile à l'ail. Assaisonnez et servez.", "Meng de uitgelekte pasta met de knoflookolie. Breng op smaak en serveer.", "Abgetropfte Pasta mit Knoblauchöl vermengen. Würzen und servieren.", "将沥干的意面与蒜油拌匀。调味后上桌。", "水を切ったパスタにガーリックオイルを絡め、味付けして盛る。", "Condisci la pasta scolata con l'olio all'aglio. Sala e servi.", "Envolva a massa escorrida no óleo de alho. Tempere e sirva.", "Смешайте слитую пasta с чесночным маслом. Приправьте и подавайте."
        )},
        "Cook brown rice according to package directions.": {"en": "Cook brown rice according to package directions.", **t(
            "Cocina el arroz integral según las instrucciones del paquete.", "Cou l'arròs integral segons les instruccions del paquet.", "Cuisez le riz complet selon les instructions de l'emballage.", "Kook zilvervliesrijst volgens de aanwijzingen op de verpakking.", "Vollkornreis nach Packungsanleitung kochen.", "按包装说明煮糙米。", "パッケージの表示通りに玄米を炊く。", "Cuoci il riso integrale secondo le istruzioni sulla confezione.", "Coza o arroz integral conforme as instruções da embalagem.", "Приготовьте бурый рис по инструкции на упаковке."
        )},
        "Cook rice according to package directions.": {"en": "Cook rice according to package directions.", **t(
            "Cocina el arroz según las instrucciones del paquete.", "Cou l'arròs segons les instruccions del paquet.", "Cuisez le riz selon les instructions de l'emballage.", "Kook rijst volgens de aanwijzingen op de verpakking.", "Reis nach Packungsanleitung kochen.", "按包装说明煮饭。", "パッケージの表示通りに米を炊く。", "Cuoci il riso secondo le istruzioni sulla confezione.", "Coza o arroz conforme as instruções da embalagem.", "Приготовьте рис по инструкции на упаковке."
        )},
        "Season chicken and pan-sear until cooked through.": {"en": "Season chicken and pan-sear until cooked through.", **t(
            "Sazona el pollo y dóralo en sartén hasta que esté cocido.", "Condimenta el pollastre i daura'l a la paella fins que estigui fet.", "Assaisonnez le poulet et faites-le poêler jusqu'à cuisson complète.", "Kruid de kip en bak in de pan tot gaar.", "Hähnchen würzen und in der Pfanne braten, bis es durch ist.", "给鸡肉调味，平底锅煎至全熟。", "鶏肉に味付けし、フライパンで中まで火を通す。", "Condisci il pollo e rosolalo in padella fino a cottura completa.", "Tempere o frango e salteie na frigideira até cozinhar por completo.", "Приправьте курицу и обжарьте на сковороде до готовности."
        )},
        "Steam broccoli until tender-crisp.": {"en": "Steam broccoli until tender-crisp.", **t(
            "Cuece el brócoli al vapor hasta que quede tierno pero crujiente.", "Cou el bròcoli al vapor fins que quedi tendre però cruixent.", "Cuisez le brocoli à la vapeur jusqu'à tendreté croquante.", "Stoom broccoli tot hij gaar maar knapperig is.", "Brokkoli dämpfen, bis er zart-knackig ist.", "将西兰花蒸至爽脆软嫩。", "ブロッコリーを歯ごたえのあるやわらかさまで蒸す。", "Cuoci a vapore i broccoli fino a cottura morbida ma croccante.", "Coza os brócolos a vapor até ficarem tenros mas crocantes.", "Приготовьте брокколи на пару до мягкости с хрустом."
        )},
        "Slice chicken and assemble bowls with rice and broccoli.": {"en": "Slice chicken and assemble bowls with rice and broccoli.", **t(
            "Corta el pollo y monta los bowls con arroz y brócoli.", "Talla el pollastre i munta els bols amb arròs i bròcoli.", "Tranchez le poulet et assemblez les bols avec riz et brocoli.", "Snijd de kip en stel bowls samen met rijst en broccoli.", "Hähnchen schneiden und Bowls mit Reis und Brokkoli anrichten.", "切片鸡肉，与米饭和西兰花组装成碗。", "鶏肉を切り、ライスとブロッコリーでボウルを組み立てる。", "Affetta il pollo e componi i bowl con riso e broccoli.", "Corte o frango e monte as taças com arroz e brócolos.", "Нарежьте курицу и соберите боулы с рисом и брокколи."
        )},
        "Whisk eggs with milk, salt, and pepper.": {"en": "Whisk eggs with milk, salt, and pepper.", **t(
            "Bate los huevos con leche, sal y pimienta.", "Bate els ous amb llet, sal i pebre.", "Battez les œufs avec le lait, le sel et le poivre.", "Klop eieren met melk, zout en peper.", "Eier mit Milch, Salz und Pfeffer verquirlen.", "将鸡蛋与牛奶、盐和 pepper 搅打。", "卵に牛乳、塩、こしょうを加えて混ぜる。", "Sbatti le uova con latte, sale e pepe.", "Bata os ovos com leite, sal e pimenta.", "Взбейте яйца с молоком, солью и перцем."
        )},
        "Melt butter in a pan over medium-low heat.": {"en": "Melt butter in a pan over medium-low heat.", **t(
            "Derrite la mantequilla en una sartén a fuego medio-bajo.", "Desfés la mantega en una paella a foc mitjà-baix.", "Faites fondre le beurre dans une poêle à feu moyen-doux.", "Smelt boter in een pan op laag-middelhoog vuur.", "Butter in einer Pfanne bei mittlerer Hitze schmelzen.", "中火将黄油在平底锅中融化。", "フライパンで中火以下の弱火でバターを溶かす。", "Sciogli il burro in padella a fuoco medio-basso.", "Derreta a manteiga numa frigideira em lume médio-baixo.", "Растопите масло на сковороде на среднем огне."
        )},
        "Cook eggs slowly, stirring, until softly set.": {"en": "Cook eggs slowly, stirring, until softly set.", **t(
            "Cocina los huevos lentamente, removiendo, hasta que cuajen suavemente.", "Cou els ous lentament, remenant, fins que quedin suaument cuajats.", "Cuisez les œufs lentement en remuant jusqu'à prise moelleuse.", "Kook eieren langzaam onder roeren tot zacht gestold.", "Eier langsam unter Rühren stocken lassen.", "小火慢炒鸡蛋，不断搅拌至 soft set。", "弱火でゆっくり混ぜながら、半熟状になるまで加熱する。", "Cuoci le uova lentamente mescolando fino a cottura morbida.", "Coza os ovos lentamente, mexendo, até ficarem suavemente firmes.", "Готовьте яйца медленно, помешивая, до мягкой готовности."
        )},
        "Chop cucumber, tomatoes, and crumble feta.": {"en": "Chop cucumber, tomatoes, and crumble feta.", **t(
            "Pica pepino y tomates y desmenuza la feta.", "Pica cogombre i tomàquets i esmicola la feta.", "Hachez concombre et tomates et émiettez la feta.", "Hak komkommer en tomaten en verkruimel feta.", "Gurke und Tomaten hacken und Feta zerbröseln.", "切 cucumber、番茄，弄碎羊奶酪。", "キュウリとトマトを切り、フェタを崩す。", "Trita cetriolo e pomodori e sbriciola la feta.", "Pique pepino e tomates e esmigalhe a feta.", "Нарежьте огурец и помидоры, раскрошите фету."
        )},
        "Whisk olive oil with lemon juice, salt, and oregano.": {"en": "Whisk olive oil with lemon juice, salt, and oregano.", **t(
            "Bate aceite de oliva con zumo de limón, sal y orégano.", "Bate oli d'oliva amb suc de llimona, sal i orenga.", "Fouettez huile d'olive avec jus de citron, sel et origan.", "Klop olijfolie met citroensap, zout en oregano.", "Olivenöl mit Zitronensaft, Salz und Oregano verquirlen.", "将橄榄油与柠檬汁、盐和 oregano 搅打。", "オリーブオイルにレモン汁、塩、オレガノを混ぜる。", "Sbatti olio d'oliva con succo di limone, sale e origano.", "Bata azeite com sumo de limão, sal e orégãos.", "Взбейте оливковое масло с лимонным соком, солью и оregano."
        )},
        "Toss vegetables with dressing and serve immediately.": {"en": "Toss vegetables with dressing and serve immediately.", **t(
            "Mezcla las verduras con el aliño y sirve al momento.", "Barreja les verdures amb el vinagreta i serveix immediatament.", "Mélangez les légumes avec la vinaigrette et servez aussitôt.", "Meng groenten met dressing en serveer meteen.", "Gemüse mit Dressing vermengen und sofort servieren.", "将蔬菜与 dressing 拌匀，立即上桌。", "野菜にドレッシングを絡め、すぐに盛る。", "Condisci le verdure con il dressing e servi subito.", "Envolva os legumes no molho e sirva de imediato.", "Смешайте овощи с заправкой и сразу подавайте."
        )},
        "Dice onion and carrot.": {"en": "Dice onion and carrot.", **t(
            "Pica cebolla y zanahoria en cubos.", "Talla ceba i pastanaga a daus.", "Coupez oignon et carotte en dés.", "Snijd ui en wortel in blokjes.", "Zwiebel und Karotte würfeln.", "将洋葱和胡萝卜切丁。", "玉ねぎとにんじんを角切りにする。", "Taglia a cubetti cipolla e carota.", "Corte cebola e cenoura em cubos.", "Нарежьте лук и морковь кубиками."
        )},
        "Sauté vegetables until softened.": {"en": "Sauté vegetables until softened.", **t(
            "Saltea las verduras hasta que se ablanden.", "Salteja les verdures fins que s'abandonin.", "Faites revenir les légumes jusqu'à ramollissement.", "Fruit groenten tot ze zacht zijn.", "Gemüse anbraten, bis es weich ist.", "将蔬菜炒至变软。", "野菜がやわらかくなるまで炒める。", "Fai soffriggere le verdure fino a ammorbidimento.", "Salteie os legumes até amolecerem.", "Обжарьте овощи до мягкости."
        )},
        "Add lentils and broth. Simmer until tender.": {"en": "Add lentils and broth. Simmer until tender.", **t(
            "Añade lentejas y caldo. Cocina a fuego lento hasta que estén tiernas.", "Afegeix llenties i brou. Cou a foc lent fins que estiguin tendres.", "Ajoutez lentilles et bouillon. Laissez mijoter jusqu'à tendreté.", "Voeg linzen en bouillon toe. Laat sudderen tot gaar.", "Linsen und Brühe hinzufügen. Köcheln lassen, bis zart.", "加入扁豆和高汤，小火炖至 soft。", "レンズ豆とブイヨンを加え、やわらかくなるまで煮る。", "Aggiungi lenticchie e brodo. Cuoci a fuoco lento fino a cottura.", "Adicione lentilhas e caldo. Coza em lume brando até ficarem tenras.", "Добавьте чечевицу и бульон. Тушите до мягкости."
        )},
        "Pat salmon dry and season with salt and pepper.": {"en": "Pat salmon dry and season with salt and pepper.", **t(
            "Seca el salmón y sazona con sal y pimienta.", "Asseca el salmó i condimenta amb sal i pebre.", "Séchez le saumon et assaisonnez de sel et poivre.", "Dep salmon droog en breng op smaak met zout en peper.", "Lachs trocken tupfen und mit Salz und Pfeffer würzen.", "擦干三文鱼，撒盐和 pepper。", "サーモンの水気を取り、塩こしょうで味付けする。", "Asciuga il salmone e condisci con sale e pepe.", "Seque o salmão e tempere com sal e pimenta.", "Обсушите лосось и приправьте солью и перцем."
        )},
        "Sear skin-side down in hot oil until crisp.": {"en": "Sear skin-side down in hot oil until crisp.", **t(
            "Dora con la piel hacia abajo en aceite caliente hasta que quede crujiente.", "Daura amb la pell cap avall en oli calent fins que quedi cruixent.", "Saisissez côté peau dans l'huile chaude jusqu'à croustillant.", "Bak met de huid naar beneden in hete olie tot krokant.", "Mit der Hautseite nach unten in heißem Öl braten, bis knusprig.", "皮朝下在热油中煎至酥脆。", "皮目を下にして熱い油でカリッと焼き色を付ける。", "Rosola con la pelle verso il basso in olio caldo fino a croccante.", "Salteie com a pele para baixo em óleo quente até ficar crocante.", "Обжарьте кожей вниз на горячем масле до хруста."
        )},
        "Flip and cook through. Finish with lemon.": {"en": "Flip and cook through. Finish with lemon.", **t(
            "Voltea y cocina por completo. Termina con limón.", "Gira i cou per complet. Acaba amb llimona.", "Retournez et cuisez à cœur. Finissez au citron.", "Keer om en gaar door. Afwerken met citroen.", "Wenden und durchgaren. Mit Zitrone abschmecken.", "翻面至全熟，最后挤柠檬。", "ひっくり返して中まで火を通し、レモンを添える。", "Gira e cuoci completamente. Completa con limone.", "Vire e cozinhe por completo. Finalize com limão.", "Переверните и доведите до готовности. Завершите лимоном."
        )},
        "Combine oats, milk, and chia seeds in a jar.": {"en": "Combine oats, milk, and chia seeds in a jar.", **t(
            "Mezcla avena, leche y semillas de chía en un tarro.", "Barreja civada, llet i llavors de xia en un pot.", "Mélangez flocons d'avoine, lait et graines de chia dans un bocal.", "Meng havermout, melk en chiazaad in een pot.", "Haferflocken, Milch und Chiasamen in einem Glas mischen.", "在密封罐中混合燕麦、牛奶和奇亚籽。", "瓶にオーツ、牛乳、チアシードを入れて混ぜる。", "Mescola fiocchi d'avena, latte e semi di chia in un barattolo.", "Misture aveia, leite e sementes de chia num frasco.", "Смешайте овсянку, молоко и семена чиа в банке."
        )},
        "Refrigerate overnight.": {"en": "Refrigerate overnight.", **t(
            "Refrigera toda la noche.", "Refrigera tota la nit.", "Réfrigérez toute la nuit.", "Koel een nacht in de koelkast.", "Über Nacht im Kühlschrank stellen.", "冷藏过夜。", "一晩冷蔵庫で寝かせる。", "Refrigera tutta la notte.", "Refrigere durante a noite.", "Поставьте в холодильник на ночь."
        )},
        "Top with sliced banana before serving.": {"en": "Top with sliced banana before serving.", **t(
            "Corona con plátano en rodajas antes de servir.", "Corona amb plàtan en rodanxes abans de servir.", "Garnissez de banane en tranches avant de servir.", "Garneer met gesneden banaan voor het serveren.", "Vor dem Servieren mit Bananenscheiben garnieren.", "上桌前铺上香蕉片。", "提供前にバナナのスライスをのせる。", "Guarnisci con fette di banana prima di servire.", "Cubra com rodelas de banana antes de servir.", "Перед подачей украсьте ломтиками банана."
        )},
        "Sauté chopped onion until soft.": {"en": "Sauté chopped onion until soft.", **t(
            "Saltea cebolla picada hasta que esté blanda.", "Salteja ceba picada fins que estigui tova.", "Faites revenir l'oignon haché jusqu'à ramollissement.", "Fruit gesnipperde ui tot zacht.", "Gehackte Zwiebel anbraten, bis weich.", "将切碎的洋葱炒至 soft。", "みじん切り玉ねぎがやわらかくなるまで炒める。", "Fai soffriggere la cipolla tritata fino a ammorbidimento.", "Salteie cebola picada até ficar macia.", "Обжарьте нарезанный лук до мягкости."
        )},
        "Add tomatoes and broth. Simmer for 20 minutes.": {"en": "Add tomatoes and broth. Simmer for 20 minutes.", **t(
            "Añade tomates y caldo. Cocina a fuego lento 20 minutos.", "Afegeix tomàquets i brou. Cou a foc lent 20 minuts.", "Ajoutez tomates et bouillon. Laissez mijoter 20 minutes.", "Voeg tomaten en bouillon toe. Laat 20 minuten sudderen.", "Tomaten und Brühe hinzufügen. 20 Minuten köcheln.", "加入番茄和高汤，小火炖 20 分钟。", "トマトとブイヨンを加え、20分弱火で煮る。", "Aggiungi pomodori e brodo. Cuoci a fuoco lento per 20 minuti.", "Adicione tomates e caldo. Coza em lume brando 20 minutos.", "Добавьте помидоры и бульон. Тушите 20 минут."
        )},
        "Blend until smooth and stir in fresh basil.": {"en": "Blend until smooth and stir in fresh basil.", **t(
            "Tritura hasta quedar suave e incorpora albahaca fresca.", "Tritura fins que quedi suau i incorpora alfàbrega fresca.", "Mixez jusqu'à lisse et incorporez le basilic frais.", "Mix tot glad en roer verse basilicum erdoor.", "Pürieren und frisches Basilikum einrühren.", "打至顺滑，拌入新鲜罗勒。", "滑らかになるまで混ぜ、生バジルを加える。", "Frulla fino a liscio e incorpora il basilico fresco.", "Triture até ficar cremoso e envolva manjericão fresco.", "Измельчите до однородности и добавьте свежий базилик."
        )},
        "Peel and slice ripe bananas. Freeze until solid.": {"en": "Peel and slice ripe bananas. Freeze until solid.", **t(
            "Pela y corta plátanos maduros. Congela hasta que estén sólidos.", "Pelar i talla plàtans madurs. Congela fins que estiguin sòlids.", "Épluchez et tranchez des bananes mûres. Congelez jusqu'à solidification.", "Schil en snijd rijpe bananen. Vries in tot hard.", "Reife Bananen schälen und schneiden. Bis fest einfrieren.", "去皮切熟香蕉，冷冻至 solid。", "熟したバナナを皮をむいて切り、固まるまで冷凍する。", "Sbuccia e affetta banane mature. Congela fino a solidificazione.", "Descasque e corte bananas maduras. Congele até ficarem sólidas.", "Очистите и нарежьте спелые бананы. Заморозьте до застывания."
        )},
        "Blend frozen banana with almond milk until creamy.": {"en": "Blend frozen banana with almond milk until creamy.", **t(
            "Tritura plátano congelado con leche de almendras hasta quedar cremoso.", "Tritura plàtan congelat amb llet d'ametlla fins que quedi cremós.", "Mixez banane congelée et lait d'amande jusqu'à crémeux.", "Mix bevroren banaan met amandelmelk tot romig.", "Gefrorene Banane mit Mandelmilch cremig pürieren.", "将冷冻香蕉与杏仁奶打至顺滑。", "冷凍バナナとアーモンドミルクをクリーミーになるまで混ぜる。", "Frulla banana congelata con latte di mandorle fino a cremoso.", "Triture banana congelada com leite de amêndoa até ficar cremosa.", "Взбейте замороженный банан с миндальным молоком до кремовой консистенции."
        )},
        "Serve immediately or freeze briefly for a firmer texture.": {"en": "Serve immediately or freeze briefly for a firmer texture.", **t(
            "Sirve al momento o congela un poco para una textura más firme.", "Serveix immediatament o congela una estona per una textura més ferma.", "Servez aussitôt ou congelez brièvement pour une texture plus ferme.", "Serveer meteen of vries kort in voor stevigere textuur.", "Sofort servieren oder kurz einfrieren für festere Konsistenz.", "立即上桌，或 brief 冷冻以获得更 firm 口感。", "すぐに提供するか、少し冷凍して固めの食感にする。", "Servi subito o congela brevemente per una texture più compatta.", "Sirva de imediato ou congele brevemente para textura mais firme.", "Подавайте сразу или ненадолго заморозьте для более плотной текстуры."
        )},
        "Dice onion and sauté until soft.": {"en": "Dice onion and sauté until soft.", **t(
            "Pica cebolla y sofríela hasta que esté blanda.", "Talla ceba i sofregeix-la fins que estigui tova.", "Coupez l'oignon en dés et faites-le revenir jusqu'à ramollissement.", "Snijd ui in blokjes en fruit tot zacht.", "Zwiebel würfeln und anbraten, bis weich.", "洋葱切丁，炒至 soft。", "玉ねぎを角切りにして、やわらかくなるまで炒める。", "Taglia a cubetti la cipolla e soffriggila fino a ammorbidimento.", "Corte cebola em cubos e refogue até ficar macia.", "Нарежьте лук кубиками и обжарьте до мягкости."
        )},
        "Add chickpeas, coconut milk, and spinach. Simmer.": {"en": "Add chickpeas, coconut milk, and spinach. Simmer.", **t(
            "Añade garbanzos, leche de coco y espinacas. Cocina a fuego lento.", "Afegeix cigrons, llet de coco i espinacs. Cou a foc lent.", "Ajoutez pois chiches, lait de coco et épinards. Laissez mijoter.", "Voeg kikkererwten, kokosmelk en spinazie toe. Laat sudderen.", "Kichererbsen, Kokosmilch und Spinat hinzufügen. Köcheln.", "加入鹰嘴豆、椰浆和菠菜，小火炖。", "ひよこ豆、ココナッツミルク、ほうれん草を加えて煮る。", "Aggiungi ceci, latte di cocco e spinaci. Cuoci a fuoco lento.", "Adicione grão-de-bico, leite de coco e espinafres. Coza em lume brando.", "Добавьте нут, кокосовое молоко и шпинат. Тушите."
        )},
        "Season and serve with rice or flatbread.": {"en": "Season and serve with rice or flatbread.", **t(
            "Sazona y sirve con arroz o pan plano.", "Condimenta i serveix amb arròs o pa pla.", "Assaisonnez et servez avec riz ou pain plat.", "Breng op smaak en serveer met rijst of flatbread.", "Würzen und mit Reis oder Fladenbrot servieren.", "调味，配米饭或扁面包上桌。", "味付けし、ライスかフラットブレッドと一緒に盛る。", "Condisci e servi con riso o pane piadina.", "Tempere e sirva com arroz ou pão achatado.", "Приправьте и подавайте с рисом или лавашом."
        )},
        "Slice peppers and broccoli.": {"en": "Slice peppers and broccoli.", **t(
            "Corta pimientos y brócoli.", "Talla pebrots i bròcoli.", "Tranchez poivrons et brocoli.", "Snijd paprika's en broccoli.", "Paprika und Brokkoli schneiden.", "切甜椒和西兰花。", "パプリカとブロッコリーを切る。", "Affetta peperoni e broccoli.", "Corte pimentos e brócolos.", "Нарежьте перец и брокколи."
        )},
        "Stir-fry vegetables over high heat.": {"en": "Stir-fry vegetables over high heat.", **t(
            "Saltea las verduras a fuego fuerte.", "Salteja les verdures a foc fort.", "Faites sauter les légumes à feu vif.", "Roerbak groenten op hoog vuur.", "Gemüse bei starker Hitze anbraten.", "大火快炒蔬菜。", "強火で野菜を炒める。", "Saltare le verdure a fuoco alto.", "Salteie os legumes em lume forte.", "Обжарьте овощи на сильном огне."
        )},
        "Add soy sauce and ginger. Toss to coat.": {"en": "Add soy sauce and ginger. Toss to coat.", **t(
            "Añade salsa de soja y jengibre. Mezcla para cubrir.", "Afegeix salsa de soja i gingebre. Barreja per cobrir.", "Ajoutez sauce soja et gingembre. Enrobez bien.", "Voeg sojasaus en gember toe. Goed omscheppen.", "Sojasauce und Ingwer hinzufügen. Gut vermengen.", "加入酱油和姜，拌匀裹匀。", "醤油と生姜を加え、全体に絡める。", "Aggiungi salsa di soia e zenzero. Mescola per ricoprire.", "Adicione molho de soja e gengibre. Envolva bem.", "Добавьте соевый соус и имбирь. Перемешайте."
        )},
        "Toast bread until golden.": {"en": "Toast bread until golden.", **t(
            "Tuesta el pan hasta dorar.", "Tosta el pa fins daurar.", "Grillez le pain jusqu'à doré.", "Rooster brood tot goudbruin.", "Brot goldbraun toasten.", "将面包烤至金黄。", "パンをきつね色になるまでトーストする。", "Tosta il pane fino a doratura.", "Torre o pão até dourar.", "Поджарьте хлеб до золотистого цвета."
        )},
        "Mash avocado with salt and chili flakes.": {"en": "Mash avocado with salt and chili flakes.", **t(
            "Aplasta aguacate con sal y copos de chile.", "Aixafa alvocat amb sal i flocs de xili.", "Écrasez l'avocat avec sel et flocons de piment.", "Prak avocado met zout en chilivlokken.", "Avocado mit Salz und Chiliflocken zerdrücken.", "将牛油果加盐和辣椒片捣碎。", "アボカドに塩と唐辛子フレークを加えて潰す。", "Schiaccia l'avocado con sale e peperoncino.", "Esmague abacate com sal e flocos de pimenta.", "Разомните авокадо с солью и хлопьями чili."
        )},
        "Spread on toast and serve.": {"en": "Spread on toast and serve.", **t(
            "Extiende sobre la tostada y sirve.", "Estén sobre la torrada i serveix.", "Étalez sur le toast et servez.", "Smeer op toast en serveer.", "Auf Toast streichen und servieren.", "涂在 toast 上上桌。", "トーストに塗って提供する。", "Spalmare sul toast e servire.", "Espalhe na tosta e sirva.", "Намажьте на тост и подавайте."
        )},
        "Slice tomatoes and mozzarella.": {"en": "Slice tomatoes and mozzarella.", **t(
            "Corta tomates y mozzarella.", "Talla tomàquets i mozzarella.", "Tranchez tomates et mozzarella.", "Snijd tomaten en mozzarella.", "Tomaten und Mozzarella schneiden.", "切番茄和马苏里拉。", "トマトとモッツァレラを切る。", "Affetta pomodori e mozzarella.", "Corte tomates e mozzarella.", "Нарежьте помидоры и моцареллу."
        )},
        "Arrange with basil leaves.": {"en": "Arrange with basil leaves.", **t(
            "Coloca con hojas de albahaca.", "Col·loca amb fulles d'alfàbrega.", "Disposez avec des feuilles de basilic.", "Schik met basilicumbladeren.", "Mit Basilikumblättern anrichten.", "摆盘，配罗勒叶。", "バジルの葉を添えて並べる。", "Disponi con foglie di basilico.", "Disponha com folhas de manjericão.", "Выложите с листьями базилика."
        )},
        "Drizzle with balsamic and olive oil.": {"en": "Drizzle with balsamic and olive oil.", **t(
            "Rociar con balsámico y aceite de oliva.", "Ruixa amb balsàmic i oli d'oliva.", "Arrosez de balsamique et huile d'olive.", "Besprenkel met balsamico en olijfolie.", "Mit Balsamico und Olivenöl beträufeln.", "淋 balsamic 和橄榄油。", "バルサミコとオリーブオイルをかける。", "Condisci con aceto balsamico e olio d'oliva.", "Regue com balsâmico e azeite.", "Полейте бalsamico и оливковым маслом."
        )},
        "Sauté sliced mushrooms.": {"en": "Sauté sliced mushrooms.", **t(
            "Saltea champiñones laminados.", "Salteja bolets laminats.", "Faites revenir les champignons émincés.", "Fruit gesneden champignons.", "Geschnittene Pilze anbraten.", "炒切片蘑菇。", "スライスしたきのこを炒める。", "Fai saltare i funghi affettati.", "Salteie cogumelos fatiados.", "Обжарьте нарезанные грибы."
        )},
        "Toast rice and add warm broth gradually.": {"en": "Toast rice and add warm broth gradually.", **t(
            "Tuesta el arroz y añade caldo caliente poco a poco.", "Tosta l'arròs i afegeix brou calent a poc a poc.", "Faites revenir le riz et ajoutez le bouillon chaud progressivement.", "Rooster rijst en voeg geleidelijk warme bouillon toe.", "Reis anrösten und nach und nach warme Brühe zugießen.", "炒香米饭， gradually 加入热 broth。", "米を炒め、温かいブイヨンを少しずつ加える。", "Tosta il riso e aggiungi brodo caldo gradualmente.", "Toste o arroz e adicione caldo quente aos poucos.", "Обжарьте рис и постепенно добавляйте горячий бульон."
        )},
        "Stir until creamy and finish with parmesan.": {"en": "Stir until creamy and finish with parmesan.", **t(
            "Remueve hasta quedar cremoso y termina con parmesano.", "Remena fins que quedi cremós i acaba amb parmesà.", "Remuez jusqu'à crémeux et finissez au parmesan.", "Roer tot romig en werk af met parmezaan.", "Rühren bis cremig und mit Parmesan abschließen.", "搅拌至 creamy，最后加帕玛森。", "クリーミーになるまで混ぜ、パルメザンを仕上げに加える。", "Mescola fino a cremoso e completa con parmigiano.", "Mexa até ficar cremoso e finalize com parmesão.", "Помешивайте до кремовости и добавьте пармезан."
        )},
        "Mix turkey, egg, and seasonings. Form meatballs.": {"en": "Mix turkey, egg, and seasonings. Form meatballs.", **t(
            "Mezcla pavo, huevo y condimentos. Forma albóndigas.", "Barreja gall dindi, ou i condiments. Forma mandonguilles.", "Mélangez dinde, œuf et assaisonnements. Formez des boulettes.", "Meng kalkoen, ei en kruiden. Vorm balletjes.", "Pute, Ei und Gewürze mischen. Fleischbällchen formen.", "混合火鸡肉、鸡蛋和 seasoning，搓成肉丸。", "七面鳥、卵、調味料を混ぜ、ミートボールに成形する。", "Mescola tacchino, uovo e condimenti. Forma le polpette.", "Misture peru, ovo e temperos. Forme almôndegas.", "Смешайте индейку, яйцо и специи. Сформируйте фрикадельки."
        )},
        "Brown meatballs in a pan.": {"en": "Brown meatballs in a pan.", **t(
            "Dora las albóndigas en una sartén.", "Daura les mandonguilles en una paella.", "Faites dorer les boulettes dans une poêle.", "Bak balletjes bruin in een pan.", "Fleischbällchen in der Pfanne anbräunen.", "平底锅将肉丸煎至 brown。", "フライパンでミートボールに焼き色を付ける。", "Dora le polpette in padella.", "Doure as almôndegas numa frigideira.", "Обжарьте фрикадельки на сковороде до румяности."
        )},
        "Simmer in tomato sauce until cooked through.": {"en": "Simmer in tomato sauce until cooked through.", **t(
            "Cocina a fuego lento en salsa de tomate hasta que estén hechas.", "Cou a foc lent en salsa de tomàquet fins que estiguin fetes.", "Laissez mijoter dans la sauce tomate jusqu'à cuisson complète.", "Laat sudderen in tomatensaus tot gaar.", "In Tomatensauce köcheln, bis durchgegart.", "在番茄酱中小火炖至全熟。", "トマトソースで弱火煮込み、中まで火を通す。", "Cuoci a fuoco lento nella salsa di pomodoro fino a cottura.", "Coza em lume brando em molho de tomate até cozinhar por completo.", "Тушите в томатном соусе до готовности."
        )},
        "Whisk egg whites with herbs.": {"en": "Whisk egg whites with herbs.", **t(
            "Bate claras con hierbas.", "Bate clares amb herbes.", "Battez les blancs d'œufs avec les herbes.", "Klop eiwit met kruiden.", "Eiweiß mit Kräutern verquirlen.", "将蛋白与香草搅打。", "卵白とハーブを混ぜる。", "Sbatti gli albumi con le erbe.", "Bata claras com ervas.", "Взбейте белки с травами."
        )},
        "Cook in a nonstick pan over medium heat.": {"en": "Cook in a nonstick pan over medium heat.", **t(
            "Cocina en sartén antiadherente a fuego medio.", "Cou en paella antiadherent a foc mitjà.", "Cuisez dans une poêle antiadhésive à feu moyen.", "Bak in anti-aanbakpan op middelhoog vuur.", "In beschichteter Pfanne bei mittlerer Hitze garen.", "用不粘锅中火加热。", "フライパンで中火で調理する。", "Cuoci in padella antiaderente a fuoco medio.", "Coza numa frigideira antiaderente em lume médio.", "Готовьте на антипригарной сковороде на среднем огне."
        )},
        "Add spinach, fold, and serve.": {"en": "Add spinach, fold, and serve.", **t(
            "Añade espinacas, dobla y sirve.", "Afegeix espinacs, doblega i serveix.", "Ajoutez épinards, pliez et servez.", "Voeg spinazie toe, vouw dicht en serveer.", "Spinat hinzufügen, falten und servieren.", "加入菠菜，折叠，上桌。", "ほうれん草を加え、折りたたんで盛る。", "Aggiungi spinaci, piega e servi.", "Adicione espinafres, dobre e sirva.", "Добавьте шпинат, сложите и подавайте."
        )},
        "Cook chicken and hard-boil eggs.": {"en": "Cook chicken and hard-boil eggs.", **t(
            "Cocina el pollo y cuece huevos duros.", "Cou el pollastre i cou ous durs.", "Cuisez le poulet et faites des œufs durs.", "Kook kip en hardgekookte eieren.", "Hähnchen garen und Eier hart kochen.", "煮 chicken，鸡蛋 hard-boil。", "鶏肉を調理し、卵をゆで卵にする。", "Cuoci il pollo e fai uova sode.", "Coza o frango e coza ovos escalfados.", "Приготовьте курицу и сварите яйца вкрутую."
        )},
        "Chop avocado and arrange greens.": {"en": "Chop avocado and arrange greens.", **t(
            "Pica aguacate y coloca las lechugas.", "Pica alvocat i col·loca les enciams.", "Coupez l'avocat et disposez la salade.", "Snijd avocado en schik de sla.", "Avocado schneiden und Salat anrichten.", "切 avocado，摆沙拉菜。", "アボカドを切り、グリーンを並べる。", "Taglia l'avocado e disponi le verdure.", "Corte abacate e disponha as folhas.", "Нарежьте авокадо и выложите зелень."
        )},
        "Top with chicken, egg, and dressing.": {"en": "Top with chicken, egg, and dressing.", **t(
            "Corona con pollo, huevo y aliño.", "Corona amb pollastre, ou i vinagreta.", "Garnissez de poulet, œuf et vinaigrette.", "Garneer met kip, ei en dressing.", "Mit Hähnchen, Ei und Dressing garnieren.", "顶部放 chicken、鸡蛋和 dressing。", "チキン、卵、ドレッシングをのせる。", "Guarnisci con pollo, uovo e dressing.", "Cubra com frango, ovo e molho.", "Сверху добавьте курицу, яйцо и заправку."
        )},
        "Spiralize zucchini into noodles.": {"en": "Spiralize zucchini into noodles.", **t(
            "Espiraliza calabacín en fideos.", "Espiralitza carbassó en noodles.", "Spiralisez la courgette en nouilles.", "Spiraliseer courgette tot noedels.", "Zucchini spiral schneiden.", "将西葫芦 spiral 成面。", "ズッキーニを麺状にスパイラルカットする。", "Spiralizza la zucchina in noodles.", "Espiralize a curgete em noodles.", "Нарежьте цуккини спиралью в виде лапши."
        )},
        "Simmer garlic and tomatoes into sauce.": {"en": "Simmer garlic and tomatoes into sauce.", **t(
            "Cocina ajo y tomates hasta formar salsa.", "Cou all i tomàquets fins formar salsa.", "Laissez mijoter ail et tomates en sauce.", "Laat knoflook en tomaten sudderen tot saus.", "Knoblauch und Tomaten zu Sauce köcheln.", "将 garlic 和番茄炖成 sauce。", "にんにくとトマトを煮込んでソースにする。", "Cuoci aglio e pomodori fino a salsa.", "Coza alho e tomates até formar molho.", "Тушите чеснок и помидоры до соуса."
        )},
        "Toss zucchini noodles with warm sauce.": {"en": "Toss zucchini noodles with warm sauce.", **t(
            "Mezcla fideos de calabacín con salsa caliente.", "Barreja noodles de carbassó amb salsa calenta.", "Mélangez courgetti avec sauce chaude.", "Meng courgettenoedels met warme saus.", "Zucchini-Nudeln mit warmer Sauce vermengen.", "将西葫芦面与 warm sauce 拌匀。", "ズッキーニヌードルに温かいソースを絡める。", "Condisci gli spaghetti di zucchine con salsa calda.", "Envolva noodles de curgete com molho quente.", "Смешайте цуккини-лапшу с тёплым соусом."
        )},
        "Marinate chicken with lemon and herbs.": {"en": "Marinate chicken with lemon and herbs.", **t(
            "Marina el pollo con limón y hierbas.", "Marina el pollastre amb llimona i herbes.", "Marinez le poulet au citron et aux herbes.", "Marineer kip met citroen en kruiden.", "Hähnchen mit Zitrone und Kräutern marinieren.", "用 lemon 和香草腌制 chicken。", "鶏肉をレモンとハーブでマリネする。", "Marina il pollo con limone ed erbe.", "Marine o frango com limão e ervas.", "Замаринуйте курицу с лимоном и травами."
        )},
        "Grill or pan-sear until cooked through.": {"en": "Grill or pan-sear until cooked through.", **t(
            "Asa a la plancha o dora en sartén hasta cocer por completo.", "Grilla o daura a la paella fins coure per complet.", "Grillez ou poêlez jusqu'à cuisson complète.", "Grill of bak in pan tot gaar.", "Grillen oder in der Pfanne braten bis durch.", "烤或煎至全熟。", "グリルまたはフライパンで中まで火を通す。", "Griglia o rosola in padella fino a cottura completa.", "Grelhe ou salteie até cozinhar por completo.", "Запеките на гриле или обжарьте до готовности."
        )},
        "Rest briefly and slice.": {"en": "Rest briefly and slice.", **t(
            "Reposa un momento y corta.", "Reposa un moment i talla.", "Laissez reposer brièvement et tranchez.", "Laat kort rusten en snijd.", "Kurz ruhen lassen und schneiden.", "稍 resting 后切片。", "少し休ませてから切る。", "Lascia riposare brevemente e affetta.", "Deixe repousar brevemente e corte.", "Дайте немного отдохнуть и нарежьте."
        )},
        "Cut steak into bite-size cubes.": {"en": "Cut steak into bite-size cubes.", **t(
            "Corta el bistec en cubos pequeños.", "Talla el bistec en trossos petits.", "Coupez le steak en cubes bouchée.", "Snijd steak in hapklare blokjes.", "Steak in mundgerechte Würfel schneiden.", "将牛排切成 bite-size 方块。", "ステーキを一口大に切る。", "Taglia la bistecca a cubetti.", "Corte o bife em cubos pequenos.", "Нарежьте стейк кубиками."
        )},
        "Sear in a hot pan.": {"en": "Sear in a hot pan.", **t(
            "Dora en sartén caliente.", "Daura en paella calenta.", "Saisissez dans une poêle chaude.", "Bak bruin in hete pan.", "In heißer Pfanne anbraten.", "在 hot pan 中 sear。", "熱いフライパンで焼き色を付ける。", "Rosola in padella calda.", "Salteie numa frigideira quente.", "Обжарьте на раскалённой сковороде."
        )},
        "Add garlic butter and toss to coat.": {"en": "Add garlic butter and toss to coat.", **t(
            "Añade mantequilla de ajo y mezcla para cubrir.", "Afegeix mantega d'all i barreja per cobrir.", "Ajoutez beurre à l'ail et enrobez.", "Voeg knoflookboter toe en schep om.", "Knoblauchbutter hinzufügen und schwenken.", "加入蒜香黄油，拌匀裹匀。", "ガーリックバターを加え、全体に絡める。", "Aggiungi burro all'aglio e mescola.", "Adicione manteiga de alho e envolva.", "Добавьте чесночное масло и перемешайте."
        )},
        "Pat shrimp dry and season.": {"en": "Pat shrimp dry and season.", **t(
            "Seca los camarones y sazona.", "Asseca les gambes i condimenta.", "Séchez les crevettes et assaisonnez.", "Dep garnalen droog en breng op smaak.", "Garnelen trocken tupfen und würzen.", "擦干虾并 seasoning。", "エビの水気を取り、味付けする。", "Asciuga i gamberetti e condisci.", "Seque o camarão e tempere.", "Обсушите креветки и приправьте."
        )},
        "Sauté garlic in butter.": {"en": "Sauté garlic in butter.", **t(
            "Saltea ajo en mantequilla.", "Salteja all en mantega.", "Faites revenir l'ail dans le beurre.", "Fruit knoflook in boter.", "Knoblauch in Butter anbraten.", "用黄油炒 garlic。", "バターでにんにくを炒める。", "Fai soffriggere l'aglio nel burro.", "Refogue alho na manteiga.", "Обжарьте чеснок на масле."
        )},
        "Cook shrimp until pink. Finish with lemon.": {"en": "Cook shrimp until pink. Finish with lemon.", **t(
            "Cocina camarones hasta que estén rosados. Termina con limón.", "Cou gambes fins que estiguin rosades. Acaba amb llimona.", "Cuisez les crevettes jusqu'à rosées. Finissez au citron.", "Kook garnalen tot roze. Afwerken met citroen.", "Garnelen rosa garen. Mit Zitrone abschmecken.", "将虾煮至 pink，最后加 lemon。", "エビがピンクになるまで加熱し、レモンを添える。", "Cuoci i gamberetti fino a rosati. Completa con limone.", "Coza camarão até ficar cor-de-rosa. Finalize com limão.", "Готовьте креветки до розового цвета. Завершите лимоном."
        )},
        "Whisk eggs with spinach and cheese.": {"en": "Whisk eggs with spinach and cheese.", **t(
            "Bate huevos con espinacas y queso.", "Bate ous amb espinacs i formatge.", "Battez œufs, épinards et fromage.", "Klop eieren met spinazie en kaas.", "Eier mit Spinat und Käse verquirlen.", "将鸡蛋与 spinach 和 cheese 搅打。", "卵にほうれん草とチーズを混ぜる。", "Sbatti uova con spinaci e formaggio.", "Bata ovos com espinafres e queijo.", "Взбейте яйца со шпинатом и сыром."
        )},
        "Divide into a greased muffin tin.": {"en": "Divide into a greased muffin tin.", **t(
            "Divide en molde de muffins engrasado.", "Divideix en motlle de muffins untat.", "Répartissez dans un moule à muffins graissé.", "Verdeel over ingevette muffinvorm.", "In gefettete Muffinform füllen.", "分入 greased muffin tin。", "油を塗ったマフィン型に分ける。", "Distribuisci in stampo muffin unto.", "Divida numa forma de muffins untada.", "Разложите по смазанной форме для маффинов."
        )},
        "Bake until set.": {"en": "Bake until set.", **t(
            "Hornea hasta que cuajen.", "Forneja fins que quedin cuajats.", "Enfournez jusqu'à prise.", "Bak tot gestold.", "Backen, bis fest.", "烤至 set。", "固まるまで焼く。", "Inforna fino a cottura.", "Asse até firmar.", "Запекайте до застывания."
        )},
        "Drain tuna and flake into a bowl.": {"en": "Drain tuna and flake into a bowl.", **t(
            "Escurre atún y desmenuza en un bol.", "Escorre tonyina i esmicola en un bol.", "Égouttez le thon et émiettez dans un bol.", "Laat tonijn uitlekken en verkruimel in kom.", "Thunfisch abtropfen und in Schüssel zerpflücken.", "沥干 tuna，弄碎入 bowl。", "ツナの水気を切り、ボウルでほぐす。", "Scola il tonno e sbricalo in una ciotola.", "Escorra o atum e desfaça numa taça.", "Слейте жидкость с тунца и разберите в миске."
        )},
        "Chop cucumber and greens.": {"en": "Chop cucumber and greens.", **t(
            "Pica pepino y lechugas.", "Pica cogombre i enciams.", "Hachez concombre et salade.", "Hak komkommer en sla.", "Gurke und Salat hacken.", "切 cucumber 和 greens。", "キュウリとグリーンを切る。", "Trita cetriolo e verdure.", "Pique pepino e folhas.", "Нарежьте огурец и зелень."
        )},
        "Assemble bowls and serve.": {"en": "Assemble bowls and serve.", **t(
            "Monta los bowls y sirve.", "Munta els bols i serveix.", "Assemblez les bols et servez.", "Stel bowls samen en serveer.", "Bowls anrichten und servieren.", "组装 bowls 并上桌。", "ボウルを組み立てて提供する。", "Componi i bowl e servi.", "Monte as taças e sirva.", "Соберите боулы и подавайте."
        )},
        "Trim and chop vegetables.": {"en": "Trim and chop vegetables.", **t(
            "Limpia y pica las verduras.", "Neteja i pica les verdures.", "Équeutez et hachez les légumes.", "Snij groenten schoon en hak.", "Gemüse putzen und schneiden.", "处理并切 vegetables。", "野菜を下処理して切る。", "Pulisci e taglia le verdure.", "Limpe e corte os legumes.", "Подготовьте и нарежьте овощи."
        )},
        "Steam until tender-crisp.": {"en": "Steam until tender-crisp.", **t(
            "Cuece al vapor hasta tierno pero crujiente.", "Cou al vapor fins tendre però cruixent.", "Cuisez à la vapeur jusqu'à tendreté croquante.", "Stoom tot gaar maar knapperig.", "Dämpfen bis zart-knackig.", "蒸至 tender-crisp。", "歯ごたえのあるやわらかさまで蒸す。", "Cuoci a vapore fino a morbido ma croccante.", "Coza a vapor até tenro mas crocante.", "Готовьте на пару до мягкости с хрустом."
        )},
        "Season and serve warm.": {"en": "Season and serve warm.", **t(
            "Sazona y sirve caliente.", "Condimenta i serveix calent.", "Assaisonnez et servez chaud.", "Breng op smaak en serveer warm.", "Würzen und warm servieren.", "调味，热食上桌。", "味付けして温かく盛る。", "Condisci e servi caldo.", "Tempere e sirva quente.", "Приправьте и подавайте тёплым."
        )},
        "Blend berries and banana until thick.": {"en": "Blend berries and banana until thick.", **t(
            "Tritura frutos rojos y plátano hasta espesar.", "Tritura fruits del bosc i plàtan fins espessir.", "Mixez baies et banane jusqu'à épaississement.", "Mix bessen en banaan tot dik.", "Beeren und Banane pürieren bis dick.", "将 berries 和 banana 打至 thick。", "ベリーとバナナをとろみが付くまで混ぜる。", "Frulla frutti di bosco e banana fino a denso.", "Triture frutos vermelhos e banana até engrossar.", "Взбейте ягоды и банан до густоты."
        )},
        "Pour into a bowl.": {"en": "Pour into a bowl.", **t(
            "Vierte en un bol.", "Aboca en un bol.", "Versez dans un bol.", "Giet in een kom.", "In eine Schüssel gießen.", "倒入 bowl。", "ボウルに注ぐ。", "Versa in una ciotola.", "Despeje numa taça.", "Переложите в миску."
        )},
        "Top with granola and serve.": {"en": "Top with granola and serve.", **t(
            "Corona con granola y sirve.", "Corona amb granola i serveix.", "Garnissez de granola et servez.", "Garneer met granola en serveer.", "Mit Granola garnieren und servieren.", "顶部撒 granola 并上桌。", "グラノーラをのせて提供する。", "Guarnisci con granola e servi.", "Cubra com granola e sirva.", "Посыпьте гранолой и подавайте."
        )},
        "Season cod with herbs and lemon.": {"en": "Season cod with herbs and lemon.", **t(
            "Sazona bacalao con hierbas y limón.", "Condimenta bacallà amb herbes i llimona.", "Assaisonnez cabillaud d'herbes et citron.", "Kruid kabeljauw met kruiden en citroen.", "Kabeljau mit Kräutern und Zitrone würzen.", "用 herbs 和 lemon 给 cod seasoning。", "タラにハーブとレモンで味付けする。", "Condisci il merluzzo con erbe e limone.", "Tempere bacalhau com ervas e limão.", "Приправьте треску травами и лимоном."
        )},
        "Bake until flaky.": {"en": "Bake until flaky.", **t(
            "Hornea hasta que se desmenuce.", "Forneja fins que s'esmicoli.", "Enfournez jusqu'à texture floconneuse.", "Bak tot bladerig.", "Backen, bis blättrig.", "烤至 flaky。", "ほろほろになるまで焼く。", "Inforna fino a sfaldarsi.", "Asse até escamose.", "Запекайте до рассыпчатости."
        )},
        "Serve immediately.": {"en": "Serve immediately.", **t(
            "Sirve al momento.", "Serveix immediatament.", "Servez aussitôt.", "Serveer meteen.", "Sofort servieren.", "立即上桌。", "すぐに提供する。", "Servi subito.", "Sirva de imediato.", "Подавайте сразу."
        )},
        "Warm beans with cumin.": {"en": "Warm beans with cumin.", **t(
            "Calienta frijoles con comino.", "Escalfa mongetes amb comí.", "Réchauffez haricots avec cumin.", "Warm bonen met komijn.", "Bohnen mit Kreuzkümmel erwärmen.", "用 cumin 加热 beans。", "豆をクミンで温める。", "Scalda i fagioli con cumino.", "Aqueça feijão com cominho.", "Подогрейте фасоль с зирой."
        )},
        "Combine and serve.": {"en": "Combine and serve.", **t(
            "Mezcla y sirve.", "Barreja i serveix.", "Mélangez et servez.", "Meng en serveer.", "Vermengen und servieren.", "混合后上桌。", "混ぜて盛る。", "Mescola e servi.", "Misture e sirva.", "Смешайте и подавайте."
        )},
        "Slice cucumber thinly.": {"en": "Slice cucumber thinly.", **t(
            "Corta pepino en rodajas finas.", "Talla cogombre a rodanxes fines.", "Tranchez le concombre finement.", "Snijd komkommer dun.", "Gurke dünn schneiden.", "将 cucumber 切薄片。", "キュウリを薄切りにする。", "Affetta sottilmente il cetriolo.", "Corte pepino em fatias finas.", "Нарежьте огурец тонкими л slices."
        )},
        "Toss with vinegar and dill.": {"en": "Toss with vinegar and dill.", **t(
            "Mezcla con vinagre y eneldo.", "Barreja amb vinagre i anet.", "Mélangez avec vinaigre et aneth.", "Meng met azijn en dille.", "Mit Essig und Dill vermengen.", "与 vinegar 和 dill 拌匀。", "酢とディルで和える。", "Condisci con aceto e aneto.", "Envolva com vinagre e endro.", "Смешайте с уксусом и укропом."
        )},
        "Chill briefly before serving.": {"en": "Chill briefly before serving.", **t(
            "Enfría un poco antes de servir.", "Refrigera una estona abans de servir.", "Réfrigérez brièvement avant de servir.", "Koel kort voor het serveren.", "Kurz kühlen vor dem Servieren.", "上桌前 brief chill。", "提供前に少し冷やす。", "Raffredda brevemente prima di servire.", "Arrefieça brevemente antes de servir.", "Немного охладите перед подачей."
        )},
        "Top flatbread with tomato and mozzarella.": {"en": "Top flatbread with tomato and mozzarella.", **t(
            "Cubre el pan plano con tomate y mozzarella.", "Cobre el pa pla amb tomàquet i mozzarella.", "Garnissez le flatbread de tomate et mozzarella.", "Beleg flatbread met tomaat en mozzarella.", "Fladenbrot mit Tomate und Mozzarella belegen.", "flatbread 上放 tomato 和 mozzarella。", "フラットブレッドにトマトとモッツァレラをのせる。", "Copri il flatbread con pomodoro e mozzarella.", "Cubra o pão achatado com tomate e mozzarella.", "Выложите на лavash помидор и моцареллу."
        )},
        "Bake or pan-toast until cheese melts.": {"en": "Bake or pan-toast until cheese melts.", **t(
            "Hornea o tuesta en sartén hasta derretir el queso.", "Forneja o torra a la paella fins fondre el formatge.", "Enfournez ou poêlez jusqu'à fonte du fromage.", "Bak of bak in pan tot kaas smelt.", "Backen oder in Pfanne toasten, bis Käse schmilzt.", "烤或 pan-toast 至 cheese 融化。", "チーズがとけるまで焼くかフライパンで焼く。", "Inforna o tosta in padella fino a fusione del formaggio.", "Asse ou toste na frigideira até derreter o queijo.", "Запеките или поджарьте, пока сыр не расплавится."
        )},
        "Finish with fresh basil.": {"en": "Finish with fresh basil.", **t(
            "Termina con albahaca fresca.", "Acaba amb alfàbrega fresca.", "Finissez au basilic frais.", "Werk af met verse basilicum.", "Mit frischem Basilikum abschließen.", "最后加 fresh basil。", "生バジルを仕上げに添える。", "Completa con basilico fresco.", "Finalize com manjericão fresco.", "Завершите свежим базиликом."
        )},
        "Boil pasta until al dente.": {"en": "Boil pasta until al dente.", **t(
            "Hierve pasta hasta al dente.", "Bull pasta fins al dente.", "Cuisez les pâtes al dente.", "Kook pasta al dente.", "Pasta al dente kochen.", "将 pasta 煮至 al dente。", "パスタをアルデンテに茹でる。", "Cuoci la pasta al dente.", "Coza a massa al dente.", "Отварите пasta al dente."
        )},
        "Reserve a little pasta water.": {"en": "Reserve a little pasta water.", **t(
            "Reserva un poco de agua de la pasta.", "Reserva una mica d'aigua de la pasta.", "Réservez un peu d'eau de cuisson.", "Bewaar wat pastawater.", "Etwas Nudelwasser aufheben.", "留一点 pasta water。", "パスタの茹で汁を少し取っておく。", "Metti da parte un po' di acqua di cottura.", "Reserve um pouco da água da massa.", "Отложите немного воды от пasta."
        )},
        "Toss pasta with pesto and parmesan.": {"en": "Toss pasta with pesto and parmesan.", **t(
            "Mezcla pasta con pesto y parmesano.", "Barreja pasta amb pesto i parmesà.", "Mélangez pâtes, pesto et parmesan.", "Meng pasta met pesto en parmezaan.", "Pasta mit Pesto und Parmesan vermengen.", "将 pasta 与 pesto 和 parmesan 拌匀。", "パスタにペstoとパルメザンを和える。", "Condisci la pasta con pesto e parmigiano.", "Envolva a massa com pesto e parmesão.", "Смешайте пasta с pesto и пармезаном."
        )},
        "Cook rice and warm beans.": {"en": "Cook rice and warm beans.", **t(
            "Cocina arroz y calienta frijoles.", "Cou arròs i escalfa mongetes.", "Cuisez le riz et réchauffez les haricots.", "Kook rijst en warm bonen.", "Reis kochen und Bohnen erwärmen.", "煮 rice，加热 beans。", "ライスを炊き、豆を温める。", "Cuoci il riso e scalda i fagioli.", "Coza arroz e aqueça feijão.", "Приготовьте рис и подогрейте фасоль."
        )},
        "Season and cook chicken.": {"en": "Season and cook chicken.", **t(
            "Sazona y cocina el pollo.", "Condimenta i cou el pollastre.", "Assaisonnez et cuisez le poulet.", "Breng kip op smaak en kook.", "Hähnchen würzen und garen.", "给 chicken seasoning 并 cooking。", "鶏肉に味付けして調理する。", "Condisci e cuoci il pollo.", "Tempere e cozinhe o frango.", "Приправьте и приготовьте курицу."
        )},
        "Assemble bowls with salsa.": {"en": "Assemble bowls with salsa.", **t(
            "Monta bowls con salsa.", "Munta bols amb salsa.", "Assemblez les bols avec salsa.", "Stel bowls samen met salsa.", "Bowls mit Salsa anrichten.", "用 salsa 组装 bowls。", "サルサでボウルを組み立てる。", "Componi i bowl con salsa.", "Monte taças com salsa.", "Соберите боулы с salsa."
        )},
        "Cook quinoa until fluffy.": {"en": "Cook quinoa until fluffy.", **t(
            "Cocina quinoa hasta esponjosa.", "Cou quinoa fins esponjosa.", "Cuisez le quinoa jusqu'à moelleux.", "Kook quinoa tot luchtig.", "Quinoa locker kochen.", "将 quinoa 煮至 fluffy。", "キノアをふっくら炊く。", "Cuoci la quinoa fino a soffice.", "Coza quinoa até ficar fofa.", "Приготовьте киноа до пышности."
        )},
        "Dice cucumber and rinse chickpeas.": {"en": "Dice cucumber and rinse chickpeas.", **t(
            "Pica pepino y enjuaga garbanzos.", "Talla cogombre i esbandeix cigrons.", "Coupez concombre en dés et rincez pois chiches.", "Snijd komkommer en spoel kikkererwten.", "Gurke würfeln und Kichererbsen abspülen.", "cucumber 切丁，rinse chickpeas。", "キュウリを角切りにし、ひよこ豆を洗う。", "Taglia a cubetti il cetriolo e sciacqua i ceci.", "Corte pepino em cubos e enxágue grão-de-bico.", "Нарежьте огурец и промойте нут."
        )},
        "Toss with lemon dressing.": {"en": "Toss with lemon dressing.", **t(
            "Mezcla con aliño de limón.", "Barreja amb vinagreta de llimona.", "Mélangez avec vinaigrette au citron.", "Meng met citroendressing.", "Mit Zitronendressing vermengen.", "与 lemon dressing 拌匀。", "レモンドレッシングで和える。", "Condisci con dressing al limone.", "Envolva com molho de limão.", "Смешайте с лимонной заправкой."
        )},
        "Layer yogurt and berries in a glass.": {"en": "Layer yogurt and berries in a glass.", **t(
            "Alterna yogur y frutos rojos en un vaso.", "Alterna iogurt i fruits del bosc en un got.", "Alternez yaourt et baies dans un verre.", "Laag yoghurt en bessen in een glas.", "Joghurt und Beeren im Glas schichten.", "在 glass 中 layer yogurt 和 berries。", "グラスにヨーグルトとベリーを重ねる。", "Alterna yogurt e frutti di bosco in un bicchiere.", "Alterne iogurte e frutos vermelhos num copo.", "Выложите слоями йогурт и ягоды в стакан."
        )},
        "Drizzle with honey.": {"en": "Drizzle with honey.", **t(
            "Rociar con miel.", "Ruixa amb mel.", "Arrosez de miel.", "Besprenkel met honing.", "Mit Honig beträufeln.", "淋 honey。", "はちみつをかける。", "Condisci con miele.", "Regue com mel.", "Полейте мёдом."
        )},
        "Blend avocado, melted chocolate, and maple syrup.": {"en": "Blend avocado, melted chocolate, and maple syrup.", **t(
            "Tritura aguacate, chocolate derretido y jarabe de arce.", "Tritura alvocat, xocolata fosca i xarop d'auró.", "Mixez avocat, chocolat fondu et sirop d'érable.", "Mix avocado, gesmolten chocolade en ahornsiroop.", "Avocado, geschmolzene Schokolade und Ahornsirup pürieren.", "blend avocado、melted chocolate 和 maple syrup。", "アボカド、溶かしたチョコ、メープルシロップを混ぜる。", "Frulla avocado, cioccolato fuso e sciroppo d'acero.", "Triture abacate, chocolate derretido e xarope de ácer.", "Измельчите авокадо, растопленный шоколад и кленовый сирок."
        )},
        "Chill until set.": {"en": "Chill until set.", **t(
            "Refrigera hasta que cuaje.", "Refrigera fins que quedi.", "Réfrigérez jusqu'à prise.", "Koel tot gestold.", "Kühlen bis fest.", "冷藏至凝固。", "固まるまで冷やす。", "Raffredda fino a cottura.", "Arrefieça até firmar.", "Охладите до застывания."
        )},
        "Serve chilled.": {"en": "Serve chilled.", **t(
            "Sirve frío.", "Serveix fred.", "Servez bien frais.", "Serveer gekoeld.", "Gekühlt servieren.", "冷食上桌。", "冷やして提供する。", "Servi freddo.", "Sirva frio.", "Подавайте охлаждённым."
        )},
        "Slice apples and toss with cinnamon.": {"en": "Slice apples and toss with cinnamon.", **t(
            "Corta manzanas y mezcla con canela.", "Talla pomes i barreja amb canela.", "Tranchez pommes et mélangez avec cannelle.", "Snijd appels en meng met kaneel.", "Äpfel schneiden und mit Zimt vermengen.", "切 apples，与 cinnamon 拌匀。", "リンゴを切り、シナモンで和える。", "Affetta mele e condisci con cannella.", "Corte maçãs e envolva com canela.", "Нарежьте яблоки и смешайте с корицей."
        )},
        "Mix oat crumble topping.": {"en": "Mix oat crumble topping.", **t(
            "Mezcla la cobertura crujiente de avena.", "Barreja la coberta cruixent de civada.", "Mélangez la garniture crumble d'avoine.", "Meng havermoutcrumble topping.", "Haferflocken-Crumble-Topping mischen.", "混合 oat crumble topping。", "オーツクランブルのトッピングを混ぜる。", "Mescola il topping crumble di avena.", "Misture a cobertura crumble de aveia.", "Смешайте овсяную крошку для topping."
        )},
        "Bake until golden.": {"en": "Bake until golden.", **t(
            "Hornea hasta dorar.", "Forneja fins daurar.", "Enfournez jusqu'à doré.", "Bak tot goudbruin.", "Backen bis goldbraun.", "烤至 golden。", "きつね色になるまで焼く。", "Inforna fino a doratura.", "Asse até dourar.", "Запекайте до золотистого цвета."
        )},
        "Whisk chia seeds, milk, and vanilla.": {"en": "Whisk chia seeds, milk, and vanilla.", **t(
            "Bate semillas de chía, leche y vainilla.", "Bate llavors de xia, llet i vainilla.", "Battez graines de chia, lait et vanille.", "Klop chiazaad, melk en vanille.", "Chiasamen, Milch und Vanille verquirlen.", "搅打 chia seeds、milk 和 vanilla。", "チアシード、牛乳、バニラを混ぜる。", "Sbatti semi di chia, latte e vaniglia.", "Bata sementes de chia, leite e baunilha.", "Взбейте семена чиа, молоко и ваниль."
        )},
        "Refrigerate until thickened.": {"en": "Refrigerate until thickened.", **t(
            "Refrigera hasta espesar.", "Refrigera fins espessar.", "Réfrigérez jusqu'à épaississement.", "Koel tot ingedikt.", "Kühlen bis eingedickt.", "冷藏至 thickened。", "とろみが付くまで冷蔵する。", "Refrigera fino a addensamento.", "Refrigere até engrossar.", "Охладите до загустения."
        )},
        "Top and serve.": {"en": "Top and serve.", **t(
            "Corona y sirve.", "Corona i serveix.", "Garnissez et servez.", "Garneer en serveer.", "Garnieren und servieren.", "top 并上桌。", "トッピングして提供する。", "Guarnisci e servi.", "Cubra e sirva.", "Украсьте и подавайте."
        )},
        "Halve peaches and sprinkle with cinnamon.": {"en": "Halve peaches and sprinkle with cinnamon.", **t(
            "Parte melocotones por la mitad y espolvorea canela.", "Parteix préssecs per la meitat i espolsa canela.", "Coupez pêches en deux et saupoudrez de cannelle.", "Halveer perziken en bestrooi met kaneel.", "Pfirsiche halbieren und mit Zimt bestreuen.", "peaches 对半切，撒 cinnamon。", "桃を半分に切り、シナモンを振る。", "Taglia le pesche a metà e cospargi di cannella.", "Corte pêssegos ao meio e polvilhe canela.", "Разрежьте персики пополам и посыпьте корицей."
        )},
        "Top with oats.": {"en": "Top with oats.", **t(
            "Corona con avena.", "Corona amb civada.", "Garnissez de flocons d'avoine.", "Garneer met havermout.", "Mit Haferflocken bestreuen.", "顶部撒燕麦片。", "オーツをのせる。", "Guarnisci con fiocchi d'avena.", "Cubra com aveia.", "Посыпьте овсянкой сверху."
        )},
        "Bake until tender.": {"en": "Bake until tender.", **t(
            "Hornea hasta tierno.", "Forneja fins tendre.", "Enfournez jusqu'à tendreté.", "Bak tot gaar.", "Backen bis zart.", "烤至软嫩。", "やわらかくなるまで焼く。", "Inforna fino a cottura morbida.", "Asse até ficar tenro.", "Запекайте до мягкости."
        )},
        "Mix coconut, almond flour, and eggs.": {"en": "Mix coconut, almond flour, and eggs.", **t(
            "Mezcla coco, harina de almendras y huevos.", "Barreja coco, farina d'ametlla i ous.", "Mélangez coco, farine d'amande et œufs.", "Meng kokos, amandelmeel en eieren.", "Kokos, Mandelmehl und Eier mischen.", "混合椰丝、杏仁粉和鸡蛋。", "ココナッツ、アーモンド粉、卵を混ぜる。", "Mescola cocco, farina di mandorle e uova.", "Misture coco, farinha de amêndoa e ovos.", "Смешайте кокос, миндальную муку и яйца."
        )},
        "Shape into cookies.": {"en": "Shape into cookies.", **t(
            "Forma galletas.", "Forma galetes.", "Formez des biscuits.", "Vorm koekjes.", "Zu Keksen formen.", "整形成曲奇。", "クッキーの形に成形する。", "Dai forma ai biscotti.", "Modele bolachas.", "Сформируйте печенье."
        )},
    }

