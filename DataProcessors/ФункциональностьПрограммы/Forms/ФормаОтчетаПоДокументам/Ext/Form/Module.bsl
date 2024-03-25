﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	Если Параметры.Свойство("ЗаголовокФормы") Тогда
		Заголовок = Параметры.ЗаголовокФормы;
	КонецЕсли;
	
	// Формируем отчет однократно при открытии и больше не трогаем. 
	// В передаваемых параметрах формы обязательно должны быть:
	// - ИмяМетода - имя процедуры, формирующей отчет
	// - НаименованиеФоновогоЗадания - отображаемое имя фонового задания	
	// Опционально в параметрах могут быть (также используются как ключ уникальности):
	// - ИмяОпции
	// - Организация
	// - Период

	// Описание длительной операции следует передать в клиентский обработчик.
	// Для этого форма содержит реквизит ДлительнаяОперацияПриОткрытии.
	
	// Перекладываем данные из Параметры в структуру ПараметрыВыполненияОтчета,
	// т.к. тип значения Параметры (ДанныеФормыСтруктура) не позволяет передать ее в фоновую процедуру 
	ПараметрыВыполненияОтчета = Новый Структура;
	
	ПараметрыВыполненияОтчета.Вставить("ИмяМетода", 	Параметры.ИмяМетода);
	ПараметрыВыполненияОтчета.Вставить("НаименованиеФоновогоЗадания", 
														Параметры.НаименованиеФоновогоЗадания);
	ПараметрыВыполненияОтчета.Вставить("Организация", 	Параметры.Организация);
	ПараметрыВыполненияОтчета.Вставить("Период", 		Параметры.Период);
	
	Если ЗначениеЗаполнено(Параметры.ИмяОпции) Тогда
		ПараметрыВыполненияОтчета.Вставить(Параметры.ИмяОпции);
	КонецЕсли;	
	
	ДлительнаяОперацияПриОткрытии = НачатьФормированиеОтчета(ПараметрыВыполненияОтчета);

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	НачатьОжиданиеФормированияОтчета();
КонецПроцедуры

&НаКлиенте
Процедура РезультатОбработкаРасшифровки(Элемент, Расшифровка, СтандартнаяОбработка)
	
	Если ТипЗнч(Расшифровка) = Тип("СправочникСсылка.Контрагенты") Тогда
		СтандартнаяОбработка = Ложь;
		СтруктураПараметров = Новый Структура;
		СтруктураПараметров.Вставить("Владелец", Расшифровка);
		СтруктураПараметров.Вставить("Организация", ПредопределенноеЗначение("Справочник.Организации.ПустаяСсылка"));
		ОткрытьФорму("Справочник.ДоговорыКонтрагентов.ФормаСписка", Новый Структура("Отбор", СтруктураПараметров), ЭтотОбъект);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ДлительныеОперации

// Актуальная версия API подсистемы ДлительныеОперации.

&НаСервере
Функция НачатьФормированиеОтчета(ПараметрыВыполненияОтчета) Экспорт
			
	ПараметрыФоновогоВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
	ПараметрыФоновогоВыполнения.НаименованиеФоновогоЗадания =
		ПараметрыВыполненияОтчета.НаименованиеФоновогоЗадания;

	// Для повышения отзывчивости формы сначала позволим форме отрисоваться,
	// а затем повторно обратимся на сервер за результатом отчета.
	// Суммарное время между командой и возможностью работы с отчетом будет больше,
	// но время между командой и какой-то визуальной реакцией на нее - меньше.
	ПараметрыФоновогоВыполнения.ОжидатьЗавершение = 0;

	ПараметрыФоновогоВыполнения.КлючФоновогоЗадания = 
		ПараметрыВыполненияОтчета.ИмяМетода + УникальныйИдентификатор;
				
	РезультатЗапуска = ДлительныеОперации.ВыполнитьВФоне(
		ПараметрыВыполненияОтчета.ИмяМетода,
		ПараметрыВыполненияОтчета,
		ПараметрыФоновогоВыполнения);
		
	Если РезультатЗапуска.Статус = "Выполняется" Тогда
		// Будем ждать кота на клиенте.
		// При открытии будет вызвана НачатьОжиданиеФормированияОтчета().
		Возврат РезультатЗапуска;
	ИначеЕсли Не ПроверитьЗавершениеФормированияОтчета(ЭтотОбъект, РезультатЗапуска) Тогда
		// По каким-то причинам показывать нечего.
		Возврат Неопределено;
	Иначе
		ЗавершитьФормированиеОтчетаСервер(РезультатЗапуска.АдресРезультата);
		Возврат Неопределено; // Не надо ждать, все готово.
	КонецЕсли;
	
КонецФункции

&НаКлиенте
// Начинает ожидание формирования отчета.
//
Процедура НачатьОжиданиеФормированияОтчета() Экспорт
	
	Если ДлительнаяОперацияПриОткрытии = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(ЭтотОбъект);
	
	ПараметрыОжидания.ВыводитьОкноОжидания = Ложь;
	ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "ФормированиеОтчета");
	
	ОповещениеОЗавершении = Новый ОписаниеОповещения(
		"ЗакончитьОжиданиеФормированияОтчета",
		ЭтотОбъект,
		Новый ОписаниеОповещения("ЗавершитьФормированиеОтчета", ЭтотОбъект));
		
	ДлительныеОперацииКлиент.ОжидатьЗавершение(ДлительнаяОперацияПриОткрытии, ОповещениеОЗавершении, ПараметрыОжидания);
	
	// См. далее ЗакончитьОжиданиеФормированияОтчета()
	
КонецПроцедуры

&НаКлиенте
Процедура ЗакончитьОжиданиеФормированияОтчета(РезультатОжидания, ОповещениеЗавершитьФормированиеОтчета) Экспорт // обработчик оповещения
		
	Если Не ПроверитьЗавершениеФормированияОтчета(ЭтотОбъект, РезультатОжидания) Тогда
		// по каким-то причинам показывать нечего; это обработано на клиенте
		Возврат;
	КонецЕсли;
	
	// Для оптимизации клиент-серверного взаимодействия, если есть данные для отображения,
	// то действия с ними выполняем в контекстном серверном вызове.
	// Обработчик оповещения передает управление на сервер - см. ЗавершитьФормированиеОтчетаСервер().
	ВыполнитьОбработкуОповещения(ОповещениеЗавершитьФормированиеОтчета, РезультатОжидания.АдресРезультата);
	
	// См. далее ЗавершитьФормированиеОтчета().
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
// РезультатЗапуска - см. ДлительныеОперации.ВыполнитьВФоне()
//
Функция ПроверитьЗавершениеФормированияОтчета(Форма, РезультатЗапуска)
	
	Если РезультатЗапуска = Неопределено Тогда
		// Пользователь устал ждать
		Возврат Ложь;
	КонецЕсли;
		
	Если РезультатЗапуска.Статус = "Выполнено" Тогда
		
		// Все действия выполним на сервере для оптимизации клиент-серверного взаимодействия.
		// Будет выполнена ЗавершитьФормированиеОтчетаСервер().
		
		Возврат Истина;
		
	КонецЕсли;
		
	Если РезультатЗапуска.Статус = "Ошибка" Тогда
		
		ОтобразитьОшибкуФормированияОтчета(Форма.Элементы.Результат, РезультатЗапуска.КраткоеПредставлениеОшибки);
		
	ИначеЕсли РезультатЗапуска.Статус = "Отменено" Тогда
		
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Форма.Элементы.Результат, "Неактуальность");
		
	КонецЕсли;
	
	Возврат Ложь;
	
КонецФункции

&НаКлиенте
// Обработчик оповещения, вызывается по окончании формирования отчета для контекстной передачи управления на сервер
Процедура ЗавершитьФормированиеОтчета(АдресРезультата, НеиспользуемыйПараметр) Экспорт // обработчик оповещения
	
	ЗавершитьФормированиеОтчетаСервер(АдресРезультата);
	
КонецПроцедуры

&НаСервере
Процедура ЗавершитьФормированиеОтчетаСервер(Знач АдресРезультата)
	
	РезультатВыполнения = ПолучитьИзВременногоХранилища(АдресРезультата);
	Результат         = РезультатВыполнения.Результат;
		
	ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеИспользовать");
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ОтобразитьОшибкуФормированияОтчета(ПолеРезультат, ОписаниеОшибки)
	
	Если ПустаяСтрока(ОписаниеОшибки) Тогда
		Возврат;
	КонецЕсли;
	
	ШаблонИнформации = НСтр("ru = 'Ошибка при формировании отчета:
                             |%1
							 |Детальная информация записана в журнал регистрации.'");
	
	ИнформацияДляПользователя = СтрШаблон(ШаблонИнформации, ОписаниеОшибки);
	
	ОтображениеСостояния = ПолеРезультат.ОтображениеСостояния;
	ОтображениеСостояния.Видимость                      = Истина;
	ОтображениеСостояния.ДополнительныйРежимОтображения = ДополнительныйРежимОтображения.Неактуальность;
	ОтображениеСостояния.Картинка                       = Новый Картинка;
	ОтображениеСостояния.Текст                          = ОписаниеОшибки;
	
КонецПроцедуры

#КонецОбласти
