﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	//отзыв уведомления о ввозе из ЕАЭС
	Источник = ПараметрыВыполненияКоманды.Источник;
	
	Если ТипЗнч(Источник) = Тип("ФормаКлиентскогоПриложения") Тогда
			
		Если Источник.ИмяФормы = "Документ.УведомлениеОВвозеИзЕАЭСИСМПТК.Форма.ФормаДокумента" Тогда
			
			ИнтеграцияИСМПТККлиент.ОтозватьИсходящиеДокументыИСМПТ(ПараметрКоманды, Новый Структура("ЗапускатьФоновоеЗадание", Ложь));
			
		Иначе
			
			ИспользоватьФоновуюОтправкуДокументИСМПТ = ИнтеграцияИСМПТККлиентСерверПереопределяемый.ИспользоватьФоновуюОтправкуДокументовИСМПТ();
			
			ДополнительныеПараметры = Новый Структура("ЗапускатьФоновоеЗадание, КлючФормы", ИспользоватьФоновуюОтправкуДокументИСМПТ, Источник.КлючУникальности);
			
			ИнтеграцияИСМПТККлиент.ОтозватьИсходящиеДокументыИСМПТ(ПараметрКоманды, ДополнительныеПараметры);
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры
