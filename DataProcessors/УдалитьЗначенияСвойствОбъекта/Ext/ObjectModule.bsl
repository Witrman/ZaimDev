﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

// Процедура заполняет табличную часть обработки свойствами и значениями свойств объекта.
// При заполнении используются значения реквизитов обработки: 
// ОбъектОтбораЗначений - объект, значения свойств которого отбираются.
// НазначениеСвойств - значение реквизита, по которому отбораются свойства.
//
// Параметры:
//  Нет.
//
Процедура ПрочитатьЗаполнитьСвойстваИЗначения() Экспорт

	СвойстваИЗначения.Загрузить(ПрочитатьТаблицуСвойствИЗначений());

КонецПроцедуры

// Функция записывает значения свойств в информационную базу.
//
// Параметры:
//  Нет.
//
// Возвращаемое значение:
//  Истина - если значения свойств были записаны, или их не требуется записывать
//  Ложь   - если значения свойств не удалось записать.
//
Функция ЗаписатьЗначенияСвойств() Экспорт
	
	Если ОбщегоНазначенияБК.ПроверитьПравоДоступа(Метаданные.РегистрыСведений.УдалитьЗначенияСвойствОбъектов, "Изменение", Истина) Тогда
		
		НаборЗаписейЗначенияСвойств = РегистрыСведений.УдалитьЗначенияСвойствОбъектов.СоздатьНаборЗаписей();
		
		Для каждого Строка Из СвойстваИЗначения Цикл
			Если ЗначениеЗаполнено(Строка.Значение) Тогда
				Запись = НаборЗаписейЗначенияСвойств.Добавить();
				
				Запись.Объект   = ОбъектОтбораЗначений;
				Запись.Свойство = Строка.Свойство;
				Запись.Значение = Строка.Значение;
			КонецЕсли;
		КонецЦикла;
		
		НаборЗаписейЗначенияСвойств.Отбор.Объект.Установить(ОбъектОтбораЗначений);
		
		Попытка
			НаборЗаписейЗначенияСвойств.Записать();
		Исключение
			ВызватьИсключение "Не удалось записать значения свойств:" + Символы.ПС + ОписаниеОшибки();
		КонецПопытки;
		
		Возврат Истина;		
	Иначе
		Возврат Ложь;
	КонецЕсли;
	
КонецФункции

// Процедура проверяет, должно ли новое свойство попасть в табличную часть обработки, 
// если да - добавляет свойство.
// Предназначена для вызова из обработчиков форм ОбработкаЗаписиНовогоОбъекта.
//
// Параметры:
//  Свойство - добавляемое свойство.
//
Процедура ПроверитьДобавитьНовоеСвойство(Свойство) Экспорт

	// Запросом проверяется, должно ли новое свойство быть отобрано в табличную часть.

	Запрос = Новый Запрос();

	Запрос.УстановитьПараметр("Свойство",                Свойство);
	Запрос.УстановитьПараметр("НазначениеСвойств",       НазначениеСвойств);
	Запрос.УстановитьПараметр("СписокНазначенийСвойств", СписокНазначенийСвойств());

	Запрос.Текст = "
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	СвойстваОбъектов.Ссылка                                     КАК Свойство
	|
	|ИЗ
	|// Отбирается свойство.
	|	(
	|	ВЫБРАТЬ 
	|		ПланВидовХарактеристик.УдалитьСвойстваОбъектов.Ссылка          КАК Ссылка
	|
	|	ИЗ
	|		ПланВидовХарактеристик.УдалитьСвойстваОбъектов
	|
	|	ГДЕ
	|		ПланВидовХарактеристик.УдалитьСвойстваОбъектов.НазначениеСвойства В ( &НазначениеСвойств )
	|		И
	|		ПланВидовХарактеристик.УдалитьСвойстваОбъектов.Ссылка             = &Свойство
	|
	|	)                                                           КАК СвойстваОбъектов
	|
	|ЛЕВОЕ ВНЕШНЕЕ СОЕДИНЕНИЕ
	|// Присоединяются группы, которым назначено свойство, для отбора свойств.
	|	РегистрСведений.УдалитьНазначенияСвойствОбъектов
	|ПО
	|	РегистрСведений.УдалитьНазначенияСвойствОбъектов.Свойство = &Свойство
	|
	|ГДЕ
	|// Свойство должно быть назанчено или всем объектам,
	|// или одной из групп - родителей объекта.
	|	РегистрСведений.УдалитьНазначенияСвойствОбъектов.Объект ЕСТЬ NULL
	|	ИЛИ
	|	РегистрСведений.УдалитьНазначенияСвойствОбъектов.Объект В ( &СписокНазначенийСвойств )
	|";

	Если Запрос.Выполнить().Пустой() Тогда
		Возврат;
	КонецЕсли;

	// Определение позиции свойства в табличной части.

	Для Индекс = 0 По СвойстваИЗначения.Количество() - 1 Цикл
		Если Свойство.Наименование < СвойстваИЗначения[Индекс].Свойство.Наименование Тогда
			Прервать;
		КонецЕсли;
	КонецЦикла;

	// Вставка свойства с соответствующую позицию.

	НоваяСтрока = СвойстваИЗначения.Вставить(Индекс);
	
	Если Свойство.ПометкаУдаления Тогда
		НоваяСтрока.ИндексКартинки = ОбщегоНазначенияБККлиентСервер.ИндексПиктограммыЭлементПомеченныйНаУдаление();	
	Иначе
		НоваяСтрока.ИндексКартинки = ОбщегоНазначенияБККлиентСервер.ИндексПиктограммыЭлемент();	
	КонецЕсли;
	
	НоваяСтрока.Свойство = Свойство;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

Функция ПрочитатьТаблицуСвойствИЗначений()
	
	Запрос = Новый Запрос();
	
	Запрос.УстановитьПараметр("НазначениеСвойств", НазначениеСвойств);
	Запрос.УстановитьПараметр("ОбъектОтбораЗначений", ОбъектОтбораЗначений);
	Запрос.УстановитьПараметр("СписокНазначенийСвойств", СписокНазначенийСвойств());
	Запрос.УстановитьПараметр("ИндексПиктограммыЭлемент", ОбщегоНазначенияБККлиентСервер.ИндексПиктограммыЭлемент());
	Запрос.УстановитьПараметр("ИндексПиктограммыЭлементПомеченныйНаУдаление", ОбщегоНазначенияБККлиентСервер.ИндексПиктограммыЭлементПомеченныйНаУдаление());
	
	Запрос.Текст = "
	|ВЫБРАТЬ РАЗЛИЧНЫЕ РАЗРЕШЕННЫЕ
	|	ВЫБОР 
	|		КОГДА СвойстваОбъектов.ПометкаУдаления ТОГДА &ИндексПиктограммыЭлементПомеченныйНаУдаление
	|		ИНАЧЕ &ИндексПиктограммыЭлемент
	|	КОНЕЦ КАК ИндексКартинки,
	|	СвойстваОбъектов.Ссылка                                     КАК Свойство,
	|	РегистрСведений.УдалитьЗначенияСвойствОбъектов.Значение            КАК Значение,
	|	СвойстваОбъектов.Наименование
	|
	|ИЗ
	|// Отбираются свойства, предназначенные для заданного типа объектов.
	|	(
	|	ВЫБРАТЬ 
	|		ПланВидовХарактеристик.УдалитьСвойстваОбъектов.Ссылка          КАК Ссылка,
	|		ПланВидовХарактеристик.УдалитьСвойстваОбъектов.Наименование    КАК Наименование,
	|		ПланВидовХарактеристик.УдалитьСвойстваОбъектов.ПометкаУдаления КАК ПометкаУдаления
	|
	|	ИЗ
	|		ПланВидовХарактеристик.УдалитьСвойстваОбъектов
	|
	|	ГДЕ
	|		ПланВидовХарактеристик.УдалитьСвойстваОбъектов.НазначениеСвойства В ( &НазначениеСвойств )
	|
	|	)                                                           КАК СвойстваОбъектов
	|
	|ЛЕВОЕ ВНЕШНЕЕ СОЕДИНЕНИЕ
	|// Присоединяются значения свойств, назначенные для заданного объекта.
	|	РегистрСведений.УдалитьЗначенияСвойствОбъектов
	|ПО
	|	РегистрСведений.УдалитьЗначенияСвойствОбъектов.Свойство = СвойстваОбъектов.Ссылка
	|	И
	|	РегистрСведений.УдалитьЗначенияСвойствОбъектов.Объект = &ОбъектОтбораЗначений
	|
	|ЛЕВОЕ ВНЕШНЕЕ СОЕДИНЕНИЕ
	|// Присоединяются группы, которым назначено свойство, для отбора свойств.
	|// Если свойству назначено значение, оно отбирается в любом случае.
	|	РегистрСведений.УдалитьНазначенияСвойствОбъектов
	|ПО
	|	РегистрСведений.УдалитьНазначенияСвойствОбъектов.Свойство = СвойстваОбъектов.Ссылка
	|	И
	|	РегистрСведений.УдалитьЗначенияСвойствОбъектов.Значение ЕСТЬ NULL
	|
	|ГДЕ
	|// Если значение свойства не задано, свойство должно быть назанчено
	|// или всем объектам, или одной из групп - родителей объекта.
	|	РегистрСведений.УдалитьНазначенияСвойствОбъектов.Объект ЕСТЬ NULL
	|	ИЛИ
	|	РегистрСведений.УдалитьНазначенияСвойствОбъектов.Объект В ( &СписокНазначенийСвойств )
	|
	|УПОРЯДОЧИТЬ ПО
	|	СвойстваОбъектов.Наименование
	|";
		
	Возврат Запрос.Выполнить().Выгрузить();
	
КонецФункции

// Функция формирует список значений, содержащий объект отбора назначений свойств 
// и всех его родителей. Список используется в качестве параметра запросов.
//
// Параметры:
//  Нет.
//
// Возвращаемое значение:
//  Cписок значений, содержащий объект отбора назначений и всех его родителей.
//
Функция СписокНазначенийСвойств()

	СписокНазначенийСвойств = Новый СписокЗначений;
	
	Если ЗначениеЗаполнено(ОбъектОтбораНазначений) Тогда
		ЭтоСправочник = Метаданные.Справочники.Содержит(ОбъектОтбораНазначений.Метаданные());
	КонецЕсли;
	
	Назначение = ОбъектОтбораНазначений;
	
	Пока ЗначениеЗаполнено(Назначение) Цикл
		
		СписокНазначенийСвойств.Добавить(Назначение);
		
		Если ЭтоСправочник Тогда
			Назначение = Назначение.Родитель;
		Иначе
			Прервать;
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат СписокНазначенийСвойств;
	
КонецФункции

#КонецЕсли