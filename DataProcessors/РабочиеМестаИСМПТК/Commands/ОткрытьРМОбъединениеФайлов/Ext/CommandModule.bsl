﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	Если ЕстьПравоДоступаКНастройкам() Тогда
		ОткрытьФорму("Обработка.РабочиеМестаИСМПТК.Форма.РабочееМестоФормаОбъединениеФайлов");	
	Иначе
		ТекстСообщения = НСтр("ru='Недостаточно прав для открытия формы обработки! Обратитесь к администратору системы.'");
		ИнтеграцияИСМПТККлиентСерверПереопределяемый.СообщитьПользователю(ТекстСообщения);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ЕстьПравоДоступаКНастройкам()
	
	Возврат ПравоДоступа("Просмотр", Метаданные.Обработки.ОбменИСМПТК);
	
КонецФункции
