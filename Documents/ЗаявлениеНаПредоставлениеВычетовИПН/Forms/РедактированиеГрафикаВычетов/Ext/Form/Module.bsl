﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ПолучитьПараметры();
	ПересчитатьНомераСтрок();
	Заголовок = СтрЗаменить(НСтр("ru='График платежей по виду вычета ""%1""'"),"%1",ВидВычетаИПН);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)
	
	Оповещение = Новый ОписаниеОповещения("ВыбратьИЗакрыть", ЭтотОбъект);
	ОбщегоНазначенияКлиент.ПоказатьПодтверждениеЗакрытияФормы(Оповещение, Отказ, Ложь);
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	Ошибки = Неопределено;
	
	Для каждого Строка Из ПрочиеВычеты Цикл
		
		ПроверитьСтрокуТЧ(
			Месяц,
			МесяцЗавершения,
			Строка.ДействуетС,
			Строка.ДействуетПо,
			Строка.НомерСтроки,
			Строка.Размер,
			Ошибки);
					
	КонецЦикла;
	
	ОбщегоНазначенияКлиентСервер.СообщитьОшибкиПользователю(Ошибки, Отказ);
	
	Если Не Отказ Тогда
		ПроверитьПересечениеПериодов(Отказ);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОК(Команда)
	
	ВыбратьИЗакрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	
	Модифицированность = Ложь;
	Закрыть();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыПрочиеВычеты

&НаКлиенте
Процедура ПрочиеВычетыПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	ТекущиеДанные = Элементы.ПрочиеВычеты.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если НоваяСтрока Тогда
		
		ДатаНачала 		= Дата(1,1,1);
		ДатаОкончания 	= Дата (1,1,1);
		
		Если ПрочиеВычеты.Количество() = 1 Тогда
			ДатаНачала 		= Месяц;
			ДатаОкончания 	= КонецМесяца(ДатаНачала);
		Иначе
			ДатаОкончанияПредыдущего = ПрочиеВычеты[ПрочиеВычеты.Количество() - 2].ДействуетПо;
			Если ЗначениеЗаполнено(ДатаОкончанияПредыдущего) Тогда
				ДатаНачала 		= НачалоДня(КонецДня(ДатаОкончанияПредыдущего) + 1);
				ДатаОкончания 	= КонецМесяца(ДатаНачала);
			КонецЕсли;
		КонецЕсли;
		
		ТекущиеДанные.ДействуетС  = ДатаНачала;
		ТекущиеДанные.ДействуетПо = ДатаОкончания;
		ТекущиеДанные.НомерСтроки = ПрочиеВычеты.Количество();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПрочиеВычетыДействуетПоПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.ПрочиеВычеты.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ТекущиеДанные.ДействуетПо) Тогда
		ТекущиеДанные.ДействуетПо = КонецМесяца(ТекущиеДанные.ДействуетПо);
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура ПрочиеВычетыДействуетСПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.ПрочиеВычеты.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ТекущиеДанные.ДействуетС) Тогда
		ТекущиеДанные.ДействуетС = НачалоМесяца(ТекущиеДанные.ДействуетС);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПрочиеВычетыПослеУдаления(Элемент)
	ПересчитатьНомераСтрок();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПолучитьПараметры()
	
	Параметры.Свойство("ВидВычетаИПН",		ВидВычетаИПН);
	Параметры.Свойство("Месяц",				Месяц);
	Параметры.Свойство("МесяцЗавершения",	МесяцЗавершения);
	ПрочиеВычеты.Загрузить(ПолучитьИзВременногоХранилища(Параметры.АдресВХранилищеПрочиеВычеты));
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьИЗакрыть(Результат = Неопределено, ДополнительныеПараметры = Неопределено) Экспорт
	
	Если ПроверитьЗаполнение() Тогда
		
		РезультатыРедактирования = Новый Структура;
		РезультатыРедактирования.Вставить("Модифицированность", Модифицированность);
		РезультатыРедактирования.Вставить("ВидВычетаИПН",       ВидВычетаИПН);
		РезультатыРедактирования.Вставить("АдресВХранилищеПрочиеВычеты", АдресВХранилищеПрочиеВычеты());
		
		Модифицированность = Ложь;
		Закрыть(РезультатыРедактирования)
		
	КонецЕсли
	
КонецПроцедуры

&НаСервере
Функция АдресВХранилищеПрочиеВычеты()
	
	ТЗПрочиеВычеты = ПрочиеВычеты.Выгрузить(,"ВидВычетаИПН,Размер,ДействуетПо,ДействуетС");
	ТЗПрочиеВычеты.ЗаполнитьЗначения(ВидВычетаИПН, "ВидВычетаИПН");
	
	Возврат ПоместитьВоВременноеХранилище(ТЗПрочиеВычеты, УникальныйИдентификатор);
	
КонецФункции

&НаСервере
Процедура ПересчитатьНомераСтрок()
	
	НомерСтроки = 1;
	Для каждого Строка Из ПрочиеВычеты Цикл
		Строка.НомерСтроки = НомерСтроки;
		НомерСтроки = НомерСтроки + 1;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ПроверитьПересечениеПериодов(Отказ)
	
	Ошибки = Неопределено;
	Запрос = Новый Запрос;
	
	Запрос.УстановитьПараметр("ПрочиеВычеты",ПрочиеВычеты.Выгрузить());
	Запрос.Текст = "ВЫБРАТЬ
	               |	Таблица.ДействуетС,
	               |	Таблица.ДействуетПо,
	               |	Таблица.НомерСтроки
	               |ПОМЕСТИТЬ ВТ_Таблица
	               |ИЗ
	               |	&ПрочиеВычеты КАК Таблица
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	Периоды.НомерСтроки,
	               |	ПериодыСравнения.НомерСтроки КАК НомерСтрокиПересечения
	               |ИЗ
	               |	ВТ_Таблица КАК Периоды
	               |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТ_Таблица КАК ПериодыСравнения
	               |		ПО Периоды.ДействуетС <= ПериодыСравнения.ДействуетПо
	               |			И Периоды.ДействуетПо >= ПериодыСравнения.ДействуетС
	               |			И Периоды.НомерСтроки <> ПериодыСравнения.НомерСтроки";
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	Пока Выборка.Следующий() Цикл
		
		ТекстСообщения = НСтр("ru='Период действия строки %1 графика пересекается с периодом строки: %2.'");
		ТекстСообщения = СтрЗаменить(ТекстСообщения,"%1", Выборка.НомерСтроки);
		ТекстСообщения = СтрЗаменить(ТекстСообщения,"%2", Выборка.НомерСтрокиПересечения);
		
		ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(
			Ошибки, "ПрочиеВычеты[%1].ДействуетС", ТекстСообщения,"",Выборка.НомерСтроки - 1);

		
	КонецЦикла;
	
	ОбщегоНазначенияКлиентСервер.СообщитьОшибкиПользователю(Ошибки, Отказ);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ПроверитьСтрокуТЧ(Месяц, МесяцЗавершения, ДатаНачала, ДатаОкончания, НомерСтроки, Размер, Ошибки)
	
	Если Не ЗначениеЗаполнено(ДатаНачала) Тогда
		ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(
			Ошибки,
			"ПрочиеВычеты[%1].ДействуетС",
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru='В строке %1 графика вычета период начала действия не может быть пустым.'"),НомерСтроки),
			"",
			НомерСтроки - 1);
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ДатаОкончания) Тогда
		ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(
			Ошибки,
			"ПрочиеВычеты[%1].ДействуетПо",
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru='В строке %1 графика вычета период окончания действия вычета не может быть пустым.'"),НомерСтроки),
			"",
			НомерСтроки - 1);
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Размер) Тогда
		ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(
			Ошибки,
			"ПрочиеВычеты[%1].Размер",
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru='В строке %1 графика вычета не заполнен размер вычета.'"),НомерСтроки),
			"",
			НомерСтроки - 1);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ДатаНачала) И ЗначениеЗаполнено(ДатаОкончания) И ДатаНачала > ДатаОкончания Тогда
		ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(
			Ошибки,
			"ПрочиеВычеты[%1].ДействуетС",
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru='В строке %1 графика вычета период начала действия вычета превышает дату окончания.'"),НомерСтроки),
			"",
			НомерСтроки - 1);
	КонецЕсли;
	            
	Если ЗначениеЗаполнено(Месяц) И ДатаНачала < Месяц Тогда
		ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(
			Ошибки,
			"ПрочиеВычеты[%1].ДействуетС",
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru='В строке %1 графика вычета период начала действия вычета меньше даты начала действия заявления.'"), НомерСтроки),
			"",
			НомерСтроки - 1);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(МесяцЗавершения) И ДатаОкончания > МесяцЗавершения Тогда
		ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(
			Ошибки,
			"ПрочиеВычеты[%1].ДействуетПо",
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru='В строке %1 графика вычета период окончания действия вычета превышает дату окончания действия заявления.'"),НомерСтроки),
			"",
			НомерСтроки - 1);;
	КонецЕсли;
		
КонецПроцедуры

#КонецОбласти
