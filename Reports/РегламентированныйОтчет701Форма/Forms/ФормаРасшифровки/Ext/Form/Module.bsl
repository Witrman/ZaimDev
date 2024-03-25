﻿
&НаКлиенте
Перем ПараметрыОбработчикаОжидания;

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
		                  
	СхемаКомпоновкиДанных = Параметры.СхемаКомпоновкиДанных;
	ТаблицаРасшифровкиНалогаНаТранспорт = Параметры.ТаблицаРасшифровкиНалогаНаТранспорт;
	КомпоновщикНастроек.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(СхемаКомпоновкиДанных));
	КомпоновщикНастроек.Восстановить(); 
				
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ОбновитьТекстЗаголовка(ЭтаФорма);
	
	ИБФайловая = СтандартныеПодсистемыКлиентПовтИсп.ПараметрыРаботыКлиента().ИнформационнаяБазаФайловая;
	ПодключитьОбработчикОжидания = Не ИБФайловая И ЗначениеЗаполнено(ИдентификаторЗадания);
	Если ПодключитьОбработчикОжидания Тогда		
		ДлительныеОперацииКлиент.ИнициализироватьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
		ПодключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеЗадания", 1, Истина);
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "ФормированиеОтчета");
	КонецЕсли;
	
	БухгалтерскиеОтчетыКлиент.ПриОткрытии(ЭтаФорма, Отказ);
	
	РезультатВыполнения = СформироватьОтчетНаСервере();
	Если Не РезультатВыполнения.ЗаданиеВыполнено Тогда
		ДлительныеОперацииКлиент.ИнициализироватьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
		ПодключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеЗадания", 1, Истина);
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "ФормированиеОтчета");
	КонецЕсли;
	
	Если РезультатВыполнения.Свойство("ОтказПроверкиЗаполнения") Тогда
		ПоказатьНастройки("");
	Иначе	
		ПодключитьОбработчикОжидания("Подключаемый_ЗакрытьНастройки", 0.1, Истина);
	КонецЕсли;
		
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	БухгалтерскиеОтчетыКлиент.ПередЗакрытием(ЭтаФорма, Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	Если ЗавершениеРаботы Тогда
		Возврат;	
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОтменитьВыполнениеЗадания();
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

&НаКлиенте
Процедура МакетОформленияПриИзменении(Элемент)
	
	БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметрВывода(КомпоновщикНастроек.Настройки, "МакетОформления", МакетОформления);
	
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ПОЛЯ ТАБЛИЧНОГО ДОКУМЕНТА

&НаКлиенте
Процедура РезультатПриАктивизацииОбласти(Элемент)
	
	Если ТипЗнч(Результат.ВыделенныеОбласти) = Тип("ВыделенныеОбластиТабличногоДокумента") Тогда
		ИнтервалОжидания = ?(ПолучитьСкоростьКлиентскогоСоединения() = СкоростьКлиентскогоСоединения.Низкая, 1, 0.2);
		ПодключитьОбработчикОжидания("Подключаемый_РезультатПриАктивизацииОбластиПодключаемый", ИнтервалОжидания, Истина);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура РезультатОбработкаРасшифровки(Элемент, Расшифровка, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура РезультатОбработкаДополнительнойРасшифровки(Элемент, Расшифровка, СтандартнаяОбработка)
	
	// Не будем обрабатывать нажатие на правую кнопку мыши.
	// Покажем стандартное контекстное меню ячейки табличного документа.
	Расшифровка = Неопределено;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ТАБЛИЦЫ ФОРМЫ ГРУППИРОВКА

&НаКлиенте
Процедура ГруппировкаПриИзменении(Элемент)

	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ГруппировкаПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	БухгалтерскиеОтчетыКлиент.ГруппировкаПередНачаломДобавления(ЭтаФорма, Элемент, Отказ, Копирование, Родитель, Группа);  
	
КонецПроцедуры

&НаКлиенте
Процедура ГруппировкаПередНачаломИзменения(Элемент, Отказ)
	
	БухгалтерскиеОтчетыКлиент.ГруппировкаПередНачаломИзменения(ЭтаФорма, Элемент, Отказ);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ТАБЛИЦЫ ФОРМЫ ОТБОРЫ

&НаКлиенте
Процедура ОтборыПриИзменении(Элемент)
	
	БухгалтерскиеОтчетыКлиент.ОтборыПриИзменении(ЭтаФорма, Элемент, Ложь);
	
	ОбновитьТекстЗаголовка(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборыПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	БухгалтерскиеОтчетыКлиент.ОтборыПередНачаломДобавления(ЭтаФорма, Элемент, Отказ, Копирование, Родитель, Группа);

КонецПроцедуры

&НаКлиенте
Процедура ОтборыПередНачаломИзменения(Элемент, Отказ)
	
	БухгалтерскиеОтчетыКлиент.ОтборыПередНачаломИзменения(ЭтаФорма, Элемент, Отказ);	
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборыПравоеЗначениеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СписокПараметров = ПолучитьПараметрыВыбораЗначенияОтбора();
	БухгалтерскиеОтчетыКлиент.ОтборыПравоеЗначениеНачалоВыбора(ЭтаФорма, Элемент, ДанныеВыбора, СтандартнаяОбработка, СписокПараметров);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ТАБЛИЦЫ ФОРМЫ ДОПОЛНИТЕЛЬНЫЕПОЛЯ

&НаКлиенте
Процедура РазмещениеДополнительныхПолейПриИзменении(Элемент)
	
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ДополнительныеПоляПриИзменении(Элемент)
	
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ДополнительныеПоляПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	БухгалтерскиеОтчетыКлиент.ДополнительныеПоляПередНачаломДобавления(ЭтаФорма, Элемент, Отказ, Копирование, Родитель, Группа);
	
КонецПроцедуры

&НаКлиенте
Процедура ДополнительныеПоляПередНачаломИзменения(Элемент, Отказ)
	
	БухгалтерскиеОтчетыКлиент.ДополнительныеПоляПередНачаломИзменения(ЭтаФорма, Элемент, Отказ);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ТАБЛИЦЫ ФОРМЫ СОРТИРОВКА

&НаКлиенте
Процедура СортировкаПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	БухгалтерскиеОтчетыКлиент.СортировкаПередНачаломДобавления(ЭтаФорма, Элемент, Отказ, Копирование, Родитель, Группа);
	
КонецПроцедуры

&НаКлиенте
Процедура СортировкаПередНачаломИзменения(Элемент, Отказ)
	
	БухгалтерскиеОтчетыКлиент.СортировкаПередНачаломИзменения(ЭтаФорма, Элемент, Отказ);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура ЗакрытьНастройки(Команда)
	
	Элементы.Сформировать.КнопкаПоУмолчанию = Истина;
	ПодключитьОбработчикОжидания("Подключаемый_ЗакрытьНастройки", 0.1, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьНастройки(Команда)
	
	Элементы.ПрименитьНастройки.КнопкаПоУмолчанию = Истина;
	Элементы.РазделыОтчета.ТекущаяСтраница = Элементы.НастройкиОтчета;
	
КонецПроцедуры

&НаКлиенте
Процедура СформироватьОтчет(Команда)
	
	ОчиститьСообщения();
	
	ОтключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеЗадания");
	
	РезультатВыполнения = СформироватьОтчетНаСервере();
	Если Не РезультатВыполнения.ЗаданиеВыполнено Тогда
		ДлительныеОперацииКлиент.ИнициализироватьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
		ПодключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеЗадания", 1, Истина);
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "ФормированиеОтчета");
	КонецЕсли;
	
	Если РезультатВыполнения.Свойство("ОтказПроверкиЗаполнения") Тогда
		ПоказатьНастройки("");
	Иначе	
		ПодключитьОбработчикОжидания("Подключаемый_ЗакрытьНастройки", 0.1, Истина);
	КонецЕсли;
		
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаКлиентеНаСервереБезКонтекста
Процедура ОбновитьТекстЗаголовка(Форма)
	
	Отчет = Форма.Отчет;
	Форма.Заголовок = НСтр("ru = 'Расшифровка формы 701.00 - Расчет текущих платежей по налогу на транспортные средства'");

КонецПроцедуры

&НаСервереБезКонтекста
Функция ЗаданиеВыполнено(ИдентификаторЗадания)
	
	Возврат ДлительныеОперации.ЗаданиеВыполнено(ИдентификаторЗадания);
	
КонецФункции

&НаСервере
Процедура ОтменитьВыполнениеЗадания()
	
	ДлительныеОперации.ОтменитьВыполнениеЗадания(ИдентификаторЗадания);
	
КонецПроцедуры

&НаСервере
Процедура ВычислитьСуммуВыделенныхЯчеекТабличногоДокументаВКонтекстеНаСервере()
	
	ПолеСумма = БухгалтерскиеОтчетыВызовСервера.ВычислитьСуммуВыделенныхЯчеекТабличногоДокумента(
		Результат, КэшВыделеннойОбласти);
	
КонецПроцедуры

&НаСервере
Функция СформироватьОтчетНаСервере() Экспорт
	
	Если Не ПроверитьЗаполнение() Тогда
		Возврат Новый Структура("ЗаданиеВыполнено", Истина);
	КонецЕсли;
	
	ИБФайловая = ОбщегоНазначения.ИнформационнаяБазаФайловая();
	
	ДлительныеОперации.ОтменитьВыполнениеЗадания(ИдентификаторЗадания);
	
	ИдентификаторЗадания = Неопределено;
	
	ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеИспользовать");
	
	ПараметрыОтчета = ПодготовитьПараметрыОтчета();
	
	АдресХранилища = ПоместитьВоВременноеХранилище(Неопределено, УникальныйИдентификатор);
	БухгалтерскиеОтчетыВызовСервера.СформироватьОтчет(ПараметрыОтчета, АдресХранилища);
	РезультатВыполнения = Новый Структура("ЗаданиеВыполнено", Истина);
	
	Если РезультатВыполнения.ЗаданиеВыполнено Тогда
		ЗагрузитьПодготовленныеДанные();
	КонецЕсли;
	
	Элементы.Сформировать.КнопкаПоУмолчанию = Истина;
	
	Возврат РезультатВыполнения;
	
КонецФункции

&НаСервере
Функция ПодготовитьПараметрыОтчета()
	
	ЗначениеСхемаКомпоновкиДанных = ПолучитьИзВременногоХранилища(СхемаКомпоновкиДанных);
	
	ПараметрыОтчета = Новый Структура;
	ПараметрыОтчета.Вставить("ВыводитьЗаголовок"                  , Ложь);
	ПараметрыОтчета.Вставить("ДанныеРасшифровки"                  , "");
	ПараметрыОтчета.Вставить("МакетОформления"                    , МакетОформления);	
	ПараметрыОтчета.Вставить("СхемаКомпоновкиДанных"              , ЗначениеСхемаКомпоновкиДанных);
	ПараметрыОтчета.Вставить("ИдентификаторОтчета"                , БухгалтерскиеОтчетыКлиентСервер.ПолучитьИдентификаторОбъекта(ЭтаФорма));
	ПараметрыОтчета.Вставить("НастройкиКомпоновкиДанных"          , ЗначениеСхемаКомпоновкиДанных.ВариантыНастроек.Основной.Настройки);
	ПараметрыОтчета.Вставить("ОтчетОбъект"                        , РеквизитФормыВЗначение("Отчет"));
	ПараметрыОтчета.Вставить("ТаблицаРасшифровкиНалогаНаТранспорт", ПолучитьИзВременногоХранилища(ТаблицаРасшифровкиНалогаНаТранспорт));
	
	Возврат ПараметрыОтчета;
	
КонецФункции

&НаСервере
Процедура ЗагрузитьПодготовленныеДанные()

	РезультатВыполнения  = ПолучитьИзВременногоХранилища(АдресХранилища);
	Результат            = РезультатВыполнения.Результат;
	ДанныеРасшифровки    = РезультатВыполнения.ДанныеРасшифровки;
	
	ИдентификаторЗадания = Неопределено;
	
	ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеИспользовать");
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_РезультатПриАктивизацииОбластиПодключаемый()
	
	НеобходимоВычислятьНаСервере = Ложь;
	БухгалтерскиеОтчетыКлиент.ВычислитьСуммуВыделенныхЯчеекТабличногоДокумента(
		ПолеСумма, Результат, КэшВыделеннойОбласти, НеобходимоВычислятьНаСервере);
	
	Если НеобходимоВычислятьНаСервере Тогда
		ВычислитьСуммуВыделенныхЯчеекТабличногоДокументаВКонтекстеНаСервере();
	КонецЕсли;
	
	ОтключитьОбработчикОжидания("Подключаемый_РезультатПриАктивизацииОбластиПодключаемый");
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ЗакрытьНастройки()
	
	Элементы.РазделыОтчета.ТекущаяСтраница = Элементы.Отчет;
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПроверитьВыполнениеЗадания()
	
	Попытка
		Если ЗаданиеВыполнено(ИдентификаторЗадания) Тогда 

			ЗагрузитьПодготовленныеДанные();
			ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеИспользовать");
		
		Иначе
			ДлительныеОперацииКлиент.ОбновитьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
			ПодключитьОбработчикОжидания(
				"Подключаемый_ПроверитьВыполнениеЗадания", 
				ПараметрыОбработчикаОжидания.ТекущийИнтервал, 
				Истина);
		КонецЕсли;
	Исключение
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеИспользовать");
		ВызватьИсключение;
	КонецПопытки;
	
КонецПроцедуры

&НаКлиенте
Функция ПолучитьЗапрещенныеПоля(Режим = "") Экспорт
	
	СписокПолей = Новый Массив;
	
	СписокПолей.Добавить("UserFields");
	СписокПолей.Добавить("DataParameters");
	СписокПолей.Добавить("SystemFields");
	
	Если Режим = "Группировка" ИЛИ Режим = "Выбор" Тогда
		СписокПолей.Добавить("Порядок");
		БухгалтерскиеОтчетыКлиент.ДобавитьПоляРесурсовВЗапрещенныеПоля(ЭтаФорма, СписокПолей);
	КонецЕсли;
	
	Возврат Новый ФиксированныйМассив(СписокПолей);
	
КонецФункции

&НаКлиенте
Функция ПолучитьПараметрыВыбораЗначенияОтбора() Экспорт
	
	Возврат Новый Структура;
	
КонецФункции

&НаКлиенте
Процедура ГруппировкаПередНачаломДобавленияЗавершение(РезультатЗакрытия, ДопПараметры) Экспорт
	
	БухгалтерскиеОтчетыКлиент.ГруппировкаПередНачаломДобавленияЗавершение(РезультатЗакрытия, ДопПараметры);
	
КонецПроцедуры

&НаКлиенте
Процедура ГруппировкаПередНачаломИзмененияЗавершение(РезультатЗакрытия, ДопПараметры) Экспорт
	
	БухгалтерскиеОтчетыКлиент.ГруппировкаПередНачаломИзмененияЗавершение(РезультатЗакрытия, ДопПараметры);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборыПередНачаломДобавленияЗавершение(РезультатЗакрытия, ДопПараметры) Экспорт
	
	БухгалтерскиеОтчетыКлиент.ОтборыПередНачаломДобавленияЗавершение(РезультатЗакрытия, ДопПараметры);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборыПередНачаломИзмененияЗавершение(РезультатЗакрытия, ДопПараметры) Экспорт
	
	БухгалтерскиеОтчетыКлиент.ОтборыПередНачаломИзмененияЗавершение(РезультатЗакрытия, ДопПараметры);
	
КонецПроцедуры

&НаКлиенте
Процедура ДополнительныеПоляПередНачаломДобавленияЗавершение(РезультатЗакрытия, ДопПараметры) Экспорт
	
	БухгалтерскиеОтчетыКлиент.ДополнительныеПоляПередНачаломДобавленияЗавершение(РезультатЗакрытия, ДопПараметры);
	
КонецПроцедуры

&НаКлиенте
Процедура ДополнительныеПоляПередНачаломИзмененияЗавершение(РезультатЗакрытия, ДопПараметры) Экспорт
	
	БухгалтерскиеОтчетыКлиент.ДополнительныеПоляПередНачаломИзмененияЗавершение(РезультатЗакрытия, ДопПараметры);
	
КонецПроцедуры

&НаКлиенте
Процедура СортировкаПередНачаломДобавленияЗавершение(РезультатЗакрытия, ДопПараметры) Экспорт
	
	БухгалтерскиеОтчетыКлиент.СортировкаПередНачаломДобавленияЗавершение(РезультатЗакрытия, ДопПараметры);
	
КонецПроцедуры

&НаКлиенте
Процедура СортировкаПередНачаломИзмененияЗавершение(РезультатЗакрытия, ДопПараметры) Экспорт
	
	БухгалтерскиеОтчетыКлиент.СортировкаПередНачаломИзмененияЗавершение(РезультатЗакрытия, ДопПараметры);
	
КонецПроцедуры