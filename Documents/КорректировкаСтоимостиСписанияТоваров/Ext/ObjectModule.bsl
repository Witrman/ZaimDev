﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	ТипДанныхЗаполнения = ТипЗнч(ДанныеЗаполнения);
	
	Если ТипДанныхЗаполнения = Тип("Структура") Тогда 
		Если ДанныеЗаполнения.Свойство("Автор") Тогда
			ДанныеЗаполнения.Удалить("Автор");
		КонецЕсли;
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, ДанныеЗаполнения);
	КонецЕсли;

	ЗаполнениеДокументов.ЗаполнитьШапкуДокумента(ЭтотОбъект,,,,, ДанныеЗаполнения);
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Отказ = СуществуютПовторяемыеДокументы(); 
	
	ДополнительныеСвойства.Вставить("ВыполненаПроверкаЗаполнения", Истина);
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если РежимЗаписи = РежимЗаписиДокумента.Проведение 
		И НЕ ДополнительныеСвойства.Свойство("ВыполненаПроверкаЗаполнения") 
		ИЛИ (ДополнительныеСвойства.Свойство("ВыполненаПроверкаЗаполнения") И НЕ ДополнительныеСвойства.ВыполненаПроверкаЗаполнения) Тогда 
		
		Отказ = НЕ ПроверитьЗаполнение();
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	// ПОДГОТОВКА ПРОВЕДЕНИЯ ПО ДАННЫМ ДОКУМЕНТА
	ПроведениеСервер.ПодготовитьНаборыЗаписейКПроведению(ЭтотОбъект, Ложь);
	Если РучнаяКорректировка Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыПроведения = Документы.КорректировкаСтоимостиСписанияТоваров.ПодготовитьПараметрыПроведения(Ссылка, Отказ);
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	МассивТоваров = ОбщегоНазначения.ВыгрузитьКолонку(ПараметрыПроведения.ТаблицаТоваров, "Номенклатура", Истина);
	СтруктураПараметров = ОбщегоНазначения.СтрокаТаблицыЗначенийВСтруктуру(ПараметрыПроведения.Реквизиты[0]);
	СтруктураПараметров.Вставить("ТаблицаТоваров", МассивТоваров);
	СтруктураПараметров.Вставить("Учет", "БУ");
	СтруктураПараметров.Вставить("ЗаписьВозвратыПоПроизводству", Движения.Типовой.ВыгрузитьКолонки());
	СтруктураПараметров.Вставить("ЗаписьСведенияОКорректировкиСтоимостиПродукцииИТоваров", Движения.СведенияОКорректировкиСтоимостиПродукцииИТоваров.ВыгрузитьКолонки());
	
	РасчетСебестоимости.КорректировкаСтоимости(СтруктураПараметров, Движения, Отказ);
	
	//запишем вовзраты из таблицы возвратов
	Для Каждого Строка Из СтруктураПараметров.ЗаписьВозвратыПоПроизводству Цикл 
		
		Проводка = Движения.Типовой.Добавить();
				   
		Проводка.Период = Строка.Период;
		Проводка.Регистратор   = Строка.Регистратор;
		Проводка.Активность    = Истина;
		Проводка.Организация   = Строка.Организация;
		Проводка.Содержание    = "Корректировка стоимости списания";
		Проводка.ВидРегламентнойОперации = Строка.ВидРегламентнойОперации;
				
		Проводка.СчетКт = Строка.СчетКт;
		ПроцедурыБухгалтерскогоУчета.УстановитьСубконто(Проводка.СчетКт, Проводка.СубконтоКт, 1, Строка.СубконтоКт1);
		ПроцедурыБухгалтерскогоУчета.УстановитьСубконто(Проводка.СчетКт, Проводка.СубконтоКт, 2, Строка.СубконтоКт2);
		ПроцедурыБухгалтерскогоУчета.УстановитьСубконто(Проводка.СчетКт, Проводка.СубконтоКт, 3, Строка.СубконтоКт3);
				
		Проводка.СчетДт = Строка.СчетДт;
		ПроцедурыБухгалтерскогоУчета.УстановитьСубконто(Проводка.СчетДт, Проводка.СубконтоДт, 1, Строка.СубконтоДт1);
		ПроцедурыБухгалтерскогоУчета.УстановитьСубконто(Проводка.СчетДт, Проводка.СубконтоДт, 2, Строка.СубконтоДт2);
		ПроцедурыБухгалтерскогоУчета.УстановитьСубконто(Проводка.СчетДт, Проводка.СубконтоДт, 3, Строка.СубконтоДт3);
		
		Проводка.СтруктурноеПодразделениеДт = Строка.СтруктурноеПодразделениеДт; 
		Проводка.СтруктурноеПодразделениеКт = Строка.СтруктурноеПодразделениеКт;
				
		Проводка.Сумма = Строка.Сумма;
				
	КонецЦикла;
	
	Движения.Типовой.Записать(Ложь);
	
	
	Если СтруктураПараметров.УчитыватьКПН Тогда
		
		СтруктураПараметров.Вставить("ТаблицаТоваров", МассивТоваров);
		СтруктураПараметров.Вставить("Учет", "НУ");
		СтруктураПараметров.Вставить("СписокНеКорректируемыхСчетов", Неопределено);
		СтруктураПараметров.Вставить("РасчетПрямыхЗатратНомер", "");
		
		ТаблицаРасчетаСебестоимости = СтруктураПараметров.ЗаписьСведенияОКорректировкиСтоимостиПродукцииИТоваров.Скопировать();
		
		//Необходимо знать регистраторы корректировок, чтобы их сразу отсечь при выборке
		СтруктураПараметров.Вставить("СписокКорректируемыхДокументов", ТаблицаРасчетаСебестоимости.ВыгрузитьКолонку("КорректируемыйДокумент"));
		
		ТаблицаРасчетаСебестоимости.Свернуть("Номенклатура,ПодразделениеВыпуска,НоменклатурнаяГруппаВыпуска,СтруктурноеПодразделение,СтруктурноеПодразделениеПолучатель,ОперацияСписания,ОПР,КорректируемыйДокумент, СчетЗатратБУ, СтатьяЗатрат", "СуммаКорректировки,Количество,Себестоимость,СуммаКорректировкиВНУ");	   
		СтруктураПараметров.Вставить("ТаблицаРасчетаСебестоимости", ТаблицаРасчетаСебестоимости);
		
		//скорректируем по виду учета НУ = "НУ"
		СтруктураПараметров.Вставить("ВидУчетаНУ", Справочники.ВидыУчетаНУ.НУ);   
		РасчетСебестоимости.КорректировкаСтоимости(СтруктураПараметров, Движения, Отказ);
		
		//скорректируем по виду учета НУ = "ПР"
		СтруктураПараметров.Вставить("ВидУчетаНУ", Справочники.ВидыУчетаНУ.ПР);	
		РасчетСебестоимости.КорректировкаСтоимости(СтруктураПараметров, Движения, Отказ);
		
	КонецЕсли;
	
	РасчетСебестоимости.СФормироватьДвиженияСведенияОКорректировкеСтоимостиПродукцииИТоваров(СтруктураПараметров.ЗаписьСведенияОКорректировкиСтоимостиПродукцииИТоваров, ПараметрыПроведения.Реквизиты, Движения, Отказ);
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	Дата = НачалоДня(ОбщегоНазначения.ТекущаяДатаПользователя());

КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

Функция СуществуютПовторяемыеДокументы()
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос;

	Запрос.УстановитьПараметр("ДатаНачалаПериода", 			НачалоМесяца(ПериодРегистрации));
	Запрос.УстановитьПараметр("Организация",  				Организация);
	Запрос.УстановитьПараметр("Ссылка",		  				Ссылка);
	
	Запрос.Текст = "ВЫБРАТЬ
	|	ДанныеДокумента.Ссылка,
	|	ДанныеДокумента.Представление КАК ПредставлениеДокумента,
	|	ДанныеДокумента.Дата
	|ИЗ
	|	Документ.КорректировкаСтоимостиСписанияТоваров КАК ДанныеДокумента
	|ГДЕ
	|	ДанныеДокумента.Организация = &Организация
	|	И НАЧАЛОПЕРИОДА(ДанныеДокумента.ПериодРегистрации, МЕСЯЦ) = &ДатаНачалаПериода
	|	И ДанныеДокумента.Ссылка <> &Ссылка
	|	И ДанныеДокумента.Проведен
	|	И НЕ ДанныеДокумента.ПометкаУдаления";
				
	РезультатЗапроса = Запрос.Выполнить();
		
	Если НЕ РезультатЗапроса.Пустой() Тогда
		ТекстСообщения = НСтр("ru = 'Операция уже выполнена в документах:'");
		
		Выборка = РезультатЗапроса.Выбрать();
		Пока Выборка.Следующий() Цикл
			ТекстСообщения = ТекстСообщения + "
					|   " + СокрЛП(Выборка.ПредставлениеДокумента);
		КонецЦикла; 		
		
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, ЭтотОбъект);	
		Возврат Истина;		
	КонецЕсли;	
	
	Возврат Ложь;
	
Конецфункции

#КонецЕсли