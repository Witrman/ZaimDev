﻿
#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// КлиентЭДО

// Отменяет выполнение длительной операции.
// 
// Параметры:
// 	ИдентификаторЗадания - УникальныйИдентификатор, Строка - идентификатор длительной операции.
//
Процедура ОтменитьВыполнениеЗадания(ИдентификаторЗадания) Экспорт
	
	ДлительныеОперации.ОтменитьВыполнениеЗадания(ИдентификаторЗадания);
	
КонецПроцедуры

// Конец КлиентЭДО

#КонецОбласти

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс


// Определяет, встроена ли в конфигурацию подсистема БСП "Обсуждения" и не подключена ли еще система "Взаимодействия".
// 
// Возвращаемое значение:
// 	Булево - Истина, если обсуждения подключены.
Функция ЕстьВозможностьПодключенияОбсуждений() Экспорт
	
	Результат = Ложь;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.Обсуждения") Тогда
		МодульОбсужденияСлужебный = ОбщегоНазначения.ОбщийМодуль("ОбсужденияСлужебный");
		Если Не МодульОбсужденияСлужебный.Подключены() Тогда
			Результат = Истина;
		КонецЕсли;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Преобразует представление адреса в структуру полей адреса, используемую в форматах ФНС
//
// Параметры:
//   АдресОрганизации - Строка - Представление адреса
//
// Возвращаемое значение:
//  Структура - структура полей адреса:
// * Индекс          - Строка - индекс
// * Регион          - Строка - Регион
// * КодРегиона      - Строка - КодРегиона
// * Район           - Строка - Район
// * Город           - Строка - Город
// * НаселенныйПункт - Строка - НаселенныйПункт
// * Улица           - Строка - Улица
// * Дом             - Строка - Дом
// * Корпус          - Строка - Корпус
// * Квартира        - Строка - Квартира
//
Функция СведенияОбАдресеПоПредставлению(АдресОрганизации) Экспорт
	
	ДанныеОрганизации = Новый Структура;
	ДанныеОрганизации.Вставить("Индекс"         , "");
	ДанныеОрганизации.Вставить("Регион"         , "");
	ДанныеОрганизации.Вставить("КодРегиона"     , "");
	ДанныеОрганизации.Вставить("Район"          , "");
	ДанныеОрганизации.Вставить("Город"          , "");
	ДанныеОрганизации.Вставить("НаселенныйПункт", "");
	ДанныеОрганизации.Вставить("Улица"          , "");
	ДанныеОрганизации.Вставить("Дом"            , "");
	ДанныеОрганизации.Вставить("Корпус"         , "");
	ДанныеОрганизации.Вставить("Квартира"       , "");
	
	Если Не ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.КонтактнаяИнформация") Тогда
		Возврат ДанныеОрганизации;
	КонецЕсли;
	
	МодульУправлениеКонтактнойИнформацией = ОбщегоНазначения.ОбщийМодуль("УправлениеКонтактнойИнформацией");
	МодульРаботаСАдресами = ОбщегоНазначения.ОбщийМодуль("РаботаСАдресами");
	
	ДополнительныеПараметры = Новый Структура("БезПредставлений, ПроверитьАдрес, КодыАдреса", Истина, Истина, Истина);
	ТипыКонтактнойИнформации = Перечисления["ТипыКонтактнойИнформации"];
	АдресXML = МодульУправлениеКонтактнойИнформацией.КонтактнаяИнформацияПоПредставлению(
		АдресОрганизации, ТипыКонтактнойИнформации["Адрес"]);
	АдресСтруктурой = МодульРаботаСАдресами.СведенияОбАдресе(АдресXML, ДополнительныеПараметры);
	
	Если АдресСтруктурой.Свойство("Индекс") Тогда
		ДанныеОрганизации.Индекс = АдресСтруктурой.Индекс;
	КонецЕсли;
	Если АдресСтруктурой.Свойство("Регион") Тогда
		ДанныеОрганизации.Регион = АдресСтруктурой.Регион;
	КонецЕсли;
	Если АдресСтруктурой.Свойство("КодРегиона") Тогда
		ДанныеОрганизации.КодРегиона = АдресСтруктурой.КодРегиона;
	КонецЕсли;
	Если АдресСтруктурой.Свойство("Район") Тогда
		ДанныеОрганизации.Район = АдресСтруктурой.Район;
	КонецЕсли;
	Если АдресСтруктурой.Свойство("Город") Тогда
		ДанныеОрганизации.Город = АдресСтруктурой.Город;
	КонецЕсли;
	Если АдресСтруктурой.Свойство("НаселенныйПункт") Тогда
		ДанныеОрганизации.НаселенныйПункт = АдресСтруктурой.НаселенныйПункт;
	КонецЕсли;
	Если АдресСтруктурой.Свойство("Улица") Тогда
		ДанныеОрганизации.Улица = АдресСтруктурой.Улица;
	КонецЕсли;
	Если АдресСтруктурой.Свойство("Здание") И ЗначениеЗаполнено(АдресСтруктурой.Здание) Тогда
		ДанныеОрганизации.Дом = АдресСтруктурой.Здание.Номер;
	КонецЕсли;
	Если АдресСтруктурой.Свойство("Корпуса") И ЗначениеЗаполнено(АдресСтруктурой.Корпуса) Тогда
		ДанныеОрганизации.Корпус = АдресСтруктурой.Корпуса[0].Номер;
	КонецЕсли;
	Если АдресСтруктурой.Свойство("Помещения") И ЗначениеЗаполнено(АдресСтруктурой.Помещения) Тогда
		ДанныеОрганизации.Квартира = АдресСтруктурой.Помещения[0].Номер;
	КонецЕсли;
	
	Возврат ДанныеОрганизации;
	
КонецФункции

// Преобразует значение адреса  в структуру полей адреса, используемую в форматах ФНС
// 
// Параметры:
// 	ЗначениеАдреса - Строка - строка JSON или XML контактной информации, соответствующая XDTO-пакету КонтактнаяИнформация.
// Возвращаемое значение:
//  Структура - структура полей адреса:
// * Индекс          - Строка - индекс
// * Регион          - Строка - Регион
// * КодРегиона      - Строка - КодРегиона
// * Район           - Строка - Район
// * Город           - Строка - Город
// * НаселенныйПункт - Строка - НаселенныйПункт
// * Улица           - Строка - Улица
// * Дом             - Строка - Дом
// * Корпус          - Строка - Корпус
// * Квартира        - Строка - Квартира
Функция СведенияОбАдресеПоЗначению(Знач ЗначениеАдреса) Экспорт
	
	ДанныеОрганизации = Новый Структура;
	ДанныеОрганизации.Вставить("Индекс"         , "");
	ДанныеОрганизации.Вставить("Регион"         , "");
	ДанныеОрганизации.Вставить("КодРегиона"     , "");
	ДанныеОрганизации.Вставить("Район"          , "");
	ДанныеОрганизации.Вставить("Город"          , "");
	ДанныеОрганизации.Вставить("НаселенныйПункт", "");
	ДанныеОрганизации.Вставить("Улица"          , "");
	ДанныеОрганизации.Вставить("Дом"            , "");
	ДанныеОрганизации.Вставить("Корпус"         , "");
	ДанныеОрганизации.Вставить("Квартира"       , "");
	
	Если Не ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.КонтактнаяИнформация") Тогда
		Возврат ДанныеОрганизации;
	КонецЕсли;
	
	МодульРаботаСАдресами = ОбщегоНазначения.ОбщийМодуль("РаботаСАдресами");
	
	ДополнительныеПараметры = Новый Структура("БезПредставлений, ПроверитьАдрес, КодыАдреса", Истина, Истина, Истина);
	АдресСтруктурой = МодульРаботаСАдресами.СведенияОбАдресе(ЗначениеАдреса, ДополнительныеПараметры);
	
	Если АдресСтруктурой.Свойство("Индекс") Тогда
		ДанныеОрганизации.Индекс = АдресСтруктурой.Индекс;
	КонецЕсли;
	Если АдресСтруктурой.Свойство("Регион") Тогда
		ДанныеОрганизации.Регион = АдресСтруктурой.Регион;
	КонецЕсли;
	Если АдресСтруктурой.Свойство("КодРегиона") Тогда
		ДанныеОрганизации.КодРегиона = АдресСтруктурой.КодРегиона;
	КонецЕсли;
	Если АдресСтруктурой.Свойство("Район") Тогда
		ДанныеОрганизации.Район = АдресСтруктурой.Район;
	КонецЕсли;
	Если АдресСтруктурой.Свойство("Город") Тогда
		ДанныеОрганизации.Город = АдресСтруктурой.Город;
	КонецЕсли;
	Если АдресСтруктурой.Свойство("НаселенныйПункт") Тогда
		ДанныеОрганизации.НаселенныйПункт = АдресСтруктурой.НаселенныйПункт;
	КонецЕсли;
	Если АдресСтруктурой.Свойство("Улица") Тогда
		ДанныеОрганизации.Улица = АдресСтруктурой.Улица;
	КонецЕсли;
	Если АдресСтруктурой.Свойство("Здание") И ЗначениеЗаполнено(АдресСтруктурой.Здание) Тогда
		ДанныеОрганизации.Дом = АдресСтруктурой.Здание.Номер;
	КонецЕсли;
	Если АдресСтруктурой.Свойство("Корпуса") И ЗначениеЗаполнено(АдресСтруктурой.Корпуса) Тогда
		ДанныеОрганизации.Корпус = АдресСтруктурой.Корпуса[0].Номер;
	КонецЕсли;
	Если АдресСтруктурой.Свойство("Помещения") И ЗначениеЗаполнено(АдресСтруктурой.Помещения) Тогда
		ДанныеОрганизации.Квартира = АдресСтруктурой.Помещения[0].Номер;
	КонецЕсли;
	
	Возврат ДанныеОрганизации;
	
КонецФункции

// Получает сведения элемента контактной информации переданного объекта.
// 
// Параметры:
// 	Объект - ЛюбаяСсылка - ссылка на объект, контактную информацию которого нужно получить.
// 	ТипВидКонтактнойИнформацииСтрокой - Строка - строковый идентификатор типа контактной информации или вида.
// Возвращаемое значение:
//  Структура - сведения элемента контактной информации:
// * Значение - Строка - строка JSON или XML контактной информации, соответствующая XDTO-пакету КонтактнаяИнформация.
// * Представление - Строка - представление элемента контактной информации.
Функция КонтактнаяИнформацияОбъекта(Объект, ТипВидКонтактнойИнформацииСтрокой) Экспорт

	Результат = Новый Структура;
	Результат.Вставить("Значение",      "");
	Результат.Вставить("Представление", "");
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.КонтактнаяИнформация") Тогда

		ТипКонтактнойИнформации = Неопределено;
		ВидКонтактнойИнформации = Неопределено;
		
		МодульУправлениеКонтактнойИнформацией = ОбщегоНазначения.ОбщийМодуль("УправлениеКонтактнойИнформацией");

		МетаданныеТипыКонтактнойИнформации = Метаданные.Перечисления.Найти("ТипыКонтактнойИнформации");
		ТипКонтактнойИнформации = МетаданныеТипыКонтактнойИнформации.ЗначенияПеречисления.Найти(
			ТипВидКонтактнойИнформацииСтрокой);
		Если ТипКонтактнойИнформации = Неопределено Тогда
			ВидКонтактнойИнформации = ОбщегоНазначенияБЭД.ПредопределенныйЭлемент("Справочник.ВидыКонтактнойИнформации",
				ТипВидКонтактнойИнформацииСтрокой);
		Иначе
			ТипКонтактнойИнформации = Перечисления["ТипыКонтактнойИнформации"][ТипВидКонтактнойИнформацииСтрокой];
		КонецЕсли;		

		Если ЗначениеЗаполнено(ТипКонтактнойИнформации) ИЛИ ЗначениеЗаполнено(ВидКонтактнойИнформации) Тогда
			МассивОбъектов = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(Объект);
			КонтактнаяИнформацияОбъекта = МодульУправлениеКонтактнойИнформацией.КонтактнаяИнформацияОбъектов(
				МассивОбъектов, ТипКонтактнойИнформации, ВидКонтактнойИнформации, ТекущаяДатаСеанса());

			Если КонтактнаяИнформацияОбъекта.Количество() > 0 Тогда
				ЗаполнитьЗначенияСвойств(Результат, КонтактнаяИнформацияОбъекта[0]);
			КонецЕсли;

		КонецЕсли;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Проверяет, является ли пользователь недействительным. 
// 
// Параметры:
// 	КонтекстДиагностики - См. ОбработкаНеисправностейБЭД.НовыйКонтекстДиагностики - если передан, в него будет добавлена ошибка.
// Возвращаемое значение:
// 	Булево - Истина, если пользователь является недействительным.
Функция ПользовательНедействителен(КонтекстДиагностики = Неопределено) Экспорт
	
	ПользовательНедействителен = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(
		Пользователи.ТекущийПользователь(), "Недействителен");
	
	Если ПользовательНедействителен И КонтекстДиагностики <> Неопределено Тогда
		
		ТекстСообщения = НСтр("ru = 'Выполнение операции недоступно для недействительного пользователя'");
		Ошибка = ОбработкаНеисправностейБЭД.НоваяОшибка(НСтр("ru = 'Обмен с контрагентами'"),
			ИнтеграцияБСПБЭДСлужебныйКлиентСервер.ВидОшибкиНедействительныйПользователь(), ТекстСообщения, ТекстСообщения);
		ОбработкаНеисправностейБЭД.ДобавитьОшибку(КонтекстДиагностики, Ошибка, ОбщегоНазначенияБЭДКлиентСервер.ПодсистемыБЭД().ЭлектронноеВзаимодействие);
	КонецЕсли;
	
	Возврат ПользовательНедействителен;
	
КонецФункции

// Возвращает пустую ссылку справочника Пользователи.
// 
// Возвращаемое значение:
// 	СправочникСсылка.Пользователи - значение ссылки.
Функция ПустаяСсылкаНаПользователя() Экспорт
	Возврат Справочники.Пользователи.ПустаяСсылка();
КонецФункции

// Возвращает пустую ссылку справочника ИдентификаторыОбъектовМетаданных.
// 
// Возвращаемое значение:
// 	СправочникСсылка.ИдентификаторыОбъектовМетаданных - значение ссылки.
Функция ПустойИдентификаторОбъектаМетаданных() Экспорт
	Возврат Справочники.ИдентификаторыОбъектовМетаданных.ПустаяСсылка();
КонецФункции

// Возвращает описание типа, в которое включен справочник идентификаторов объектов метаданных.
// 
// Возвращаемое значение:
// 	ОписаниеТипов - описание типов.
Функция ОписаниеТипаИдентификатораОбъектаМетаданных() Экспорт
	Возврат Новый ОписаниеТипов("СправочникСсылка.ИдентификаторыОбъектовМетаданных");
КонецФункции

// Преобразует номер к виду, допустимому для печати.
// 
// Параметры:
// 	Номер - Строка - номер в исходном виде.
// Возвращаемое значение:
//  Строка - номер, готовый к печати.
Функция ПредставлениеНомераОбъектаУчета(Номер) Экспорт
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ПрефиксацияОбъектов") Тогда
		МодульПрефиксацияОбъектовКлиентСервер = ОбщегоНазначения.ОбщийМодуль("ПрефиксацияОбъектовКлиентСервер");
		Возврат МодульПрефиксацияОбъектовКлиентСервер.НомерНаПечать(Номер);
	КонецЕсли;
	
	Возврат Номер;
	
КонецФункции

// Возвращает таблицу команд печати, которые имеют менеджеры.
// 
// Параметры:
// 	ОбъектМетаданных - ОбъектМетаданных - объект метаданных, по которому нужно получить команды печати.
// Возвращаемое значение:
// 	ТаблицаЗначений - см. УправлениеПечатью.КомандыПечатиОбъекта.
Функция КомандыПечатиСМенеджерамиПечати(ОбъектМетаданных) Экспорт

	Если УправлениеПечатью.ИсточникиКомандПечати().Найти(ОбъектМетаданных) = Неопределено Тогда
		Возврат УправлениеПечатью.СоздатьКоллекциюКомандПечати();
	КонецЕсли;		

	КомандыПечати = УправлениеПечатью.КомандыПечатиОбъекта(ОбъектМетаданных);
	
	ДоступныеКомандыПечати = КомандыПечати.Скопировать();
	ДоступныеКомандыПечати.Очистить();
	
	Для Каждого КомандаПечати Из КомандыПечати Цикл
		Если ЗначениеЗаполнено(КомандаПечати.МенеджерПечати) Тогда
			ДоступнаяКомандПечати = ДоступныеКомандыПечати.Добавить();
			ЗаполнитьЗначенияСвойств(ДоступнаяКомандПечати, КомандаПечати);
		КонецЕсли;
	КонецЦикла;
	
	Возврат ДоступныеКомандыПечати;
	
КонецФункции

// Возвращает данные валюты по классификатору ОКВ.
// 
// Параметры:
// 	КодВалюты - Строка
// Возвращаемое значение:
// 	Структура - данные валюты:
// * КодВалютыЦифровой - Строка 
// * КодВалютыБуквенный - Строка 
// * Наименование - Строка
//  Неопределено - возвращается в случае, если не удалось получить данные классификатора. 
Функция ДанныеВалютыПоКлассификатору(КодВалюты) Экспорт

	Результат = Неопределено;
	
	ДанныеКлассификатора = ИнтеграцияБСПБЭДПовтИсп.ДанныеКлассификатораВалют();
	Если ДанныеКлассификатора <> Неопределено И ДанныеКлассификатора.Количество() Тогда
		СтрокаВалюты = ДанныеКлассификатора.Найти(КодВалюты, "КодВалютыЦифровой");
		
		Если СтрокаВалюты <> Неопределено Тогда
			Результат = Новый Структура("КодВалютыЦифровой, КодВалютыБуквенный, Наименование");
			ЗаполнитьЗначенияСвойств(Результат, СтрокаВалюты);
		КонецЕсли;
	КонецЕсли;
	
	Возврат Результат;

КонецФункции

// Возвращает индекс картинки коллекции "КоллекцияПиктограммФайлов" по переданному расширению.
// 
// Параметры:
// 	РасширениеФайла - Строка - расширение файла включая точку.
// Возвращаемое значение:
// 	Число - индекс картинки коллекции
Функция ИндексПиктограммыФайла(РасширениеФайла) Экспорт
	Возврат ИнтеграцияБСПБЭДСлужебныйКлиентСервер.ИндексПиктограммыФайла(РасширениеФайла);		
КонецФункции

// Возвращает список объектов метаданных, в которых внедрена подсистема Печать.
//
// Возвращаемое значение:
//  Массив - список из элементов типа ОбъектМетаданных.
//
Функция ИсточникиКомандПечати() Экспорт
	
	Источники = Новый Массив;
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.Печать") Тогда
		МодульУправлениеПечатью = ОбщегоНазначения.ОбщийМодуль("УправлениеПечатью");
		Источники = МодульУправлениеПечатью.ИсточникиКомандПечати()
	КонецЕсли;
	
	Возврат Источники;
	
КонецФункции

#КонецОбласти

