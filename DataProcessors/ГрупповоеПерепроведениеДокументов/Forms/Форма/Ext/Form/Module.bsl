﻿&НаКлиенте
Перем ПараметрыОбработчикаОжидания;

&НаКлиенте
Перем ФормаДлительнойОперации;


////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ПодготовитьФормуНаСервере();
	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

&НаКлиенте
Процедура ТолькоВыбранныеОрганизацииПриИзменении(Элемент)
	
	Элементы.ТаблицаОрганизаций.Доступность = ТолькоВыбранныеОрганизации;
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ТАБЛИЦЫ ФОРМЫ <ИМЯ ТАБЛИЦЫ ФОРМЫ>

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура КнопкаВыполнить(Команда)
	
	ОчиститьСообщения();
	
	Если ТолькоВыбранныеОрганизации <> 0 И НЕ ЗначениеЗаполнено(ТаблицаОрганизаций) Тогда
		ТекстСообщения = ОбщегоНазначенияБККлиентСервер.ПолучитьТекстСообщения("Список", , , , НСтр("ru = 'Список организаций'"));
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения);
		Возврат;
	КонецЕсли;
	
	ИнициализацияКомандДокументаНаКлиенте();
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьПериод(Команда)
	
	ПараметрыВыбора = Новый Структура("НачалоПериода, КонецПериода", Объект.ДатаНачала, Объект.ДатаОкончания);
	ОписаниеОповещения = Новый ОписаниеОповещения("ВыбратьПериодЗавершение", ЭтаФорма);
	ОткрытьФорму("ОбщаяФорма.ВыборСтандартногоПериода", ПараметрыВыбора, Элементы.ВыбратьПериод, , , , ОписаниеОповещения);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаСервере
Процедура ПодготовитьФормуНаСервере()
	
	Если НЕ ЗначениеЗаполнено(Объект.ДатаНачала) И НЕ ЗначениеЗаполнено(Объект.ДатаОкончания) Тогда
		РабочаяДатаПриложения = ОбщегоНазначения.ТекущаяДатаПользователя();
		Если День(РабочаяДатаПриложения) < 25 Тогда
			Объект.ДатаНачала    = НачалоМесяца(НачалоМесяца(РабочаяДатаПриложения) - 1);
			Объект.ДатаОкончания = КонецМесяца(Объект.ДатаНачала);
		Иначе
			Объект.ДатаНачала    = НачалоМесяца(РабочаяДатаПриложения);
			Объект.ДатаОкончания = КонецМесяца(Объект.ДатаНачала);
		КонецЕсли; 
	КонецЕсли;
	
	Элементы.ТаблицаОрганизаций.Доступность = ТолькоВыбранныеОрганизации;
	
	ПроведеноДокументов = 0;
	НеУдалосьПровести   = 0;
	
КонецПроцедуры
 

&НаСервереБезКонтекста
Функция ЗаданиеВыполнено(ИдентификаторЗадания)
	
	Возврат ДлительныеОперации.ЗаданиеВыполнено(ИдентификаторЗадания);
	
КонецФункции

&НаКлиенте
Процедура ПоказатьРезультатПерепроведения()
	
	ТекстСообщения = НСтр("ru='Выполнено перепроведение документов:
	| - проведено документов: %1;
	|%2'");
	Если НеУдалосьПровести = 0 Тогда
		ТекстСообщенияОбОбшибках = НСтр("ru=' - ошибок не обнаружено.'");
	Иначе
		ТекстСообщенияОбОбшибках = НСтр("ru=' - не удалось провести документов: %1'");
		ТекстСообщенияОбОбшибках = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			ТекстСообщенияОбОбшибках, НеУдалосьПровести);
	КонецЕсли;
	ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		ТекстСообщения, ПроведеноДокументов, ТекстСообщенияОбОбшибках);
		
	ПоказатьПредупреждение(,ТекстСообщения);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПроверитьВыполнениеЗадания()

	Попытка
		Если ФормаДлительнойОперации.Открыта() 
			И ФормаДлительнойОперации.ИдентификаторЗадания = ИдентификаторЗадания Тогда			
			Если ЗаданиеВыполнено(ИдентификаторЗадания) Тогда
				ЗагрузитьПодготовленныеДанныеНаСервере();
				ДлительныеОперацииКлиент.ЗакрытьФормуДлительнойОперации(ФормаДлительнойОперации);
				ПоказатьРезультатПерепроведения();
			Иначе
				ДлительныеОперацииКлиент.ОбновитьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
				ПодключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеЗадания",
					ПараметрыОбработчикаОжидания.ТекущийИнтервал, Истина);
			КонецЕсли;
		Иначе
			// Задание отменено
			ИдентификаторЗадания = Неопределено;
		КонецЕсли;
	Исключение
		ДлительныеОперацииКлиент.ЗакрытьФормуДлительнойОперации(ФормаДлительнойОперации);
		ВызватьИсключение;
	КонецПопытки;

КонецПроцедуры

&НаКлиенте
Процедура ИнициализацияКомандДокументаНаКлиенте()
	
	Результат = ВыполнитьНаСервере();
	
	Если Результат = 1 Тогда
		ПоказатьПредупреждение(,НСтр("ru = 'Перепроведение уже выполняется. Ожидайте завершения.'"));
		Возврат;
	ИначеЕсли Результат = 2 Тогда
		ПоказатьПредупреждение(,НСтр("ru = 'Перепроведение уже выполняется другим пользователем.'"));
		Возврат;
	КонецЕсли;
	
	Если НЕ Результат.ЗаданиеВыполнено Тогда
		ДлительныеОперацииКлиент.ИнициализироватьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
		ПодключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеЗадания", 1, Истина);
		ФормаДлительнойОперации = ДлительныеОперацииКлиент.ОткрытьФормуДлительнойОперации(ЭтаФорма, ИдентификаторЗадания);
	Иначе
		ПоказатьРезультатПерепроведения();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьПодготовленныеДанныеНаСервере()

	СтруктураДанных = ПолучитьИзВременногоХранилища(АдресХранилища);
	Если ТипЗнч(СтруктураДанных) <> Тип("Структура") Тогда
		Возврат;
	КонецЕсли;

	Если СтруктураДанных.Свойство("ПроведеноДокументов") Тогда
		ПроведеноДокументов = СтруктураДанных.ПроведеноДокументов;
	КонецЕсли;
	Если СтруктураДанных.Свойство("НеУдалосьПровести") Тогда
		НеУдалосьПровести = СтруктураДанных.НеУдалосьПровести;
	КонецЕсли;
	
    ПоказатьСообщенияПользователю();
	
	ИдентификаторЗадания = Неопределено;
	РазблокироватьДанныеДляРедактирования(, УникальныйИдентификатор);

КонецПроцедуры

&НаСервере
Функция ВыполнитьНаСервере()
	
	Если ЗначениеЗаполнено(ИдентификаторЗадания) 
		И Не ДлительныеОперации.ЗаданиеВыполнено(ИдентификаторЗадания) Тогда
		Возврат 1;
	КонецЕсли;
	
	Если ТолькоВыбранныеОрганизации = 0 Тогда
		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	Организации.Ссылка КАК Организация
		|ИЗ
		|	Справочник.Организации КАК Организации";
		Выборка = Запрос.Выполнить().Выбрать();
		Пока Выборка.Следующий() Цикл
			Попытка
				ЗаблокироватьДанныеДляРедактирования(Выборка.Организация,, УникальныйИдентификатор);
			Исключение
				РазблокироватьДанныеДляРедактирования(, УникальныйИдентификатор);
				Возврат 2;
			КонецПопытки;
		КонецЦикла;
	Иначе
		ВыбранныеОрганизации = Новый Массив;
		Для Каждого ЭлементСпискаОрганизаций Из ТаблицаОрганизаций Цикл
			Если ЗначениеЗаполнено(ЭлементСпискаОрганизаций.Организация) Тогда
				ВыбранныеОрганизации.Добавить(ЭлементСпискаОрганизаций.Организация);
				
				Попытка
					ЗаблокироватьДанныеДляРедактирования(ЭлементСпискаОрганизаций.Организация,, УникальныйИдентификатор);
				Исключение
					РазблокироватьДанныеДляРедактирования(, УникальныйИдентификатор);
					Возврат 2;
				КонецПопытки;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	СтруктураПараметров = Новый Структура("Организация, ДатаНачала, ДатаОкончания, ЗаписыватьОшибкиВЖурналРегистрации, ОстанавливатьсяПоОшибке",
		?(ТолькоВыбранныеОрганизации = 0, Неопределено, ВыбранныеОрганизации),
		?(ЗначениеЗаполнено(Объект.ДатаНачала), Объект.ДатаНачала, Неопределено),
		?(ЗначениеЗаполнено(Объект.ДатаОкончания), Объект.ДатаОкончания, Неопределено),
		Истина,
		Объект.ОстанавливатьсяПоОшибке);
	
	Если ОбщегоНазначения.ИнформационнаяБазаФайловая() Тогда
		АдресХранилища = ПоместитьВоВременноеХранилище(Неопределено, УникальныйИдентификатор);
		Обработки.ГрупповоеПерепроведениеДокументов.ПерепроведениеДокументов(СтруктураПараметров, АдресХранилища);
		Результат = Новый Структура("ЗаданиеВыполнено", Истина);

	Иначе
		НаименованиеЗадания = НСтр("ru = 'Групповое перепроведение документов'");
		Результат = ДлительныеОперации.ЗапуститьВыполнениеВФоне(
			УникальныйИдентификатор,
			"Обработки.ГрупповоеПерепроведениеДокументов.ПерепроведениеДокументов",
			СтруктураПараметров,
			НаименованиеЗадания);

		АдресХранилища       = Результат.АдресХранилища;
		ИдентификаторЗадания = Результат.ИдентификаторЗадания;
	КонецЕсли;
	
	Если Результат.ЗаданиеВыполнено Тогда
		ЗагрузитьПодготовленныеДанныеНаСервере();
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма)

	Объект   = Форма.Объект;
	Элементы = Форма.Элементы;
	
КонецПроцедуры

&НаСервере
Процедура ПоказатьСообщенияПользователю()
	
	Если ОбщегоНазначения.ИнформационнаяБазаФайловая() Тогда
		Возврат;
	КонецЕсли;
	
	ФоновоеЗадание = ФоновыеЗадания.НайтиПоУникальномуИдентификатору(ИдентификаторЗадания);
	Если ФоновоеЗадание <> Неопределено Тогда
		МассивСообщений = ФоновоеЗадание.ПолучитьСообщенияПользователю(Истина);
		Если МассивСообщений <> Неопределено Тогда
			Для Каждого Сообщение Из МассивСообщений Цикл
				Сообщение.ИдентификаторНазначения = УникальныйИдентификатор;
				Сообщение.Сообщить();
			КонецЦикла;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьПериодЗавершение(РезультатВыбора, ДопПараметры) Экспорт
	
	Если РезультатВыбора = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Объект.ДатаНачала	 = РезультатВыбора.НачалоПериода;
	Объект.ДатаОкончания = РезультатВыбора.КонецПериода;
	
КонецПроцедуры

