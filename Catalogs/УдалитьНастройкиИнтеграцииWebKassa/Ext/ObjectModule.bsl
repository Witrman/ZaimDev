﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Только для внутреннего использования
Функция НастройкаОбменаУникальна() Экспорт
	
	Если ПометкаУдаления Тогда
		Возврат Истина;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Организация) Тогда
		Возврат Истина
	КонецЕсли;
	
	ТекущаяНастройкаУникальна = Истина;
	
	// Проверка на уникальное использование настройки по реквизитам: Организация, Банк
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ТекущаяНастройка", Ссылка);
	Запрос.УстановитьПараметр("Организация", Организация);
	
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	НастройкиИнтеграции.Организация
	|ИЗ
	|	Справочник.НастройкиИнтеграцииWebKassa КАК НастройкиИнтеграции
	|ГДЕ
	|	НЕ НастройкиИнтеграции.ПометкаУдаления
	|	И НастройкиИнтеграции.Организация = &Организация
	|	И НастройкиИнтеграции.Ссылка <> &ТекущаяНастройка";
	
	Результат = Запрос.Выполнить();
	Если Не Результат.Пустой() Тогда
		ТекущаяНастройкаУникальна = Ложь;
		
		Выборка = Результат.Выбрать();
		Пока Выборка.Следующий() Цикл
			ШаблонСообщения = НСтр("ru = 'В информационной базе уже существует настройка интеграции
									|с сервисом 1С:WebKassa для организации %1'");
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				ШаблонСообщения, Выборка.Организация);
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения);
		КонецЦикла;
	КонецЕсли;
	
	Возврат ТекущаяНастройкаУникальна;
	
КонецФункции

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если Не НастройкаОбменаУникальна() Тогда
		Отказ = Истина;
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если ПометкаУдаления Тогда
		ПроверяемыеРеквизиты.Очистить();
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
