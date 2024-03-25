﻿#Область ОбработчикиСобытийФормы

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ПолучитьСписокВыбораВидаДохода(Запись.Период);	
	УправлениеВидимостью(ЭтаФорма);

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

#КонецОбласти

&НаКлиенте
Процедура ПериодПриИзменении(Элемент)
	
	ПолучитьСписокВыбораВидаДохода(Запись.Период);
	УправлениеВидимостью(ЭтаФорма);

КонецПроцедуры

&НаКлиенте
Процедура ПолучитьСписокВыбораВидаДохода(Период)
	
	Элементы.ВидДохода.СписокВыбора.Очистить();
	
	Если Период < '20200101'
		И ЗначениеЗаполнено(Период) Тогда		
		Элементы.ВидДохода.СписокВыбора.Добавить(ПредопределенноеЗначение("Перечисление.ЮрФизЛицо.ФизЛицо"), НСтр("ru = 'Доходы от работодателя'"));	
		Элементы.ВидДохода.СписокВыбора.Добавить(ПредопределенноеЗначение("Перечисление.ЮрФизЛицо.ЮрЛицо"),  НСтр("ru = 'Доходы от налогового агента / Доходы ИП (в 2017)'"));
	Иначе 	
		Элементы.ВидДохода.СписокВыбора.Добавить(ПредопределенноеЗначение("Перечисление.ЮрФизЛицо.ФизЛицо"), НСтр("ru = 'Доходы от работодателя'"));	
		Элементы.ВидДохода.СписокВыбора.Добавить(ПредопределенноеЗначение("Перечисление.ЮрФизЛицо.ЮрЛицо"),  НСтр("ru = 'Доходы от налогового агента'"));
	КонецЕсли;
	
	Элементы.ВидДохода.ОбновитьТекстРедактирования();
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеВидимостью(Форма)

	Запись		= Форма.Запись;
	Элементы	= Форма.Элементы;
	
	Если Запись.Период < '20200101' Тогда
		Элементы.Налогоплательщик.Видимость	  = Ложь;
	Иначе
		Элементы.Налогоплательщик.Видимость	  = Истина;
	КонецЕсли;
	
КонецПроцедуры

