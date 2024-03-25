﻿   
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	 	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтаФорма);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	ПоляФормы		= Новый Структура("Субконто1, Субконто2, Субконто3",
		"СубконтоДт1", "СубконтоДт2", "СубконтоДт3");
	
	ЗаголовкиПолей	= Новый Структура("Субконто1, Субконто2, Субконто3",
		"ЗаголовокСубконтоДтБУ1", "ЗаголовокСубконтоДтБУ2", "ЗаголовокСубконтоДтБУ3"); 
		
	УстановитьЗаголовкиИДоступностьСубконто(ЭтаФорма, Объект.СчетДт, ПоляФормы, ЗаголовкиПолей);
	
	ПоляФормы		= Новый Структура("Субконто1, Субконто2, Субконто3",
		"СубконтоКт1", "СубконтоКт2", "СубконтоКт3");
	
	ЗаголовкиПолей	= Новый Структура("Субконто1, Субконто2, Субконто3",
		"ЗаголовокСубконтоКтБУ1", "ЗаголовокСубконтоКтБУ2", "ЗаголовокСубконтоКтБУ3"); 
		
	УстановитьЗаголовкиИДоступностьСубконто(ЭтаФорма, Объект.СчетКт, ПоляФормы, ЗаголовкиПолей);
	
	ПоляФормы		= Новый Структура("Субконто1, Субконто2, Субконто3",
		"СубконтоДтНУ1", "СубконтоДтНУ2", "СубконтоДтНУ3");
	
	ЗаголовкиПолей	= Новый Структура("Субконто1, Субконто2, Субконто3",
		"ЗаголовокСубконтоДтНУ1", "ЗаголовокСубконтоДтНУ2", "ЗаголовокСубконтоДтНУ3"); 
		
	УстановитьЗаголовкиИДоступностьСубконто(ЭтаФорма, Объект.СчетДтНУ, ПоляФормы, ЗаголовкиПолей);
	
	ПоляФормы		= Новый Структура("Субконто1, Субконто2, Субконто3",
		"СубконтоКтНУ1", "СубконтоКтНУ2", "СубконтоКтНУ3");
	
	ЗаголовкиПолей	= Новый Структура("Субконто1, Субконто2, Субконто3",
		"ЗаголовокСубконтоКтНУ1", "ЗаголовокСубконтоКтНУ2", "ЗаголовокСубконтоКтНУ3"); 
		
	УстановитьЗаголовкиИДоступностьСубконто(ЭтаФорма, Объект.СчетКтНУ, ПоляФормы, ЗаголовкиПолей);
	
	Если НЕ ЗначениеЗаполнено(Объект.ВидУчетаНУДТ) тогда
		Объект.ВидУчетаНУДТ = Справочники.ВидыУчетаНУ.НУ;
	КонецЕсли;
	Если НЕ ЗначениеЗаполнено(Объект.ВидУчетаНУКТ) тогда
		Объект.ВидУчетаНУКТ = Справочники.ВидыУчетаНУ.НУ;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	Элементы.Наименование.ТолькоПросмотр = Объект.Предопределенный;
КонецПроцедуры


   
#Область ОбработчикиСобытийФормы

&НаКлиенте
Процедура СчетДТБУПриИзменении(Элемент)
			
	ПоляФормы		= Новый Структура("Субконто1, Субконто2, Субконто3",
		"СубконтоДт1", "СубконтоДт2", "СубконтоДт3");
	
	ЗаголовкиПолей	= Новый Структура("Субконто1, Субконто2, Субконто3",
		"ЗаголовокСубконтоДтБУ1", "ЗаголовокСубконтоДтБУ2", "ЗаголовокСубконтоДтБУ3"); 
		
	УстановитьЗаголовкиИДоступностьСубконто(ЭтаФорма, Объект.СчетДт, ПоляФормы, ЗаголовкиПолей);
	
	Объект.СчетДтНУ = ПроцедурыБухгалтерскогоУчетаВызовСервераПовтИсп.ПреобразоватьСчетаБУвСчетНУ(Новый Структура("СчетБУ", Объект.СчетДт));
	
	ПоляФормы		= Новый Структура("Субконто1, Субконто2, Субконто3",
		"СубконтоДтНУ1", "СубконтоДтНУ2", "СубконтоДтНУ3");
	
	ЗаголовкиПолей	= Новый Структура("Субконто1, Субконто2, Субконто3",
		"ЗаголовокСубконтоДтНУ1", "ЗаголовокСубконтоДтНУ2", "ЗаголовокСубконтоДтНУ3"); 
		
	УстановитьЗаголовкиИДоступностьСубконто(ЭтаФорма, Объект.СчетДтНУ, ПоляФормы, ЗаголовкиПолей);

	ИзменитьПараметрыВыбораПолейСубконто(ЭтаФорма, "Дт",   "СчетДт");
	ИзменитьПараметрыВыбораПолейСубконто(ЭтаФорма, "ДтНУ", "СчетДтНУ"); 
	
КонецПроцедуры
   

&НаКлиенте
Процедура СчетКТБУПриИзменении(Элемент)
	ПоляФормы		= Новый Структура("Субконто1, Субконто2, Субконто3",
		"СубконтоКт1", "СубконтоКт2", "СубконтоКт3");
	
	ЗаголовкиПолей	= Новый Структура("Субконто1, Субконто2, Субконто3",
		"ЗаголовокСубконтоКтБУ1", "ЗаголовокСубконтоКтБУ2", "ЗаголовокСубконтоКтБУ3"); 
		
	УстановитьЗаголовкиИДоступностьСубконто(ЭтаФорма, Объект.СчетКт, ПоляФормы, ЗаголовкиПолей);
	
	Объект.СчетКтНУ = ПроцедурыБухгалтерскогоУчетаВызовСервераПовтИсп.ПреобразоватьСчетаБУвСчетНУ(Новый Структура("СчетБУ", Объект.СчетКт));
	
	ПоляФормы		= Новый Структура("Субконто1, Субконто2, Субконто3",
		"СубконтоКтНУ1", "СубконтоКтНУ2", "СубконтоКтНУ3");
	
	ЗаголовкиПолей	= Новый Структура("Субконто1, Субконто2, Субконто3",
		"ЗаголовокСубконтоКтНУ1", "ЗаголовокСубконтоКтНУ2", "ЗаголовокСубконтоКтНУ3"); 
		
	УстановитьЗаголовкиИДоступностьСубконто(ЭтаФорма, Объект.СчетКтНУ, ПоляФормы, ЗаголовкиПолей);
	ИзменитьПараметрыВыбораПолейСубконто(ЭтаФорма, "Кт",   "СчетКт");
	ИзменитьПараметрыВыбораПолейСубконто(ЭтаФорма, "КтНУ", "СчетКтНУ");
КонецПроцедуры

&НаКлиенте
Процедура СчетДТНУПриИзменении(Элемент)
		ПоляФормы		= Новый Структура("Субконто1, Субконто2, Субконто3",
		"СубконтоДтНУ1", "СубконтоДтНУ2", "СубконтоДтНУ3");
	
	ЗаголовкиПолей	= Новый Структура("Субконто1, Субконто2, Субконто3",
		"ЗаголовокСубконтоДтНУ1", "ЗаголовокСубконтоДтНУ2", "ЗаголовокСубконтоДтНУ3"); 
		
	УстановитьЗаголовкиИДоступностьСубконто(ЭтаФорма, Объект.СчетДтНУ, ПоляФормы, ЗаголовкиПолей);

КонецПроцедуры

&НаКлиенте
Процедура СчетКТНУПриИзменении(Элемент)
		ПоляФормы		= Новый Структура("Субконто1, Субконто2, Субконто3",
		"СубконтоКтНУ1", "СубконтоКтНУ2", "СубконтоКтНУ3");
	
	ЗаголовкиПолей	= Новый Структура("Субконто1, Субконто2, Субконто3",
		"ЗаголовокСубконтоКтНУ1", "ЗаголовокСубконтоКтНУ2", "ЗаголовокСубконтоКтНУ3"); 
		
	УстановитьЗаголовкиИДоступностьСубконто(ЭтаФорма, Объект.СчетКтНУ, ПоляФормы, ЗаголовкиПолей);
	
КонецПроцедуры

&НаКлиенте
Процедура СубконтоДт1ПриИзменении(Элемент)
	
	ОбщегоНазначенияБККлиентСервер.ЗаменитьСубконтоНУ(Объект, Объект.СчетДт, Объект.СчетДтНУ, 1, Объект.СубконтоДт1, "СубконтоДтНУ");		
	ИзменитьПараметрыВыбораПолейСубконто(ЭтаФорма, "Дт", "СчетДт");	
	ИзменитьПараметрыВыбораПолейСубконто(ЭтаФорма, "ДтНУ", "СчетДтНУ");	
	
КонецПроцедуры

&НаКлиенте
Процедура СубконтоДт2ПриИзменении(Элемент)
	
	ОбщегоНазначенияБККлиентСервер.ЗаменитьСубконтоНУ(Объект, Объект.СчетДт, Объект.СчетДтНУ, 2, Объект.СубконтоДт2, "СубконтоДтНУ");		
	ИзменитьПараметрыВыбораПолейСубконто(ЭтаФорма, "Дт", "СчетДт");	
	ИзменитьПараметрыВыбораПолейСубконто(ЭтаФорма, "ДтНУ", "СчетДтНУ");	
	
КонецПроцедуры

&НаКлиенте
Процедура СубконтоДт3ПриИзменении(Элемент)
	
	ОбщегоНазначенияБККлиентСервер.ЗаменитьСубконтоНУ(Объект, Объект.СчетДт, Объект.СчетДтНУ, 3, Объект.СубконтоДт3, "СубконтоДтНУ");		
	ИзменитьПараметрыВыбораПолейСубконто(ЭтаФорма, "Дт", "СчетДт");	
	ИзменитьПараметрыВыбораПолейСубконто(ЭтаФорма, "ДтНУ", "СчетДтНУ");	
	
КонецПроцедуры

&НаКлиенте
Процедура СубконтоДт1НачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СубконтоНачалоВыбора(Элемент, "СубконтоДт", 1, "СчетДт", Объект, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура СубконтоДт2НачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СубконтоНачалоВыбора(Элемент, "СубконтоДт", 2, "СчетДт", Объект, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура СубконтоДт3НачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СубконтоНачалоВыбора(Элемент, "СубконтоДт", 3, "СчетДт", Объект, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура СубконтоКт1ПриИзменении(Элемент)
	
	ОбщегоНазначенияБККлиентСервер.ЗаменитьСубконтоНУ(Объект, Объект.СчетКт, Объект.СчетКтНУ, 1, Объект.СубконтоКт1, "СубконтоКтНУ");		
	ИзменитьПараметрыВыбораПолейСубконто(ЭтаФорма, "Кт", "СчетКт");	
	ИзменитьПараметрыВыбораПолейСубконто(ЭтаФорма, "КтНУ", "СчетКтНУ");	
	
КонецПроцедуры

&НаКлиенте
Процедура СубконтоКт2ПриИзменении(Элемент)
	
	ОбщегоНазначенияБККлиентСервер.ЗаменитьСубконтоНУ(Объект, Объект.СчетКт, Объект.СчетКтНУ, 2, Объект.СубконтоКт2, "СубконтоКтНУ");		
	ИзменитьПараметрыВыбораПолейСубконто(ЭтаФорма, "Кт", "СчетКт");	
	ИзменитьПараметрыВыбораПолейСубконто(ЭтаФорма, "КтНУ", "СчетКтНУ");	
	
КонецПроцедуры

&НаКлиенте
Процедура СубконтоКт3ПриИзменении(Элемент)
	
	ОбщегоНазначенияБККлиентСервер.ЗаменитьСубконтоНУ(Объект, Объект.СчетКт, Объект.СчетКтНУ, 3, Объект.СубконтоКт3, "СубконтоКтНУ");		
	ИзменитьПараметрыВыбораПолейСубконто(ЭтаФорма, "Кт", "СчетКт");	
	ИзменитьПараметрыВыбораПолейСубконто(ЭтаФорма, "КтНУ", "СчетКтНУ");	
	
КонецПроцедуры

&НаКлиенте
Процедура СубконтоКт1НачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СубконтоНачалоВыбора(Элемент, "СубконтоКт", 1, "СчетКт", Объект, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура СубконтоКт2НачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СубконтоНачалоВыбора(Элемент, "СубконтоКт", 2, "СчетКт", Объект, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура СубконтоКт3НачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СубконтоНачалоВыбора(Элемент, "СубконтоКт", 3, "СчетКт", Объект, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура СубконтоДтНУ1НачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СубконтоНачалоВыбора(Элемент, "СубконтоДтНУ", 1, "СчетДтНУ", Объект, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура СубконтоДтНУ2НачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СубконтоНачалоВыбора(Элемент, "СубконтоДтНУ", 2, "СчетДтНУ", Объект, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура СубконтоДтНУ3НачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СубконтоНачалоВыбора(Элемент, "СубконтоДтНУ", 3, "СчетДтНУ", Объект, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура СубконтоКтНУ1НачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СубконтоНачалоВыбора(Элемент, "СубконтоКтНУ", 1, "СчетКтНУ", Объект, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура СубконтоКтНУ2НачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СубконтоНачалоВыбора(Элемент, "СубконтоКтНУ", 2, "СчетКтНУ", Объект, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура СубконтоКтНУ3НачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СубконтоНачалоВыбора(Элемент, "СубконтоКтНУ", 3, "СчетКтНУ", Объект, СтандартнаяОбработка);
	
КонецПроцедуры


#КонецОбласти
 
#Область СлужебныеПроцедурыИФункции


&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьЗаголовкиИДоступностьСубконто(ЭтаФорма, СчетУчета, ПоляФормы, ЗаголовкиПолей, СчетУчетаНУ = Неопределено)

	ПроцедурыБухгалтерскогоУчетаКлиентСервер.ПриВыбореСчета(СчетУчета, ЭтаФорма, ПоляФормы, ЗаголовкиПолей);
	
	Если НЕ СчетУчетаНУ = Неопределено Тогда
		
		Для Каждого ПолеФормы Из ПоляФормы Цикл
			
			ПоляФормы.Вставить(ПолеФормы.Ключ, СтрЗаменить(ПолеФормы.Значение, "БУ", "НУ"));
			
		КонецЦикла;
		
		Для Каждого ЗаголовоеПоля Из ЗаголовкиПолей Цикл
			
			ЗаголовкиПолей.Вставить(ЗаголовоеПоля.Ключ, СтрЗаменить(ЗаголовоеПоля.Значение, "БУ", "НУ"));
			
		КонецЦикла;
		
		ПроцедурыБухгалтерскогоУчетаКлиентСервер.ПриВыбореСчета(СчетУчетаНУ, ЭтаФорма, ПоляФормы, ЗаголовкиПолей);
		
	КонецЕсли;

КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ИзменитьПараметрыВыбораПолейСубконто(Форма, Суффикс, ИмяСчета)
	
	ПараметрыДокумента = СписокПараметровВыбораСубконто(Форма.Объект, Форма.Объект, "Субконто" + Суффикс + "%Индекс%", ИмяСчета);
	ПроцедурыБухгалтерскогоУчетаКлиентСервер.ИзменитьПараметрыВыбораПолейСубконто(Форма, Форма.Объект, "Субконто" + Суффикс + "%Индекс%", "Субконто" + Суффикс + "%Индекс%", ПараметрыДокумента);	
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция СписокПараметровВыбораСубконто(ДанныеОбъекта, ПараметрыОбъекта, ШаблонИмяПоляОбъекта, ИмяСчета)
	
	СписокПараметров = Новый Структура;
	Для Индекс = 1 По 3 Цикл
		ИмяПоля = СтрЗаменить(ШаблонИмяПоляОбъекта, "%Индекс%", Индекс);
		Если ТипЗнч(ПараметрыОбъекта[ИмяПоля]) = Тип("СправочникСсылка.Контрагенты") Тогда
			СписокПараметров.Вставить("Контрагент", ПараметрыОбъекта[ИмяПоля]);
		ИначеЕсли ТипЗнч(ПараметрыОбъекта[ИмяПоля]) = Тип("СправочникСсылка.ДоговорыКонтрагентов") Тогда
			СписокПараметров.Вставить("ДоговорКонтрагента", ПараметрыОбъекта[ИмяПоля]);
		ИначеЕсли ТипЗнч(ПараметрыОбъекта[ИмяПоля]) = Тип("СправочникСсылка.Номенклатура") Тогда
			СписокПараметров.Вставить("Номенклатура", ПараметрыОбъекта[ИмяПоля]);
		ИначеЕсли ТипЗнч(ПараметрыОбъекта[ИмяПоля]) = Тип("СправочникСсылка.Склады") Тогда
			СписокПараметров.Вставить("Склад", ПараметрыОбъекта[ИмяПоля]);
		КонецЕсли;
	КонецЦикла;
	СписокПараметров.Вставить("СчетУчета", ПараметрыОбъекта[ИмяСчета]);	

	Возврат СписокПараметров; 

КонецФункции

&НаКлиенте
Процедура СубконтоНачалоВыбора(Элемент, ИмяЭлементаСубконто, ИндексСубконто, ИмяЭлементаСчета, СтрокаТаблицы, СтандартнаяОбработка)	
		
	ПараметрыДокумента = СписокПараметровВыбораСубконто(Объект, СтрокаТаблицы, ИмяЭлементаСубконто + "%Индекс%", ИмяЭлементаСчета);
	
	ПроцедурыБухгалтерскогоУчетаКлиент.НачалоВыбораЗначенияСубконто(ЭтаФорма, Элемент, ИндексСубконто, СтандартнаяОбработка, ПараметрыДокумента);	
	
КонецПроцедуры


#КонецОбласти