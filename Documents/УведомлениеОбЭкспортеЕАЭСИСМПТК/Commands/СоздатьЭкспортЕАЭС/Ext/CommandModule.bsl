﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ДопПараметры = Новый Структура("ТипКоманды", "СоздатьЭкспортЕАЭС");
	
	Если ЗначениеЗаполнено(ПараметрКоманды) Тогда	
		ИнтеграцияИСМПТККлиент.СоздатьЭкспортЕАЭС(ПараметрКоманды, ДопПараметры);
	КонецЕсли;	
	
КонецПроцедуры
