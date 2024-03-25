﻿
#Область ПрограммныйИнтерфейс

////////////////////////////////////////////////////////////////////////////////
// Информационные ссылки

// Выводит информационные ссылки на форме
//
// Параметры:
//	Форма - ФормаКлиентскогоПриложения - контекст формы.
//	ГруппаФормы - ГруппаФормы - группа формы, в которой выводятся информационные ссылки.
//	КоличествоГрупп - Число - количество групп информационных ссылок в форме.
//	КоличествоСсылокВГруппе - Число - количество информационных ссылок в группе.
//	ВыводитьСсылкуВсе - Булево - выводить или нет ссылку "Все".
//	ПутьКФорме - Строка - полный путь к форме.
//
Процедура ВывестиКонтекстныеСсылки(Форма, ГруппаФормы, КоличествоГрупп = 3, КоличествоСсылокВГруппе = 1, 
	ВыводитьСсылкуВсе = Истина, ПутьКФорме = "") Экспорт
	
	Попытка
		
		Если ПустаяСтрока(ПутьКФорме) Тогда 
			ПутьКФорме = Форма.ИмяФормы;
		КонецЕсли;
		
		ХешПутиКФорме = ХешПолногоПутиКФорме(ПутьКФорме);
		
		ТаблицаСсылокФормы = ИнформационныйЦентрСерверПовтИсп.ИнформационныеСсылки(ХешПутиКФорме);
		Если ТаблицаСсылокФормы.Количество() = 0 Тогда 
			Возврат;
		КонецЕсли;
		
		// Изменение параметров формы
		ГруппаФормы.ОтображатьЗаголовок = Ложь;
		ГруппаФормы.Подсказка   = "";
		ГруппаФормы.Отображение = ОтображениеОбычнойГруппы.Нет;
		ГруппаФормы.Группировка = ГруппировкаПодчиненныхЭлементовФормы.Горизонтальная;
		
		// Добавление списка Информационных ссылок
		ИмяРеквизита = "ИнформационныеСсылки";
		ДобавляемыеРеквизиты = Новый Массив;
		ДобавляемыеРеквизиты.Добавить(Новый РеквизитФормы(ИмяРеквизита, Новый ОписаниеТипов("СписокЗначений")));
		Форма.ИзменитьРеквизиты(ДобавляемыеРеквизиты);
		
		СформироватьГруппыВывода(
			Форма, ТаблицаСсылокФормы, ГруппаФормы, КоличествоГрупп, КоличествоСсылокВГруппе, ВыводитьСсылкуВсе);
		
	Исключение
		
		ИмяСобытия = ПолучитьИмяСобытияДляЖурналаРегистрации();
		ЗаписьЖурналаРегистрации(ИмяСобытия, УровеньЖурналаРегистрации.Ошибка,,,
			ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		
	КонецПопытки;	
		
КонецПроцедуры

// Заполняет элементы формы информационными ссылками.
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - форма.
//  МассивЭлементов - Массив Из ПолеФормы - массив элементов формы.
//  ЭлементВсеСсылки - ДекорацияФормы - элемент формы.
//  ПутьКФорме - Строка - путь к форме.
//
Процедура ЗаполнитьСтатическиеИнформационныеСсылки(Форма, МассивЭлементов, ЭлементВсеСсылки = Неопределено, 
	ПутьКФорме = "") Экспорт
	
	Попытка
		
		Если ПустаяСтрока(ПутьКФорме) Тогда 
			ПутьКФорме = Форма.ИмяФормы;
		КонецЕсли;
		
		ХешПутиКФорме = ХешПолногоПутиКФорме(ПутьКФорме);
		
		ТаблицаСсылок = ИнформационныйЦентрСерверПовтИсп.ИнформационныеСсылки(ХешПутиКФорме);
		Если ТаблицаСсылок.Количество() = 0 Тогда 
			Возврат;
		КонецЕсли;
		
		ЗаполнитьИнформационныеСсылки(Форма, МассивЭлементов, ТаблицаСсылок, ЭлементВсеСсылки);
		
		//@skip-warning СтроковыйЛитералСодержитОшибку - ошибка проверки
		Если ТипЗнч(ЭлементВсеСсылки) = Тип("ДекорацияТекстФормы") Тогда
			ОтображатьСсылку = ТаблицаСсылок.Количество() <= МассивЭлементов.Количество();
			ЭлементВсеСсылки.Видимость = ОтображатьСсылку;
		КонецЕсли;
		
		
	Исключение
		
		ИмяСобытия = ПолучитьИмяСобытияДляЖурналаРегистрации();
		ЗаписьЖурналаРегистрации(ИмяСобытия, УровеньЖурналаРегистрации.Ошибка,,, 
			ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
			
	КонецПопытки;	
	
КонецПроцедуры

// Возвращает информационную ссылку по идентификатору.
//
// Параметры:
//	Идентификатор - Строка - идентификатор ссылки.
//
// Возвращаемое значение:
//	Структура - контекстная ссылка:
//	* Адрес - Строка
//	* Наименование - Строка
//
Функция КонтекстнаяСсылкаПоИдентификатору(Идентификатор) Экспорт
	
	ВозвращаемаяСтруктура = Новый Структура;
	ВозвращаемаяСтруктура.Вставить("Адрес", "");
	ВозвращаемаяСтруктура.Вставить("Наименование", "");
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ИнформационныеСсылкиДляФорм.Адрес КАК Адрес,
	|	ИнформационныеСсылкиДляФорм.Наименование КАК Наименование
	|ИЗ
	|	Справочник.ИнформационныеСсылкиДляФорм КАК ИнформационныеСсылкиДляФорм
	|ГДЕ
	|	ИнформационныеСсылкиДляФорм.Идентификатор = &ID
	|	И НЕ ИнформационныеСсылкиДляФорм.ПометкаУдаления";
	
	Запрос.УстановитьПараметр("ID", Идентификатор);
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		
		ВозвращаемаяСтруктура.Адрес = Выборка.Адрес;
		ВозвращаемаяСтруктура.Наименование = Выборка.Наименование;
		Прервать;
		
	КонецЦикла;
	
	Возврат ВозвращаемаяСтруктура;
	
КонецФункции

// Возвращает все пространства имен информационных ссылок.
//
// Возвращаемое значение:
//  Массив из Строка - массив пространства имен информационных ссылок.
//
Функция ПространстваИменИнформационныхСсылок() Экспорт
	
	МассивПространств = Новый Массив;
	МассивПространств.Добавить(ПространствоИменИнформационныхСсылок());
	МассивПространств.Добавить(ПространствоИменИнформационныхСсылок_1_0_1_1());
	
	Возврат МассивПространств;	
	
КонецФункции

// Формирует список новостей.
// @skip-warning ПустойМетод - особенность реализации.
//
// Параметры:
//	ТаблицаНовостей - ТаблицаЗначений - с колонками:
//	 * Наименование - Строка - заголовок новости.
//	 * Идентификатор - УникальныйИдентификатор - идентификатор новости.
//	 * Критичность - Число - критичность новости.
//	 * ВнешняяСсылка - Строка - адрес внешней ссылки.
//	КоличествоВыводимыхНовостей - Число - количество выводимых новостей на рабочем столе.
//
Процедура СформироватьСписокНовостейНаРабочийСтол(ТаблицаНовостей, Знач КоличествоВыводимыхНовостей = 3) Экспорт
	
КонецПроцедуры

// Возвращает Истину, если установлена интеграция со службой поддержки.
// @skip-warning ПустойМетод - особенность реализации.
// 
// Возвращаемое значение:
//	Булево - Истина, если установлена интеграция со службой поддержки.
Функция УстановленаИнтеграцияСоСлужбойПоддержки() Экспорт
	
	Возврат ПодтвержденКодДляИнтеграцииСУСП();
		
КонецФункции

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Возвращает список макетов для информационных ссылок.
//
// Возвращаемое значение:
//  Массив Из ТекстовыйДокумент - массив общих макетов.
//
Функция ПолучитьОбщиеМакетыИнформационныхСсылок() Экспорт
	
	МассивМакетов = Новый Массив;
	МассивМакетов.Добавить(ПолучитьОбщийМакет("ИнформационныеСсылки_Общие"));
	
	ИнформационныйЦентрСерверПереопределяемый.ОбщиеМакетыСИнформационнымиСсылками(МассивМакетов);
	
	Возврат МассивМакетов;
	
КонецФункции

// Формирует хеш полного пути к форме при записи.
//
Процедура ПолныйПутьКФормеПередЗаписьюПередЗаписью(Источник, Отказ) Экспорт
	
	Если Источник.ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ПустаяСтрока(Источник.ПолныйПутьКФорме) Тогда 
		Источник.Хеш = ХешПолногоПутиКФорме(Источник.ПолныйПутьКФорме);
	КонецЕсли;
	
КонецПроцедуры

// Возвращает хеш полного пути к форме по алгоритму.
//
// Параметры:
//	ПолныйПутьКФорме - Строка - полный путь к форме.
//
// Возвращаемое значение:
//	Строка - хэш.
//
Функция ХешПолногоПутиКФорме(Знач ПолныйПутьКФорме) Экспорт
	
	ХешированиеДанных = Новый ХешированиеДанных(ХешФункция.MD5);
	ХешированиеДанных.Добавить(ПолныйПутьКФорме);
	Возврат СтрЗаменить(ХешированиеДанных.ХешСумма, " ", "");
	
КонецФункции

// Возвращает имя события журнала регистрации.
//
// Возвращаемое значение:
//	Строка - имя события журнала регистрации.
//
Функция ПолучитьИмяСобытияДляЖурналаРегистрации() Экспорт
	
	Возврат НСтр("ru = 'Информационный центр'", ОбщегоНазначения.КодОсновногоЯзыка());
	
КонецФункции

// Процедура регламентного задания ЧтениеНовостейСлужбыПоддержки
// @skip-warning ПустойМетод - особенность реализации.
//
Процедура ЧтениеНовостейСлужбыПоддержки() Экспорт

КонецПроцедуры

// Возвращает Прокси Информационного центра Менеджера сервиса.
// Вызывающий код должен самостоятельно устанавливать привилегированный режим.
// @skip-warning ПустойМетод - особенность реализации.
//
// Возвращаемое значение:
//	WSПрокси - прокси Информационного центра.
//
Функция ПолучитьПроксиИнформационногоЦентра_1_0_1_1() Экспорт
	
КонецФункции

// Адрес web-сервиса InformationCenterIntegrationProtected службы поддержки
// 
// Возвращаемое значение:
//  Строка - адрес
//
Функция АдресАнонимногоСервисаИнтеграцииСИнформационнымЦентромУСП()
	
	УстановитьПривилегированныйРежим(Истина);
	Владелец = ОбщегоНазначения.ИдентификаторОбъектаМетаданных("Обработка.ИнформационныйЦентр");
	Адрес = ОбщегоНазначения.ПрочитатьДанныеИзБезопасногоХранилища(
		Владелец, "АдресАнонимногоСервисаИнтеграцииСИнформационнымЦентромУСП");
	УстановитьПривилегированныйРежим(Ложь);
	
	Если Адрес = Неопределено Тогда
		Возврат "";
	КонецЕсли;
	
	Возврат Адрес;
	
КонецФункции

// Адрес http-сервиса ВнешнийАнонимныйИнтерфейс (ext_sd) службы поддержки
// 
// Возвращаемое значение:
//  Строка - адрес 
//
Функция АдресВнешнегоАнонимногоИнтерфейсаУСП() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	Владелец = ОбщегоНазначения.ИдентификаторОбъектаМетаданных("Обработка.ИнформационныйЦентр");
	АдресВнешнегоАнонимногоИнтерфейсаУСП = ОбщегоНазначения.ПрочитатьДанныеИзБезопасногоХранилища(
		Владелец, "АдресВнешнегоАнонимногоИнтерфейсаУСП");
	УстановитьПривилегированныйРежим(Ложь);
	
	Если АдресВнешнегоАнонимногоИнтерфейсаУСП = Неопределено Тогда
		Возврат "";
	КонецЕсли;
	
	Возврат АдресВнешнегоАнонимногоИнтерфейсаУСП;
	
КонецФункции

// E-mail пользователя, от имени которого локальной база подключена к службе поддержки
// 
// Возвращаемое значение:
//  Строка - e-mail
//
Функция АдресПочтыАбонентаДляИнтеграцииСУСП() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	Владелец = ОбщегоНазначения.ИдентификаторОбъектаМетаданных("Обработка.ИнформационныйЦентр");
	АдресПочтыАбонентаДляИнтеграцииСУСП = ОбщегоНазначения.ПрочитатьДанныеИзБезопасногоХранилища(
		Владелец, "АдресПочтыАбонентаДляИнтеграцииСУСП");
	УстановитьПривилегированныйРежим(Ложь);
	
	Если АдресПочтыАбонентаДляИнтеграцииСУСП = Неопределено Тогда
		Возврат "";
	КонецЕсли;
	
	Возврат АдресПочтыАбонентаДляИнтеграцииСУСП;
	
КонецФункции

// Информация о подключении локальной базы к службе поддержки
// 
// Возвращаемое значение:
//  Структура - содержит поля:
//  	* АдресВнешнегоАнонимногоИнтерфейсаУСП - Строка - адрес http-сервиса ext_sd службы поддержки
//  	* АдресАнонимногоСервисаИнтеграцииСИнформационнымЦентромУСП - Строка - адрес web-сервиса службы поддержки
//  	* ПодтвержденКодДляИнтеграцииСУСП - Булево - если Истина, то база подключена к службе поддержки
//  	* АдресПочтыАбонентаДляИнтеграцииСУСП - Строка - E-mail пользователя, 
//			от имени которого локальной база подключена к службе поддержки
//  	* КодРегистрацииВУСП - Строка - код, при помощи которого база зарегистрирована в службе поддержки
//
Функция ДанныеНастроекИнтеграцииСУСП() Экспорт
	
	Результат = Новый Структура;
	Результат.Вставить("АдресВнешнегоАнонимногоИнтерфейсаУСП", АдресВнешнегоАнонимногоИнтерфейсаУСП());
	Результат.Вставить("АдресАнонимногоСервисаИнтеграцииСИнформационнымЦентромУСП", 
		АдресАнонимногоСервисаИнтеграцииСИнформационнымЦентромУСП());
	Результат.Вставить("ПодтвержденКодДляИнтеграцииСУСП", ПодтвержденКодДляИнтеграцииСУСП());
	Результат.Вставить("АдресПочтыАбонентаДляИнтеграцииСУСП", АдресПочтыАбонентаДляИнтеграцииСУСП());
	Результат.Вставить("КодРегистрацииВУСП", КодРегистрацииВУСП());
	
	Возврат Результат;
	
КонецФункции

// Определяет, введен ли код для регистрации локальной базы в службе поддержки.
// 
// Возвращаемое значение:
//  Булево - Истина, если код введен
//
Функция ПодтвержденКодДляИнтеграцииСУСП() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	Владелец = ОбщегоНазначения.ИдентификаторОбъектаМетаданных("Обработка.ИнформационныйЦентр");
	ПодтвержденКодДляИнтеграцииСУСП = ОбщегоНазначения.ПрочитатьДанныеИзБезопасногоХранилища(
		Владелец, "ПодтвержденКодДляИнтеграцииСУСП");
	УстановитьПривилегированныйРежим(Ложь);
	
	Если ПодтвержденКодДляИнтеграцииСУСП = Неопределено Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Возврат ПодтвержденКодДляИнтеграцииСУСП;
	
КонецФункции

// Код, при помощи которого база зарегистрирована в службе поддержки
// 
// Возвращаемое значение:
//  Строка - код
//
Функция КодРегистрацииВУСП() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	Владелец = ОбщегоНазначения.ИдентификаторОбъектаМетаданных("Обработка.ИнформационныйЦентр");
	КодРегистрацииВУСП = ОбщегоНазначения.ПрочитатьДанныеИзБезопасногоХранилища(
		Владелец, "КодРегистрацииВУСП");
	УстановитьПривилегированныйРежим(Ложь);
	
	Если КодРегистрацииВУСП = Неопределено Тогда
		Возврат "";
	КонецЕсли;
	
	Возврат КодРегистрацииВУСП;
	
КонецФункции

// Сохраняет данные о подключении локальной базы к службе поддержки.
//
// Параметры:
//  АдресВнешнегоИнтерфейса		 - Строка - адрес http-сервиса ext_sd службы поддержки
//  ПодтвержденКод				 - Булево - если Истина, то база подключена к службе поддержки
//  АдресАбонента				 - Строка - E-mail пользователя, от имени которого локальной база подключена к службе поддержки
//  КодРегистрации				 - Строка - код, при помощи которого база зарегистрирована в службе поддержки
//  АдресИнформационногоЦентра	 - Строка - адрес web-сервиса службы поддержки для работы с обращениями
//
Процедура ЗаписатьДанныеНастроекИнтеграцииСУСП(АдресВнешнегоИнтерфейса, ПодтвержденКод, 
	АдресАбонента, КодРегистрации, АдресИнформационногоЦентра) Экспорт
	
	ЗаписатьАдресВнешнегоАнонимногоИнтерфейсаУСП(АдресВнешнегоИнтерфейса);
	ЗаписатьАдресАнонимногоСервисаИнтеграцииСИнформационнымЦентромУСП(АдресИнформационногоЦентра);
	ЗаписатьПризнакПодтвержденияКодаДляИнтеграцииСУСП(ПодтвержденКод);
	ЗаписатьАдресПочтыАбонентаДляИнтеграцииСУСП(АдресАбонента);
	ЗаписатьКодРегистрацииВУСП(КодРегистрации);
	
КонецПроцедуры

// Сохраняет адрес http-сервиса ext_sd службы поддержки
//
// Параметры:
//  Адрес	 - Строка
//
Процедура ЗаписатьАдресВнешнегоАнонимногоИнтерфейсаУСП(Адрес) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	Владелец = ОбщегоНазначения.ИдентификаторОбъектаМетаданных("Обработка.ИнформационныйЦентр");
	ОбщегоНазначения.ЗаписатьДанныеВБезопасноеХранилище(Владелец, Адрес, "АдресВнешнегоАнонимногоИнтерфейсаУСП");
	УстановитьПривилегированныйРежим(Ложь);
	
КонецПроцедуры

// Сохраняет адрес web-сервиса службы поддержки для работы с обращениями
//
// Параметры:
//  Адрес	 - Строка
//
Процедура ЗаписатьАдресАнонимногоСервисаИнтеграцииСИнформационнымЦентромУСП(Адрес) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	Владелец = ОбщегоНазначения.ИдентификаторОбъектаМетаданных("Обработка.ИнформационныйЦентр");
	ОбщегоНазначения.ЗаписатьДанныеВБезопасноеХранилище(
		Владелец, Адрес, "АдресАнонимногоСервисаИнтеграцииСИнформационнымЦентромУСП");
	УстановитьПривилегированныйРежим(Ложь);
	
КонецПроцедуры

// Сохраняет признак подтверждения кода для интеграции локальной базы с УСП
//
// Параметры:
//  КодПодтвержден	 - Булево
//
Процедура ЗаписатьПризнакПодтвержденияКодаДляИнтеграцииСУСП(КодПодтвержден) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	Владелец = ОбщегоНазначения.ИдентификаторОбъектаМетаданных("Обработка.ИнформационныйЦентр");
	ОбщегоНазначения.ЗаписатьДанныеВБезопасноеХранилище(Владелец, КодПодтвержден, "ПодтвержденКодДляИнтеграцииСУСП");
	УстановитьПривилегированныйРежим(Ложь);
	
КонецПроцедуры

// Сохраняет e-mail пользователя, от имени которого локальная база подключена к службе поддержки
//
// Параметры:
//  Адрес	 - Строка
//
Процедура ЗаписатьАдресПочтыАбонентаДляИнтеграцииСУСП(Адрес) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	Владелец = ОбщегоНазначения.ИдентификаторОбъектаМетаданных("Обработка.ИнформационныйЦентр");
	ОбщегоНазначения.ЗаписатьДанныеВБезопасноеХранилище(Владелец, Адрес, "АдресПочтыАбонентаДляИнтеграцииСУСП");
	УстановитьПривилегированныйРежим(Ложь);
	
КонецПроцедуры

// Сохраняет код, при помощи которого база зарегистрирована в службе поддержки 
//
// Параметры:
//  Код	 - Строка
//
Процедура ЗаписатьКодРегистрацииВУСП(Код) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	Владелец = ОбщегоНазначения.ИдентификаторОбъектаМетаданных("Обработка.ИнформационныйЦентр");
	ОбщегоНазначения.ЗаписатьДанныеВБезопасноеХранилище(Владелец, Код, "КодРегистрацииВУСП");
	УстановитьПривилегированныйРежим(Ложь);
	
КонецПроцедуры

// Очищает данные о подключении локальной базы к службе поддержки
//
Процедура ОчиститьДанныеНастроекИнтеграцииСУСП() Экспорт
	
	ЗаписатьАдресВнешнегоАнонимногоИнтерфейсаУСП("");
	ЗаписатьАдресАнонимногоСервисаИнтеграцииСИнформационнымЦентромУСП("");
	ЗаписатьПризнакПодтвержденияКодаДляИнтеграцииСУСП(Ложь);
	ЗаписатьАдресПочтыАбонентаДляИнтеграцииСУСП("");
	ЗаписатьКодРегистрацииВУСП("");
	
КонецПроцедуры

// Возвращает картинку по состоянию обращения.
//
// Параметры:
//	Состояние - Строка - состояние обращения.
//
// Возвращаемое значение:
//	Картинка - картинка.
//
Функция КартинкаПоСостояниюОбращения(Состояние) Экспорт
	
	Если Состояние = "Closed" Тогда 
		Возврат БиблиотекаКартинок.ЗакрытоеОбращение;
	ИначеЕсли Состояние = "InProgress" Тогда
		Возврат БиблиотекаКартинок.ОбращениеВРаботе;
	ИначеЕсли Состояние = "New" Тогда
		Возврат БиблиотекаКартинок.НовоеОбращение;
	ИначеЕсли Состояние = "NeedAnswer" Тогда
		Возврат БиблиотекаКартинок.ОбращениеНуженОтвет;
	КонецЕсли;
	
	Возврат Неопределено;
	
КонецФункции

// Номер картинки по типу взаимодействия.
//
// Параметры:
//	ТипВзаимодействия - Строка - тип взаимодействия.
//	Входящее - Булево - является ли взаимодействие входящим для пользователя.
//
// Возвращаемое значение:
//	Число - номер картинки.
//
Функция НомерКартинкиПоВзаимодействию(ТипВзаимодействия, Входящее) Экспорт
	
	Если ТипВзаимодействия = "Email" Тогда 
		Если Входящее Тогда 
			Возврат 2;
		Иначе
			Возврат 3;
		КонецЕсли;
	ИначеЕсли ТипВзаимодействия = "Comment" Тогда 
		Возврат 4;
	ИначеЕсли ТипВзаимодействия = "PhoneCall" Тогда 
		Возврат 1;
	КонецЕсли;
	
	Возврат 0;
	
КонецФункции

// Возвращает адрес электронной почты текущего пользователя.
//
// Возвращаемое значение:
//	Строка - адрес электронной почты текущего пользователя.
//
Функция ОпределитьАдресЭлектроннойПочтыПользователя() Экспорт
	
	ТекущийПользователь = Пользователи.ТекущийПользователь();
	
	
	//В БК 3.  КИ не из БСП
	//Если ИнтеграцияПодсистемБТС.ПодсистемаСуществует("СтандартныеПодсистемы.КонтактнаяИнформация") Тогда 
	//	
	//	Модуль = ИнтеграцияПодсистемБТС.ОбщийМодуль("УправлениеКонтактнойИнформацией");
	//	Если Модуль = Неопределено Тогда 
	//		Возврат "";
	//	КонецЕсли;
	//	
	//	Возврат Модуль.КонтактнаяИнформацияОбъекта(ТекущийПользователь, ПредопределенноеЗначение("Справочник.ВидыКонтактнойИнформации.EmailПользователя"));
	//	
	//КонецЕсли;
	
	АдресЭлПочты = ОбщегоНазначенияБКВызовСервера.СлужебныйАдресЭлектроннойПочтыПользователя(ТекущийПользователь);
	Если АдресЭлПочты <> Неопределено Тогда
		Возврат   АдресЭлПочты;
	КонецЕсли;
	
	Возврат "";
	
	
	
КонецФункции

// Возвращает размер в мегабайтах, размер вложения не больше 20 Мегабайт.
//
// Возвращаемое значение:
//	Число - размер вложений в мегабайтах.
//
Функция МаксимальныйРазмерВложенийДляОтправкиСообщенияВПоддержкуСервиса() Экспорт
	
	Возврат 20;
	
КонецФункции

// Текст исключения при недоступности службы поддержки.
//
// Возвращаемое значение:
//	Строка - текст исключения.
//
Функция ТекстВыводаИнформацииОбОшибкеВСлужбеПоддержки() Экспорт
	
	Возврат НСтр("ru = 'Служба поддержки временно не доступна.
                       |Пожалуйста, повторите попытку позже.'")
	
КонецФункции

// Возвращает шаблон текста в техподдержку.
//
// Возвращаемое значение:
//	Строка - шаблон текста в техподдержку.
//
Функция ШаблонТекстаВТехПоддержку() Экспорт
	
	Шаблон = НСтр("ru = 'Здравствуйте.
		|<p/>
		|<p/>ПозицияКурсора
		|<p/>
		|С уважением, %1.'");
	Шаблон = СтрШаблон(Шаблон, Пользователи.ТекущийПользователь().ПолноеНаименование());
	
	Возврат Шаблон;
	
КонецФункции

// Получает WSПрокси службы поддержки
//
// Возвращаемое значение:
//	WSПрокси - WSПрокси службы поддержки.
//
Функция ПолучитьПроксиСлужбыПоддержки() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	АдресСервиса = АдресАнонимногоСервисаИнтеграцииСИнформационнымЦентромУСП();
	УстановитьПривилегированныйРежим(Ложь);
	
	ПараметрыПодключения = ОбщегоНазначения.ПараметрыПодключенияWSПрокси();
	ПараметрыПодключения.АдресWSDL = АдресСервиса;
	ПараметрыПодключения.URIПространстваИмен = "http://www.1c.ru/1cFresh/InformationCenter/SupportServiceData/1.0.0.1";
	ПараметрыПодключения.ИмяСервиса = "InformationCenterIntegrationProtected_1_0_0_1";
	ПараметрыПодключения.ИмяТочкиПодключения = "InformationCenterIntegrationProtected_1_0_0_1Soap";
	ПараметрыПодключения.Таймаут = 20;
	
	Прокси = ОбщегоНазначения.СоздатьWSПрокси(ПараметрыПодключения);
	
	Возврат Прокси;
	
КонецФункции

// Проверяет код пользователя для работы со службой поддержки.
//
// Параметры:
//  КодПользователя	 - Строка - проверяемый код
//  Email			 - Строка - e-mail пользователя, код которого проверяется
// 
// Возвращаемое значение:
//  Структура - с полями:
//  	* КодВерный - Булево
//  	* ТекстСообщения - Строка - заполянется, если код не верный
//
Функция ПроверитьКодПользователя(КодПользователя, Email) Экспорт
	
	АдресУСП = АдресВнешнегоАнонимногоИнтерфейсаУСП();
	
	Результат = Новый Структура;
	Результат.Вставить("КодВерный", Ложь);
	Результат.Вставить("ТекстСообщения", "");
	
	АдресСервиса = АдресУСП + "/v1/CheckUserCode";
	
	Попытка
		
		СтруктураURI = ОбщегоНазначенияКлиентСервер.СтруктураURI(АдресСервиса);
		Хост = СтруктураURI.Хост;
		ПутьНаСервере = СтруктураURI.ПутьНаСервере;
		Порт = СтруктураURI.Порт;
		
		Если НРег(СтруктураURI.Схема) = НРег("https") Тогда
			ЗащищенноеСоединение = ОбщегоНазначенияКлиентСервер.НовоеЗащищенноеСоединение(
				, Новый СертификатыУдостоверяющихЦентровОС);
		Иначе
			ЗащищенноеСоединение = Неопределено;
		КонецЕсли;
		
		Соединение = Новый HTTPСоединение(
			Хост,
			Порт,
			,
			,
			,
			,
			ЗащищенноеСоединение);
		
		ДанныеЗапроса = Новый Структура;
		ДанныеЗапроса.Вставить("method_name", "CheckUserCode");
		ДанныеЗапроса.Вставить("user_code", КодПользователя);
		ДанныеЗапроса.Вставить("email", Email);
		
		ЗаписьJSON = Новый ЗаписьJSON;
		ЗаписьJSON.УстановитьСтроку();
		ЗаписатьJSON(ЗаписьJSON, ДанныеЗапроса);
		
		СтрокаЗапроса = ЗаписьJSON.Закрыть();
		
		Заголовки = Новый Соответствие;
		Заголовки.Вставить("Content-Type", "application/json; charset=utf-8");
		Заголовки.Вставить("Accept", "application/json");
		
		Запрос = Новый HTTPЗапрос(ПутьНаСервере, Заголовки);
		Запрос.УстановитьТелоИзСтроки(СтрокаЗапроса);
		
		Ответ = Соединение.ОтправитьДляОбработки(Запрос);
		
		Если Ответ.КодСостояния <> 200 Тогда
			ТекстОшибки = СтрШаблон(НСтр("ru = 'Ошибка %1'", ОбщегоНазначения.КодОсновногоЯзыка()), Строка(Ответ.КодСостояния));
			Результат.ТекстСообщения = ТекстОшибки;
			Возврат Результат;
		КонецЕсли;
		
		ЧтениеJSON = Новый ЧтениеJSON;
		
		СтрокаТелаОтвета = Ответ.ПолучитьТелоКакСтроку();
		ЧтениеJSON.УстановитьСтроку(СтрокаТелаОтвета);
		
		Попытка
			ДанныеОтвета = ПрочитатьJSON(ЧтениеJSON, Ложь);	
		Исключение
			
			ЗаписьЖурналаРегистрации(
				СтрШаблон(
					"%1.%2", 
					ПолучитьИмяСобытияДляЖурналаРегистрации(), 
					НСтр("ru = 'Проверка кода пользователя'", ОбщегоНазначения.КодОсновногоЯзыка())),
				УровеньЖурналаРегистрации.Ошибка,
				,
				,
				СтрокаТелаОтвета);
			
			Результат.ТекстСообщения = СтрокаТелаОтвета;
			
			Возврат Результат;
		КонецПопытки;
		
		Если Не ДанныеОтвета.success Тогда
			
			ЗаписьЖурналаРегистрации(
				СтрШаблон(
					"%1.%2", 
					ПолучитьИмяСобытияДляЖурналаРегистрации(), 
					НСтр("ru = 'Проверка кода пользователя'", ОбщегоНазначения.КодОсновногоЯзыка())),
				УровеньЖурналаРегистрации.Ошибка,
				,
				,
				ДанныеОтвета.response_text);
			
			Результат.ТекстСообщения = ДанныеОтвета.response_text;
			
			Возврат Результат;
			
		КонецЕсли;
		
		Результат.КодВерный = Истина;
		
	Исключение
		
		ИнформацияОбОшибке = ИнформацияОбОшибке();
		
		ЗаписьЖурналаРегистрации(
			СтрШаблон(
				"%1.%2", 
				ПолучитьИмяСобытияДляЖурналаРегистрации(), 
				НСтр("ru = 'Проверка кода пользователя'", ОбщегоНазначения.КодОсновногоЯзыка())),
			УровеньЖурналаРегистрации.Ошибка,
			,
			,
			ПодробноеПредставлениеОшибки(ИнформацияОбОшибке));
		
		Результат.ТекстСообщения = ИнформационныйЦентрСлужебный.ПодробныйТекстОшибки(ИнформацияОбОшибке);
		
		Возврат Результат;
		
	КонецПопытки;
	
	Возврат Результат;
	
КонецФункции

// Возвращает код для доступа к web-сервису информационного центра службы поддержки
// @skip-warning ПустойМетод - особенность реализации.
// Возвращаемое значение:
//  Строка - код пользователя
//
Функция КодПользователяДляДоступа() Экспорт
КонецФункции

// Возвращает структуру хранимого на форме значения взаимодействия по объекту XDTO взаимодействия.
// 
// Параметры:
//	Взаимодействие - ОбъектXDTO - объект взаимодействия. 
// Возвращаемое значение:
//	Структура:
// * Тема - Строка - тема взаимодействия. 
// * Дата - Дата - дата создания взаимодействия.
// * Описание - Строка - описание.
// * Идентификатор - УникальныйИдентификатор - идентификатор.
// * Тип - Строка - тип. 
// * Входящее - Булево - признак, Истина - входящее, Ложь - исходящее.
//
Функция ХранимоеЗначениеВзаимодействия(Взаимодействие) Экспорт
		
	ХранимоеЗначение = Новый Структура;
	ХранимоеЗначение.Вставить("Тема", Взаимодействие.Name);
	ХранимоеЗначение.Вставить("Дата", Взаимодействие.Date);
	ХранимоеЗначение.Вставить("Описание", Взаимодействие.Description);
	ХранимоеЗначение.Вставить("Идентификатор", Новый УникальныйИдентификатор(Взаимодействие.Id));
	ХранимоеЗначение.Вставить("Тип", Взаимодействие.Type);
	ХранимоеЗначение.Вставить("Входящее", Взаимодействие.Incoming);
	
	Возврат ХранимоеЗначение;
	
КонецФункции

// Сведения об информационной базе для интеграции со службой поддержки.
// 
// Возвращаемое значение:
//  Структура - Сведения об ИБ для интеграции с УСП:
//  * ИмяКонфигурации - Строка
//  * ВерсияКонфигурации - Строка
//  * ВерсияПлатформы - Строка
//  * ИдентификаторКлиента - УникальныйИдентификатор
//  * ИдентификаторИБ - Строка
//  
Функция СведенияОбИБДляИнтеграции()  Экспорт
	
	СИ = Новый СистемнаяИнформация;
	
	Сведения = Новый Структура();
	Сведения.Вставить("ИмяКонфигурации", Метаданные.Имя);
	Сведения.Вставить("ВерсияКонфигурации", Метаданные.Версия);
	Сведения.Вставить("ВерсияПлатформы", СИ.ВерсияПриложения);
	Сведения.Вставить("ИдентификаторКлиента", СИ.ИдентификаторКлиента);
	Сведения.Вставить("ИдентификаторИБ", Константы.ИдентификаторИнформационнойБазы.Получить());
	
	Возврат Сведения;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Возвращает пространство имен для пакета XDTO "InformationReferences"
//
// Возвращаемое значение:
//	Строка - пространство имен.
//
Функция ПространствоИменИнформационныхСсылок()
	
	Возврат "http://www.1c.ru/SaaS/1.0/XMLSchema/ManageInfoCenter/InformationReferences";
	
КонецФункции

// Возвращает пространство имен для пакета XDTO "InformationReferences_1_0_1_1"
//
// Возвращаемое значение:
//	Строка - пространство имен.
//
Функция ПространствоИменИнформационныхСсылок_1_0_1_1()
	
	Возврат "http://www.1c.ru/1cFresh/InformationCenter/InformationReferences/1.0.1.1";
	
КонецФункции

// Формирует элементы формы информационных ссылок в группе.
//
// Параметры:
//	Форма - ФормаКлиентскогоПриложения - контекст формы:
//  * ИнформационныеСсылки - СписокЗначений - значения информационных ссылок.
//	ТаблицаСсылок - см. ИнформационныйЦентрСерверПовтИсп.ИнформационныеСсылки
//	ГруппаФормы - ГруппаФормы - группа формы, в которой выводятся информационные ссылки.
//	КоличествоГрупп - Число - количество групп информационных ссылок в форме.
//	КоличествоСсылокВГруппе - Число - количество информационных ссылок в группе.
//	ВыводитьСсылкуВсе - Булево - выводить или нет ссылку "Все".
//
Процедура СформироватьГруппыВывода(Форма, ТаблицаСсылок, ГруппаФормы, КоличествоГрупп, КоличествоСсылокВГруппе, 
	ВыводитьСсылкуВсе)
	
	КоличествоСсылок = ?(ТаблицаСсылок.Количество() > КоличествоГрупп * КоличествоСсылокВГруппе, 
		КоличествоГрупп * КоличествоСсылокВГруппе, ТаблицаСсылок.Количество());
	
	КоличествоГрупп = ?(КоличествоСсылок < КоличествоГрупп, КоличествоСсылок, КоличествоГрупп);
	
	НеполноеНаименованиеГруппы = "ГруппаИнформационныхСсылок";
	
	Для Итерация = 1 По КоличествоГрупп Цикл 
		
		ИмяЭлементаФормы = НеполноеНаименованиеГруппы + Строка(Итерация);
		РодительскаяГруппа = Форма.Элементы.Добавить(ИмяЭлементаФормы, Тип("ГруппаФормы"), ГруппаФормы);
		РодительскаяГруппа.Вид = ВидГруппыФормы.ОбычнаяГруппа;
		РодительскаяГруппа.ОтображатьЗаголовок = Ложь;
		РодительскаяГруппа.Группировка = ГруппировкаПодчиненныхЭлементовФормы.Вертикальная;
		РодительскаяГруппа.Отображение = ОтображениеОбычнойГруппы.Нет;
		
	КонецЦикла;
	
	Для Итерация = 1 По КоличествоСсылок Цикл 
		
		ГруппаСсылки = ПолучитьГруппуСсылок(Форма, КоличествоГрупп, НеполноеНаименованиеГруппы, Итерация);
		
		ДанныеСсылки = ТаблицаСсылок.Получить(Итерация - 1);
		ИмяСсылки = ДанныеСсылки.Наименование;
		Адрес = ДанныеСсылки.Адрес;
		
		ЭлементСсылки = 
			Форма.Элементы.Добавить("ЭлементСсылки" + Строка(Итерация), Тип("ДекорацияФормы"), ГруппаСсылки);
		ЭлементСсылки.Вид = ВидДекорацииФормы.Надпись;
		ЭлементСсылки.Заголовок = ИмяСсылки;
		ЭлементСсылки.РастягиватьПоГоризонтали = Истина;
		ЭлементСсылки.АвтоМаксимальнаяШирина = Ложь;
		ЭлементСсылки.Высота = 1;
		Обработки.ИнформационныйЦентр.УстановитьПризнакГиперссылки(ЭлементСсылки);
		ЭлементСсылки.УстановитьДействие("Нажатие", "Подключаемый_НажатиеНаИнформационнуюСсылку");
		
		Форма.ИнформационныеСсылки.Добавить(ЭлементСсылки.Имя, Адрес);
		
	КонецЦикла;
	
	Если ВыводитьСсылкуВсе Тогда
		Элемент = Форма.Элементы.Добавить("СсылкаВсеИнформационныеСсылки", Тип("ДекорацияФормы"), ГруппаФормы);
		Элемент.Вид = ВидДекорацииФормы.Надпись;
		Элемент.Заголовок = НСтр("ru = 'Все'");
		Элемент.Гиперссылка = Истина;
		Элемент.ЦветТекста = WebЦвета.Черный;
		Элемент.ГоризонтальноеПоложение = ГоризонтальноеПоложениеЭлемента.Право;
		Элемент.УстановитьДействие("Нажатие", "Подключаемый_НажатиеНаСсылкуВсеИнформационныеСсылки")
	КонецЕсли;
	
КонецПроцедуры

// Заполняет элементы формы.
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - форма:
//  * ИнформационныеСсылки - СписокЗначений - значения информационных ссылок.
//  ТаблицаСсылок - ТаблицаЗначений - таблица ссылок.
//  МассивЭлементов - Массив - массив элементов формы.
//  ЭлементВсеСсылки - ДекорацияФормы -  надпись "Все".
//
Процедура ЗаполнитьИнформационныеСсылки(Форма, МассивЭлементов, ТаблицаСсылок, ЭлементВсеСсылки)
	
	Для Итерация = 0 По МассивЭлементов.Количество() -1 Цикл
		
		ДанныеСсылки = ТаблицаСсылок.Получить(Итерация);
		
		ЭлементСсылки = МассивЭлементов.Получить(Итерация);
		ЭлементСсылки.Заголовок = ДанныеСсылки.Наименование;
		Обработки.ИнформационныйЦентр.УстановитьПризнакГиперссылки(ЭлементСсылки);
		ЭлементСсылки.Подсказка = ДанныеСсылки.Подсказка;
		
		Форма.ИнформационныеСсылки.Добавить(ЭлементСсылки.Имя, ДанныеСсылки.Адрес);
		
	КонецЦикла;
	
КонецПроцедуры

// Возвращает группу, в которой необходимо выводить информационные ссылки.
//
// Параметры:
//	Форма - ФормаКлиентскогоПриложения - контекст формы.
//	КоличествоГрупп - Число - количество групп с информационными ссылками на форме.
//	НеполноеНаименованиеГруппы - Строка - неполное наименование группы.
//	ТекущаяИтерация - Число - текущая итерация.
//
// Возвращаемое значение:
//	ГруппаФормы - группа информационных ссылок или неопределенно.
//
Функция ПолучитьГруппуСсылок(Форма, КоличествоГрупп, НеполноеНаименованиеГруппы, ТекущаяИтерация)
	
	ИмяГруппы = "";
	
	Для ИтерацияГрупп = 1 По КоличествоГрупп Цикл
		
		Если ТекущаяИтерация % ИтерацияГрупп  = 0 Тогда 
			ИмяГруппы = НеполноеНаименованиеГруппы + Строка(ИтерацияГрупп);
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат Форма.Элементы.Найти(ИмяГруппы);
	
КонецФункции

Процедура ОпределитьСостояниеПодключенияВФоне(Параметры, АдресРезультата) Экспорт
	
	АдресУСП = АдресВнешнегоАнонимногоИнтерфейсаУСП();
	
	Результат = Новый Структура;
	Результат.Вставить("Успешно", Истина);
	Результат.Вставить("ТекстСообщения", "");
	
	АдресСервиса = АдресУСП + "/version";
	
	Попытка
		
		СтруктураURI = ОбщегоНазначенияКлиентСервер.СтруктураURI(АдресСервиса);
		Хост = СтруктураURI.Хост;
		ПутьНаСервере = СтруктураURI.ПутьНаСервере;
		Порт = СтруктураURI.Порт;
		
		Если НРег(СтруктураURI.Схема) = НРег("https") Тогда
			ЗащищенноеСоединение = ОбщегоНазначенияКлиентСервер.НовоеЗащищенноеСоединение(
				, Новый СертификатыУдостоверяющихЦентровОС);
		Иначе
			ЗащищенноеСоединение = Неопределено;
		КонецЕсли;
		
		Соединение = Новый HTTPСоединение(
			Хост,
			Порт,
			,
			,
			,
			,
			ЗащищенноеСоединение);
		
		Запрос = Новый HTTPЗапрос(ПутьНаСервере);
		Ответ = Соединение.Получить(Запрос);
		
		Если Ответ.КодСостояния <> 200 Тогда
			ТекстОшибки = СтрШаблон(НСтр("ru = 'Ошибка %1'", ОбщегоНазначения.КодОсновногоЯзыка()), Строка(Ответ.КодСостояния));
			Результат.ТекстСообщения = ТекстОшибки;
			Результат.Успешно = Ложь;
		КонецЕсли;
		
	Исключение
		
		ИнформацияОбОшибке = ИнформацияОбОшибке();
		
		ЗаписьЖурналаРегистрации(
			СтрШаблон(
				"%1.%2", 
				ПолучитьИмяСобытияДляЖурналаРегистрации(), 
				НСтр("ru = 'Проверка кода пользователя'", ОбщегоНазначения.КодОсновногоЯзыка())),
			УровеньЖурналаРегистрации.Ошибка,
			,
			,
			ПодробноеПредставлениеОшибки(ИнформацияОбОшибке));
		
		Результат.ТекстСообщения = ИнформационныйЦентрСлужебный.КраткийТекстОшибки(ИнформацияОбОшибке);
		Результат.Успешно = Ложь;
		
	КонецПопытки;
	
	ПоместитьВоВременноеХранилище(Результат, АдресРезультата);
	
КонецПроцедуры

#КонецОбласти
