﻿////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ТекущаяДата = ЭтотОбъект.Запись.Период;
	
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
Процедура ПериодПриИзменении(Элемент)
	
	Если ТекущаяДата = ЭтотОбъект.Запись.Период Тогда 
		Возврат;
	КонецЕсли;
		
	РабочаяДата = ПолучитьРабочуюДату();
	
	Если ЭтотОбъект.Запись.Период > РабочаяДата Тогда
		
		ТекстВопроса = НСтр("ru='Вы действительно хотите ввести вычеты" + Символы.ПС + "на будущую дату?'");
		Режим 	     = РежимДиалогаВопрос.ДаНет;
		Оповещение   = Новый ОписаниеОповещения("ПослеИзмененияПериода", ЭтотОбъект, Параметры);
		ПоказатьВопрос(Оповещение, ТекстВопроса, Режим, 0);
		
	КонецЕсли;

КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаКлиенте
Процедура ПослеИзмененияПериода(Результат, Параметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Нет Тогда
		ЭтотОбъект.Запись.Период = РабочаяДата;
	КонецЕсли;

КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьРабочуюДату() 
	
	Возврат ОбщегоНазначения.ТекущаяДатаПользователя();
	
КонецФункции



