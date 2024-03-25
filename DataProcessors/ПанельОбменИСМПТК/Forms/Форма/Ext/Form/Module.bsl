﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ВосстановитьНастройкиФормы();
	
	ПроверитьОбновитьСписокАППДляОформленияУОР();
	ПроверитьОбновитьСписокТоваровНацКаталогаДляУточненияДанных();
	ПроверитьОбновитьСписокЗаказовДляОформленияНанесения();
	
	УправлениеФормой();
	СобытияФормИСМПТКПереопределяемый.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаНавигационнойСсылки(НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	АдресаСерверовИСМПТ = ИнтеграцияИСМПТКВызовСервера.ПолучитьАдресаСерверовИСМПТ();
	АдресИСМПТ = ИнтеграцияИСМПТКВызовСервера.ПроверитьНаличиеПротоколаВАдресе(АдресаСерверовИСМПТ.АдресИСМПТ);
	АдресСУЗ   = ИнтеграцияИСМПТКВызовСервера.ПроверитьНаличиеПротоколаВАдресе(АдресаСерверовИСМПТ.АдресСУЗ);
	
	Если НавигационнаяСсылкаФорматированнойСтроки = "ПерейтиВЛичныйКабинетСУЗ" Тогда
		СтандартнаяОбработка = Ложь;   
		РазборИОбработкаКодовМаркировкиИСМПТКСлужебныйКлиент.ОткрытьНавигационнуюСсылку(АдресСУЗ);
	ИначеЕсли НавигационнаяСсылкаФорматированнойСтроки = "ПерейтиВЛичныйКабинетИСМПТ" Тогда
		СтандартнаяОбработка = Ложь;
		РазборИОбработкаКодовМаркировкиИСМПТКСлужебныйКлиент.ОткрытьНавигационнуюСсылку(АдресИСМПТ);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "КонстантыМаркировки_Изменение" Тогда
		УправлениеФормой();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

#Область ДокументыИСМП

#Область Производство

#Область ЗаказНаЭмиссиюКодовМаркировкиСУЗ

&НаКлиенте
Процедура ОткрытьЗаказНаЭмиссиюКодовМаркировкиСУЗ(Команда)
	
	ПараметрыФормыВыбора = Новый Структура();
	
	Если ЗначениеЗаполнено(Организация) Тогда
		
		Отбор = Новый Структура();
		Отбор.Вставить("Организация", Организация);
	 	ПараметрыФормыВыбора.Вставить("Отбор", Отбор);
		
	КонецЕсли;
	
	ПараметрыФормыВыбора.Вставить("Заголовок", "Заказы на эмиссию кодов маркировки");
	ОткрытьФорму("Документ.ЗаказКодовМаркировкиСУЗИСМПТК.Форма.ФормаСписка", ПараметрыФормыВыбора);
	
КонецПроцедуры

#КонецОбласти

#Область НанесениеКодовМаркировкиСУЗ

&НаКлиенте
Процедура ОткрытьНанесениеКодовМаркировкиСУЗ(Команда)
	
	ПараметрыФормыВыбора = Новый Структура();
	
	Если ЗначениеЗаполнено(Организация) Тогда
		
		Отбор = Новый Структура();
		Отбор.Вставить("Организация", Организация);
	 	ПараметрыФормыВыбора.Вставить("Отбор", Отбор);
		
	КонецЕсли;
	
	ПараметрыФормыВыбора.Вставить("Заголовок", "Нанесение кодов маркировки");
	ОткрытьФорму("Документ.НанесениеКодовМаркировкиСУЗИСМПТК.Форма.ФормаСписка", ПараметрыФормыВыбора);
	
КонецПроцедуры

#КонецОбласти

#Область АгрегацияКодовМаркировкиСУЗ

&НаКлиенте
Процедура ОткрытьАгрегацияКодовМаркировкиСУЗ(Команда)
	
	ПараметрыФормыВыбора = Новый Структура();
	
	Если ЗначениеЗаполнено(Организация) Тогда
		
		Отбор = Новый Структура();
		Отбор.Вставить("Организация", Организация);
	 	ПараметрыФормыВыбора.Вставить("Отбор", Отбор);
		
	КонецЕсли;
	
	ПараметрыФормыВыбора.Вставить("Заголовок", "Агрегация кодов маркировки");
	ОткрытьФорму("Документ.АгрегацияКодовМаркировкиСУЗИСМПТК.Форма.ФормаСписка", ПараметрыФормыВыбора);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область Запасы

#Область АктПриемаПередачиИСМПТ

&НаКлиенте
Процедура ОткрытьАктПриемаПередачиКодовМаркировкиИСМПВходящие(Команда)
	
	ПараметрыФормыВыбора = Новый Структура();
	
	Если ЗначениеЗаполнено(Организация) Тогда
		
		Отбор = Новый Структура();
		Отбор.Вставить("Организация", Организация);
	 	ПараметрыФормыВыбора.Вставить("Отбор", Отбор);
		
	КонецЕсли;
			
	ОткрытьФорму("Документ.АктПриемаПередачиИСМПТК.Форма.ФормаСпискаВходящих", ПараметрыФормыВыбора);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьАктПриемаПередачиКодовМаркировкиИСМПИсходящие(Команда)
	
	ПараметрыФормыВыбора = Новый Структура();
	
	Если ЗначениеЗаполнено(Организация) Тогда
		
		Отбор = Новый Структура();
		Отбор.Вставить("Организация", Организация);
	 	ПараметрыФормыВыбора.Вставить("Отбор", Отбор);
		
	КонецЕсли;
			
	ОткрытьФорму("Документ.АктПриемаПередачиИСМПТК.Форма.ФормаСпискаИсходящих", ПараметрыФормыВыбора);
		
КонецПроцедуры

#КонецОбласти

#Область УведомлениеОВыводеИзОборотаИСМПТ

&НаКлиенте
Процедура ОткрытьУведомлениеОВыводеИзОборотаИСМПТ(Команда)
	
	ПараметрыФормыВыбора = Новый Структура();
	
	Если ЗначениеЗаполнено(Организация) Тогда
		
		Отбор = Новый Структура();
		Отбор.Вставить("Организация", Организация);
	 	ПараметрыФормыВыбора.Вставить("Отбор", Отбор);
		
	КонецЕсли;
			
	ОткрытьФорму("Документ.УведомлениеОВыводеИзОборотаИСМПТК.Форма.ФормаСпискаИсходящих", ПараметрыФормыВыбора);
	                                       
КонецПроцедуры                             

#КонецОбласти

#Область УведомлениеОРасхожденииИСМПТ

&НаКлиенте
Процедура ОткрытьУведомлениеОРасхожденииИСМПТИсх(Команда)
	
	ПараметрыФормыВыбора = Новый Структура();
	
	Если ЗначениеЗаполнено(Организация) Тогда
		
		Отбор = Новый Структура();
		Отбор.Вставить("Организация", Организация);
	 	ПараметрыФормыВыбора.Вставить("Отбор", Отбор);
		
	КонецЕсли;
			
	ОткрытьФорму("Документ.УведомлениеОРасхожденииИСМПТК.Форма.ФормаСпискаИсходящих", ПараметрыФормыВыбора);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьУведомлениеОРасхожденииИСМПТВход(Команда)
	
	ПараметрыФормыВыбора = Новый Структура();
	
	Если ЗначениеЗаполнено(Организация) Тогда
		
		Отбор = Новый Структура();
		Отбор.Вставить("Организация", Организация);
	 	ПараметрыФормыВыбора.Вставить("Отбор", Отбор);
		
	КонецЕсли;
			
	ОткрытьФорму("Документ.УведомлениеОРасхожденииИСМПТК.Форма.ФормаСпискаВходящих", ПараметрыФормыВыбора);
	
КонецПроцедуры

#КонецОбласти

#Область УведомлениеОВводеВОборотИСМПТ

&НаКлиенте
Процедура ОткрытьУведомлениеОВводеВОборотИСМПТ(Команда)
	
	ПараметрыФормыВыбора = Новый Структура();
	
	Если ЗначениеЗаполнено(Организация) Тогда
		
		Отбор = Новый Структура();
		Отбор.Вставить("Организация", Организация);
	 	ПараметрыФормыВыбора.Вставить("Отбор", Отбор);
		
	КонецЕсли;
			
	ОткрытьФорму("Документ.УведомлениеОВводеВОборотИСМПТК.Форма.ФормаСпискаИсходящих", ПараметрыФормыВыбора);
	                                       
КонецПроцедуры                             

#КонецОбласти

#Область УведомлениеОВвозеИСМПТ

#Область ИзЕАЭС

&НаКлиенте
Процедура ОткрытьУведомлениеОВвозеИзЕАЭС(Команда)
	
	ПараметрыФормыВыбора = Новый Структура();
	
	Отбор = Новый Структура();
	Если ЗначениеЗаполнено(Организация) Тогда
		Отбор.Вставить("Организация", Организация);
	КонецЕсли;
	
	ПараметрыФормыВыбора.Вставить("Отбор", Отбор);
	ПараметрыФормыВыбора.Вставить("Заголовок", "Уведомления о ввозе товаров (ЕАЭС)");
	
	ОткрытьФорму("Документ.УведомлениеОВвозеИзЕАЭСИСМПТК.Форма.ФормаСпискаИсходящих", ПараметрыФормыВыбора);
	
КонецПроцедуры

#КонецОбласти

#Область ИзТретьихСтран

&НаКлиенте
Процедура ОткрытьУведомлениеОВвозеНеЕАЭС(Команда)
	
	ПараметрыФормыВыбора = Новый Структура();
	
	Отбор = Новый Структура();
	Если ЗначениеЗаполнено(Организация) Тогда
		Отбор.Вставить("Организация", Организация);
	КонецЕсли;
	
	ПараметрыФормыВыбора.Вставить("Отбор", Отбор);
	ПараметрыФормыВыбора.Вставить("Заголовок", "Уведомления о ввозе товаров (Импорт)");
			
	ОткрытьФорму("Документ.УведомлениеОВвозеИзТретьихСтранИСМПТК.Форма.ФормаСпискаИсходящих", ПараметрыФормыВыбора);
	
КонецПроцедуры

#КонецОбласти

#Область ЭкспортЕАЭС

&НаКлиенте
Процедура ОткрытьУведомлениеОбЭкспортеЕАЭС(Команда)
	
	ПараметрыФормыВыбора = Новый Структура();
	
	Отбор = Новый Структура();
	Если ЗначениеЗаполнено(Организация) Тогда
		Отбор.Вставить("Организация", Организация);
	КонецЕсли;
	
	ПараметрыФормыВыбора.Вставить("Отбор", Отбор);
			
	ОткрытьФорму("Документ.УведомлениеОбЭкспортеЕАЭСИСМПТК.ФормаСписка", ПараметрыФормыВыбора);
	
КонецПроцедуры

#КонецОбласти

#Область ПриемкаЕАЭС

&НаКлиенте
Процедура ОткрытьУведомлениеОПриемкеЕАЭС(Команда)
	
	ПараметрыФормыВыбора = Новый Структура();
	
	Отбор = Новый Структура();
	Если ЗначениеЗаполнено(Организация) Тогда
		Отбор.Вставить("Организация", Организация);
	КонецЕсли;
	
	ПараметрыФормыВыбора.Вставить("Отбор", Отбор);
			
	ОткрытьФорму("Документ.УведомлениеОПриемкеЕАЭСИСМПТК.ФормаСписка", ПараметрыФормыВыбора);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьУведомлениеОбОтгрузкеЕАЭС(Команда)
	
	ПараметрыФормыВыбора = Новый Структура();
	
	Отбор = Новый Структура();
	Если ЗначениеЗаполнено(Организация) Тогда
		Отбор.Вставить("Организация", Организация);
	КонецЕсли;
	
	ПараметрыФормыВыбора.Вставить("Отбор", Отбор);
			
	ОткрытьФорму("Документ.УведомлениеОбОтгрузкеЕАЭСИСМПТК.ФормаСписка", ПараметрыФормыВыбора);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецОбласти

#КонецОбласти

#Область ОбъектыИСМП

&НаКлиенте
Процедура ОткрытьСтанцииУправленияЗаказамиИСМП(Команда)
	
	ОткрытьФорму("Справочник.СтанцииУправленияЗаказамиИСМПТК.ФормаСписка");
	
КонецПроцедуры

&НаКлиенте
Процедура ПулКодовМаркировкиСУЗ(Команда)
	
	ОткрытьФорму("РегистрСведений.ПулКодовМаркировкиСУЗИСМПТК.Форма.ФормаСписка");
	
КонецПроцедуры

&НаКлиенте
Процедура ЗависшиеЗаказыКМ(Команда)
	
	ПараметрыФормыВыбора = Новый Структура();
	Отбор = Новый Структура();
	
	Если ЗначениеЗаполнено(Организация) Тогда
		Отбор.Вставить("Организация", Организация);
	КонецЕсли;
	
	СписокЗависшихЗаказовСУЗ = ИнтеграцияИСМПТКВызовСервера.ПолучитьСписокЗависшихЗаказовСУЗ(Организация);
	Отбор.Вставить("Ссылка", СписокЗависшихЗаказовСУЗ);
	
	ПараметрыФормыВыбора.Вставить("Отбор", Отбор);
	ПараметрыФормыВыбора.Вставить("Заголовок", "Незавершенные Заказы на эмиссию кодов маркировки");
	ПараметрыФормыВыбора.Вставить("ЭтоСписокИсправления", Истина);
	
	ОткрытьФорму("Документ.ЗаказКодовМаркировкиСУЗИСМПТК.ФормаСписка", ПараметрыФормыВыбора);
		
КонецПроцедуры

&НаКлиенте
Процедура КодыГрупповыхУпаковокSSCC(Команда)
	
	ПараметрыФормыВыбора = Новый Структура();
	Отбор = Новый Структура();
	Если ЗначениеЗаполнено(Организация) Тогда
		Отбор.Вставить("Организация", Организация);
		ПараметрыФормыВыбора.Вставить("Отбор", Отбор);
	КонецЕсли;
	
	ОткрытьФорму("РегистрСведений.ШтрихкодыSSCCИСМПТК.ФормаСписка", ПараметрыФормыВыбора);
		
КонецПроцедуры

&НаКлиенте
Процедура ТоварыНацКаталога(Команда)
	
	ПараметрыФормыВыбора = Новый Структура();
	Отбор = Новый Структура();
	Если ЗначениеЗаполнено(Организация) Тогда
		Отбор.Вставить("Организация", Организация);
		ПараметрыФормыВыбора.Вставить("Отбор", Отбор);
	КонецЕсли;
	ПараметрыФормыВыбора.Вставить("Заголовок", "Товары Национального каталога");
	ПараметрыФормыВыбора.Вставить("ЭтоВыборКарточки", Ложь);
	
	ОткрытьФорму("РегистрСведений.ТоварыНацКаталогаИСМПТК.ФормаСписка", ПараметрыФормыВыбора);
	
КонецПроцедуры

#КонецОбласти

#Область ПрикладныеОбъекты

&НаКлиенте
Процедура ОткрытьВидыНоменклатуры(Команда)
	
	ИнтеграцияИСМПТККлиентПереопределяемый.ОткрытьФормуСпискаВидыНоменклатуры(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьНоменклатуру(Команда)

	ИнтеграцияИСМПТККлиентПереопределяемый.ОткрытьФормуСпискаНоменклатуры(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

&НаКлиенте
Процедура Обновить(Команда)
	
	ОбновитьСпискиДокументов();
	ПроверитьОбновитьСписокАППДляОформленияУОР();
	ПроверитьОбновитьСписокТоваровНацКаталогаДляУточненияДанных();
	ПроверитьОбновитьСписокЗаказовДляОформленияНанесения();
	
КонецПроцедуры

#Область СправочникиИСМП

&НаКлиенте
Процедура ОткрытьШаблоныЭтикеток(Команда)
	
	ОткрытьФорму("Справочник.ХранилищеШаблоновИСМПТК.ФормаСписка");
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

#Область ОтборПоОрганизации

&НаКлиенте
Процедура ОтборОрганизацииПриИзменении(Элемент)
	
	ИнтеграцияИСМПТККлиент.ОбработатьВыборОрганизаций(ЭтотОбъект, Организации, Ложь, "Отбор");
	ОбновитьСпискиДокументов();
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборОрганизацииНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ИнтеграцияИСМПТККлиент.ОткрытьФормуВыбораОрганизаций(ЭтотОбъект, "Отбор", , ОповещениеВыбораОрганизаций());
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборОрганизацииОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ИнтеграцияИСМПТККлиент.ОбработатьВыборОрганизаций(ЭтотОбъект, Неопределено, Ложь, "Отбор");
	ОбновитьСпискиДокументов();
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборОрганизацииОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ИнтеграцияИСМПТККлиент.ОбработатьВыборОрганизаций(ЭтотОбъект, ВыбранноеЗначение, Ложь, "Отбор");
	ОбновитьСпискиДокументов();
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборОрганизацияПриИзменении(Элемент)
	
	ИнтеграцияИСМПТККлиент.ОбработатьВыборОрганизаций(ЭтотОбъект, Организация, Ложь, "Отбор");
	ОбновитьСпискиДокументов();
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборОрганизацияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ИнтеграцияИСМПТККлиент.ОткрытьФормуВыбораОрганизаций(ЭтотОбъект, "Отбор", , ОповещениеВыбораОрганизаций());
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборОрганизацияОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ИнтеграцияИСМПТККлиент.ОбработатьВыборОрганизаций(ЭтотОбъект, Неопределено, Ложь, "Отбор");
	ОбновитьСпискиДокументов();
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборОрганизацияОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ИнтеграцияИСМПТККлиент.ОбработатьВыборОрганизаций(ЭтотОбъект, ВыбранноеЗначение, Ложь, "Отбор");
	ОбновитьСпискиДокументов();
	
КонецПроцедуры

#КонецОбласти

&НаКлиенте
Процедура ОтветственныйПриИзменении(Элемент)
	
	ОбновитьСпискиДокументов();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ДействияСНастройкамиФормы

&НаСервере
Процедура СохранитьНастройкиФормы()
	
	ОбщегоНазначения.ХранилищеОбщихНастроекСохранить("ПанельОбменИСМПТК", "Организация",              Организация);
	ОбщегоНазначения.ХранилищеОбщихНастроекСохранить("ПанельОбменИСМПТК", "ОрганизацииПредставление", ОрганизацииПредставление);
	ОбщегоНазначения.ХранилищеОбщихНастроекСохранить("ПанельОбменИСМПТК", "Организации",              Организации);
	
КонецПроцедуры

&НаСервере
Процедура ВосстановитьНастройкиФормы()
	
	Организации              = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить("ПанельОбменИСМПТК", "Организации");
	//Ответственный            = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить("ПанельОбменИСМПТК", "Ответственный", Ответственный);
	Организация              = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить("ПанельОбменИСМПТК", "Организация", Организация);
	ОрганизацииПредставление = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить("ПанельОбменИСМПТК", "ОрганизацииПредставление", ОрганизацииПредставление);
	
КонецПроцедуры

#КонецОбласти

#Область ОбновлениеЭлементовФормы

&НаСервере
Процедура ОбновитьСпискиДокументов()
	
	УправлениеФормой();
	СохранитьНастройкиФормы();
	
КонецПроцедуры

#КонецОбласти

#Область ОтборПоОрганизации

&НаКлиенте
Функция ОповещениеВыбораОрганизаций()
	
	Возврат Новый ОписаниеОповещения("ПослеВыбораОрганизации", ЭтотОбъект);
	
КонецФункции

&НаКлиенте
Процедура ПослеВыбораОрганизации(Результат, ДополнительныеПараметры) Экспорт
	
	ОбновитьСпискиДокументов();
	
КонецПроцедуры

#КонецОбласти

&НаСервере
Процедура УправлениеФормой()
	
	////////ОБЩИЕ СВЕДЕНИЯ////////
	//1. ПЕРЕХОД В ЛК (внешняя ссылка)
	ПерейтиВЛичныйКабинетСУЗ  = Новый ФорматированнаяСтрока(НСтр("ru = 'Личный кабинет (СУЗ)';
												 		 |en = 'Personal account'"),, 
												    ЦветаСтиля.ЦветГиперссылкиИСМПТК,, 
												    "ПерейтиВЛичныйКабинетСУЗ");
													
	ПерейтиВЛичныйКабинетИСМПТ = Новый ФорматированнаяСтрока(НСтр("ru = 'Личный кабинет (ИС МПТ)';
														  |en = 'Personal account'"),, 
													 ЦветаСтиля.ЦветГиперссылкиИСМПТК,, 
													 "ПерейтиВЛичныйКабинетИСМПТ");

	//2. КОНСТАНТЫ УЧЕТА
	ВедетсяУчетМарокПоОбуви 	 = ПолучитьФункциональнуюОпцию("ВестиУчетМаркируемойОбувиИСМПТК");
	ВедетсяУчетМарокПоТабаку 	 = ПолучитьФункциональнуюОпцию("ВестиУчетМаркируемогоТабакаИСМПТК");
	ВедетсяУчетМарокПоМолочке 	 = ПолучитьФункциональнуюОпцию("ВестиУчетМаркируемойМолочкиИСМПТК");
	ВедетсяУчетМарокПоАлкоголю 	 = ПолучитьФункциональнуюОпцию("ВестиУчетМаркируемогоАлкоголяИСМПТК");
	ВедетсяУчетМарокПоЛекарствам = ПолучитьФункциональнуюОпцию("ВестиУчетМаркируемыхЛекарствИСМПТК");
	ВедетсяУчетМарокПоТекстилю 	 = ПолучитьФункциональнуюОпцию("ВестиУчетМаркируемогоТекстиляИСМПТК");
	ВедетсяУчетМарокОбщая	 	 = ПолучитьФункциональнуюОпцию("ВестиУчетМаркируемойПродукцииИСМПТК");
	//////////////////////////////
	
	//===========================
	
	///////ПЕРЕОПРЕДЕЛЯЕМЫЕ///////
	//Получение параметров настроек модуля с учетом особенностей конфигурации.
	МассивПереопределяемыхНастроек = СобытияФормИСМПТКПереопределяемый.ПолучитьСписокПереопределяемыхНастроекФормыОсновноеРабочееМестоИСМПТ();
	Для Каждого СтруктураПараметров Из МассивПереопределяемыхНастроек Цикл
		
		ИмяЭлемента = СтруктураПараметров.ИмяЭлементаФормы;
		Свойство	= СтруктураПараметров.Свойство;
		ЗначениеСвойства = СтруктураПараметров.Значение;
		
		ИнтерфейсИСМПТККлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, ИмяЭлемента, Свойство, ЗначениеСвойства);
		
	КонецЦикла;
	//////////////////////////////
	
	//===========================
	
	//////МАРКИРОВКА ТОВАРОВ/////
	//1. ГРУППА ТОВАРОДВИЖЕНИЕ
	//Акты приема/передачи и Уведомления о расхождениях
	ВидимостьГруппаАППУОР = ПравоДоступа("Просмотр",   Метаданные.Документы.АктПриемаПередачиИСМПТК)
	                        И ПравоДоступа("Просмотр", Метаданные.Документы.УведомлениеОРасхожденииИСМПТК);												 
	ИнтерфейсИСМПТККлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ГруппаАктПриемаПередачиМаркировкиИСМП", 		 "Видимость", ВидимостьГруппаАППУОР);
	ИнтерфейсИСМПТККлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ГруппаУведомлениеОРасхожденииМаркировкиИСМП", "Видимость", ВидимостьГруппаАППУОР);
	
	//2. ГРУППА ВВОЗ ТОВАРОВ
	//Уведомления о ввозе товаров (ЕАЭС и Третьи страны)
	ВидимостьВвоз = ПравоДоступа("Просмотр", Метаданные.Документы.УведомлениеОВвозеИзЕАЭСИСМПТК)
					И ПравоДоступа("Просмотр", Метаданные.Документы.УведомлениеОВвозеИзТретьихСтранИСМПТК);
	ИнтерфейсИСМПТККлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ГруппаУведомлениеОВвозеМаркировкиИСМП", "Видимость", ВидимостьВвоз);
	
	//Уведомления об Экспорте, Отгрузке и Приемке (ЕАЭС)
	ВидимостьВывозСПризнанием = ПравоДоступа("Просмотр", Метаданные.Документы.УведомлениеОбЭкспортеЕАЭСИСМПТК);
	ИнтерфейсИСМПТККлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "Продажа", "Видимость", ВидимостьВывозСПризнанием);
	
	ВидимостьВвозСПризнанием = ПравоДоступа("Просмотр", Метаданные.Документы.УведомлениеОбОтгрузкеЕАЭСИСМПТК)
							   И ПравоДоступа("Просмотр", Метаданные.Документы.УведомлениеОПриемкеЕАЭСИСМПТК);
	ИнтерфейсИСМПТККлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "Закупка", "Видимость", ВидимостьВвозСПризнанием);
	
	//3. ГРУППА ИНВЕНТАРИЗАЦИЯ
	//Уведомления о вводе в оборот
	ВидимостьВводВОборот = ПравоДоступа("Просмотр", Метаданные.Документы.УведомлениеОВводеВОборотИСМПТК);
	ИнтерфейсИСМПТККлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ГруппаВозвратВОборотКодовМаркировкиИСМП", "Видимость", ВидимостьВводВОборот);
	
	//Уведомления о вывводе из оборота
	ВидимостьВыводИЗОборота = ПравоДоступа("Просмотр", Метаданные.Документы.УведомлениеОВыводеИзОборотаИСМПТК);							  
	ИнтерфейсИСМПТККлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ГруппаСписаниеКодовМаркировкиИСМП", "Видимость", ВидимостьВыводИЗОборота);
	
	//4. См. также
	ВидимостьСсылкаНаЛК = ВидимостьГруппаАППУОР ИЛИ ВидимостьВвоз ИЛИ ВидимостьВводВОборот ИЛИ ВидимостьВыводИЗОборота;  
	ИнтерфейсИСМПТККлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ГруппаСмТакже3", "Видимость", ВидимостьСсылкаНаЛК);
	///////////////////////////////
	
	//===========================
	
	//СТАНЦИЯ УПРАВЛЕНИЯ ЗАКАЗАМИ//
	//1. ГРУППА ПРОИЗВОДСТВО
	//Заказы на эмиссию кодов маркировки
	ВидимостьЗаказКМ = ПравоДоступа("Просмотр", Метаданные.Документы.ЗаказКодовМаркировкиСУЗИСМПТК);
	ИнтерфейсИСМПТККлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ГруппаЗаказНаЭмиссиюКодовМаркировкиСУЗ", "Видимость", ВидимостьЗаказКМ);
	
	//ВидимостьТребуетсяОтчетОНанесении = ПравоДоступа("Просмотр", Метаданные.Документы.ЗаказКодовМаркировкиСУЗИСМПТК)
	//									И ПравоДоступа("Просмотр", Метаданные.Документы.НанесениеКодовМаркировкиСУЗИСМПТК)
	//									И (ВедетсяУчетМарокПоЛекарствам ИЛИ ВедетсяУчетМарокПоМолочке ИЛИ ВедетсяУчетМарокПоТабаку);
	//ИнтерфейсИСМПТККлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ОткрытьСписокЗаказовТребующихНанесения", "Видимость", ВидимостьТребуетсяОтчетОНанесении);
	
	//Отчеты о нанесениеи кодов маркировки
	ВидимостьНанесениеКМ = ПравоДоступа("Просмотр", Метаданные.Документы.НанесениеКодовМаркировкиСУЗИСМПТК)
					   	   И (ВедетсяУчетМарокПоЛекарствам ИЛИ ВедетсяУчетМарокПоМолочке ИЛИ ВедетсяУчетМарокПоТабаку); //Для обуви не поддерживается
	ИнтерфейсИСМПТККлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ГруппаНанесениеКодовМаркировкиСУЗ", "Видимость", ВидимостьНанесениеКМ);
	
	//Агрегации кодов маркировки
	ВидимостьАгрегацияКМ = ПравоДоступа("Просмотр", Метаданные.Документы.АгрегацияКодовМаркировкиСУЗИСМПТК);
	ИнтерфейсИСМПТККлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ГруппаАгрегацияКодовМаркировкиСУЗ", "Видимость", ВидимостьАгрегацияКМ);
	
	//2. ГРУППА СЕРВИС
	//Пул кодов маркировки
	ВидимостьПулКодов = ПравоДоступа("Просмотр", Метаданные.РегистрыСведений.ПулКодовМаркировкиСУЗИСМПТК);
	ИнтерфейсИСМПТККлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ОткрытьПулКодовМаркировкиСУЗ", "Видимость", ВидимостьПулКодов);
	
	//РМ Создание группы отчетов об агрегации
	ВидимостьРМСозданиеАгрегаций = ПравоДоступа("Просмотр", Метаданные.Обработки.РабочиеМестаИСМПТК.Команды.ОткрытьРМСозданиеГруппыАгрегаций)
								   И ПравоДоступа("Изменение", Метаданные.Документы.АгрегацияКодовМаркировкиСУЗИСМПТК); //Создание документов в РМ
	ИнтерфейсИСМПТККлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ГрупповоеСозданиеАгрегаций", "Видимость", ВидимостьРМСозданиеАгрегаций);
	
	//РМ Проверка остатков КМ по данным агрегаций
	ВидимостьРМПроверкаОстатковПоАгрегациям = ПравоДоступа("Просмотр", Метаданные.Обработки.РабочиеМестаИСМПТК.Команды.ОткрытьРМПроверкаАгрегации); //Команда и форма РМ
	ИнтерфейсИСМПТККлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ОбработкаОбменИСМПТКРМПроверкаАгрегации", "Видимость", ВидимостьРМПроверкаОстатковПоАгрегациям);
	
	ИнтерфейсИСМПТККлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "Декорация1", "Видимость", ВидимостьРМПроверкаОстатковПоАгрегациям);
	///////////////////////////////
	
	//===========================
	
	/////НАЦИОНАЛЬНЫЙ КАТАЛОГ//////
	//На текущий момент интеграция не завершена!
	ИнтерфейсИСМПТККлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ГруппаНацКаталог", "Видимость", Ложь);
	///////////////////////////////
	
	//===========================
	
	////СЕРВИСНЫЕ ВОЗМОЖНОСТИ/////
	//1. НАСТРОЙКИ И СПРАВОЧНИКИ
	//Настройка обмена с ИС МПТ
	ВидимостьНастройкиОбмена = ПравоДоступа("Использование", Метаданные.Обработки.ПанельАдминистрированияИСМПТК);
	ИнтерфейсИСМПТККлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "НастройкаИСМП", "Видимость", ВидимостьНастройкиОбмена);
							   
	//Справочник Станции управления заказами
	ВидимостьСУЗ = ПравоДоступа("Изменение", Метаданные.Справочники.СтанцииУправленияЗаказамиИСМПТК); //Просматривать рядовому пользователю незачем.
	ИнтерфейсИСМПТККлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "СтанцииУправленияЗаказамиИСМП", "Видимость", ВидимостьСУЗ);
	
	//Справочник Шаблоны этикеток
	ВидимостьШаблоныЭтикетокКМ = ПравоДоступа("Просмотр", Метаданные.Справочники.ХранилищеШаблоновИСМПТК);
	ИнтерфейсИСМПТККлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ОткрытьШаблоныЭтикеток", "Видимость", ВидимостьШаблоныЭтикетокКМ);
	
	//2. РАБОТА С ФАЙЛАМИ
	//РМ Печать КМ из загруженного файла
	ВидимостьРМПечатьИзФайла = ПравоДоступа("Просмотр", Метаданные.Обработки.РабочиеМестаИСМПТК.Команды.ОткрытьРМПечатьКМИзФайла);
	ИнтерфейсИСМПТККлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ПечатьКМИзЗагруженногоФайла", "Видимость", ВидимостьРМПечатьИзФайла);
	
	//РМ Объединение загруженных файлов
	ВидимостьРМОбъединениеФайлов = ПравоДоступа("Просмотр", Метаданные.Обработки.РабочиеМестаИСМПТК.Команды.ОткрытьРМОбъединениеФайлов);
	ИнтерфейсИСМПТККлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ОбъединениеФайлов", "Видимость", ВидимостьРМОбъединениеФайлов);
	
	//3. ПРОИЗВОДСТВО
	//РМ Восстановление зависших операций в заказах
	ВидимостьРМВосстановлениеЗависшихЗаказов = ПравоДоступа("Просмотр", Метаданные.Документы.ЗаказКодовМаркировкиСУЗИСМПТК.Команды.ВосстановлениеЗависшихОпераций)
											   И ПравоДоступа("Изменение", Метаданные.Документы.ЗаказКодовМаркировкиСУЗИСМПТК); 
	ИнтерфейсИСМПТККлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ЗависшиеЗаказыКМ", "Видимость", ВидимостьРМВосстановлениеЗависшихЗаказов);
	
	//Список сгенерированных транспортных КМ
	ВидимостьСписокТранспортныхКодов = ПравоДоступа("Просмотр", Метаданные.Обработки.ГенерацияШтрихкодовИСМПТК);
	ИнтерфейсИСМПТККлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "КодыГрупповыхУпаковокSSCC", "Видимость", ВидимостьСписокТранспортныхКодов);
	
	//4. ПОЛУЧЕНИЕ ИНФОРМАЦИИ С СЕРВЕРА
	//РМ Проверка статуса и состояния КМ
	ВидимостьРМПроверкаСостоянияКМ = ПравоДоступа("Просмотр", Метаданные.Обработки.РабочиеМестаИСМПТК.Команды.ОткрытьРМПроверкаСостоянияКодовМаркировки);
	ИнтерфейсИСМПТККлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ПроверкаСостоянияКодовМаркировки", "Видимость", ВидимостьРМПроверкаСостоянияКМ);
	
	//РМ Управление счетами
	ВидимостьРМУправлениеСчетами = ПравоДоступа("Просмотр", Метаданные.Обработки.РабочиеМестаИСМПТК.Команды.ОткрытьРМУправлениеЛичнымиСчетами);
	ИнтерфейсИСМПТККлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "УправлениеЛичнымиСчетами", "Видимость", ВидимостьРМУправлениеСчетами);
			
КонецПроцедуры

#Область РМТребуютОформления

&НаКлиенте
Процедура ОткрытьСписокАППТребующихВводУОР(Команда)
	
	СписокАктов = ПолучитьСписокАктовТребующихВводУОР();
	
	ПараметрыФормыВыбора = Новый Структура();
	Отбор = Новый Структура();
	Отбор.Вставить("Ссылка", СписокАктов);
	ПараметрыФормыВыбора.Вставить("Отбор", Отбор);
	ПараметрыФормыВыбора.Вставить("Заголовок", "Акты приема/передачи: требуется оформление Уведомления о расхождениях");
	
	ОткрытьФорму("Документ.АктПриемаПередачиИСМПТК.Форма.ФормаСпискаВходящих", ПараметрыФормыВыбора);

КонецПроцедуры

&НаКлиенте
Процедура ОткрытьСписокЗаказовТребующихНанесения(Команда)
	
	СписокЗаказов = ПолучитьСписокЗаказовТребующихВводНанесения();
	
	ПараметрыФормыВыбора = Новый Структура();
	Отбор = Новый Структура();
	Отбор.Вставить("Ссылка", СписокЗаказов);
	ПараметрыФормыВыбора.Вставить("Отбор", Отбор);
	ПараметрыФормыВыбора.Вставить("Заголовок", "Заказы на эмиссию кодов маркировки: требуется оформление Отчета о нанесении");
	
	ОткрытьФорму("Документ.ЗаказКодовМаркировкиСУЗИСМПТК.Форма.ФормаСписка", ПараметрыФормыВыбора);

КонецПроцедуры

&НаКлиенте
Процедура ОткрытьСписокТоваровТребующихДоработки(Команда)
	
	ПараметрыФормыВыбора = Новый Структура();
	Отбор = Новый Структура();
	Отбор.Вставить("КарточкаЗаполнена", Ложь);
	ПараметрыФормыВыбора.Вставить("Отбор", Отбор);
	ПараметрыФормыВыбора.Вставить("Заголовок", "Карточки, требующие уточнения данных");
	ПараметрыФормыВыбора.Вставить("ЭтоВыборКарточки", Ложь);
	
	ОткрытьФорму("РегистрСведений.ТоварыНацКаталогаИСМПТК.ФормаСписка", ПараметрыФормыВыбора);
	
КонецПроцедуры

&НаСервере 
Процедура ПроверитьОбновитьСписокАППДляОформленияУОР()
	
	Если ПравоДоступа("Просмотр", Метаданные.Документы.АктПриемаПередачиИСМПТК) Тогда
		СписокАктов = ПолучитьСписокАктовТребующихВводУОР();
		ИнтерфейсИСМПТККлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ОткрытьСписокАППТребующихВводУОР", "Видимость", ЗначениеЗаполнено(СписокАктов));	 
	КонецЕсли;
	
КонецПроцедуры

&НаСервере 
Процедура ПроверитьОбновитьСписокЗаказовДляОформленияНанесения()
	
	Если ПравоДоступа("Просмотр", Метаданные.Документы.ЗаказКодовМаркировкиСУЗИСМПТК) Тогда
		СписокЗаказов = ПолучитьСписокЗаказовТребующихВводНанесения();
		ИнтерфейсИСМПТККлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ОткрытьСписокЗаказовТребующихНанесения", "Видимость", ЗначениеЗаполнено(СписокЗаказов));	 
	КонецЕсли;
	
КонецПроцедуры

&НаСервере 
Процедура ПроверитьОбновитьСписокТоваровНацКаталогаДляУточненияДанных()
	
	ПереченьТоваров = ПолучитьСписокТоваровТребующихУточнения();
	ИнтерфейсИСМПТККлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ОткрытьСписокТоваровТребующихДоработки", "Видимость", ЗначениеЗаполнено(ПереченьТоваров));	 
	
КонецПроцедуры

&НаСервере
Функция ПолучитьСписокАктовТребующихВводУОР() Экспорт
	
	Запрос = Новый Запрос();
	ТекстЗапроса = "ВЫБРАТЬ
	|	АктПриемаПередачиИСМПТКРасхождения.Ссылка КАК Ссылка
	|ИЗ
	|	Документ.АктПриемаПередачиИСМПТК.Расхождения КАК АктПриемаПередачиИСМПТКРасхождения
	|ГДЕ
	|	АктПриемаПередачиИСМПТКРасхождения.Ссылка.Направление = ЗНАЧЕНИЕ(Перечисление.НаправленияДокументовИСМПТК.Входящий)
	|	И АктПриемаПередачиИСМПТКРасхождения.Ссылка.УведомлениеОРасхождении = ЗНАЧЕНИЕ(Документ.УведомлениеОРасхожденииИСМПТК.ПустаяСсылка)
	|	И АктПриемаПередачиИСМПТКРасхождения.Ссылка.Статус В (&СписокСтатусов)
	|	&Организация
	|
	|СГРУППИРОВАТЬ ПО
	|	АктПриемаПередачиИСМПТКРасхождения.Ссылка";
	
	Если ЗначениеЗаполнено(Организация) Тогда 
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&Организация", "И АктПриемаПередачиИСМПТКРасхождения.Ссылка.Организация = &Организация");
	Иначе
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&Организация", "");
	КонецЕсли;
	
	СписокСтатусов = Новый Массив();
	СписокСтатусов.Добавить(ПредопределенноеЗначение("Перечисление.СтатусыДокументовИСМПТК.ОжидаетПриемку"));
	
	Запрос.Текст = ТекстЗапроса;
	Запрос.УстановитьПараметр("СписокСтатусов", СписокСтатусов);
	Если ЗначениеЗаполнено(Организация) Тогда 
		Запрос.УстановитьПараметр("Организация", Организация);
	КонецЕсли;
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	СписокАПП = Новый Массив();
	Пока Выборка.Следующий() Цикл
		СписокАПП.Добавить(Выборка.Ссылка);
	КонецЦикла;
	
	Возврат СписокАПП;
	
КонецФункции

&НаСервере
Функция ПолучитьСписокЗаказовТребующихВводНанесения() Экспорт
	
	Запрос = Новый Запрос();
	ТекстЗапроса = "ВЫБРАТЬ
	|	ЗаказКодовМаркировкиСУЗИСМПТК.Ссылка КАК Ссылка
	|ИЗ
	|	Документ.ЗаказКодовМаркировкиСУЗИСМПТК КАК ЗаказКодовМаркировкиСУЗИСМПТК
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ПулКодовМаркировкиСУЗИСМПТК КАК ПулКодовМаркировкиСУЗИСМПТК
	|		ПО (ПулКодовМаркировкиСУЗИСМПТК.ЗаказНаЭмиссию = ЗаказКодовМаркировкиСУЗИСМПТК.Ссылка)
	|ГДЕ
	|	ЗаказКодовМаркировкиСУЗИСМПТК.Статус В(&ДоступныеСтатусы)
	|	И ЗаказКодовМаркировкиСУЗИСМПТК.ВыполненоНанесениеКМ = ЛОЖЬ
	//|&Организация
	|	И (ЗаказКодовМаркировкиСУЗИСМПТК.ВидПродукции = ЗНАЧЕНИЕ(Перечисление.ВидыПродукцииИСМПТК.МолочнаяПродукция)
	|			ИЛИ ЗаказКодовМаркировкиСУЗИСМПТК.ВидПродукции = ЗНАЧЕНИЕ(Перечисление.ВидыПродукцииИСМПТК.ЛекарственныеПрепараты))
	|	И ПулКодовМаркировкиСУЗИСМПТК.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыКодовМаркировкиСУЗИСМПТК.СгенерированНеНанесен)
	|
	|СГРУППИРОВАТЬ ПО
	|	ЗаказКодовМаркировкиСУЗИСМПТК.Ссылка";
	
	Если ЗначениеЗаполнено(Организация) Тогда 
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&Организация", "И ЗаказКодовМаркировкиСУЗИСМПТК.Организация = &Организация");
	Иначе
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&Организация", "");
	КонецЕсли;
	
	СписокСтатусов = Новый Массив();
	СписокСтатусов.Добавить(ПредопределенноеЗначение("Перечисление.СтатусыОбработкиЗаказовНаЭмиссиюКодовМаркировкиИСМПТК.Выполнен"));
	
	Запрос.Текст = ТекстЗапроса;
	Запрос.УстановитьПараметр("ДоступныеСтатусы", СписокСтатусов);
	Если ЗначениеЗаполнено(Организация) Тогда 
		Запрос.УстановитьПараметр("Организация", Организация);
	КонецЕсли;
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	СписокЗаказов = Новый Массив();
	Пока Выборка.Следующий() Цикл
		СписокЗаказов.Добавить(Выборка.Ссылка);
	КонецЦикла;
	
	Возврат СписокЗаказов;
	
КонецФункции

&НаСервере
Функция ПолучитьСписокТоваровТребующихУточнения() Экспорт
	
	Запрос = Новый Запрос();
	ТекстЗапроса = "ВЫБРАТЬ
	|	ТоварыНацКаталогаИСМПТК.GTIN КАК GTIN
	|ИЗ
	|	РегистрСведений.ТоварыНацКаталогаИСМПТК КАК ТоварыНацКаталогаИСМПТК
	|ГДЕ
	|	ТоварыНацКаталогаИСМПТК.КарточкаЗаполнена = ЛОЖЬ
	|	&Организация
	|
	|СГРУППИРОВАТЬ ПО
	|	ТоварыНацКаталогаИСМПТК.GTIN";
	
	Если ЗначениеЗаполнено(Организация) Тогда 
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&Организация", "И ТоварыНацКаталогаИСМПТК.Организация = &Организация");
	Иначе
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&Организация", "");
	КонецЕсли;
		
	Запрос.Текст = ТекстЗапроса;
	Если ЗначениеЗаполнено(Организация) Тогда 
		Запрос.УстановитьПараметр("Организация", Организация);
	КонецЕсли;
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	СписокТоваров = Новый Массив();
	Пока Выборка.Следующий() Цикл
		СписокТоваров.Добавить(Выборка.GTIN);
	КонецЦикла;
	
	Возврат СписокТоваров;
	
КонецФункции

#КонецОбласти

#КонецОбласти