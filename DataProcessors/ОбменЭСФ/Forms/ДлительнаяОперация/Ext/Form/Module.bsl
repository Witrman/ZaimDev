﻿
&НаКлиенте
Перем ИнтервалОжидания;

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ТекстСообщения = НСтр("ru = 'Пожалуйста, подождите...'");
	Если Не ПустаяСтрока(Параметры.ТекстСообщения) Тогда
		ТекстСообщения = Параметры.ТекстСообщения + Символы.ПС + ТекстСообщения;
		Элементы.ДекорацияПоясняющийТекстДлительнойОперации.Заголовок = ТекстСообщения;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Параметры.ИдентификаторЗадания) Тогда
		ИдентификаторЗадания = Параметры.ИдентификаторЗадания;
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если Параметры.ВыводитьОкноОжидания Тогда
		ИнтервалОжидания = ?(Параметры.Интервал <> 0, Параметры.Интервал, 1);
		ПодключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеЗадания", ИнтервалОжидания, Истина);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)
	
	Если Статус = "" Тогда
		Результат = ПроверитьЗаданиеВыполнено();
		Статус = Результат.Статус;
	КонецЕсли;
	
	Если Статус = "Выполняется" Тогда
		Отказ = Истина;
		ЭСФКлиентСервер.СообщитьПользователю(НСтр("ru = 'Необходимо дождаться завершения работы фонового задания'"));
	КонецЕсли;
			
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии()
	
	ПриЗакрытииНаСервере()
	
КонецПроцедуры

#КонецОбласти

#Область Команды

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура Подключаемый_ПроверитьВыполнениеЗадания()
	
	Результат = ПроверитьЗаданиеВыполнено();
	Статус = Результат.Статус;
	
	Если Результат.Прогресс <> Неопределено Тогда
		ПрогрессСтрокой = ПрогрессСтрокой(Результат.Прогресс);
		Если Не ПустаяСтрока(ПрогрессСтрокой) Тогда
			Элементы.ДекорацияПоясняющийТекстДлительнойОперации.Заголовок = ТекстСообщения + " " + ПрогрессСтрокой;
		КонецЕсли;
	ИначеЕсли Результат.Сообщения <> Неопределено И ВладелецФормы <> Неопределено Тогда
		ИдентификаторНазначения = ВладелецФормы.УникальныйИдентификатор;
		Для каждого СообщениеПользователю Из Результат.Сообщения Цикл
			СообщениеПользователю.ИдентификаторНазначения = ИдентификаторНазначения;
			СообщениеПользователю.Сообщить();
		КонецЦикла;
	КонецЕсли;
		
	Если Статус = "Выполнено" Тогда
		
		ПоказатьОповещение();
		Закрыть(РезультатВыполнения(Результат));
		Возврат;
		
	ИначеЕсли Статус = "Ошибка" Тогда
		
		ПослеЗакрытияОкнаПредупреждения = Новый ОписаниеОповещения("ВыполнитьПослеЗакрытияОкнаПредупреждения", ЭтаФорма, Результат);
		ПоказатьПредупреждение(ПослеЗакрытияОкнаПредупреждения, ?(ПустаяСтрока(Результат.КраткоеПредставлениеОшибки), 
			НСтр("ru = 'Не удалось выполнить запрошенное действие.'"), Результат.КраткоеПредставлениеОшибки));
		Возврат;
		
	КонецЕсли;
	
	Если Параметры.ВыводитьОкноОжидания Тогда
		Если Параметры.Интервал = 0 Тогда
			ИнтервалОжидания = ИнтервалОжидания * 1.4;
			Если ИнтервалОжидания > 15 Тогда
				ИнтервалОжидания = 15;
			КонецЕсли;
		КонецЕсли;
		ПодключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеЗадания", ИнтервалОжидания, Истина);
	КонецЕсли;
		
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьПослеЗакрытияОкнаПредупреждения(Результат) Экспорт
	
	Закрыть(РезультатВыполнения(Результат));

КонецПроцедуры

&НаКлиенте
Процедура ПоказатьОповещение()
	
	Если Параметры.ОповещениеПользователя = Неопределено Или Не Параметры.ОповещениеПользователя.Показать Тогда
		Возврат;
	КонецЕсли;
	
	Оповещение = Параметры.ОповещениеПользователя;
	
	НавигационнаяСсылкаОповещения = Оповещение.НавигационнаяСсылка;
	Если НавигационнаяСсылкаОповещения = Неопределено И ВладелецФормы <> Неопределено И ВладелецФормы.Окно <> Неопределено Тогда
		НавигационнаяСсылкаОповещения = ВладелецФормы.Окно.ПолучитьНавигационнуюСсылку();
	КонецЕсли;
	ПояснениеОповещения = Оповещение.Пояснение;
	Если ПояснениеОповещения = Неопределено И ВладелецФормы <> Неопределено И ВладелецФормы.Окно <> Неопределено Тогда
		ПояснениеОповещения = ВладелецФормы.Окно.Заголовок;
	КонецЕсли;
	
	ПоказатьОповещениеПользователя(?(Оповещение.Текст <> Неопределено, Оповещение.Текст, НСтр("ru = 'Действие выполнено'")), 
		НавигационнаяСсылкаОповещения, ПояснениеОповещения);

КонецПроцедуры
	
&НаСервере
Функция ПроверитьЗаданиеВыполнено()
	
	Возврат ЭСФСерверПереопределяемый.ОперацияВыполнена(ИдентификаторЗадания, Ложь, Параметры.ВыводитьПрогрессВыполнения, Параметры.ВыводитьСообщения);
	
КонецФункции

&НаКлиенте
Функция ПрогрессСтрокой(Прогресс)
	
	Результат = "";
	Если Прогресс = Неопределено Тогда
		Возврат Результат;
	КонецЕсли;
	
	Процент = 0;
	Если Прогресс.Свойство("Процент", Процент) Тогда
		Результат = Строка(Процент) + "%";
	КонецЕсли;
	Текст = 0;
	Если Прогресс.Свойство("Текст", Текст) Тогда
		Если Не ПустаяСтрока(Результат) Тогда
			Результат = Результат + " (" + Текст + ")";
		Иначе
			Результат = Текст;
		КонецЕсли;
	КонецЕсли;

	Возврат Результат;
	
КонецФункции

&НаКлиенте
Функция РезультатВыполнения(Статус)
	
	Если Статус = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Результат = Новый Структура;
	Результат.Вставить("Статус", Статус.Статус);
	Результат.Вставить("АдресХранилища", Параметры.АдресРезультата);
	Результат.Вставить("АдресДополнительногоРезультата", Параметры.АдресДополнительногоРезультата);
	Результат.Вставить("КраткоеПредставлениеОшибки", Статус.КраткоеПредставлениеОшибки);
	Результат.Вставить("ПодробноеПредставлениеОшибки", Статус.ПодробноеПредставлениеОшибки);
	Возврат Результат;
	
КонецФункции
	
&НаСервере
Процедура ПриЗакрытииНаСервере()
	
	ЭСФСерверПереопределяемый.ОтменитьВыполнениеЗадания(ИдентификаторЗадания);
	
КонецПроцедуры

#КонецОбласти
