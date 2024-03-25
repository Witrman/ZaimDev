﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Выполняет поиск единицы измерения в справочнике "КлассификаторЕдиницИзмерения"
// если элемент в справочнике не найден, осуществляется попыка добавления элемента из ОКЕИ,
// если в ОКЕИ элемент не найден, то он создается с переданным кодом и наименованием
// Если Наиенование не задано то добавление элемента в справочник произведено не будет!
//
// Параметры:
// - КодПоОКЕИ - Строка(3), код единицы измерения по ОКЕИ (Обязательный)
// - Наименование - Строка, Наименование единицы измерения (Необязательный)
// - НаименованиеПолное - Строка, Полное наименование единицы измерения (Необязательный)
//
// Возвращаемое значение:
// Неопределено - если поиск и попытка добавления элемента не дали результатов
// СправочникСсылка.КлассификаторЕдиницИзмерения - если поиск или добавление успешны
// 
Функция ЕдиницаИзмеренияПоКоду(КодПоОКЕИ, Наименование = "", НаименованиеПолное = "") Экспорт

	// Если кодПоОКЕИ не заполнен то воврат
	Если НЕ ЗначениеЗаполнено(КодПоОКЕИ) Тогда
		
		Возврат Неопределено;
		
	Иначе
		
		// Сначала попытаемся найти единицу среди уже существующих в справочнике
		ЕдиницаИзмерения = Справочники.КлассификаторЕдиницИзмерения.НайтиПоКоду(КодПоОКЕИ);
		
		Если ЕдиницаИзмерения <> Справочники.КлассификаторЕдиницИзмерения.ПустаяСсылка() Тогда 
			
			// Если нашли возвращаем ссылку
			Возврат ЕдиницаИзмерения;
			
		Иначе	
			
			// Если единицы нет в справочнике, поищем ее в классификаторе
			// Классификатор хранится в макете "КлассификаторЕдиницИзмерения"
			// Загружаем макет
			Макет = Справочники.КлассификаторЕдиницИзмерения.ПолучитьМакет("ПФ_MXL_КлассификаторЕдиницИзмерения");
			
			// Запомним параметры макета которые будем использовать дальше
			ОбластьКодЧисловойЛево          = Макет.Области.КодЧисловой.Лево;
			ОбластьКодЧисловойПраво         = Макет.Области.КодЧисловой.Право;
			ОбластьНаименованиеКраткоеЛево  = Макет.Области.НаименованиеКраткое.Лево;
			ОбластьНаименованиеКраткоеПраво = Макет.Области.НаименованиеКраткое.Право;
			ОбластьНаименованиеПолноеЛево   = Макет.Области.НаименованиеПолное.Лево;
			ОбластьНаименованиеПолноеПраво  = Макет.Области.НаименованиеПолное.Право;
			
			// Загружаем табличный документ
			ТабДокумент = Новый ТабличныйДокумент;
			ТабДокумент.Вывести(Макет);
			
			// Поищем КодПоОКЕИ в таблице классификатора
			НайденнаяОбласть = ТабДокумент.НайтиТекст(КодПоОКЕИ,, ТабДокумент.Области.КодЧисловой, , Истина, , Истина);
			
			// Инициализируем временную структуру для реквизитов единицы измерения
			ЗначенияЗаполнения = Новый Структура("Код, Наименование, НаименованиеПолное");
			
			// Если единица найдена, заполняем нашу структуру из классификатора
			Если НайденнаяОбласть <> Неопределено Тогда
				
				ЗначенияЗаполнения.Вставить("Код", ТабДокумент.Область(НайденнаяОбласть.Верх, ОбластьКодЧисловойЛево,
				НайденнаяОбласть.Низ, ОбластьКодЧисловойПраво).Текст);
				
				НаименованиеДляЗаполнения = ТабДокумент.Область(НайденнаяОбласть.Верх, ОбластьНаименованиеКраткоеЛево,
				НайденнаяОбласть.Низ, ОбластьНаименованиеКраткоеПраво).Текст;
				
				ЗначенияЗаполнения.Вставить("Наименование", СтрПолучитьСтроку(НаименованиеДляЗаполнения, 1));
				
				НаименованиеПолное = ТабДокумент.Область(НайденнаяОбласть.Верх, ОбластьНаименованиеПолноеЛево,
				НайденнаяОбласть.Низ, ОбластьНаименованиеПолноеПраво).Текст;
				
				ЗначенияЗаполнения.Вставить("НаименованиеПолное", СтрПолучитьСтроку(НаименованиеПолное, 1));
				
			// Если в классификаторе нет подходящей единицы, но у нас есть данные для заполнения справочника
			// то добавляем новую единицу по этим данным
			ИначеЕсли ЗначениеЗаполнено(Наименование) Тогда
				
				ЗначенияЗаполнения.Вставить("Код", КодПоОКЕИ);
				
				ЗначенияЗаполнения.Вставить("Наименование", Наименование);
				
				ЗначенияЗаполнения.Вставить("НаименованиеПолное", ?(ЗначениеЗаполнено(НаименованиеПолное), НаименованиеПолное, Наименование));
				
			// Если единицы нет в классификаторе и ничего кроме кода о ней не известно
			// возвращаем неопределено
			Иначе
				
				Возврат Неопределено;
				
			КонецЕсли;
			
			// Создаем единицу измерения в справочнике
			НоваяЕдиницаИзмерения = Справочники.КлассификаторЕдиницИзмерения.СоздатьЭлемент();
			
			ЗаполнитьЗначенияСвойств(НоваяЕдиницаИзмерения, ЗначенияЗаполнения);
			
			НоваяЕдиницаИзмерения.КодЭСФ = НоваяЕдиницаИзмерения.Код;
			НоваяЕдиницаИзмерения.Записать();
			
			ЕдиницаИзмерения = НоваяЕдиницаИзмерения.Ссылка;
			
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат ЕдиницаИзмерения;
	
КонецФункции	

Функция ПолучитьЕдиницуИзмеренияПоУмолчанию() Экспорт
	
	ЕдиницаПоУмолчанию = Справочники.КлассификаторЕдиницИзмерения.НайтиПоКоду("796");
	Если ЕдиницаПоУмолчанию = Справочники.КлассификаторЕдиницИзмерения.ПустаяСсылка() Тогда
		ЕдиницаПоУмолчанию = Справочники.КлассификаторЕдиницИзмерения.НайтиПоНаименованию("шт", Истина);
	КонецЕсли;
	
	Возврат ЕдиницаПоУмолчанию;
	
КонецФункции

#КонецОбласти

#КонецЕсли