﻿////////////////////////////////////////////////////////////////////////////////
// ПроцедурыБухгалтерскогоУчетаКлиентСервер: 
//  
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

// Процедура установки типа и видимости субконто в зависимости от выбранного счета
//
// Параметры:
//	Счет			 - <План счетов> - Счет, для которого необходимо настроить тип и видимость субконто
//	Форма			 - <Управляемая форма> - Форма, которая содержит ПоляФормы и ЗаголовкиПолей
//	ПоляФормы		 - <Структура> - Ключи, которой Субконто1, Субконто2, Субконто3, 
//									 а значения имена соответствующих полей на форме (поля субконто)
//	ЗаголовкиПолей	 - <Структура> ИЛИ <Неопределено> - Ключи, которой Субконто1, Субконто2, Субконто3
//									 а значения имена соответствующих полей на форме (заголовки субконто)
//	ЭтоТаблица		 - <Булево>		 - Признак того, где выполняется настройка субконто. 
//	СкрыватьСубконто - <Булево>		 - Признак того, нужно ли для этой формы дополнительно скрывать субконто, влияет на выполнении функции НужноСкрытьСубконто
//
Процедура ПриВыбореСчета(Счет, Форма, ПоляФормы, ЗаголовкиПолей = Неопределено, ЭтоТаблица = Ложь, СкрыватьСубконто = Истина) Экспорт
	
	ДанныеСчета = ПроцедурыБухгалтерскогоУчетаВызовСервераПовтИсп.ПолучитьСвойстваСчета(Счет);
	
	Для Индекс = 1 По 3 Цикл
		ТипЗначенияСубконто = ДанныеСчета["ВидСубконто" + Индекс + "ТипЗначения"];
		Если Индекс <= ДанныеСчета.КоличествоСубконто И НЕ НужноСкрытьСубконто(СкрыватьСубконто, ТипЗначенияСубконто) Тогда
			Если ЭтоТаблица Тогда
				Если ПоляФормы.Свойство("Субконто" + Индекс) Тогда
					Форма.Элементы[ПоляФормы["Субконто" + Индекс]].ОграничениеТипа = ТипЗначенияСубконто;
					Форма.Элементы[ПоляФормы["Субконто" + Индекс]].ПодсказкаВвода  = ДанныеСчета["ВидСубконто" + Индекс + "Наименование"];
				КонецЕсли;
			Иначе
				Если ЗаголовкиПолей <> Неопределено И ЗаголовкиПолей.Свойство("Субконто" + Индекс) Тогда
					// Заголовок может быть не выведен на форму
					ЭлементФормыЗаголовок = Форма.Элементы.Найти(ЗаголовкиПолей["Субконто" + Индекс]);
					Если ЭлементФормыЗаголовок <> Неопределено Тогда
						ЭлементФормыЗаголовок.Видимость = Истина;
					КонецЕсли;
					Форма[ЗаголовкиПолей["Субконто" + Индекс]] = ДанныеСчета["ВидСубконто" + Индекс + "Наименование"] + ":";
				КонецЕсли;
				Если ПоляФормы.Свойство("Субконто" + Индекс) Тогда
					Форма.Элементы[ПоляФормы["Субконто" + Индекс]].Видимость       = Истина;
					Форма.Элементы[ПоляФормы["Субконто" + Индекс]].ОграничениеТипа = ТипЗначенияСубконто;
				КонецЕсли;
			КонецЕсли;
		Иначе 
			// Ничего делать не надо, т.к. не доступные поля будут скрыты
			Если НЕ ЭтоТаблица Тогда
				Если ЗаголовкиПолей <> Неопределено И ЗаголовкиПолей.Свойство("Субконто" + Индекс) Тогда
					// Заголовок может быть не выведен на форму
					ЭлементФормыЗаголовок = Форма.Элементы.Найти(ЗаголовкиПолей["Субконто" + Индекс]);
					Если ЭлементФормыЗаголовок <> Неопределено Тогда
						ЭлементФормыЗаголовок.Видимость	 = Ложь;
					КонецЕсли;
					Форма[ЗаголовкиПолей["Субконто" + Индекс]] = "";
				КонецЕсли;
				Если ПоляФормы.Свойство("Субконто" + Индекс) Тогда
					Форма.Элементы[ПоляФормы["Субконто" + Индекс]].Видимость       = Ложь;
					Форма.Элементы[ПоляФормы["Субконто" + Индекс]].ОграничениеТипа = Новый ОписаниеТипов("Неопределено");
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

// Процедура установки типа и доступности субконто объекта в зависимости от выбранного счета
//
Процедура ПриИзмененииСчета(Счет, Объект, ПоляОбъекта, ЭтоТаблица = Ложь, ЗаполнятьЗаголовокСубконто = Истина, ЗначенияСубконто = Неопределено, СкрыватьСубконто = Истина) Экспорт
	
	ДанныеСчета = ПроцедурыБухгалтерскогоУчетаВызовСервераПовтИсп.ПолучитьСвойстваСчета(Счет);
	
	Для Индекс = 1 По 3 Цикл
		Если ПоляОбъекта.Свойство("Субконто" + Индекс) Тогда
			Если Индекс <= ДанныеСчета.КоличествоСубконто Тогда
				ТипЗначенияСубконто = ДанныеСчета["ВидСубконто" + Индекс + "ТипЗначения"];
				ЗначениеСубконто = ТипЗначенияСубконто.ПривестиЗначение(Объект[ПоляОбъекта["Субконто" + Индекс]]);
				ЗначениеСубконтоПоУмолчанию = ?(ЗначенияСубконто = Неопределено, Неопределено, ЗначенияСубконто.Получить(ДанныеСчета["ВидСубконто" + Индекс]));
				
				Если НЕ ЗначениеЗаполнено(ЗначениеСубконто) И НЕ ЗначениеЗаполнено(ЗначениеСубконтоПоУмолчанию) Тогда
					Если ТипЗначенияСубконто.СодержитТип(Тип("СправочникСсылка.НоменклатурныеГруппы"))
						И ПроцедурыБухгалтерскогоУчетаВызовСервераПовтИсп.ИспользоватьОднуНоменклатурнуюГруппу() Тогда
						ЗначениеСубконтоПоУмолчанию = ПроцедурыБухгалтерскогоУчетаВызовСервераПовтИсп.ОсновнаяНоменклатурнаяГруппа();
					КонецЕсли;
					Если ТипЗначенияСубконто.СодержитТип(Тип("СправочникСсылка.Склады"))
						И НЕ ПроцедурыБухгалтерскогоУчетаВызовСервераПовтИсп.ИспользуетсяНесколькоСкладов() Тогда
						ЗначениеСубконтоПоУмолчанию = ПроцедурыБухгалтерскогоУчетаВызовСервераПовтИсп.ПолучитьСкладПоУмолчанию();
					КонецЕсли;
				КонецЕсли;
				
				Если ЗначениеЗаполнено(ЗначениеСубконто) Или Не ЗначениеЗаполнено(ЗначениеСубконтоПоУмолчанию) Тогда
					Объект[ПоляОбъекта["Субконто" + Индекс]] = ЗначениеСубконто;
				Иначе
					Объект[ПоляОбъекта["Субконто" + Индекс]] = ЗначениеСубконтоПоУмолчанию;
				КонецЕсли;
				Объект[ПоляОбъекта["Субконто" + Индекс]] = ДанныеСчета["ВидСубконто" + Индекс + "ТипЗначения"].ПривестиЗначение(Объект[ПоляОбъекта["Субконто" + Индекс]]);
			Иначе
				Объект[ПоляОбъекта["Субконто" + Индекс]] = Неопределено;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	Если ЭтоТаблица Тогда
		УстановитьДоступностьИЗаголовкиСубконто(Счет, Объект, ПоляОбъекта, ЗаполнятьЗаголовокСубконто, СкрыватьСубконто);
	КонецЕсли;
	
КонецПроцедуры

// Процедура установки доступности субконто в зависимости от выбранного счета
//	Счет			 - <План счетов> - Счет, для которого необходимо настроить тип и видимость субконто
//	Объект			 - <Управляемая форма> ИЛИ <Строка табличной части> - Объект, который содержит ПоляФормы
//	ПоляОбъекта		 - <Структура> - Ключи, которой Субконто1, Субконто2, Субконто3, 
//									 а значения имена соответствующих полей на форме (поля субконто)
//	ЗаполнятьЗаголовокСубконто - <Булево> - Признак того, что нужно устанавливать заголовок субконто.
//	СкрыватьСубконто - <Булево>		 - Признак того, нужно ли для этой формы дополнительно скрывать субконто, влияет на выполнении функции НужноСкрытьСубконто
//
Процедура УстановитьДоступностьИЗаголовкиСубконто(Счет, Объект, ПоляОбъекта, ЗаполнятьЗаголовокСубконто = Истина, СкрыватьСубконто = Истина) Экспорт
	
	ДанныеСчета = ПроцедурыБухгалтерскогоУчетаВызовСервераПовтИсп.ПолучитьСвойстваСчета(Счет);
	
	Для Индекс = 1 По 3 Цикл
		Если ПоляОбъекта.Свойство("Субконто" + Индекс) Тогда
			ТипЗначенияСубконто = ДанныеСчета["ВидСубконто" + Индекс + "ТипЗначения"];
			Если НужноСкрытьСубконто(СкрыватьСубконто, ТипЗначенияСубконто) Тогда
				Объект[ПоляОбъекта["Субконто" + Индекс] + "Доступность"] = Ложь;
			Иначе
				Объект[ПоляОбъекта["Субконто" + Индекс] + "Доступность"] = (Индекс <= ДанныеСчета.КоличествоСубконто);
			КонецЕсли;
			
			Если ЗаполнятьЗаголовокСубконто Тогда
				Объект["Вид" + ПоляОбъекта["Субконто" + Индекс]] = ДанныеСчета["ВидСубконто" + Индекс + "Наименование"];
			КонецЕсли;
		Иначе
			Если ЗаполнятьЗаголовокСубконто Тогда
				Объект["Вид" + ПоляОбъекта["Субконто" + Индекс]] = "";
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	Если ПоляОбъекта.Свойство("Валютный") Тогда
		Объект[ПоляОбъекта["Валютный"] + "Доступность"] = ДанныеСчета.Валютный;
	КонецЕсли;
	
	Если ПоляОбъекта.Свойство("Количественный") Тогда
		Объект[ПоляОбъекта["Количественный"] + "Доступность"] = ДанныеСчета.Количественный;
	КонецЕсли;
	
КонецПроцедуры

// Процедура установки доступности субконто в зависимости от выбранного счета
//
Процедура УстановитьДоступностьСубконто(Счет, Объект, ПоляОбъекта, СкрыватьСубконто = Истина) Экспорт
	
	ДанныеСчета = ПроцедурыБухгалтерскогоУчетаВызовСервераПовтИсп.ПолучитьСвойстваСчета(Счет);
	
	Для Индекс = 1 По 3 Цикл
		Если ПоляОбъекта.Свойство("Субконто" + Индекс) Тогда
			ТипЗначенияСубконто = ДанныеСчета["ВидСубконто" + Индекс + "ТипЗначения"];
			Если НужноСкрытьСубконто(СкрыватьСубконто, ТипЗначенияСубконто) Тогда
				Объект[ПоляОбъекта["Субконто" + Индекс] + "Доступность"] = Ложь;
			Иначе
				Объект[ПоляОбъекта["Субконто" + Индекс] + "Доступность"] = (Индекс <= ДанныеСчета.КоличествоСубконто);
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	Если ПоляОбъекта.Свойство("Валютный") Тогда
		Объект[ПоляОбъекта["Валютный"] + "Доступность"] = ДанныеСчета.Валютный;
	КонецЕсли;
	
	Если ПоляОбъекта.Свойство("Количественный") Тогда
		Объект[ПоляОбъекта["Количественный"] + "Доступность"] = ДанныеСчета.Количественный;
	КонецЕсли;
	
КонецПроцедуры

Процедура ИзменитьПараметрыВыбораПолейСубконто(Форма, Объект, ШаблонИмяПоляОбъекта, ШаблонИмяЭлементаФормы, СписокПараметров, ЗаменаСубконтоНУ = Ложь) Экспорт
	
	ОчищатьСвязанныеСубконто 	= Ложь;
	ТипыСвязанныхСубконто 		= Неопределено;
	Если ТипЗнч(Форма.ТекущийЭлемент) = Тип("ТаблицаФормы") Тогда
		ТекущийЭлемент = Форма.ТекущийЭлемент.ТекущийЭлемент;
	Иначе
		ТекущийЭлемент = Форма.ТекущийЭлемент;
	КонецЕсли;
	ИмяТекущегоЭлемента = ?(ТипЗнч(ТекущийЭлемент) = Тип("ПолеФормы"), ТекущийЭлемент.Имя, "");
	
	Если ЗаменаСубконтоНУ Тогда
		Если СтрНайти(ИмяТекущегоЭлемента, "БУ") > 0 Тогда
			ИмяТекущегоЭлемента = СтрЗаменить(ИмяТекущегоЭлемента,"БУ","НУ");
		Иначе
			Если СтрНайти(ИмяТекущегоЭлемента, "Дт") > 0 Тогда
				ИмяТекущегоЭлемента = Лев(ИмяТекущегоЭлемента, СтрНайти(ИмяТекущегоЭлемента, "Дт") + 1) + "НУ" + Прав(ИмяТекущегоЭлемента, СтрДлина(ИмяТекущегоЭлемента) - СтрНайти(ИмяТекущегоЭлемента, "Дт") - 1);
			ИначеЕсли СтрНайти(ИмяТекущегоЭлемента, "Кт") > 0 Тогда
				ИмяТекущегоЭлемента = Лев(ИмяТекущегоЭлемента, СтрНайти(ИмяТекущегоЭлемента, "Кт") + 1) + "НУ" + Прав(ИмяТекущегоЭлемента, СтрДлина(ИмяТекущегоЭлемента) - СтрНайти(ИмяТекущегоЭлемента, "Кт") - 1);
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
		
	Для Индекс = 1 По 3 Цикл
		МассивПараметров = Новый Массив();
		ИмяПоляОбъекта   = СтрЗаменить(ШаблонИмяПоляОбъекта  , "%Индекс%", Индекс);
		ИмяЭлементаФормы = СтрЗаменить(ШаблонИмяЭлементаФормы, "%Индекс%", Индекс);
		ТипПоляОбъекта   = ТипЗнч(Объект[ИмяПоляОбъекта]);
		Если ТипЗнч(Объект[ИмяПоляОбъекта]) = Тип("СправочникСсылка.БанковскиеСчета") Тогда
			
			Если СписокПараметров.Свойство("Организация") И ЗначениеЗаполнено(СписокПараметров.Организация) Тогда
				МассивПараметров.Добавить(Новый ПараметрВыбора("Отбор.Владелец", СписокПараметров.Организация));
			КонецЕсли;
			
			Если СписокПараметров.Свойство("ВалютаДенежныхСредств") И ЗначениеЗаполнено(СписокПараметров.ВалютаДенежныхСредств) Тогда
				МассивПараметров.Добавить(Новый ПараметрВыбора("Отбор.ВалютаДенежныхСредств", СписокПараметров.ВалютаДенежныхСредств));
			КонецЕсли;
			
		ИначеЕсли ТипЗнч(Объект[ИмяПоляОбъекта]) = Тип("СправочникСсылка.Кассы") Тогда
			
			Если СписокПараметров.Свойство("Организация") И ЗначениеЗаполнено(СписокПараметров.Организация) Тогда
				МассивПараметров.Добавить(Новый ПараметрВыбора("Отбор.Владелец", СписокПараметров.Организация));
			КонецЕсли;
			
			Если СписокПараметров.Свойство("ВалютаДенежныхСредств") И ЗначениеЗаполнено(СписокПараметров.ВалютаДенежныхСредств) Тогда
				МассивПараметров.Добавить(Новый ПараметрВыбора("Отбор.ВалютаДенежныхСредств", СписокПараметров.ВалютаДенежныхСредств));
			КонецЕсли;
			
		ИначеЕсли ТипЗнч(Объект[ИмяПоляОбъекта]) = Тип("СправочникСсылка.ПодразделенияОрганизаций") Тогда
			Если СписокПараметров.Свойство("СтруктурноеПодразделение") И ЗначениеЗаполнено(СписокПараметров.СтруктурноеПодразделение) Тогда
				МассивПараметров.Добавить(Новый ПараметрВыбора("Отбор.Ссылка", СписокПараметров.СтруктурноеПодразделение));
			КонецЕсли;
			Если СписокПараметров.Свойство("Организация") И ЗначениеЗаполнено(СписокПараметров.Организация) Тогда
				МассивПараметров.Добавить(Новый ПараметрВыбора("Отбор.Владелец", СписокПараметров.Организация));
			КонецЕсли;
			Если СписокПараметров.Свойство("ВыбиратьПодразделенияОрганизации") Тогда 
				МассивПараметров.Добавить(Новый ПараметрВыбора("ВыбиратьПодразделенияОрганизации", СписокПараметров.ВыбиратьПодразделенияОрганизации));
			КонецЕсли;
			
		ИначеЕсли ТипЗнч(Объект[ИмяПоляОбъекта]) = Тип("СправочникСсылка.ДоговорыКонтрагентов") Тогда
			Если СписокПараметров.Свойство("Организация") И ЗначениеЗаполнено(СписокПараметров.Организация) Тогда
				МассивПараметров.Добавить(Новый ПараметрВыбора("Отбор.Организация", СписокПараметров.Организация));
			КонецЕсли;
			Если СписокПараметров.Свойство("Контрагент") Тогда
				МассивПараметров.Добавить(Новый ПараметрВыбора("Отбор.Владелец", СписокПараметров.Контрагент));
			КонецЕсли;
			
		ИначеЕсли ТипЗнч(Объект[ИмяПоляОбъекта]) = Тип("СправочникСсылка.Субконто") 
			И СписокПараметров.Свойство("СчетУчета") Тогда
			СвойстваСчета = ПроцедурыБухгалтерскогоУчетаВызовСервераПовтИсп.ПолучитьСвойстваСчета(СписокПараметров.СчетУчета);
			МассивПараметров.Добавить(Новый ПараметрВыбора("Отбор.Владелец", СвойстваСчета["ВидСубконто" + Индекс]));
		КонецЕсли;
		
		ПараметрыВыбора = Новый ФиксированныйМассив(МассивПараметров);
		Форма.Элементы[ИмяЭлементаФормы].ПараметрыВыбора = ПараметрыВыбора;
		
		Если ОчищатьСвязанныеСубконто 
			И ЗначениеЗаполнено(Объект[ИмяПоляОбъекта]) Тогда
			
			Если ТипЗнч(Объект[ИмяПоляОбъекта]) = Тип("СправочникСсылка.ДоговорыКонтрагентов") Тогда
				РеквизитыДоговораОрганизация = ОбщегоНазначенияБКВызовСервера.ЗначениеРеквизитаОбъекта(Объект[ИмяПоляОбъекта], "Организация");
				РеквизитыДоговораВладелец    = ОбщегоНазначенияБКВызовСервера.ЗначениеРеквизитаОбъекта(Объект[ИмяПоляОбъекта], "Владелец");
				Если СписокПараметров.Свойство("Организация") И СписокПараметров.Свойство("Контрагент") Тогда
					Если СписокПараметров.Организация = РеквизитыДоговораОрганизация И СписокПараметров.Контрагент = РеквизитыДоговораВладелец Тогда
						ОчищатьСвязанныеСубконто = Ложь;
						Продолжить;
					КонецЕсли;					
				КонецЕсли;
			КонецЕсли; 				

			Если ТипыСвязанныхСубконто = Неопределено Тогда
				ВсеТипыСвязанныхСубконто = ПроцедурыБухгалтерскогоУчетаВызовСервераПовтИсп.ВсеТипыСвязанныхСубконто();
				ТипыСвязанныхСубконто    = Новый ОписаниеТипов(Новый Массив);
				Для каждого Параметр Из СписокПараметров Цикл
					Если ВсеТипыСвязанныхСубконто[Параметр.Ключ] <> Неопределено Тогда
						ТипыСвязанныхСубконто = Новый ОписаниеТипов(ТипыСвязанныхСубконто, 
							ВсеТипыСвязанныхСубконто[Параметр.Ключ].Типы());
					КонецЕсли;
				КонецЦикла;
			КонецЕсли;
			
			Если ТипыСвязанныхСубконто.СодержитТип(ТипПоляОбъекта)	Тогда
				//проверяем, что до него было изменено именно субконто "Организация"
				Если ТипПоляОбъекта = Тип("СправочникСсылка.ПодразделенияОрганизаций") Тогда
					Если Индекс = 1 Тогда
						ИндексПР = 1;
					Иначе
						ИндексПР = Индекс - 1;						
					КонецЕсли;					
					ТипПоляПредшествующего = СтрЗаменить(ШаблонИмяПоляОбъекта  , "%Индекс%", ИндексПР);
					Если ТипПоляПредшествующего = Тип("СправочникСсылка.Организации") Тогда
						Объект[ИмяПоляОбъекта] = Новый (ТипПоляОбъекта);
					КонецЕсли; 					
				Иначе				
					Объект[ИмяПоляОбъекта] = Новый (ТипПоляОбъекта);
				КонецЕсли;
			КонецЕсли;
			
		КонецЕсли;
		
		Если ИмяТекущегоЭлемента = ИмяЭлементаФормы Тогда
			ОчищатьСвязанныеСубконто = Истина; // Очищаются только субконто с номером больше текущего
		КонецЕсли;
		
	КонецЦикла;

КонецПроцедуры

Процедура ИзменитьПараметрыВыбораПолейСубконтоПослеЗаменыСубконтоНУ(Форма, Объект, ШаблонИмяПоляОбъекта, ШаблонИмяЭлементаФормы, СписокПараметров) Экспорт
	
	ОчищатьСвязанныеСубконто 	= Ложь;
	ТипыСвязанныхСубконто 		= Неопределено;
	Если ТипЗнч(Форма.ТекущийЭлемент) = Тип("ТаблицаФормы") Тогда
		ТекущийЭлемент = Форма.ТекущийЭлемент.ТекущийЭлемент;
	Иначе
		ТекущийЭлемент = Форма.ТекущийЭлемент;
	КонецЕсли;
	ИмяТекущегоЭлемента = ?(ТипЗнч(ТекущийЭлемент) = Тип("ПолеФормы"), ТекущийЭлемент.Имя, "");
	
	
	Для Индекс = 1 По 3 Цикл
		МассивПараметров = Новый Массив();
		ИмяПоляОбъекта   = СтрЗаменить(ШаблонИмяПоляОбъекта  , "%Индекс%", Индекс);
		ИмяЭлементаФормы = СтрЗаменить(ШаблонИмяЭлементаФормы, "%Индекс%", Индекс);
		ТипПоляОбъекта   = ТипЗнч(Объект[ИмяПоляОбъекта]);
		Если ТипЗнч(Объект[ИмяПоляОбъекта]) = Тип("СправочникСсылка.БанковскиеСчета") Тогда
			
			Если СписокПараметров.Свойство("Организация") И ЗначениеЗаполнено(СписокПараметров.Организация) Тогда
				МассивПараметров.Добавить(Новый ПараметрВыбора("Отбор.Владелец", СписокПараметров.Организация));
			КонецЕсли;
			
			Если СписокПараметров.Свойство("ВалютаДенежныхСредств") И ЗначениеЗаполнено(СписокПараметров.ВалютаДенежныхСредств) Тогда
				МассивПараметров.Добавить(Новый ПараметрВыбора("Отбор.ВалютаДенежныхСредств", СписокПараметров.ВалютаДенежныхСредств));
			КонецЕсли;
			
		ИначеЕсли ТипЗнч(Объект[ИмяПоляОбъекта]) = Тип("СправочникСсылка.Кассы") Тогда
			
			Если СписокПараметров.Свойство("Организация") И ЗначениеЗаполнено(СписокПараметров.Организация) Тогда
				МассивПараметров.Добавить(Новый ПараметрВыбора("Отбор.Владелец", СписокПараметров.Организация));
			КонецЕсли;
			
			Если СписокПараметров.Свойство("ВалютаДенежныхСредств") И ЗначениеЗаполнено(СписокПараметров.ВалютаДенежныхСредств) Тогда
				МассивПараметров.Добавить(Новый ПараметрВыбора("Отбор.ВалютаДенежныхСредств", СписокПараметров.ВалютаДенежныхСредств));
			КонецЕсли;
			
		ИначеЕсли ТипЗнч(Объект[ИмяПоляОбъекта]) = Тип("СправочникСсылка.ПодразделенияОрганизаций") Тогда
			Если СписокПараметров.Свойство("СтруктурноеПодразделение") И ЗначениеЗаполнено(СписокПараметров.СтруктурноеПодразделение) Тогда
				МассивПараметров.Добавить(Новый ПараметрВыбора("Отбор.Ссылка", СписокПараметров.СтруктурноеПодразделение));
			КонецЕсли;
			Если СписокПараметров.Свойство("Организация") И ЗначениеЗаполнено(СписокПараметров.Организация) Тогда
				МассивПараметров.Добавить(Новый ПараметрВыбора("Отбор.Владелец", СписокПараметров.Организация));
			КонецЕсли;
			Если СписокПараметров.Свойство("ВыбиратьПодразделенияОрганизации") Тогда 
				МассивПараметров.Добавить(Новый ПараметрВыбора("ВыбиратьПодразделенияОрганизации", СписокПараметров.ВыбиратьПодразделенияОрганизации));
			КонецЕсли;
			
		ИначеЕсли ТипЗнч(Объект[ИмяПоляОбъекта]) = Тип("СправочникСсылка.ДоговорыКонтрагентов") Тогда
			Если СписокПараметров.Свойство("Организация") И ЗначениеЗаполнено(СписокПараметров.Организация) Тогда
				МассивПараметров.Добавить(Новый ПараметрВыбора("Отбор.Организация", СписокПараметров.Организация));
			КонецЕсли;
			Если СписокПараметров.Свойство("Контрагент") Тогда
				МассивПараметров.Добавить(Новый ПараметрВыбора("Отбор.Владелец", СписокПараметров.Контрагент));
			КонецЕсли;
			
		ИначеЕсли ТипЗнч(Объект[ИмяПоляОбъекта]) = Тип("СправочникСсылка.Субконто") 
			И СписокПараметров.Свойство("СчетУчета") Тогда
			СвойстваСчета = ПроцедурыБухгалтерскогоУчетаВызовСервераПовтИсп.ПолучитьСвойстваСчета(СписокПараметров.СчетУчета);
			МассивПараметров.Добавить(Новый ПараметрВыбора("Отбор.Владелец", СвойстваСчета["ВидСубконто" + Индекс]));
		КонецЕсли;
		
		ПараметрыВыбора = Новый ФиксированныйМассив(МассивПараметров);
		Форма.Элементы[ИмяЭлементаФормы].ПараметрыВыбора = ПараметрыВыбора;
		
		Если ОчищатьСвязанныеСубконто 
			И ЗначениеЗаполнено(Объект[ИмяПоляОбъекта]) Тогда
			
			Если ТипЗнч(Объект[ИмяПоляОбъекта]) = Тип("СправочникСсылка.ДоговорыКонтрагентов") Тогда
				РеквизитыДоговораОрганизация = ОбщегоНазначенияБКВызовСервера.ЗначениеРеквизитаОбъекта(Объект[ИмяПоляОбъекта], "Организация");
				РеквизитыДоговораВладелец    = ОбщегоНазначенияБКВызовСервера.ЗначениеРеквизитаОбъекта(Объект[ИмяПоляОбъекта], "Владелец");
				Если СписокПараметров.Свойство("Организация") И СписокПараметров.Свойство("Контрагент") Тогда
					Если СписокПараметров.Организация = РеквизитыДоговораОрганизация И СписокПараметров.Контрагент = РеквизитыДоговораВладелец Тогда
						ОчищатьСвязанныеСубконто = Ложь;
						Продолжить;
					КонецЕсли;					
				КонецЕсли;
			КонецЕсли; 				

			Если ТипыСвязанныхСубконто = Неопределено Тогда
				ВсеТипыСвязанныхСубконто = ПроцедурыБухгалтерскогоУчетаВызовСервераПовтИсп.ВсеТипыСвязанныхСубконто();
				ТипыСвязанныхСубконто    = Новый ОписаниеТипов(Новый Массив);
				Для каждого Параметр Из СписокПараметров Цикл
					Если ВсеТипыСвязанныхСубконто[Параметр.Ключ] <> Неопределено Тогда
						ТипыСвязанныхСубконто = Новый ОписаниеТипов(ТипыСвязанныхСубконто, 
							ВсеТипыСвязанныхСубконто[Параметр.Ключ].Типы());
					КонецЕсли;
				КонецЦикла;
			КонецЕсли;
			
			Если ТипыСвязанныхСубконто.СодержитТип(ТипПоляОбъекта)	Тогда
				//проверяем, что до него было изменено именно субконто "Организация"
				Если ТипПоляОбъекта = Тип("СправочникСсылка.ПодразделенияОрганизаций") Тогда
					Если Индекс = 1 Тогда
						ИндексПР = 1;
					Иначе
						ИндексПР = Индекс - 1;						
					КонецЕсли;					
					ТипПоляПредшествующего = СтрЗаменить(ШаблонИмяПоляОбъекта  , "%Индекс%", ИндексПР);
					Если ТипПоляПредшествующего = Тип("СправочникСсылка.Организации") Тогда
						Объект[ИмяПоляОбъекта] = Новый (ТипПоляОбъекта);
					КонецЕсли; 					
				Иначе				
					Объект[ИмяПоляОбъекта] = Новый (ТипПоляОбъекта);
				КонецЕсли;
			КонецЕсли;
			
		КонецЕсли;
		
		Если ИмяТекущегоЭлемента = ИмяЭлементаФормы Тогда
			ОчищатьСвязанныеСубконто = Истина; // Очищаются только субконто с номером больше текущего
		КонецЕсли;
		
	КонецЦикла;

КонецПроцедуры

// Процедура изменяет параметры выбора для ПоляВвода управляемой формы:
//
//Параметры:
//	ЭлементФормыСчет - ПолеВвода управляемой формы, для которого изменяется параметр выбора 
//  МассивСчетов                 - <Массив> ИЛИ <Неопределено> - счета, которыми нужно ограничить список. 
//	                                   Если не заполнено - ограничения не будет
//  ОтборПоПризнакуВалютный      - <Булево> ИЛИ <Неопределено> - Значение для установки соответсвтующего параметра выбора. 
//                                     Если неопределено, параметр выбора не устанавливается.
//  ОтборПоПризнкуЗабалансовый   - <Булево> ИЛИ <Неопределено> - Значение для установки соответсвтующего параметра выбора. 
//                                     Если неопределено, параметр выбора не устанавливается.
//  ОтборПоПризнакуСчетГруппа    - <Булево> ИЛИ <Неопределено> - Значение для установки соответсвтующего параметра выбора. 
//                                     Если неопределено, параметр выбора не устанавливается.
//
//
Процедура ИзменитьПараметрыВыбораСчета(ЭлементФормыСчет, МассивСчетов, ОтборПоПризнакуВалютный = Неопределено, ОтборПоПризнакуЗабалансовый = Неопределено, ОтборПоПризнакуСчетГруппа = Ложь) Экспорт

	МассивОтборов = Новый Массив;
	Если ОтборПоПризнакуСчетГруппа <> Неопределено Тогда
		МассивОтборов.Добавить(Новый ПараметрВыбора("Отбор.ЗапретитьИспользоватьВПроводках", ОтборПоПризнакуСчетГруппа));
	КонецЕсли; 
	
	Если ОтборПоПризнакуВалютный <> Неопределено Тогда
		МассивОтборов.Добавить(Новый ПараметрВыбора("Отбор.Валютный", ОтборПоПризнакуВалютный));
	КонецЕсли; 
	
	Если ОтборПоПризнакуЗабалансовый <> Неопределено Тогда
		МассивОтборов.Добавить(Новый ПараметрВыбора("Отбор.Забалансовый", ОтборПоПризнакуЗабалансовый));
	КонецЕсли; 
	
	Если МассивСчетов <> Неопределено И МассивСчетов.Количество() > 0 Тогда
		МассивОтборов.Добавить(Новый ПараметрВыбора("Отбор.Ссылка", Новый ФиксированныйМассив(МассивСчетов)));
	КонецЕсли; 

	ПараметрыВыбора = Новый ФиксированныйМассив(МассивОтборов);
	ЭлементФормыСчет.ПараметрыВыбора = ПараметрыВыбора;
	
КонецПроцедуры

// Функция ЭтоРегламентнаяОперация возвращает Истина, если переданный по ссылке документ
// является документом регламентной операции.
//
Функция ЭтоРегламентнаяОперация(СсылкаНаДокумент) Экспорт

	Возврат ТипЗнч(СсылкаНаДокумент) = Тип("ДокументСсылка.ЗакрытиеМесяца");

КонецФункции

// Процедура - обработчик события ПриИзменении счета в табличной части
//
// Параметры:
//	Объект - ДанныеФормыСтруктура, СправочникОбъект, ДокументОбъект, ДанныеФормыСтруктураСКоллекцией и т.п. - любая коллекция, обращение к свойствам которой доступно через []
//  СтруктураРеквизитов - структура с названиеями и значениями реквизитов, которые необходимо проверить
//
Процедура ПроверитьУстановитьПроизвольноеСубконто(Объект, СтруктураРеквизитов) Экспорт
	
	Если СтруктураРеквизитов.Свойство("НазваниеСубконто1") И СтруктураРеквизитов.Свойство("Субконто1") И СтруктураРеквизитов.Свойство("ЗначениеСубконто") Тогда
		УстановитьПроизвольноеСубконто(Объект, СтруктураРеквизитов.НазваниеСубконто1, СтруктураРеквизитов.Субконто1, СтруктураРеквизитов.ЗначениеСубконто);
	КонецЕсли;
	
	Если СтруктураРеквизитов.Свойство("НазваниеСубконто2") И СтруктураРеквизитов.Свойство("Субконто2") И СтруктураРеквизитов.Свойство("ЗначениеСубконто") Тогда
		УстановитьПроизвольноеСубконто(Объект, СтруктураРеквизитов.НазваниеСубконто2, СтруктураРеквизитов.Субконто2, СтруктураРеквизитов.ЗначениеСубконто);
	КонецЕсли;
	
	Если СтруктураРеквизитов.Свойство("НазваниеСубконто3") И СтруктураРеквизитов.Свойство("Субконто3") И СтруктураРеквизитов.Свойство("ЗначениеСубконто") Тогда
		УстановитьПроизвольноеСубконто(Объект, СтруктураРеквизитов.НазваниеСубконто3, СтруктураРеквизитов.Субконто3,  СтруктураРеквизитов.ЗначениеСубконто);
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

Процедура УстановитьПроизвольноеСубконто(Объект, НазваниеРеквизитаСубконто, Субконто, ЗначениеСубконто)	
	
	Если ТипЗнч(Субконто) = ТипЗнч(ЗначениеСубконто) Тогда
		
		// Если субконто не заполнено.
		Если НЕ ЗначениеЗаполнено(Субконто) Тогда
			Объект[НазваниеРеквизитаСубконто] = ЗначениеСубконто;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

// Функция определяет, нужно ли скрывать данное субконто
//
// Параметры:
//	СкрыватьСубконто - Булево - - Признак того, нужно ли для этой формы дополнительно скрывать субконто
//	ТипЗначенияСубконто - Описание типов 
//
Функция НужноСкрытьСубконто(СкрыватьСубконто, ТипЗначенияСубконто)
	
	Если СкрыватьСубконто Тогда
		Возврат ТипЗначенияСубконто = Новый ОписаниеТипов("СправочникСсылка.НоменклатурныеГруппы") И
			ПроцедурыБухгалтерскогоУчетаВызовСервераПовтИсп.ИспользоватьОднуНоменклатурнуюГруппу();
	Иначе
		Возврат Ложь;
	КонецЕсли;
	
КонецФункции
