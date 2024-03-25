﻿
////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	Если ВРег(ИсточникВыбора.ИмяФормы) = ВРег("ОбщаяФорма.ФормаВыбораИзКлассификатора") Тогда
		Если ВыбранноеЗначение <> Неопределено Тогда
			Запись.КодСтроки = ВыбранноеЗначение;
			Модифицированность = Истина;
		КонецЕсли;
	КонецЕсли;	

КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

&НаКлиенте
Процедура ПериодПриИзменении(Элемент)
	
	РабочаяДата = ОбщегоНазначенияКлиент.ДатаСеанса();
	
	Если Запись.Период > РабочаяДата Тогда
		
		ТекстВопроса		 = НСтр("ru='Вы действительно хотите ввести данные" + Символы.ПС + "на будущую дату?'");
		Режим 	    		 = РежимДиалогаВопрос.ДаНет;
		КнопкаПоУмолчанию	 = КодВозвратаДиалога.Нет;
		ПараметрыОповещения	 = Новый Структура("РабочаяДата", РабочаяДата);
		Оповещение  		 = Новый ОписаниеОповещения("ПослеИзмененияПериода", ЭтотОбъект, ПараметрыОповещения);
		
		ПоказатьВопрос(Оповещение, ТекстВопроса, Режим, 0, КнопкаПоУмолчанию);
		
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура КодСтрокиНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ПараметрыФормы = Новый Структура;
	
	ПараметрыФормы.Вставить("ИмяМакета"			  , "КодыСтрокНалоговыхДеклараций");
	ПараметрыФормы.Вставить("ИмяСекции"			  ,	"Акциз");
	ПараметрыФормы.Вставить("ПолучатьПолныеДанные", Ложь);
	ПараметрыФормы.Вставить("ТекущийКодСтроки"	  , ?(НЕ ЗначениеЗаполнено(Запись.КодСтроки), Неопределено, СокрЛП(Запись.КодСтроки)));
	
	ОткрытьФорму("ОбщаяФорма.ФормаВыбораИзКлассификатора", ПараметрыФормы, ЭтаФорма,,,,,РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура КодСтрокиПриИзменении(Элемент)
	
	Запись.КодСтроки = РегламентированнаяОтчетностьКлиентСервер.ОбрезатьКодСтроки(Запись.КодСтроки);

КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ТАБЛИЦЫ ФОРМЫ <ИМЯ ТАБЛИЦЫ ФОРМЫ>

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаКлиенте
Процедура ПослеИзмененияПериода(Результат, ПараметрыОповещения) Экспорт
	Если Результат = КодВозвратаДиалога.Нет Тогда
		Запись.Период = ПараметрыОповещения.РабочаяДата;
	КонецЕсли;	
КонецПроцедуры	

