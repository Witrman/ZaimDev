﻿////////////////////////////////////////////////////////////////////////////////
// ПроведениеСервер:
//  
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

// Функция формирует массив имен регистров, по которым документ имеет движения.
// Вызывается при подготовке записей к регистрации движений.
//
Функция ПолучитьМассивИспользуемыхРегистров(Регистратор, Движения, МассивИсключаемыхРегистров = Неопределено) Экспорт

	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Регистратор", Регистратор);

	Результат = Новый Массив;
	МаксимумТаблицВЗапросе = 256;

	СчетчикТаблиц   = 0;
	СчетчикДвижений = 0;

	ВсегоДвижений = Движения.Количество();
	ТекстЗапроса  = "";
	Для Каждого Движение Из Движения Цикл

		СчетчикДвижений = СчетчикДвижений + 1;

		ПропуститьРегистр = МассивИсключаемыхРегистров <> Неопределено
							И МассивИсключаемыхРегистров.Найти(Движение.Имя) <> Неопределено;

		Если Не ПропуститьРегистр Тогда

			Если СчетчикТаблиц > 0 Тогда

				ТекстЗапроса = ТекстЗапроса + "
				|ОБЪЕДИНИТЬ ВСЕ
				|";

			КонецЕсли;

			СчетчикТаблиц = СчетчикТаблиц + 1;

			ТекстЗапроса = ТекстЗапроса + 
			"
			|ВЫБРАТЬ ПЕРВЫЕ 1
			|""" + Движение.Имя + """ КАК ИмяРегистра
			|
			|ИЗ " + Движение.ПолноеИмя() + "
			|
			|ГДЕ Регистратор = &Регистратор
			|";

		КонецЕсли;

		Если (СчетчикТаблиц = МаксимумТаблицВЗапросе Или СчетчикДвижений = ВсегоДвижений) И ТекстЗапроса <> "" Тогда

			Запрос.Текст  = ТекстЗапроса;
			ТекстЗапроса  = "";
			СчетчикТаблиц = 0;

			Если Результат.Количество() = 0 Тогда

				Результат = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("ИмяРегистра");

			Иначе

				Выборка = Запрос.Выполнить().Выбрать();
				Пока Выборка.Следующий() Цикл
					Результат.Добавить(Выборка.ИмяРегистра);
				КонецЦикла;

			КонецЕсли;
		КонецЕсли;
	КонецЦикла;

	Возврат Результат;

КонецФункции

// Процедура выполняет подготовку наборов записей документа к проведению документа.
// 1. Очищает наборы записей от "старых записей" (ситуация возможна только в толстом клиенте)
// 2. Взводит флаг записи у наборов, по которым документ имел движения при прошлом проведении
// 3. Устанавливает активность наборам записей документов с установленным флагом ручной корректировки
// 4. Записывает пустые наборы, если дата ранее проведенного документа была сдвинута вперед
// Вызывается из модуля документа при проведении.
//
Процедура ПодготовитьНаборыЗаписейКПроведению(Объект, ВыборочноОчищатьРегистры = Истина) Экспорт
	
	Для каждого НаборЗаписей Из Объект.Движения Цикл
		Если НаборЗаписей.Количество() > 0 Тогда
			НаборЗаписей.Очистить();
		КонецЕсли;
	КонецЦикла;

	МетаданныеОбъекта = Объект.Метаданные();
	
	// Регистры, требующие принудительной очистки:
	МассивИменРегистровПринудительнойОчистки = Новый Массив;
	МассивДвиженийДляПринудительнойОчистки = Новый Массив;
	
	МассивИменРегистров = ПолучитьМассивИспользуемыхРегистров(
		Объект.Ссылка, 
		МетаданныеОбъекта.Движения);

	Для каждого ИмяРегистра Из МассивИменРегистров Цикл
		Объект.Движения[ИмяРегистра].Записывать = Истина;
		Если МассивИменРегистровПринудительнойОчистки.Найти(ИмяРегистра) <> Неопределено
			ИЛИ НЕ ВыборочноОчищатьРегистры Тогда
			МассивДвиженийДляПринудительнойОчистки.Добавить(Объект.Движения[ИмяРегистра]);
		КонецЕсли; 
	КонецЦикла;
	
	РучнаяКорректировка = МетаданныеОбъекта.Реквизиты.Найти("РучнаяКорректировка") <> Неопределено
		И Объект.РучнаяКорректировка;
	
	Если РучнаяКорректировка Тогда
		
		Для Каждого ИмяРегистра Из МассивИменРегистров Цикл
			Объект.Движения[ИмяРегистра].Прочитать();
			Объект.Движения[ИмяРегистра].УстановитьАктивность(Истина);
		КонецЦикла;
		
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Движения документа %1 отредактированы вручную и не могут быть автоматически актуализированы'"), Объект);
		
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, Объект.Ссылка);
	Иначе
		
		Для Каждого НаборЗаписей Из МассивДвиженийДляПринудительнойОчистки Цикл
			НаборЗаписей.Записать();
			НаборЗаписей.Записывать = Ложь;
		КонецЦикла; 
		
		Объект.Движения.Записать();
		
	КонецЕсли;

КонецПроцедуры

// Процедура выполняет подготовку наборов записей документа к отмене проведения документа.
// 1. Взводит флаг записи у наборов, по которым документ имел движения при прошлом проведении
// 2. Снимает активность у наборов записей документов с установленным флагом ручной корректировки
// Вызывается из модуля документа при отмене проведения.
//
Процедура ПодготовитьНаборыЗаписейКОтменеПроведения(Объект) Экспорт
	
	МетаданныеОбъекта = Объект.Метаданные();
	
	МассивИменРегистров = ПолучитьМассивИспользуемыхРегистров(
		Объект.Ссылка, 
		МетаданныеОбъекта.Движения);

	Для каждого ИмяРегистра Из МассивИменРегистров Цикл
		Объект.Движения[ИмяРегистра].Записывать = Истина;
	КонецЦикла;
	
	РучнаяКорректировка = МетаданныеОбъекта.Реквизиты.Найти("РучнаяКорректировка") <> Неопределено
		И Объект.РучнаяКорректировка;
	
	Если РучнаяКорректировка Тогда
		Для каждого ИмяРегистра Из МассивИменРегистров Цикл
			Объект.Движения[ИмяРегистра].Прочитать();
			Объект.Движения[ИмяРегистра].УстановитьАктивность(Ложь);
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

//////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ БЗК

// Очищает записи наборов из коллекции Движения и проставляет флаг Записывать наборам, по которым 
// документ уже имеет движения
// 
//	Параметры:
//		Объект - документ
//		ЭтоНовый - признак того, что пишется новый документ
//		ДвиженияМетаданные - свойство метаданных Движения
Процедура ПодготовитьНаборыЗаписейКРегистрацииДвижений(Объект, ЭтоНовый = Ложь, ДвиженияМетаданные = НеОпределено) Экспорт
	
	Для Каждого НаборЗаписей Из Объект.Движения Цикл
		Если НаборЗаписей.Количество() > 0 Тогда
			НаборЗаписей.Очистить();
		КонецЕсли;
	КонецЦикла;
	
	Если НЕ ЭтоНовый Тогда
		МассивИменРегистров = ПолучитьМассивИспользуемыхРегистров(Объект.Ссылка, Объект.Метаданные().Движения);
		Для Каждого ИмяРегистра Из МассивИменРегистров Цикл
			Объект.Движения[ИмяРегистра].Записывать = Истина;
		КонецЦикла;
	КонецЕсли;
		
КонецПроцедуры

//////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ УДАЛЕНИЯ ДВИЖЕНИЙ

//Процедура выполняет удаление движений документа по регистрам при отмене проведения
//	Является обработчиком подписки на событие "ОбработкаУдаленияПроведенияДокумента"
//
Процедура ОбработкаУдаленияПроведенияДокумента(Источник, Отказ) Экспорт
	
	УдалитьДвиженияРегистратора(Источник, Отказ);
	
КонецПроцедуры

// Процедура удаления движений документа при перепроведении (отмене проведения)
//
// Параметры:
//	ДокументОбъект 				- документ, движения которого удаляются
//	Отказ 						- булево, признак отказа
//	ВыборочноОчищатьРегистры 	- булево, признак выборочной очистки наборов записей 
//								Если Истина - часть наборов записей не будут очищены, будут очищены только коллекции движений
//	РежимПроведенияДокумента 	- режим проведения (оперативный / неоперативный), 
//								нужен для составления списка регистров, которые не надо очищать
//	Для документа ПринятиеКУчетуОС предусмотрена отдельная процедура УдалитьДвиженияПринятиеКУчетуОС
Процедура УдалитьДвиженияРегистратора(ДокументОбъект, Отказ, ВыборочноОчищатьРегистры = Ложь, РежимПроведенияДокумента = Неопределено) Экспорт
	
	// Удалим те движения, которые уже записаны
	УдалитьЗаписанныеДвиженияДокумента(ДокументОбъект, Отказ, ВыборочноОчищатьРегистры, РежимПроведенияДокумента);
			
КонецПроцедуры

// Возвращает перечень регистров, которые требуется очистить
//
Функция МассивРегистровНужноОчистить(ДокументОбъект) Экспорт
	
	МассивРегистров = Новый Массив();
	
	Для Каждого Движение ИЗ ДокументОбъект.Метаданные().Движения Цикл
		МассивРегистров.Добавить(Движение.ПолноеИмя());
	КонецЦикла; 
	
	Возврат МассивРегистров;
	
КонецФункции

Процедура ЗаписатьНаборЗаписейНаСервере(ИмяРегистра, Регистратор, ТаблицаДвижений = Неопределено, ТипРегистра = "РегистрНакопления") Экспорт	
	
	Если ТипРегистра = "РегистрНакопления" Тогда
		Набор = РегистрыНакопления[ИмяРегистра].СоздатьНаборЗаписей();
		
		Если ТаблицаДвижений <> Неопределено Тогда
			Набор.мТаблицаДвижений = ТаблицаДвижений;
			//ОбщегоНазначения.ВыполнитьДвижениеПоРегистру(Набор);		
			ВыполнитьДвижениеПоРегистру(Набор);		
			
		КонецЕсли;
		
	Иначе
		Если ТипРегистра = "РегистрБухгалтерии" Тогда
			Набор = РегистрыБухгалтерии[ИмяРегистра].СоздатьНаборЗаписей();
		ИначеЕсли ТипРегистра = "РегистрСведений" Тогда
			Набор = РегистрыСведений[ИмяРегистра].СоздатьНаборЗаписей();
		ИначеЕсли ТипРегистра = "РегистрРасчета" Тогда
			Набор = РегистрыРасчета[ИмяРегистра].СоздатьНаборЗаписей();
		КонецЕсли; 
		
		Если ТаблицаДвижений <> Неопределено Тогда
			Набор.Загрузить(ТаблицаДвижений);
		КонецЕсли;
	КонецЕсли; 
	
	Набор.Отбор.Регистратор.Установить(Регистратор);

	Попытка
		Набор.Записать();
	Исключение
		//ОбщегоНазначения.СообщитьОбОшибке(ОписаниеОшибки());
	КонецПопытки;
КонецПроцедуры

// Выполняет движение по регистру.
//
// Параметры:
//  НаборДвижений               - набор движений регистра,
//  ПустыеКолонкиСоставногоТипа - структура, содержащая имена измерений,ресурсов и
//  реквизитов составного типа, которые могут содержать пустые ссылки.
//
Процедура ВыполнитьДвижениеПоРегистру(НаборДвижений, ВидДвижения = Неопределено,
	                                  ПустыеКолонкиСоставногоТипа = Неопределено) Экспорт

	ТаблицаДвижений = НаборДвижений.мТаблицаДвижений;
	Если ТаблицаДвижений.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	Если ПустыеКолонкиСоставногоТипа = Неопределено Тогда
		ПустыеКолонкиСоставногоТипа = Новый Структура;
	КонецЕсли;
	
	//
	КолонкиТаблицы = ТаблицаДвижений.Колонки;
	
	//
	МетаРег = НаборДвижений.Метаданные();
	ИзмеренияСостТипа = Новый Структура;
	ИзмеренияСостТипаСтр = "";
	Для Каждого МетаИзм Из МетаРег.Измерения Цикл
		Если (МетаИзм.Тип.Типы().Количество() > 1)
		   И НЕ (ПустыеКолонкиСоставногоТипа.Свойство(МетаИзм.Имя)) Тогда
			Если не КолонкиТаблицы.Найти(МетаИзм.Имя)=Неопределено Тогда
				ИзмеренияСостТипа.Вставить(МетаИзм.Имя);
				ИзмеренияСостТипаСтр = ИзмеренияСостТипаСтр + ", " + МетаИзм.Имя;
			КонецЕсли; 
		КонецЕсли;
	КонецЦикла;
	Для Каждого МетаРек Из МетаРег.Реквизиты Цикл
		Если (МетаРек.Тип.Типы().Количество() > 1)
		   И НЕ (ПустыеКолонкиСоставногоТипа.Свойство(МетаРек.Имя)) Тогда
			Если не КолонкиТаблицы.Найти(МетаРек.Имя)=Неопределено Тогда
				ИзмеренияСостТипа.Вставить(МетаРек.Имя);
				ИзмеренияСостТипаСтр = ИзмеренияСостТипаСтр + ", " + МетаРек.Имя;
			КонецЕсли; 
			
		КонецЕсли;
	КонецЦикла;
	Для Каждого МетаРес Из МетаРег.Ресурсы Цикл
		Если (МетаРес.Тип.Типы().Количество() > 1)
		   И НЕ (ПустыеКолонкиСоставногоТипа.Свойство(МетаРес.Имя)) Тогда
			Если не КолонкиТаблицы.Найти(МетаРес.Имя)=Неопределено Тогда
				ИзмеренияСостТипа.Вставить(МетаРес.Имя);
				ИзмеренияСостТипаСтр = ИзмеренияСостТипаСтр + ", " + МетаРес.Имя;
			КонецЕсли; 
		КонецЕсли;
	КонецЦикла;
	
	Если ИзмеренияСостТипаСтр <> "" Тогда
		ИзмеренияСостТипаСтр = Сред(ИзмеренияСостТипаСтр, 3);
	КонецЕсли;
	
	ТипЧисло = Тип("Число");
	ТипСтрока = Тип("Строка");
	ТипДата = Тип("Дата");
	
	ЕстьПериод = НЕ ТаблицаДвижений.Колонки.Найти("Период") = Неопределено;

	Для Каждого СтрокаДвижения ИЗ ТаблицаДвижений Цикл
		Движение = НаборДвижений.Добавить();
		ЗаполнитьЗначенияСвойств(Движение, СтрокаДвижения, ,ИзмеренияСостТипаСтр);
		
		Если ВидДвижения <> Неопределено Тогда
			Движение.ВидДвижения = ВидДвижения;
		КонецЕсли;
		
		Если ЕстьПериод И НЕ СтрокаДвижения.Период = '00010101000000' Тогда
			Движение.Период = СтрокаДвижения.Период;
		Иначе
			Движение.Период = НаборДвижений.мПериод;
		КонецЕсли; 
		Движение.Активность = Истина;
		
		Для Каждого КлючИЗначение ИЗ ИзмеренияСостТипа Цикл
			ЗначениеВКолонке = СтрокаДвижения[КлючИЗначение.Ключ];
			
			Если ЗначениеВКолонке = Неопределено Тогда
				Продолжить;
			КонецЕсли;
			
			ТипЗначенияВКолонке = ТипЗнч(ЗначениеВКолонке);
			
			Если ТипЗначенияВКолонке = ТипЧисло Тогда
				Если ЗначениеВКолонке = 0 Тогда
					Продолжить;
				КонецЕсли;
			ИначеЕсли ТипЗначенияВКолонке = ТипСтрока Тогда
				Если ЗначениеВКолонке = "" Тогда
					Продолжить;
				КонецЕсли;
			ИначеЕсли ТипЗначенияВКолонке = ТипДата Тогда
				Если ЗначениеВКолонке = '00010101000000' Тогда
					Продолжить;
				КонецЕсли;
			ИначеЕсли ЗначениеВКолонке.Пустая() Тогда
				Продолжить;
			КонецЕсли;
			
			Движение[КлючИЗначение.Ключ] = ЗначениеВКолонке;
			
		КонецЦикла;
		
	КонецЦикла;

КонецПроцедуры // ВыполнитьДвижениеПоРегистру()

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

//////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ УДАЛЕНИЯ ДВИЖЕНИЙ

// Процедура очистки записанных движений документа
//
// Параметры:
//	ДокументОбъект 				- документ, движения которого удаляются
//	Отказ 						- булево, признак отказа
//	ВыборочноОчищатьРегистры 	- булево, признак выборочной очистки наборов записей 
//								Если Истина - часть наборов записей не будут очищены, будут очищены только коллекции движений
//	РежимПроведенияДокумента 	- режим проведения (оперативный / неоперативный), 
//								нужен для составления списка регистров, которые не надо очищать
Процедура УдалитьЗаписанныеДвиженияДокумента(ДокументОбъект, Отказ, ВыборочноОчищатьРегистры, РежимПроведенияДокумента)
	
	// Получим перечень регистров, движения по которым нужно очистить
	МассивРегистров = МассивРегистровНужноОчистить(ДокументОбъект);
	
	Если МассивРегистров.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	//Обойдем список регистров, по которым существуют движения, и выполним очистку необходимых регистров
	Для Каждого ПолноеИмяРегистра ИЗ МассивРегистров Цикл
		
		// Имя регистра передается как значение, 
		// полученное с помощью функции ПолноеИмя() метаданных регистра
		ПозицияТочки = Найти(ПолноеИмяРегистра, ".");
		ТипРегистра = Лев(ПолноеИмяРегистра, ПозицияТочки - 1);
		ИмяРегистра = СокрП(Сред(ПолноеИмяРегистра, ПозицияТочки + 1));
		
		// Удаление движений происходит без контроля доступа - передаем пустую таблицу движений
		//ПолныеПрава.ЗаписатьНаборЗаписейНаСервере(ИмяРегистра, ДокументОбъект.Ссылка,, ТипРегистра);
		ЗаписатьНаборЗаписейНаСервере(ИмяРегистра, ДокументОбъект.Ссылка,, ТипРегистра);
		
	КонецЦикла;	
	
КонецПроцедуры

