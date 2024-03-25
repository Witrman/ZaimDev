﻿// используется для определения необходимости закрытия окна обработки в случае закрытия окна без сохранения значений
&НаКлиенте
Перем ФормаЗакрыта;
// используется для хранения данных параметров документа основания с целью дальнейшего использовнаия в процедурах пересчета табличных частей 
&НаКлиенте
Перем СтруктураДляРасчета;


////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если НЕ (ЗначениеЗаполнено(Параметры.АдресХранилищаТабличнойЧасти)) Тогда
		ТекстСообщения = НСтр("ru='Непосредственное открытие обработки изменения табличной части не предусмотрено. 
				|Для открытия обработки можно воспользоваться командой ""Изменить"" в формах документов'");
		ВызватьИсключение ТекстСообщения;
	КонецЕсли;
	
	//заполним реквизиты формы из переданных параметров
	СписокСвойств = "АдресХранилищаТабличнойЧасти, ИмяТаблицы, СтруктураРеквизитов, СтруктураСвязанныхРеквизитов, ДокументСсылка, ДокументДата, ДокументВалюта,
		|ДокументКурс, ДокументКратность, ДокументСуммаВключаетНДС, ДокументУчитыватьНДС, ДокументНДСВключенВСтоимость";
	ЗаполнитьЗначенияСвойств(ЭтаФорма, Параметры, СписокСвойств);
	
	Если ЗначениеЗаполнено(Параметры.Заголовок) Тогда
		АвтоЗаголовок = Ложь;
		Заголовок = "Обработка табличной части: " + Параметры.Заголовок;
	КонецЕсли;
	
	ВидимыеКолонки.ЗагрузитьЗначения(Параметры.ВидимыеКолонки);
	
	ПодготовитьФормуНаСервере(); 	
	
КонецПроцедуры

 &НаКлиенте
 Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	 	
	Если ФормаЗакрыта Тогда
		Возврат;
	КонецЕсли;

	Если ЗавершениеРаботы Тогда
		Возврат;	
	КонецЕсли;
	
	Если НЕ ФормаЗакрыта И Модифицированность И НЕ ПеренестиВДокумент Тогда
		
		Режим =  РежимДиалогаВопрос.ДаНетОтмена;
		ТекстВопроса = НСтр("ru = 'Перенести изменения в документ?'");
		ДополнительныеПараметры = Новый Структура();
		ДополнительныеПараметры.Вставить("Отказ", Отказ);
		Оповещение = Новый ОписаниеОповещения("ПослеЗакрытияВопросаПередЗакрытием", ЭтотОбъект, ДополнительныеПараметры);
		ПоказатьВопрос(Оповещение, ТекстВопроса, Режим, 0);
		
		Отказ = Истина;
		СтандартнаяОбработка = Ложь;

	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗакрытияВопросаПередЗакрытием(Результат, Параметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Отмена Тогда
		Возврат;
	ИначеЕсли Результат = КодВозвратаДиалога.Да Тогда
		ПеренестиВДокумент = Истина;
		ФормаЗакрыта = Истина;
		Закрыть();
	ИначеЕсли  Результат = КодВозвратаДиалога.Нет Тогда
		ФормаЗакрыта = Истина;
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	Если ЗавершениеРаботы Тогда
		Возврат;	
	КонецЕсли;
	
	ПриЗакрытииФормыНаСервере();

	Если ПеренестиВДокумент Тогда
		
		ПараметрОповещения = Новый Структура;
		ПараметрОповещения.Вставить("ИмяТаблицы"                               , ИмяТаблицы);
		ПараметрОповещения.Вставить("ИдентификаторВызывающейФормы"             , ВладелецФормы.УникальныйИдентификатор);
		ПараметрОповещения.Вставить("АдресОбработаннойТабличнойЧастиВХранилище", АдресХранилищаТабличнойЧасти);
		
		Оповестить("ОбработанаТабличнаяЧасть", ПараметрОповещения , ВладелецФормы);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ФормаЗакрыта = Ложь;
	
	СтруктураДляРасчета = Новый Структура;
	СтруктураДляРасчета.Вставить("ВалютаДокумента", 		ДокументВалюта);
	СтруктураДляРасчета.Вставить("КурсВзаиморасчетов", 		ДокументКурс);
	СтруктураДляРасчета.Вставить("КратностьВзаиморасчетов", ДокументКратность);
	СтруктураДляРасчета.Вставить("УчитыватьНДС",			ДокументУчитыватьНДС);
	СтруктураДляРасчета.Вставить("СуммаВключаетНДС", 		ДокументСуммаВключаетНДС);
	СтруктураДляРасчета.Вставить("НДСВключенВСтоимость",    ДокументНДСВключенВСтоимость);
	СтруктураДляРасчета.Вставить("Дата", 		            ДокументДата);
	
	ПриИзмененииТекущегоДействия();
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура ПеренестиВДокумент(Команда)
	
	ПеренестиВДокумент = Истина;
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьДействие(Команда)

	Если ТекущееДействие = "ДобавитьИзДокумента" Тогда   		
		
		Если НЕ ЗначениеЗаполнено(ВариантЗначения) Тогда
			ТекстСообщения = НСтр("ru = 'Не указан документ, из которого добавляются строки списка'");
			ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения, , "ВариантЗначения");
			Возврат;
		КонецЕсли;
		
		ДобавитьДанныеИзДокумента(ВариантЗначения, СтруктураДляРасчета);
		
	ИначеЕсли ТекущееДействие = "УстановитьРеквизит" Тогда
		
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("ИмяДокумента"       , ИмяДокумента);
		ПараметрыФормы.Вставить("ИмяТаблицы"         , ИмяТаблицы);
		ПараметрыФормы.Вставить("СтруктураРеквизитов", СтруктураРеквизитов);
		ПараметрыФормы.Вставить("СтруктураСвязанныхРеквизитов", СтруктураСвязанныхРеквизитов);
		
		ДополнительныеПараметры = Новый Структура();
		Оповещение = Новый ОписаниеОповещения("УстановитьРеквизитЗавершение", ЭтаФорма, ДополнительныеПараметры);

		ОткрытьФорму("Обработка.ОбработкаТабличнойЧастиДокументов.Форма.ФормаВыбораРеквизита", ПараметрыФормы,
			ЭтаФорма,,,, Оповещение, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
		
	ИначеЕсли ТекущееДействие = "РаспределитьСуммуПоГрафе" Тогда
			
		Отказ = Ложь;
		
		Если ВариантЗначения = 0 Тогда
			ТекстСообщения = НСтр("ru = 'Не указана сумма для распределения! Действие не может быть выполнено.'");
			ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения);
			Отказ = Истина;
		КонецЕсли;
		
		Если НЕ ЗначениеЗаполнено(СписокГрафКРаспределению)
			ИЛИ НЕ ЗначениеЗаполнено(СписокБазовыхГраф) Тогда
			ТекстСообщения = НСтр("ru = 'Указаны не все графы по которым будет происходить распределение! Действие не может быть выполнено.'");
			ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения);
			Отказ = Истина;
		КонецЕсли;
		
		Если Отказ Тогда
			Возврат;
		КонецЕсли;
		
		РаспределитьСуммуПоКолонке(СокрЛП(СписокГрафКРаспределению), СокрЛП(СписокБазовыхГраф), ВариантЗначения);

	ИначеЕсли ТекущееДействие = "ИзменитьЦену" Тогда    	

		ИзменитьЦену();	
		
	ИначеЕсли ТекущееДействие = "РаспределитьСуммуПоКоличеству" Тогда
		
		 //Сумма должна быть не нулевой.
		Если НЕ ЗначениеЗаполнено(ВариантЗначения) Тогда
			ТекстПредупреждения = НСтр("ru = 'Не задана сумма для распределения!'");
			ПоказатьПредупреждение( , ТекстПредупреждения,, Заголовок);
			ТекущийЭлемент = Элементы.ВариантЗначения;
			Возврат;
		КонецЕсли;

		РаспределитьСуммуПоКолонке("Сумма", "Количество", ВариантЗначения);
	
	ИначеЕсли ТекущееДействие = "РаспределитьСуммуПоСуммам" Тогда    
		
		 //Сумма должна быть не нулевой.
		Если НЕ ЗначениеЗаполнено(ВариантЗначения) Тогда
			ТекстПредупреждения = НСтр("ru = 'Не задана сумма для распределения!'");
			ПоказатьПредупреждение( , ТекстПредупреждения,, Заголовок);
			ТекущийЭлемент = Элементы.ВариантЗначения;
			Возврат;
		КонецЕсли;

		РаспределитьСуммуПоКолонке("Сумма", "Сумма", ВариантЗначения);
	
	ИначеЕсли НЕ ЗначениеЗаполнено(ТекущееДействие) Тогда
		
		ТекстСообщения = НСтр("ru = 'Не указано действие'");
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения, , "ТекущееДействие");
		Возврат;
		
	Иначе
		
		ТекстСообщения = НСтр("ru = 'Действие указано не верно!'");
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения, , "ТекущееДействие");
		Возврат;
		
	КонецЕсли;
	
	Модифицированность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьФлажки(Команда)

	УстановитьПометкуВСтрокахТабличнойЧасти(Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура СнятьФлажки(Команда)

	УстановитьПометкуВСтрокахТабличнойЧасти(Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗакрытьБезПереноса(Команда)

	Модифицированность = Ложь;
	ПеренестиВДокумент = Ложь;
	Закрыть();
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ФОРМЫ

&НаКлиенте
Процедура ТекущееДействиеПриИзменении(Элемент)

	// Установим элементы формы в зависимости от выбранного действия
	ПриИзмененииТекущегоДействия();
	
КонецПроцедуры

&НаКлиенте
Процедура СписокГрафКРаспределениюОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	ЭлементСпискаВыбора = Элемент.СписокВыбора.НайтиПоЗначению(ВыбранноеЗначение);
	Элемент.СписокВыбора.Сдвинуть(ЭлементСпискаВыбора, Элемент.СписокВыбора.Индекс(ЭлементСпискаВыбора)*(-1));
	
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаЦенаПриИзменении(Элемент)

	СтрокаТабличнойЧасти = Элементы.ТабличнаяЧастьДокумента.ТекущиеДанные;
	РассчитатьЦеныИСуммы(СтрокаТабличнойЧасти);

КонецПроцедуры // ТаблицаЦенаПриИзменении()

&НаКлиенте
Процедура ТаблицаСуммаПриИзменении(Элемент)

	СтрокаТабличнойЧасти = Элементы.ТабличнаяЧастьДокумента.ТекущиеДанные;	 
	ПриИзмененииСуммыВТабличнойЧасти(СтрокаТабличнойЧасти);

КонецПроцедуры // ТаблицаСуммаПриИзменении()

&НаКлиенте
Процедура ТаблицаКоличествоПриИзменении(Элемент)

	СтрокаТабличнойЧасти = Элементы.ТабличнаяЧастьДокумента.ТекущиеДанные;	
	ПриИзмененииКоличестваВТабличнойЧасти(СтрокаТабличнойЧасти);

КонецПроцедуры // ТаблицаКоличествоПриИзменении()

&НаКлиенте
Процедура ТаблицаСтавкаНДСПриИзменении(Элемент)

	СтрокаТабличнойЧасти = Элементы.ТабличнаяЧастьДокумента.ТекущиеДанные;	
	РассчитатьСуммуНДСВТабличнойЧасти(СтрокаТабличнойЧасти);

КонецПроцедуры // ТаблицаСтавкаНДСПриИзменении()


////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаСервере
Процедура ПриЗакрытииФормыНаСервере()

	ОбщегоНазначения.ХранилищеОбщихНастроекСохранить("ОбработкаТабличнойЧастиДокументаТекущееДействие", ИмяДокумента, ТекущееДействие);

	Если ПеренестиВДокумент Тогда
		ТаблицаДляПереноса = СформироватьТаблицуДляПереносаВДокумент();
		ПоместитьВоВременноеХранилище(ТаблицаДляПереноса, АдресХранилищаТабличнойЧасти);
	КонецЕсли;
		
КонецПроцедуры

&НаСервере
Процедура ИнициализироватьРеквизитыФормы()
	
	СтруктураТабличнойЧасти = ДокументСсылка[ИмяТаблицы].ВыгрузитьКолонки();
	
	МассивДобавляемыхРеквизитов = Новый Массив;
	ЭлементТаблица = Элементы.Найти("ТабличнаяЧастьДокумента");
	Для Каждого КолонкаТабЧасти Из СтруктураТабличнойЧасти.Колонки Цикл
		КолонкаТабЧастиИмя = КолонкаТабЧасти.Имя;
		Если КолонкаТабЧастиИмя = "НомерСтроки" Тогда
			Продолжить;
		КонецЕсли;
		РеквизитФормы = Новый РеквизитФормы(КолонкаТабЧастиИмя, КолонкаТабЧасти.ТипЗначения, "ТабличнаяЧастьДокумента", КолонкаТабЧасти.Заголовок, Ложь); 
		МассивДобавляемыхРеквизитов.Добавить(РеквизитФормы);
		
		Если КолонкаТабЧастиИмя = "Цена" Тогда
			ЕстьЦена = Истина;
		ИначеЕсли КолонкаТабЧастиИмя = "Количество" Тогда
			ЕстьКоличество = Истина;
		ИначеЕсли КолонкаТабЧастиИмя = "Сумма" Тогда
			ЕстьСумма = Истина;
		ИначеЕсли КолонкаТабЧастиИмя = "СтавкаНДС" И ДокументУчитыватьНДС Тогда
			ЕстьНДС = Истина;
		КонецЕсли;
	КонецЦикла;
	ИзменитьРеквизиты(МассивДобавляемыхРеквизитов);
	
	СписокДействий = Элементы.ТекущееДействие.СписокВыбора;
	СписокДействий.Очистить();
	СписокДействий.Добавить("ДобавитьИзДокумента", НСтр("ru = 'Добавить из документа'"));
	
	ЕстьЧисловыеДанные = Ложь;
	
	ЭлементТаблица = Элементы.Найти("ТабличнаяЧастьДокумента");
	Для Каждого ДобавленныйРеквизит Из МассивДобавляемыхРеквизитов Цикл
		ДобавленныйРеквизитИмя = ДобавленныйРеквизит.Имя;
        НовыйЭлементФормы = Элементы.Добавить("ТабличнаяЧастьДокумента" + ДобавленныйРеквизитИмя, Тип("ПолеФормы"), ЭлементТаблица);
        НовыйЭлементФормы.Вид = ВидПоляФормы.ПолеВвода;
        НовыйЭлементФормы.ПутьКДанным = "ТабличнаяЧастьДокумента." + ДобавленныйРеквизитИмя;
		
		Если ДобавленныйРеквизитИмя = "Цена" Тогда
			НовыйЭлементФормы.УстановитьДействие("ПриИзменении", "ТаблицаЦенаПриИзменении");
			СписокДействий.Добавить("ИзменитьЦену", НСтр("ru = 'Изменить цены на %'"));
		ИначеЕсли ДобавленныйРеквизитИмя = "Сумма" Тогда
			НовыйЭлементФормы.УстановитьДействие("ПриИзменении", "ТаблицаСуммаПриИзменении");
		ИначеЕсли ДобавленныйРеквизитИмя = "Количество" Тогда
			НовыйЭлементФормы.УстановитьДействие("ПриИзменении", "ТаблицаКоличествоПриИзменении");
		ИначеЕсли ДобавленныйРеквизитИмя = "СтавкаНДС" Тогда
			НовыйЭлементФормы.УстановитьДействие("ПриИзменении", "ТаблицаСтавкаНДСПриИзменении");
		КонецЕсли;
		
		ДобавленныйРеквизитТипЗначения = ДобавленныйРеквизит.ТипЗначения;
		Если ДобавленныйРеквизитТипЗначения.СодержитТип(Тип("Число")) И НЕ ДобавленныйРеквизитИмя = "НомерСтроки" Тогда
			ЕстьЧисловыеДанные = Истина;
			Элементы.СписокБазовыхГраф.СписокВыбора.Добавить(ДобавленныйРеквизитИмя, ДобавленныйРеквизит.Заголовок);
			Элементы.СписокГрафКРаспределению.СписокВыбора.Добавить(ДобавленныйРеквизитИмя, ДобавленныйРеквизит.Заголовок);
		КонецЕсли;
	КонецЦикла;
	
	Если ЕстьСумма Тогда
		СписокДействий.Добавить("РаспределитьСуммуПоСуммам", НСтр("ru = 'Распределить сумму по суммам'"));
		Если ЕстьКоличество Тогда
			СписокДействий.Добавить("РаспределитьСуммуПоКоличеству", НСтр("ru = 'Распределить сумму по количеству'"));
		КонецЕсли;
	КонецЕсли;
	
	Если ЕстьЧисловыеДанные Тогда
		СписокДействий.Добавить("РаспределитьСуммуПоГрафе", НСтр("ru = 'Распределить сумму по графе [...]'"));
	КонецЕсли;
	
	Если ЗначениеЗаполнено(СтруктураРеквизитов) Тогда
		СписокДействий.Добавить("УстановитьРеквизит", НСтр("ru = 'Установить реквизит [...]'"));
	КонецЕсли;
	
	ДанныеТабличнойЧасти = ПолучитьИзВременногоХранилища(АдресХранилищаТабличнойЧасти);
	ДанныеТабличнойЧасти.Колонки.Добавить("Пометка", Новый ОписаниеТипов("Булево"));
	ДанныеТабличнойЧасти.ЗаполнитьЗначения(Истина, "Пометка");
	
	ТабличнаяЧастьДокумента.Загрузить(ДанныеТабличнойЧасти);
	
КонецПроцедуры

&НаСервере
Процедура ПодготовитьФормуНаСервере()

	ИнициализироватьРеквизитыФормы();

	ИмяДокумента = ДокументСсылка.Метаданные().Имя;
	//загрузим текущее действие из сохраненных настроек
	ТекущееДействие = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить("ОбработкаТабличнойЧастиДокументаТекущееДействие", ИмяДокумента);
	Если Элементы.ТекущееДействие.СписокВыбора.НайтиПоЗначению(ТекущееДействие) = Неопределено Тогда
		ТекущееДействие = Элементы.ТекущееДействие.СписокВыбора[0].Значение;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриИзмененииТекущегоДействия()
	
	Элементы.ВариантЗначения.Заголовок = НСтр("ru = 'Вариант значения'");
	Элементы.ВариантЗначения.Видимость = Истина;
	Элементы.ВариантЗначения.ОграничениеТипа = Новый ОписаниеТипов();
	Элементы.ГруппаРаспределениеСуммы.Видимость  = Ложь;
	Элементы.ВариантЗначения.РежимВыбораИзСписка = Ложь;

	Если ТекущееДействие = "ДобавитьИзДокумента" Тогда     			
		
		Элементы.ВариантЗначения.Видимость = Истина;
		Элементы.ВариантЗначения.Заголовок = НСтр("ru = 'Документ'");
		
		МассивНужныхТипов = ПолучитьТипыДокументовДляДобавления();
		Элементы.ВариантЗначения.ОграничениеТипа = Новый ОписаниеТипов(МассивНужныхТипов);
		
		ВариантЗначения = Неопределено;
		
	ИначеЕсли ТекущееДействие = "ИзменитьЦену" Тогда       
		
		Элементы.ВариантЗначения.Видимость = Истина;
		Элементы.ВариантЗначения.Заголовок = НСтр("ru = '%'");
		
		Элементы.ВариантЗначения.ОграничениеТипа = Новый ОписаниеТипов("Число", Новый КвалификаторыЧисла(5, 2));
		
		ВариантЗначения = 0;
		
	ИначеЕсли ТекущееДействие = "РаспределитьСуммуПоСуммам" ИЛИ ТекущееДействие = "РаспределитьСуммуПоКоличеству" Тогда      	
	
		Элементы.ВариантЗначения.Видимость = Истина;
		Элементы.ВариантЗначения.Заголовок = НСтр("ru = 'Сумма к распределению'");
		
		Элементы.ВариантЗначения.ОграничениеТипа = Новый ОписаниеТипов("Число", Новый КвалификаторыЧисла(15, 3));
		
		ВариантЗначения = 0;
		
	ИначеЕсли ТекущееДействие = "РаспределитьСуммуПоГрафе" Тогда
		
		Элементы.ВариантЗначения.Видимость = Истина;
		Элементы.ВариантЗначения.Заголовок = НСтр("ru = 'Сумма к распределению'");
		Элементы.ВариантЗначения.ОграничениеТипа = Новый ОписаниеТипов("Число", Новый КвалификаторыЧисла(15, 2));
		
		Элементы.ГруппаРаспределениеСуммы.Видимость = Истина;
		
		ВариантЗначения = 0;
			
	ИначеЕсли ТекущееДействие = "УстановитьРеквизит" Тогда
		
		Элементы.ВариантЗначения.Видимость = Ложь;

	КонецЕсли;

КонецПроцедуры 

&НаСервере
Функция ПолучитьТипыДокументовДляДобавления()

	МассивНужныхТипов = Новый Массив;
	
	Если ТипЗнч(ДокументСсылка) = Тип("ДокументСсылка.СчетФактураВыданный") 
		ИЛИ ТипЗнч(ДокументСсылка) = Тип("ДокументСсылка.СчетФактураПолученный") Тогда
		Для каждого Основание Из ДокументСсылка.Метаданные().ВводитсяНаОсновании Цикл
			Если Основание.ТабличныеЧасти.Найти(ИмяТаблицы) <> Неопределено Тогда
				МассивНужныхТипов.Добавить(Тип("ДокументСсылка." + Основание.Имя));
			КонецЕсли;
		КонецЦикла;
	ИначеЕсли ТипЗнч(ДокументСсылка) = Тип("ДокументСсылка.ЭлектронныйДокументВС") Тогда
		МассивНужныхТипов.Добавить(Тип("ДокументСсылка.ЭлектронныйДокументВС"));
	Иначе
		Для Каждого Документ Из Метаданные.Документы Цикл
			Если Документ.ТабличныеЧасти.Найти(ИмяТаблицы) <> Неопределено Тогда
				МассивНужныхТипов.Добавить(Тип("ДокументСсылка." + Документ.Имя));
				Продолжить;
			КонецЕсли;
			Если Документ.Имя = "Доверенность"
				И (ИмяТаблицы = "НМА" ИЛИ ИмяТаблицы = "ОС" ИЛИ ИмяТаблицы = "Товары" ИЛИ ИмяТаблицы = "Услуги") Тогда
				МассивНужныхТипов.Добавить(Тип("ДокументСсылка." + Документ.Имя));
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;  		
	
	Возврат МассивНужныхТипов;

КонецФункции // ПолучитьТипыДокументовДляДобавления()

&НаКлиенте
Процедура УстановитьПометкуВСтрокахТабличнойЧасти(НоваяПометка)

	Для Каждого СтрокаТабличнойЧасти Из ТабличнаяЧастьДокумента Цикл
		СтрокаТабличнойЧасти.Пометка = НоваяПометка;
	КонецЦикла; 

КонецПроцедуры

&НаКлиенте
Процедура УстановитьРеквизитЗавершение(Результат, Параметры) Экспорт
	
	Если  Результат <> Неопределено Тогда
		Для Каждого СтрокаТаблицыРеквизитов из Результат Цикл
			Если НЕ СтрокаТаблицыРеквизитов.Пометка Тогда
				Продолжить;
			КонецЕсли;	
			УстановитьЗначениеРеквизита(СтрокаТаблицыРеквизитов.ИмяРеквизита, СтрокаТаблицыРеквизитов.Значение, СтрокаТаблицыРеквизитов.Реквизит);			
		КонецЦикла;			
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьЗначениеРеквизита(ИмяРеквизита, ЗначениеРеквизита, ПредставлениеРеквизита)
	
	 //Должно быть выбрано новое значение реквизита
	Если НЕ ЗначениеЗаполнено(ЗначениеРеквизита) Тогда				
		ТекстСообщения = НСтр("ru = 'Не выбрано новое значение реквизита %1!'");
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстСообщения, ПредставлениеРеквизита);
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения);
		Возврат;		
	КонецЕсли; 

	Для Каждого СтрокаТабличнойЧасти Из ТабличнаяЧастьДокумента Цикл
		Если СтрокаТабличнойЧасти.Пометка Тогда
			СтрокаТабличнойЧасти[ИмяРеквизита] = ЗначениеРеквизита;			
			Если ИмяРеквизита = "Количество" Тогда
				ПриИзмененииКоличестваВТабличнойЧасти(СтрокаТабличнойЧасти);
			КонецЕсли;	
			Если ИмяРеквизита = "Цена" Тогда
				РассчитатьЦеныИСуммы(СтрокаТабличнойЧасти);				
			КонецЕсли;	
			Если ИмяРеквизита = "СтавкаНДС" Тогда
				РассчитатьСуммуНДСВТабличнойЧасти(СтрокаТабличнойЧасти);
			КонецЕсли;	
		КонецЕсли; 
	КонецЦикла; 
	
КонецПроцедуры

&НаСервере
Процедура ДобавитьДанныеИзДокумента(ДокументИсточник, СтруктураДляРасчета)
	
	Если НЕ ЗначениеЗаполнено(ДокументИсточник) Тогда
		Возврат;
	КонецЕсли;
	
	МетаданныеДокументаИсточника 	= ДокументИсточник.Метаданные();
	СоответствиеРеквизитов = Новый Структура;
	
	ИмяТаблицыИсточника = ИмяТаблицы;
	
	// заменим соответствие реквизитов для отдельных документов
	Если ИмяДокумента = "ПоступлениеДопРасходов" Тогда
		//в этом документе графа Сумма Называется "СуммаТовара"
		Если МетаданныеДокументаИсточника.Имя = "ГТДИмпорт" Тогда
			СоответствиеРеквизитов.Вставить("ФактурнаяСтоимость", "СуммаТовара");
		ИначеЕсли МетаданныеДокументаИсточника.Имя = "Доверенность" Тогда
			Если ИмяТаблицы = "Товары" Тогда
				СоответствиеРеквизитов.Вставить("НаименованиеТовара", "Номенклатура");
				СоответствиеРеквизитов.Вставить("ЕдиницаПоКлассификатору", "ЕдиницаИзмерения");
				ИмяТаблицыИсточника = "Товары";
			ИначеЕсли ИмяТаблицы = "НМА" Тогда
				СоответствиеРеквизитов.Вставить("НаименованиеТовара", "НематериальныйАктив");
				ИмяТаблицыИсточника = "Товары";
			ИначеЕсли ИмяТаблицы = "ОС" Тогда
				СоответствиеРеквизитов.Вставить("НаименованиеТовара", "ОсновноеСредство");
				ИмяТаблицыИсточника = "Товары";
			КонецЕсли;
		Иначе
			СоответствиеРеквизитов.Вставить("Сумма", "СуммаТовара");
		КонецЕсли;					
	ИначеЕсли ИмяДокумента = "ГТДИмпорт" Тогда
		Если МетаданныеДокументаИсточника.Имя = "ПоступлениеДопРасходов" Тогда
			СоответствиеРеквизитов.Вставить("СуммаТовара", "ФактурнаяСтоимость");
		ИначеЕсли МетаданныеДокументаИсточника.Имя = "Доверенность" Тогда
			Если ИмяТаблицы = "Товары" Тогда
				СоответствиеРеквизитов.Вставить("НаименованиеТовара", "Номенклатура");
				СоответствиеРеквизитов.Вставить("ЕдиницаПоКлассификатору", "ЕдиницаИзмерения");
				ИмяТаблицыИсточника = "Товары";
			ИначеЕсли ИмяТаблицы = "ОС" Тогда
				СоответствиеРеквизитов.Вставить("НаименованиеТовара", "ОсновноеСредство");
				ИмяТаблицыИсточника = "Товары";
			КонецЕсли;
		Иначе
			СоответствиеРеквизитов.Вставить("Сумма", "ФактурнаяСтоимость");
		КонецЕсли;
	ИначеЕсли МетаданныеДокументаИсточника.Имя = "Доверенность" Тогда
		Если ИмяТаблицы = "Товары" ИЛИ ИмяТаблицы = "Услуги" Тогда
			СоответствиеРеквизитов.Вставить("НаименованиеТовара", "Номенклатура");
			ИмяТаблицыИсточника = "Товары";
			Если ИмяТаблицы = "Товары" Тогда
				СоответствиеРеквизитов.Вставить("ЕдиницаПоКлассификатору", "ЕдиницаИзмерения");
			КонецЕсли;
		ИначеЕсли ИмяТаблицы = "НМА" Тогда
			СоответствиеРеквизитов.Вставить("НаименованиеТовара", "НематериальныйАктив");
			ИмяТаблицыИсточника = "Товары";
		ИначеЕсли ИмяТаблицы = "ОС" Тогда
			СоответствиеРеквизитов.Вставить("НаименованиеТовара", "ОсновноеСредство");
			ИмяТаблицыИсточника = "Товары";
		КонецЕсли;
	КонецЕсли;
	
	ДанныеТабличнойЧасти = РеквизитФормыВЗначение("ТабличнаяЧастьДокумента", Тип("ТаблицаЗначений"));
	
	ТипНоменклатура = Тип("СправочникСсылка.Номенклатура");
	ТипОС           = Тип("СправочникСсылка.ОсновныеСредства");
	ТипНМА          = Тип("СправочникСсылка.НематериальныеАктивы");
	
	Для Каждого СтрокаТЧ Из ДокументИсточник[ИмяТаблицыИсточника] Цикл
		
		Если МетаданныеДокументаИсточника.Имя = "Доверенность" Тогда
			ТипТовараИсточника = ТипЗнч(СтрокаТЧ.НаименованиеТовара);
			Если ИмяТаблицы = "ОС" И ТипТовараИсточника <> ТипОС Тогда
				Продолжить;
			КонецЕсли;
			Если ИмяТаблицы = "НМА" И ТипТовараИсточника <> ТипНМА Тогда
				Продолжить;
			КонецЕсли;
			Если (ИмяТаблицы = "Товары" ИЛИ ИмяТаблицы = "Услуги") И ТипТовараИсточника <> ТипНоменклатура Тогда
				Продолжить;
			КонецЕсли;
			Если ИмяТаблицы = "Товары" И СтрокаТЧ.НаименованиеТовара.Услуга Тогда
				Продолжить;
			КонецЕсли;
			Если ИмяТаблицы = "Услуги" И НЕ СтрокаТЧ.НаименованиеТовара.Услуга Тогда
				Продолжить;
			КонецЕсли;
			СтрокаТабличнойЧасти = ДанныеТабличнойЧасти.Добавить();
		Иначе
			СтрокаТабличнойЧасти = ДанныеТабличнойЧасти.Добавить();
		КонецЕсли;
		
		Для Каждого РеквизитТЧ из МетаданныеДокументаИсточника.ТабличныеЧасти[ИмяТаблицыИсточника].Реквизиты Цикл
			Если СоответствиеРеквизитов.Свойство(РеквизитТЧ.Имя) Тогда
				// документы исключения, в которых реквизит называется иначе
				ИмяКолонки = СоответствиеРеквизитов[РеквизитТЧ.Имя];
			Иначе	
				ИмяКолонки = РеквизитТЧ.Имя;
			КонецЕсли;
			Если ДанныеТабличнойЧасти.Колонки.Найти(ИмяКолонки) <> Неопределено Тогда
				СтрокаТабличнойЧасти[ИмяКолонки] = СтрокаТЧ[РеквизитТЧ.Имя];
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;
	
	ЗначениеВРеквизитФормы(ДанныеТабличнойЧасти, "ТабличнаяЧастьДокумента");
	
КонецПроцедуры

&НаСервере
Функция СформироватьТаблицуДляПереносаВДокумент()

	ТаблицаОбработки = ТабличнаяЧастьДокумента.Выгрузить();
	
	ТаблицаДокумента = ПолучитьИзВременногоХранилища(АдресХранилищаТабличнойЧасти);
		
	// Создадим структуру, которая будет содержать имена колонок присутствующих в 
	// документе, но не присутствующих в ТЧ обработки. 
	СтруктураНовыхКолонок = Новый Структура;
	
	Если ИмяДокумента = "ГТДИмпорт" Тогда
		Если ТаблицаОбработки.Колонки.Найти("НомерРаздела") = Неопределено ТОгда
			ТаблицаОбработки.Колонки.Добавить("НомерРаздела");
			СтруктураНовыхКолонок.Вставить("НомерРаздела");
		КонецЕсли;
	КонецЕсли;
	
	// Идем по строкам табличной части и обрабатываем строки, в которых заполнен
	// реквизит НомерСтроки. Эти строки были выгружены из документа.
	Для каждого СтрокаТаблицы Из ТаблицаОбработки Цикл
		
		Если ИмяДокумента = "ГТДИмпорт" Тогда
			СтрокаТаблицы.НомерРаздела = ?(ЗначениеЗаполнено(СтрокаТаблицы.НомерРаздела), СтрокаТаблицы.НомерРаздела, 1);
		КонецЕсли;
		
		Если ЗначениеЗаполнено(СтрокаТаблицы.НомерСтроки) Тогда
			
			Если ИмяДокумента = "ГТДИмпорт" Тогда
				ПараметрыОтбора = Новый Структура;
				//ПараметрыОтбора.Вставить("НомерРаздела"	, СтрокаТаблицы.НомерРаздела);
				ПараметрыОтбора.Вставить("НомерСтроки"	, СтрокаТаблицы.НомерСтроки);
				МассивСтрок = ТаблицаДокумента.НайтиСтроки(ПараметрыОтбора);
				
				СтрокаТаблицыДокумента = МассивСтрок[0];
				
			Иначе	
				//Если номер строки заполнен, находим соответствующую строку в табличной 
				//части документа
				СтрокаТаблицыДокумента = ТаблицаДокумента[СтрокаТаблицы.НомерСтроки - 1];
			КонецЕсли;
			// Теперь пройдем по колонкам таблицы документа
			Для каждого КолонкаТаблицыДокумента Из ТаблицаДокумента.Колонки Цикл
				//Если колонка есть в таблице документа, но ее нет в таблице, выгруженной
				//из обработке и нет в структуре новых колонок, тогда добавим ее в таблицу
				//и в структуру
				Если ТаблицаОбработки.Колонки.Найти(КолонкаТаблицыДокумента.Имя) = Неопределено
					И НЕ СтруктураНовыхКолонок.Свойство(КолонкаТаблицыДокумента.Имя) Тогда
					
					ТаблицаОбработки.Колонки.Добавить(КолонкаТаблицыДокумента.Имя);
					СтруктураНовыхКолонок.Вставить(КолонкаТаблицыДокумента.Имя);
				КонецЕсли;
				
				//Если колонка есть в структуре новых колонок, заполняем ее значение 
				//из таблицы документа
				Если СтруктураНовыхКолонок.Свойство(КолонкаТаблицыДокумента.Имя) Тогда
					СтрокаТаблицы[КолонкаТаблицыДокумента.Имя] = СтрокаТаблицыДокумента[КолонкаТаблицыДокумента.Имя];
				КонецЕсли;						
			КонецЦикла;
			
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат ТаблицаОбработки;
	
КонецФункции

&НаКлиенте
Процедура ПриИзмененииКоличестваВТабличнойЧасти(СтрокаТабличнойЧасти)
	
	Если ЕстьСумма и ЕстьЦена Тогда
		ОбработкаТабличныхЧастейКлиентСервер.РассчитатьСуммуТабЧасти(СтрокаТабличнойЧасти);
	КонецЕсли;
	
	РассчитатьСуммуНДСВТабличнойЧасти(СтрокаТабличнойЧасти);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриИзмененииСуммыВТабличнойЧасти(СтрокаТабличнойЧасти)
    
	Если ЕстьЦена Тогда
		Если НЕ ЕстьКоличество И (НЕ ЕстьСумма ИЛИ НЕ ЗначениеЗаполнено(СтрокаТабличнойЧасти.Количество))Тогда
			СтрокаТабличнойЧасти.Цена = 0;
		Иначе
			Если СтрокаТабличнойЧасти.Количество = 0 Тогда 
				СтрокаТабличнойЧасти.Количество  = 1;
			КонецЕсли;
			СтрокаТабличнойЧасти.Цена = СтрокаТабличнойЧасти.Сумма / СтрокаТабличнойЧасти.Количество;
		КонецЕсли; 
	КонецЕсли;	
	
	РассчитатьСуммуНДСВТабличнойЧасти(СтрокаТабличнойЧасти);
	
КонецПроцедуры // ПриИзмененииСуммыВТабличнойЧасти()

&НаКлиенте
Процедура РаспределитьСуммуПоКолонке(ИмяКолонки, ИмяБазовойКолонки, СуммаРаспределения)
	
	//Посчитаем общую помеченных позиций
	ОбщаяСумма = 0;
	Для каждого СтрокаТабличнойЧасти Из ТабличнаяЧастьДокумента Цикл
		Если СтрокаТабличнойЧасти.Пометка Тогда
			ОбщаяСумма = ОбщаяСумма + СтрокаТабличнойЧасти[ИмяБазовойКолонки];
		КонецЕсли; 
	КонецЦикла;
	
	Если ОбщаяСумма = 0 Тогда
		ЭлементСпискаВыбора = Элементы.СписокБазовыхГраф.СписокВыбора.НайтиПоЗначению(ИмяБазовойКолонки);			
		ТекстПредупреждения = НСтр("ru = 'Общий итог по графе ""%1"" помеченных строк нулевой!
                                    |Распределение невозможно.'");
		ТекстПредупреждения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстПредупреждения,
									ЭлементСпискаВыбора.Представление);
		ПоказатьПредупреждение( , ТекстПредупреждения,, НСтр("ru = 'Распределение суммы по графе'"));
		Возврат;
	КонецЕсли; 
		
	 //Теперь  распределяем
	СтрокаМаксимальнойСуммы = Неопределено; // На эту строку будем относить остаток после распределения (ошибки округления)
	МаксимальнаяСумма       = 0; // Значение максимальной суммы.
	НепогашеннаяСумма       = СуммаРаспределения;
	Для каждого СтрокаТабличнойЧасти Из ТабличнаяЧастьДокумента Цикл
		Если СтрокаТабличнойЧасти.Пометка Тогда

			Дельта = СуммаРаспределения * СтрокаТабличнойЧасти[ИмяБазовойКолонки] / ОбщаяСумма;
			
			 //Если Дельта по модулю оказалась больше, чем осталось погасить
			Если Дельта < 0 Тогда
				Дельта = Макс(НепогашеннаяСумма, Дельта)
			Иначе
				Дельта = Мин(НепогашеннаяСумма, Дельта)
			КонецЕсли; 

			 //Проверим текущую сумму на максимум.
			Если СтрокаТабличнойЧасти[ИмяКолонки] > МаксимальнаяСумма  Тогда
				МаксимальнаяСумма       = СтрокаТабличнойЧасти[ИмяКолонки];
				СтрокаМаксимальнойСуммы = СтрокаТабличнойЧасти;
			КонецЕсли;

			 //Увеличиваем значение и запоминаем старое.
			ТекущаяСумма             = СтрокаТабличнойЧасти[ИмяКолонки];
			СтрокаТабличнойЧасти[ИмяКолонки] = СтрокаТабличнойЧасти[ИмяКолонки] + Дельта;
			
			 //Остаток нераспределенной суммы надо уменьшать на дельту реального изменения
			НепогашеннаяСумма = НепогашеннаяСумма - (СтрокаТабличнойЧасти[ИмяКолонки] - ТекущаяСумма);

			 //Пересчитываем связанные реквизиты.
			 Если ИмяКолонки = "Сумма" Тогда
				ПриИзмененииСуммыВТабличнойЧасти(СтрокаТабличнойЧасти);
				РассчитатьСуммуНДСВТабличнойЧасти(СтрокаТабличнойЧасти);
			КонецЕсли;
			Если ИмяКолонки = "Количество" Тогда
				ПриИзмененииКоличестваВТабличнойЧасти(СтрокаТабличнойЧасти);
			КонецЕсли;			
			Если ИмяКолонки = "Цена" Тогда
				РассчитатьЦеныИСуммы(СтрокаТабличнойЧасти);				
			КонецЕсли;
		КонецЕсли; 		
	КонецЦикла;  
		
	 //Если что-то осталось, кидаем на строку с максимальной суммой.
	Если НепогашеннаяСумма > 0
	   И СтрокаМаксимальнойСуммы <> Неопределено Тогда

		СтрокаМаксимальнойСуммы[ИмяКолонки] = СтрокаМаксимальнойСуммы[ИмяКолонки] + НепогашеннаяСумма;
		Если ИмяКолонки = "Сумма" Тогда
			ПриИзмененииСуммыВТабличнойЧасти(СтрокаМаксимальнойСуммы);
			РассчитатьСуммуНДСВТабличнойЧасти(СтрокаТабличнойЧасти);
		КонецЕсли;
		Если ИмяКолонки = "Количество" Тогда
			ПриИзмененииКоличестваВТабличнойЧасти(СтрокаТабличнойЧасти);
		КонецЕсли;			
		Если ИмяКолонки = "Цена" Тогда
			РассчитатьЦеныИСуммы(СтрокаТабличнойЧасти);				
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры // РаспределитьСуммуПоКолонке()

&НаКлиенте
Процедура ИзменитьЦену()
	
	Для каждого СтрокаТабличнойЧасти Из ТабличнаяЧастьДокумента Цикл
		Если СтрокаТабличнойЧасти.Пометка Тогда
			СтрокаТабличнойЧасти.Цена = СтрокаТабличнойЧасти.Цена * (100 + ВариантЗначения) / 100;
			//пересчитаем связанные реквизиты.
			РассчитатьЦеныИСуммы(СтрокаТабличнойЧасти);			
		КонецЕсли; 
	КонецЦикла; 
	
КонецПроцедуры

&НаКлиенте
Процедура РассчитатьЦеныИСуммы(СтрокаТабличнойЧасти)

    Если ЕстьСумма и ЕстьЦена Тогда
		ОбработкаТабличныхЧастейКлиентСервер.РассчитатьСуммуТабЧасти(СтрокаТабличнойЧасти);
	КонецЕсли;

	РассчитатьСуммуНДСВТабличнойЧасти(СтрокаТабличнойЧасти);

КонецПроцедуры // РассчитатьЦеныИСуммы()

&НаКлиенте
Процедура РассчитатьСуммуНДСВТабличнойЧасти(СтрокаТабличнойЧасти)
    	
	Если ЕстьСумма И ЕстьНДС ТОгда
		ОбработкаТабличныхЧастейКлиентСервер.РассчитатьСуммуНДСТабЧасти(СтрокаТабличнойЧасти, СтруктураДляРасчета);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ТабличнаяЧастьДокументаПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	Если НоваяСтрока и Копирование Тогда
		Элемент.ТекущиеДанные.НомерСтроки = 0;
	КонецЕсли;
КонецПроцедуры




