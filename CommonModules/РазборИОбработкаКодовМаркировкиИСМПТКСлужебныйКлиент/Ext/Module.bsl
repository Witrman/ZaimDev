﻿
#Область ПодключаемоеОборудование

#Область РаботаСТСД

// Показывает окно оповещения об окончании обработки данных ТСД.
//
// Параметры:
Процедура ОповеститьОбОкончанииОбработкиДанныхТСД() Экспорт
	
	ПоказатьОповещениеПользователя(
		ЗаголовокОповещенияТСД(),,
		НСтр("ru = 'Закончена обработка полученных из ТСД данных.';
			 |en = 'Закончена обработка полученных из ТСД данных.'"),
		БиблиотекаКартинок.Информация32);
	
КонецПроцедуры

// Показывает окно оповещения о начале обработки данных ТСД.
//
// Параметры:
Процедура ОповеститьОНачалеОбработкиДанныхТСД() Экспорт
	
	ПоказатьОповещениеПользователя(
		ЗаголовокОповещенияТСД(),,
		НСтр("ru = 'Начата обработка полученных из ТСД данных.';
			 |en = 'Начата обработка полученных из ТСД данных.'"),
		БиблиотекаКартинок.Информация32);
	
КонецПроцедуры

// Возвращает текст заголовка оповещения для ТСД.
//
// Параметры:
// Возвращаемое значение:
//  Строка - Текст заголовка.
Функция ЗаголовокОповещенияТСД()
	
	Возврат НСтр("ru = 'Загрузка из ТСД';
				 |en = 'Загрузка из ТСД'");
	
КонецФункции

// Преобразует массив штрихкодов в формат Base64.
// 
// Параметры:
//  ШтрихкодыТСД - Массив из Строка - список штрихкодов.
Процедура ПреобразоватьШтрихкодыТСДВBase64(ШтрихкодыТСД) Экспорт
	
	Для Каждого ЭлементМассива Из ШтрихкодыТСД Цикл
		Если ЭлементМассива.Свойство("ШтрихкодыПреобразованы") Тогда
			Продолжить;
		КонецЕсли;
		Если ЗначениеЗаполнено(ЭлементМассива.Штрихкод) Тогда
			ЭлементМассива.Штрихкод = РазборИОбработкаКодовМаркировкиИСМПТКСлужебныйКлиентСервер.ШтрихкодВBase64(ЭлементМассива.Штрихкод);
		КонецЕсли;
		Если ЭлементМассива.Свойство("ШтрихкодУпаковки") И ЗначениеЗаполнено(ЭлементМассива.ШтрихкодУпаковки) Тогда
			ЭлементМассива.ШтрихкодУпаковки = РазборИОбработкаКодовМаркировкиИСМПТКСлужебныйКлиентСервер.ШтрихкодВBase64(ЭлементМассива.ШтрихкодУпаковки);
		КонецЕсли;
		ЭлементМассива.Вставить("ШтрихкодыПреобразованы");
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область Оповещения

// Инициализирует параметры открытия формы невозможности добавления отсканированного.
//
// Параметры:
// 	ВидПродукции - ПеречислениеСсылка.ВидыПродукцииИСМПТК - Вид маркируемой продукции.
// Возвращаемое значение:
// 	Структура - Описание:
// * АдресДереваУпаковок - Строка - адрес хранилища, где находится дерево упаковок.
// * АлкогольнаяПродукция - СправочникСсылка.КлассификаторАлкогольнойПродукцииЕГАИС - алкогольная продукция.
// * ТипШтрихкода - ПеречислениеСсылка.ТипыШтрихкодов - Тип штрихкода.
// * Организация - ОпределяемыйТип.Организация - Организация.
// * ТекстОшибки - Строка - Описание причины невозможности обработки отсканированного штрихкода.
// * Штрихкод - Строка - Штрихкод строкой.
// * ПредставлениеНоменклатуры - Строка - Представление маркируемой продукции.
// * ВидПродукции - ПеречислениеСсылка.ВидыПродукцииИСМПТК - Вид маркируемой продукции.
Функция ПараметрыОткрытияФормыНевозможностиДобавленияОтсканированного(ВидПродукции = Неопределено) Экспорт
	
	ИнформацияПроблемы = Новый Структура;
	
	ИнформацияПроблемы.Вставить("ВидПродукции", ВидПродукции);
	
	// Информация по маркированному товару.
	ИнформацияПроблемы.Вставить("ПредставлениеНоменклатуры",        Неопределено);
	ИнформацияПроблемы.Вставить("Штрихкод",                         Неопределено);
	ИнформацияПроблемы.Вставить("ТекстОшибки",                      Неопределено);
	ИнформацияПроблемы.Вставить("ПараметрыОшибки",                  Неопределено);
	ИнформацияПроблемы.Вставить("ИмяФормыИсточник",                 Неопределено);
	ИнформацияПроблемы.Вставить("Организация",                      Неопределено);
	ИнформацияПроблемы.Вставить("ТекстОшибкиФорматированнаяСтрока", Неопределено);
	ИнформацияПроблемы.Вставить("ТипШтрихкода",                     Неопределено);
	ИнформацияПроблемы.Вставить("ВидУпаковки",                      Неопределено);
	ИнформацияПроблемы.Вставить("АлкогольнаяПродукция",             Неопределено);
	ИнформацияПроблемы.Вставить("ОбратноеСканирование",             Неопределено);
	
	// Информация по дереву упаковок.
	ИнформацияПроблемы.Вставить("АдресДереваУпаковок", Неопределено);
	
	Возврат ИнформацияПроблемы;
	
КонецФункции

// Показывает форму ввода штрихкода.
// 
// Параметры:
//  ОписаниеОповещения - ОписаниеОповещения - Оповещение, которое будет выполнено по завершению.
Процедура ПоказатьВводШтрихкода(ОписаниеОповещения) Экспорт
	
	Заголовок = НСтр("ru = 'Введите штрихкод (сканирование не поддерживается!)';
					 |en = 'Введите штрихкод'");
	
	ДополнительныеПараметры = Новый Структура("ОповещениеУспешногоВвода, Количество", ОписаниеОповещения, Неопределено);
		
	Оповещение = Новый ОписаниеОповещения("ПоказатьВводШтрихкодаЗавершение", ЭтотОбъект, ДополнительныеПараметры);
	
	ПоказатьВводЗначения(Оповещение, "", Заголовок);
		
КонецПроцедуры

// Выполняет завершение после показа формы ввода штрихкода.
// 
// Параметры:
//  Штрихкод - Строка - штрихкод строкой.
//  ДополнительныеПараметры - Структура - Параметры описания оповещения.
Процедура ПоказатьВводШтрихкодаЗавершение(Штрихкод, ДополнительныеПараметры) Экспорт
	
	ОповещениеУспешногоВвода = ДополнительныеПараметры.ОповещениеУспешногоВвода;
	Количество = ДополнительныеПараметры.Количество;
	
	Если Штрихкод = Неопределено Или ПустаяСтрока(Штрихкод) Тогда
		Возврат;
	КонецЕсли;
	
	Если Количество = Неопределено Тогда
		Количество = 1;
	КонецЕсли;
	
	Если СтрДлина(Штрихкод) > 200 Тогда
		ТекстСообщения = НСтр("ru = 'Длина штрихкода не должна быть больше 200 символов.';
							  |en = 'Длина штрихкода не должна быть больше 200 символов.'");
		РазборИОбработкаКодовМаркировкиИСМПТКСлужебныйКлиентСерверПереопределяемый.СообщитьПользователю(ТекстСообщения);
		
		Возврат;
	КонецЕсли;
	
	ВыполнитьОбработкуОповещения(ОповещениеУспешногоВвода, Новый Структура("Штрихкод, Количество", Штрихкод, Количество));
	
КонецПроцедуры

#КонецОбласти

// Выполняет инициализацию и заполнение параметров сканирования по переданному контексту.
// Параметры сканирования необходимы для анализа и обработки штрихкодов маркируемой продукции.
//
Функция ПараметрыСканирования(Контекст = Неопределено, ФормаВыбора = Неопределено, ВидПродукции = Неопределено) Экспорт
	
	ПараметрыСканирования = РазборИОбработкаКодовМаркировкиИСМПТКСлужебныйКлиентСервер.БазовыеПараметрыСканирования();
	РазборИОбработкаКодовМаркировкиИСМПТКСлужебныйВызовСервера.ЗполнитьДопустимыеВидыПродукции(ПараметрыСканирования);
	РазборИОбработкаКодовМаркировкиИСМПТКСлужебныйКлиентСерверПереопределяемый.ЗаполнитьБазовыеПараметрыСканирования(ПараметрыСканирования, Контекст);
		
	Возврат ПараметрыСканирования;
	
КонецФункции

#КонецОбласти

#Область НавигационнаяСсылка

// Открывает навигационную ссылку в программе, которая ассоциирована с протоколом навигационной ссылки.
//
Процедура ОткрытьНавигационнуюСсылку(НавигационнаяСсылка, Знач Оповещение = Неопределено) Экспорт
	
	// АПК:534-выкл методы безопасного запуска обеспечиваются этой функцией
	
	Контекст = Новый Структура;
	Контекст.Вставить("НавигационнаяСсылка", НавигационнаяСсылка);
	Контекст.Вставить("Оповещение", 		 Оповещение);
	
	ОписаниеОшибки = РазборИОбработкаКодовМаркировкиИСМПТКСлужебныйКлиентСерверПереопределяемый.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'Не удалось перейти по ссылке ""%1"" по причине: 
		           |Неверно задана навигационная ссылка.';
		           |en = 'Cannot follow the ""%1"" link due to:
		           |Navigation link is specified incorrectly.'"),
		НавигационнаяСсылка);
	
	Если Не ЭтоДопустимаяСсылка(НавигационнаяСсылка) Тогда 
		
		ОткрытьНавигационнуюСсылкуОповеститьОбОшибке(ОписаниеОшибки, Контекст);
		
	ИначеЕсли ЭтоВебСсылка(НавигационнаяСсылка)
		Или ЭтоНавигационнаяСсылка(НавигационнаяСсылка) Тогда 
		
		Попытка
		
#Если ТолстыйКлиентОбычноеПриложение Тогда
			
			// Особенность платформы: ПерейтиПоНавигационнойСсылке не доступен в толстом клиенте обычного приложения.
			Оповещение = Новый ОписаниеОповещения(
				,, Контекст,
				"ОткрытьНавигационнуюСсылкуПриОбработкеОшибки", РазборИОбработкаКодовМаркировкиИСМПТКСлужебныйКлиент);
			НачатьЗапускПриложения(Оповещение, НавигационнаяСсылка);
#Иначе
			ПерейтиПоНавигационнойСсылке(НавигационнаяСсылка);
#КонецЕсли
			
			Если Оповещение <> Неопределено Тогда 
				ПриложениеЗапущено = Истина;
				ВыполнитьОбработкуОповещения(Оповещение, ПриложениеЗапущено);
			КонецЕсли;
			
		Исключение
			ОткрытьНавигационнуюСсылкуОповеститьОбОшибке(ОписаниеОшибки, Контекст);
		КонецПопытки;
		
	ИначеЕсли ЭтоСсылкаНаСправку(НавигационнаяСсылка) Тогда 
		
		ОткрытьСправку(НавигационнаяСсылка);
		
	Иначе 
		
		Оповещение = Новый ОписаниеОповещения(
			"ОткрытьНавигационнуюСсылкуПослеПроверкиРасширенияРаботыСФайлами", РазборИОбработкаКодовМаркировкиИСМПТКСлужебныйКлиент, Контекст);
		
		ТекстПредложения = РазборИОбработкаКодовМаркировкиИСМПТКСлужебныйКлиентСерверПереопределяемый.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Для открытия ссылки ""%1"" необходимо установить расширение работы с файлами.';
				|en = 'To open the ""%1"" link, install the file system extension.'"),
			НавигационнаяСсылка);
		ПодключитьРасширениеДляРаботыСФайлами(Оповещение, ТекстПредложения, Ложь);
		
	КонецЕсли;
	
	// АПК:534-вкл
	
КонецПроцедуры

Процедура ОткрытьНавигационнуюСсылкуПослеПроверкиРасширенияРаботыСФайлами(РасширениеПодключено, Контекст) Экспорт
	
	// АПК:534-выкл методы безопасного запуска обеспечиваются этой функцией
	
	НавигационнаяСсылка = Контекст.НавигационнаяСсылка;
	
	Если РасширениеПодключено Тогда
		
		Оповещение          = Контекст.Оповещение;
		ДождатьсяЗавершения = (Оповещение <> Неопределено);
		
		Оповещение = Новый ОписаниеОповещения(
			"ОткрытьНавигационнуюСсылкуПослеЗапускаПриложения", ЭтотОбъект, Контекст,
			"ОткрытьНавигационнуюСсылкуПриОбработкеОшибки", 	ЭтотОбъект);
		НачатьЗапускПриложения(Оповещение, НавигационнаяСсылка,, ДождатьсяЗавершения);
		
	Иначе
		ОписаниеОшибки = РазборИОбработкаКодовМаркировкиИСМПТКСлужебныйКлиентСерверПереопределяемый.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Расширение для работы с файлами не установлено, переход по ссылке ""%1"" невозможен.';
				|en = 'The file system extension is not installed. Cannot follow the ""%1"" link.'"),
			НавигационнаяСсылка);
		ОткрытьНавигационнуюСсылкуОповеститьОбОшибке(ОписаниеОшибки, Контекст);
	КонецЕсли;
	
	// АПК:534-вкл
	
КонецПроцедуры

Процедура ОткрытьНавигационнуюСсылкуПослеЗапускаПриложения(КодВозврата, Контекст) Экспорт 
	
	Оповещение = Контекст.Оповещение;
	
	Если Оповещение <> Неопределено Тогда 
		ПриложениеЗапущено = (КодВозврата = 0 Или КодВозврата = Неопределено);
		ВыполнитьОбработкуОповещения(Оповещение, ПриложениеЗапущено);
	КонецЕсли;
	
КонецПроцедуры

Процедура ОткрытьНавигационнуюСсылкуПриОбработкеОшибки(ИнформацияОбОшибке, СтандартнаяОбработка, Контекст) Экспорт 
	
	СтандартнаяОбработка = Ложь;
	ОткрытьНавигационнуюСсылкуОповеститьОбОшибке("", Контекст);
	
КонецПроцедуры

Процедура ОткрытьНавигационнуюСсылкуОповеститьОбОшибке(ОписаниеОшибки, Контекст) Экспорт
	
	Оповещение = Контекст.Оповещение;
	
	Если Оповещение = Неопределено Тогда
		Если Не ПустаяСтрока(ОписаниеОшибки) Тогда 
			ПоказатьПредупреждение(, ОписаниеОшибки);
		КонецЕсли;
	Иначе 
		ПриложениеЗапущено = Ложь;
		ВыполнитьОбработкуОповещения(Оповещение, ПриложениеЗапущено);
	КонецЕсли;
	
КонецПроцедуры

// Проверяет, является ли переданная строка веб ссылкой.
// 
// Параметры:
//  Строка - Строка - переданная ссылка.
//
Функция ЭтоВебСсылка(Строка) Экспорт
	
	Возврат СтрНачинаетсяС(Строка, "http://")  // обычное соединение.
		Или СтрНачинаетсяС(Строка, "https://");// защищенное соединение.
	
КонецФункции

// Проверяет, является ли переданная строка внутренней навигационной ссылкой.
//  
// Параметры:
//  Строка - Строка - навигационная ссылка.
//
Функция ЭтоНавигационнаяСсылка(Строка) Экспорт
	
	Возврат СтрНачинаетсяС(Строка, "e1c:")
		Или СтрНачинаетсяС(Строка, "e1cib/");
	
КонецФункции

// Проверяет, является ли переданная строка ссылкой на встроенную справку.
// 
// Параметры:
//  Строка - Строка - переданная ссылка.
//
Функция ЭтоСсылкаНаСправку(Строка) Экспорт
	
	Возврат СтрНачинаетсяС(Строка, "v8help://");
	
КонецФункции

// Проверяет, является ли переданная строка допустимой ссылкой по белому списку протоколов.
// 
// Параметры:
//  Строка - Строка - переданная ссылка.
//
Функция ЭтоДопустимаяСсылка(Строка) Экспорт
	
	Возврат СтрНачинаетсяС(Строка, "e1c:")
		Или СтрНачинаетсяС(Строка, "e1cib/")
		Или СтрНачинаетсяС(Строка, "e1ccs/")
		Или СтрНачинаетсяС(Строка, "v8help:")
		Или СтрНачинаетсяС(Строка, "http:")
		Или СтрНачинаетсяС(Строка, "https:")
		Или СтрНачинаетсяС(Строка, "mailto:")
		Или СтрНачинаетсяС(Строка, "tel:")
		Или СтрНачинаетсяС(Строка, "skype:");
	
КонецФункции

#КонецОбласти

#Область РаботаСФайлами

// Предлагает пользователю установить расширение работы с файлами в веб-клиенте.
// Предназначена для использования в начале участков кода, в которых ведется работа с файлами.
//
// Параметры:
//  ОписаниеОповещенияОЗакрытии - ОписаниеОповещения - описание процедуры, которая будет вызвана после закрытия
//          формы со следующими параметрами:
//    - РасширениеПодключено - Булево - Истина, если расширение было подключено.
//    - ДополнительныеПараметры - Произвольный - параметры, заданные в ОписаниеОповещенияОЗакрытии.
//  ТекстПредложения - Строка - текст сообщения. Если не указан, то выводится текст по умолчанию.
//  ВозможноПродолжениеБезУстановки - Булево - если Истина, будет показана кнопка ПродолжитьБезУстановки,
//          если Ложь, будет показана кнопка Отмена.
//
// Пример:
//
//  Оповещение = Новый ОписаниеОповещения("ПечатьДокументаЗавершение", ЭтотОбъект);
//  ТекстСообщения = НСтр("ru = 'Для печати документа необходимо установить расширение работы с файлами.'");
//  ФайловаяСистемаКлиент.ПодключитьРасширениеДляРаботыСФайлами(Оповещение, ТекстСообщения);
//
//  Процедура ПечатьДокументаЗавершение(РасширениеПодключено, ДополнительныеПараметры) Экспорт
//    Если РасширениеПодключено Тогда
//     // код печати документа, рассчитывающий на то, что расширение подключено.
//     // ...
//    Иначе
//     // код печати документа, который работает без подключенного расширения.
//     // ...
//    КонецЕсли;
//
Процедура ПодключитьРасширениеДляРаботыСФайлами(
		ОписаниеОповещенияОЗакрытии, 
		ТекстПредложения = "",
		ВозможноПродолжениеБезУстановки = Истина) Экспорт
	
	ОписаниеОповещенияЗавершение = Новый ОписаниеОповещения(
		"НачатьПодключениеРасширенияРаботыСФайламиПриОтветеНаВопросОбУстановке", РазборИОбработкаКодовМаркировкиИСМПТКСлужебныйКлиент,
		ОписаниеОповещенияОЗакрытии);
	
#Если Не ВебКлиент Тогда
	// В мобильном, тонком и толстом клиентах расширение подключено всегда.
	ВыполнитьОбработкуОповещения(ОписаниеОповещенияЗавершение, "ПодключениеНеТребуется");
	Возврат;
#КонецЕсли
	
	Контекст = Новый Структура;
	Контекст.Вставить("ОписаниеОповещенияЗавершение", ОписаниеОповещенияЗавершение);
	Контекст.Вставить("ТекстПредложения",             ТекстПредложения);
	Контекст.Вставить("ВозможноПродолжениеБезУстановки", ВозможноПродолжениеБезУстановки);
	
	Оповещение = Новый ОписаниеОповещения(
		"НачатьПодключениеРасширенияРаботыСФайламиПриУстановкеРасширения", РазборИОбработкаКодовМаркировкиИСМПТКСлужебныйКлиент, Контекст);
	НачатьПодключениеРасширенияРаботыСФайлами(Оповещение);
	
КонецПроцедуры

// Продолжение процедуры ФайловаяСистемаКлиент.НачатьПодключениеРасширенияРаботыСФайлами.
Процедура НачатьПодключениеРасширенияРаботыСФайламиПриУстановкеРасширения(Подключено, Контекст) Экспорт
	
	// Если расширение и так уже подключено, незачем про него спрашивать.
	Если Подключено Тогда
		ВыполнитьОбработкуОповещения(Контекст.ОписаниеОповещенияЗавершение, "ПодключениеНеТребуется");
		Возврат;
	КонецЕсли;
	
	// В веб клиенте под MacOS расширение не доступно.
	Если РазборИОбработкаКодовМаркировкиИСМПТКСлужебныйКлиентПереопределяемый.ЭтоOSXКлиент() Тогда
		ВыполнитьОбработкуОповещения(Контекст.ОписаниеОповещенияЗавершение);
		Возврат;
	КонецЕсли;
	
	ИмяПараметра = "СтандартныеПодсистемы.ПредлагатьУстановкуРасширенияРаботыСФайлами";
	ПервоеОбращениеЗаСеанс = ПараметрыПриложения[ИмяПараметра] = Неопределено;
	Если ПараметрыПриложения[ИмяПараметра] = Неопределено Тогда
		ПараметрыПриложения.Вставить(ИмяПараметра, ПредлагатьУстановкуРасширенияРаботыСФайлами());
	КонецЕсли;
	
	ПредлагатьУстановкуРасширенияРаботыСФайлами = ПараметрыПриложения[ИмяПараметра] Или ПервоеОбращениеЗаСеанс;
	Если Контекст.ВозможноПродолжениеБезУстановки И Не ПредлагатьУстановкуРасширенияРаботыСФайлами Тогда
		
		ВыполнитьОбработкуОповещения(Контекст.ОписаниеОповещенияЗавершение);
		
	Иначе 
		
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("ТекстПредложения", Контекст.ТекстПредложения);
		ПараметрыФормы.Вставить("ВозможноПродолжениеБезУстановки", Контекст.ВозможноПродолжениеБезУстановки);
		ОткрытьФорму(
			"ОбщаяФорма.ВопросОбУстановкеРасширенияРаботыСФайлами", 
			ПараметрыФормы,,,,, 
			Контекст.ОписаниеОповещенияЗавершение);
		
	КонецЕсли;
	
КонецПроцедуры

// Продолжение процедуры ФайловаяСистемаКлиент.НачатьПодключениеРасширенияРаботыСФайлами.
Процедура НачатьПодключениеРасширенияРаботыСФайламиПриОтветеНаВопросОбУстановке(Действие, ОповещениеОЗакрытии) Экспорт
	
	РасширениеПодключено = (Действие = "РасширениеПодключено" Или Действие = "ПодключениеНеТребуется");
	
#Если ВебКлиент Тогда
	Если Действие = "БольшеНеПредлагать"
		Или Действие = "РасширениеПодключено" Тогда
		
		СистемнаяИнформация = Новый СистемнаяИнформация();
		ИдентификаторКлиента = СистемнаяИнформация.ИдентификаторКлиента;
		ПараметрыПриложения["СтандартныеПодсистемы.ПредлагатьУстановкуРасширенияРаботыСФайлами"] = Ложь;
		ОбщегоНазначенияВызовСервера.ХранилищеОбщихНастроекСохранить("НастройкиПрограммы/ПредлагатьУстановкуРасширенияРаботыСФайлами", ИдентификаторКлиента, Ложь);
		
	КонецЕсли;
#КонецЕсли
	
	ВыполнитьОбработкуОповещения(ОповещениеОЗакрытии, РасширениеПодключено);
	
КонецПроцедуры

// Продолжение процедуры ФайловаяСистемаКлиент.НачатьПодключениеРасширенияРаботыСФайлами.
Функция ПредлагатьУстановкуРасширенияРаботыСФайлами()
	
	СистемнаяИнформация = Новый СистемнаяИнформация();
	ИдентификаторКлиента = СистемнаяИнформация.ИдентификаторКлиента;
	Возврат ОбщегоНазначенияВызовСервера.ХранилищеОбщихНастроекЗагрузить("НастройкиПрограммы/ПредлагатьУстановкуРасширенияРаботыСФайлами", ИдентификаторКлиента, Истина);
	
КонецФункции

#Область МобильноеПриложение

Процедура МобильноеПриложениеЗагрузитьТоварыОбработкаВыбораОбщая(Форма, Элемент, Параметры, НеСообщатьОбОтмене = Ложь) Экспорт
	
	Если Элемент <> Неопределено Тогда
		
		МассивОшибок = Новый Массив();
		СведенияОВыбранныхДокументах = Новый Массив();
		НужноЗагружать = Ложь;
		ОбщееКоличество = 0;
		
		Для Каждого Строка Из Элемент Цикл
			
			Если Строка.Пометка = Истина Тогда
				НужноЗагружать = Истина;
				ОбщееКоличество = ОбщееКоличество + 1;
				ЗагрузитьТоварыИзМобильногоПриложения(Строка.Значение, Строка.Представление, СведенияОВыбранныхДокументах);
			КонецЕсли;
			
		КонецЦикла;
		
		Если НужноЗагружать Тогда
			
			Если Не ОбщееКоличество = 1 Тогда
				Для Каждого СтруткураДанных Из СведенияОВыбранныхДокументах Цикл
					СтруткураДанных.ОбщееКоличество = ОбщееКоличество;
				КонецЦикла;
			КонецЕсли;	
			ВыполнитьОбработкуПолученныхДанныхМобильноеПриложение(Форма, СведенияОВыбранныхДокументах, МассивОшибок, ОбщееКоличество);
			
		КонецЕсли;
	Иначе
		
		Если Не НеСообщатьОбОтмене Тогда
			ТекстСообщения = НСтр("ru = 'Выбор файла сканирования из мобильного приложения отменен. Процесс загрузки данных прерван.'");
			ИнтеграцияИСМПТККлиентСерверПереопределяемый.СообщитьПользователю(ТекстСообщения);
		КонецЕсли;
		
	КонецЕсли;	
	
КонецПроцедуры

Процедура ЗагрузитьТоварыИзМобильногоПриложения(Номер, Представление = "", СведенияОВыбранныхДокументах = Неопределено)
	
	Список = РазборИОбработкаКодовМаркировкиИСМПТКСлужебныйВызовСервера.ЗагруженныеДокументыСканированияВыборНаСервере(Номер);  //Перечень КМ из документа
	МассивКодовМаркировки = Новый Массив;
	
	Для Каждого Код Из Список Цикл
		
		Код = Код.Значение;
		Если Не РозничноеВыбытиеИСМПТККлиент.ЭтоСтрокаФорматаBase64(Код) Тогда
		     Код = РазборИОбработкаКодовМаркировкиИСМПТКСлужебныйКлиентСервер.ШтрихкодВBase64(Код);
		КонецЕсли;
		ДанныеШтрихкода = Новый Структура("ШтрихКод, ФорматBase64, Количество", Код, Истина, 1);
		Если Не ИнтеграцияИСМПТККлиентСерверПереопределяемый.ПроверкаФорматаТранспортногоКодаПройденаУспешно(ДанныеШтрихкода, Истина) Тогда
			Продолжить;
		КонецЕсли;
		МассивКодовМаркировки.Добавить(ДанныеШтрихкода);
	КонецЦикла;
	
	ДанныеФайла = Новый Структура("ОбщееКоличество, ИмяДокумента, МассивКодов");
	ДанныеФайла.ОбщееКоличество = 1;
	ДанныеФайла.ИмяДокумента	= Представление;
	ДанныеФайла.МассивКодов		= МассивКодовМаркировки;
	СведенияОВыбранныхДокументах.Добавить(ДанныеФайла);
	
КонецПроцедуры

Процедура ВыполнитьОбработкуПолученныхДанныхМобильноеПриложение(Форма, СведенияОВыбранныхДокументах, МассивОшибок, ОбщееКоличество) 
	
	СтруктураПараметров = Новый Структура("ФормаОбъекта, МассивОшибок, СведенияОВыбранныхДокументах", Форма, МассивОшибок, СведенияОВыбранныхДокументах);
	
	Если ИнтеграцияИСМПТКВызовСервера.ИспользоватьАвтоОпределениеЛогистическихКодовИСМПТК()
		И Не Форма.ИмяФормы = "Обработка.РабочиеМестаИСМПТК.Форма.РабочееМестоПолучениеИнформацииОВладельцеИСостоянииКМ" 
		И Не Форма.ИмяФормы = "Документ.АктПриемаПередачиИСМПТК.Форма.ФормаСверкиВходящихКодовМаркировки" Тогда  //В этом РМ данная проверка и запрос не нужны
		
		ЗавершениеПолучитьДанныеПоГорупповымКодамМаркировки = Новый ОписаниеОповещения("ЗагрузитьКодыМаркировкиИзФайлаЗавершение", ИнтеграцияИСМПТККлиент, СтруктураПараметров);
		Форма.ПолучитьКлючАвторизации(ЗавершениеПолучитьДанныеПоГорупповымКодамМаркировки);
	Иначе
		ИнтеграцияИСМПТККлиент.ЗагрузитьКодыМаркировкиИзФайлаЗавершение(Неопределено, СтруктураПараметров);
	КонецЕсли;

	Если ИнтеграцияИСМПТКВызовСервера.ИспользоватьАвтоПроверкаВалидностиКодаИСМПТК()
		И Не Форма.ИмяФормы = "Обработка.РабочиеМестаИСМПТК.Форма.РабочееМестоПолучениеИнформацииОВладельцеИСостоянииКМ" 
		И Не Форма.ИмяФормы = "Документ.АктПриемаПередачиИСМПТК.Форма.ФормаСверкиВходящихКодовМаркировки" Тогда 
		
		ТокенАвторизацииВрем = Неопределено;
		ЗавершениеПроверитьСостояниеКодовНаСервере = Новый ОписаниеОповещения("ЗавершениеПроверитьСостояниеКодовНаСервере", Форма);
		Форма.ПолучитьКлючАвторизации(ЗавершениеПроверитьСостояниеКодовНаСервере);
		
		Форма.ОповеститьОПроблемеЗапросаВалидностиКМ();
			
	КонецЕсли;
	
КонецПроцедуры

Процедура СообщитьОНевозможностиВыполнитьПроверкуСтатусаКМ(РежимЗапроса) Экспорт

	Если РежимЗапроса = "Ручной" Тогда
		ТекстСообщения = РазборИОбработкаКодовМаркировкиИСМПТКСлужебныйКлиентСервер.ТекстСообщенияНевозможноВыполнитьПроверкуСтатусаКМ_Вручную();
	Иначе	
		ТекстСообщения = РазборИОбработкаКодовМаркировкиИСМПТКСлужебныйКлиентСервер.ТекстСообщенияНевозможноВыполнитьПроверкуСтатусаКМ_ВФоне();
	КонецЕсли;
	ИнтеграцияИСМПТККлиентСерверПереопределяемый.СообщитьПользователю(ТекстСообщения);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

// В процедуре нужно реализовать алгоритм преобразования данных из подсистемы подключаемого оборудования.
//
// Параметры:
//  Параметр - Массив - входящие данные.
//
// Возвращаемое значение:
//  Структура - структура со свойствами:
//   * Штрихкод
//   * Количество
Функция ПреобразоватьДанныеСоСканераВСтруктуру(Параметр) Экспорт
	
	Результат = Новый Структура("Штрихкод,Количество");
	РазборИОбработкаКодовМаркировкиИСМПТКСлужебныйКлиентПереопределяемый.ПреобразоватьДанныеСоСканераВСтруктуру(Результат, Параметр);
	Возврат Результат;
	
КонецФункции

Процедура ВывестиСообщениеОбОшибке(ТекстСообщения) Экспорт
	
	ПараметрыОткрытияФормы = Новый Структура("ТекстОшибки", ТекстСообщения);
	ОткрытьФорму("Обработка.РозничноеВыбытиеМаркированнойПродукцииИСМПТК.Форма.ИнформацияОНевозможностиДобавленияОтсканированного", ПараметрыОткрытияФормы,,,,,, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
		
КонецПроцедуры

Функция ПреобразоватьСтрокуСНедопустимымиСимволами(ПроверяемаяСтрока) Экспорт
	
	ПозицияСимвола = РазборИОбработкаКодовМаркировкиИСМПТКСлужебныйКлиентСервер.НайденНедопустимыйСимволXML(ПроверяемаяСтрока);
	Если Не ПозицияСимвола = 0 Тогда
		НоваяСтрока = Сред(ПроверяемаяСтрока, 1, ПозицияСимвола - 1) + Сред(ПроверяемаяСтрока, ПозицияСимвола + 1);
		ПроверяемаяСтрока = ПреобразоватьСтрокуСНедопустимымиСимволами(НоваяСтрока);
	КонецЕсли;	
	
	Возврат ПроверяемаяСтрока;
	
КонецФункции

Процедура ПолучитьКлючАвторизацииОбщая(СобытиеПослеАвторизации, Организация) Экспорт
	
	СтруктурныеЕдиницы = Новый Соответствие;
	СтруктурныеЕдиницы.Вставить(Организация, "");
	ПараметрыФормы = Новый Структура("СписокСтруктурныхЕдиниц, ТребуетсяВыборСертификата", СтруктурныеЕдиницы, Истина);

	Контейнер = ИнтеграцияИСМПТККлиентСервер.КонтейнерМетодов();
	Контейнер.ПроверитьТокенИВыбратьКлючПриНебходимости(СобытиеПослеАвторизации, ПараметрыФормы, СтруктурныеЕдиницы);
	
КонецПроцедуры