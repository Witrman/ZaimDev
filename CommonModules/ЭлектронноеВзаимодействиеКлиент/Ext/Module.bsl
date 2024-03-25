﻿////////////////////////////////////////////////////////////////////////////////
// ЭлектронноеВзаимодействиеКлиент: общий механизм обмена электронными документами.
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// См. ЭлектроннаяПодписьКлиентПереопределяемый.ПриДополнительнойПроверкеСертификата
//
Процедура ПриДополнительнойПроверкеСертификата(Параметры) Экспорт
	
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("ЭлектронноеВзаимодействие.ОбменСБанками") Тогда
		МодульОбменаСБанками = ОбщегоНазначенияКлиент.ОбщийМодуль("ОбменСБанкамиКлиент");
		МодульОбменаСБанками.ПриДополнительнойПроверкеСертификата(Параметры);
	КонецЕсли;

КонецПроцедуры

// См. ОбщегоНазначенияКлиентПереопределяемый.ПослеНачалаРаботыСистемы
//
Процедура ПослеНачалаРаботыСистемы() Экспорт
	
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("ЭлектронноеВзаимодействие.ОбменСКонтрагентами") Тогда
		МодульОбменСКонтрагентами = ОбщегоНазначенияКлиент.ОбщийМодуль("ОбменСКонтрагентамиСлужебныйКлиент");
		МодульОбменСКонтрагентами.ПослеНачалаРаботыСистемы();
	КонецЕсли;
	
КонецПроцедуры

// Обработка нажатия на рекламную ссылку на форме печати БСП.
//
// Параметры:
//  НавигационнаяСсылка - Строка - текст навигационной ссылки;
//  Параметры - Произвольный - значение, которое будет передано процедуру обработки.
//
Процедура ОбработкаНавигационнойСсылкиВФормеПечатиБСП(НавигационнаяСсылка, Параметры = Неопределено) Экспорт
	
	Если НавигационнаяСсылка = "Реклама1СДиректБанк" Тогда
		
		МодульОбменСБанкамиКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ОбменСБанкамиКлиент");
		МодульОбменСБанкамиКлиент.ОбработкаНавигационнойСсылкиВФормеПечатиБСП(НавигационнаяСсылка, Параметры);
		
	ИначеЕсли НавигационнаяСсылка = "Реклама1СЭДО" Тогда
		
		МодульОбменСКонтрагентамиКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ОбменСКонтрагентамиКлиент");
		МодульОбменСКонтрагентамиКлиент.ОбработкаНавигационнойСсылкиВФормеПечатиБСП(НавигационнаяСсылка, Параметры);
		
	КонецЕсли;	
	
КонецПроцедуры	

// Выполнение подключаемой команды ЭДО.
//
// Параметры:
//  Команда - КомандаФормы - вызывающая команда.
//  Форма - ФормаКлиентскогоПриложения - вызывающая форма.
//  Источник - РеквизитФормы -реквизит формы.
//
Процедура ВыполнитьПодключаемуюКомандуЭДО(Знач Команда, Знач Форма, Знач Источник) Экспорт
	
	ОписаниеКоманды = Команда;
	Если ТипЗнч(Команда) = Тип("КомандаФормы") Тогда
		АдресКомандВоВременномХранилище = Форма.Команды.Найти("АдресКомандЭДОВоВременномХранилище").Действие;
		ОписаниеКоманды = ОписаниеКомандыЭДО(Команда.Имя, АдресКомандВоВременномХранилище);
	КонецЕсли;
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ОписаниеКоманды", ОписаниеКоманды);
	ДополнительныеПараметры.Вставить("Форма", Форма);
	ДополнительныеПараметры.Вставить("Источник", Источник);
	
	Если ТипЗнч(Источник) = Тип("ДанныеФормыСтруктура")
		И (Источник.Ссылка.Пустая() Или Форма.Модифицированность) Тогда
		
		ТекстВопроса = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Данные еще не записаны.
				|Выполнение действия ""%1"" возможно только после записи данных.
				|Данные будут записаны.'"),
			ОписаниеКоманды.Представление);
			
		ОписаниеОповещения = Новый ОписаниеОповещения("ВыполнитьПодключаемуюКомандуЭДОПодтверждениеЗаписи",
			ЭлектронноеВзаимодействиеСлужебныйКлиент, ДополнительныеПараметры);
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ОКОтмена);
		Возврат;
	КонецЕсли;
	
	ЭлектронноеВзаимодействиеСлужебныйКлиент.ВыполнитьПодключаемуюКомандуЭДОПодтверждениеЗаписи(
		Неопределено, ДополнительныеПараметры);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Получение структуры команды их сохраненной настройки.
//  ИмяКоманды - Строка - имя команды.
//  АдресКомандВоВременномХранилище - Строка - адрес во временном хранилище.
//
Функция ОписаниеКомандыЭДО(ИмяКоманды, АдресКомандВоВременномХранилище)
	
	Возврат ЭлектронноеВзаимодействиеСлужебныйВызовСервера.ОписаниеКомандыЭДО(
		ИмяКоманды, АдресКомандВоВременномХранилище);
	
КонецФункции

#КонецОбласти
