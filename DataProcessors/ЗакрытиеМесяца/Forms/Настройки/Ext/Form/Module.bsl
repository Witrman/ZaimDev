﻿////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Данная форма открывалась методом глобального контекста ОткрытьФорму().
	// Такое открытие приводит к тому, что переменная Объект у данной формы и у владельца отличается.
	// Поэтому в данной форме выполняется повторная инициализация требуемых свойств переменной Объект.
	Объект.ПериодРегистрации = Параметры.ПериодРегистрации;
	ТабЗначКурсыВалют = ПолучитьИзВременногоХранилища(Параметры.АдресТаблицыЗначенийКурсыВалют);
	Объект.КурсыВалют.Загрузить(ТабЗначКурсыВалют);
	
	Переоценка_УстановитьВариант(ЭтаФорма);	
	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если Переоценка_Вариант = Переоценка_Вручную() И Объект.КурсыВалют.Количество() = 0 Тогда
		ТекстСообщения = НСтр("ru = 'Укажите курсы валют или установите переключатель в положение: Использовать текущие курсы регистра ""Курсы валют""'");
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения, , , "Объект.КурсыВалют");
		Отказ = Истина;	
	КонецЕсли;

КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

&НаКлиенте
Процедура Переоценка_ВариантПриИзменении(Элемент)
	
	// Изменение внешнего вида формы, если потребуется его переопределить, то код ниже это сделатет.
	УправлениеФормой(ЭтаФорма);
	
	// Если происходит изменение с ручного варианта на автоматический.
	Если Переоценка_Вариант = Переоценка_Автоматически() Тогда
		
		Если Объект.КурсыВалют.Количество() <> 0 Тогда
			
			Оповещение = Новый ОписаниеОповещения("Переоценка_ВариантПриИзменении_ОтветНаВопрос", ЭтаФорма);
			
			ТекстВопроса = НСтр("ru = 'Курсы валют будут очищены.
			|Продолжить?'");
			
			ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ДаНет, , КодВозвратаДиалога.Да); 
				
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Переоценка_ВариантПриИзменении_ОтветНаВопрос(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		Объект.КурсыВалют.Очистить();
	Иначе
		// Вернуть вариант, который был: "Вручную".
		Переоценка_Вариант = Переоценка_Вручную();	
	КонецЕсли;
	
	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура Переоценка_Заполнить(Команда)
	
	
	Оповещение = Новый ОписаниеОповещения("Переоценка_Заполнить_ОтветНаВопрос", ЭтаФорма);
	
	ТекстВопроса = НСтр("ru = 'Перед заполнением табличная часть будет очищена.
	|Заполнить?'");
	
	ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ДаНет, , КодВозвратаДиалога.Да); 
	
КонецПроцедуры

&НаКлиенте
Процедура Переоценка_Заполнить_ОтветНаВопрос(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		ЗаполнитьТекущимиКурсами();	
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОК(Команда)
	
	Результат = Новый Структура;
	Результат.Вставить("АдресТаблицыЗначенийКурсыВалют", АдресТаблицыЗначенийКурсыВалют());
	
	ЭтаФорма.Закрыть(Результат);
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	
	ЭтаФорма.Закрыть(Неопределено);
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма)
	
	Если Форма.Переоценка_Вариант = Переоценка_Автоматически() Тогда
		
		Форма.Элементы.КурсыВалют.Доступность = Ложь;
		
	Иначе // Переоценка_Вариант = Переоценка_Вручную 
		
		Форма.Элементы.КурсыВалют.Доступность = Истина;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура Переоценка_УстановитьВариант(Форма)
	
	Если Форма.Объект.КурсыВалют.Количество() = 0 Тогда
		Форма.Переоценка_Вариант = Переоценка_Автоматически();
	Иначе
		Форма.Переоценка_Вариант = Переоценка_Вручную();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция Переоценка_Автоматически()
	Возврат "Автоматически";	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция Переоценка_Вручную()
	Возврат "Вручную";	
КонецФункции

&НаСервере
Процедура ЗаполнитьТекущимиКурсами()
	
	Объект.КурсыВалют.Очистить();
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Дата", КонецМесяца(Объект.ПериодРегистрации));
	Запрос.УстановитьПараметр("ВалютаРегламентированногоУчета", Константы.ВалютаРегламентированногоУчета.Получить());
	
	Запрос.Текст =  
	"ВЫБРАТЬ
	|	Валюты.Ссылка КАК Валюта
	|ПОМЕСТИТЬ ВТ_Валюты
	|ИЗ
	|	Справочник.Валюты КАК Валюты
	|ГДЕ
	|	НЕ Валюты.ПометкаУдаления
	|	И Валюты.Ссылка <> &ВалютаРегламентированногоУчета
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	КурсыВалютСрезПоследних.Валюта,
	|	КурсыВалютСрезПоследних.Курс,
	|	КурсыВалютСрезПоследних.Кратность
	|ИЗ
	|	РегистрСведений.КурсыВалют.СрезПоследних(
	|			&Дата,
	|			Валюта В
	|				(ВЫБРАТЬ
	|					ВТ_Валюты.Валюта
	|				ИЗ
	|					ВТ_Валюты КАК ВТ_Валюты)) КАК КурсыВалютСрезПоследних";
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		СтрокаКурсыВалют = Объект.КурсыВалют.Добавить();
		ЗаполнитьЗначенияСвойств(СтрокаКурсыВалют, Выборка);
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Функция НоваяТаблицаЗначенийКурсыВалют()
	
	ОбработкаОбъект = РеквизитФормыВЗначение("Объект");
	ТаблицаЗначенийКурсыВалют = ОбработкаОбъект.КурсыВалют.Выгрузить(, "Валюта,Курс,Кратность");
	
	Возврат ТаблицаЗначенийКурсыВалют;
	
КонецФункции 

&НаСервере
Функция АдресТаблицыЗначенийКурсыВалют()
	
	ТабЗначКурсыВалют = НоваяТаблицаЗначенийКурсыВалют();
	Адрес = ПоместитьВоВременноеХранилище(ТабЗначКурсыВалют, ЭтаФорма.УникальныйИдентификатор);
	
	Возврат Адрес;
	
КонецФункции