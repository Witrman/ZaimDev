﻿
#Область ФормаПоискНоменклатурыПоШтрихкоду

Функция ИнициализироватьДанныеШтрихкода(ПараметрыСканирования = Неопределено) Экспорт
	
	ДанныеШтрихкода = Новый Структура;
	
	ДанныеШтрихкода.Вставить("Номенклатура",              Неопределено);
	ДанныеШтрихкода.Вставить("Характеристика",            Неопределено);
	ДанныеШтрихкода.Вставить("Серия",                     Неопределено);
	ДанныеШтрихкода.Вставить("ПредставлениеНоменклатуры", "");
	ДанныеШтрихкода.Вставить("ВложенныеШтрихкоды",        Новый Соответствие);
	ДанныеШтрихкода.Вставить("Количество",                0);
	ДанныеШтрихкода.Вставить("МаркированныеТовары",       Новый Массив);
	ДанныеШтрихкода.Вставить("ТекстОшибки",               Неопределено);
	ДанныеШтрихкода.Вставить("ТипУпаковки",               Неопределено);
	ДанныеШтрихкода.Вставить("ТипШтрихкода",              Неопределено);
	ДанныеШтрихкода.Вставить("Упаковка",                  Неопределено);
	ДанныеШтрихкода.Вставить("Штрихкод",                  Неопределено);
	ДанныеШтрихкода.Вставить("ШтрихкодУпаковки",          Неопределено);
	ДанныеШтрихкода.Вставить("ДополнительныеПараметры",   Неопределено);
	ДанныеШтрихкода.Вставить("ВидыПродукции",             Новый Массив);
	ДанныеШтрихкода.Вставить("МаркируемаяПродукция",      Неопределено);
	ДанныеШтрихкода.Вставить("ОбработатьБезМаркировки",   Ложь);
	ДанныеШтрихкода.Вставить("ЭтоШтрихкодНоменклатуры",   Ложь);
	ДанныеШтрихкода.Вставить("АдресДереваУпаковок",       Неопределено);
	ДанныеШтрихкода.Вставить("ИННВладельца"               "");
	ДанныеШтрихкода.Вставить("Владелец",                  Неопределено);
	ДанныеШтрихкода.Вставить("Статус",                    Неопределено);
	ДанныеШтрихкода.Вставить("ПредставлениеСтатуса"       "");
	ДанныеШтрихкода.Вставить("КоличествоВложенныхЕдиниц", 1);
	ДанныеШтрихкода.Вставить("ИННПроизводителя",          "");
	ДанныеШтрихкода.Вставить("Производитель",             Неопределено);
	ДанныеШтрихкода.Вставить("НаименованиеПроизводителя", "");
	ДанныеШтрихкода.Вставить("ДатаЭмиссии",               Неопределено);
	ДанныеШтрихкода.Вставить("ТребуетсяВыборСерии",       Ложь);
	ДанныеШтрихкода.Вставить("GTIN",                      "");
	ДанныеШтрихкода.Вставить("СпособВводаВОборот",        Неопределено);
	ДанныеШтрихкода.Вставить("ОсобоеСостояние",           Неопределено);	
	
	Возврат ДанныеШтрихкода;
	
КонецФункции

#КонецОбласти

#Область МодификацияФормыДокумента

Процедура ПриСозданииНаСервере(Форма, Отказ, СтандартнаяОбработка, ДополнительныеПараметры = Неопределено) Экспорт
	
	РозничноеВыбытиеИСМПТКПереопределяемый.ПриСозданииНаСервере(Форма, Отказ, СтандартнаяОбработка, ДополнительныеПараметры);
		
КонецПроцедуры

Процедура МодификацияРеквизитовФормы(Форма, ПараметрыИнтеграции, ДобавляемыеРеквизиты) Экспорт
	
	ДобавитьОбщиеНастройкиВстраивания(Форма, ПараметрыИнтеграции);

КонецПроцедуры

Процедура МодификацияЭлементовФормы(Форма) Экспорт
	
	РозничноеВыбытиеИСМПТКПереопределяемый.МодификацияЭлементовФормыИСМПТК(Форма);
	
КонецПроцедуры

// Возвращает структуру, заполненную значениями по умолчанию, используемую для интеграции реквизитов ИСМПТ
//   в прикладные формы конфигурации - потребителя библиотеки Маркировки.
//   Содержит общие настройки встраивания подсистемы
//
// ВозвращаемоеЗначение:
//  ПараметрыИнтеграции - Структура - значения, используемые для интеграции подсистемы в прикладную форму:
//   * МодульЗаполнения        - Строка - модуль в котором размещаются действия по заполнению реквизитов ИСМПТК при открытии формы
//   * ИмяРеквизитаФормыОбъект - Строка - имя реквизита формы, содержащего связанный объект.
//
Функция ОбщиеПараметрыИнтеграции(ИмяМодуляЗаполнения = Неопределено) Экспорт
	
	ОбщиеПараметры = Новый Структура;
	ОбщиеПараметры.Вставить("МодульЗаполнения",        ИмяМодуляЗаполнения);
	ОбщиеПараметры.Вставить("ИмяРеквизитаФормыОбъект", "Объект");
	
	Возврат ОбщиеПараметры;
	
КонецФункции

Процедура ДобавитьОбщиеНастройкиВстраивания(Форма, ПараметрыИнтеграции)
	
	ОбщиеНастройки = ОбщиеПараметрыИнтеграции("РозничноеВыбытиеИСМПТК");
	ОбщиеНастройки.Вставить("ВидыПродукции", Новый Массив);
	
	Если ПолучитьФункциональнуюОпцию("ВестиУчетМаркируемогоТабакаИСМПТК") Тогда
		ОбщиеНастройки.ВидыПродукции.Добавить(Перечисления.ВидыПродукцииИСМПТК.Табачная);
	КонецЕсли;
	
	Если ПолучитьФункциональнуюОпцию("ВестиУчетМаркируемойОбувиИСМПТК") Тогда
		ОбщиеНастройки.ВидыПродукции.Добавить(Перечисления.ВидыПродукцииИСМПТК.Обувная);
	КонецЕсли;
	
	Если ПолучитьФункциональнуюОпцию("ВестиУчетМаркируемойМолочкиИСМПТК") Тогда
		ОбщиеНастройки.ВидыПродукции.Добавить(Перечисления.ВидыПродукцииИСМПТК.МолочнаяПродукция);
	КонецЕсли;
	
	Если ПолучитьФункциональнуюОпцию("ВестиУчетМаркируемогоТекстиляИСМПТК") Тогда
		ОбщиеНастройки.ВидыПродукции.Добавить(Перечисления.ВидыПродукцииИСМПТК.ЛегкаяПромышленность);
	КонецЕсли;
	
	Если ПолучитьФункциональнуюОпцию("ВестиУчетМаркируемыхЛекарствИСМПТК") Тогда
		ОбщиеНастройки.ВидыПродукции.Добавить(Перечисления.ВидыПродукцииИСМПТК.ЛекарственныеПрепараты);
	КонецЕсли;
	
	ПараметрыИнтеграции.Вставить("ИСМПТК", ОбщиеНастройки);
	
КонецПроцедуры

#КонецОбласти

#Область ПроверкаВидаПродукции

Функция ЭтоШтрихкодОбувнойПродукции(КодМаркировки, УчитыватьЛогистическуюУпаковку = Ложь) Экспорт
	
	НастройкиРазбораКодаМаркировки = РазборИОбработкаКодовМаркировкиИСМПТКСлужебныйПовтИсп.НастройкиРазбораКодаМаркировки();
	СтруктураРазбора = РазборИОбработкаКодовМаркировкиИСМПТКСлужебный.РазобратьКодМаркировки(КодМаркировки, НастройкиРазбораКодаМаркировки.ДоступныеВидыПродукции, , НастройкиРазбораКодаМаркировки);
	
	ЭтоКодПотребительскойУпаковки = Не СтруктураРазбора = Неопределено
									И СтруктураРазбора.ВидУпаковки = Перечисления.ВидыУпаковокИСМПТК.Потребительская
									И Не СтруктураРазбора.ВидыПродукции.Найти(Перечисления.ВидыПродукцииИСМПТК.Обувная) = Неопределено;
	
	Если УчитыватьЛогистическуюУпаковку
		И Не ЭтоКодПотребительскойУпаковки Тогда
		
		Возврат Не СтруктураРазбора = Неопределено И СтруктураРазбора.ВидУпаковки = Перечисления.ВидыУпаковокИСМПТК.Логистическая;
		
	КонецЕсли;
	
	Возврат ЭтоКодПотребительскойУпаковки;
	
КонецФункции

Функция ЭтоШтрихкодТабачнойПродукции(КодМаркировки, УчитыватьЛогистическуюУпаковку = Ложь) Экспорт
	
	Возврат РозничноеВыбытиеИСМПТККлиентСервер.ЭтоКодМаркировкиТабачнойПачки(КодМаркировки)
		Или РозничноеВыбытиеИСМПТККлиентСервер.ЭтоКодМаркировкиБлока(КодМаркировки);
	
КонецФункции

Функция ЭтоШтрихкодЛекарственнойПродукции(КодМаркировки, УчитыватьЛогистическуюУпаковку = Ложь) Экспорт
	
	НастройкиРазбораКодаМаркировки = РазборИОбработкаКодовМаркировкиИСМПТКСлужебныйПовтИсп.НастройкиРазбораКодаМаркировки();
	СтруктураРазбора 			   = РазборИОбработкаКодовМаркировкиИСМПТКСлужебный.РазобратьКодМаркировки(КодМаркировки, НастройкиРазбораКодаМаркировки.ДоступныеВидыПродукции, , НастройкиРазбораКодаМаркировки);
	
	ЭтоКодПотребительскойУпаковки = Не СтруктураРазбора = Неопределено
									И СтруктураРазбора.ВидУпаковки = Перечисления.ВидыУпаковокИСМПТК.Потребительская
									И Не СтруктураРазбора.ВидыПродукции.Найти(Перечисления.ВидыПродукцииИСМПТК.ЛекарственныеПрепараты) = Неопределено;
	
	Если УчитыватьЛогистическуюУпаковку
		И Не ЭтоКодПотребительскойУпаковки Тогда
		
		Возврат Не СтруктураРазбора = Неопределено И СтруктураРазбора.ВидУпаковки = Перечисления.ВидыУпаковокИСМПТК.Логистическая;
		
	КонецЕсли;
	
	Возврат ЭтоКодПотребительскойУпаковки;
	
КонецФункции

#КонецОбласти

#Область Штрихкодирование

Функция НормализованныйШтрихкод(Знач ШтрихкодBase64) Экспорт
	
	Если РазборИОбработкаКодовМаркировкиИСМПТКСлужебный.ЭтоСтрокаФорматаBase64(ШтрихкодBase64) Тогда
		Штрихкод = РазборИОбработкаКодовМаркировкиИСМПТКСлужебныйКлиентСервер.Base64ВШтрихкод(ШтрихкодBase64);
	Иначе
		Штрихкод = ШтрихкодBase64;
	КонецЕсли;
	
	ШтрихкодНормализован 	   = Ложь;
	НужноЗакодироватьШтрихкод  = Ложь; //В формат Base64, если не получилось нормализовать
	
	Если ИнтеграцияИСМПТКПереопределяемый.НайтиНедопустимыеСимволыXMLПлатформа(Штрихкод) Тогда
					//Заменяем строку со спецсимволами строкой, у которой идентификаторы применения в скобках.
			НормализованныйШтрихкод = РазборИОбработкаКодовМаркировкиИСМПТКСлужебныйКлиентСервер.ШтрихкодВФорматеGS1(Штрихкод); 
			
			Если (ПолучитьФункциональнуюОпцию("ВестиУчетМаркируемогоТабакаИСМПТК") 
					И ЭтоШтрихкодТабачнойПродукции(НормализованныйШтрихкод))
				ИЛИ (ПолучитьФункциональнуюОпцию("ВестиУчетМаркируемойОбувиИСМПТК") 
					И ЭтоШтрихкодОбувнойПродукции(НормализованныйШтрихкод))
				ИЛИ (ПолучитьФункциональнуюОпцию("ВестиУчетМаркируемыхЛекарствИСМПТК")
					И ЭтоШтрихкодЛекарственнойПродукции(НормализованныйШтрихкод)) Тогда
					
				ШтрихкодНормализован = Истина;
					
			КонецЕсли;			
				
	Иначе
		
		Если ПолучитьФункциональнуюОпцию("ВестиУчетМаркируемогоТабакаИСМПТК") 
			И ЭтоШтрихкодТабачнойПродукции(Штрихкод) Тогда
			//в коде табачной пачки може не быть спецсимвола, поэтому считаем его нормализованным сразу
			НормализованныйШтрихкод = Штрихкод;
			ШтрихкодНормализован 	= Истина;
		КонецЕсли;
			
	КонецЕсли;
	
	Если Не ШтрихкодНормализован Тогда
		
		ЧтениеШтрихкода = РазборИОбработкаКодовМаркировкиИСМПТКСлужебныйКлиентСервер.ПараметрыШтрихкода(Штрихкод);
		
		Если Не ЧтениеШтрихкода.Результат = Неопределено Тогда
			
			//Пытаемся рзобрать ШК как код транспортной упаковки в формате SSCC 
			Если ЧтениеШтрихкода.ТипШтрихкода = ПредопределенноеЗначение("Перечисление.ТипыШтрихкодовИСМПТК.SSCC") Тогда
				//Розница не работает с транспортными кодами, но для проверки разобрать его все равно нужно
				НормализованныйШтрихкод = РазборИОбработкаКодовМаркировкиИСМПТКСлужебныйКлиентСервер.ШтрихкодSSCC(ЧтениеШтрихкода.Результат, Истина);
				ШтрихкодНормализован 	= НормализованныйШтрихкод <> Штрихкод;
			Иначе
				//Если не получилось разобрать штрихкод, значит с ним что-то не то. Для того, чтобы он гарантировано не приводил к ошибкам при возвращении из функции - закодируем его обратно в Base64.
				НужноЗакодироватьШтрихкод  = Истина;
			КонецЕсли;
			
		Иначе
			
			//Делаем еще одну попытку разбора: может быть штрихкод это штрихкод товара (ЕАН-13, ЕАН-8, GTIN) 
			ЭтоШтрихкодНоменклатуры = РазборИОбработкаКодовМаркировкиИСМПТКСлужебныйКлиентСервер.ПроверитьКорректностьGTIN(Штрихкод);
			Если ЭтоШтрихкодНоменклатуры Тогда //Такой ШК нормализовать не нужно
				
				Если СтрДлина(Штрихкод) = 14 Тогда
					
					ШтрихкодИзGTIN = РазборИОбработкаКодовМаркировкиИСМПТКСлужебныйКлиентСервер.ШтрихкодEANИзGTIN(Штрихкод);
					Возврат ШтрихкодИзGTIN;
					
				ИначеЕсли СтрДлина(Штрихкод) = 8 
					Или СтрДлина(Штрихкод) = 13 Тогда  
					
					Возврат Штрихкод;
					
				КонецЕсли;
				
			Иначе
				//Если не получилось разобрать штрихкод, значит с ним что-то не то. Для того, чтобы он гарантировано не приводил к ошибкам при возвращении из функции - закодируем его обратно в Base64.
				НужноЗакодироватьШтрихкод  = Истина;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	Если ШтрихкодНормализован Тогда
		Возврат НормализованныйШтрихкод;
	Иначе
		Если НужноЗакодироватьШтрихкод Тогда 
			Возврат РазборИОбработкаКодовМаркировкиИСМПТКСлужебныйКлиентСервер.ШтрихкодВBase64(Штрихкод);
		Иначе
			Возврат Штрихкод;
		КонецЕсли;
	КонецЕсли;
	
КонецФункции

Процедура ПолныйШтрихкодИзНормализованного(ДанныеШтрихКода, СтрокаШтрихКод = "", СтрокаШтрихКодBase64 = "") Экспорт
	
	//01
	ДобавитьБлокКода(СтрокаШтрихКод, ДанныеШтрихКода, "01");
	ДобавитьБлокКода(СтрокаШтрихКодBase64, ДанныеШтрихКода, "01");
	//21
	ДобавитьБлокКода(СтрокаШтрихКод, ДанныеШтрихКода, "21");
	ДобавитьБлокКода(СтрокаШтрихКодBase64, ДанныеШтрихКода, "21");
	//91
	ДобавитьБлокКода(СтрокаШтрихКод, ДанныеШтрихКода, "91");
	ДобавитьБлокКода(СтрокаШтрихКодBase64, ДанныеШтрихКода, "91", Истина);
	//92
	ДобавитьБлокКода(СтрокаШтрихКод, ДанныеШтрихКода, "92");
	ДобавитьБлокКода(СтрокаШтрихКодBase64, ДанныеШтрихКода, "92", Истина);
	//93
	ДобавитьБлокКода(СтрокаШтрихКод, ДанныеШтрихКода, "93");
	ДобавитьБлокКода(СтрокаШтрихКодBase64, ДанныеШтрихКода, "93", Истина);
	
КонецПроцедуры

Процедура ДобавитьБлокКода(СтрокаКода, ДанныеШтрихКода, Блок, ДобавитьРазделитель = Ложь)
	
	Если Не ДанныеШтрихКода.Получить(Блок) = Неопределено Тогда 
		
		КлючСтруктуры = ДанныеШтрихКода.Получить(Блок);
		ЗначениеБлока = КлючСтруктуры.Значение;
		
		Если ДобавитьРазделитель Тогда 
			СтрокаКода 	= СтрокаКода + РазборИОбработкаКодовМаркировкиИСМПТКСлужебныйКлиентСервер.РазделительGS1() + Блок + ЗначениеБлока;
		Иначе 
			СтрокаКода 	= СтрокаКода + Блок + ЗначениеБлока;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

Функция РазобратьКодМаркировкиТовараДляПробитияЧека(Знач КодМаркировки) Экспорт;
	
	Идентификаторы = РазборИОбработкаКодовМаркировкиИСМПТКСлужебныйКлиентСервер.ИдентификаторыGS1(); 
	
	// Определяем структуру результата. 
	ДанныеМаркировки = Новый Структура();
	ДанныеМаркировки.Вставить("Разобран", 				 Ложь);
	ДанныеМаркировки.Вставить("ОписаниеОшибки");
	ДанныеМаркировки.Вставить("ПредставлениеШтрихкода" , "");
	ДанныеМаркировки.Вставить("ПотребительскаяУпаковка", Ложь);
	ДанныеМаркировки.Вставить("ДанныеШтрихкода", 		 Новый Соответствие);
	
	ДанныеМаркировки.Вставить("ГлобальныйИдентификаторТорговойЕдиницы"); // GTIN
	ДанныеМаркировки.Вставить("СерийныйНомер"); 						 // Серийный номер с потребительской или групповой обработки.
	ДанныеМаркировки.Вставить("ИдентификаторКлючаПроверки");
	ДанныеМаркировки.Вставить("КодПроверки");
	ДанныеМаркировки.Вставить("ДополнительныйИдентификаторПродукта");
	
	ДанныеМаркировки.Вставить("КодМаркировки");    // Исходный код маркировки. Для отображении на экране.
	ДанныеМаркировки.Вставить("КодМаркировкиККТ"); // Исходный код маркировки. Маскируемый для передачи на ККТ. 
 	ДанныеМаркировки.Вставить("EAN");              // Штрихкод товара преобразованный из GTIN

	ПозицияРазделителяGS1 	= Найти(КодМаркировки, РазборИОбработкаКодовМаркировкиИСМПТКСлужебныйКлиентСервер.РазделительGS1());
	ПозицияРазделителяЭкран = Найти(КодМаркировки, РазборИОбработкаКодовМаркировкиИСМПТКСлужебныйКлиентСервер.ЭкранированныйСимволGS1());
	
	Если СтрНачинаетсяС(КодМаркировки, "(") Тогда
		
		КодыGS1 = РазборИОбработкаКодовМаркировкиИСМПТКСлужебныйКлиентСерверПовтИсп.КодыGS1();
		РазборИОбработкаКодовМаркировкиИСМПТКСлужебныйКлиентСервер.РазобратьСтрокуШтрихкодаGS1СоСкобками(КодМаркировки, ДанныеМаркировки, КодыGS1);
		
		Если ДанныеМаркировки.Разобран Тогда
			
			ЗначениеЭлемента = ДанныеМаркировки.ДанныеШтрихкода.Получить(Идентификаторы.GTIN);
			Если ЗначениеЭлемента <> Неопределено Тогда
				ДанныеМаркировки.ГлобальныйИдентификаторТорговойЕдиницы = ЗначениеЭлемента.Значение;
			КонецЕсли;
			
			ЗначениеЭлемента = ДанныеМаркировки.ДанныеШтрихкода.Получить(Идентификаторы.СерийныйНомер);
			Если ЗначениеЭлемента <> Неопределено Тогда
				ДанныеМаркировки.СерийныйНомер = ЗначениеЭлемента.Значение;
			КонецЕсли;
			
			ЗначениеЭлемента = ДанныеМаркировки.ДанныеШтрихкода.Получить(Идентификаторы.КлючПроверки);
			Если ЗначениеЭлемента <> Неопределено Тогда
				ДанныеМаркировки.ИдентификаторКлючаПроверки = ЗначениеЭлемента.Значение;
			КонецЕсли;
			
			ЗначениеЭлемента = ДанныеМаркировки.ДанныеШтрихкода.Получить(Идентификаторы.КодПроверки);
			Если ЗначениеЭлемента <> Неопределено Тогда
				ДанныеМаркировки.КодПроверки = ЗначениеЭлемента.Значение;
			КонецЕсли;
		КонецЕсли;
		
	ИначеЕсли ПозицияРазделителяGS1 > 0 Или ПозицияРазделителяЭкран > 0 Тогда // В коде маркировки для групповых и транспортных упаковок присутствует символ разделитель GS1 (Dec 29).
		
		КодыGS1 = РазборИОбработкаКодовМаркировкиИСМПТКСлужебныйКлиентСерверПовтИсп.КодыGS1();
		
		Если ПозицияРазделителяЭкран > 0 Тогда
			ЧастиШтрихкода = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(КодМаркировки, РазборИОбработкаКодовМаркировкиИСМПТКСлужебныйКлиентСервер.ЭкранированныйСимволGS1(), Ложь);
			ДанныеМаркировки.КодМаркировки 	  = СтрЗаменить(КодМаркировки, РазборИОбработкаКодовМаркировкиИСМПТКСлужебныйКлиентСервер.ЭкранированныйСимволGS1(), "");
			ДанныеМаркировки.КодМаркировкиККТ = ДанныеМаркировки.КодМаркировки;
		Иначе
			ЧастиШтрихкода = СтрРазделить(КодМаркировки, РазборИОбработкаКодовМаркировкиИСМПТКСлужебныйКлиентСервер.РазделительGS1(), Ложь);
			ДанныеМаркировки.КодМаркировки 	  = СтрЗаменить(КодМаркировки, РазборИОбработкаКодовМаркировкиИСМПТКСлужебныйКлиентСервер.РазделительGS1(), "");
			ДанныеМаркировки.КодМаркировкиККТ = СтрЗаменить(КодМаркировки, РазборИОбработкаКодовМаркировкиИСМПТКСлужебныйКлиентСервер.РазделительGS1(), РазборИОбработкаКодовМаркировкиИСМПТКСлужебныйКлиентСервер.ЭкранированныйСимволGS1());
		КонецЕсли;
		
		Для Каждого ЧастьБезРазделителей Из ЧастиШтрихкода Цикл
			РазборИОбработкаКодовМаркировкиИСМПТКСлужебныйКлиентСервер.РазобратьСтрокуШтрихкодаGS1Служебный(ЧастьБезРазделителей, ДанныеМаркировки, КодыGS1);
		КонецЦикла;
		
		Если ДанныеМаркировки.Разобран Тогда
			
			ЗначениеЭлемента = ДанныеМаркировки.ДанныеШтрихкода.Получить(Идентификаторы.GTIN);
			Если ЗначениеЭлемента <> Неопределено Тогда
				ДанныеМаркировки.ГлобальныйИдентификаторТорговойЕдиницы = ЗначениеЭлемента.Значение;
			КонецЕсли;
			
			ЗначениеЭлемента = ДанныеМаркировки.ДанныеШтрихкода.Получить(Идентификаторы.СерийныйНомер);
			Если ЗначениеЭлемента <> Неопределено Тогда
				ДанныеМаркировки.СерийныйНомер = ЗначениеЭлемента.Значение;
			КонецЕсли;
			
			ЗначениеЭлемента = ДанныеМаркировки.ДанныеШтрихкода.Получить(Идентификаторы.КлючПроверки);
			Если ЗначениеЭлемента <> Неопределено Тогда
				ДанныеМаркировки.ИдентификаторКлючаПроверки = ЗначениеЭлемента.Значение;
			КонецЕсли;
			
			ЗначениеЭлемента = ДанныеМаркировки.ДанныеШтрихкода.Получить(Идентификаторы.КодПроверки);
			Если ЗначениеЭлемента <> Неопределено Тогда
				ДанныеМаркировки.КодПроверки = ЗначениеЭлемента.Значение;
			КонецЕсли;
		КонецЕсли;
		
	Иначе
		// Код маркировки потребительской упаковке представляет собой строку символов без разделителей.
		ДанныеМаркировки.КодМаркировки = КодМаркировки;
		
		ДлиннаКода = СтрДлина(КодМаркировки);
		Если ДлиннаКода = 29 Тогда // Код маркировки табачной потребительской упаковки изложенные в постановлении правительстве №1433 от 27 ноября 2017.
			
			ДанныеМаркировки.ПотребительскаяУпаковка = Истина;
			ДанныеМаркировки.ГлобальныйИдентификаторТорговойЕдиницы = Лев(КодМаркировки, 14); // Код товара по товарной номенклатуре GS1.
			ДанныеМаркировки.СерийныйНомер = Сред(КодМаркировки, 15, 7); // Код идентификации упаковки табачной продукции.
			ДанныеМаркировки.КодПроверки   = Прав(КодМаркировки, 8); // Код проверки.
			ДанныеМаркировки.Разобран 	   = Истина;
			
		ИначеЕсли ДлиннаКода = 31 Тогда // Код маркировки табачной потребительской упаковки, новые требования.
			
			ДанныеМаркировки.ПотребительскаяУпаковка = Истина;
			ДанныеМаркировки.ГлобальныйИдентификаторТорговойЕдиницы = Лев(КодМаркировки, 14); // Код товара по товарной номенклатуре GS1.
			ДанныеМаркировки.СерийныйНомер = Сред(КодМаркировки, 15, 7); // Код идентификации упаковки табачной продукции.
			КодПроверки = Прав(КодМаркировки, 10); 
			ДанныеМаркировки.ИдентификаторКлючаПроверки = Лев(КодПроверки, 2); // Идентификатор ключа проверки.
			ДанныеМаркировки.КодПроверки = Прав(КодПроверки, 8); // Код проверки.
			ДанныеМаркировки.Разобран 	 = Истина;
			
		Иначе
			ДанныеМаркировки.ОписаниеОшибки = НСтр("ru = 'Штрихкод не распознан.'")
		КонецЕсли;
	
	КонецЕсли;
	
	Если ДанныеМаркировки.Разобран Тогда
		// Пытаем получить торговый штрикод EAN8 или EAN13 из GTIN.
		GTIN = ДанныеМаркировки.ГлобальныйИдентификаторТорговойЕдиницы;
		Пока Лев(GTIN, 1) = "0" И СтрДлина(GTIN) > 8 Цикл
			GTIN = Сред(GTIN, 2);
		КонецЦикла;
		ДанныеМаркировки.EAN = GTIN;
	КонецЕсли;
	
	Возврат ДанныеМаркировки;
	
КонецФункции

