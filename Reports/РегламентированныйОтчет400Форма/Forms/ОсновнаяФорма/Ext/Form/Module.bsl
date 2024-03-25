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

	Если ПолеВыбораПериодичность = ПеречислениеПериодичностьКвартал Тогда  // ежеквартально
		мДатаКонцаПериодаОтчета  = КонецКвартала(ДобавитьМесяц(мДатаКонцаПериодаОтчета, Шаг*3));
		мДатаНачалаПериодаОтчета = НачалоКвартала(мДатаКонцаПериодаОтчета);
	Иначе
		мДатаКонцаПериодаОтчета  = КонецМесяца(ДобавитьМесяц(мДатаКонцаПериодаОтчета, Шаг)); 
		мДатаНачалаПериодаОтчета = НачалоМесяца(мДатаКонцаПериодаОтчета);
	КонецЕсли;

	ПоказатьПериод(ЭтаФорма);

КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Налогоплательщик         = Параметры.Налогоплательщик;
	мДатаНачалаПериодаОтчета = Параметры.мДатаНачалаПериодаОтчета;
	мДатаКонцаПериодаОтчета  = Параметры.мДатаКонцаПериодаОтчета;
	мПериодичность           = Параметры.мПериодичность;
	мСкопированаФорма        = Параметры.мСкопированаФорма;
	мСохраненныйДок          = Параметры.мСохраненныйДок;
	
	Если ЗначениеЗаполнено(Параметры.мВыбраннаяФорма) Тогда
		мПараметрыПрежнейФормы = Новый Структура("мВыбраннаяФорма, мСохраненныйДок, Налогоплательщик, мДатаНачалаПериодаОтчета, мДатаКонцаПериодаОтчета",
												Параметры.мВыбраннаяФорма, Параметры.мСохраненныйДок, Параметры.Налогоплательщик, Параметры.мДатаНачалаПериодаОтчета, Параметры.мДатаКонцаПериодаОтчета);
	КонецЕсли;	

				
	ИсточникОтчета = СтрЗаменить(СтрЗаменить(Строка(ЭтаФорма.ИмяФормы), "Отчет.", ""), ".Форма.ОсновнаяФорма", "");
	
	ТаблицаФормОтчета = РеквизитФормыВЗначение("ОтчетОбъект").ТаблицаФормОтчета();
	
	ЗначениеВДанныеФормы(ТаблицаФормОтчета, мТаблицаФормОтчета);
	
	Элементы.ПолеВыбораПериодичность.СписокВыбора.Добавить(Перечисления.Периодичность.Месяц);
		   		
	УчетПоВсемОрганизациям 	= РегламентированнаяОтчетностьПереопределяемый.ПолучитьПризнакУчетаПоВсемОрганизациям();
	ПеречислениеРазделыНалоговогоУчета = Перечисления.РазделыНалоговогоУчета.Акциз;

	ОрганизацияПоУмолчанию = РегламентированнаяОтчетностьПереопределяемый.ПолучитьОрганизациюПоУмолчанию();
	
	ПеречислениеПериодичностьМесяц   = Перечисления.Периодичность.Месяц;
	ПеречислениеПериодичностьКвартал = Перечисления.Периодичность.Квартал;
		
	// Устанавливаем границы периода построения отчета как квартал
	// предшествующий текущему, нарастающим итогом с начала года.
	Если НЕ ЗначениеЗаполнено(мДатаНачалаПериодаОтчета) И НЕ ЗначениеЗаполнено(мДатаКонцаПериодаОтчета) Тогда		
		мДатаКонцаПериодаОтчета  = КонецМесяца(ТекущаяДатаСеанса());
		мДатаНачалаПериодаОтчета = НачалоМесяца(ТекущаяДатаСеанса());                                        
	КонецЕсли;

	Если НЕ ЗначениеЗаполнено(мПериодичность) ИЛИ НЕ (мПериодичность = ПеречислениеПериодичностьМесяц ИЛИ мПериодичность = ПеречислениеПериодичностьКвартал) Тогда
		мПериодичность = ПеречислениеПериодичностьМесяц;
	КонецЕсли;

	ПолеВыбораПериодичность = мПериодичность;
	
	ПоказатьПериод(ЭтаФорма); 	
	
	Если НЕ ЗначениеЗаполнено(Налогоплательщик) 
	   И ЗначениеЗаполнено(ОрганизацияПоУмолчанию) Тогда
		Налогоплательщик = ОрганизацияПоУмолчанию;
	КонецЕсли;	
	
	мПоддержкаРаботыСоСтруктурнымиПодразделениями = ПолучитьФункциональнуюОпцию("ПоддержкаРаботыСоСтруктурнымиПодразделениями");	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)

	// здесь отключаем стандартную обработку ПередЗакрытием формы
	// для подавления выдачи запроса на сохранение формы.
	СтандартнаяОбработка = Ложь;

КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ФОРМЫ

&НаКлиенте
Процедура ПолеВыбораПериодичностьПриИзменении(Элемент)
	
	Если ПолеВыбораПериодичность = ПеречислениеПериодичностьКвартал Тогда  // ежеквартально
		мДатаКонцаПериодаОтчета  = КонецКвартала(мДатаКонцаПериодаОтчета);
		мДатаНачалаПериодаОтчета = НачалоКвартала(мДатаКонцаПериодаОтчета);
	Иначе
		мДатаКонцаПериодаОтчета  = КонецМесяца(мДатаКонцаПериодаОтчета);
		мДатаНачалаПериодаОтчета = НачалоМесяца(мДатаКонцаПериодаОтчета);
	КонецЕсли;

	мПериодичность = ПолеВыбораПериодичность;
	
	ПоказатьПериод(ЭтаФорма);
		
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
	
	Если НЕ ЗначениеЗаполнено(Налогоплательщик) Тогда						
		ОбщегоНазначенияКлиент.СообщитьПользователю(РегламентированнаяОтчетностьКлиент.ОсновнаяФормаОрганизацияНеЗаполненаВывестиТекст());				
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
	
	// Основная форма была открыта из формы периода.
	Если мПараметрыПрежнейФормы <> Неопределено Тогда
		
		ТекстИзменений = НСтр("ru = 'Изменены параметры формирования отчета:'");
		ЕстьИзменения = Ложь;
		НеобходимоОткрытьНовуюФорму = Ложь;
		НеобходимоОчиститьФорму = Ложь;
		Если мПараметрыПрежнейФормы.Налогоплательщик <> Налогоплательщик Тогда
			ТекстИзменений = ТекстИзменений + НСТР("ru = 'налогоплательщик'");
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
			НеобходимоОткрытьНовуюФорму = Истина;
		КонецЕсли; 
		
		Если ЕстьИзменения И НеобходимоОткрытьНовуюФорму Тогда			
			// форма открыта из формы отчета. При изменении формы периода требуется открыть новую форму			
			ТекстВопроса = ТекстИзменений + НСТР("ru = '. Будет закрыта форма текущего отчета и открыта новая форма, соответствующая данному периоду. Продолжить?'");			
			ОбработчикОповещенияОЗакрытии = Новый ОписаниеОповещения("ВопросОНеобходимостиЗакрытияПредыдущейФормы", ЭтотОбъект);
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

&НаКлиенте
Процедура ВопросОНеобходимостиЗакрытияПредыдущейФормы(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если РезультатВопроса <> КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли;
	
	Если ВладелецФормы <> Неопределено Тогда
		ВладелецФормы.Модифицированность = Ложь; // Снимем флаг, чтобы подавить вопрос на сохранение данных при закрытии
		ВладелецФормы.Закрыть();
	КонецЕсли;
	
	мСохраненныйДок = Неопределено; // при открытии новой формы не нужно восстанавливать данные сохраненные в прежнем шаблоне
		
	ОткрытьВыбраннуюФорму();
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

		//ВладелецФормы.Очистить(КодОсновнойФормыВладельца, Истина);
	Исключение
		ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru = 'Не удалось очистить отчет.'"));
	КонецПопытки;
	
	ОткрытьВыбраннуюФорму(Истина);
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьВыбраннуюФорму(ОбновитьПараметрыОткрытойФормы = Ложь)

	Если мПоддержкаРаботыСоСтруктурнымиПодразделениями Тогда				
		мСписокСтруктурныхЕдиниц = ПроцедурыНалоговогоУчетаВызовСервераПовтИсп.СформироватьСписокСтруктурныхЕдиниц(ПеречислениеРазделыНалоговогоУчета, Неопределено, Налогоплательщик);
	Иначе				
		мСписокСтруктурныхЕдиниц.Очистить();
		мСписокСтруктурныхЕдиниц.Добавить(Налогоплательщик);
	КонецЕсли;
		
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("мДатаНачалаПериодаОтчета", мДатаНачалаПериодаОтчета);
	ПараметрыФормы.Вставить("мСохраненныйДок",          мСохраненныйДок);
	ПараметрыФормы.Вставить("мСкопированаФорма",        мСкопированаФорма);
	ПараметрыФормы.Вставить("мДатаКонцаПериодаОтчета",  мДатаКонцаПериодаОтчета);
	ПараметрыФормы.Вставить("мПериодичность",           мПериодичность);
	ПараметрыФормы.Вставить("Налогоплательщик",         Налогоплательщик);	
	ПараметрыФормы.Вставить("мВыбраннаяФорма",          мВыбраннаяФорма);
	ПараметрыФормы.Вставить("мСписокСтруктурныхЕдиниц", мСписокСтруктурныхЕдиниц);	
		
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
