﻿
#Область ОбработчикиСобытий

Процедура ОбработкаПолученияФормы(ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка)
	
	Если Не Параметры.Свойство("ДокументСсылка") Тогда
		Возврат;
	КонецЕсли;
	
	СтандартнаяОбработка = Ложь;
	ВыбраннаяФорма = "Форма";
	
	Если Не Параметры.Свойство("ПодключенноеОборудование") Тогда
		
		//вызов сервера!
		ПодключенноеОборудование = ПодключаемоеОборудованиеОрганизации(Параметры.Организация);
		Параметры.Вставить("ПодключенноеОборудование", ПодключенноеОборудование);
		
		Если ПодключенноеОборудование.ФискальныеУстройства.Количество() = 0 Тогда
			ВыбраннаяФорма = "ОшибкаПодключенияОборудования";
		КонецЕсли;
		
	КонецЕсли;
	
	#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
		
 		Если НЕ ПечатьФискальныхДокументовРКПереопределяемый.СравнитьВалюты(Параметры.ДокументСсылка) Тогда
			ВыбраннаяФорма = "ОшибкаИспользуемойВалюты";
		КонецЕсли; 
				
	#КонецЕсли
	
КонецПроцедуры

Функция ПодключаемоеОборудованиеОрганизации(Организация)
	
	Оборудование = Новый Структура;
	Оборудование.Вставить("Терминал");
	Оборудование.Вставить("ФискальныеУстройства");
	
	ПоддерживаемыеТипыВО = Новый Массив();
	ПоддерживаемыеТипыВО.Добавить("ФискальныйРегистратор");
	ПоддерживаемыеТипыВО.Добавить("ПринтерЧеков");			
			
	СписокДоступныхУстройств = МенеджерОборудованияВызовСервера.ОборудованиеПоПараметрам(ПоддерживаемыеТипыВО);
	СписокУстройств = Новый Массив();
	Для Каждого Устройства Из СписокДоступныхУстройств Цикл
		СписокУстройств.Добавить(Устройства.Ссылка);
	КонецЦикла;
	Оборудование.ФискальныеУстройства = СписокУстройств;
		
	Возврат Оборудование;
	
КонецФункции

#КонецОбласти