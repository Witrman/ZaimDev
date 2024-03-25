﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	Обновить = АВРКлиентСервер.ПроверитьВозможностьОбновления(ПараметрКоманды);
	Если Обновить Тогда
		
		Источник = ПараметрыВыполненияКоманды.Источник;
		
		
		Если ТипЗнч(Источник) = ЭСФКлиентПереопределяемый.ПолучитьТипФормаКлиентскогоПриложения() Тогда
			
			Если Источник.ИмяФормы = "Документ.ЭлектронныйАктВыполненныхРабот.Форма.ФормаДокумента" Тогда
				
				АВРКлиент.ОбновитьДокументыАВРИзИСЭСФ(ПараметрКоманды, Новый Структура("ЗапускатьФоновоеЗадание", Ложь));
				
			Иначе
				
				ИспользоватьФоновуюОтправкуАВР = АВРКлиентСервер.ИспользоватьФоновуюОтправкуАВР();
				
				ДополнительныеПараметры = Новый Структура("ЗапускатьФоновоеЗадание, КлючФормы", ИспользоватьФоновуюОтправкуАВР, Источник.КлючУникальности);
				
				АВРКлиент.ОбновитьДокументыАВРИзИСЭСФ(ПараметрКоманды, ДополнительныеПараметры);
				
			КонецЕсли;
			
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры
