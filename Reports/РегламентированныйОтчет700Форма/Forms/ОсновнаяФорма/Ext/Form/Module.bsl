﻿
////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ОБЩЕГО НАЗНАЧЕНИЯ

// Процедура управляет показом в форме периода построения отчета.
//
&НаКлиентеНаСервереБезКонтекста
Процедура ПоказатьПериод(Форма)

	Если  (Форма.мДатаКонцаПериодаОтчета < Форма.мДатаНачалаПериодаОтчета) Тогда
		Сообщить("Неверно задан период", СтатусСообщения.Важное);
		Возврат;
	КонецЕсли;

	СтрПериодОтчета = ПредставлениеПериода(НачалоДня(Форма.мДатаНачалаПериодаОтчета), КонецДня(Форма.мДатаКонцаПериодаОтчета), "ФП = Истина" );
		
	Форма.НадписьПериодСоставленияОтчета = СтрПериодОтчета;

	КоличествоФорм = РегламентированнаяОтчетностьКлиентСервер.КоличествоФормСоответствующихВыбранномуПериоду(Форма);
	Если КоличествоФорм >= 1 Тогда

		Форма.Элементы.ОткрытьФормуОтчета.Доступность = Истина;

	Иначе		

		Форма.ОписаниеНормативДок = "";
		Форма.Элементы.ОткрытьФормуОтчета.Доступность = Ложь;
		
	КонецЕсли;

	РегламентированнаяОтчетностьКлиентСервер.ВыборФормыРегламентированногоОтчетаПоУмолчанию(Форма);

КонецПроцедуры

// Процедура устанавливает границы периода построения отчета.
//
// Параметры:
//  Шаг          - число, количество стандартных периодов, на которое необходимо
//                 сдвигать период построения отчета;
//
&НаКлиенте
Процедура ИзменитьПериод(Шаг)

	мДатаКонцаПериодаОтчета  = КонецГода(ДобавитьМесяц(мДатаКонцаПериодаОтчета, Шаг*12));
	мДатаНачалаПериодаОтчета = НачалоГода(мДатаКонцаПериодаОтчета);

	ПоказатьПериод(ЭтаФорма);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Налогоплательщик         = Параметры.Налогоплательщик;
	НалоговыйКомитет         = Параметры.НалоговыйКомитет;
	мДатаНачалаПериодаОтчета = Параметры.мДатаНачалаПериодаОтчета;
	мДатаКонцаПериодаОтчета  = Параметры.мДатаКонцаПериодаОтчета;
	мПериодичность           = Параметры.мПериодичность;
	мСкопированаФорма        = Параметры.мСкопированаФорма;
	мСохраненныйДок          = Параметры.мСохраненныйДок;
	          	
	мПоддержкаРаботыСоСтруктурнымиПодразделениями = ПолучитьФункциональнуюОпцию("ПоддержкаРаботыСоСтруктурнымиПодразделениями");	
	
	Если ЗначениеЗаполнено(Параметры.мВыбраннаяФорма) Тогда
		мПараметрыПрежнейФормы = Новый Структура("мВыбраннаяФорма, мСохраненныйДок, Налогоплательщик, НалоговыйКомитет, мДатаНачалаПериодаОтчета, мДатаКонцаПериодаОтчета",
												Параметры.мВыбраннаяФорма, Параметры.мСохраненныйДок, Параметры.Налогоплательщик, Параметры.НалоговыйКомитет, Параметры.мДатаНачалаПериодаОтчета, Параметры.мДатаКонцаПериодаОтчета);
	КонецЕсли;	

	ИсточникОтчета = СтрЗаменить(СтрЗаменить(Строка(ЭтаФорма.ИмяФормы), "Отчет.", ""), ".Форма.ОсновнаяФорма", "");
	
	ТаблицаФормОтчета = РеквизитФормыВЗначение("ОтчетОбъект").ТаблицаФормОтчета();
	
	ЗначениеВДанныеФормы(ТаблицаФормОтчета, мТаблицаФормОтчета);
	    		
	УчетПоВсемОрганизациям  = РегламентированнаяОтчетностьПереопределяемый.ПолучитьПризнакУчетаПоВсемОрганизациям();
	ПеречислениеРазделыНалоговогоУчета = Перечисления.РазделыНалоговогоУчета.МестныеНалоги;
	
	ОрганизацияПоУмолчанию = РегламентированнаяОтчетностьПереопределяемый.ПолучитьОрганизациюПоУмолчанию();
	
	ПеречислениеПериодичностьГод   = Перечисления.Периодичность.Год;
	ПеречислениеПериодичностьКвартал = Перечисления.Периодичность.Квартал;
		
	// Устанавливаем границы периода построения отчета как год текущий год
	Если НЕ ЗначениеЗаполнено(мДатаНачалаПериодаОтчета) И НЕ ЗначениеЗаполнено(мДатаКонцаПериодаОтчета) Тогда
		
		мДатаКонцаПериодаОтчета  = КонецГода(ТекущаяДатаСеанса());
		мДатаНачалаПериодаОтчета = НачалоГода(ТекущаяДатаСеанса());

	КонецЕсли;

	Если НЕ ЗначениеЗаполнено(мПериодичность) ИЛИ НЕ (мПериодичность = ПеречислениеПериодичностьГод ИЛИ мПериодичность = ПеречислениеПериодичностьКвартал) Тогда
		мПериодичность = ПеречислениеПериодичностьГод;
	КонецЕсли;
	
	ПолеВыбораПериодичность = мПериодичность;
	
	ПоказатьПериод(ЭтаФорма);
	 	
	Если НЕ ЗначениеЗаполнено(Налогоплательщик) 
	   И ЗначениеЗаполнено(ОрганизацияПоУмолчанию) Тогда
		Налогоплательщик = ОрганизацияПоУмолчанию;
		
		Если мПоддержкаРаботыСоСтруктурнымиПодразделениями Тогда
			// получим действительного налогоплательщика
			Налогоплательщик = ПроцедурыНалоговогоУчетаВызовСервераПовтИсп.ПолучитьНалогоплательщикаСтруктурнойЕдиницы(Налогоплательщик,
																		Налогоплательщик,
																		ПеречислениеРазделыНалоговогоУчета);		    		
		КонецЕсли;

	КонецЕсли;	
	        	 	
	Если мПоддержкаРаботыСоСтруктурнымиПодразделениями Тогда
		
		СписокКомитетов = ПроцедурыНалоговогоУчетаВызовСервераПовтИсп.СформироватьСписокНалоговыхКомитетов(Налогоплательщик, ПеречислениеРазделыНалоговогоУчета);		
		
		НКНалогоплательщика = ПолучитьЗначениеРеквизита(Налогоплательщик, "НалоговыйКомитет");
		Если СписокКомитетов.Количество() = 1 Тогда
			НалоговыйКомитет = СписокКомитетов[0].Значение;		
		ИначеЕсли ЗначениеЗаполнено(НКНалогоплательщика) 
			И СписокКомитетов.НайтиПоЗначению(НКНалогоплательщика) <> Неопределено Тогда
			НалоговыйКомитет = НКНалогоплательщика;
		КонецЕсли;
		
		Элементы.НалоговыйКомитет.СписокВыбора.ЗагрузитьЗначения(СписокКомитетов.ВыгрузитьЗначения());
		
	КонецЕсли;  	
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)

	// здесь отключаем стандартную обработку ПередЗакрытием формы
	// для подавления выдачи запроса на сохранение формы.
	СтандартнаяОбработка = Ложь;

КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ФОРМЫ

&НаСервере
Процедура УстановитьПериодичностьНаСервере()
	
	мПериодичность = Перечисления.Периодичность.Год;

КонецПроцедуры


&НаКлиенте
Процедура УстановитьПредыдущийПериод(Команда)
	
	ИзменитьПериод(-1);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьСледующийПериод(Команда)
	
	ИзменитьПериод(1);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФормуОтчета(Команда)
	
	Если мСкопированаФорма <> Неопределено Тогда
		// Документ был скопиран. 
		// Проверяем соответствие форм.
		Если мВыбраннаяФорма <> мСкопированаФорма Тогда
			
			ПоказатьПредупреждение(,НСтр("ru='Форма отчета изменилась, копирование невозможно!'"));
			Возврат;
						
		КонецЕсли;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Налогоплательщик) Тогда
		
		Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru='%1'"), РегламентированнаяОтчетностьКлиент.ОсновнаяФормаОрганизацияНеЗаполненаВывестиТекст());

		ОбщегоНазначенияКлиент.СообщитьПользователю(Текст, , "Налогоплательщик", "Объект", Истина);
				
		Возврат;
		
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(мВыбраннаяФорма) Тогда
		ТекстСообщения = НСтр("ru='Форма отчета для указанного периода не определена.'");
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения);				
		Возврат;		
	КонецЕсли;
	
	Если мСкопированаФорма <> Неопределено Тогда
		// Документ был скопиран. 
		// Проверяем соответствие форм.
		Если мВыбраннаяФорма <> мСкопированаФорма Тогда
			
			ПоказатьПредупреждение(,(НСтр("ru='Форма отчета изменилась, копирование невозможно!'")));
			Возврат;
						
		КонецЕсли;
	КонецЕсли;
	
	Если мПоддержкаРаботыСоСтруктурнымиПодразделениями Тогда
		Если Не ЗначениеЗаполнено(НалоговыйКомитет) Тогда
			Если СписокКомитетов.Количество() = 0 Тогда
				
				Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru='Ни в регистре сведений ""Исчисление налогов структурных единиц"", ни в справочнике ""Организации"" не указан налоговый комитет для %1'"), Налогоплательщик);					
				ОбщегоНазначенияКлиент.СообщитьПользователю(Текст, ,"НалоговыйКомитет" , "Объект" , Истина); 					
				Возврат;
			Иначе
				ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru='Не выбран налоговый комитет из списка!'"), ,"НалоговыйКомитет" , "Объект" , Истина);					
				Возврат;
			КонецЕсли;				
		КонецЕсли;		
		мСписокСтруктурныхЕдиниц = ПроцедурыНалоговогоУчетаВызовСервераПовтИсп.СформироватьСписокСтруктурныхЕдиниц(ПеречислениеРазделыНалоговогоУчета, НалоговыйКомитет, Налогоплательщик);		
	Иначе
		НалоговыйКомитет = ПолучитьЗначениеРеквизита(Налогоплательщик, "НалоговыйКомитет");
		Если Не ЗначениеЗаполнено(НалоговыйКомитет) Тогда			
			Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru='В справочнике ""Организации"" не указан налоговый комитет для %1'"), Налогоплательщик);					
			ОбщегоНазначенияКлиент.СообщитьПользователю(Текст, , , , Истина); 					
			Возврат;
		КонецЕсли;     		
		мСписокСтруктурныхЕдиниц.Очистить();
		мСписокСтруктурныхЕдиниц.Добавить(Налогоплательщик);
	КонецЕсли;    
		
	// Основная форма была открыта из формы периода.
	Если мПараметрыПрежнейФормы <> Неопределено Тогда
		ТекстИзменений = НСтр("ru = 'Изменены параметры формирования отчета:'");
		ЕстьИзменения = Ложь;
		НеобходимоСохранитьФорму = Ложь;
		НеобходимоОчиститьФорму = Ложь;
		Если мПараметрыПрежнейФормы.Налогоплательщик <> Налогоплательщик Тогда
			ТекстИзменений = ТекстИзменений + НСТР("ru = 'налогоплательщик'");
			ЕстьИзменения = Истина;
			НеобходимоОчиститьФорму = Истина;
		КонецЕсли;	
		
		Если мПараметрыПрежнейФормы.НалоговыйКомитет <> НалоговыйКомитет Тогда
			ТекстИзменений = ТекстИзменений + ?(ЕстьИзменения, НСТР("ru=' и '"), "") +  НСТР("ru = 'налоговый комитет'");
			ЕстьИзменения = Истина;
			НеобходимоОчиститьФорму = Истина;
		КонецЕсли;	
		
		Если мПараметрыПрежнейФормы.мДатаНачалаПериодаОтчета <> мДатаНачалаПериодаОтчета ИЛИ мПараметрыПрежнейФормы.мДатаКонцаПериодаОтчета <> мДатаКонцаПериодаОтчета Тогда
			ТекстИзменений = ТекстИзменений + ?(ЕстьИзменения, НСТР("ru=' и '"), "") + НСТР("ru = 'отчетный период'");
			ЕстьИзменения = Истина;
			НеобходимоОчиститьФорму = Истина;
		КонецЕсли;	
						
		Если мПараметрыПрежнейФормы.мВыбраннаяФорма <> мВыбраннаяФорма Тогда
			ЕстьИзменения = Истина;
			НеобходимоСохранитьФорму = Истина;
		КонецЕсли;
		
		Если ЕстьИзменения И НеобходимоСохранитьФорму Тогда			
			// форма открыта из формы отчета. При изменении формы периода требуется открыть новую форму
			ТекстВопроса = ТекстИзменений + НСТР("ru = '. Будет закрыта форма текущего отчета и открыта новая форма, соответствующая данному периоду. Продолжить?'");
			
			ОбработчикОповещенияОЗакрытии = Новый ОписаниеОповещения("ВопросОНеобходимостиЗакрытияПредыдущейФормы",
			ЭтотОбъект);
			ПоказатьВопрос(ОбработчикОповещенияОЗакрытии, ТекстВопроса, РежимДиалогаВопрос.ДаНет);		
			Возврат; // дальнейшие действия будут выполнены в обработке оповещения
			
		КонецЕсли;	
		
		Если ЕстьИзменения И НеобходимоОчиститьФорму Тогда
			// форма открыта из формы отчета. При изменении формы периода требуется открыть новую форму
			ТекстВопроса = ТекстИзменений + НСТР("ru = '. Данные в форме будут очищены! Продолжить?'");
			
			ОбработчикОповещенияОЗакрытии = Новый ОписаниеОповещения("ВопросОНеобходимостиОчисткиПредыдущейФормы", ЭтотОбъект);
			ПоказатьВопрос(ОбработчикОповещенияОЗакрытии, ТекстВопроса, РежимДиалогаВопрос.ДаНет);		
			Возврат; // дальнейшие действия будут выполнены в обработке оповещения
			
		КонецЕсли;	
	КонецЕсли;	
	
	ОткрытьВыбраннуюФорму();	
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаСервереБезКонтекста
Функция ПолучитьЗначениеРеквизита(Ссылка, ЗначениеРеквизита)
											
	Возврат ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Ссылка, ЗначениеРеквизита);										
											
КонецФункции

&НаКлиенте
Процедура НалогоплательщикПриИзменении(Элемент)
	
	Если мПоддержкаРаботыСоСтруктурнымиПодразделениями Тогда
		Элементы.НалоговыйКомитет.СписокВыбора.Очистить();
		
		СписокКомитетов = ПроцедурыНалоговогоУчетаВызовСервераПовтИсп.СформироватьСписокНалоговыхКомитетов(Налогоплательщик, ПеречислениеРазделыНалоговогоУчета);
				
		Элементы.НалоговыйКомитет.СписокВыбора.ЗагрузитьЗначения(СписокКомитетов.ВыгрузитьЗначения());
		 	
		Если СписокКомитетов.НайтиПоЗначению(НалоговыйКомитет) = Неопределено
			ИЛИ НЕ ЗначениеЗаполнено(НалоговыйКомитет)  Тогда				
			НКНалогоплательщика = ПолучитьЗначениеРеквизита(Налогоплательщик, "НалоговыйКомитет");
			Если ЗначениеЗаполнено(НКНалогоплательщика) 
				И СписокКомитетов.НайтиПоЗначению(НКНалогоплательщика) <> Неопределено Тогда
				НалоговыйКомитет = НКНалогоплательщика;
			ИначеЕсли СписокКомитетов.Количество() = 1 Тогда
				НалоговыйКомитет = СписокКомитетов[0].Значение;
			Иначе
				НалоговыйКомитет = ПредопределенноеЗначение("Справочник.Контрагенты.ПустаяСсылка");
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВопросОНеобходимостиЗакрытияПредыдущейФормы(РезультатВопроса, ДополнительныеПараметры) Экспорт          
	
	Если РезультатВопроса <> КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли;
	Попытка
		ВладелецФормы.СохранитьДанные(); // экспортная процедура формы
	Исключение
		ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru = 'Не удалось сохранить отчет.'"));
	КонецПопытки;

	Если ВладелецФормы <> Неопределено Тогда
		ВладелецФормы.Закрыть();
	КонецЕсли;
	
	мСохраненныйДок = Неопределено;

	ОткрытьВыбраннуюФорму(Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ВопросОНеобходимостиОчисткиПредыдущейФормы(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если РезультатВопроса <> КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли;
	
	Попытка
		ОсновнаяФорма = ВладелецФормы.СписокФормДерева.ПолучитьЭлементы()[0];
		КодОсновнойФормыВладельца 			   = ОсновнаяФорма.КодФормы;
		МногострочностьОсновнойФормыВладельца  = ОсновнаяФорма.Многострочность;	
		
		ВладелецФормы.ОчиститьРеглОтчетЗавершениеНаСервере(КодОсновнойФормыВладельца, МногострочностьОсновнойФормыВладельца, Истина);
		
	//	ВладелецФормы.Очистить(КодОсновнойФормыВладельца, Истина);
	Исключение
		ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru = 'Не удалось очистить отчет.'"));
	КонецПопытки;
	
	ОткрытьВыбраннуюФорму(Истина);
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьВыбраннуюФорму(ОбновитьПараметрыОткрытойФормы = Ложь)

	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("мДатаНачалаПериодаОтчета", мДатаНачалаПериодаОтчета);
	ПараметрыФормы.Вставить("мСохраненныйДок",          мСохраненныйДок);
	ПараметрыФормы.Вставить("мСкопированаФорма",        мСкопированаФорма);
	ПараметрыФормы.Вставить("мДатаКонцаПериодаОтчета",  мДатаКонцаПериодаОтчета);
	ПараметрыФормы.Вставить("мПериодичность",           мПериодичность);
	ПараметрыФормы.Вставить("Налогоплательщик",         Налогоплательщик);
	ПараметрыФормы.Вставить("НалоговыйКомитет",         НалоговыйКомитет);
	ПараметрыФормы.Вставить("мВыбраннаяФорма",          мВыбраннаяФорма);
	ПараметрыФормы.Вставить("мСписокСтруктурныхЕдиниц", мСписокСтруктурныхЕдиниц);	
	ПараметрыФормы.Вставить("мПериодичность",			мПериодичность);	
	
	Если ОбновитьПараметрыОткрытойФормы И ВладелецФормы <> Неопределено Тогда
		// при повторном открытии не выполняется создание формы на сервере
		// необходимо самостоятельно обновить параметры формы и зависимые данные
		ВладелецФормы.ОбновитьПараметрыФормыНаКлиенте(ПараметрыФормы);
	КонецЕсли;	
	
	Попытка
		Если ВладелецФормы  = Неопределено Тогда
			ОткрытьФорму(СтрЗаменить(ЭтаФорма.ИмяФормы, "ОсновнаяФорма", "") + мВыбраннаяФорма, ПараметрыФормы);
		Иначе
			ОткрытьФорму(СтрЗаменить(ЭтаФорма.ИмяФормы, "ОсновнаяФорма", "") + мВыбраннаяФорма, ПараметрыФормы,,ВладелецФормы.КлючУникальности);
		КонецЕсли;	 		
		Закрыть(); // закрываем основную форму
	Исключение
		ТекстСообщения = НСтр("ru='Форма отчета для указанного периода не определена.'");
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения);		
	КонецПопытки;	
		  	
КонецПроцедуры
