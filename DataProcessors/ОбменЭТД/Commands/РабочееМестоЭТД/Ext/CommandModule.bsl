﻿#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ОткрытьФорму("Обработка.ОбменЭТД.Форма.РабочееМестоЭТД"
		, 
		, ПараметрыВыполненияКоманды.Источник
		, ПараметрыВыполненияКоманды.Уникальность
		, ПараметрыВыполненияКоманды.Окно
		, ПараметрыВыполненияКоманды.НавигационнаяСсылка);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#КонецОбласти