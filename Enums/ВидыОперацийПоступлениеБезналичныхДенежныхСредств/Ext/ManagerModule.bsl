﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

Процедура ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	СписокИсключений = Новый Массив;
	
	Если НЕ ПолучитьФункциональнуюОпцию("ВедетсяУчетЗарплатыИКадры") Тогда
		СписокИсключений.Добавить(Перечисления.ВидыОперацийПоступлениеБезналичныхДенежныхСредств.ВозвратЗаработнойПлаты);
		СписокИсключений.Добавить(Перечисления.ВидыОперацийПоступлениеБезналичныхДенежныхСредств.ВозвратПенсионныхВзносов);
		СписокИсключений.Добавить(Перечисления.ВидыОперацийПоступлениеБезналичныхДенежныхСредств.ВозвратСоциальныхОтчислений);
	КонецЕсли;
	
	Если НЕ ПолучитьФункциональнуюОпцию("ИспользоватьВалютныйУчет") Тогда
		СписокИсключений.Добавить(Перечисления.ВидыОперацийПоступлениеБезналичныхДенежныхСредств.ПоступленияОтПродажиИностраннойВалюты);
		СписокИсключений.Добавить(Перечисления.ВидыОперацийПоступлениеБезналичныхДенежныхСредств.ПриобретениеИностраннойВалюты);
	КонецЕсли;
	
	Если НЕ ПолучитьФункциональнуюОпцию("ПоддержкаРаботыСоСтруктурнымиПодразделениями") Тогда
		СписокИсключений.Добавить(Перечисления.ВидыОперацийПоступлениеБезналичныхДенежныхСредств.ОплатаСтруктурногоПодразделения);
	КонецЕсли;

	ДанныеВыбора = Новый СписокЗначений;
	
	Для Каждого ЗначениеПеречисления Из Метаданные.Перечисления.ВидыОперацийПоступлениеБезналичныхДенежныхСредств.ЗначенияПеречисления Цикл
		
		Если ТипЗнч(Параметры.СтрокаПоиска) = Тип("Строка")
			И НЕ ПустаяСтрока(Параметры.СтрокаПоиска)
			И СтрНайти(НРег(ЗначениеПеречисления.Синоним), НРег(Параметры.СтрокаПоиска)) <> 1 Тогда
			
			Продолжить;
			
		КонецЕсли;
		
		Ссылка = Перечисления.ВидыОперацийПоступлениеБезналичныхДенежныхСредств[ЗначениеПеречисления.Имя];
		
		Если Параметры.Свойство("Отбор") И Параметры.Отбор.Свойство("Ссылка")
			И ТипЗнч(Параметры.Отбор.Ссылка) = Тип("ПеречислениеСсылка.ВидыОперацийПоступлениеБезналичныхДенежныхСредств")
			И Параметры.Отбор.Ссылка <> Ссылка Тогда
			
			Продолжить;
			
		ИначеЕсли Параметры.Свойство("Отбор") И Параметры.Отбор.Свойство("Ссылка")
			И ТипЗнч(Параметры.Отбор.Ссылка) = Тип("ФиксированныйМассив")
			И Параметры.Отбор.Ссылка.Найти(Ссылка) = Неопределено Тогда
			
			Продолжить;
			
		КонецЕсли;
		
		Если СписокИсключений.Найти(Ссылка) <> Неопределено Тогда
			
			Продолжить;
			
		КонецЕсли;
		
		ДанныеВыбора.Добавить(Ссылка, ЗначениеПеречисления.Синоним);
		
	КонецЦикла;
	
КонецПроцедуры

#КонецЕсли