﻿////////////////////////////////////////////////////////////////////////////////
// ОбработкаТабличныхЧастейКлиентСервер:
//  
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

Функция ПодготовитьСтруктуруДляРасчетаСумм(Объект) Экспорт
	
	СтруктураВозможныхРеквизитов = Новый Структура;
	СтруктураВозможныхРеквизитов.Вставить("Дата");	
	СтруктураВозможныхРеквизитов.Вставить("ВалютаДокумента");
	СтруктураВозможныхРеквизитов.Вставить("КурсВзаиморасчетов");
	СтруктураВозможныхРеквизитов.Вставить("КратностьВзаиморасчетов");
	СтруктураВозможныхРеквизитов.Вставить("УчитыватьНДС");
	СтруктураВозможныхРеквизитов.Вставить("СуммаВключаетНДС");
	СтруктураВозможныхРеквизитов.Вставить("СуммаВключаетАкциз");
	СтруктураВозможныхРеквизитов.Вставить("УчитыватьАкциз");
	СтруктураВозможныхРеквизитов.Вставить("НДСВключенВСтоимость");
	
	СтруктураРеквизитовДокумента = Новый Структура();
	
	Для Каждого ТекущийЭлементСтруктуры Из СтруктураВозможныхРеквизитов Цикл
		НужныйРеквизитДокумента = ТекущийЭлементСтруктуры.Ключ;
		Если Объект.Свойство(НужныйРеквизитДокумента) Тогда
			СтруктураРеквизитовДокумента.Вставить(НужныйРеквизитДокумента, Объект[НужныйРеквизитДокумента]);
		КонецЕсли;
	КонецЦикла;

	Возврат СтруктураРеквизитовДокумента;
	
КонецФункции

Процедура РассчитатьСуммуТабЧасти(СтрокаТабличнойЧасти, ЗначениеПустогоКоличества = 0) Экспорт
	
	Если СтрокаТабличнойЧасти <> Неопределено Тогда
		СтрокаТабличнойЧасти.Сумма = СтрокаТабличнойЧасти.Цена * ?(СтрокаТабличнойЧасти.Количество = 0, ЗначениеПустогоКоличества, СтрокаТабличнойЧасти.Количество);
	КонецЕсли;
	
КонецПроцедуры

Процедура РассчитатьСуммуАкцизаТабЧасти(СтрокаТабличнойЧасти, ПараметрыОбъекта) Экспорт

	Валюта 	  = ?(ПараметрыОбъекта.Свойство("ВалютаДокумента"), ПараметрыОбъекта.ВалютаДокумента, ОбщегоНазначенияБКВызовСервераПовтИсп.ПолучитьВалютуРегламентированногоУчета());
	Курс   	  = ?(ПараметрыОбъекта.Свойство("КурсВзаиморасчетов"), ПараметрыОбъекта.КурсВзаиморасчетов, 1);
	Кратность = ?(ПараметрыОбъекта.Свойство("КратностьВзаиморасчетов"), ПараметрыОбъекта.КратностьВзаиморасчетов, 1);
	
	Если СтрокаТабличнойЧасти.Свойство("СуммаАкциза") 
		И СтрокаТабличнойЧасти.Свойство("СтавкаАкциза")
		И СтрокаТабличнойЧасти.Свойство("Количество")
		И СтрокаТабличнойЧасти.Свойство("Номенклатура") Тогда
			
		Коэффициент = 1;
		Если ТипЗнч(СтрокаТабличнойЧасти.Номенклатура) = Тип("СправочникСсылка.Номенклатура") Тогда
		#Если Сервер ИЛИ ВнешнееСоединение Тогда
			Коэффициент = СтрокаТабличнойЧасти.Номенклатура.КоэффициентРасчетаОблагаемойБазыАкциза;
		#Иначе
			// Нужно на клиенте получить значение реквизита КоэффициентРасчетаОблагаемойБазыАкциза из одноименного реквизита формы табличной части
			Коэффициент = СтрокаТабличнойЧасти.КоэффициентАкциза;
		#КонецЕсли
		КонецЕсли;	
		
		Если ПараметрыОбъекта.УчитыватьАкциз Тогда
			СтрокаТабличнойЧасти.СуммаАкциза = УчетНДСиАкцизаКлиентСервер.РассчитатьСуммуАкциза(СтрокаТабличнойЧасти.Количество, Коэффициент, УчетНДСиАкцизаВызовСервераПовтИсп.ПолучитьСтавкуАкциза(СтрокаТабличнойЧасти.СтавкаАкциза), Валюта, Курс, Кратность);
		Иначе
			СтрокаТабличнойЧасти.СуммаАкциза = 0;
			СтрокаТабличнойЧасти.СтавкаАкциза = ПредопределенноеЗначение("Справочник.СтавкиАкциза.ПустаяСсылка");
		КонецЕсли;
		
	КонецЕсли;

КонецПроцедуры // РассчитатьСуммуАкцизаТабЧасти()
			   
Процедура РассчитатьСуммуНДСТабЧасти(СтрокаТабличнойЧасти, ПараметрыОбъекта, ИмяРеквизитаСуммаНДС = "СуммаНДС", РассчитыватьСуммуЗачета = Ложь) Экспорт

	// Если в документе нет флагов учета НДС, то используем значения по умолчанию
	УчитыватьНДС = Истина;
	СуммаВключаетНДС = Ложь;
	ЕстьОборотПоРеализации = СтрокаТабличнойЧасти.Свойство("ОборотПоРеализации");
	ЕстьВалюта = ПараметрыОбъекта.Свойство("ВалютаДокумента");
	
	ВалютаРеглУчета = ОбщегоНазначенияБКВызовСервераПовтИсп.ПолучитьВалютуРегламентированногоУчета();
	
	// если процедура вызвана из ОбработкаЗаполненияТабличныхЧастейТовары, то проверим наличие параметра "ЗначениеОборотПоРеализации"
	Если ПараметрыОбъекта.Свойство("ЗначениеОборотПоРеализации") Тогда
		ЕстьОборотПоРеализации = ПараметрыОбъекта.ЗначениеОборотПоРеализации;
	Иначе
		Если ЕстьВалюта И ВалютаРеглУчета <> ПараметрыОбъекта.ВалютаДокумента И ПараметрыОбъекта.Дата < Дата(2014, 07, 01) Тогда
			// В валютных счетах-фактурах до 01.07.2014 расчет НДС выполняется от суммы, так как оборот по реализации указывается в тенге.
			// В валютных счетах-фактурах начиная с 01.07.2014 расчет НДС выполняется от оборота по реализации, так как оборот по реализации указывается в валюте.			
			ЕстьОборотПоРеализации = Ложь;
		КонецЕсли;	
	КонецЕсли;
	
	
	Если ПараметрыОбъекта.Свойство("УчитыватьНДС") Тогда
		УчитыватьНДС = ПараметрыОбъекта.УчитыватьНДС;
	КонецЕсли;

	Если ПараметрыОбъекта.Свойство("СуммаВключаетНДС") Тогда
		СуммаВключаетНДС = ПараметрыОбъекта.СуммаВключаетНДС;
	КонецЕсли;
	

	Если СтрокаТабличнойЧасти.Свойство("СтавкаНДС") Тогда
		Если ЕстьОборотПоРеализации Тогда 
			СтрокаТабличнойЧасти[ИмяРеквизитаСуммаНДС] = УчетНДСиАкцизаКлиентСервер.РассчитатьСуммуНДС(СтрокаТабличнойЧасти.ОборотПоРеализации,
														   УчитыватьНДС, 
														   Ложь,
														   УчетНДСиАкцизаВызовСервераПовтИсп.ПолучитьСтавкуНДС(СтрокаТабличнойЧасти.СтавкаНДС),
														   ?(СтрокаТабличнойЧасти.Свойство("СуммаАкциза"), СтрокаТабличнойЧасти.СуммаАкциза, 0),
														   Истина);	
														   
		ИначеЕсли СтрокаТабличнойЧасти.Свойство("Сумма") Тогда
		
			СтрокаТабличнойЧасти[ИмяРеквизитаСуммаНДС] = УчетНДСиАкцизаКлиентСервер.РассчитатьСуммуНДС(СтрокаТабличнойЧасти.Сумма,
														   УчитыватьНДС, 
														   СуммаВключаетНДС,
														   УчетНДСиАкцизаВызовСервераПовтИсп.ПолучитьСтавкуНДС(СтрокаТабличнойЧасти.СтавкаНДС),
														   ?(СтрокаТабличнойЧасти.Свойство("СуммаАкциза"), СтрокаТабличнойЧасти.СуммаАкциза, 0),
														   ?(ПараметрыОбъекта.Свойство("СуммаВключаетАкциз"), ПараметрыОбъекта.СуммаВключаетАкциз, Ложь));
														   
		КонецЕсли;													   
	КонецЕсли;

	// если в документе есть реквизиты УплаченныйНДС и СуммаНДС, то сумма НДС к зачету определяется
	// исходя из признака включения НДС в стоимость
	Если РассчитыватьСуммуЗачета Тогда
		
		НДСВключенВСтоимость = ?(ПараметрыОбъекта.Свойство("НДСВключенВСтоимость"), ПараметрыОбъекта.НДСВключенВСтоимость, Ложь);	
		
		Если НДСВключенВСтоимость Тогда
			СтрокаТабличнойЧасти.СуммаНДС = 0;
		Иначе
			СтрокаТабличнойЧасти.СуммаНДС = СтрокаТабличнойЧасти[ИмяРеквизитаСуммаНДС];
		КонецЕсли
		
	КонецЕсли;   	

КонецПроцедуры // РассчитатьСуммуНДСТабЧасти()

Процедура РассчитатьСуммуВсегоТабЧасти(Строка, СуммаВключаетНДС, СуммаВключаетАкциз = Ложь) Экспорт
	
	Если Строка.Свойство("Всего") Тогда
		Строка.Всего = Строка.Сумма + ?(СуммаВключаетНДС, 0, Строка.СуммаНДС) + ?(Строка.Свойство("СуммаАкциза"), ?(СуммаВключаетАкциз, 0, Строка.СуммаАкциза), 0);
	КонецЕсли;	
	
КонецПроцедуры

Процедура ПриИзмененииСуммыТабЧасти(СтрокаТабличнойЧасти) Экспорт

	Если НЕ ЗначениеЗаполнено(СтрокаТабличнойЧасти.Количество) Тогда
		СтрокаТабличнойЧасти.Цена = 0;
	Иначе
		СтрокаТабличнойЧасти.Цена = СтрокаТабличнойЧасти.Сумма / СтрокаТабличнойЧасти.Количество;
	КонецЕсли; 

КонецПроцедуры 

Функция НайтиСтрокуТабЧасти(Объект, ТабличнаяЧасть, СтруктураОтбора) Экспорт

	СтрокаТабличнойЧасти = Неопределено;
	МассивНайденныхСтрок = Объект[ТабличнаяЧасть].НайтиСтроки(СтруктураОтбора);
	Если МассивНайденныхСтрок.Количество() > 0 Тогда

		// Нашли. Вернем первую найденную строку.
		СтрокаТабличнойЧасти = МассивНайденныхСтрок[0];
	КонецЕсли;

	Возврат СтрокаТабличнойЧасти;

КонецФункции

// Производит пересчет цен при изменении флагов учета налогов.
// Пересчет зависит от способа заполнения цен, при заполнении По ценам номенклатуры (при продаже) 
// хочется избегать ситуаций, когда компания «теряет деньги» при пересчете налогов. 
// Поэтому если в документе флаг "Учитывать налог" выключен, то цены должны браться напрямую из справочника, 
// потому что хочется продавать по той же цене, независимо от режима налогообложения. 
// Например, если отпускная цена задана с НДС для избежания ошибок округления, то это не значит, 
// что при отпуске без НДС мы должны продать дешевле. Если же флаг учета налога в документе включен, 
// то цены должны пересчитываться при подстановке в документ: 
// налог должен включаться или не включаться в зависимости от флага включения налога в типе цен.
// При заполнении по ценам контрагентов (при покупке) хочется хранить цены поставщиков. 
// Поэтому нужно пересчитывать всегда по установленным флагам в документе и в типе цен. 
// Это гарантирует, что при записи цен в регистр и последующем их чтении, 
// например, при заполнении следующего документа, мы с точностью до ошибок округления при пересчете 
// получим те же самые цены.
//
// Все расчеты с акцизом провоим из того предположения, что если Цена включает НДС, то она включает и Акциз
//
// Параметры: 
//  Цена                - число, пересчитваемое значение цены, 
//  СпособЗаполненияЦен - ссылка на перечисление СпособыЗаполненияЦен, определяет способ расчета,
//						  "при продаже" или "при покупке", см описание функции,
//  ЦенаВключаетНДС     - булево, определяет содержит ли переданное значение цены НДС,
//  УчитыватьНДС        - булево, определяет должно ли новое значение цены учитвать НДС,
//  СуммаВключаетНДС    - булево, определяет должно ли новое значение цены включать НДС,
//  СтавкаНДС           - число, ставка НДС, 
//
//  ЦенаВключаетАкциз   - булево, определяет содержит ли переданное значение цены Акциз,
//  УчитыватьАкциз      - булево, определяет должно ли новое значение цены учитвать Акциз,
//  СуммаВключаетАкциз  - булево, определяет должно ли новое значение цены включать Акциз,
//  СуммаАкциза         - число, сумма акциза на единицу, 
//
// Возвращаемое значение:
//  Числое, новое значение цены.
//
Функция ПересчитатьЦенуПриИзмененииФлаговНалогов(Цена, СпособЗаполненияЦен, ЦенаВключаетНДС,
													УчитыватьНДС, СуммаВключаетНДС, СтавкаНДС, 
													ЦенаВключаетАкциз  = Ложь, УчитыватьАкциз = Ложь, 
													СуммаВключаетАкциз = Ложь, СуммаАкциза = 0) Экспорт

	// Инициализация переменных
	НадоВключитьНДС  = Ложь;
	НадоИсключитьНДС = Ложь;
	
	НадоВключитьАкциз  = Ложь;
	НадоИсключитьАкциз = Ложь;
	
	НоваяЦена		 = Цена;
	
	Если УчитыватьНДС Тогда
		Если СуммаВключаетНДС И (НЕ ЦенаВключаетНДС) Тогда
			// Надо добавлять НДС       
			НадоВключитьНДС = Истина;
		ИначеЕсли НЕ СуммаВключаетНДС И ЦенаВключаетНДС Тогда
			// Надо исключать НДС       
			НадоИсключитьНДС = Истина;
		КонецЕсли;
	Иначе 
		Если ЦенаВключаетНДС  Тогда
			// Надо исключать НДС       
			НадоИсключитьНДС = Истина;
		КонецЕсли;	
	КонецЕсли;
		
	Если УчитыватьАкциз Тогда
		Если СуммаВключаетАкциз И (НЕ ЦенаВключаетАкциз) Тогда
			// Надо добавлять НДС       
			НадоВключитьАкциз = Истина;
		ИначеЕсли НЕ СуммаВключаетАкциз И ЦенаВключаетАкциз Тогда
			// Надо исключать НДС       
			НадоИсключитьАкциз = Истина;
		КонецЕсли;
		// при условии что у нас вдется учет Акциза и Сумма будет включать НДС, принудительного акциз включаем в цену, 
		//т.к. он входит в базу для расчета НДС
		Если НадоВключитьНДС И НЕ СуммаВключаетАкциз Тогда
			НадоВключитьАкциз = Истина;
			// при этом если Акциз ране у нас был - отнимем его, чтобы не включить дважды
			Если ЦенаВключаетАкциз  Тогда
				НадоИсключитьАкциз = Истина;
			КонецЕсли;	
		КонецЕсли;
	Иначе
		Если ЦенаВключаетАкциз  Тогда
			// Надо исключать НДС       
			НадоИсключитьАкциз = Истина;
		КонецЕсли;	
	КонецЕсли;
	
	//НДС накручивается сверху, поэтому при любом раскладе первым исключаем его
	Если НадоИсключитьНДС Тогда
		НоваяЦена = (НоваяЦена * 100) / (100 + СтавкаНДС);
	КонецЕсли;
	
	// Исключаем акциз
	Если НадоИсключитьАкциз Тогда
		НоваяЦена =  НоваяЦена - СуммаАкциза;
	КонецЕсли;	
	
	//включаем его при необходимости 
	Если НадоВключитьАкциз Тогда
		НоваяЦена = НоваяЦена + СуммаАкциза;
	КонецЕсли;	
	
	Если НадоВключитьНДС Тогда
		НоваяЦена = (НоваяЦена * (100 + СтавкаНДС)) / 100;
	КонецЕсли;

	Возврат НоваяЦена;

КонецФункции // ПересчитатьЦенуПриИзмененииФлаговНалогов()

Процедура ПриИзмененииЕдиницыТабЧасти(СтрокаТабличнойЧасти) Экспорт

	// Установить коэффициент
	СтрокаТабличнойЧасти.Коэффициент = 1; 

КонецПроцедуры // ПриИзмененииЕдиницыТабЧасти

// Процедура выполняет стандартные действия по расчету плановой суммы
// в строке табличной части документа.
//
// Параметры:
//  СтрокаТабличнойЧасти - строка табличной части документа,
//
Процедура ПересчитатьПлановуюСумму(СтрокаТабличнойЧасти, ЗначениеПустогоКоличества = 0) Экспорт

	СтрокаТабличнойЧасти.СуммаПлановая = 
		?(СтрокаТабличнойЧасти.Количество = 0, ЗначениеПустогоКоличества, СтрокаТабличнойЧасти.Количество)
		* СтрокаТабличнойЧасти.ПлановаяСтоимость;

КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ
