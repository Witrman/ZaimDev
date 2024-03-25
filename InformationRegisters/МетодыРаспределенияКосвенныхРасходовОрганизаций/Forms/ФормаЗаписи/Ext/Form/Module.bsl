﻿
////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ПоддержкаРаботыСоСтруктурнымиПодразделениями = ПолучитьФункциональнуюОпцию("ПоддержкаРаботыСоСтруктурнымиПодразделениями");
	ЗаполнитьТЧМетодыРаспределения();
	
	Если НЕ ЗначениеЗаполнено(Параметры.Ключ) Тогда
		Если НЕ Справочники.Организации.ИспользуетсяНесколькоОрганизаций() Тогда
			Запись.СтруктурноеПодразделение = Справочники.ПодразделенияОрганизаций.ПустаяСсылка();
		КонецЕсли;
	КонецЕсли;
	
		// Включим предопределенные счета и их субсчета
	УчетПроизводства.ОграничитьВыборСчетамиНакладныхРасходов(Элементы.СчетЗатратБУ);
	УчетПроизводства.ОграничитьВыборСчетамиНакладныхРасходов(Элементы.СчетЗатратНУ, "Налоговый");
	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)

	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	// СтандартныеПодсистемы.ДатыЗапретаИзменения
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.ДатыЗапретаИзменения
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)

	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом

КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	
	//Если ЗначениеЗаполнено(Запись.Организация)
	//	И НЕ ЗначениеЗаполнено(Запись.СтруктурноеПодразделение) Тогда
	//	
	//	Запись.СтруктурноеПодразделение = Запись.Организация;
	//	
	//Иначе
		
	Если Запись.СтруктурноеПодразделение = Неопределено Тогда
		
		Запись.СтруктурноеПодразделение =  ПредопределенноеЗначение("Справочник.ПодразделенияОрганизаций.ПустаяСсылка");
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура МетодРаспределенияЗатратПриИзменении(Элемент)
	
	ЗаполнитьТЧМетодыРаспределения();
	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура СчетЗатратБУПриИзменении(Элемент)
	
	Запись.СчетЗатратНУ = ПроцедурыБухгалтерскогоУчетаВызовСервераПовтИсп.ПреобразоватьСчетаБУвСчетНУ(Новый Структура("СчетБУ", Запись.СчетЗатратБУ));	

КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма)
	
	Запись   = Форма.Запись;
	Элементы = Форма.Элементы;
	
	// Отображение колонки СтруктурноеПодразделение
	Если Форма.ПоддержкаРаботыСоСтруктурнымиПодразделениями Тогда 
		Элементы.МетодыРаспределенияСтруктурноеПодразделение.Видимость = Истина;
	Иначе 
		Элементы.МетодыРаспределенияСтруктурноеПодразделение.Видимость = Форма.ОтображениеКолонкиСтруктурноеПодразделение;
	КонецЕсли;

	ОтображениеПанелиСтруктурноеПодразделение = Ложь;

	Если ТипЗнч(Запись.СтруктурноеПодразделение) = Тип("СправочникСсылка.ПодразделенияОрганизаций") Тогда
		ОтображениеПанелиСтруктурноеПодразделение = Истина;
	КонецЕсли; 

	Если НЕ Форма.ПоддержкаРаботыСоСтруктурнымиПодразделениями И НЕ ОтображениеПанелиСтруктурноеПодразделение Тогда
		Элементы.СтруктурноеПодразделение.Видимость = Ложь;
	КонецЕсли;
			
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьТЧМетодыРаспределения()
	
	МетодыРаспределения.Очистить();
	Элементы.МетодыРаспределенияПроцентРаспределения.Видимость = Ложь;
		
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	МетодыРаспределенияКосвенныхРасходовАналитикаРаспределения.Ссылка,
		|	МетодыРаспределенияКосвенныхРасходовАналитикаРаспределения.НомерСтроки,
		|	МетодыРаспределенияКосвенныхРасходовАналитикаРаспределения.СтруктурноеПодразделение,
		|	МетодыРаспределенияКосвенныхРасходовАналитикаРаспределения.СчетЗакрытияБУ,
		|	МетодыРаспределенияКосвенныхРасходовАналитикаРаспределения.СубконтоБУ1,
		|	МетодыРаспределенияКосвенныхРасходовАналитикаРаспределения.СубконтоБУ2,
		|	МетодыРаспределенияКосвенныхРасходовАналитикаРаспределения.СубконтоБУ3,
		|	МетодыРаспределенияКосвенныхРасходовАналитикаРаспределения.СчетЗакрытияНУ,
		|	МетодыРаспределенияКосвенныхРасходовАналитикаРаспределения.СубконтоНУ1,
		|	МетодыРаспределенияКосвенныхРасходовАналитикаРаспределения.СубконтоНУ2,
		|	МетодыРаспределенияКосвенныхРасходовАналитикаРаспределения.СубконтоНУ3,
		|	МетодыРаспределенияКосвенныхРасходовАналитикаРаспределения.ПроцентРаспределения
		|ИЗ
		|	Справочник.МетодыРаспределенияКосвенныхРасходов.АналитикаРаспределения КАК МетодыРаспределенияКосвенныхРасходовАналитикаРаспределения
		|ГДЕ
		|	МетодыРаспределенияКосвенныхРасходовАналитикаРаспределения.Ссылка = &Ссылка";

	Запрос.УстановитьПараметр("Ссылка", Запись.МетодРаспределенияЗатрат);

	Результат = Запрос.Выполнить();

	ВыборкаДетальныеЗаписи = Результат.Выбрать();

	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		
		Строка = МетодыРаспределения.Добавить();
		
		Если ЗначениеЗаполнено(ВыборкаДетальныеЗаписи.ПроцентРаспределения) Тогда 
			Элементы.МетодыРаспределенияПроцентРаспределения.Видимость = Истина;
		КонецЕсли;
		
		Если ТипЗнч(ВыборкаДетальныеЗаписи.СтруктурноеПодразделение) = Тип("СправочникСсылка.ПодразделенияОрганизаций") Тогда
			ОтображениеКолонкиСтруктурноеПодразделение = Истина;
		КонецЕсли;
		
		ЗаполнитьЗначенияСвойств(Строка, ВыборкаДетальныеЗаписи);
				
	КонецЦикла;
		
КонецПроцедуры

