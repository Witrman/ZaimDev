﻿
Функция РазобратьКодМаркировки(Знач ДанныеДляРазбора, ВидыПродукции = Неопределено, ПримечаниеКРезультатуРазбора = Неопределено) Экспорт
	
	ПримечаниеКРезультатуРазбора = Новый Структура("ИдентификаторОшибки, ТекстОшибки, РезультатРазбора", "", "", Неопределено);
	
	ИдентификаторыОшибок = ИдентификаторыОшибокРазобраКодаМаркировки();
	
	Настройки = НастройкиРазбораКодаМаркировки();
	
	Если Настройки.ДоступныеВидыПродукции.Количество() = 0 Тогда
		ПримечаниеКРезультатуРазбора.ИдентификаторОшибки = ИдентификаторыОшибок.УчетМаркируемойПродукцииНеВедется;
		ПримечаниеКРезультатуРазбора.ТекстОшибки         = НСтр("ru = 'Учет маркируемой продукции не ведется.'");
		Возврат Неопределено;
	КонецЕсли;
	
	ВидыПродукцииДляФильтра = Новый Массив;
	Если ЗначениеЗаполнено(ВидыПродукции) И ТипЗнч(ВидыПродукции) = Тип("ПеречислениеСсылка.ВидыПродукцииИСМПТК") Тогда
		ВидыПродукцииДляФильтра.Добавить(ВидыПродукции);
	ИначеЕсли ЗначениеЗаполнено(ВидыПродукции) И ТипЗнч(ВидыПродукции) = Тип("Массив") Тогда
		Для Каждого Значение Из ВидыПродукции Цикл
			Если ЗначениеЗаполнено(Значение) И ТипЗнч(Значение) = Тип("ПеречислениеСсылка.ВидыПродукцииИСМПТК") Тогда
				ВидыПродукцииДляФильтра.Добавить(Значение);
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	ВидыПродукцииДляФильтра = ОбщегоНазначенияКлиентСервер.СвернутьМассив(ВидыПродукцииДляФильтра);
	
	ФильтрПоВидуПродукции = Новый Структура("Использовать, ВидыПродукции", Ложь, Неопределено);
	Если ВидыПродукцииДляФильтра.Количество() > 0 Тогда
		ФильтрПоВидуПродукции.Использовать = Истина;
		ФильтрПоВидуПродукции.ВидыПродукции = Новый ФиксированныйМассив(ВидыПродукцииДляФильтра);
	КонецЕсли;
	
	РезультатРазбора = Неопределено;
	Если ТипЗнч(ДанныеДляРазбора) = Тип("Строка") Тогда
		Если НайтиНедопустимыеСимволыXML(ДанныеДляРазбора) > 0 Тогда
			РезультатРазбора = ПодключаемоеОборудованиеИСМПТККлиентСервер.РазобратьСтрокуШтрихкодаGS1(ДанныеДляРазбора);
		КонецЕсли;
	ИначеЕсли ТипЗнч(ДанныеДляРазбора) = Тип("Структура") Тогда
		РезультатРазбора = ДанныеДляРазбора;
	Иначе
		ПримечаниеКРезультатуРазбора.ИдентификаторОшибки = ИдентификаторыОшибок.ДанныеДляРазбораНекорректны;
		ПримечаниеКРезультатуРазбора.ТекстОшибки         = НСтр("ru = 'Данные для разбора некорректны.'");
		Возврат Неопределено;
	КонецЕсли;
	
	НачинаетсяСоСкобки = Ложь;
	СодержитGS1        = Ложь;
	
	Если РезультатРазбора = Неопределено Тогда
		НачинаетсяСоСкобки = СтрНачинаетсяС(ДанныеДляРазбора, "(");
		КодМаркировки      = ДанныеДляРазбора;
	Иначе
		Если Не РезультатРазбора.Разобран Тогда
			ПримечаниеКРезультатуРазбора.ИдентификаторОшибки = ИдентификаторыОшибок.ДанныеДляРазбораНекорректны;
			ПримечаниеКРезультатуРазбора.ТекстОшибки         = РезультатРазбора.ОписаниеОшибки;
			Возврат Неопределено;
		КонецЕсли;
		СодержитGS1    = Истина;
		КодМаркировки  = РезультатРазбора.ПредставлениеШтрихкода;
	КонецЕсли;
	
	ДлинаКодаМаркировки = СтрДлина(КодМаркировки);
	
	ПараметрыРазбораКодаМаркировки = Новый Структура;
	ПараметрыРазбораКодаМаркировки.Вставить("КодМаркировки",         КодМаркировки);
	ПараметрыРазбораКодаМаркировки.Вставить("НачинаетсяСоСкобки",    НачинаетсяСоСкобки);
	ПараметрыРазбораКодаМаркировки.Вставить("СодержитGS1",           СодержитGS1);
	ПараметрыРазбораКодаМаркировки.Вставить("РезультатРазбора",      РезультатРазбора);
	ПараметрыРазбораКодаМаркировки.Вставить("ДлинаКодаМаркировки",   ДлинаКодаМаркировки);
	ПараметрыРазбораКодаМаркировки.Вставить("ФильтрПоВидуПродукции", ФильтрПоВидуПродукции);
	
	НайденныеШаблоны = ШаблонРазбораКодаМаркировки(ПараметрыРазбораКодаМаркировки, Настройки);
	
	Результат = Новый Массив;
	
	Для Каждого ШаблонКодаМаркировки Из НайденныеШаблоны Цикл
		
		ДанныеРезультата = КодМаркировкиСоответствуетШаблону(ПараметрыРазбораКодаМаркировки, Настройки, ШаблонКодаМаркировки);
		
		Если ДанныеРезультата = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		Результат.Добавить(ДанныеРезультата);
		
	КонецЦикла;
	
	Если Результат.Количество() = 0 Тогда
		
		ДанныеРезультата = Неопределено;
		Если ЭтоНеформализованныйКодМаркировки(ПараметрыРазбораКодаМаркировки, Настройки, ДанныеРезультата) Тогда
			Возврат ДанныеРезультата;
		КонецЕсли;
		
		ПримечаниеКРезультатуРазбора.ИдентификаторОшибки = ИдентификаторыОшибок.КодМаркировкиНеСоответствуетНиОдномуШаблону;
		ПримечаниеКРезультатуРазбора.ТекстОшибки         = НСтр("ru = 'Код маркировки не соответствует ни одному шаблону.'");
		Возврат Неопределено;
		
	КонецЕсли;
	
	РезультатПоФильтру = Новый Массив;
	
	Для Каждого ДанныеРезультата Из Результат Цикл
		
		ВидыПродукцииПоФильтру = ВидыПродукцииПоФильтру(ФильтрПоВидуПродукции, ДанныеРезультата.ВидыПродукции);
		
		Если ВидыПродукцииПоФильтру.Количество() = 0 Тогда
			Продолжить;
		КонецЕсли;
		
		ДанныеРезультата.ВидыПродукции = ВидыПродукцииПоФильтру;
		
		РезультатПоФильтру.Добавить(ДанныеРезультата);
		
	КонецЦикла;
	
	Если РезультатПоФильтру.Количество() = 1 Тогда
		
		Возврат РезультатПоФильтру[0];
		
	ИначеЕсли РезультатПоФильтру.Количество() > 1 Тогда
		
		ДанныеРезультата = Неопределено;
		Если ОбработатьРезультатНесколькихШаблонов(РезультатПоФильтру, ДанныеРезультата) Тогда
			Возврат ДанныеРезультата;
		КонецЕсли;
		
		// К примеру логистические укаковки длиной 18 символов для ЕГАИС и ИСМП
		ПримечаниеКРезультатуРазбора.ИдентификаторОшибки = ИдентификаторыОшибок.КодМаркировкиСоответствуетНесколькимШаблонам;
		ПримечаниеКРезультатуРазбора.ТекстОшибки         = НСтр("ru = 'Код маркировки соответствует нескольким шаблонам'");
		ПримечаниеКРезультатуРазбора.РезультатРазбора    = РезультатПоФильтру;
		Возврат Неопределено;
		
	Иначе
		
		ПримечаниеКРезультатуРазбора.ИдентификаторОшибки = ИдентификаторыОшибок.КодМаркировкиСоответствуетДругимВидамПродукции;
		ПримечаниеКРезультатуРазбора.ТекстОшибки         = НСтр("ru = 'Код маркировки соответствует другим видам продукции'");
		ПримечаниеКРезультатуРазбора.РезультатРазбора    = Результат;
		Возврат Неопределено;
		
	КонецЕсли;
	
КонецФункции

Функция КодМаркировкиСоответствуетШаблону(ПараметрыРазбораКодаМаркировки, Настройки, ШаблонКодаМаркировки) Экспорт
	
	ДанныеШаблона = Настройки.ШаблоныИОписанияВидовПродукции[ШаблонКодаМаркировки.Шаблон];
	
	СоставКодаМаркировки = СлужебныеПроцедурыИФункцииИСМПТККлиентСервер.СкопироватьРекурсивно(ДанныеШаблона.СоставКодаМаркировки);
	
	ПараметрыОписанияКодаМаркировки = Новый Структура;
	ПараметрыОписанияКодаМаркировки.Вставить("ОписаниеКодаМаркировки",      ДанныеШаблона.ОписаниеКодаМаркировки);
	ПараметрыОписанияКодаМаркировки.Вставить("ОбщиеМодулиШтрихкодирования", ДанныеШаблона.ОбщиеМодулиШтрихкодирования);
	ПараметрыОписанияКодаМаркировки.Вставить("Шаблон",                      ШаблонКодаМаркировки.Шаблон);
	ПараметрыОписанияКодаМаркировки.Вставить("ТипШтрихкода",                ШаблонКодаМаркировки.ТипШтрихкода);
	ПараметрыОписанияКодаМаркировки.Вставить("ВидУпаковки",                 ШаблонКодаМаркировки.ВидУпаковки);
	
	ЗначенияЭлементовКМ = Новый Соответствие;
	
	Если Не КодМаркировкиСоответствуетОписанию(ПараметрыРазбораКодаМаркировки, ПараметрыОписанияКодаМаркировки, СоставКодаМаркировки, ЗначенияЭлементовКМ) Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	ДанныеРезультата = НовыйРезультатРазбораКодаМаркировки();
	ДанныеРезультата.КодМаркировки        = ПараметрыРазбораКодаМаркировки.КодМаркировки;
	ДанныеРезультата.ТипШтрихкода         = ШаблонКодаМаркировки.ТипШтрихкода;
	ДанныеРезультата.ВидУпаковки          = ШаблонКодаМаркировки.ВидУпаковки;
	ДанныеРезультата.ВидыПродукции        = ДанныеШаблона.ВидыПродукции;
	ДанныеРезультата.СоставКодаМаркировки = СоставКодаМаркировки;
	
	ВидПродукцииДляНормализации = Неопределено;
	Если ДанныеШаблона.ВидыПродукции.Количество() = 1 Тогда
		ВидПродукцииДляНормализации = ДанныеШаблона.ВидыПродукции[0];
	ИначеЕсли ПараметрыРазбораКодаМаркировки.ФильтрПоВидуПродукции.Использовать Тогда
		ВидПродукцииНайден = Ложь;
		Для Каждого ТекущийВидПродукции Из ПараметрыРазбораКодаМаркировки.ФильтрПоВидуПродукции.ВидыПродукции Цикл
			Если ДанныеШаблона.ВидыПродукции.Найти(ТекущийВидПродукции) = Неопределено Тогда
				Продолжить;
			КонецЕсли;
			Если ВидПродукцииНайден Тогда
				ВидПродукцииДляНормализации = Неопределено;
				Прервать;
			КонецЕсли;
			ВидПродукцииДляНормализации = ТекущийВидПродукции;
			ВидПродукцииНайден = Истина;
		КонецЦикла;
	КонецЕсли;
	
	НормализованныйКодМаркировки = НормализоватьКодМаркировки(ДанныеРезультата, ВидПродукцииДляНормализации);
	
	ДанныеРезультата.НормализованныйКодМаркировки = НормализованныйКодМаркировки;
	
	Возврат ДанныеРезультата;
	
КонецФункции

Функция НастройкиРазбораКодаМаркировки() Экспорт
	
	//Добавим только табак
	ДоступныеВидыПродукции = Новый Массив;
	ДоступныеВидыПродукции.Добавить(Перечисления.ВидыПродукцииИСМПТК.Табачная);
	
	НастройкиРазбораКодаМаркировки = ИнициализацияНастроекРазбораКодаМаркировки();
	НастройкиРазбораКодаМаркировки.ДоступныеВидыПродукции = ДоступныеВидыПродукции;
	НастройкиРазбораКодаМаркировки.Алфавит                = ДопустимыеСимволыВКодеМаркировки();
	
	Если ДоступныеВидыПродукции.Количество() = 0 Тогда
		Возврат НастройкиРазбораКодаМаркировки;
	КонецЕсли;
	
	ИмяОбщегоМодуля = "ШтрихкодированиеИСМПТКСлужебный";
	ДанныеОбщегоМодуляИСМП = Новый Структура("Имя, ОбщийМодуль", ИмяОбщегоМодуля, ОбщегоНазначения.ОбщийМодуль(ИмяОбщегоМодуля));
		
	ДанныеОбщихМодулей                = Новый Соответствие;
	ДанныеОбщихМодулейПоВидуПродукции = Новый Соответствие;
	
	Для Каждого ВидПродукции Из ДоступныеВидыПродукции Цикл
		
		ДанныеОбщегоМодуля = ДанныеОбщегоМодуляИСМП;
		
		Если ДанныеОбщихМодулей[ДанныеОбщегоМодуля.Имя] = Неопределено Тогда
			ДанныеОбщихМодулей[ДанныеОбщегоМодуля.Имя] = ДанныеОбщихМодулей;
			НастройкиРазбораКодаМаркировки.ОбщиеМодули.Добавить(ДанныеОбщегоМодуля);
		КонецЕсли;
		
		ДанныеОбщегоМодуля.ОбщийМодуль.ДополнитьНастройкиРазбораКодаМаркировки(НастройкиРазбораКодаМаркировки, ВидПродукции, ДанныеОбщегоМодуля);
		
		ДанныеОбщихМодулейПоВидуПродукции[ВидПродукции] = ДанныеОбщегоМодуля;
		
	КонецЦикла;
	
	ИменаКолонок                 = Новый Массив;
	ИменаКолонокБезВидаПродукции = Новый Массив;
	Для Каждого КолонкаТаблици Из НастройкиРазбораКодаМаркировки.ШаблоныКодовМаркировкиПоВидамПродукции.Колонки Цикл
		ИменаКолонок.Добавить(КолонкаТаблици.Имя);
		Если КолонкаТаблици.Имя <> "ВидПродукции" Тогда
			ИменаКолонокБезВидаПродукции.Добавить(КолонкаТаблици.Имя);
		КонецЕсли;
	КонецЦикла;
	
	// Сворачиваем строки что бы исключить дубли
	ИменаКолонокСтрокой = СтрСоединить(ИменаКолонок, ",");
	НастройкиРазбораКодаМаркировки.ШаблоныКодовМаркировкиПоВидамПродукции.Свернуть(ИменаКолонокСтрокой);
	
	// Сворачиваем строки без учета Вида продукции
	ИменаКолонокСтрокой = СтрСоединить(ИменаКолонокБезВидаПродукции, ",");
	ШаблоныКодовМаркировки = НастройкиРазбораКодаМаркировки.ШаблоныКодовМаркировкиПоВидамПродукции.Скопировать(, ИменаКолонокСтрокой);
	ШаблоныКодовМаркировки.Свернуть(ИменаКолонокСтрокой);
	
	ШаблоныКодовМаркировки.Сортировать("ДлинаСоСкобкой, Длина");
	
	НастройкиРазбораКодаМаркировки.ШаблоныКодовМаркировки = ШаблоныКодовМаркировки;
	
	ОпределитьОбщиеМодулиВШаблонахИОписанияхВидовПродукции(НастройкиРазбораКодаМаркировки, ДанныеОбщихМодулейПоВидуПродукции);
	
	Возврат НастройкиРазбораКодаМаркировки;
	
КонецФункции

Функция ОписанияШаблоновКодаМаркировки(ОписаниеЭлементовКМ, ШаблоныСтрокой) Экспорт
	
	СписокОписанийШаблонов = Новый Массив;
	
	Для Каждого ШаблонСтрокой Из ШаблоныСтрокой Цикл
		
		ОписаниеШаблонаКМ = Новый Массив;
		
		СписокЭлементовКМ = СтрРазделить(ШаблонСтрокой, "+", Ложь);
		Для Каждого ИмяЭлементаКМ Из СписокЭлементовКМ Цикл
			
			ОписаниеЭлементаКМ = ОписаниеЭлементовКМ[СокрЛП(ИмяЭлементаКМ)];
			
			ОписаниеШаблонаКМ.Добавить(ОписаниеЭлементаКМ);
			
		КонецЦикла;
		
		СписокОписанийШаблонов.Добавить(ОписаниеШаблонаКМ);
		
	КонецЦикла;
	
	Возврат СписокОписанийШаблонов;
	
КонецФункции

// Формирует описание элемента для кода маркировки
// 
// Параметры:
// 	Код - Строка - Код элемента.
// 	Имя - Строка - Имя элемента.
// 	КоличествоЗнаков - Число - Число знаков.
// 	АлфавитДопустимыхСимволов - Строка - Если заполнено, то определяет какими символами может быть заполнено значение элемента.
// Возвращаемое значение:
// 	Структура - описание элемента для кода маркировки:
// * Код - Строка - Код элемента.
// * Имя - Строка - Имя элемента.
// * Длина - Число - Число знаков.
// * Алфавит - Строка - Если заполнено, то определяет какими символами может быть заполнено значение элемента.
Функция ОписаниеЭлементаКодаМаркировки(Код, Имя, КоличествоЗнаков, АлфавитДопустимыхСимволов = "") Экспорт
	ОписаниеКода = Новый Структура;
	ОписаниеКода.Вставить("Код",     Код);
	ОписаниеКода.Вставить("Имя",     Имя);
	ОписаниеКода.Вставить("Длина",   КоличествоЗнаков);
	ОписаниеКода.Вставить("Алфавит", АлфавитДопустимыхСимволов);
	Возврат ОписаниеКода;
КонецФункции

// Возвращает структуру из строк с допустимыми символами
// 
// Возвращаемое значение:
// 	Структура - допустимые символы в коде маркировки:
// * БуквыЦифрыЗнаки - Строка - "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!”%&’()*+,-./_:;=<>?"
// * БуквыЦифрыЗнакиМРЦ - Строка - "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!""%&'*+-./_,:;=<>?()"
// * Цифры - Строка - "0123456789"
Функция ДопустимыеСимволыВКодеМаркировки() Экспорт
	Алфавит = Новый Структура;
	Алфавит.Вставить("БуквыЦифры",         "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789");
	Алфавит.Вставить("БуквыЦифрыЗнаки",    "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!”""%&’'()*+,-./_:;=<>?");
	Алфавит.Вставить("БуквыЦифрыЗнакиМРЦ", "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!""%&'*+-./_,:;=<>?");
	Алфавит.Вставить("Цифры",              "0123456789");
	Возврат Алфавит;
КонецФункции

Функция ТипШтрихкодаИВидУпаковки() Экспорт
	Данные = Новый Структура;
	Данные.Вставить("ТипШтрихкода", Перечисления.ТипыШтрихкодовИСМПТК.ПустаяСсылка());
	Данные.Вставить("ВидУпаковки",  Перечисления.ВидыУпаковокИСМПТК.ПустаяСсылка());
	Возврат Данные;
КонецФункции

Функция НовыйРезультатРазбораКодаМаркировки() Экспорт
	Результат = Новый Структура;
	Результат.Вставить("КодМаркировки",                "");
	Результат.Вставить("НормализованныйКодМаркировки", "");
	Результат.Вставить("ТипШтрихкода",                 Перечисления.ТипыШтрихкодовИСМПТК.ПустаяСсылка());
	Результат.Вставить("ВидУпаковки",                  Перечисления.ВидыУпаковокИСМПТК.ПустаяСсылка());
	Результат.Вставить("ВидыПродукции",                Неопределено);
	Результат.Вставить("СоставКодаМаркировки",         Неопределено);
	Возврат Результат;
КонецФункции

// Инициализировать параметры нормализации кода маркировки
// 
// Возвращаемое значение:
// 	Структура - Описание:
// * ВключатьМРЦ - Булево - Признак включения МРЦ
// * ИмяСвойстваКодМаркировки - Строка - Имя свойства для получения кода маркировки
Функция ПараметрыНормализацииКодаМаркировки() Экспорт
	
	ПараметрыНормализации = Новый Структура;
	ПараметрыНормализации.Вставить("ИмяСвойстваКодМаркировки", "КодМаркировки");
	ПараметрыНормализации.Вставить("НачинаетсяСоСкобки",        Истина);
	ПараметрыНормализации.Вставить("ВключатьМРЦ",               Истина); // Табак
	ПараметрыНормализации.Вставить("ВключатьСрокГодности",      Истина); // Молочная продукция
	
	Возврат ПараметрыНормализации;
	
КонецФункции

Функция НормализоватьКодМаркировки(РезультатРазбора, ВидПродукции, ПараметрыНормализации = Неопределено) Экспорт
	
	Если ПараметрыНормализации = Неопределено Тогда
		ПараметрыНормализации = ПараметрыНормализацииКодаМаркировки();
	КонецЕсли;
	
	Если ВидПродукции = ПредопределенноеЗначение("Перечисление.ВидыПродукцииИСМПТК.Алкогольная") Тогда
		
		Возврат РезультатРазбора[ПараметрыНормализации.ИмяСвойстваКодМаркировки];
	
	ИначеЕсли ВидПродукции = ПредопределенноеЗначение("Перечисление.ВидыПродукцииИСМПТК.Табачная")
		И РезультатРазбора.ВидУпаковки = ПредопределенноеЗначение("Перечисление.ВидыУпаковокИСМПТК.Логистическая")
		И РезультатРазбора.ТипШтрихкода = ПредопределенноеЗначение("Перечисление.ТипыШтрихкодовИСМПТК.GS1_128") Тогда
		
		Если ПараметрыНормализации.НачинаетсяСоСкобки Тогда
			Возврат РезультатРазбора[ПараметрыНормализации.ИмяСвойстваКодМаркировки];
		КонецЕсли;
		
		Возврат ШтрихкодированиеИСМПТККлиентСервер.КодМаркировкиБезСкобок(
			РезультатРазбора[ПараметрыНормализации.ИмяСвойстваКодМаркировки]);
		
	ИначеЕсли РезультатРазбора.ВидУпаковки = ПредопределенноеЗначение("Перечисление.ВидыУпаковокИСМПТК.Логистическая") Тогда
		
		Если ПараметрыНормализации.НачинаетсяСоСкобки Тогда
			Возврат СтрШаблон("(00)%1", Прав(РезультатРазбора[ПараметрыНормализации.ИмяСвойстваКодМаркировки], 18));
		КонецЕсли;
		
		Если ВидПродукции = ПредопределенноеЗначение("Перечисление.ВидыПродукцииИСМПТК.Табачная") Тогда
			Возврат СтрШаблон("00%1", Прав(РезультатРазбора[ПараметрыНормализации.ИмяСвойстваКодМаркировки], 18));
		КонецЕсли;
		
		Возврат Прав(РезультатРазбора[ПараметрыНормализации.ИмяСвойстваКодМаркировки], 18);
		
	КонецЕсли;
	
	Если ВидПродукции = ПредопределенноеЗначение("Перечисление.ВидыПродукцииИСМПТК.Табачная") Тогда
		
		ВключатьМРЦ = ПараметрыНормализации.ВключатьМРЦ И РезультатРазбора.СоставКодаМаркировки.ВключаетМРЦ;
		
		Если РезультатРазбора.ВидУпаковки = ПредопределенноеЗначение("Перечисление.ВидыУпаковокИСМПТК.Потребительская") Тогда
			
			Если ВключатьМРЦ Тогда
				
				Возврат СтрШаблон("%1%2%3",
					РезультатРазбора.СоставКодаМаркировки.GTIN,
					РезультатРазбора.СоставКодаМаркировки.СерийныйНомер,
					РезультатРазбора.СоставКодаМаркировки.МРЦСтрокой);
				
			Иначе
				
				Возврат СтрШаблон("%1%2",
					РезультатРазбора.СоставКодаМаркировки.GTIN,
					РезультатРазбора.СоставКодаМаркировки.СерийныйНомер);
				
			КонецЕсли;
			
		Иначе
			
			Если ВключатьМРЦ Тогда
				
				Если ПараметрыНормализации.НачинаетсяСоСкобки Тогда
					Возврат СтрШаблон("(01)%1(21)%2(8005)%3",
						РезультатРазбора.СоставКодаМаркировки.GTIN,
						РезультатРазбора.СоставКодаМаркировки.СерийныйНомер,
						РезультатРазбора.СоставКодаМаркировки.МРЦСтрокой);
				КонецЕсли;
				
				ЭлементыКМ = Новый Массив;
				ЭлементыКМ.Добавить("01");
				ЭлементыКМ.Добавить(РезультатРазбора.СоставКодаМаркировки.GTIN);
				ЭлементыКМ.Добавить("21");
				ЭлементыКМ.Добавить(РезультатРазбора.СоставКодаМаркировки.СерийныйНомер);
				ЭлементыКМ.Добавить("8005");
				ЭлементыКМ.Добавить(РезультатРазбора.СоставКодаМаркировки.МРЦСтрокой);
				Возврат СтрСоединить(ЭлементыКМ);
				
			Иначе
				
				Если ПараметрыНормализации.НачинаетсяСоСкобки Тогда
					Возврат СтрШаблон("(01)%1(21)%2",
						РезультатРазбора.СоставКодаМаркировки.GTIN,
						РезультатРазбора.СоставКодаМаркировки.СерийныйНомер);
				КонецЕсли;
				
				ЭлементыКМ = Новый Массив;
				ЭлементыКМ.Добавить("01");
				ЭлементыКМ.Добавить(РезультатРазбора.СоставКодаМаркировки.GTIN);
				ЭлементыКМ.Добавить("21");
				ЭлементыКМ.Добавить(РезультатРазбора.СоставКодаМаркировки.СерийныйНомер);
				Возврат СтрСоединить(ЭлементыКМ);
				
			КонецЕсли;
			
			
		КонецЕсли;
		
	ИначеЕсли ВидПродукции = ПредопределенноеЗначение("Перечисление.ВидыПродукцииИСМПТК.Обувная") 
		ИЛИ ВидПродукции = ПредопределенноеЗначение("Перечисление.ВидыПродукцииИСМПТК.ЛекарственныеПрепараты")
		ИЛИ ВидПродукции = ПредопределенноеЗначение("Перечисление.ВидыПродукцииИСМПТК.ЛегкаяПромышленность")
		ИЛИ ВидПродукции = ПредопределенноеЗначение("Перечисление.ВидыПродукцииИСМПТК.БезалкогольныеНапитки") Тогда
		
		ВключатьКодТНВЭД = РезультатРазбора.СоставКодаМаркировки.Свойство("КодТНВЭД")
		                 И ЗначениеЗаполнено(РезультатРазбора.СоставКодаМаркировки.КодТНВЭД);
		
		Если ВключатьКодТНВЭД Тогда
			
			Если ПараметрыНормализации.НачинаетсяСоСкобки Тогда
				Возврат СтрШаблон("(01)%1(21)%2(240)%3",
					РезультатРазбора.СоставКодаМаркировки.GTIN,
					РезультатРазбора.СоставКодаМаркировки.СерийныйНомер,
					РезультатРазбора.СоставКодаМаркировки.КодТНВЭД);
			КонецЕсли;
			
			ЭлементыКМ = Новый Массив;
			ЭлементыКМ.Добавить("01");
			ЭлементыКМ.Добавить(РезультатРазбора.СоставКодаМаркировки.GTIN);
			ЭлементыКМ.Добавить("21");
			ЭлементыКМ.Добавить(РезультатРазбора.СоставКодаМаркировки.СерийныйНомер);
			ЭлементыКМ.Добавить("240");
			ЭлементыКМ.Добавить(РезультатРазбора.СоставКодаМаркировки.КодТНВЭД);
			Возврат СтрСоединить(ЭлементыКМ);
			
		Иначе
			
			Если ПараметрыНормализации.НачинаетсяСоСкобки Тогда
				Возврат СтрШаблон("(01)%1(21)%2",
					РезультатРазбора.СоставКодаМаркировки.GTIN,
					РезультатРазбора.СоставКодаМаркировки.СерийныйНомер);
			КонецЕсли;
			
			ЭлементыКМ = Новый Массив;
			ЭлементыКМ.Добавить("01");
			ЭлементыКМ.Добавить(РезультатРазбора.СоставКодаМаркировки.GTIN);
			ЭлементыКМ.Добавить("21");
			ЭлементыКМ.Добавить(РезультатРазбора.СоставКодаМаркировки.СерийныйНомер);
			Возврат СтрСоединить(ЭлементыКМ);
			
		КонецЕсли;
		
	ИначеЕсли ВидПродукции = ПредопределенноеЗначение("Перечисление.ВидыПродукцииИСМПТК.МолочнаяПродукция") Тогда
		
		ВключатьСрокГодности = ПараметрыНормализации.ВключатьСрокГодности
		                     И РезультатРазбора.СоставКодаМаркировки.Свойство("ГоденДо")
		                     И ЗначениеЗаполнено(РезультатРазбора.СоставКодаМаркировки.ГоденДо);
		
		Если ВключатьСрокГодности Тогда
			
			Если РезультатРазбора.СоставКодаМаркировки.Скоропортящаяся Тогда
				КодЭлемента = "7003";
				ФорматДаты  = "ДФ=yyMMddHHmm;"; // Формат: YYMMDDHHMM
			Иначе
				КодЭлемента = "17";
				ФорматДаты  = "ДФ=yyMMdd;"; // Формат: YYMMDD
			КонецЕсли;
			
			ЗначениеЭлемента = Формат(РезультатРазбора.СоставКодаМаркировки.ГоденДо, ФорматДаты);
			
			Если ПараметрыНормализации.НачинаетсяСоСкобки Тогда
				Возврат СтрШаблон("(01)%1(21)%2(%3)%4",
					РезультатРазбора.СоставКодаМаркировки.GTIN,
					РезультатРазбора.СоставКодаМаркировки.СерийныйНомер,
					КодЭлемента,
					ЗначениеЭлемента);
			КонецЕсли;
			
			ЭлементыКМ = Новый Массив;
			ЭлементыКМ.Добавить("01");
			ЭлементыКМ.Добавить(РезультатРазбора.СоставКодаМаркировки.GTIN);
			ЭлементыКМ.Добавить("21");
			ЭлементыКМ.Добавить(РезультатРазбора.СоставКодаМаркировки.СерийныйНомер);
			ЭлементыКМ.Добавить(КодЭлемента);
			ЭлементыКМ.Добавить(ЗначениеЭлемента);
			Возврат СтрСоединить(ЭлементыКМ);
			
		Иначе
			
			Если ПараметрыНормализации.НачинаетсяСоСкобки Тогда
				Возврат СтрШаблон("(01)%1(21)%2",
					РезультатРазбора.СоставКодаМаркировки.GTIN,
					РезультатРазбора.СоставКодаМаркировки.СерийныйНомер);
			КонецЕсли;
			
			ЭлементыКМ = Новый Массив;
			ЭлементыКМ.Добавить("01");
			ЭлементыКМ.Добавить(РезультатРазбора.СоставКодаМаркировки.GTIN);
			ЭлементыКМ.Добавить("21");
			ЭлементыКМ.Добавить(РезультатРазбора.СоставКодаМаркировки.СерийныйНомер);
			Возврат СтрСоединить(ЭлементыКМ);
			
		КонецЕсли;
				
	КонецЕсли;
	
	Если ПараметрыНормализации.НачинаетсяСоСкобки Тогда
		Возврат СтрШаблон("(01)%1(21)%2",
			РезультатРазбора.СоставКодаМаркировки.GTIN,
			РезультатРазбора.СоставКодаМаркировки.СерийныйНомер);
	КонецЕсли;
	
	ЭлементыКМ = Новый Массив;
	ЭлементыКМ.Добавить("01");
	ЭлементыКМ.Добавить(РезультатРазбора.СоставКодаМаркировки.GTIN);
	ЭлементыКМ.Добавить("21");
	ЭлементыКМ.Добавить(РезультатРазбора.СоставКодаМаркировки.СерийныйНомер);
	Возврат СтрСоединить(ЭлементыКМ);
	
КонецФункции

Функция ИдентификаторыОшибокРазобраКодаМаркировки() Экспорт
	ИдентификаторОшибки = Новый Структура;
	ИдентификаторОшибки.Вставить("УчетМаркируемойПродукцииНеВедется",              "УчетМаркируемойПродукцииНеВедется");
	ИдентификаторОшибки.Вставить("ДанныеДляРазбораНекорректны",                    "ДанныеДляРазбораНекорректны");
	ИдентификаторОшибки.Вставить("КодМаркировкиНеСоответствуетНиОдномуШаблону",    "КодМаркировкиНеСоответствуетНиОдномуШаблону");
	ИдентификаторОшибки.Вставить("КодМаркировкиСоответствуетНесколькимШаблонам",   "КодМаркировкиСоответствуетНесколькимШаблонам");
	ИдентификаторОшибки.Вставить("КодМаркировкиСоответствуетДругимВидамПродукции", "КодМаркировкиСоответствуетДругимВидамПродукции");
	Возврат ИдентификаторОшибки;
КонецФункции


Функция ШаблонРазбораКодаМаркировки(ПараметрыРазбораКодаМаркировки, Настройки)
	
	ИмяКолонкиПоиска = "Длина";
	
	Отбор = Новый Структура;
	
	Если ПараметрыРазбораКодаМаркировки.НачинаетсяСоСкобки Тогда
		
		ИмяКолонкиПоиска = "ДлинаСоСкобкой";
		
	ИначеЕсли ПараметрыРазбораКодаМаркировки.СодержитGS1 Тогда
		
		ИмяКолонкиПоиска = "ДлинаСоСкобкой";
		
		КоличествоЭлементов = ПараметрыРазбораКодаМаркировки.РезультатРазбора.ДанныеШтрихкода.Количество();
		
		Отбор.Вставить("КоличествоЭлементов", КоличествоЭлементов);
		
	КонецЕсли;
	
	Отбор.Вставить(ИмяКолонкиПоиска, ПараметрыРазбораКодаМаркировки.ДлинаКодаМаркировки);
	
	НайденныеШаблоны = Настройки.ШаблоныКодовМаркировки.НайтиСтроки(Отбор);
	
	Возврат НайденныеШаблоны;
	
КонецФункции

Функция ЭтоНеформализованныйКодМаркировки(ПараметрыРазбораКодаМаркировки, Настройки, ДанныеРезультата)
	
	Для Каждого ДанныеОбщегоМодуля Из Настройки.ОбщиеМодули Цикл
		ОбщийМодуль = ДанныеОбщегоМодуля.ОбщийМодуль;
		Если ОбщийМодуль.ЭтоНеФормализованныйКодМаркировки(ПараметрыРазбораКодаМаркировки, Настройки, ДанныеРезультата) Тогда
			Возврат Истина;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Ложь;
	
КонецФункции

Функция ОбработатьРезультатНесколькихШаблонов(Результат, ДанныеРезультата)
	
	// Для табака может подойти два шаблона: GTIN+Серия+КодПроверки и GTIN+Серия+МРЦСтрокой+КодПроверки, берем с МРЦ
	Если Результат.Количество() = 2
		И Результат[0].ВидыПродукции[0] = Перечисления.ВидыПродукцииИСМПТК.Табачная
		И Результат[1].ВидыПродукции[0] = Перечисления.ВидыПродукцииИСМПТК.Табачная Тогда
		
		Если Результат[0].СоставКодаМаркировки.ВключаетМРЦ Тогда
			ДанныеРезультата = Результат[0];
			Возврат Истина;
		ИначеЕсли Результат[1].СоставКодаМаркировки.ВключаетМРЦ Тогда
			ДанныеРезультата = Результат[1];
			Возврат Истина;
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат Ложь;
	
КонецФункции

Функция ВидыПродукцииПоФильтру(ФильтрПоВидуПродукции, ВидыПродукции)
	
	Если Не ФильтрПоВидуПродукции.Использовать Тогда
		Возврат Новый ФиксированныйМассив(ВидыПродукции);
	КонецЕсли;
	
	Результат = Новый Массив;
	Для Каждого ВидПродукции Из ФильтрПоВидуПродукции.ВидыПродукции Цикл
		Если ВидыПродукции.Найти(ВидПродукции) <> Неопределено Тогда
			Результат.Добавить(ВидПродукции);
		КонецЕсли;
	КонецЦикла;
	
	Возврат Новый ФиксированныйМассив(Результат);
	
КонецФункции

Функция КодМаркировкиСоответствуетОписанию(ПараметрыКодаМаркировки, ПараметрыОписанияКодаМаркировки, СоставКодаМаркировки, ЗначенияЭлементовКМ)
	
	КодМаркировки      = ПараметрыКодаМаркировки.КодМаркировки;
	НачинаетсяСоСкобки = ПараметрыКодаМаркировки.НачинаетсяСоСкобки Или ПараметрыКодаМаркировки.СодержитGS1;
	
	КоличествоДопСимволов = ?(НачинаетсяСоСкобки, 2, 0); // с учетом символов "(" и ")"
	
	Для Каждого ОписаниеЭлементаКМ Из ПараметрыОписанияКодаМаркировки.ОписаниеКодаМаркировки Цикл
		
		ИдентификаторСДопСимволами = Лев(КодМаркировки, СтрДлина(ОписаниеЭлементаКМ.Код) + КоличествоДопСимволов);
		Если НачинаетсяСоСкобки Тогда
			ЭтоПравильныйИдентификатор = (ИдентификаторСДопСимволами = СтрШаблон("(%1)", ОписаниеЭлементаКМ.Код));
		Иначе
			ЭтоПравильныйИдентификатор = (ИдентификаторСДопСимволами = ОписаниеЭлементаКМ.Код);
		КонецЕсли;
		Если Не ЭтоПравильныйИдентификатор Тогда
			Возврат Ложь;
		КонецЕсли;
		Значение = Сред(КодМаркировки, СтрДлина(ОписаниеЭлементаКМ.Код) + КоличествоДопСимволов + 1, ОписаниеЭлементаКМ.Длина);
		
		Если ЗначениеЗаполнено(ОписаниеЭлементаКМ.Алфавит)
			И Не ШтрихкодированиеИСМПТККлиентСервер.КодСоответствуетАлфавиту(Значение, ОписаниеЭлементаКМ.Алфавит) Тогда
			Возврат Ложь;
		КонецЕсли;
		
		Если Не ЭлементКодаМаркировкиСоответствуетОписанию(Значение, ОписаниеЭлементаКМ, СоставКодаМаркировки, ПараметрыОписанияКодаМаркировки) Тогда
			Возврат Ложь;
		КонецЕсли;
		
		ЗначенияЭлементовКМ[ОписаниеЭлементаКМ.Имя] = Значение;
		
		КодМаркировки = Сред(КодМаркировки, СтрДлина(ОписаниеЭлементаКМ.Код) + КоличествоДопСимволов + ОписаниеЭлементаКМ.Длина + 1);
		Если КодМаркировки = "" Тогда
			Прервать;
		КонецЕсли;
		
	КонецЦикла;
	
	Если ЗначениеЗаполнено(КодМаркировки) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

Функция ЭлементКодаМаркировкиСоответствуетОписанию(Знач Значение, ОписаниеЭлементаКМ, СоставКодаМаркировки, ПараметрыОписанияКодаМаркировки)
	
	Для Каждого ДанныеОбщегоМодуля Из ПараметрыОписанияКодаМаркировки.ОбщиеМодулиШтрихкодирования Цикл
		Если Не ДанныеОбщегоМодуля.ОбщийМодуль.ЭлементКодаМаркировкиСоответствуетОписанию(Значение, ОписаниеЭлементаКМ, СоставКодаМаркировки, ПараметрыОписанияКодаМаркировки) Тогда
			Возврат Ложь;
		КонецЕсли;
		ДанныеОбщегоМодуля.ОбщийМодуль.ПреобразоватьЗначениеДляЗаполненияСоставаКодаМаркировки(ПараметрыОписанияКодаМаркировки, СоставКодаМаркировки, ОписаниеЭлементаКМ, Значение);
	КонецЦикла;
	
	ЗаполнитьСоставКодаМаркировки(СоставКодаМаркировки, ОписаниеЭлементаКМ, Значение);
	
	Возврат Истина;
	
КонецФункции

Процедура ЗаполнитьСоставКодаМаркировки(СоставКодаМаркировки, ОписаниеЭлементаКМ, Значение) Экспорт
	
	Если СоставКодаМаркировки = Неопределено Или Не СоставКодаМаркировки.Свойство(ОписаниеЭлементаКМ.Имя) Тогда
		Возврат;
	КонецЕсли;
	
	СоставКодаМаркировки[ОписаниеЭлементаКМ.Имя] = Значение;
	
КонецПроцедуры

Функция ИнициализацияНастроекРазбораКодаМаркировки()
	
	ШаблоныКодовМаркировки = Новый ТаблицаЗначений;
	ШаблоныКодовМаркировки.Колонки.Добавить("Шаблон",              Новый ОписаниеТипов("Строка"));
	ШаблоныКодовМаркировки.Колонки.Добавить("ТипШтрихкода",        Новый ОписаниеТипов("ПеречислениеСсылка.ТипыШтрихкодовИСМПТК"));
	ШаблоныКодовМаркировки.Колонки.Добавить("ВидУпаковки",         Новый ОписаниеТипов("ПеречислениеСсылка.ВидыУпаковокИСМПТК"));
	ШаблоныКодовМаркировки.Колонки.Добавить("КоличествоЭлементов", Новый ОписаниеТипов("Число"));
	ШаблоныКодовМаркировки.Колонки.Добавить("НачинаетсяСоСкобки",  Новый ОписаниеТипов("Булево"));
	ШаблоныКодовМаркировки.Колонки.Добавить("Длина",               Новый ОписаниеТипов("Число"));
	ШаблоныКодовМаркировки.Колонки.Добавить("ДлинаСоСкобкой",      Новый ОписаниеТипов("Число"));
	ШаблоныКодовМаркировки.Колонки.Добавить("КодПервогоЭлемента",  Новый ОписаниеТипов("Строка"));
	
	ШаблоныКодовМаркировкиПоВидамПродукции = ШаблоныКодовМаркировки.СкопироватьКолонки();
	ШаблоныКодовМаркировкиПоВидамПродукции.Колонки.Добавить("ВидПродукции", Новый ОписаниеТипов("ПеречислениеСсылка.ВидыПродукцииИСМПТК"));
	
	Настройки = Новый Структура;
	Настройки.Вставить("ДоступныеВидыПродукции",                 Новый Массив);
	Настройки.Вставить("Алфавит",                                Новый Структура);
	Настройки.Вставить("ОбщиеМодули",                            Новый Массив);
	Настройки.Вставить("ШаблоныКодовМаркировкиПоВидамПродукции", ШаблоныКодовМаркировкиПоВидамПродукции);
	Настройки.Вставить("ШаблоныКодовМаркировки",                 ШаблоныКодовМаркировки);
	Настройки.Вставить("ШаблоныИОписанияВидовПродукции",         Новый Соответствие);
	
	Возврат Настройки;
	
КонецФункции

Процедура ДобавитьОписаниеШаблонаКодаМаркировкиВидаПродукции(НастройкиРазбораКодаМаркировки, НастройкаОписанияКодаМаркировки) Экспорт
	
	ВидПродукции                   = НастройкаОписанияКодаМаркировки.ВидПродукции;
	ОписаниеШаблонаКодаМаркировки  = НастройкаОписанияКодаМаркировки.ОписаниеШаблонаКодаМаркировки;
	ТипШтрихкодаИВидУпаковки       = НастройкаОписанияКодаМаркировки.ТипШтрихкодаИВидУпаковки;
	
	ШаблоныКодовМаркировки         = НастройкиРазбораКодаМаркировки.ШаблоныКодовМаркировкиПоВидамПродукции;
	ШаблоныИОписанияВидовПродукции = НастройкиРазбораКодаМаркировки.ШаблоныИОписанияВидовПродукции;
	
	НачинаетсяСоСкобки  = Ложь;
	ДлинаКодаМаркировки = 0;
	Шаблон              = "";
	
	Шаблон = СтрШаблон("[%1]", ТипШтрихкодаИВидУпаковки.ТипШтрихкода) + " ";
	
	КонечныйИндекс = ОписаниеШаблонаКодаМаркировки.ВГраница();
	Для ТекущийИндекс = 0 По КонечныйИндекс Цикл
		
		ОписаниеЭлементаКМ = ОписаниеШаблонаКодаМаркировки[ТекущийИндекс];
		
		Если ТекущийИндекс = 0 Тогда
			НачинаетсяСоСкобки = ЗначениеЗаполнено(ОписаниеЭлементаКМ.Код);
			КодПервогоЭлемента = ОписаниеЭлементаКМ.Код;
		КонецЕсли;
		
		ДлинаКодаМаркировки = ДлинаКодаМаркировки + СтрДлина(ОписаниеЭлементаКМ.Код) + ОписаниеЭлементаКМ.Длина;
		
		Если НачинаетсяСоСкобки Тогда
			ШаблонЭлементаКМ = СтрШаблон("%1 + %2 (%3 chars)",
				ОписаниеЭлементаКМ.Код, ОписаниеЭлементаКМ.Имя, ОписаниеЭлементаКМ.Длина);
		Иначе
			ШаблонЭлементаКМ = СтрШаблон("%1 (%2 chars)",
				ОписаниеЭлементаКМ.Имя, ОписаниеЭлементаКМ.Длина);
		КонецЕсли;
		Шаблон = Шаблон + ?(ТекущийИндекс = 0, "", " " + "+" + " ") + ШаблонЭлементаКМ;
		
		Если ТекущийИндекс = КонечныйИндекс Тогда
			
			ДлинаКодаМаркировкиСоСкобкой = 0;
			Если НачинаетсяСоСкобки Тогда
				ДлинаКодаМаркировкиСоСкобкой = ДлинаКодаМаркировки + (ТекущийИндекс + 1) * 2;
			КонецЕсли;
			
			ШаблонКМ = ШаблоныКодовМаркировки.Добавить();
			ШаблонКМ.ВидПродукции        = ВидПродукции;
			ШаблонКМ.Шаблон              = Шаблон;
			ШаблонКМ.ТипШтрихкода        = ТипШтрихкодаИВидУпаковки.ТипШтрихкода;
			ШаблонКМ.ВидУпаковки         = ТипШтрихкодаИВидУпаковки.ВидУпаковки;
			ШаблонКМ.КоличествоЭлементов = ТекущийИндекс + 1;
			ШаблонКМ.НачинаетсяСоСкобки  = НачинаетсяСоСкобки;
			ШаблонКМ.Длина               = ДлинаКодаМаркировки;
			ШаблонКМ.ДлинаСоСкобкой      = ДлинаКодаМаркировкиСоСкобкой;
			ШаблонКМ.КодПервогоЭлемента  = КодПервогоЭлемента;
			
			ЗаполнениеШаблоновИОписанийВидовПродукции(ШаблоныИОписанияВидовПродукции, НастройкаОписанияКодаМаркировки, Шаблон);
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ЗаполнениеШаблоновИОписанийВидовПродукции(ШаблоныИОписанияВидовПродукции, НастройкаОписанияКодаМаркировки, Шаблон)
	
	// Формируем описание и состав кода маркировки в соответствии с составом текущего шаблона
	ОписаниеТекущегоШаблона = ШаблоныИОписанияВидовПродукции[Шаблон];
	Если ОписаниеТекущегоШаблона = Неопределено Тогда
		
		СоставКодаМаркировки          = СлужебныеПроцедурыИФункцииИСМПТККлиентСервер.СкопироватьРекурсивно(НастройкаОписанияКодаМаркировки.СоставКодаМаркировки);
		ОписаниеШаблонаКодаМаркировки = НастройкаОписанияКодаМаркировки.ОписаниеШаблонаКодаМаркировки;
		
		ОписаниеТекущегоШаблона = Новый Структура;
		ОписаниеТекущегоШаблона.Вставить("ВидыПродукции",               Новый Массив);
		ОписаниеТекущегоШаблона.Вставить("ОписаниеКодаМаркировки",      ОписаниеШаблонаКодаМаркировки);
		ОписаниеТекущегоШаблона.Вставить("СоставКодаМаркировки",        СоставКодаМаркировки);
		ОписаниеТекущегоШаблона.Вставить("ОбщиеМодулиШтрихкодирования", Новый Массив);
		
		ШаблоныИОписанияВидовПродукции[Шаблон] = ОписаниеТекущегоШаблона;
		
	КонецЕсли;
	
	ВидПродукции = НастройкаОписанияКодаМаркировки.ВидПродукции;
	Если ОписаниеТекущегоШаблона.ВидыПродукции.Найти(ВидПродукции) <> Неопределено Тогда
		Возврат;
	КонецЕсли;
	ОписаниеТекущегоШаблона.ВидыПродукции.Добавить(ВидПродукции);
	
	// Переформируем состав один раз, так что бы подходил под любой вид продукции
	Если ОписаниеТекущегоШаблона.ВидыПродукции.Количество() = 2
		И ОписаниеТекущегоШаблона.СоставКодаМаркировки.Количество() > 0 Тогда
		
		ДанныеОбщегоМодуля        = НастройкаОписанияКодаМаркировки.ДанныеОбщегоМодуля;
		НовыйСоставКодаМаркировки = ДанныеОбщегоМодуля.ОбщийМодуль.НовыйСоставКодаМаркировки(
			НастройкаОписанияКодаМаркировки.ТипШтрихкодаИВидУпаковки);
		
		ОписаниеТекущегоШаблона.СоставКодаМаркировки = НовыйСоставКодаМаркировки;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ОпределитьОбщиеМодулиВШаблонахИОписанияхВидовПродукции(НастройкиРазбораКодаМаркировки, ДанныеОбщихМодулейПоВидуПродукции)
	
	Для Каждого СтрокаПоискаШаблона Из НастройкиРазбораКодаМаркировки.ШаблоныКодовМаркировки Цикл
		
		ДанныеШаблона      = НастройкиРазбораКодаМаркировки.ШаблоныИОписанияВидовПродукции[СтрокаПоискаШаблона.Шаблон];
		ДанныеОбщихМодулей = Новый Соответствие;
		
		Для Каждого ВидПродукции Из ДанныеШаблона.ВидыПродукции Цикл
			
			ДанныеОбщегоМодуля = ДанныеОбщихМодулейПоВидуПродукции[ВидПродукции];
			
			Если ДанныеОбщихМодулей[ДанныеОбщегоМодуля.Имя] = Неопределено Тогда
				
				ДанныеОбщихМодулей[ДанныеОбщегоМодуля.Имя] = ДанныеОбщегоМодуля;
				
				ДанныеШаблона.ОбщиеМодулиШтрихкодирования.Добавить(ДанныеОбщегоМодуля);
				
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЦикла;
	
КонецПроцедуры

Функция GTINИзКодаМаркировки(КодМаркировки, ВидУпаковки) Экспорт
	
	ЗначениеИдентификатораGTIN = "";
	
	Если ВидУпаковки = ПредопределенноеЗначение("Перечисление.ВидыУпаковокИСМПТК.Потребительская") Тогда
		
		ЗначениеИдентификатораGTIN = Лев(КодМаркировки, 14);
		
	ИначеЕсли ВидУпаковки = ПредопределенноеЗначение("Перечисление.ВидыУпаковокИСМПТК.Групповая") Тогда
		
		ИдентификаторGTIN = Лев(КодМаркировки, 4);
		Если ИдентификаторGTIN = "(01)" Тогда
			ЗначениеИдентификатораGTIN = Сред(КодМаркировки, 5, 14);
		КонецЕсли;
		
	ИначеЕсли ВидУпаковки = ПредопределенноеЗначение("Перечисление.ВидыУпаковокИСМПТК.Логистическая") Тогда
		
		Если СтрНачинаетсяС(КодМаркировки, "(") Тогда
			ИдентификаторGTIN = Лев(КодМаркировки, 4);
			Если ИдентификаторGTIN = "(01)" Или ИдентификаторGTIN = "(02)" Тогда
				ЗначениеИдентификатораGTIN = Сред(КодМаркировки, 5, 14);
			КонецЕсли;
		Иначе
			ИдентификаторGTIN = Лев(КодМаркировки, 2);
			Если ИдентификаторGTIN = "01" Или ИдентификаторGTIN = "02" Тогда
				ЗначениеИдентификатораGTIN = Сред(КодМаркировки, 3, 14);
			КонецЕсли;
		КонецЕсли;
		
	Иначе
		Возврат Неопределено;
	КонецЕсли;
	
	Если ЗначениеИдентификатораGTIN = "" Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Если СтрДлина(ЗначениеИдентификатораGTIN) = 14
		И МенеджерОборудованияКлиентСервер.ПроверитьКорректностьGTIN(ЗначениеИдентификатораGTIN) Тогда
		
		Возврат ЗначениеИдентификатораGTIN;
		
	КонецЕсли;
	
	Возврат Неопределено;
	
КонецФункции
