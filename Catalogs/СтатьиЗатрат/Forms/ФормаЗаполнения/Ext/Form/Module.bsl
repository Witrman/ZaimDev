﻿
////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	ПодготовитьФормуНаСервере();	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаСервере
Процедура ПодготовитьФормуНаСервере()
	
	Если Параметры.Свойство("ЗаполнениеКлассификатора") И Параметры.ЗаполнениеКлассификатора Тогда
		Элементы.Страницы.ТекущаяСтраница = Элементы.ОжиданиеОбработки;
	Иначе
		Элементы.Страницы.ТекущаяСтраница = Элементы.ГруппаСлужебноеИспользование;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьКлассификатор() Экспорт
	ПодключитьОбработчикОжидания("ЗаполнениеКлассификатора", 0.1, Истина);	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнениеКлассификатора()
	
	Элементы.Страницы.ТекущаяСтраница = Элементы.ОжиданиеОбработки;	
	
	ЗаполнитьКлассификаторНаСервере();
	
	Если РезультатФоновогоЗадания.ЗаданиеВыполнено Тогда
		ПоказатьСообщениеОЗавершении();
	Иначе
		ПодключитьОбработчикОжидания("ПроверитьВыполнениеЗаполнения", 1, Истина);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьВыполнениеЗаполнения()
	
	Попытка
		РезультатФоновогоЗадания.ЗаданиеВыполнено = ЗаданиеВыполнено(РезультатФоновогоЗадания.ИдентификаторЗадания);
	Исключение
		ВызватьИсключение ОписаниеОшибки();
	КонецПопытки;
		
	Если РезультатФоновогоЗадания.ЗаданиеВыполнено Тогда
		ПоказатьСообщениеОЗавершении();
	Иначе
		ПодключитьОбработчикОжидания("ПроверитьВыполнениеИзменения", 1, Истина);
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ЗаданиеВыполнено(ИдентификаторЗадания)
	Возврат ДлительныеОперации.ЗаданиеВыполнено(ИдентификаторЗадания);
КонецФункции

&НаКлиенте
Процедура ПоказатьСообщениеОЗавершении()
	Оповестить("ОкончаниеЗагрузкиКлассификатораСтатейЗатрат", Параметры, ЭтаФорма);
	ЭтаФорма.Закрыть();	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьКлассификаторНаСервере()
	
	НаименованиеЗадания = НСтр("ru = 'Загрузка классификатора статей затрат'");
		
	ВыполняемыйМетод = "Справочники.СтатьиЗатрат.ВыполнитьЗагрузкуКлассификатора";
	СтруктураПараметров = Новый Структура("ИмяОбработки, ИмяМетода, ПараметрыВыполнения, ЭтоВнешняяОбработка, ДополнительнаяОбработкаСсылка",
		"СтатьиЗатрат", "ВыполнитьЗагрузкуКлассификатора", , Ложь, "");
		
	РезультатФоновогоЗадания = ДлительныеОперации.ЗапуститьВыполнениеВФоне(
			УникальныйИдентификатор,
			ВыполняемыйМетод,
			СтруктураПараметров, 
			НаименованиеЗадания);
	
КонецПроцедуры




