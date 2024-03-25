﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

Функция ПолучитьПараметрыИсполненияОтчета() Экспорт
	
	Возврат Новый Структура("ИспользоватьПередКомпоновкойМакета,
							|ИспользоватьПослеКомпоновкиМакета,
							|ИспользоватьПослеВыводаРезультата,
							|ИспользоватьПередВыводомЭлементаРезультата,
							|ИспользоватьДанныеРасшифровки",
							Истина, Ложь, Истина, Истина, Ложь);
							
КонецФункции

Функция ПолучитьТекстЗаголовка(ПараметрыОтчета, ОрганизацияВНачале = Истина) Экспорт
	
	ЗаголовокОтчета = НСтр("ru = 'Справка-расчет себестоимости продукции и услуг %1'") + " (" + ПараметрыОтчета.НазваниеНабораПоказателейОтчета + ")";
	ЗаголовокОтчета = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		ЗаголовокОтчета, БухгалтерскиеОтчетыКлиентСервер.ПолучитьПредставлениеПериода(
			?(ПараметрыОтчета.СНачалаГода,НачалоГода(ПараметрыОтчета.НачалоПериода),ПараметрыОтчета.НачалоПериода), ПараметрыОтчета.КонецПериода));
	
	Возврат ЗаголовокОтчета;
	
КонецФункции

// В процедуре можно доработать компоновщик перед выводом в отчет
// Изменения сохранены не будут
Процедура ПередКомпоновкойМакета(ПараметрыОтчета, Схема, КомпоновщикНастроек) Экспорт
	
	Если ЗначениеЗаполнено(ПараметрыОтчета.НачалоПериода) Тогда
		БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "НачалоПериода", ?(ПараметрыОтчета.СначалаГода,НачалоГода(ПараметрыОтчета.НачалоПериода),НачалоДня(ПараметрыОтчета.НачалоПериода)));
	КонецЕсли;
	Если ЗначениеЗаполнено(ПараметрыОтчета.КонецПериода) Тогда
		БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "КонецПериода" , КонецДня(ПараметрыОтчета.КонецПериода));
	КонецЕсли;
	БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "ВариантОтчета", ПараметрыОтчета.ВариантОтчета);
	БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "ВидУчетаНУ"   , Справочники.ВидыУчетаНУ.НУ);
	БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "ВидУчетаПР"   , Справочники.ВидыУчетаНУ.ПР);
	БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "ВидУчетаВР"   , Справочники.ВидыУчетаНУ.ВР);
	
	ГруппировкаОрганизация        = НайтиПоИмени(КомпоновщикНастроек.Настройки.Структура, "Организация");
	ГруппировкаОрганизацияРазницы = НайтиПоИмени(КомпоновщикНастроек.Настройки.Структура, "ОрганизацияСРазницами");
	
	Если ПараметрыОтчета.ВариантОтчета = 3 Тогда 
		ГруппировкаОрганизация.Использование        = Ложь;
		ГруппировкаОрганизацияРазницы.Использование = Истина;
	Иначе
		ГруппировкаОрганизация.Использование        = Истина;
		ГруппировкаОрганизацияРазницы.Использование = Ложь;
	КонецЕсли;
	
	БухгалтерскиеОтчеты.ДобавитьОтборПоОрганизациямИПодразделениям(КомпоновщикНастроек, ПараметрыОтчета);
	
	ПараметрыОтчета.Вставить("ПрерватьВывод", Истина);
	
КонецПроцедуры

Процедура ПередВыводомЭлементаРезультата(ПараметрыОтчета, МакетКомпоновки, ДанныеРасшифровки, ЭлементРезультата, Отказ = Ложь) Экспорт
	
	// Макет1 - макет заголовка группировки Организация
	// Макет2 - макет итогов группировки Организация и общих итогов
	// Если Макет2 выводится, а Макет1 еще не выводился, значит нужно прервать вывод пустого макета общих итогов 
	
	Если ЭлементРезультата.Макет = "Макет1" Тогда
		ПараметрыОтчета.ПрерватьВывод = Ложь;
	КонецЕсли;
	
	Если ЭлементРезультата.Макет = "Макет2" И ПараметрыОтчета.ПрерватьВывод Тогда
		Отказ = Истина;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПослеВыводаРезультата(ПараметрыОтчета, Результат) Экспорт
	
	БухгалтерскиеОтчетыВызовСервера.ОбработкаРезультатаОтчета(ПараметрыОтчета.ИдентификаторОтчета, Результат);

КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ


////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

Функция НайтиПоИмени(Структура, Имя)
	Группировка = Неопределено;
	Для каждого Элемент Из Структура Цикл
		Если ТипЗнч(Элемент) = Тип("ТаблицаКомпоновкиДанных") Тогда
			Если Элемент.Имя = Имя Тогда
				Возврат Элемент;
			КонецЕсли;	
		Иначе
			Если Элемент.Имя = Имя Тогда
				Возврат Элемент;
			КонецЕсли;	
			Для каждого Поле Из Элемент.ПоляГруппировки.Элементы Цикл
				Если Не ТипЗнч(Поле) = Тип("АвтоПолеГруппировкиКомпоновкиДанных") Тогда
					Если Поле.Поле = Новый ПолеКомпоновкиДанных(Имя) Тогда
						Возврат Элемент;
					КонецЕсли;
				КонецЕсли;
			КонецЦикла;
			Если Элемент.Структура.Количество() = 0 Тогда
				Продолжить;
			Иначе
				Группировка = НайтиПоИмени(Элемент.Структура, Имя);
				Если Не Группировка = Неопределено Тогда
					Возврат	Группировка;
				КонецЕсли;	
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	Возврат Группировка;
	
КонецФункции



#КонецЕсли