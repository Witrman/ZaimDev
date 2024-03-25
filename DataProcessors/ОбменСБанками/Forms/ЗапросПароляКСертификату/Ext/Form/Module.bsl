﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Заголовок = Параметры.ВидОперации;
	
	Если Параметры.ВидОперации = НСтр("ru = 'Подписание электронного документа'")
		ИЛИ Параметры.ВидОперации = НСтр("ru = 'Подписание электронных документов'") Тогда
		Элементы.Выбрать.Заголовок = НСтр("ru = 'Подписать'");
	КонецЕсли;
	
	
	Если ТипЗнч(Параметры.МассивСертификатов) = Тип("Массив") И Параметры.МассивСертификатов.Количество() > 0 Тогда
		Для Каждого Элемент Из Параметры.МассивСертификатов Цикл
			Элементы.ВыбранныйСертификат.СписокВыбора.Добавить(Элемент);
		КонецЦикла;
		Если Параметры.МассивСертификатов.Количество() > 1 Тогда
			Элементы.ВыбранныйСертификат.РежимВыбораИзСписка = Истина;
		Иначе
			ВыбранныйСертификат = Элемент;
		КонецЕсли;
	Иначе
		Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаВводЛогинаИПароля;
		НастройкаОбмена = Параметры.НастройкаОбмена;
		Если Не ЗначениеЗаполнено(НастройкаОбмена) Тогда
			Элементы.ГруппаПредставлениеНастройкиDirectBank.Видимость = Ложь;
		КонецЕсли;
		Пользователь = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(НастройкаОбмена, "ИмяПользователя");
		
		УстановитьПривилегированныйРежим(Истина);
		Логины = ХранилищеСистемныхНастроек.Загрузить("ОбменСБанками", "Логины");
		Если Логины <> Неопределено И Логины.Получить(НастройкаОбмена) <> Неопределено Тогда
			Пользователь = Логины.Получить(НастройкаОбмена);
		КонецЕсли;
		ПользовательПоУмолчанию = Пользователь;
	КонецЕсли;
	
	МассивСообщенийОбмена = Новый Массив;
	
	Если ТипЗнч(Параметры.ОбъектыДляОбработки) = Тип("Массив") И Параметры.ОбъектыДляОбработки.Количество() > 0 Тогда
		Если Параметры.ОбъектыДляОбработки.Количество() = 1 Тогда
			СообщениеОбмена = Параметры.ОбъектыДляОбработки[0];
			ШаблонГиперссылки = НСтр("ru = '%1 № %2 от %3'");
			ТекстГиперссылки = Строка(СообщениеОбмена);
			МассивСообщенийОбмена.Добавить(СообщениеОбмена);
		Иначе
			МассивСообщенийОбмена = Параметры.ОбъектыДляОбработки;
			ШаблонГиперссылки = НСтр("ru = 'Электронные документы (%1)'");
			ТекстГиперссылки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонГиперссылки,
				Параметры.ОбъектыДляОбработки.Количество());
		КонецЕсли;
		
		ТекстГиперссылки = ОбщегоНазначенияКлиентСервер.ЗаменитьНедопустимыеСимволыВИмениФайла(ТекстГиперссылки);
		НадписьОбъектыДляОбработки = ТекстГиперссылки;
	КонецЕсли;
	
	МассивСообщенийОбменаСсылка = ПоместитьВоВременноеХранилище(МассивСообщенийОбмена, УникальныйИдентификатор);
	
	КлючСохраненияПоложенияОкна = ?(МассивСообщенийОбмена.Количество() > 0, "СОбъектами", "БезОбъектов");
	
	Если ЗначениеЗаполнено(ВыбранныйСертификат) Тогда
		Элементы.ВыбранныйСертификат.ТолькоПросмотр = Истина;
	КонецЕсли;
	
	Элементы.ОбъектыДляОбработки.Видимость = (МассивСообщенийОбмена.Количество() > 0);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если Элементы.ВыбранныйСертификат.СписокВыбора.Количество() = 1 Тогда
		ОбработкаВыбораСертификата();
	КонецЕсли;
	ОбновитьОтображениеДанных();
	
	Если ЗначениеЗаполнено(Пользователь) Тогда
		ТекущийЭлемент = Элементы.ПарольАвторизации;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ВыбранныйСертификатОткрытие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Ключ", ВыбранныйСертификат);
	ПараметрыФормы.Вставить("ТолькоПросмотр", Истина);
	ОткрытьФорму("Справочник.СертификатыКлючейЭлектроннойПодписиИШифрования.Форма.ФормаЭлемента", ПараметрыФормы, ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбранныйСертификатПриИзменении(Элемент)
	
	ОбработкаВыбораСертификата();
	ОбновитьОтображениеДанных();
	
КонецПроцедуры

&НаКлиенте
Процедура ПарольПользователяОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, СтандартнаяОбработка)
	
	#Если НЕ ВебКлиент Тогда
		ПарольПользователя = Текст;
	#КонецЕсли
	
КонецПроцедуры

&НаКлиенте
Процедура ПарольАвторизацииОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, СтандартнаяОбработка)
	
	#Если НЕ ВебКлиент Тогда
		ПарольПользователя = Текст;
	#КонецЕсли

КонецПроцедуры

&НаКлиенте
Процедура ОбъектыДляОбработкиНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	МассивСообщенийОбмена = ПолучитьИзВременногоХранилища(МассивСообщенийОбменаСсылка);
	
	Если МассивСообщенийОбмена.Количество() > 1 Тогда
		ПараметрыФормы = Новый Структура("МассивСообщенийОбмена", МассивСообщенийОбмена);
		ОткрытьФорму("Обработка.ОбменСБанками.Форма.СписокЭлектронныхДокументов", ПараметрыФормы, ЭтотОбъект);
	Иначе
		ОбменСБанкамиСлужебныйКлиент.ОткрытьЭДДляПросмотра(МассивСообщенийОбмена[0], , ЭтотОбъект, Истина);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗапомнитьПарольЛогинНаВремяСеансаПриИзменении(Элемент)
	
	Если НЕ Элементы.ПарольАвторизации.Доступность Тогда
		Элементы.ПарольАвторизации.Доступность = НЕ ЗапомнитьПарольНаВремяСеанса;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗапомнитьПарольСертификатНаВремяСеансаПриИзменении(Элемент)
	
	Если НЕ Элементы.ПарольПользователя.Доступность Тогда
		Элементы.ПарольПользователя.Доступность = Элементы.ЗапомнитьПарольСертификатНаВремяСеанса.Доступность
			И НЕ ЗапомнитьПарольНаВремяСеанса;
	КонецЕсли;

	
КонецПроцедуры


#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаГотово(Команда)
	
	Отказ = Ложь;
	
	// Блок проверки на заполненность сертификата ЭП.
	Если Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаВводПароляКСертификату
		И Не ЗначениеЗаполнено(ВыбранныйСертификат) Тогда
		ТекстСообщения = ЭлектронноеВзаимодействиеКлиентСервер.ТекстСообщения(
			"Поле", "Заполнение", НСтр("ru = 'Сертификат подписи'"));
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения, , "ВыбранныйСертификат");
		Отказ = Истина;
	ИначеЕсли Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаВводЛогинаИПароля Тогда
		Если ПустаяСтрока(Пользователь) Тогда
			ТекстСообщения = ЭлектронноеВзаимодействиеКлиентСервер.ТекстСообщения(
				"Поле", "Заполнение", НСтр("ru = 'Логин'"));
			ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения, , "Пользователь");
			Отказ = Истина;
		КонецЕсли;
			
		Если Не Отказ И Пользователь <> ПользовательПоУмолчанию Тогда
			СохранитьЛогин(Пользователь, НастройкаОбмена);
		КонецЕсли;
		
	КонецЕсли;
	
	Если Не Отказ Тогда
		ОбработатьПолучениеПароля();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ОбработатьПолучениеПароля()
	
	Если Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаВводПароляКСертификату Тогда
		СохраняемыйКлюч = ВыбранныйСертификат;
		СохраняемоеЗначение = ПарольПользователя;
	Иначе
		СохраняемыйКлюч = НастройкаОбмена;
		ДанныеАвторизации = Новый Структура("Логин, Пароль", Пользователь, ПарольПользователя);
		СохраняемоеЗначение = ДанныеАвторизации;
	КонецЕсли;
	
	Если ЗапомнитьПарольНаВремяСеанса Тогда
		ДобавитьПарольВГлобальнуюПеременную(СохраняемыйКлюч, СохраняемоеЗначение);
	Иначе
		ОбменСБанкамиСлужебныйКлиент.УдалитьПарольИзСеанса(СохраняемыйКлюч);
	КонецЕсли;
	
	Закрыть(ПараметрыВозвратаПароля());
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура СохранитьЛогин(Знач Логин, Знач НастройкаОбмена)

	УстановитьПривилегированныйРежим(Истина);
	Логины = ХранилищеСистемныхНастроек.Загрузить("ОбменСБанками", "Логины");
	Если Логины = Неопределено Тогда
		Логины = Новый Соответствие;
	КонецЕсли;
	Логины.Вставить(НастройкаОбмена, Логин);
	ХранилищеСистемныхНастроек.Сохранить("ОбменСБанками", "Логины", Логины);

КонецПроцедуры

&НаКлиенте
Функция ПараметрыВозвратаПароля()
	
	РезультатВыбора = Новый Структура;
	
	РезультатВыбора.Вставить("ВыбранныйСертификат", ВыбранныйСертификат);
	РезультатВыбора.Вставить("Логин", Пользователь);
	РезультатВыбора.Вставить("Пароль", ПарольПользователя);
	РезультатВыбора.Вставить("ПарольСертификата", ПарольПользователя);
	
	Возврат РезультатВыбора;
	
КонецФункции

&НаКлиенте
Процедура ОбработкаВыбораСертификата()
	
	Если НЕ ЗначениеЗаполнено(ВыбранныйСертификат) Тогда
		Возврат;
	КонецЕсли;
	
	Пароль = Неопределено;
	НаВремяСеанса = Ложь;
	ПарольПолучен = ОбменСБанкамиСлужебныйКлиент.ПарольКСертификатуПолучен(ВыбранныйСертификат, Пароль, НаВремяСеанса);
	ПарольПользователя = Пароль;
	ЗапомнитьПарольНаВремяСеанса = НаВремяСеанса;
	Элементы.ЗапомнитьПарольСертификатНаВремяСеанса.Доступность = НаВремяСеанса ИЛИ НЕ ПарольПолучен;
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьПарольВГлобальнуюПеременную(СертификатЭП, ПарольПользователя)
	
	Соответствие = Новый Соответствие;
	СоответствиеСертификатаИПароля = ПараметрыПриложения["ЭлектронноеВзаимодействие.ОбменСБанками.ПаролиСеанса"];
	Если ТипЗнч(СоответствиеСертификатаИПароля) = Тип("ФиксированноеСоответствие") Тогда
		Для Каждого Элемент Из СоответствиеСертификатаИПароля Цикл
			Соответствие.Вставить(Элемент.Ключ, Элемент.Значение);
		КонецЦикла;
	КонецЕсли;
	
	Соответствие.Вставить(СертификатЭП, ПарольПользователя);
	
	ПараметрыПриложения.Вставить("ЭлектронноеВзаимодействие.ОбменСБанками.ПаролиСеанса",
		Новый ФиксированноеСоответствие(Соответствие));
	
КонецПроцедуры

#КонецОбласти
