﻿
#Область ФормаПоискНоменклатурыПоШтрихкоду

// В данной процедуре нужно переопределить параметры записи журнала регистрации при отказе ввода кода маркировки.
// 
// Параметры:
//  Форма - УправляемаяФорма - форма, для которой происходит обработка штрихкода.
//  СтруктураСообщения - Структура:
//   * ИмяСобытия - Строка - Имя события журнала регистрации.
//   * Уровень - Строка - Уровень журнала регистрации. Возможные уровни: "Информация", "Ошибка", "Предупреждение",
//        "Примечание".
//   * Данные - Любая ссылка, Число, Строка, Дата, Булево, Неопределено; Null; Тип - Данные журнала регистрации.
//   * СсылкаНаОбъект - Любая ссылка - Ссылка на объект, на основании которого будут полученные метаданные для записи
//        в журнал регистрации.
//   * КодМаркировки - Строка - Введеный код маркировки. Если значение кода не заполнено - ввод кода маркировки отменен
//        по инициативе пользователя.
Процедура ПриОпределенииИнформацииОбОтказеВводаКодаМаркиДляЖурналаРегистрации(Форма, СтруктураСообщения) Экспорт
	
	Если РазборИОбработкаКодовМаркировкиИСМПТКСлужебныйКлиентСерверПереопределяемый.ЭтоКонтекстОбъекта(Форма, "Документ.ЧекККМ") Тогда
		СтруктураСообщения.СсылкаНаОбъект = ПредопределенноеЗначение("Документ.ЧекККМ.ПустаяСсылка");
	КонецЕсли;
	
КонецПроцедуры

#Область ОбработкаШтрихкодаНоменклатуры

//Возвращает имя типовой процедуры обработки данных штрихкода из обработки события сканирования в форме ЧекККМ
//
Функция ИмяТиповойПроцедурыОбработкиШтрихкода() Экспорт
	
	//ПЕРЕОПРЕДЕЛЕНИЕ//
	//ЕРП, КА, УТ
	Возврат "ОбработатьШтрихкоды";
	
	//Розница
	//Возврат "ОбработатьКодМаркировки";
	///////////////////	
	
КонецФункции

Функция ПолучитьПустуюСсылкуУпаковка() Экспорт
	
	//ПЕРЕОПРЕДЕЛЕНИЕ//
	//ЕРП, КА, УТ
	//Возврат ПредопределенноеЗначение("Справочник.УпаковкиЕдиницыИзмерения.ПустаяСсылка");
	
	//Розница
	//Возврат ПредопределенноеЗначение("Справочник.БазовыеЕдиницыИзмерения.ПустаяСсылка");
	
	//БК
	Возврат ПредопределенноеЗначение("Справочник.КлассификаторЕдиницИзмерения.ПустаяСсылка");
	///////////////////
	
КонецФункции

#КонецОбласти

#КонецОбласти

#Область ОбработчикиКомандФормы

Процедура ОчиститьМаркиИСМПТК(Объект, СтрокаТабличнойЧасти) Экспорт 
	
	СтруктураПоиска = Новый Структура;
	СтруктураПоиска.Вставить("КлючСвязи", СтрокаТабличнойЧасти.КлючСвязи);
		
	Если СтрокаТабличнойЧасти.НеобходимостьВводаКодаМаркировкиИСМПТК Тогда
		МассивКодовМаркировки = Объект.КодыМаркировкиИСМПТК.НайтиСтроки(СтруктураПоиска);
		
		Для Каждого СтрокаКМ Из МассивКодовМаркировки Цикл
			Объект.КодыМаркировкиИСМПТК.Удалить(СтрокаКМ);
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ПроверкаВидаПродукцииВРозничныхДокументах

Процедура ПроверитьТабачныйВидПродукции(ЭтоМаркировка, ИмяФормы, ТекстОшибки) Экспорт 
	
	ПроверитьВидПродукцииОбщая(ЭтоМаркировка, ИмяФормы, ТекстОшибки, "маркированной табачной");
	
КонецПроцедуры

Процедура ПроверитьОбувнойВидПродукции(ЭтоМаркировка, ИмяФормы, ТекстОшибки) Экспорт
	
	ПроверитьВидПродукцииОбщая(ЭтоМаркировка, ИмяФормы, ТекстОшибки, "маркированной обувной");

КонецПроцедуры

Процедура ПроверитьЛекарственногоВидПродукции(ЭтоМаркировка, ИмяФормы, ТекстОшибки) Экспорт
	
	ПроверитьВидПродукцииОбщая(ЭтоМаркировка, ИмяФормы, ТекстОшибки, "маркированной фармакологической");
		
КонецПроцедуры

Процедура ПроверитьВидПродукцииОбщая(ЭтоМаркировка, ИмяФормы, ТекстОшибки, ТоварнаяГруппа) Экспорт
	
	ТекстОшибкиОбщийНеПредусмотрено = НСтр("ru = 'Сканирование %1 продукции в данном документе не предусмотрено.'");
	ТекстОшибкиОбщийНеПредусмотрено = РазборИОбработкаКодовМаркировкиИСМПТКСлужебныйКлиентСерверПереопределяемый.ПодставитьПараметрыВСтроку(ТекстОшибкиОбщийНеПредусмотрено, ТоварнаяГруппа);
	
	//ПЕРЕОПРЕДЕЛЕНИЕ//
	//ЕРП, КА, УТ
	#Область ЕРП_КА_УТ
	Если ПроверитьДокументНаПоддержкуИСМП(,ИмяФормы) Тогда
		
		ЭтоМаркировка = Истина;
		
	ИначеЕсли ИмяФормы = "Документ.ВозвратТоваровОтКлиента.Форма.ФормаДокумента"
		Или ИмяФормы = "Документ.ВозвратТоваровПоставщику.Форма.ФормаДокумента" 
		Или ИмяФормы = "Документ.ЗаказКлиента.Форма.ФормаДокумента"
		Или ИмяФормы = "Документ.ЗаказПоставщику.Форма.ФормаДокумента"
		Или ИмяФормы = "Документ.ЗаявкаНаВозвратТоваровОтКлиента.Форма.ФормаДокумента"
		Или ИмяФормы = "Документ.ЗаявлениеОВвозеТоваров.Форма.ФормаДокумента" 
		Или ИмяФормы = "Документ.КоммерческоеПредложениеКлиенту.Форма.ФормаДокумента"
		Или ИмяФормы = "Документ.КорректировкаПриобретения.Форма.ФормаДокумента" 
		Или ИмяФормы = "Документ.КорректировкаРеализации.Форма.ФормаДокумента"
		Или ИмяФормы = "Документ.ОприходованиеИзлишковТоваров.Форма.ФормаДокумента"
		Или ИмяФормы = "Документ.ОтгрузкаТоваровСХранения.Форма.ФормаДокумента" 
		Или ИмяФормы = "Документ.ОтчетОРозничныхПродажах.Форма.ФормаДокумента" 
		Или ИмяФормы = "Документ.ПеремещениеТоваров.Форма.ФормаДокумента" 
		Или ИмяФормы = "Документ.ПересчетТоваров.Форма.ФормаДокумента" 
		Или ИмяФормы = "Документ.ПорчаТоваров.Форма.ФормаДокумента" 
		Или ИмяФормы = "Документ.ПриемкаТоваровНаХранение.Форма.ФормаДокумента" 
		Или ИмяФормы = "Документ.ПриобретениеТоваровУслуг.Форма.ФормаДокумента" 
		Или ИмяФормы = "Документ.ПриходныйОрдерНаТовары.Форма.ФормаДокумента" 
		Или ИмяФормы = "Документ.ПрочееОприходованиеТоваров.Форма.ФормаДокумента" 
		Или ИмяФормы = "Документ.РасходныйОрдерНаТовары.Форма.ФормаДокумента" 
		Или ИмяФормы = "Документ.РеализацияТоваровУслуг.Форма.ФормаДокумента" 
		Или ИмяФормы = "Документ.РегистрацияЦенНоменклатурыПоставщика.Форма.ФормаДокумента" 
		Или ИмяФормы = "Документ.СборкаТоваров.Форма.ФормаДокумента" 
		Или ИмяФормы = "Документ.СписаниеИзЭксплуатации.Форма.ФормаДокумента" 
		Или ИмяФормы = "Документ.СписаниеНедостачТоваров.Форма.ФормаДокумента" 
		Или ИмяФормы = "Документ.ТаможеннаяДекларацияИмпорт.Форма.ФормаДокумента" 
		Или ИмяФормы = "Документ.ЭСФ.Форма.ФормаДокумента" 
		Или ИмяФормы = "Документ.ЭлектронныйДокументВС.Форма.ФормаДокумента" 
		Или ИмяФормы = "Документ.СопоставлениеСНТиФНО.Форма.ФормаДокумента" 
		Или ИмяФормы = "Документ.СНТ.Форма.ФормаДокумента" Тогда
				
		ЭтоМаркировка = Истина;
		ТекстОшибки   = ТекстОшибкиОбщийНеПредусмотрено;
	КонецЕсли;
	#КонецОбласти
	
	//Розница
	#Область Розница
	//Если ПроверитьДокументНаПоддержкуИСМП(, ИмяФормы) Тогда
	//	
	//	ЭтоМаркировка = Истина;
	//	
	//ИначеЕсли ИмяФормы = "Документ.ВозвратТоваровОтПокупателя.Форма.ФормаДокумента"
	//	Или ИмяФормы = "Документ.ВозвратТоваровПоставщику.Форма.ФормаДокумента" 
	//	Или ИмяФормы = "Документ.ПеремещениеТоваров.Форма.ФормаДокумента"
	//	Или ИмяФормы = "Документ.ПоступлениеТоваров.Форма.ФормаДокумента"
	//	Или ИмяФормы = "Документ.СборкаТоваров.Форма.ФормаДокумента"
	//	Или ИмяФормы = "Документ.РеализацияТоваров.Форма.ФормаДокумента" 
	//	Или ИмяФормы = "Документ.ЗаказПоставщику.Форма.ФормаДокумента"
	//	Или ИмяФормы = "Документ.ЗаказПокупателя.Форма.ФормаДокумента" 
	//	Или ИмяФормы = "Документ.СписаниеТоваров.Форма.ФормаДокумента"
	//	Или ИмяФормы = "Документ.ОприходованиеТоваров.Форма.ФормаДокумента"
	//	Или ИмяФормы = "Документ.СборкаТоваров.Форма.ФормаДокумента" 
	//	Или ИмяФормы = "Документ.ОрдерНаПеремещениеТоваров.Форма.ФормаДокумента" Тогда
	//	
	//	ЭтоМаркировка = Истина;
	//	ТекстОшибки   = ТекстОшибкиОбщийНеПредусмотрено;
	//	
	//КонецЕсли;
	#КонецОбласти
	///////////////////
	
КонецПроцедуры

#КонецОбласти

#Область ФормаПроверкиКМ

Процедура ПриЗакрытииФормыПроверкиКМ(Результат, ДополнительныеПараметры) Экспорт
	
	Форма = ДополнительныеПараметры.Форма;
	
	Если ПроверитьДокументНаПоддержкуИСМП(Форма) Тогда		
		Оповестить("ЗакрытиеФормыПроверкиКМ", Результат, Форма.УникальныйИдентификатор);
	Иначе
		Форма.Прочитать();
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриУстановкеПараметровОткрытияФормыПроверкиКМ(Форма, Параметры) Экспорт

	Если РазборИОбработкаКодовМаркировкиИСМПТКСлужебныйКлиентСервер.ЭтоДокументПоНаименованию(Форма, "ЧекККМ")
		Или Форма.ИмяФормы = "Обработка.РМКУправляемыйРежим.Форма.Форма" Тогда
		
		Параметры.ПроверятьМодифицированность   = Ложь;
		ПараметрыОповещенияПриЗакрытии = Новый Структура;
		ПараметрыОповещенияПриЗакрытии.Вставить("Форма", Форма);
		Параметры.ОписаниеОповещенияПриЗакрытии = Новый ОписаниеОповещения("ПриЗакрытииФормыПроверкиКМ", РозничноеВыбытиеИСМПТККлиент, ПараметрыОповещенияПриЗакрытии);
		
	КонецЕсли;

КонецПроцедуры

Процедура ВыполнитьПереопределяемуюКомандуЧекККМ(Форма, Команда, ДополнительныеПараметры) Экспорт
	
	//Открытие из формы чека ККМ
	Если Команда.Имя = "ПроверитьКодыМаркировки" Тогда
		
		ОчиститьСообщения();
		ПараметрыОткрытия = РозничноеВыбытиеИСМПТККлиент.ПараметрыОткрытияФормыПроверкиКМ(Форма);
		
		ОписаниеОповещения = ПараметрыОткрытия.ОписаниеОповещенияПриЗакрытии;
		ПараметрыОткрытия.Удалить("ОписаниеОповещенияПриЗакрытии"); //Удаляем служебные значения
		ПараметрыОткрытия.Удалить("ИмяРеквизитаФормыОбъект"); //Удаляем служебные значения
		ПараметрыОткрытия.Удалить("ИмяРеквизитаОрганизация"); //Удаляем служебные значения
				
		ПараметрыОткрытия.Вставить("СписокКМ", 	  Форма.Объект.КодыМаркировкиИСМПТК);
		ПараметрыОткрытия.Вставить("ТоварыЧека",  Форма.Объект.Товары);
		ПараметрыОткрытия.Вставить("Организация", форма.Объект.Организация);
		ПараметрыОткрытия.Вставить("ОбъединятьСтрокиСОдинаковымиТоварами", Истина);
		ПараметрыОткрытия.Вставить("ВызовИзФормыСпискаЧеков", Ложь);
		ПараметрыОткрытия.РедактированиеФормыНедоступно = Форма.ТолькоПросмотр;
		
		//Дополнительный параметр, присуствующий только при вызове из формы ЧекККМВозврат
		ПараметрыОткрытия.Вставить("ДанныеВозвращаемогоКода", Неопределено);
				
		ОткрытьФорму("Обработка.РозничноеВыбытиеМаркированнойПродукцииИСМПТК.Форма.ПроверкаКМ", ПараметрыОткрытия, Форма, Форма.УникальныйИдентификатор,,, ОписаниеОповещения, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
		
	КонецЕсли;
			
КонецПроцедуры

Функция ПолучитьНастройкуОбъединенияСтрокВЧеке(Форма) Экспорт 
	
	Возврат Форма.НаборПравИНастроек.ОбъединятьПозицииСОдинаковымТоваром;
	
КонецФункции

Процедура ОткрытьФормуПодбораНоменклатурыИРегистрацииШК_Общая(ИсходныеДанныеВходящие, ЭтоКодМарки, ДокументОбъект) Экспорт
	
	Операция = "СопоставлениеНоменклатуры";
	ТекстСообщенияНеизвестныйШтрихкод  =  НСтр("ru = 'Не удалось выполнить разбор отсканированного штрихкода.'");
	
	Если ТипЗнч(ИсходныеДанныеВходящие) = Тип("Структура") Тогда
		ИсходныеДанные = ИсходныеДанныеВходящие;
	ИначеЕсли ТипЗнч(ИсходныеДанныеВходящие) = Тип("Массив") Тогда
		ИсходныеДанные = ИсходныеДанныеВходящие[0];
	КонецЕсли;
	
	Если ЭтоКодМарки Тогда
		СтруктураКодовМаркировки = РозничноеВыбытиеИСМПТКВызовСервера.ПолучитьКодыМаркировкиПриРозничнойПродаже(Новый Структура("Штрихкод, ФорматBase64", ИсходныеДанные.Штрихкод, Истина));
		//Если удалось разобрать код, вернется структура. Если нет - текст сообщения об ошибке.
		Если ТипЗнч(СтруктураКодовМаркировки) = Тип("Строка") Тогда
			РазборИОбработкаКодовМаркировкиИСМПТКСлужебныйКлиентСерверПереопределяемый.СообщитьПользователю(СтруктураКодовМаркировки);
			//Был отсканирован Код маркировки, но не удалось его распознать - выводим сообщение об ошибке и не продолжаем разбор.
			Возврат;
		КонецЕсли;
	Иначе
		//Отсканирован не код маркировки. Пытаемся проверить, является ли строка штрихкодом ЕАН.
		//В библиотеке марикровки при сканировании ЕАН в документах поведение отличается от Чеков, поэтому обработку данного случая
		//выполняем уже на стороне типового решения в розничном контуре.
		СтруктураКодовМаркировки = Неопределено;
	КонецЕсли;
	
	ДанныеДляСопоставленияНоменклатуры = Новый Структура(); //передается в параметрах открытия формы подбора
	
	Если СтруктураКодовМаркировки = Неопределено Тогда
		
		//Возможно, был отсканирован ЕАН
		ТипШКСоответствуетКМ = РозничноеВыбытиеИСМПТКПереопределяемый.ПроверитьТипШтрихкодаВФормеВводаКМ(ИсходныеДанные.Штрихкод); //Обрабатываем обратный результат, когда ШК - это ЕАН8/ЕАН13
		Если Не ТипШКСоответствуетКМ Тогда
			//Был отсканирован ЕАН, берем его без изменений для заполнения данных:
			ДекодированныйШтрихкод = РазборИОбработкаКодовМаркировкиИСМПТКСлужебныйКлиентСервер.Base64ВШтрихкод(ИсходныеДанные.Штрихкод);
			ИсходныйШтрихкод = ДекодированныйШтрихкод;
			EAN 			 = ДекодированныйШтрихкод;
		Иначе
			//Когда отсканирован неизвестный ШК, не являющийся ни КМ, ни ЕАН. Возможно, это какой-то внутренний код - регистрацию ШК не продолжаем.
			РазборИОбработкаКодовМаркировкиИСМПТКСлужебныйКлиент.ВывестиСообщениеОбОшибке(ТекстСообщенияНеизвестныйШтрихкод);
			Возврат;
		КонецЕсли;

	Иначе
		//Был отсканирован код маркировки и его удалось корректно разобрать - берем данные из структуры разбора.
		ИсходныйШтрихкод = СтруктураКодовМаркировки.КодМаркировки;
		EAN 			 = СтруктураКодовМаркировки.EAN;
	КонецЕсли;
	
	ИсходныеДанные = Новый Структура("Количество, Штрихкод", 1, ИсходныйШтрихкод);
	ДанныеДляСопоставленияНоменклатуры.Вставить("ИсходныеДанные", ИсходныеДанные); //содержит структуру "Количество, Штрихкод", где штрихкод это отсканированный КМ
	
	ШтрихкодыКСопоставлению = Новый Массив();
	ДанныеШтрихкода = Новый Структура("Количество, Штрихкод", 1, EAN);
	ШтрихкодыКСопоставлению.Добавить(ДанныеШтрихкода);
	ДанныеДляСопоставленияНоменклатуры.Вставить("ШтрихкодыКСопоставлению", ШтрихкодыКСопоставлению); //содержит массив, где каждый элемент - структура "Количество, Штрихкод", где штрихкод - это EAN из КМ, который необходимо проверить по регистру Штрихкодов
	
	ПараметрыОткрытияФормы  = Новый Структура("ДанныеДляСопоставленияНоменклатуры, Операция, НеизвестныеШтрихкоды, СтруктураКодовМаркировки", ДанныеДляСопоставленияНоменклатуры, Операция, ШтрихкодыКСопоставлению, СтруктураКодовМаркировки);
	ДополнительныеПараметры = Новый Структура("ДанныеСоСканераСтруктура, ЭтоКодМаркировки", ИсходныеДанные, ЭтоКодМарки); 
	
	ОбработкаОповещенияПодборНоменклатуры = Новый ОписаниеОповещения("ОбработатьКодМаркировкиИСМПТК", ДокументОбъект, ДополнительныеПараметры);
	РежимОткрытия = РежимОткрытияОкнаФормы.БлокироватьОкноВладельца;
	
	ОткрытьФорму("Обработка.РозничноеВыбытиеМаркированнойПродукцииИСМПТК.Форма.ПоискНоменклатурыПоШтрихкоду", ПараметрыОткрытияФормы, ДокументОбъект,,,, ОбработкаОповещенияПодборНоменклатуры, РежимОткрытия);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция НеобходимоОбновитьСтатусыСерий(ТекущиеДанные, КэшированныеЗначения, ПараметрыУказанияСерий, Удаление = Ложь) Экспорт
	
	//ПЕРЕОПРЕДЕЛЕНИЕ//
	//ЕРП, КА, УТ
	Возврат Неопределено;
	
	//Розница
	#Область Розница
	//Если ТекущиеДанные = Неопределено Тогда
	//	Возврат Ложь;
	//КонецЕсли;
	//
	//Если ПараметрыУказанияСерий = Неопределено Тогда
	//	Возврат Ложь;
	//КонецЕсли;
	//
	//Если НЕ ПараметрыУказанияСерий.ИспользоватьСерииНоменклатуры Тогда
	//	Возврат Ложь;
	//КонецЕсли;
	//
	//Если Удаление Тогда
	//	Возврат Истина;
	//КонецЕсли;
	//
	//ИмяТЧТовары = "";
	//
	//Если Не ПараметрыУказанияСерий.Свойство("ИмяТЧТовары", ИмяТЧТовары) Тогда
	//	ИмяТЧТовары = "Товары";
	//КонецЕсли;
	//
	//ИмяТЧСерии  = "";
	//
	//Если Не ПараметрыУказанияСерий.Свойство("ИмяТЧСерии", ИмяТЧСерии) Тогда
	//	ИмяТЧСерии = "Серии";
	//КонецЕсли;
	//
	//Если ИмяТЧТовары = ИмяТЧСерии Тогда
	//	Если КэшированныеЗначения.Номенклатура = ТекущиеДанные.Номенклатура Тогда
	//		Возврат Ложь;
	//	Иначе
	//		Возврат Истина;
	//	КонецЕсли;
	//КонецЕсли;
	//
	//ТекстПоляСвязи = "";
	//
	//Если ТекущиеДанные = Неопределено Тогда
	//	Возврат Ложь;
	//КонецЕсли;
	//Для Каждого СтрокаМассива Из ПараметрыУказанияСерий.ПоляСвязи Цикл
	//	ТекстПоляСвязи = ТекстПоляСвязи + "," + СтрокаМассива;
	//КонецЦикла;
	//
	//Если ПараметрыУказанияСерий.Свойство("ЭтоЗаказ")
	//	И ПараметрыУказанияСерий.ЭтоЗаказ
	//	И ПараметрыУказанияСерий.СкладскиеОперации.Найти(ПредопределенноеЗначение("Перечисление.СкладскиеОперации.ОтгрузкаКомплектующихДляСборки")) = Неопределено
	//	И ПараметрыУказанияСерий.СкладскиеОперации.Найти(ПредопределенноеЗначение("Перечисление.СкладскиеОперации.ОтгрузкаКомплектовДляРазборки")) = Неопределено Тогда
	//	ЕстьОтменаСтроки = Истина;
	//Иначе
	//	ЕстьОтменаСтроки = Ложь;
	//КонецЕсли;
	//
	//Если ЕстьОтменаСтроки Тогда
	//	ТекстПоляСвязи = ТекстПоляСвязи + ",Отменено";
	//КонецЕсли;
	//
	//ИмяКолонкиКоличество = "";
	//Если Не ПараметрыУказанияСерий.Свойство("ИмяКолонкиКоличество", ИмяКолонкиКоличество) Тогда
	//	ИмяКолонкиКоличество = "Количество";
	//КонецЕсли;
	//
	//Если Не ОбщегоНазначенияРТКлиентСервер.СтруктурыРавны(КэшированныеЗначения, ТекущиеДанные,
	//	ИмяКолонкиКоличество + ",Номенклатура,Характеристика"+ТекстПоляСвязи) Тогда
	//	Возврат Истина;
	//Иначе
	//	Возврат Ложь;
	//КонецЕсли;
	#КонецОбласти
	///////////////////
		
КонецФункции

Функция ПроверитьДокументНаПоддержкуИСМП(Форма = Неопределено, ИмяФормы = Неопределено) Экспорт
	
	Если Не Форма = Неопределено Тогда
		ИмяФормы = Форма.ИмяФормы;
	КонецЕсли;
	
	//ПЕРЕОПРЕДЕЛЕНИЕ//
	//ЕРП, КА, УТ
	Если ИмяФормы    = "Документ.ЧекККМ.Форма.ФормаДокументаРМК"
		Или ИмяФормы = "Документ.ЧекККМ.Форма.ФормаДокумента" 
		Или ИмяФормы = "Документ.ЧекККМВозврат.Форма.ФормаДокументаРМК" 
		Или ИмяФормы = "Документ.ЧекККМВозврат.Форма.ФормаДокумента" Тогда
		
	//Розница
	//Если ИмяФормы    = "Документ.ЧекККМ.Форма.ФормаДокумента"
	//	Или ИмяФормы = "Обработка.РМКУправляемыйРежим.Форма.Форма" Тогда
	
	//БК
	//Требуется адаптация
	///////////////////
		Возврат Истина;
	Иначе 
		Возврат Ложь;
	КонецЕсли;
		
КонецФункции

#КонецОбласти

#Область Переопределение

Процедура ОбработкаВнешнегоСобытияЧекВозврат(Форма, ДанныеСоСканераСтруктура, ФормаИсточникСтрока, НесоответствиеТоваровРазрешено = Ложь) Экспорт
	
	Если ТипЗнч(ДанныеСоСканераСтруктура) = Тип("Структура") Тогда
		//Данные со сканера в конфигурации Розница
		Штрихкод = ДанныеСоСканераСтруктура.Штрихкод;
	ИначеЕсли ТипЗнч(ДанныеСоСканераСтруктура) = Тип("Массив") Тогда
		//В конфигурации ЕРП, УТ
		Штрихкод = ДанныеСоСканераСтруктура[0].Штрихкод;
	КонецЕсли;	
	
	ИсходныйШтрихкод = РазборИОбработкаКодовМаркировкиИСМПТКСлужебныйКлиентСервер.ШтрихкодВBase64(Штрихкод);
	ДанныеМаркировки = РозничноеВыбытиеИСМПТКВызовСервера.РазобратьШтриховойКодТовара(ИсходныйШтрихкод, Истина);
	
	ИмяТиповойПроцедурыОбработатьШтрихкод = РозничноеВыбытиеИСМПТККлиентПереопределяемый.ИмяТиповойПроцедурыОбработкиШтрихкода();
	
	Если НЕ ДанныеМаркировки.Разобран Тогда
		
		//Это не код маркировки и не ЕАН, но это может быть произвольный зарегистрированный штрихкод номенклатуры. 
		//В этом случае потребуется выполнить типовую обработку.
		//В типовой механизм отправляем только в случае, когда отсканированный ШК это не поврежденный код маркировки.
		ДанныеРазобранногоШКДляПроверки = РозничноеВыбытиеИСМПТКВызовСервера.ПроверитьРазборШтрихкода(ИсходныйШтрихкод);
		НайденыСпецсимволы = РазборИОбработкаКодовМаркировкиИСМПТКСлужебныйКлиентСервер.НайденНедопустимыйСимволXML(Штрихкод) <> 0;
		ЭтоКодМаркировки   = ДанныеМаркировки.ТипИдентификатораТовара = ПредопределенноеЗначение("Перечисление.ТипыИдентификаторовШКТовараИСМПТК.КодТовараВФорматеDataMatrixGS1");
		                
		Если НЕ (ДанныеРазобранногоШКДляПроверки = Неопределено
				 И ЭтоКодМаркировки И НайденыСпецсимволы)  //Это может быть КМ с частично отсутствующими спецсимволами или с нарушенной структурой групп идентификаторов применения
			И НЕ (Не ДанныеРазобранногоШКДляПроверки = Неопределено
				 И ЭтоКодМаркировки И Не НайденыСпецсимволы) Тогда //Это код маркировки без спецсимволов вообще (нормализованный или ошибочно сгенерированный)
			Выполнить("Форма." + ИмяТиповойПроцедурыОбработатьШтрихкод + "(ДанныеСоСканераСтруктура)");
		КонецЕсли;
		Возврат;
		
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ДанныеМаркировки.ОписаниеОшибки) Тогда
		
		ТекстСообщения = НСтр("ru = 'При разборе данных произошла ошибка: '") + ДанныеМаркировки.ОписаниеОшибки;
		РазборИОбработкаКодовМаркировкиИСМПТКСлужебныйКлиентСерверПереопределяемый.СообщитьПользователю(ТекстСообщения);
				
		//Т.к. в этом случае скорее всего штрихкод - код макрировки не учитываемой ТГ, нужно преобразовать штрихкод, чтобы в нем не было спецсимволов
		Если ТипЗнч(ДанныеСоСканераСтруктура) = Тип("Структура") Тогда
			//Данные со сканера в конфигурации Розница
			ДанныеСоСканераСтруктура.Штрихкод = ДанныеМаркировки.EAN;
		ИначеЕсли ТипЗнч(ДанныеСоСканераСтруктура) = Тип("Массив") Тогда
			//В конфигурации ЕРП, УТ
			ДанныеСоСканераСтруктура[0].Штрихкод = ДанныеМаркировки.EAN;
		КонецЕсли;
		Возврат;
		
	Иначе
		
		ЭтоКодМарки	 	  = РозничноеВыбытиеИСМПТККлиент.ЭтоКодМаркировки(ДанныеМаркировки.ТипИдентификатораТовара);
		НормализованныйКМ = РозничноеВыбытиеИСМПТКВызовСервера.НормализованныйШтрихкод(ДанныеМаркировки.ШтрихкодBase64);
		
		//1. Проверяем наличие отсканированного КМ в документе, чтобы избежать дублирования кодов
		НайденныйВЧекеКМ = Форма.Объект.КодыМаркировкиИСМПТК.НайтиСтроки(Новый Структура("КодМаркировки", НормализованныйКМ)).Количество();
		Если Не НайденныйВЧекеКМ = 0 Тогда
			ТекстСообщения = НСтр("ru = 'Код маркировки уже указан в документе!'"); 
			Форма.ВывестиСообщениеОбОшибке(ТекстСообщения);		
			Возврат;
		КонецЕсли;	
		
//ПЕРЕОПРЕДЕЛЕНИЕ//
//ЕРП, КА, УТ
#Область ЕРП_КА_УТ
		ДанныеНоменклатуры = РозничноеВыбытиеИСМПТККлиент.ПолучитьНоменклатуруПоШтрихкодуВРозничномКонтуре(ДанныеМаркировки.EAN);
		Если ДанныеНоменклатуры = Неопределено 
			Или (ТипЗнч(ДанныеНоменклатуры) = Тип("Структура") И ДанныеНоменклатуры.Номенклатура = Неопределено) Тогда

			//В чеке Продажи в этом случае предлагаем зарегистрировать новую номенклатуру, но в возврате такую возможность не предоставляем.
			ТекстСообщения = НСтр("ru = 'Не удалось определить номенклатуру для отсканированного кода маркировки.'"); 
			Форма.ВывестиСообщениеОбОшибке(ТекстСообщения);	
			
		Иначе
#КонецОбласти
		
//Розница
#Область Розница
		//ДанныеНоменклатуры = ПолучитьНоменклатуруПоШтрихкодуВРозничномКонтуре(ДанныеМаркировки.EAN);
		//Если ДанныеНоменклатуры = Неопределено Тогда 
		//				
		//	//В чеке Продажи в этом случае предлагаем зарегистрировать новую номенклатуру, но в возврате такую возможность не предоставляем.
		//	ТекстСообщения = НСтр("ru = 'Не удалось определить номенклатуру для штрихкода! Товар не был добавлен в чек!'"); 
		//	РазборИОбработкаКодовМаркировкиИСМПТКСлужебныйКлиентСерверПереопределяемый.СообщитьПользователю(ТекстСообщения);
		//	
		//ИначеЕсли ДанныеНоменклатуры.Номенклатура = Неопределено Тогда
		//	
		//	//Для конфигураций, поддерживающих возможность регистрации неуникальных штрихкодов номенклатуры. 
		//	//В этом случае однозначно определить ном-ру по ЕАН нельзя, и при продаже пользователю предоставляется
		//	//возможность уточнения товара. При возврате данное действие излишне, т.к. в большинстве случаев 
		//	//ТЧ чека возврата предзаполнена поданным продажи и давать возможность выбрать товар по ШК некорректно.
		//	//Поэтому проверяем, какая из номенклатур, относящихся к ЕАН, присутствует в ТЧ, и связываем код 
		//	//маркировки с ней. Если таких товаров в чеке несколько, связываем с первым из выборки, т.к. 
		//	//по большому счету не имеет значения с какой строкой связан КМ, указанный в документе,
		//	//он все равно будет передан в ИС МПТ корректно.
		//	
		//	ТоварНайден = Ложь;
		//	МассивОбнаруженныхТоваровПоШК = РозничноеВыбытиеИСМПТККлиент.ПолучитьНоменклатуруПоШтрихкодуВРозничномКонтуре(ДанныеМаркировки.EAN, Истина);
		//	Для Каждого СведенияШК Из МассивОбнаруженныхТоваровПоШК Цикл
		//		СтруктураПоискаПоЧеку = Новый Структура("Номенклатура, Характеристика, Упаковка", 
		//												СведенияШК.Номенклатура, СведенияШК.Характеристика, СведенияШК.Упаковка);
		//		НайденныеСтроки = Форма.Объект.Товары.НайтиСтроки(СтруктураПоискаПоЧеку);
		//		Если Не НайденныеСтроки.Количество() = 0 Тогда
		//			ТоварНайден = Истина;
		//			
		//			ВидПродукцииШК = РозничноеВыбытиеИСМПТККлиент.ПолучитьВидПродукцииПоНоменклатуре(СведенияШК.Номенклатура);
		//			УчетТГВключен  = РозничноеВыбытиеИСМПТКВызовСервера.ПроверитьВключениеУчетаТГ(ВидПродукцииШК);
		//		
		//			Если Не ЭтоКодМарки 
		//				И ЗначениеЗаполнено(ВидПродукцииШК)
		//				И УчетТГВключен Тогда
		//				ТекстСообщения = НСтр("ru = 'Необходимо отсканировать код маркировки с возвращаемого товара!'");
		//				Форма.ВывестиСообщениеОбОшибке(ТекстСообщения);
		//			Иначе
		//				ПараметрыОткрытия = РозничноеВыбытиеИСМПТККлиент.ПараметрыОткрытияФормыПроверкиКМ(Форма);
		//				
		//				ОписаниеОповещения = ПараметрыОткрытия.ОписаниеОповещенияПриЗакрытии;
		//				ПараметрыОткрытия.Удалить("ОписаниеОповещенияПриЗакрытии"); //Удаляем служебные значения
		//				ПараметрыОткрытия.Удалить("ИмяРеквизитаФормыОбъект"); //Удаляем служебные значения
		//				ПараметрыОткрытия.Удалить("ИмяРеквизитаОрганизация"); //Удаляем служебные значения
		//				
		//				ПараметрыОткрытия.Вставить("СписокКМ", 	  Форма.Объект.КодыМаркировкиИСМПТК);
		//				ПараметрыОткрытия.Вставить("ТоварыЧека",  Форма.Объект.Товары);
		//				ПараметрыОткрытия.Вставить("Организация", форма.Объект.Организация);
		//				ПараметрыОткрытия.Вставить("ОбъединятьСтрокиСОдинаковымиТоварами", Истина);
		//				ПараметрыОткрытия.Вставить("ВызовИзФормыСпискаЧеков", Ложь);
		//				ПараметрыОткрытия.РедактированиеФормыНедоступно = Форма.ТолькоПросмотр;
		//				
		//				//Дополнительный параметр, присуствующий только при вызове из формы ЧекККМВозврат
		//				ДанныеКМ = Новый Структура("ДанныеМаркировки, ДанныеНоменклатуры", ДанныеМаркировки, СведенияШК);
		//				ПараметрыОткрытия.Вставить("ДанныеВозвращаемогоКода", ДанныеКМ);
		//				
		//				ОткрытьФорму("Обработка.РозничноеВыбытиеМаркированнойПродукцииИСМПТК.Форма.ПроверкаКМ", ПараметрыОткрытия, Форма, Форма.УникальныйИдентификатор,,, ОписаниеОповещения, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);	
		//				Возврат;
		//			КонецЕсли;
		//			Прервать;
		//		КонецЕсли;
		//	КонецЦикла;
		//	
		//	Если Не ТоварНайден Тогда
		//		ТекстСообщения = НСтр("ru = 'Не удалось определить номенклатуру для штрихкода! Товар не был добавлен в чек!'"); 
		//		РазборИОбработкаКодовМаркировкиИСМПТКСлужебныйКлиентСерверПереопределяемый.СообщитьПользователю(ТекстСообщения);
		//	КонецЕсли;			
		//	
		//Иначе
#КонецОбласти
///////////////////
	
			Номенклатура     	 = ДанныеНоменклатуры.Номенклатура;
			Характеристика   	 = ДанныеНоменклатуры.Характеристика;
			Упаковка		 	 = ДанныеНоменклатуры.Упаковка;
			ИспользуютсяУпаковки = ДанныеНоменклатуры.ИспользуютсяУпаковки;
			
			Если Не ЭтоКодМарки Тогда
				//Если это штрихкод ЕАН и он зарегистрирован на номенклатуру с особенностями учета,
				//и включен учет по этой товарной группе - нужно запросить сканирование кода маркировки
				ЭтоЕАН = РазборИОбработкаКодовМаркировкиИСМПТКСлужебныйКлиентСерверПовтИсп.ЭтоGTIN(ДанныеМаркировки.EAN);
				ВидПродукцииШК = РозничноеВыбытиеИСМПТККлиент.ПолучитьВидПродукцииПоНоменклатуре(Номенклатура);
				УчетТГВключен  = РозничноеВыбытиеИСМПТКВызовСервера.ПроверитьВключениеУчетаТГ(ВидПродукцииШК);
				
				Если ЗначениеЗаполнено(ВидПродукцииШК) 
					И УчетТГВключен И ЭтоЕАН Тогда
					//Открываем форму предупреждения, что нужно сканировать код маркировки
					ДанныеНоменклатурыКода = Новый Структура("Номенклатура, Характеристика, ЕдиницаИзмерения", Номенклатура, Характеристика, ?(ИспользуютсяУпаковки, Упаковка, РозничноеВыбытиеИСМПТККлиентПереопределяемый.ПолучитьПустуюСсылкуУпаковка()));
					Форма.ДобавлениеМПБезКодаМаркировкиПредупреждение(ВидПродукцииШК, ДанныеМаркировки, ДанныеНоменклатурыКода);
				Иначе
			         Выполнить("Форма." + ИмяТиповойПроцедурыОбработатьШтрихкод + "(ДанныеСоСканераСтруктура)");
				КонецЕсли;
				Возврат;
			КонецЕсли;
			
			//2. Проверяем наличие товара, к которому относится отсканированный КМ, в таблице: добавлять КМ по отсутствующим в чеке товарам при возврате нельзя
			СтруктураПоискаПоЧеку = Новый Структура("Номенклатура, Характеристика, Упаковка");
			СтруктураПоискаПоЧеку.Вставить("Номенклатура",   Номенклатура);
			СтруктураПоискаПоЧеку.Вставить("Характеристика", Характеристика);
			СтруктураПоискаПоЧеку.Вставить("Упаковка", 		 Упаковка);
						
			НайденныеСтрокиТоваровЧекаКоличество = Форма.Объект.Товары.НайтиСтроки(СтруктураПоискаПоЧеку).Количество();
			
			Если Не НайденныеСтрокиТоваровЧекаКоличество = 0 Тогда
				//3. Открываем форму ПроверкаКМ для подтверждения добавления КМ в чек
				ПараметрыОткрытия = РозничноеВыбытиеИСМПТККлиент.ПараметрыОткрытияФормыПроверкиКМ(Форма);
				
				ОписаниеОповещения = ПараметрыОткрытия.ОписаниеОповещенияПриЗакрытии;
				ПараметрыОткрытия.Удалить("ОписаниеОповещенияПриЗакрытии"); //Удаляем служебные значения
				ПараметрыОткрытия.Удалить("ИмяРеквизитаФормыОбъект"); //Удаляем служебные значения
				ПараметрыОткрытия.Удалить("ИмяРеквизитаОрганизация"); //Удаляем служебные значения
				
				ПараметрыОткрытия.Вставить("СписокКМ", 	  Форма.Объект.КодыМаркировкиИСМПТК);
				ПараметрыОткрытия.Вставить("ТоварыЧека",  Форма.Объект.Товары);
				ПараметрыОткрытия.Вставить("Организация", форма.Объект.Организация);
				ПараметрыОткрытия.Вставить("ОбъединятьСтрокиСОдинаковымиТоварами", Истина);
				ПараметрыОткрытия.Вставить("ВызовИзФормыСпискаЧеков", Ложь);
				ПараметрыОткрытия.РедактированиеФормыНедоступно = Форма.ТолькоПросмотр;
				
				//Дополнительный параметр, присуствующий только при вызове из формы ЧекККМВозврат
				ДанныеКМ = Новый Структура("ДанныеМаркировки, ДанныеНоменклатуры", ДанныеМаркировки, ДанныеНоменклатуры);
				ПараметрыОткрытия.Вставить("ДанныеВозвращаемогоКода", ДанныеКМ);
				
				ОткрытьФорму("Обработка.РозничноеВыбытиеМаркированнойПродукцииИСМПТК.Форма.ПроверкаКМ", ПараметрыОткрытия, Форма, Форма.УникальныйИдентификатор,,, ОписаниеОповещения, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);	
				Возврат;
			Иначе
				Если НесоответствиеТоваровРазрешено Тогда 
					//Конфигурация поддерживает заполнение чека на возврат товарами не из чека продажи
					РозничноеВыбытиеИСМПТККлиент.ОбработкаВнешнегоСобытия(Форма, ДанныеСоСканераСтруктура, ФормаИсточникСтрока);
				Иначе	
					ТекстСообщения = НСтр("ru = 'Отсканированный код маркировки относится к номенклатуре, отсутствующей в чеке.'"); 
					Форма.ВывестиСообщениеОбОшибке(ТекстСообщения);	
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;		
	КонецЕсли;
		
КонецПроцедуры

#Область Розница

#Область ФормаВыборДанныхПоискаПоКМ

Процедура ОткрытьФормуУточненияДанныхТоварнойПозиции(Форма, НормализованныйКМ) Экспорт 
	
	//ПЕРЕОПРЕДЕЛЕНИЕ//
	//ЕРП, КА, УТ
	Возврат;
	
	//Розница
	#Область Розница
	//СтруктураПараметровКлиента = ПолученШтрихкодИзСШК(Форма, НормализованныйКМ);
	//ОбработатьДанныеПодбораТовара(Форма, СтруктураПараметровКлиента);
	#КонецОбласти
	///////////////////
			
КонецПроцедуры

Функция ПолученШтрихкодИзСШК(Форма, Штрихкод) Экспорт
	
	//ПЕРЕОПРЕДЕЛЕНИЕ//
	//ЕРП, КА, УТ
	Возврат Неопределено;
	
	//Розница
	#Область Розница
	//СтруктураРезультат = РозничноеВыбытиеИСМПТКПереопределяемый.ДанныеПоискаПоШтрихкодуСервер(Штрихкод);
	//Возврат ПолученШтрихкодИзСШКПродолжение(Форма, СтруктураРезультат);
	#КонецОбласти
	///////////////////
	
КонецФункции

Функция ПолученШтрихкодИзСШКПродолжение(Форма, СтруктураРезультат) Экспорт
	
	//ПЕРЕОПРЕДЕЛЕНИЕ//
	//ЕРП, КА, УТ
	Возврат Неопределено;
	
	//Розница
	#Область Розница
	//НайденоОбъектов = СтруктураРезультат.ЗначенияПоиска.Количество();
	//Если НайденоОбъектов = 1 Тогда
	//	ОписаниеОповещения = Новый ОписаниеОповещения("ОповещениеОбработатьДанныеПоПолученнымШК", Форма);
	//	ВыполнитьОбработкуОповещения(ОписаниеОповещения, СтруктураРезультат);
	//ИначеЕсли НайденоОбъектов > 1 Тогда
	//	ПодключаемоеОборудованиеРТВызовСервера.ПодготовитьДанныеДляВыбора(СтруктураРезультат);
	//КонецЕсли;
	//
	//Возврат СтруктураРезультат;
	#КонецОбласти
	///////////////////
	
КонецФункции

Процедура ОбработатьДанныеПодбораТовара(Форма, СтруктураПараметровКлиента) Экспорт
	
	//ПЕРЕОПРЕДЕЛЕНИЕ//
	//ЕРП, КА, УТ
	Возврат;
	
	//Розница
	#Область Розница
	//Если СтруктураПараметровКлиента.Свойство("ВыборДанныхПоиска") Тогда
	//	
	//	ДополнительныеПараметры = Новый Структура;
	//	ДополнительныеПараметры.Вставить("СтруктураПараметровКлиента", СтруктураПараметровКлиента);
	//	ОбработчикОповещения = Новый ОписаниеОповещения("ОповещениеОткрытьФормуВыборДанныхПоискаПоКМ", Форма, ДополнительныеПараметры);
	//	ПараметрыФормы 		 = Новый Структура("АдресВХранилище", СтруктураПараметровКлиента.ВыборДанныхПоиска);
	//	Режим = РежимОткрытияОкнаФормы.БлокироватьОкноВладельца;
	//	
	//	ОткрытьФорму("Обработка.РозничноеВыбытиеМаркированнойПродукцииИСМПТК.Форма.ВыборДанныхПоискаПоКМ", ПараметрыФормы,,,,, ОбработчикОповещения, Режим); 
	//			
	//КонецЕсли;
	#КонецОбласти
	///////////////////
		
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область ЕРП

Процедура ПриИзмененииЭлемента(Форма, Элемент, ДополнительныеПараметры) Экспорт
	
	Возврат;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти