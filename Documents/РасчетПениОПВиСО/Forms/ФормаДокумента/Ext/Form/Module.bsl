﻿
////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтаФорма);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	Если Параметры.Ключ.Пустая() Тогда
		
		ПодготовитьФормуНаСервере();
		РаботаСДиалогами.УстановитьЗаголовокФормыДокумента(Строка(Объект.ВидОперации), Объект.Ссылка, ЭтаФорма);
		
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)

	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	// СтандартныеПодсистемы.ДатыЗапретаИзменения
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.ДатыЗапретаИзменения
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

	// РедактированиеДокументовПользователей
	ПраваДоступаКОбъектам.ОбъектПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец РедактированиеДокументовПользователей
	
	ПодготовитьФормуНаСервере();
	РаботаСДиалогами.УстановитьЗаголовокФормыДокумента(Строка(Объект.ВидОперации), Объект.Ссылка, ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)

	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом

	РаботаСДиалогами.УстановитьЗаголовокФормыДокумента(Строка(Объект.ВидОперации), Объект.Ссылка, ЭтаФорма);	
	МесяцНачисленияСтрокой = РаботаСДиалогамиКлиентСервер.ДатаКакМесяцПредставление(Объект.ПериодРегистрации);

КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	Если ИсточникВыбора.ИмяФормы = "Справочник.СотрудникиОрганизаций.Форма.ФормаСписка"  Тогда
		Если ТипЗнч(ВыбранноеЗначение) = Тип("СправочникСсылка.ФизическиеЛица")Тогда
			Если Объект.ИсчислениеПени.НайтиСтроки(Новый Структура("ФизЛицо", ВыбранноеЗначение)).Количество() = 0 Тогда
				НоваяСтрока 						= Объект.ИсчислениеПени.Добавить();	
				НоваяСтрока.ФизЛицо 				= ВыбранноеЗначение;
				НоваяСтрока.ДатаНачала 				= Объект.ДатаНачала;
				НоваяСтрока.ДатаОкончания 			= Объект.ДатаОкончания;
				НоваяСтрока.МесяцНалоговогоПериода 	= Объект.ПериодРегистрации;
			КонецЕсли;
		ИначеЕсли ТипЗнч(ВыбранноеЗначение) = Тип("Массив") Тогда
			Для Каждого СтрокаМассива Из ВыбранноеЗначение Цикл
				
				Если Объект.ИсчислениеПени.НайтиСтроки(Новый Структура("ФизЛицо", СтрокаМассива)).Количество() = 0 Тогда
					
					НоваяСтрока 						= Объект.ИсчислениеПени.Добавить();	
					НоваяСтрока.ФизЛицо 				= СтрокаМассива;
					НоваяСтрока.ДатаНачала 				= Объект.ДатаНачала;
					НоваяСтрока.ДатаОкончания 			= Объект.ДатаОкончания;
					НоваяСтрока.МесяцНалоговогоПериода 	= Объект.ПериодРегистрации;
					
				КонецЕсли;
				
			КонецЦикла;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
		
	ОбщегоНазначенияБККлиент.ОбработкаОповещенияФормыДокумента(ЭтаФорма, Объект.Ссылка, ИмяСобытия, Параметр, Источник);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
		
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	Если ПараметрыЗаписи.РежимЗаписи = ПредопределенноеЗначение("РежимЗаписиДокумента.Проведение") Тогда
		КлючеваяОперация = "Документ ""расчет пени по взносам и отчислениям"" (проведение)";
		ОценкаПроизводительностиКлиент.НачатьЗамерВремени(Истина, КлючеваяОперация);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.ПослеЗаписи(ЭтотОбъект, Объект, ПараметрыЗаписи);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

&НаКлиенте
Процедура ДатаПриИзменении(Элемент)
	
	Если НачалоДня(Объект.Дата) = НачалоДня(ТекущаяДатаДокумента) Тогда
		// Изменение времени не влияет на поведение документа.
		ТекущаяДатаДокумента = Объект.Дата;
		Возврат;
	КонецЕсли;
	
	УстановитьФункциональныеОпцииФормы();
		
	// Запомним новую дату документа.
	ТекущаяДатаДокумента = Объект.Дата;
	
	УправлениеФормой(ЭтаФорма);

КонецПроцедуры

&НаКлиенте
Процедура СтруктурноеПодразделениеОрганизацияПриИзменении(Элемент)
	
	Если НЕ ЗначениеЗаполнено(СтруктурноеПодразделениеОрганизация) Тогда 
		Объект.Организация = Неопределено;
		Объект.СтруктурноеПодразделение = Неопределено;
	Иначе  
		Результат = РаботаСДиалогамиКлиент.ПроверитьИзменениеЗначенийОрганизацииСтруктурногоПодразделения(СтруктурноеПодразделениеОрганизация, Объект.Организация, Объект.СтруктурноеПодразделение);
		Если Результат.ИзмененаОрганизация ИЛИ Результат.ИзмененоСтруктурноеПодразделение Тогда
			СтруктураРезультатаВыполнения = Неопределено;
			СтруктурноеПодразделениеОрганизацияПриИзмененииНаСервере(, СтруктураРезультатаВыполнения);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СтруктурноеПодразделениеОрганизацияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	РаботаСДиалогамиКлиент.СтруктурноеПодразделениеНачалоВыбора(ЭтаФорма, СтандартнаяОбработка, Объект.Организация, Объект.СтруктурноеПодразделение, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура КомментарийНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ОбщегоНазначенияКлиент.ПоказатьФормуРедактированияКомментария(Элемент.ТекстРедактирования, ЭтотОбъект, "Объект.Комментарий");
	
КонецПроцедуры

&НаКлиенте
Процедура МесяцНачисленияСтрокойПриИзменении(Элемент)
	
	РаботаСДиалогамиКлиент.ДатаКакМесяцПодобратьДатуПоТексту(МесяцНачисленияСтрокой, Объект.ПериодРегистрации);
	МесяцНачисленияСтрокой = РаботаСДиалогамиКлиентСервер.ДатаКакМесяцПредставление(Объект.ПериодРегистрации);
	
КонецПроцедуры

&НаКлиенте
Процедура МесяцНачисленияСтрокойОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура МесяцНачисленияСтрокойРегулирование(Элемент, Направление, СтандартнаяОбработка)
	
	Объект.ПериодРегистрации = ДобавитьМесяц(Объект.ПериодРегистрации, Направление);
	МесяцНачисленияСтрокой = РаботаСДиалогамиКлиентСервер.ДатаКакМесяцПредставление(Объект.ПериодРегистрации);
	УстановитьПризнакиРаспределения();
	УправлениеФормой(ЭтаФорма);
	Модифицированность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура МесяцНачисленияСтрокойАвтоПодбор(Элемент, Текст, ДанныеВыбора, Параметры, Ожидание, СтандартнаяОбработка)
	
	Если Текст = "" Тогда
		Ожидание = 0;
		РаботаСДиалогамиКлиент.НачалоВыбораИзСпискаПредставленияПериодаРегистрации(Элемент, Объект.ПериодРегистрации, ЭтаФорма, ,Истина);
	Иначе
		РаботаСДиалогамиКлиент.ДатаКакМесяцАвтоПодборТекста(Текст, ДанныеВыбора, СтандартнаяОбработка);
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура МесяцНачисленияСтрокойОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, Параметры, СтандартнаяОбработка)
	
	РаботаСДиалогамиКлиент.ДатаКакМесяцОкончаниеВводаТекста(Текст, ДанныеВыбора, СтандартнаяОбработка);
	УстановитьПризнакиРаспределения();
	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ВидОперацииПриИзменении(Элемент)
	
	Если Объект.ИсчислениеПени.Количество() > 0 Тогда
		
		// Если меняем вид операции, то предлагаем очищение ТЧ
		ТекстВопроса = НСтр("ru= 'Изменен вид операции документа. Очистить данные табличной части?'");
		Режим = РежимДиалогаВопрос.ДаНет;
		Оповещение = Новый ОписаниеОповещения("ПослеЗакрытияВопросаОбОчисткеТабЧасти", ЭтотОбъект);
		ПоказатьВопрос(Оповещение, ТекстВопроса, Режим, 0);
		
	КонецЕсли;
	
	ВидОперацииПриИзмененииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура СчетЗатратБУПриИзменении(Элемент)
	
	Объект.СчетЗатратНУ = ПроцедурыБухгалтерскогоУчетаВызовСервераПовтИсп.ПреобразоватьСчетаБУвСчетНУ(Новый Структура("СчетБУ", Объект.СчетЗатратБУ));
	
	ПоляФормы		= Новый Структура("Субконто1, Субконто2, Субконто3",
		"СубконтоЗатратБУ1", "СубконтоЗатратБУ2", "СубконтоЗатратБУ3");
	
	ЗаголовкиПолей	= Новый Структура("Субконто1, Субконто2, Субконто3",
		"ЗаголовокСубконтоБУ1", "ЗаголовокСубконтоБУ2", "ЗаголовокСубконтоБУ3"); 
		
	УстановитьЗаголовкиИДоступностьСубконто(ЭтаФорма, Объект.СчетЗатратБУ, ПоляФормы, ЗаголовкиПолей, Объект.СчетЗатратНУ);
	
	ПоляФормы = Новый Структура("Субконто1, Субконто2, Субконто3",
	"СубконтоЗатратНУ1", "СубконтоЗатратНУ2", "СубконтоЗатратНУ3");
	

	ПроцедурыБухгалтерскогоУчетаКлиентСервер.ПриИзмененииСчета(Объект.СчетЗатратНУ, Объект, ПоляФормы);

	ИзменитьПараметрыВыбораПолейСубконто(ЭтаФорма, "ЗатратБУ", "СчетЗатратБУ");
	ИзменитьПараметрыВыбораПолейСубконто(ЭтаФорма, "ЗатратНУ", "СчетЗатратНУ");

	ДанныеОбъекта = Новый Структура("Организация, СубконтоЗатратБУ1, СубконтоЗатратБУ2, СубконтоЗатратБУ3,
									|СубконтоЗатратНУ1, СубконтоЗатратНУ2, СубконтоЗатратНУ3");
			
	ЗаполнитьЗначенияСвойств(ДанныеОбъекта, Объект);
		
	СчетЗатратБУПриИзмененииНаСервере(ДанныеОбъекта);
	
	ЗаполнитьЗначенияСвойств(Объект, ДанныеОбъекта);
КонецПроцедуры

&НаКлиенте
Процедура СубконтоЗатратБУ1ПриИзменении(Элемент)
	
	ОбщегоНазначенияБККлиентСервер.ЗаменитьСубконтоНУ(Объект, Объект.СчетЗатратБУ, Объект.СчетЗатратНУ, 1, Объект.СубконтоЗатратБУ1, "СубконтоЗатратНУ");
	ИзменитьПараметрыВыбораПолейСубконто(ЭтаФорма, "ЗатратБУ", "СчетЗатратБУ");
	ИзменитьПараметрыВыбораПолейСубконто(ЭтаФорма, "ЗатратНУ", "СчетЗатратНУ", , Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура СубконтоЗатратБУ1НачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СубконтоНачалоВыбора(Элемент, "СубконтоЗатратБУ", 1, "СчетЗатратБУ", Объект, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура СубконтоЗатратБУ2ПриИзменении(Элемент)
	
	ОбщегоНазначенияБККлиентСервер.ЗаменитьСубконтоНУ(Объект, Объект.СчетЗатратБУ, Объект.СчетЗатратНУ, 2, Объект.СубконтоЗатратБУ2, "СубконтоЗатратНУ");
	ИзменитьПараметрыВыбораПолейСубконто(ЭтаФорма, "ЗатратБУ", "СчетЗатратБУ");
	ИзменитьПараметрыВыбораПолейСубконто(ЭтаФорма, "ЗатратНУ", "СчетЗатратНУ", , Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура СубконтоЗатратБУ2НачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СубконтоНачалоВыбора(Элемент, "СубконтоЗатратБУ", 2, "СчетЗатратБУ", Объект, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура СубконтоЗатратБУ3ПриИзменении(Элемент)
	
	ОбщегоНазначенияБККлиентСервер.ЗаменитьСубконтоНУ(Объект, Объект.СчетЗатратБУ, Объект.СчетЗатратНУ, 3, Объект.СубконтоЗатратБУ3, "СубконтоЗатратНУ");
	ИзменитьПараметрыВыбораПолейСубконто(ЭтаФорма, "ЗатратБУ", "СчетЗатратБУ");
	ИзменитьПараметрыВыбораПолейСубконто(ЭтаФорма, "ЗатратНУ", "СчетЗатратНУ", , Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура СубконтоЗатратБУ3НачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СубконтоНачалоВыбора(Элемент, "СубконтоЗатратБУ", 3, "СчетЗатратБУ", Объект, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура СчетЗатратНУПриИзменении(Элемент)
	
	ПоляФормы		= Новый Структура("Субконто1, Субконто2, Субконто3",
		"СубконтоЗатратНУ1", "СубконтоЗатратНУ2", "СубконтоЗатратНУ3");
	
	ЗаголовкиПолей	= Новый Структура("Субконто1, Субконто2, Субконто3",
		"ЗаголовокСубконтоНУ1", "ЗаголовокСубконтоНУ2", "ЗаголовокСубконтоНУ3"); 
		
	УстановитьЗаголовкиИДоступностьСубконто(ЭтаФорма, Объект.СчетЗатратНУ, ПоляФормы, ЗаголовкиПолей);

	ИзменитьПараметрыВыбораПолейСубконто(ЭтаФорма, "ЗатратНУ", "СчетЗатратНУ");

	ДанныеОбъекта = Новый Структура("Организация, СубконтоЗатратНУ1, СубконтоЗатратНУ2, СубконтоЗатратНУ3");
			
	ЗаполнитьЗначенияСвойств(ДанныеОбъекта, Объект);
		
	СчетЗатратНУПриИзмененииНаСервере(ДанныеОбъекта);
	
	ЗаполнитьЗначенияСвойств(Объект, ДанныеОбъекта);

КонецПроцедуры

&НаКлиенте
Процедура СубконтоЗатратНУ3ПриИзменении(Элемент)
	
	ИзменитьПараметрыВыбораПолейСубконто(ЭтаФорма, "ЗатратНУ", "СчетЗатратНУ");

КонецПроцедуры

&НаКлиенте
Процедура СубконтоЗатратНУ3НачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СубконтоНачалоВыбора(Элемент, "СубконтоЗатратНУ", 1, "СчетЗатратНУ", Объект, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура СубконтоЗатратНУ2ПриИзменении(Элемент)
	
	ИзменитьПараметрыВыбораПолейСубконто(ЭтаФорма, "ЗатратНУ", "СчетЗатратНУ");

КонецПроцедуры

&НаКлиенте
Процедура СубконтоЗатратНУ2НачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СубконтоНачалоВыбора(Элемент, "СубконтоЗатратНУ", 2, "СчетЗатратНУ", Объект, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура СубконтоЗатратНУ1ПриИзменении(Элемент)
	
	ИзменитьПараметрыВыбораПолейСубконто(ЭтаФорма, "ЗатратНУ", "СчетЗатратНУ");

КонецПроцедуры

&НаКлиенте
Процедура СубконтоЗатратНУ1НачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СубконтоНачалоВыбора(Элемент, "СубконтоЗатратНУ", 2, "СчетЗатратНУ", Объект, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтражениеПениПоУмолчаниюПриИзменении(Элемент)
	
	Если ОтражениеПениПоУмолчанию = 1 Тогда
		Объект.СчетЗатратБУ = Неопределено;
		Объект.СчетЗатратНУ = Неопределено;
		
		
		ПоляФормы		= Новый Структура("Субконто1, Субконто2, Субконто3",
		"СубконтоЗатратБУ1", "СубконтоЗатратБУ2", "СубконтоЗатратБУ3");
		
		ЗаголовкиПолей	= Новый Структура("Субконто1, Субконто2, Субконто3",
		"ЗаголовокСубконтоБУ1", "ЗаголовокСубконтоБУ2", "ЗаголовокСубконтоБУ3"); 
		
		УстановитьЗаголовкиИДоступностьСубконто(ЭтаФорма, Объект.СчетЗатратБУ, ПоляФормы, ЗаголовкиПолей, Объект.СчетЗатратНУ);
		
	КонецЕсли;
	
	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ РЕКВИЗИТОВ ТЧ Исчисление пени

&НаКлиенте
Процедура ИсчислениеПениПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	Если НоваяСтрока И НЕ Копирование Тогда
		Элемент.ТекущиеДанные.ДатаНачала = Объект.ДатаНачала;
		Элемент.ТекущиеДанные.ДатаОкончания = Объект.ДатаОкончания;
		Элемент.ТекущиеДанные.МесяцНалоговогоПериода = Объект.ПериодРегистрации;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ИсчислениеПениПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	
	РассчитатьСуммуДокумента();
	
КонецПроцедуры

&НаКлиенте
Процедура ИсчислениеПениПослеУдаления(Элемент)
	
	РассчитатьСуммуДокумента();
	
КонецПроцедуры

&НаКлиенте
Процедура ИсчислениеПениФизЛицоНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)

	Если Объект.ВидОперации <> ПредопределенноеЗначение("Перечисление.ВидыОперацийРасчетПени.РасчетПениВОСМС")
		И Объект.ВидОперации <> ПредопределенноеЗначение("Перечисление.ВидыОперацийРасчетПени.РаспределениеПениВОСМС")
		И Объект.ВидОперации <> ПредопределенноеЗначение("Перечисление.ВидыОперацийРасчетПени.РасчетПениОПВ")
		И Объект.ВидОперации <> ПредопределенноеЗначение("Перечисление.ВидыОперацийРасчетПени.РаспределениеПениОПВ")Тогда
		
		СтандартнаяОбработка = Ложь;
		Режим = РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс;
		ОбработчикОповещения = Новый ОписаниеОповещения("СписокСотрудниковСписокЗавершениеВыбора", ЭтотОбъект);
		
		ПараметрыФормы	= Новый Структура;
		ПараметрыФормы.Вставить("ЗакрыватьПриЗакрытииВладельца",	Истина);
		ПараметрыФормы.Вставить("ЗакрыватьПриВыборе",				Истина);
		ПараметрыФормы.Вставить("РежимВыбора",						Истина);
		
		Если ЕжемесячныйРасчетВзносовИОтчисленийЗаИП Тогда
			ОткрытьФорму("Справочник.ФизическиеЛица.Форма.ФормаВыбора", ПараметрыФормы, Элемент,,,,ОбработчикОповещения, Режим);			
		Иначе
			
			ПараметрыФормы.Вставить("ОтборОрганизация", Объект.Организация);
			ПараметрыФормы.Вставить("ВыбиратьФизЛицо", Истина); 		
			
			ОткрытьФорму("Справочник.СотрудникиОрганизаций.Форма.ФормаСписка", ПараметрыФормы, Элемент,,,,ОбработчикОповещения, Режим);
		КонецЕсли;             		
			
	КонецЕсли;		
	
КонецПроцедуры

&НаКлиенте
Процедура ИсчислениеПениФизЛицоОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	Если ВыбранноеЗначение = Тип("СправочникСсылка.ФизическиеЛица") Тогда
		СтандартнаяОбработка = Ложь;
		ПараметрыФормы	= Новый Структура;
		ПараметрыФормы.Вставить("ЗакрыватьПриЗакрытииВладельца",	Истина);
		ПараметрыФормы.Вставить("ЗакрыватьПриВыборе",				Истина);
		ПараметрыФормы.Вставить("РежимВыбора",						Истина);
			
		Режим = РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс;
		
		ОбработчикОповещения = Новый ОписаниеОповещения("СписокСотрудниковСписокЗавершениеВыбора", ЭтотОбъект);
		
		Если ЕжемесячныйРасчетВзносовИОтчисленийЗаИП Тогда
			ОткрытьФорму("Справочник.ФизическиеЛица.Форма.ФормаВыбора", ПараметрыФормы, Элемент,,,,ОбработчикОповещения, Режим);				
		Иначе
			ПараметрыФормы.Вставить("ОтборОрганизация", Объект.Организация);
			ПараметрыФормы.Вставить("ВыбиратьФизЛицо", Истина);
			ОткрытьФорму("Справочник.СотрудникиОрганизаций.Форма.ФормаСписка", ПараметрыФормы, Элемент,,,,ОбработчикОповещения, Режим);
		КонецЕсли;
		
	ИначеЕсли ВыбранноеЗначение = Тип("СправочникСсылка.Контрагенты") Тогда
		СтандартнаяОбработка = Ложь;
		ПараметрыФормы	= Новый Структура;
		ПараметрыФормы.Вставить("Отбор",	Новый Структура("ЮрФизЛицо", ПредопределенноеЗначение("Перечисление.ЮрФизЛицо.ФизЛицо")));
		
		ОбработчикОповещения = Новый ОписаниеОповещения("СписокСотрудниковСписокЗавершениеВыбора", ЭтотОбъект);
		ОткрытьФорму("Справочник.Контрагенты.Форма.ФормаВыбора", ПараметрыФормы,,,,,ОбработчикОповещения);
			
	КонецЕсли;
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура ПоВсемСотрудникам(Команда)
	
	Если Объект.ИсчислениеПени.Количество() > 0 Тогда
		
		ТекстВопроса = НСтр("ru= 'Перед заполнением табличная часть будет очищена. Заполнить?'");
		Режим = РежимДиалогаВопрос.ДаНет;
		Оповещение = Новый ОписаниеОповещения("ПослеЗакрытияВопросаПередЗаполнениемПоЗадолжности", ЭтотОбъект);
		ПоказатьВопрос(Оповещение, ТекстВопроса, Режим, 0);
	
	Иначе
		
		АвтозаполнениеНаСервере();
		
		Если Объект.ИсчислениеПени.Количество() = 0 Тогда
			ТекстСообщения = НСтр("ru = 'Не обнаружены данные для записи в табличную часть документа'");
			ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения, Объект.Ссылка, , "Объект");
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СпискомСотрудников(Команда)
	
	Если Объект.ИсчислениеПени.Количество() > 0 Тогда
		ТекстВопроса = НСтр("ru = 'Табличная часть будет полностью перезаполнена. Продолжить?'");
		Режим = РежимДиалогаВопрос.ДаНет;
		Оповещение = Новый ОписаниеОповещения("ПослеЗакрытияВопросаЗаполнитьПоСпискуСотрудников", ЭтотОбъект);
		ПоказатьВопрос(Оповещение, ТекстВопроса, Режим, 0);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Рассчитать(Команда)
	
	Если Объект.Проведен Тогда
		
		ТекстВопроса = НСтр("ru= 'Автоматически рассчитать документ можно только после отмены его проведения. Выполнить отмену проведения документа?'");
		Режим = РежимДиалогаВопрос.ДаНет;
		Оповещение = Новый ОписаниеОповещения("ПослеЗакрытияВопросаПередРасчетом", ЭтотОбъект);
		ПоказатьВопрос(Оповещение, ТекстВопроса, Режим, 0);

	ИначеЕсли Модифицированность ИЛИ Объект.Ссылка.Пустая() Тогда
		
		ТекстВопроса = НСтр("ru= 'Перед расчетом необходимо сохранить документ. Продолжить?'");
		Режим = РежимДиалогаВопрос.ДаНет;
		Оповещение = Новый ОписаниеОповещения("ПослеЗакрытияВопросаПередРасчетом", ЭтотОбъект);
		ПоказатьВопрос(Оповещение, ТекстВопроса, Режим, 0);
			
	Иначе
		
		РассчитатьНаСервере();

	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Очистить(Команда)

	ТекстВопроса = НСтр("ru= 'Табличные части будут очищены. Продолжить?'");
	Режим = РежимДиалогаВопрос.ДаНет;
	Оповещение = Новый ОписаниеОповещения("ПослеЗакрытияВопросаОбОчисткеТабЧасти", ЭтотОбъект);
	ПоказатьВопрос(Оповещение, ТекстВопроса, Режим, 0);
	
КонецПроцедуры

&НаКлиенте
Процедура Подбор(Команда)

	ПараметрыФормы	= Новый Структура;
	ПараметрыФормы.Вставить("ЗакрыватьПриЗакрытииВладельца",	Истина);
	ПараметрыФормы.Вставить("ЗакрыватьПриВыборе",				Ложь);
	ПараметрыФормы.Вставить("РежимВыбора",						Истина);
	ПараметрыФормы.Вставить("МножественныйВыбор",				Истина);
	ПараметрыФормы.Вставить("ПараметрВыборГруппИЭлементов",		ИспользованиеГруппИЭлементов.Элементы);
	ПараметрыФормы.Вставить("ОтборОрганизация", Объект.Организация);
	ПараметрыФормы.Вставить("ВыбиратьФизЛицо", Истина);

	Режим = РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс;
	
	ОткрытьФорму("Справочник.СотрудникиОрганизаций.Форма.ФормаСписка", ПараметрыФормы, ЭтаФорма,,,,, Режим);


КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
     ПодключаемыеКомандыКлиент.НачатьВыполнениеКоманды(ЭтотОбъект, Команда, Объект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПродолжитьВыполнениеКомандыНаСервере(ПараметрыВыполнения, ДополнительныеПараметры) Экспорт
     ВыполнитьКомандуНаСервере(ПараметрыВыполнения);
КонецПроцедуры
 
&НаСервере
Процедура ВыполнитьКомандуНаСервере(ПараметрыВыполнения)
     ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, ПараметрыВыполнения, Объект);
КонецПроцедуры
 
&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
     ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

&НаСервере
Процедура УстановитьФункциональныеОпцииФормы()

	ОбщегоНазначенияБККлиентСервер.УстановитьПараметрыФункциональныхОпцийФормыДокумента(ЭтаФорма);
	ОрганизацияПлательщикНалогаНаПрибыль = ПроцедурыНалоговогоУчета.ПолучитьПризнакПлательщикаНалогаНаПрибыль(Объект.Организация, Объект.Дата);  	
	ЕжемесячныйРасчетВзносовИОтчисленийЗаИП = ПроцедурыНалоговогоУчета.ПолучитьПризнакЕжемесячногоРасчетаВзносовИОтчисленийЗаИП(Объект.Организация, Объект.Дата);
	
КонецПроцедуры

&НаСервере
Процедура ПодготовитьФормуНаСервере()
	
	УстановитьФункциональныеОпцииФормы();
	
	Если Параметры.Ключ.Пустая() Тогда
		
		Если НЕ ЗначениеЗаполнено(Объект.ВидПлатежа) Тогда
			Объект.ВидПлатежа = Перечисления.ВидыПлатежейВБюджетИФонды.ПениСам;
		КонецЕсли;

		Если НЕ ЗначениеЗаполнено(Объект.ДатаНачала) Тогда
			Объект.ДатаНачала = НачалоМесяца(Объект.Дата);
		КонецЕсли;
		
		Если НЕ ЗначениеЗаполнено(Объект.ДатаОкончания) Тогда
			Объект.ДатаОкончания = КонецМесяца(Объект.Дата);
		КонецЕсли;
		
	КонецЕсли;
	
	ТекущаяДатаДокумента = Объект.Дата;
	
	Если НЕ ЗначениеЗаполнено(Объект.СчетЗатратБУ) И НЕ ЗначениеЗаполнено(Объект.СчетЗатратНУ) Тогда
		ОтражениеПениПоУмолчанию = 1;
	Иначе 
		ОтражениеПениПоУмолчанию = 2;
	КонецЕсли;

	// Заполним реквизит формы МесяцСтрока.
	МесяцНачисленияСтрокой = РаботаСДиалогамиКлиентСервер.ДатаКакМесяцПредставление(Объект.ПериодРегистрации);
	
	ПоддержкаРаботыСоСтруктурнымиПодразделениями = ПолучитьФункциональнуюОпцию("ПоддержкаРаботыСоСтруктурнымиПодразделениями");
	РаботаСДиалогамиКлиентСервер.УстановитьВидимостьСтруктурногоПодразделения(Объект.Организация, Объект.СтруктурноеПодразделение, СтруктурноеПодразделениеОрганизация, ПоддержкаРаботыСоСтруктурнымиПодразделениями);
	РаботаСДиалогамиКлиентСервер.УстановитьСвойстваЭлементаСтруктурноеПодразделениеОрганизация(Элементы.СтруктурноеПодразделениеОрганизация, Объект.СтруктурноеПодразделение, ПоддержкаРаботыСоСтруктурнымиПодразделениями);
    
    ПоказыватьВДокументахСчетаУчета = Истина;
    
	ПоляФормы		= Новый Структура("Субконто1, Субконто2, Субконто3",
		"СубконтоЗатратБУ1", "СубконтоЗатратБУ2", "СубконтоЗатратБУ3");
	
	ЗаголовкиПолей	= Новый Структура("Субконто1, Субконто2, Субконто3",
		"ЗаголовокСубконтоБУ1", "ЗаголовокСубконтоБУ2", "ЗаголовокСубконтоБУ3"); 
		
	ИзменитьПараметрыВыбораПолейСубконто(ЭтаФорма, "ЗатратБУ", "СчетЗатратБУ");	
	ИзменитьПараметрыВыбораПолейСубконто(ЭтаФорма, "ЗатратНУ", "СчетЗатратНУ");
	УстановитьЗаголовкиИДоступностьСубконто(ЭтаФорма, Объект.СчетЗатратБУ, ПоляФормы, ЗаголовкиПолей, Объект.СчетЗатратНУ);

	УстановитьПризнакиРаспределения();
	УправлениеФормой(ЭтаФорма);
	
	ОбщегоНазначенияБК.УстановитьТекстАвтора(НадписьАвтор, Объект.Автор);

КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма)
	
	Объект   = Форма.Объект;
	Элементы = Форма.Элементы;
	Если Объект.ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийРасчетПени.РасчетПениОПВ")
		ИЛИ Объект.ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийРасчетПени.РасчетПениСО")
		ИЛИ Объект.ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийРасчетПени.РасчетПениОППВ")
		ИЛИ Объект.ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийРасчетПени.РасчетПениОПВР")
		ИЛИ Объект.ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийРасчетПени.РасчетПениВОСМС")
		ИЛИ Объект.ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийРасчетПени.РасчетПениООСМС") 
		ИЛИ Объект.ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийРасчетПени.РасчетПениЕП") Тогда
		// отметим незаполненные даты
		Элементы.ИсчислениеПениДатаНачала.АвтоОтметкаНезаполненного = Истина;
		Элементы.ИсчислениеПениДатаОкончания.АвтоОтметкаНезаполненного = Истина;
		Элементы.СуммаДокумента.АвтоОтметкаНезаполненного = Ложь;
	Иначе
		// в случае ручного распределения пени даты неважны
		Элементы.ИсчислениеПениДатаНачала.АвтоОтметкаНезаполненного = Ложь;
		Элементы.ИсчислениеПениДатаОкончания.АвтоОтметкаНезаполненного = Ложь;
		Элементы.СуммаДокумента.АвтоОтметкаНезаполненного = Истина;
	КонецЕсли;
	
	Если Объект.ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийРасчетПени.РаспределениеПениВОСМС")
		ИЛИ Объект.ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийРасчетПени.РасчетПениВОСМС") Тогда
		
		Элементы.ИсчислениеПениФизЛицо.КнопкаОчистки = Истина;
		
	Иначе
		Элементы.ИсчислениеПениФизЛицо.КнопкаОчистки = Ложь;
	КонецЕсли;	
		
	
	Элементы.ДекорацияРеквизитыНУ.Видимость  = НЕ Форма.ОрганизацияПлательщикНалогаНаПрибыль;
	Элементы.ГруппаСчетАналитикаНУ.Видимость = Форма.ОрганизацияПлательщикНалогаНаПрибыль;

	Элементы.ГруппаСчетаЗатратНУБУ.Видимость = Форма.ОтражениеПениПоУмолчанию=2 И Форма.ПоказыватьВДокументахСчетаУчета;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьПризнакиРаспределения()
	
	СтруктураПризнаковРаспределения = УчетнаяПолитикаСервер.ПолучитьПризнакиРаспределенияНалогов(Объект.Организация, Объект.ПериодРегистрации);
	РаспределятьНалогиПоСтруктурнымЕдиницам = СтруктураПризнаковРаспределения.РаспределятьНалогиПоСтруктурнымЕдиницам;
	РаспределятьНалогиПоПодразделениямОрганизаций = СтруктураПризнаковРаспределения.РаспределятьНалогиПоПодразделениямОрганизаций;
		
КонецПроцедуры

&НаСервере
Процедура ПриИзмененииЗначенияОрганизацииСервер(СтруктураПараметров, СтруктураРезультатаВыполнения)
	
	Если НЕ СтруктураПараметров.ИзмененаОрганизация И НЕ СтруктураПараметров.ИзмененоСтруктурноеПодразделение Тогда
		Возврат;
	КонецЕсли;
	
	ПриИзмененииЗначенияСтруктурногоПодразделенияСервер(СтруктураПараметров);
	
	УстановитьПризнакиРаспределения();	
	УстановитьФункциональныеОпцииФормы();
	УправлениеФормой(ЭтаФорма);
	
	ПроверитьВладельцаСубконтоПодразделениеБУНУ(Объект);
	
	ИзменитьПараметрыВыбораПолейСубконто(ЭтаФорма, "ЗатратБУ","СчетЗатратБУ");	
	ИзменитьПараметрыВыбораПолейСубконто(ЭтаФорма, "ЗатратНУ","СчетЗатратНУ");
	
	РаботаСДиалогами.ПриИзмененииЗначенияОрганизации(Объект, , СтруктураРезультатаВыполнения);
	
КонецПроцедуры

&НаСервере
Процедура ПриИзмененииЗначенияСтруктурногоПодразделенияСервер(СтруктураПараметров)
	
	Если СтруктураПараметров.Свойство("ОчищатьНекорректныеЗначения") И НЕ СтруктураПараметров.ОчищатьНекорректныеЗначения Тогда 
		Возврат;
	КонецЕсли;
	
	УстановитьПризнакиРаспределения();	
	УстановитьФункциональныеОпцииФормы();
	
	// Очистим некорректные значения Субконто с подразделениями не входящими в выбранное структурное подразделение
	РаботаСДиалогами.ПроверитьСоответствиеПодразделения(Объект.Организация, Объект.СтруктурноеПодразделение, Объект.ПодразделениеОрганизации); 

КонецПроцедуры

&НаСервере
Процедура СтруктурноеПодразделениеОрганизацияПриИзмененииНаСервере(СтруктураПараметров = Неопределено, СтруктураРезультатаВыполнения = Неопределено)
	
	Если СтруктураПараметров = Неопределено 
		ИЛИ (СтруктураПараметров.Свойство("НеобходимоИзменитьЗначенияРеквизитовОбъекта") 
			И СтруктураПараметров.НеобходимоИзменитьЗначенияРеквизитовОбъекта) Тогда 
		РаботаСДиалогами.СтруктурноеПодразделениеПриИзменении(СтруктурноеПодразделениеОрганизация, Объект.Организация, Объект.СтруктурноеПодразделение, СтруктураПараметров);
	КонецЕсли;
	
	ПриИзмененииЗначенияОрганизацииСервер(СтруктураПараметров, СтруктураРезультатаВыполнения);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеВыбораСтруктурногоПодразделения(Результат, Параметры) Экспорт
	
	РаботаСДиалогамиКлиент.ПослеВыбораСтруктурногоПодразделения(Результат, Объект.Организация, Объект.СтруктурноеПодразделение, СтруктурноеПодразделениеОрганизация);
	Если Результат.ИзмененаОрганизация ИЛИ Результат.ИзмененоСтруктурноеПодразделение Тогда
		Модифицированность = Истина;
		Результат.Вставить("НеобходимоИзменитьЗначенияРеквизитовОбъекта", Ложь);
		СтруктураРезультатаВыполнения = Неопределено;
		РаботаСДиалогамиКлиент.ПоказатьВопросОбОчисткеНекорректныхЗначенийПодразделения(ЭтаФорма, Результат);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗакрытияВопросаОбОчисткеНекорректныхЗначенийПодразделения(Результат, Параметры) Экспорт
	
	Параметры.Вставить("ОчищатьНекорректныеЗначения", Результат = КодВозвратаДиалога.Да);
	СтруктураРезультатаВыполнения = Неопределено;

	СтруктурноеПодразделениеОрганизацияПриИзмененииНаСервере(Параметры, СтруктураРезультатаВыполнения);	
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗакрытияВопросаОбОчисткеТабЧасти(Результат, Параметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Нет Тогда
		Возврат;		
	КонецЕсли;
	
	Объект.ИсчислениеПени.Очистить();

КонецПроцедуры

&НаСервере
Процедура ВидОперацииПриИзмененииНаСервере()
	
	УправлениеФормой(ЭтаФорма);
	// Вывести в заголовке формы статус документа (новый, не проведен, проведен).
	РаботаСДиалогами.УстановитьЗаголовокФормыДокумента(Строка(Объект.ВидОперации), Объект.Ссылка, ЭтаФорма);

КонецПроцедуры

&НаКлиенте
Процедура ПослеЗакрытияВопросаЗаполнитьПоСпискуСотрудников(Результат, Параметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Нет Тогда
		Возврат;		
	КонецЕсли;

	Объект.ИсчислениеПени.Очистить();
	
КонецПроцедуры

&НаКлиенте  
Процедура ПослеЗакрытияВопросаПередЗаполнениемПоЗадолжности(Результат, Параметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Нет Тогда
		Возврат;		
	КонецЕсли;
	
	Объект.ИсчислениеПени.Очистить();
	
	АвтозаполнениеНаСервере();
	
	Если Объект.ИсчислениеПени.Количество() = 0 Тогда
		ТекстСообщения = НСтр("ru = 'Не обнаружены данные для записи в табличную часть документа'");
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения, Объект.Ссылка, , "Объект");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте  
Процедура ПослеЗакрытияВопросаПередРасчетом(Результат, Параметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Нет Тогда
		Возврат;		
	КонецЕсли;
	
	Если Объект.Проведен Тогда
		
		ЭтотОбъект.Записать(Новый Структура("РежимЗаписи", РежимЗаписиДокумента.ОтменаПроведения));
		
	ИначеЕсли Модифицированность ИЛИ Объект.Ссылка.Пустая() Тогда
		
		ЭтотОбъект.Записать(Новый Структура("РежимЗаписи", РежимЗаписиДокумента.Запись));
		
	КонецЕсли;
	
	РассчитатьНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура АвтозаполнениеНаСервере() 
	
	Если ОценкаПроизводительностиВызовСервераПовтИсп.ВыполнятьЗамерыПроизводительности() Тогда
		КлючеваяОперация 	= "Документ ""расчет пени по взносам и отчислениям"" (заполнение)";
		ВремяНачалаЗамера 	= ОценкаПроизводительности.НачатьЗамерВремени();
	КонецЕсли;
	
	Документы.РасчетПениОПВиСО.Автозаполнение(Объект);

	ОценкаПроизводительности.ЗакончитьЗамерВремени(КлючеваяОперация, ВремяНачалаЗамера);
	
КонецПроцедуры

&НаСервере
Процедура РассчитатьНаСервере()
	
	Если ОценкаПроизводительностиВызовСервераПовтИсп.ВыполнятьЗамерыПроизводительности() Тогда
		КлючеваяОперация 	= "Документ ""расчет пени по взносам и отчислениям"" (расчет)";
		ВремяНачалаЗамера 	= ОценкаПроизводительности.НачатьЗамерВремени();
	КонецЕсли;
	
	Документы.РасчетПениОПВиСО.Рассчитать(Объект);

	ОценкаПроизводительности.ЗакончитьЗамерВремени(КлючеваяОперация, ВремяНачалаЗамера);
	
КонецПроцедуры

&НаСервере
Процедура РассчитатьСуммуДокумента()
	
	Если Объект.ВидОперации = Перечисления.ВидыОперацийРасчетПени.РасчетПениОПВ
			ИЛИ Объект.ВидОперации = Перечисления.ВидыОперацийРасчетПени.РасчетПениСО 
			ИЛИ Объект.ВидОперации = Перечисления.ВидыОперацийРасчетПени.РасчетПениОППВ
			ИЛИ Объект.ВидОперации = Перечисления.ВидыОперацийРасчетПени.РасчетПениОПВР 
			ИЛИ Объект.ВидОперации = Перечисления.ВидыОперацийРасчетПени.РасчетПениВОСМС 
			ИЛИ Объект.ВидОперации = Перечисления.ВидыОперацийРасчетПени.РасчетПениООСМС 
			ИЛИ Объект.ВидОперации = Перечисления.ВидыОперацийРасчетПени.РаспределениеПениЕП Тогда

		Объект.СуммаДокумента	= Объект.ИсчислениеПени.Итог("Сумма");
		
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура СписокСотрудниковСписокЗавершениеВыбора(ВыбранноеЗначение, Параметры) Экспорт

	ТекущаяСтрока = Элементы.ИсчислениеПени.ТекущиеДанные;
	Если  ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ВыбранноеЗначение <> Неопределено Тогда
		ТекущаяСтрока.ФизЛицо = ВыбранноеЗначение;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьПослеВыбораИзСпискаПредставленияПериодаРегистрации(ВыбранныйЭлемент, ДопПараметры) Экспорт
	
	Если ВыбранныйЭлемент = Неопределено Тогда
		Возврат;
	ИначеЕсли Год(ВыбранныйЭлемент.Значение) <> Год(ДопПараметры.ПериодРегистрации) Тогда
		РаботаСДиалогамиКлиент.НачалоВыбораИзСпискаПредставленияПериодаРегистрации(ДопПараметры.Элемент, ВыбранныйЭлемент.Значение, ЭтаФорма, ВыбранныйЭлемент.Значение, Истина);
		Возврат;	
	КонецЕсли;
	
	Объект.ПериодРегистрации = ВыбранныйЭлемент.Значение; 
	МесяцНачисленияСтрокой   = РаботаСДиалогамиКлиентСервер.ДатаКакМесяцПредставление(ВыбранныйЭлемент.Значение);
	Модифицированность = Истина;
	УстановитьПризнакиРаспределения();
	УправлениеФормой(ЭтаФорма);

КонецПроцедуры

// Процедуры работы со счетами и субконто

&НаКлиентеНаСервереБезКонтекста
Процедура ИзменитьПараметрыВыбораПолейСубконто(Форма, Суффикс, ИмяСчета, ИмяТабличнойЧасти = "", ЗаменаСубконтоНУ = Ложь)
	
	ПараметрыДокумента = СписокПараметровВыбораСубконто(Форма.Объект, Форма.Объект, "Субконто" + Суффикс + "%Индекс%", ИмяСчета);
	ПроцедурыБухгалтерскогоУчетаКлиентСервер.ИзменитьПараметрыВыбораПолейСубконто(Форма, Форма.Объект, "Субконто" + Суффикс + "%Индекс%", "Субконто" + Суффикс + "%Индекс%", ПараметрыДокумента, ЗаменаСубконтоНУ);	
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьЗаголовкиИДоступностьСубконто(ЭтаФорма, СчетУчета, ПоляФормы, ЗаголовкиПолей, СчетУчетаНУ = Неопределено, ЭтоТаблица = Ложь)
	
	ПроцедурыБухгалтерскогоУчетаКлиентСервер.ПриВыбореСчета(СчетУчета, ЭтаФорма, ПоляФормы, ЗаголовкиПолей);
	
	Если НЕ СчетУчетаНУ = Неопределено Тогда
		
		Для Каждого ПолеФормы Из ПоляФормы Цикл
			
			ПоляФормы.Вставить(ПолеФормы.Ключ, СтрЗаменить(ПолеФормы.Значение, "БУ", "НУ"));
			
		КонецЦикла;
		
		Для Каждого ЗаголовоеПоля Из ЗаголовкиПолей Цикл
			
			ЗаголовкиПолей.Вставить(ЗаголовоеПоля.Ключ, СтрЗаменить(ЗаголовоеПоля.Значение, "БУ", "НУ"));
			
		КонецЦикла;
		
		ПроцедурыБухгалтерскогоУчетаКлиентСервер.ПриВыбореСчета(СчетУчетаНУ, ЭтаФорма, ПоляФормы, ЗаголовкиПолей);
		
	КонецЕсли;

КонецПроцедуры

&НаСервереБезКонтекста
Процедура СчетЗатратБУПриИзмененииНаСервере(ДанныеОбъекта)
	
	ПроверитьВладельцаСубконтоПодразделениеБУНУ(ДанныеОбъекта);

КонецПроцедуры

&НаСервереБезКонтекста
Процедура СчетЗатратНУПриИзмененииНаСервере(ДанныеОбъекта)
	
	ПроцедурыБухгалтерскогоУчета.ПроверитьВладельцаСубконтоПодразделение(ДанныеОбъекта, 
	                                        ДанныеОбъекта.Организация, 
	                                        Новый Структура("НазваниеСубконтоБУ1, НазваниеСубконтоБУ2, НазваниеСубконтоБУ3, 
	                                                        |СубконтоБУ1, СубконтоБУ2, СубконтоБУ3",
	                                                        "СубконтоЗатратНУ1", "СубконтоЗатратНУ2", "СубконтоЗатратНУ3", 
	                                                        ДанныеОбъекта.СубконтоЗатратНУ1, ДанныеОбъекта.СубконтоЗатратНУ2, ДанныеОбъекта.СубконтоЗатратНУ3));
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ПроверитьВладельцаСубконтоПодразделениеБУНУ(ДанныеОбъекта)
	
	ПроцедурыБухгалтерскогоУчета.ПроверитьВладельцаСубконтоПодразделение(ДанныеОбъекта, 
	                                        ДанныеОбъекта.Организация, 
	                                        Новый Структура("НазваниеСубконтоБУ1, НазваниеСубконтоБУ2, НазваниеСубконтоБУ3, 
	                                                        |СубконтоБУ1, СубконтоБУ2, СубконтоБУ3",
	                                                        "СубконтоЗатратБУ1", "СубконтоЗатратБУ2", "СубконтоЗатратБУ3", 
	                                                        ДанныеОбъекта.СубконтоЗатратБУ1, ДанныеОбъекта.СубконтоЗатратБУ2, ДанныеОбъекта.СубконтоЗатратБУ3));
															
	ПроцедурыБухгалтерскогоУчета.ПроверитьВладельцаСубконтоПодразделение(ДанныеОбъекта, 
	                                        ДанныеОбъекта.Организация, 
	                                        Новый Структура("НазваниеСубконтоБУ1, НазваниеСубконтоБУ2, НазваниеСубконтоБУ3, 
	                                                        |СубконтоБУ1, СубконтоБУ2, СубконтоБУ3",
	                                                        "СубконтоЗатратНУ1", "СубконтоЗатратНУ2", "СубконтоЗатратНУ3", 
	                                                        ДанныеОбъекта.СубконтоЗатратНУ1, ДанныеОбъекта.СубконтоЗатратНУ2, ДанныеОбъекта.СубконтоЗатратНУ3));
															
КонецПроцедуры

&НаКлиенте
Процедура СубконтоНачалоВыбора(Элемент, ИмяЭлементаСубконто, ИндексСубконто, ИмяЭлементаСчета, СтрокаТаблицы, СтандартнаяОбработка)	
	
	ПараметрыДокумента = СписокПараметровВыбораСубконто(Объект, СтрокаТаблицы, ИмяЭлементаСубконто + "%Индекс%", ИмяЭлементаСчета);
	ПроцедурыБухгалтерскогоУчетаКлиент.НачалоВыбораЗначенияСубконто(ЭтаФорма, Элемент, ИндексСубконто, СтандартнаяОбработка, ПараметрыДокумента);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция СписокПараметровВыбораСубконто(ДанныеОбъекта, ПараметрыОбъекта, ШаблонИмяПоляОбъекта, ИмяСчета)
	
	СписокПараметров = Новый Структура;
	Для Индекс = 1 По 3 Цикл
		ИмяПоля = СтрЗаменить(ШаблонИмяПоляОбъекта, "%Индекс%", Индекс);
	КонецЦикла;
	СписокПараметров.Вставить("СчетУчета", 				  ПараметрыОбъекта[ИмяСчета]);	
	СписокПараметров.Вставить("Организация", 			  ДанныеОбъекта.Организация);
	СписокПараметров.Вставить("СтруктурноеПодразделение", ДанныеОбъекта.СтруктурноеПодразделение);
	СписокПараметров.Вставить("ВыбиратьПодразделенияОрганизации", Истина);

	Возврат СписокПараметров; 

КонецФункции

