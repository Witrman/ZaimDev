﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	Источник = ПараметрыВыполненияКоманды.Источник;
	
	Если ТипЗнч(Источник) = Тип("ФормаКлиентскогоПриложения") Тогда
			
		Если Источник.ИмяФормы = "Документ.УведомлениеОРасхожденииИСМПТК.Форма.ФормаДокумента" Тогда
			
			ИнтеграцияИСМПТККлиент.ОтправитьИсходящиеДокументыИСМПТ(ПараметрКоманды, Новый Структура("ЗапускатьФоновоеЗадание", Ложь));
			
		Иначе
			
			ИспользоватьФоновуюОтправкуДокументИСМПТ = ИнтеграцияИСМПТККлиентСерверПереопределяемый.ИспользоватьФоновуюОтправкуДокументовИСМПТ();
			
			ДополнительныеПараметры = Новый Структура("ЗапускатьФоновоеЗадание, КлючФормы", ИспользоватьФоновуюОтправкуДокументИСМПТ, Источник.КлючУникальности);
			
			ИнтеграцияИСМПТККлиент.ОтправитьИсходящиеДокументыИСМПТ(ПараметрКоманды, ДополнительныеПараметры);
			
		КонецЕсли;
		
	КонецЕсли;

КонецПроцедуры
