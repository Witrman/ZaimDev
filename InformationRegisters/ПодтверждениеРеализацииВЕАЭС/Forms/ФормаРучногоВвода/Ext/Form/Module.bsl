﻿&НаКлиенте
Перем ВыполняетсяЗакрытие;

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	ЗаполнитьЗначенияСвойств(ЭтаФорма, Параметры, "Документ, Состояние, ДатаПодтверждения, НомерПодтверждения, Комментарий, ТекущийПериод");
	Если Параметры.Свойство("ЗаписыватьРезультат") Тогда
		ЗаписыватьРезультат = Параметры.ЗаписыватьРезультат;
	КонецЕсли;
	
	Если Параметры.Свойство("Модифицированность") Тогда
		Модифицированность = Параметры.Модифицированность;
		ПриИзмененииСостояния(ЭтаФорма);
	КонецЕсли;
	
	ЕстьПравоИзменения = ПравоДоступа("Изменение", Метаданные.РегистрыСведений.ПодтверждениеРеализацииВЕАЭС);
	ЭтаФорма.ТолькоПросмотр = НЕ ЕстьПравоИзменения;
	Элементы.Сохранить.Видимость = ЕстьПравоИзменения;
	Если НЕ ЕстьПравоИзменения
		ИЛИ НЕ ЗаписьСуществует() Тогда
		Элементы.УдалитьЗапись.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	УстановитьВидимость();
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)
	
	Если Не ВыполняетсяЗакрытие И Модифицированность Тогда
		
		Отказ = Истина;
		ПоказатьВопрос(Новый ОписаниеОповещения("ПередЗакрытиемЗавершение", ЭтаФорма), НСтр("ru = 'Данные были изменены. Сохранить изменения?'"), РежимДиалогаВопрос.ДаНетОтмена);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытиемЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Ответ = РезультатВопроса;
	
	Если Ответ = КодВозвратаДиалога.Да Тогда
		ВыполняетсяЗакрытие = Истина;
		СохранитьРезультат();
	ИначеЕсли Ответ = КодВозвратаДиалога.Нет Тогда
		ВыполняетсяЗакрытие = Истина;
		Модифицированность = Ложь;
		Закрыть(Неопределено);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Сохранить(Команда)
	
	СохранитьРезультат();
	
КонецПроцедуры

&НаКлиенте
Процедура УдалитьЗапись(Команда)
	
	УдалитьЗаписьНаСервере();
	ВыполняетсяЗакрытие = Истина;
	
	ОповеститьОВыборе(Новый Структура("Состояние, ДатаПодтверждения, НомерПодтверждения, Комментарий, УдалениеЗаписи", 
		ПредопределенноеЗначение("Перечисление.СостоянияРеализацийВЕАЭС.ПустаяСсылка"), '00010101', "", "", Истина));
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ПриИзмененииРеквизитов

&НаКлиенте
Процедура СостояниеПриИзменении(Элемент)
	
	ПриИзмененииСостояния(ЭтаФорма);
	
	УстановитьВидимость();
	
КонецПроцедуры

#КонецОбласти

#Область Прочее

&НаКлиентеНаСервереБезКонтекста
Процедура ПриИзмененииСостояния(Форма)
	
	Если Форма.Состояние = ПредопределенноеЗначение("Перечисление.СостоянияРеализацийВЕАЭС.НеПодтвержденаРеализация") Тогда
		Форма.ДатаПодтверждения  = Форма.ТекущийПериод;
		Форма.НомерПодтверждения = "";
	ИначеЕсли Форма.Состояние = ПредопределенноеЗначение("Перечисление.СостоянияРеализацийВЕАЭС.ПодтвержденаРеализация") Тогда
		Форма.ДатаПодтверждения = Форма.ТекущийПериод;
	Иначе
		Форма.ДатаПодтверждения  = '00010101';
		Форма.НомерПодтверждения = "";
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьВидимость()
	
	Если Состояние = ПредопределенноеЗначение("Перечисление.СостоянияРеализацийВЕАЭС.НеПодтвержденаРеализация") Тогда
		Элементы.ДатаПодтверждения.Видимость  = Истина;
		Элементы.НомерПодтверждения.Видимость = Ложь;
	ИначеЕсли Состояние = ПредопределенноеЗначение("Перечисление.СостоянияРеализацийВЕАЭС.ПодтвержденаРеализация") Тогда
		Элементы.ДатаПодтверждения.Видимость  = Истина;
		Элементы.НомерПодтверждения.Видимость = Истина;
	Иначе
		Элементы.ДатаПодтверждения.Видимость  = Ложь;
		Элементы.НомерПодтверждения.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьРезультат()
	
	Результат = Новый Структура("Состояние, ДатаПодтверждения, НомерПодтверждения, Комментарий", Состояние, ДатаПодтверждения, НомерПодтверждения, Комментарий);
	
	Модифицированность = Ложь;
	
	Если ЗаписыватьРезультат Тогда
		Если Состояние = ПредопределенноеЗначение("Перечисление.СостоянияРеализацийВЕАЭС.ОжидаетсяПодтверждение") Тогда
			УдалитьЗаписьНаСервере();
			Результат.Вставить("Состояние", ПредопределенноеЗначение("Перечисление.СостоянияРеализацийВЕАЭС.ПустаяСсылка"));
			Результат.Вставить("УдалениеЗаписи", Истина);
		Иначе
			СохранитьРезультатНаСервере();
		КонецЕсли;
		
		Оповестить("Запись_ПодтверждениеРеализацииВЕАЭС");
	КонецЕсли;
	
	ОповеститьОВыборе(Результат);
	
КонецПроцедуры

&НаСервере
Процедура СохранитьРезультатНаСервере()

	МенеджерЗаписи = РегистрыСведений.ПодтверждениеРеализацииВЕАЭС.СоздатьМенеджерЗаписи();
	МенеджерЗаписи.ДокументРеализации = Документ;
	МенеджерЗаписи.Прочитать();
	
	Если НЕ МенеджерЗаписи.Выбран() Тогда
		МенеджерЗаписи.ДокументРеализации = Документ;
	КонецЕсли;
	
	МенеджерЗаписи.Состояние          = Состояние;
	МенеджерЗаписи.ДатаПодтверждения  = ДатаПодтверждения;
	МенеджерЗаписи.НомерПодтверждения = НомерПодтверждения;
	МенеджерЗаписи.Комментарий        = Комментарий;
	
	НачатьТранзакцию();
	
	Попытка
		МенеджерЗаписи.Записать(Истина);
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ОбщегоНазначения.СообщитьПользователю(КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
	КонецПопытки;
	
КонецПроцедуры

&НаСервере
Процедура УдалитьЗаписьНаСервере()
	
	УстановитьПривилегированныйРежим(Истина);
	
	НаборЗаписей = РегистрыСведений.ПодтверждениеРеализацииВЕАЭС.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.ДокументРеализации.Значение = Документ;
	НаборЗаписей.Отбор.ДокументРеализации.Использование = Истина;
	НаборЗаписей.Прочитать();
	Если НаборЗаписей.Количество() > 0 Тогда
		НаборЗаписей.Очистить();
		НаборЗаписей.Записать();
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Ложь);
	
КонецПроцедуры

&НаСервере
Функция ЗаписьСуществует()
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос;
	Запрос.Текст = "
	|ВЫБРАТЬ
	|	ИСТИНА
	|ИЗ
	|	РегистрСведений.ПодтверждениеРеализацииВЕАЭС КАК ПодтверждениеРеализацииВЕАЭС
	|ГДЕ
	|	ПодтверждениеРеализацииВЕАЭС.ДокументРеализации = &ДокументРеализации";
	
	Запрос.УстановитьПараметр("ДокументРеализации", Документ);
	
	Возврат НЕ Запрос.Выполнить().Пустой();
	
КонецФункции

#КонецОбласти

#КонецОбласти

ВыполняетсяЗакрытие = Ложь;