﻿#Область ПрограммныйИнтерфейс

Процедура ПоискНоменклатурыПоШтрихкодуПослеВводаСтроки(ДанныеШтрихкода, Контекст) Экспорт
	
	Штрихкод = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(ДанныеШтрихкода, "Штрихкод");
	
	Если Штрихкод = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Контекст.Вставить("Штрихкод", Штрихкод);
	
	НоменклатураПоШтрихкоду = РаботаСНоменклатуройВызовСервераБК.НоменклатураПоШтрихкоду(Штрихкод);
	Контекст.Вставить("Номенклатура", НоменклатураПоШтрихкоду);
	
	Если Не НоменклатураПоШтрихкоду.Пустая() Тогда
		ПоискНоменклатурыПоШтрихкодуЗавершение(Контекст);
	Иначе 
		ПроверитьДоступностьИВыполнитьПоиск(Контекст);
	КонецЕсли;
	
КонецПроцедуры

Процедура ПоискНоменклатурыПоШтрихкодуПослеДобавленияИзСервиса(Результат, Контекст) Экспорт
	
	Если ТипЗнч(Результат) = Тип("Строка") Тогда
		Контекст.Вставить("Идентификатор", Результат);
	Иначе 
		СозданнаяНоменклатура = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(Результат, "СозданнаяНоменклатура");
		Если ТипЗнч(СозданнаяНоменклатура) = Тип("Массив") И СозданнаяНоменклатура.Количество() > 0 Тогда
			НоменклатураПоШтрихкоду = СозданнаяНоменклатура[0];
			Контекст.Вставить("Номенклатура", НоменклатураПоШтрихкоду);
		КонецЕсли;
	КонецЕсли;
	
	ПоискНоменклатурыПоШтрихкодуЗавершение(Контекст);
	
КонецПроцедуры

Процедура ПодключитьИнтернетПоддержкуПользователей(Оповещение) Экспорт
	
	ИнтернетПоддержкаПользователейКлиент.ПодключитьИнтернетПоддержкуПользователей(
		Оповещение, ЭтотОбъект);
	
КонецПроцедуры

// См. РаботаСНоменклатуройКлиентПереопределяемый.СоздатьНоменклатуруИнтерактивно.
Процедура СоздатьНоменклатуруИнтерактивно(ПараметрыФормы, ОписаниеОповещенияОЗакрытии) Экспорт 
	
	ПараметрыСоздания = Новый Структура;
	Если ПараметрыФормы.Свойство("ИдентификаторНоменклатуры") Тогда
		ПараметрыСоздания.Вставить("ИдентификаторСервиса", ПараметрыФормы.ИдентификаторНоменклатуры);
	КонецЕсли;
	
	Если ПараметрыСоздания.Количество() = 0 Тогда
		ПараметрыСоздания = ПараметрыФормы;
	КонецЕсли;
	
	ОткрытьФорму("Справочник.Номенклатура.Форма.ФормаЭлемента", ПараметрыСоздания,,,,, ОписаниеОповещенияОЗакрытии);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ПроверитьДоступностьИВыполнитьПоиск(Контекст)
	
	ПараметрыДоступности = РаботаСНоменклатуройКлиентСерверБК.ПараметрыДоступностиСервиса();
	
	Если ТипЗнч(Контекст.ОповещениеОРезультате.Модуль) = Тип("ФормаКлиентскогоПриложения") Тогда
		ЗаполнитьЗначенияСвойств(ПараметрыДоступности, Контекст.ОповещениеОРезультате.Модуль);
	КонецЕсли;
	
	Если ПараметрыДоступности.ИнтернетПоддержкаПодключена = Неопределено Тогда
		РаботаСНоменклатуройВызовСервераБК.ЗаполнитьПараметрыДоступностиСервиса(ПараметрыДоступности);
	КонецЕсли;
	
	Для каждого Элемент Из ПараметрыДоступности Цикл
		Контекст.Вставить(Элемент.Ключ, Элемент.Значение);
	КонецЦикла;
	
	Если Не ПараметрыДоступности.СервисДоступен Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru = 'Нарушение прав доступа'"));
		ПоискНоменклатурыПоШтрихкодуЗавершение(Контекст);
	ИначеЕсли Не ПараметрыДоступности.СервисАктивен Тогда
		ТекстВопроса = Неопределено;
		Контекст.Свойство("ТекстВопроса", ТекстВопроса);
		Если ТекстВопроса = Неопределено Тогда
			ТекстВопроса = НСтр("ru = 'Хотите поискать в сервисе 1С:Номенклатура?'")
		КонецЕсли;
		
		Оповещение = Новый ОписаниеОповещения("ВопросВыполнитьПоискЗавершение", ЭтотОбъект, Контекст);
		ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ДаНет,, КодВозвратаДиалога.Да);
	ИначеЕсли Не ПараметрыДоступности.ИнтернетПоддержкаПодключена Тогда
		Оповещение = Новый ОписаниеОповещения("ПодключитьИнтернетПоддержкуПользователейНажатиеПродолжение", 
			ЭтотОбъект, Контекст);
		ПодключитьИнтернетПоддержкуПользователей(Оповещение);
	Иначе 
		ВыполнитьПоиск(Контекст);
	КонецЕсли;
	
КонецПроцедуры

Процедура ВыполнитьПоиск(Контекст)
	
	Контекст.Вставить("ВернутьОдинРезультат", Истина);
	Оповещение = Новый ОписаниеОповещения("ПоискНоменклатурыПоШтрихкодуПослеДобавленияИзСервиса", ЭтотОбъект, Контекст);
	РаботаСНоменклатуройКлиент.НайтиНоменклатуруПоШтрихкодуВСервисе(Контекст.Штрихкод, Неопределено, Оповещение);
	
КонецПроцедуры

Процедура ПодключитьИнтернетПоддержкуПользователейНажатиеПродолжение(Результат, ДополнительныеПараметры) Экспорт 
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ДополнительныеПараметры.Вставить("ИнтернетПоддержкаПодключена", Истина);
	ВыполнитьПоиск(ДополнительныеПараметры);
	
КонецПроцедуры

Процедура ПоискНоменклатурыПоШтрихкодуЗавершение(Контекст)
	
	Результат = Новый Структура;
	Результат.Вставить("Номенклатура", ПредопределенноеЗначение("Справочник.Номенклатура.ПустаяСсылка"));
	Результат.Вставить("Штрихкод", "");
	Результат.Вставить("Идентификатор", "");
	
	ЗаполнитьЗначенияСвойств(Результат, Контекст);
	
	Если Контекст.Свойство("ИнтернетПоддержкаПодключена") Тогда
		Результат.Вставить("ИнтернетПоддержкаПодключена", Контекст.ИнтернетПоддержкаПодключена);
	КонецЕсли;
	
	Если Контекст.Свойство("СервисАктивен") Тогда
		Результат.Вставить("СервисАктивен", Контекст.СервисАктивен);
	КонецЕсли;
	
	ВыполнитьОбработкуОповещения(Контекст.ОповещениеОРезультате, Результат);
	
КонецПроцедуры

#КонецОбласти
