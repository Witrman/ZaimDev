﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

// Заполняет настройки, влияющие на использование плана обмена.
// 
// Параметры:
//  Настройки - Структура - настройки плана обмена по умолчанию, см. ОбменДаннымиСервер.НастройкиПланаОбменаПоУмолчанию,
//                          описание возвращаемого значения функции.
//
Процедура ПриПолученииНастроек(НастройкиПланаОбмена) Экспорт

	НастройкиПланаОбмена.ИмяКонфигурацииИсточника = "БухгалтерияДляКазахстана";
	НастройкиПланаОбмена.ИмяКонфигурацииПриемника.Вставить("ЗарплатаИУправлениеПерсоналомДляКазахстана");
	НастройкиПланаОбмена.ПланОбменаИспользуетсяВМоделиСервиса = Истина;
	
	НастройкиПланаОбмена.ПредупреждатьОНесоответствииВерсийПравилОбмена  = Ложь;
	
	НастройкиПланаОбмена.Алгоритмы.ПриПолученииВариантовНастроекОбмена   = Истина;
	НастройкиПланаОбмена.Алгоритмы.ПриПолученииОписанияВариантаНастройки = Истина;

КонецПроцедуры

// Заполняет коллекцию вариантов настроек, предусмотренных для плана обмена.
// 
// Параметры:
//  ВариантыНастроекОбмена - ТаблицаЗначений - коллекция вариантов настроек обмена, см. описание возвращаемого значения
//                                       функции НастройкиПланаОбменаПоУмолчанию общего модуля ОбменДаннымиСервер.
//  ПараметрыКонтекста     - Структура - см. ОбменДаннымиСервер.ПараметрыКонтекстаПолученияВариантовНастроек,
//                                       описание возвращаемого значения функции.
//
Процедура ПриПолученииВариантовНастроекОбмена(ВариантыНастроекОбмена, ПараметрыКонтекста) Экспорт
	
	ВариантНастройки = ВариантыНастроекОбмена.Добавить();
	ВариантНастройки.ИдентификаторНастройки        = "Двухсторонний";
	ВариантНастройки.КорреспондентВМоделиСервиса   = Ложь;
	ВариантНастройки.КорреспондентВЛокальномРежиме = Истина;

КонецПроцедуры

// Заполняет набор параметров, определяющих вариант настройки обмена.
// 
// Параметры:
//  ОписаниеВарианта       - Структура - набор варианта настройки по умолчанию,
//                                       см. ОбменДаннымиСервер.ОписаниеВариантаНастройкиОбменаПоУмолчанию,
//                                       описание возвращаемого значения.
//  ИдентификаторНастройки - Строка    - идентификатор варианта настройки обмена.
//  ПараметрыКонтекста     - Структура - см. ОбменДаннымиСервер.ПараметрыКонтекстаПолученияОписанияВариантаНастройки,
//                                       описание возвращаемого значения функции.
//
Процедура ПриПолученииОписанияВариантаНастройки(ОписаниеВарианта, ИдентификаторНастройки, ПараметрыКонтекста) Экспорт
	
	КраткаяИнформацияПоОбмену = КраткаяИнформацияПоОбмену(ИдентификаторНастройки);
	КраткаяИнформацияПоОбмену = СтрЗаменить(КраткаяИнформацияПоОбмену, Символы.ПС, "");
	ОписаниеВарианта.КраткаяИнформацияПоОбмену   = КраткаяИнформацияПоОбмену;
	
	ОписаниеВарианта.ПодробнаяИнформацияПоОбмену 				= ПодробнаяИнформацияПоОбмену(ИдентификаторНастройки);
	ОписаниеВарианта.ИспользоватьПомощникСозданияОбменаДанными 	= ИспользоватьПомощникСозданияОбменаДанными();
	ОписаниеВарианта.ИмяКонфигурацииКорреспондента 				= "ЗарплатаИУправлениеПерсоналомДляКазахстана";
	ОписаниеВарианта.НаименованиеКонфигурацииКорреспондента 	= НСтр("ru='Зарплата и управление персоналом для Казахстана, ред. 2.0'");
	ОписаниеВарианта.ЗаголовокПомощникаСозданияОбмена         	= НСтр("ru = 'Настройка обмена данными с программой Зарплата и управление персоналом, ред. 2.0'");;
	ОписаниеВарианта.ИспользуемыеТранспортыСообщенийОбмена 		= ИспользуемыеТранспортыСообщенийОбмена();
	ОписаниеВарианта.ИмяФайлаНастроекДляПриемника 				= ИмяФайлаНастроекДляПриемника();
	
	ЗаголовокФормыУзла = НСтр("ru='Зарплата и управление персоналом для Казахстана, ред. 2.0'");
	ОписаниеВарианта.Вставить("ЗаголовокУзлаПланаОбмена", ЗаголовокФормыУзла);
	//ОписаниеВарианта.ОтображатьЗначенияПоУмолчаниюНаУзле = Ложь;
	//ОписаниеВарианта.ОтображатьЗначенияПоУмолчаниюНаУзлеБазыКорреспондента = Ложь;
	ОписаниеВарианта.ОбщиеДанныеУзлов = ОбщиеДанныеУзлов();
	// Отборы и значения по умолчанию.
	//ОписаниеВарианта.Отборы = НастройкаОтборовНаУзле(ИдентификаторНастройки);
	//ОписаниеВарианта.ЗначенияПоУмолчанию = ЗначенияПоУмолчаниюНаУзле(ИдентификаторНастройки);
	//ОписаниеВарианта.ОтборыКорреспондента = НастройкаОтборовНаУзлеБазыКорреспондента(ИдентификаторНастройки);
	//ОписаниеВарианта.ЗначенияПоУмолчаниюКорреспондента = ЗначенияПоУмолчаниюНаУзлеБазыКорреспондента(ИдентификаторНастройки);
	
КонецПроцедуры

// Возвращает представление отбора для варианта дополнения выгрузки по сценарию узла.
//
// Параметры:
//     Получатель - ПланОбменаСсылка - узел, для которого определяется представление отбора.
//     Параметры  - Структура        - характеристики отбора.
//
// Возвращаемое значение: 
//     Строка - описание отбора
//
Функция ПредставлениеОтбораИнтерактивнойВыгрузки(Получатель, Параметры) Экспорт
	
КонецФункции

// Предназначена для настройки вариантов интерактивной настройки выгрузки по сценарию узла.
// Для настройки необходимо установить значения свойств параметров в необходимые значения.
//
// Параметры:
//  Получатель - ПланОбменаСсылка - узел, для которого производится настройка.
//  Параметры  - Структура        - параметры для изменения.
//
Процедура НастроитьИнтерактивнуюВыгрузку(Получатель, Параметры) Экспорт
	
КонецПроцедуры

// Обработчик события при получении данных узла-отправителя. Событие возникает при 
// получении данных узла-отправителя, когда данные узла прочитаны из сообщения обмена, 
// но не записаны в ин-формационную базу. В обработчике можно изменить полученные 
// данные или вовсе отказаться от получения данных узла.
// 
// Параметры:
//  Отправитель – ПланОбменаОбъект – узел плана обмена, от имени которого выполняется 
// 									 получение данных.
//  Игнорировать – Булево – признак отказа от получения данных узла. Если в обработчике 
//							установить значение этого параметра в Истина, то получение 
//							данных узла выполнено не будет. Значение по умолчанию – Ложь.
// 
Процедура ПриПолученииДанныхОтправителя(Отправитель, Игнорировать) Экспорт
	
КонецПроцедуры

// Обработчик события при отправке данных узла-отправителя. Событие возникает при 
// отправке данных узла-отправителя из текущей базы в базу-корреспондент, до 
// помещения данных узла в сообщение обмена. В обработчике можно изменить 
// отправляемые данные или вовсе отказаться от отправки данных узла.
// 
// Параметры:
//  Отправитель – ПланОбменаОбъект – узел плана обмена, от имени которого выполняется 
// 									 отправка данных.
//  Игнорировать – Булево – признак отказа от выгрузки данных узла. Если в обработчике 
//							установить значение этого параметра в Истина, то отправка 
//							данных узла выполнена не будет. Значение по умолчанию – Ложь.
// 
Процедура ПриОтправкеДанныхОтправителя(Отправитель, Игнорировать) Экспорт
	
КонецПроцедуры

// Обработчик события при подключении к корреспонденту. Событие возникает при успешном 
// подключении к корреспонденту и получении версии конфигурации корреспондента 
// при настройке обмена с использованием помощника через прямое подключение или 
// при подключении к корреспонденту через Интернет.
// 
// Параметры:
//  ВерсияКорреспондента - Строка - версия конфигурации корреспондента, например, "2.1.5.1".
// 
Процедура ПриПодключенииККорреспонденту(ВерсияКорреспондента) Экспорт
	
КонецПроцедуры

// Возвращает имя файла настроек по умолчанию;
// В этот файл будут выгружены настройки обмена для приемника;
// Это значение должно быть одинаковым в плане обмена источника и приемника.
// 
// Параметры:
//  Нет.
// 
// Возвращаемое значение:
//  Строка, 255 - имя файла по умолчанию для выгрузки настроек обмена данными
//
Функция ИмяФайлаНастроекДляПриемника() Экспорт
	
	Возврат НСтр("ru = 'Настройки обмена для БК-ЗУП'");
	
КонецФункции

// Возвращает массив используемых транспортов сообщений для этого плана обмена
//
// 1. Например, если план обмена поддерживает только два транспорта сообщений FILE и FTP,
// то тело функции следует определить следующим образом:
//
//	Результат = Новый Массив;
//	Результат.Добавить(Перечисления.ВидыТранспортаСообщенийОбмена.FILE);
//	Результат.Добавить(Перечисления.ВидыТранспортаСообщенийОбмена.FTP);
//	Возврат Результат;
//
// 2. Например, если план обмена поддерживает все транспорты сообщений, определенных в конфигурации,
// то тело функции следует определить следующим образом:
//
//	Возврат ОбменДаннымиСервер.ВсеТранспортыСообщенийОбменаКонфигурации();
//
// Возвращаемое значение:
//  Массив - массив содержит значения перечисления ВидыТранспортаСообщенийОбмена
//
Функция ИспользуемыеТранспортыСообщенийОбмена() Экспорт
	
	Результат = Новый Массив;
	Результат.Добавить(Перечисления.ВидыТранспортаСообщенийОбмена.FILE);
	Результат.Добавить(Перечисления.ВидыТранспортаСообщенийОбмена.FTP);
	//Результат.Добавить(Перечисления.ВидыТранспортаСообщенийОбмена.COM);
	Возврат Результат;
	
КонецФункции

// Возвращает пользовательскую форму для создания начального образа базы.
// Эта форма будет открыта после завершения настройки обмена с помощью помощника.
// Для планов обмена не РИБ функция возвращает пустую строку
//
// Возвращаемое значение:
//  Строка, Неогранич - имя формы
//
// Например:
//	Возврат "ПланОбмена._ДемоРаспределеннаяИнформационнаяБаза.Форма.ФормаСозданияНачальногоОбраза";
//
Функция ИмяФормыСозданияНачальногоОбраза() Экспорт
	
	Возврат "";
	
КонецФункции

// Возвращает представление команды создания нового обмена данными.
//
// Возвращаемое значение:
//  Строка, Неогранич - представление команды, выводимое в пользовательском интерфейсе.
//
// Например:
//	Возврат НСтр("ru = 'Создать обмен в распределенной информационной базе'");
//
Функция ЗаголовокКомандыДляСозданияНовогоОбменаДанными() Экспорт
	
	Возврат НСтр("ru = 'Зарплата и управление персоналом для Казахстана, ред. 2.0'");
	
КонецФункции

// Определяет, будет ли использоваться помощник для создания новых узлов плана обмена.
//
// Возвращаемое значение:
//  Булево - признак использования помощника.
//
Функция ИспользоватьПомощникСозданияОбменаДанными() Экспорт
	
	Возврат Истина;
	
КонецФункции

// Возвращает имена реквизитов и табличных частей плана обмена,
// перечисленных через запятую, которые являются общими для пары обменивающихся конфигураций.
// Например, если для плана обмена предусмотрено ограничение миграции данных по организациям в обе стороны,
// то табличная часть плана обмена, в которой перечислены разрешенные организации, считается общей.
// Возвращает пустую строку, если общие данные узлов не предусмотрены.
//
// Параметры:
//  ВерсияКорреспондента - Строка - версия конфигурации корреспондента, например, "2.1.5.1".
// 
Функция ОбщиеДанныеУзлов() Экспорт
	
	Возврат "ДатаНачалаВыгрузкиДокументов,ИспользоватьОтборПоОрганизациям,Организации,РежимВыгрузкиПриНеобходимости";
	
КонецФункции

// Возвращает пользовательское представление значений по умолчанию в виде строки.
// Возвращает пустую строку, если значения по умолчанию на узле не предусмотрены.
//
Функция ОписаниеЗначениеПоУмолчанию() Экспорт
	возврат "";
КонецФункции

// Возвращает признак использования плана обмена для организации обмена в модели сервиса.
//  Если признак установлен, то в сервисе можно включить обмен данными
//  с использованием этого плана обмена.
//  Если признак не установлен, то план обмена будет использоваться только 
//  для обмена в локальном режиме работы конфигурации.
// 
Функция ПланОбменаИспользуетсяВМоделиСервиса() Экспорт
	
	Возврат Ложь;
	
КонецФункции

// Возвращает признак того, что план обмена поддерживает обмен данными с корреспондентом, работающим в модели сервиса.
// Если признак установлен, то становится возможным создать обмен данными когда эта информационная база
// работает в локальном режиме, а корреспондент в модели сервиса.
//
Функция КорреспондентВМоделиСервиса() Экспорт
	
	Возврат Ложь;
	
КонецФункции

// Возвращает пояснение о последовательности действий пользователя для настройки параметров учета в текущей информационной базе.
//
Функция ПояснениеДляНастройкиПараметровУчета() Экспорт
	
	Возврат "";
	
КонецФункции

// Возвращает пояснение о последовательности действий пользователя для настройки параметров учета в базе-корреспонденте.
//
// Параметры:
//  ВерсияКорреспондента - Строка - версия конфигурации корреспондента, например, "2.1.5.1".
// 
Функция ПояснениеДляНастройкиПараметровУчетаБазыКорреспондента(ВерсияКорреспондента) Экспорт
	
	Возврат "";
	
КонецФункции

Процедура ОбработчикПроверкиПараметровУчета(Отказ, Получатель, Сообщение) Экспорт
	
КонецПроцедуры

// Возвращает краткую информацию по обмену, выводимую при настройке синхронизации данных.
//
Функция КраткаяИнформацияПоОбмену(ИдентификаторНастройки) Экспорт
	
	ПоясняющийТекст = НСтр("ru = 'Позволяет синхронизировать данные с программой 1С:Зарплата и управление персоналом для Казахстана, редакция 2.0. 
	|В синхронизации участвуют следующие типы данных: справочники (например, Организации), документы (например, 
	|Приходный кассовый ордер), регистры сведений (например, Сведения об инвалидности физ. лиц).
	|
	|Синхронизация является двухсторонней и позволяет иметь актуальные данные в каждой из информационных баз.'");

	Возврат ПоясняющийТекст;
	
КонецФункции

// Возвращаемое значение: Строка - Ссылка на подробную информацию по настраиваемой синхронизации,
// в виде гиперссылки или полного пути к форме
//
Функция ПодробнаяИнформацияПоОбмену(ИдентификаторНастройки) Экспорт
	
	Возврат "ПланОбмена.ОбменЗарплатаИУправлениеПерсоналомБухгалтерияПредприятия.Форма.ПодробнаяИнформация";
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
//Дополнение к функционалу БСП

//Возвращает режим запуска, в случае интерактивного инициирования синхронизации
//Возвращаемые значения АвтоматическаяСинхронизация Или ИнтерактивнаяСинхронизация
//На основании этих значений запускается либо помощник интерактивного обмена, либо автообмен
Функция РежимЗапускаСинхронизацииДанных(УзелИнформационнойБазы) Экспорт
	//Пример типового возврата
	Возврат "";
КонецФункции

//Возвращает сценарий работы помощника интерактивного сопостовления
//НеОтправлять, ИнтерактивнаяСинхронизацияДокументов, ИнтерактивнаяСинхронизацияСправочников либо пустую строку
Функция ИнициализироватьСценарийРаботыПомощникаИнтерактивногоОбмена(УзелИнформационнойБазы) Экспорт
	//Пример типового возврата
	Возврат "";
КонецФункции

//Возвращает значения ограничений объектов узла плана обмена для интерактивной регистрации к обмену
//Структура: ВсеДокументы, ВсеСправочники, ДетальныйОтбор
//Детальный отбор либо неопределено, либо массив объектов метаданных входящих в состав узла (Указывается полное имя метаданных)
Функция ДобавитьГруппыОграничений(УзелИнформационнойБазы) Экспорт
	//Пример типового возврата
	Возврат Новый Структура("ВсеДокументы, ВсеСправочники, ДетальныйОтбор", Ложь, Ложь, Неопределено);
КонецФункции

#КонецЕсли