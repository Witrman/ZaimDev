﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

Функция ПолучитьПараметрыИсполненияОтчета() Экспорт
	
	Возврат Новый Структура("ИспользоватьПередКомпоновкойМакета,
							|ИспользоватьВнешниеНаборыДанных,
							|ИспользоватьПослеКомпоновкиМакета,
							|ИспользоватьПослеВыводаРезультата,
							|ИспользоватьДанныеРасшифровки,
							|ИспользоватьПриВыводеЗаголовка,
							|ИспользоватьПриВыводеПодвала,
							|ИспользоватьРасширенныеПараметрыРасшифровки",
							Истина, Истина, Ложь, Истина, Истина, Истина, Истина, Истина);
							
КонецФункции

Процедура ПриВыводеЗаголовка(ПараметрыОтчета,Результат) Экспорт
	
    Если ПараметрыОтчета.ВидОтчета = "ПроизвольныйОтчет" ИЛИ ПараметрыОтчета.РежимРасшифровки  Тогда
		Возврат;
	КонецЕсли;
	
	СведенияОНалогоплательщике = ОбщегоНазначенияБКВызовСервера.СведенияОЮрФизЛице(ПараметрыОтчета.Налогоплательщик, ПараметрыОтчета.КонецПериода);
	
	Макет = ПолучитьОбщийМакет("ЗаголовокРегистраНалоговогоУчета");
	ОбластьЗаголовок = Макет.ПолучитьОбласть("ЗаголовокОтчета_Общий_Полный"); 
	ОбластьЗаголовок.Параметры.НомерПриложения  = "8";
	ОбластьЗаголовок.Параметры.ЗаголовокОтчета = ПолучитьТекстЗаголовка(ПараметрыОтчета);

	Если СведенияОНалогоплательщике <> Неопределено Тогда 
		ОбластьЗаголовок.Параметры.Заполнить(СведенияОНалогоплательщике);
		ОбластьЗаголовок_Период = Макет.ПолучитьОбласть("Строка_Дата");
		ОбластьЗаголовок_Период.Параметры.ДатаПредставления = (Формат(ПараметрыОтчета.КонецПериода, "ДЛФ=ДД"));
	КонецЕсли;
	Результат.Вывести(ОбластьЗаголовок);
	Результат.Вывести(ОбластьЗаголовок_Период);
	
КонецПроцедуры

Процедура ПриВыводеПодвала(ПараметрыОтчета, Результат) Экспорт
	
	Макет = ПолучитьОбщийМакет("ЗаголовокРегистраНалоговогоУчета");
	ОбластьПодвал = Макет.ПолучитьОбласть("ПолныйВариант"); 	
	Если ПараметрыОтчета.Налогоплательщик <> Неопределено Тогда 
		ОтветЛица = ОбщегоНазначенияБКВызовСервера.ОтветственныеЛицаОрганизаций(ПараметрыОтчета.Налогоплательщик, ПараметрыОтчета.КонецПериода);
		ОбластьПодвал.Параметры.ФИОРуководителя = ОтветЛица.Руководитель;
		ОбластьПодвал.Параметры.ФИОглБухгалтера = ОтветЛица.ГлавныйБухгалтер;
		ОбластьПодвал.Параметры.ФИОИсполнителя 	= ОтветЛица.ОтветственныйЗаРегистры;
		ОбластьПодвал.Параметры.ДатаСоставления = Формат(ОбщегоНазначения.ТекущаяДатаПользователя(), "ДФ=""дд ММММ гггг 'г.'""");	
	КонецЕсли;
	
	Результат.Вывести(ОбластьПодвал);
	
	ОбластьПримечание = Макет.ПолучитьОбласть("СложноеПримечание");
	ОбластьПримечаниеНДС = Макет.ПолучитьОбласть("НДСПримечание");
	
	Результат.Вывести(ОбластьПримечание);
	Результат.Вывести(ОбластьПримечаниеНДС);
	
КонецПроцедуры

Функция ПолучитьТекстЗаголовка(ПараметрыОтчета, ОрганизацияВНачале = Истина) Экспорт
	
	ЗаголовокОтчета = ?(ПараметрыОтчета.ВидОтчета = "НалоговыйРегистр", НСтр("ru = 'Налоговый регистр по обороту в виде остатков товаров для целей исчисления налога на добавленную стоимость'"),
	НСтр("ru = 'Отчет по обороту в виде остатков товаров для целей исчисления налога на добавленную стоимость'"));
	
	Возврат ЗаголовокОтчета;
	
КонецФункции

Функция ПолучитьВнешниеНаборыДанных(ПараметрыОтчета, МакетКомпоновки) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	Типовой.Ссылка КАК Счет
	|ПОМЕСТИТЬ СписокСчетовЗапасов
	|ИЗ
	|	ПланСчетов.Типовой КАК Типовой
	|ГДЕ
	|	(Типовой.Ссылка = ЗНАЧЕНИЕ(ПланСчетов.Типовой.СырьеИМатериалы)
	|			ИЛИ Типовой.Ссылка = ЗНАЧЕНИЕ(ПланСчетов.Типовой.Товары)
	|			ИЛИ Типовой.Ссылка = ЗНАЧЕНИЕ(ПланСчетов.Типовой.ПрочиеЗапасы))
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	СписокСчетовЗапасов.Счет КАК Счет,
	|	ЕСТЬNULL(СпособОценкиЗапасовБУ.СпособОценки, ЗНАЧЕНИЕ(Перечисление.СпособыОценки.ПоСредней)) КАК СпособОценки
	|ПОМЕСТИТЬ ВТ_СчетаИСпособы
	|ИЗ
	|	СписокСчетовЗапасов КАК СписокСчетовЗапасов
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СпособОценкиЗапасовБУ КАК СпособОценкиЗапасовБУ
	|		ПО СписокСчетовЗапасов.Счет = СпособОценкиЗапасовБУ.СчетЗапасов
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТиповойОстатки.Счет КАК Счет,
	|	ТиповойОстатки.Субконто1 КАК Номенклатура,
	|	ТиповойОстатки.Организация КАК Организация,
	|	ТиповойОстатки.СуммаОстатокДт КАК СуммаОстаток,
	|	ТиповойОстатки.КоличествоОстатокДт КАК КоличествоОстаток,
	|	ИСТИНА КАК ПризнакУчетаПоСредней
	|ПОМЕСТИТЬ ВТ_ОстаткиПоСредней
	|ИЗ
	|	РегистрБухгалтерии.Типовой.Остатки(
	|			&КонецПериода,
	|			Счет В
	|				(ВЫБРАТЬ
	|					ВТ_СчетаИСпособы.Счет
	|				ИЗ
	|					ВТ_СчетаИСпособы
	|				ГДЕ
	|					ВТ_СчетаИСпособы.СпособОценки = ЗНАЧЕНИЕ(перечисление.СпособыОценки.ПоСредней)),
	|			&СубконтоДляСредней,
	|			Организация В (&Организация)) КАК ТиповойОстатки
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТиповойОстатки.Счет КАК Счет,
	|	ТиповойОстатки.Субконто1 КАК Номенклатура,
	|	ТиповойОстатки.Субконто3 КАК Документ,
	|	ТиповойОстатки.Организация КАК Организация,
	|	ТиповойОстатки.СуммаОстатокДт КАК СуммаОстаток,
	|	ТиповойОстатки.КоличествоОстатокДт КАК КоличествоОстаток,
	|	ЛОЖЬ КАК ПризнакУчетаПоСредней
	|ПОМЕСТИТЬ ВТ_ОстаткиПартии
	|ИЗ
	|	РегистрБухгалтерии.Типовой.Остатки(
	|			&КонецПериода,
	|			Счет В
	|				(ВЫБРАТЬ
	|					ВТ_СчетаИСпособы.Счет
	|				ИЗ
	|					ВТ_СчетаИСпособы
	|				ГДЕ
	|					ВТ_СчетаИСпособы.СпособОценки <> ЗНАЧЕНИЕ(перечисление.СпособыОценки.ПоСредней)),
	|			&Субконто,
	|			Организация В (&Организация)) КАК ТиповойОстатки
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	СУММА(ЕСТЬNULL(ТиповойОбороты.СуммаОборотДт, 0)) КАК СуммаОборот,
	|	СУММА(ЕСТЬNULL(ТиповойОбороты.КоличествоОборотДт, 0)) КАК КоличествоОборот,
	|	ВТ_ОстаткиПартии.Счет КАК Счет,
	|	ВТ_ОстаткиПартии.Номенклатура КАК Номенклатура,
	|	ТиповойОбороты.Регистратор КАК Документ,
	|	ВТ_ОстаткиПартии.Организация КАК Организация,
	|	ВЫБОР
	|		КОГДА ТИПЗНАЧЕНИЯ(ТиповойОбороты.Регистратор) <> ТИП(Документ.ПоступлениеДопРасходов)
	|			ТОГДА ВТ_ОстаткиПартии.СуммаОстаток
	|		ИНАЧЕ 0
	|	КОНЕЦ КАК СуммаОстаток,
	|	ВЫБОР
	|		КОГДА ТИПЗНАЧЕНИЯ(ТиповойОбороты.Регистратор) <> ТИП(Документ.ПоступлениеДопРасходов)
	|			ТОГДА ВТ_ОстаткиПартии.КоличествоОстаток
	|		ИНАЧЕ 0
	|	КОНЕЦ КАК КоличествоОстаток,
	|	ВТ_ОстаткиПартии.ПризнакУчетаПоСредней КАК ПризнакУчетаПоСредней
	|ПОМЕСТИТЬ ВТ_ДокументыПартии
	|ИЗ
	|	ВТ_ОстаткиПартии КАК ВТ_ОстаткиПартии
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрБухгалтерии.Типовой.Обороты(
	|				&НачалоПериодаБезОграничений,
	|				&КонецПериода,
	|				Регистратор,
	|				Счет В
	|					(ВЫБРАТЬ
	|						ВТ_СчетаИСпособы.Счет
	|					ИЗ
	|						ВТ_СчетаИСпособы
	|					ГДЕ
	|						ВТ_СчетаИСпособы.СпособОценки <> ЗНАЧЕНИЕ(перечисление.СпособыОценки.ПоСредней)),
	|				&Субконто,
	|				Субконто1 В
	|						(ВЫБРАТЬ
	|							ВТ_ОстаткиПартии.Номенклатура
	|						ИЗ
	|							ВТ_ОстаткиПартии КАК ВТ_ОстаткиПартии)
	|					И Субконто3 В
	|						(ВЫБРАТЬ
	|							ВТ_ОстаткиПартии.Документ
	|						ИЗ
	|							ВТ_ОстаткиПартии КАК ВТ_ОстаткиПартии)
	|					И Организация В (&Организация),
	|				КорСчет <> ЗНАЧЕНИЕ(ПланСчетов.Типовой.СебестоимостьРеализованнойПродукцииИОказанныхУслуг),
	|				) КАК ТиповойОбороты
	|		ПО ВТ_ОстаткиПартии.Документ = ТиповойОбороты.Субконто3
	|			И ВТ_ОстаткиПартии.Номенклатура = ТиповойОбороты.Субконто1
	|			И ВТ_ОстаткиПартии.Счет = ТиповойОбороты.Счет
	|ГДЕ
	|	(ТиповойОбороты.СуммаОборотДт > 0
	|			ИЛИ ТиповойОбороты.КоличествоОборотДт > 0)
	|	И ТИПЗНАЧЕНИЯ(ТиповойОбороты.Регистратор) <> ТИП(Документ.перемещениеТоваров)
	|
	|СГРУППИРОВАТЬ ПО
	|	ВТ_ОстаткиПартии.Счет,
	|	ВТ_ОстаткиПартии.Номенклатура,
	|	ТиповойОбороты.Регистратор,
	|	ВТ_ОстаткиПартии.Организация,
	|	ВТ_ОстаткиПартии.ПризнакУчетаПоСредней,
	|	ВЫБОР
	|		КОГДА ТИПЗНАЧЕНИЯ(ТиповойОбороты.Регистратор) <> ТИП(Документ.ПоступлениеДопРасходов)
	|			ТОГДА ВТ_ОстаткиПартии.СуммаОстаток
	|		ИНАЧЕ 0
	|	КОНЕЦ,
	|	ВЫБОР
	|		КОГДА ТИПЗНАЧЕНИЯ(ТиповойОбороты.Регистратор) <> ТИП(Документ.ПоступлениеДопРасходов)
	|			ТОГДА ВТ_ОстаткиПартии.КоличествоОстаток
	|		ИНАЧЕ 0
	|	КОНЕЦ
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТиповойОбороты.Регистратор КАК Документ,
	|	СУММА(ТиповойОбороты.СуммаОборотДт) КАК СуммаОборот,
	|	СУММА(ТиповойОбороты.КоличествоОборотДт) КАК КоличествоОборот,
	|	ВТ_ОстаткиПоСредней.Счет КАК Счет,
	|	ВТ_ОстаткиПоСредней.Номенклатура КАК Номенклатура,
	|	ВТ_ОстаткиПоСредней.СуммаОстаток КАК СуммаОстаток,
	|	ВТ_ОстаткиПоСредней.КоличествоОстаток КАК КоличествоОстаток,
	|	ВТ_ОстаткиПоСредней.ПризнакУчетаПоСредней КАК ПризнакУчетаПоСредней,
	|	ВТ_ОстаткиПоСредней.Организация КАК Организация
	|ПОМЕСТИТЬ ВТ_ДокументыПоСредней
	|ИЗ
	|	ВТ_ОстаткиПоСредней КАК ВТ_ОстаткиПоСредней
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрБухгалтерии.Типовой.Обороты(
	|				&НачалоПериодаБезОграничений,
	|				&КонецПериода,
	|				Регистратор,
	|				Счет В
	|					(ВЫБРАТЬ
	|						ВТ_СчетаИСпособы.Счет
	|					ИЗ
	|						ВТ_СчетаИСпособы
	|					ГДЕ
	|						ВТ_СчетаИСпособы.СпособОценки = ЗНАЧЕНИЕ(перечисление.СпособыОценки.ПоСредней)),
	|				&СубконтоДляСредней,
	|				Субконто1 В
	|						(ВЫБРАТЬ
	|							ВТ_ОстаткиПоСредней.Номенклатура
	|						ИЗ
	|							ВТ_ОстаткиПоСредней КАК ВТ_ОстаткиПоСредней)
	|					И Организация В (&Организация),
	|				НЕ КорСчет В
	|						(ВЫБРАТЬ
	|							ВТ_СчетаИСпособы.Счет
	|						ИЗ
	|							ВТ_СчетаИСпособы),
	|				) КАК ТиповойОбороты
	|		ПО ВТ_ОстаткиПоСредней.Номенклатура = ТиповойОбороты.Субконто1
	|ГДЕ
	|	(ТиповойОбороты.СуммаОборотДт > 0
	|			ИЛИ ТиповойОбороты.КоличествоОборотДт > 0
	|			ИЛИ ТиповойОбороты.СуммаОборотКт < 0
	|			ИЛИ ТиповойОбороты.КоличествоОборотКт < 0)
	|	И ТИПЗНАЧЕНИЯ(ТиповойОбороты.Регистратор) <> ТИП(Документ.перемещениеТоваров)
	|
	|СГРУППИРОВАТЬ ПО
	|	ТиповойОбороты.Регистратор,
	|	ВТ_ОстаткиПоСредней.Номенклатура,
	|	ВТ_ОстаткиПоСредней.Счет,
	|	ВТ_ОстаткиПоСредней.СуммаОстаток,
	|	ВТ_ОстаткиПоСредней.КоличествоОстаток,
	|	ВТ_ОстаткиПоСредней.ПризнакУчетаПоСредней,
	|	ВТ_ОстаткиПоСредней.Организация
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТ_ДокументыПартии.Счет КАК Счет,
	|	ВТ_ДокументыПартии.Номенклатура КАК Номенклатура,
	|	ВТ_ДокументыПартии.Документ КАК Документ,
	|	ВТ_ДокументыПартии.СуммаОстаток КАК СуммаОстаток,
	|	ВТ_ДокументыПартии.КоличествоОстаток КАК КоличествоОстаток,
	|	ВТ_ДокументыПартии.СуммаОборот КАК СуммаОборот,
	|	ВТ_ДокументыПартии.КоличествоОборот КАК КоличествоОборот,
	|	ВТ_ДокументыПартии.ПризнакУчетаПоСредней КАК ПризнакУчетаПоСредней,
	|	ВТ_ДокументыПартии.Организация КАК Организация
	|ПОМЕСТИТЬ ВТ_Итог
	|ИЗ
	|	ВТ_ДокументыПартии КАК ВТ_ДокументыПартии
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ВТ_ДокументыПоСредней.Счет,
	|	ВТ_ДокументыПоСредней.Номенклатура,
	|	ВТ_ДокументыПоСредней.Документ,
	|	ВТ_ДокументыПоСредней.СуммаОстаток,
	|	ВТ_ДокументыПоСредней.КоличествоОстаток,
	|	ВТ_ДокументыПоСредней.СуммаОборот,
	|	ВТ_ДокументыПоСредней.КоличествоОборот,
	|	ВТ_ДокументыПоСредней.ПризнакУчетаПоСредней,
	|	ВТ_ДокументыПоСредней.Организация
	|ИЗ
	|	ВТ_ДокументыПоСредней КАК ВТ_ДокументыПоСредней
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	НДСКВозмещениюОбороты.Организация КАК Организация,
	|	НДСКВозмещениюОбороты.ТМЗ КАК ТМЗ,
	|	СУММА(НДСКВозмещениюОбороты.СуммаБезНДСОборот) КАК СуммаОборотаБезНДС,
	|	СУММА(НДСКВозмещениюОбороты.СуммаНДСОборот) КАК СуммаНДС,
	|	ВЫБОР
	|		КОГДА ТИПЗНАЧЕНИЯ(НДСКВозмещениюОбороты.Регистратор) = ТИП(Документ.ГТДИмпорт)
	|			ТОГДА НДСКВозмещениюОбороты.Регистратор.ДокументОснование
	|		КОГДА ТИПЗНАЧЕНИЯ(НДСКВозмещениюОбороты.Регистратор) = ТИП(Документ.РегистрацияПрочихОперацийПоПриобретеннымТоварамВЦеляхНДС)
	|			ТОГДА ВЫБОР
	|					КОГДА ТИПЗНАЧЕНИЯ(НДСКВозмещениюОбороты.Регистратор.ДокументОснование) = ТИП(Документ.ЗаявлениеОВвозеТоваровИУплатеКосвенныхНалогов)
	|						ТОГДА НДСКВозмещениюОбороты.Регистратор.ДокументОснование.ДокументОснование
	|					КОГДА ТИПЗНАЧЕНИЯ(НДСКВозмещениюОбороты.Регистратор.ДокументОснование) = ТИП(Документ.ПоступлениеТоваровУслуг)
	|						ТОГДА НДСКВозмещениюОбороты.Регистратор.ДокументОснование
	|				КОНЕЦ
	|		ИНАЧЕ НДСКВозмещениюОбороты.Регистратор
	|	КОНЕЦ КАК ДокументПартии,
	|	НДСКВозмещениюОбороты.Регистратор КАК Регистратор
	|ПОМЕСТИТЬ ВТ_ДанныеПоНДС
	|ИЗ
	|	РегистрНакопления.НДСКВозмещению.Обороты(&НачалоПериодаБезОграничений, &КонецПериода, Регистратор, Организация В (&Организация)) КАК НДСКВозмещениюОбороты
	|
	|СГРУППИРОВАТЬ ПО
	|	НДСКВозмещениюОбороты.Организация,
	|	НДСКВозмещениюОбороты.ТМЗ,
	|	ВЫБОР
	|		КОГДА ТИПЗНАЧЕНИЯ(НДСКВозмещениюОбороты.Регистратор) = ТИП(Документ.ГТДИмпорт)
	|			ТОГДА НДСКВозмещениюОбороты.Регистратор.ДокументОснование
	|		КОГДА ТИПЗНАЧЕНИЯ(НДСКВозмещениюОбороты.Регистратор) = ТИП(Документ.РегистрацияПрочихОперацийПоПриобретеннымТоварамВЦеляхНДС)
	|			ТОГДА ВЫБОР
	|					КОГДА ТИПЗНАЧЕНИЯ(НДСКВозмещениюОбороты.Регистратор.ДокументОснование) = ТИП(Документ.ЗаявлениеОВвозеТоваровИУплатеКосвенныхНалогов)
	|						ТОГДА НДСКВозмещениюОбороты.Регистратор.ДокументОснование.ДокументОснование
	|					КОГДА ТИПЗНАЧЕНИЯ(НДСКВозмещениюОбороты.Регистратор.ДокументОснование) = ТИП(Документ.ПоступлениеТоваровУслуг)
	|						ТОГДА НДСКВозмещениюОбороты.Регистратор.ДокументОснование
	|				КОНЕЦ
	|		ИНАЧЕ НДСКВозмещениюОбороты.Регистратор
	|	КОНЕЦ,
	|	НДСКВозмещениюОбороты.Регистратор
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТ_Итог.Счет КАК Счет,
	|	ВТ_Итог.Номенклатура КАК Номенклатура,
	|	ВТ_Итог.Документ КАК Документ,
	|	ВТ_Итог.СуммаОстаток КАК СуммаОстаток,
	|	ВТ_Итог.КоличествоОстаток КАК КоличествоОстаток,
	|	ВТ_Итог.СуммаОборот КАК СуммаОборот,
	|	ВТ_Итог.КоличествоОборот КАК КоличествоОборот,
	|	ВТ_Итог.ПризнакУчетаПоСредней КАК ПризнакУчетаПоСредней,
	|	ВТ_Итог.Организация КАК Организация,
	|	ЕСТЬNULL(ВТ_ДанныеПоНДС.СуммаОборотаБезНДС, 0) КАК СуммаОборотаБезНДС,
	|	ЕСТЬNULL(ВТ_ДанныеПоНДС.СуммаНДС, 0) КАК СуммаНДС,
	|	ВТ_ДанныеПоНДС.ДокументПартии КАК ДокументПартии,
	|	ВТ_ДанныеПоНДС.Регистратор КАК Регистратор
	|ПОМЕСТИТЬ ВТ_ИтогНДС
	|ИЗ
	|	ВТ_Итог КАК ВТ_Итог
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_ДанныеПоНДС КАК ВТ_ДанныеПоНДС
	|		ПО ВТ_Итог.Документ = ВТ_ДанныеПоНДС.ДокументПартии
	|			И ВТ_Итог.Номенклатура = ВТ_ДанныеПоНДС.ТМЗ
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ВТ_ИтогНДС.Счет КАК Счет,
	|	ВТ_ИтогНДС.Номенклатура КАК Номенклатура,
	|	ВТ_ИтогНДС.Документ КАК ДокументПартии,
	|	ВТ_ИтогНДС.СуммаОстаток КАК СуммаОстаток,
	|	ВТ_ИтогНДС.КоличествоОстаток КАК КоличествоОстаток,
	|	ВТ_ИтогНДС.СуммаОборот КАК СуммаДокумента,
	|	ВТ_ИтогНДС.КоличествоОборот КАК КоличествоДокумента,
	|	ВТ_ИтогНДС.ПризнакУчетаПоСредней КАК ПризнакУчетаПоСредней,
	|	ВТ_ИтогНДС.Организация КАК Организация,
	|	ВТ_ИтогНДС.ДокументПартии КАК ДокументНДС,
	|	ВЫБОР
	|		КОГДА СведенияСчетовФактурПолученных.СчетФактура ЕСТЬ NULL
	|				И ВТ_ИтогНДС.СуммаНДС <> 0
	|			ТОГДА ВТ_ИтогНДС.Регистратор
	|		КОГДА СведенияСчетовФактурПолученных.СчетФактура ЕСТЬ НЕ NULL 
	|				И ВТ_ИтогНДС.СуммаНДС <> 0
	|			ТОГДА СведенияСчетовФактурПолученных.СчетФактура
	|		ИНАЧЕ ""Документ зачета НДС не найден""
	|	КОНЕЦ КАК СчетФактура,
	|	ВТ_ИтогНДС.СуммаОборотаБезНДС КАК СуммаОборотаБезНДС,
	|	ВТ_ИтогНДС.СуммаНДС КАК СуммаНДС,
	|	ВЫБОР
	|		КОГДА ТИПЗНАЧЕНИЯ(ВЫБОР
	|				КОГДА СведенияСчетовФактурПолученных.СчетФактура ЕСТЬ NULL
	|						И ВТ_ИтогНДС.СуммаНДС <> 0
	|					ТОГДА ВТ_ИтогНДС.Регистратор
	|				КОГДА СведенияСчетовФактурПолученных.СчетФактура ЕСТЬ НЕ NULL 
	|						И ВТ_ИтогНДС.СуммаНДС <> 0
	|					ТОГДА СведенияСчетовФактурПолученных.СчетФактура
	|				ИНАЧЕ ""Документ зачета НДС не найден""
	|			КОНЕЦ) = ТИП(Документ.СчетФактураПолученный)
	|			ТОГДА ""Счет-фактура полученный""
	|		ИНАЧЕ ВЫБОР
	|				КОГДА СведенияСчетовФактурПолученных.СчетФактура ЕСТЬ NULL
	|						И ВТ_ИтогНДС.СуммаНДС <> 0
	|					ТОГДА ВТ_ИтогНДС.Регистратор
	|				КОГДА СведенияСчетовФактурПолученных.СчетФактура ЕСТЬ НЕ NULL 
	|						И ВТ_ИтогНДС.СуммаНДС <> 0
	|					ТОГДА СведенияСчетовФактурПолученных.СчетФактура
	|				ИНАЧЕ ""Документ зачета НДС не найден""
	|			КОНЕЦ
	|	КОНЕЦ КАК НаименованиеДокумента,
	|	ВЫБОР
	|		КОГДА ТИПЗНАЧЕНИЯ(ВЫБОР
	|				КОГДА СведенияСчетовФактурПолученных.СчетФактура ЕСТЬ NULL
	|						И ВТ_ИтогНДС.СуммаНДС <> 0
	|					ТОГДА ВТ_ИтогНДС.Регистратор
	|				КОГДА СведенияСчетовФактурПолученных.СчетФактура ЕСТЬ НЕ NULL 
	|						И ВТ_ИтогНДС.СуммаНДС <> 0
	|					ТОГДА СведенияСчетовФактурПолученных.СчетФактура
	|				ИНАЧЕ ""Документ зачета НДС не найден""
	|			КОНЕЦ) = ТИП(Документ.СчетФактураПолученный)
	|			ТОГДА ВЫРАЗИТЬ(ВЫБОР
	|						КОГДА СведенияСчетовФактурПолученных.СчетФактура ЕСТЬ NULL
	|								И ВТ_ИтогНДС.СуммаНДС <> 0
	|							ТОГДА ВТ_ИтогНДС.Регистратор
	|						КОГДА СведенияСчетовФактурПолученных.СчетФактура ЕСТЬ НЕ NULL 
	|								И ВТ_ИтогНДС.СуммаНДС <> 0
	|							ТОГДА СведенияСчетовФактурПолученных.СчетФактура
	|						ИНАЧЕ ""Документ зачета НДС не найден""
	|					КОНЕЦ КАК Документ.СчетФактураПолученный).Номер
	|	КОНЕЦ КАК НомерСФ,
	|	ВЫБОР
	|		КОГДА ТИПЗНАЧЕНИЯ(ВЫБОР
	|				КОГДА СведенияСчетовФактурПолученных.СчетФактура ЕСТЬ NULL
	|						И ВТ_ИтогНДС.СуммаНДС <> 0
	|					ТОГДА ВТ_ИтогНДС.Регистратор
	|				КОГДА СведенияСчетовФактурПолученных.СчетФактура ЕСТЬ НЕ NULL 
	|						И ВТ_ИтогНДС.СуммаНДС <> 0
	|					ТОГДА СведенияСчетовФактурПолученных.СчетФактура
	|				ИНАЧЕ ""Документ зачета НДС не найден""
	|			КОНЕЦ) = ТИП(Документ.СчетФактураПолученный)
	|			ТОГДА ВЫРАЗИТЬ(ВЫБОР
	|						КОГДА СведенияСчетовФактурПолученных.СчетФактура ЕСТЬ NULL
	|								И ВТ_ИтогНДС.СуммаНДС <> 0
	|							ТОГДА ВТ_ИтогНДС.Регистратор
	|						КОГДА СведенияСчетовФактурПолученных.СчетФактура ЕСТЬ НЕ NULL 
	|								И ВТ_ИтогНДС.СуммаНДС <> 0
	|							ТОГДА СведенияСчетовФактурПолученных.СчетФактура
	|						ИНАЧЕ ""Документ зачета НДС не найден""
	|					КОНЕЦ КАК Документ.СчетФактураПолученный).Дата
	|	КОНЕЦ КАК ДатаСФ
	|ИЗ
	|	ВТ_ИтогНДС КАК ВТ_ИтогНДС
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.СведенияСчетовФактурПолученных КАК СведенияСчетовФактурПолученных
	|		ПО (ВЫБОР
	|				КОГДА ВТ_ИтогНДС.Документ.Ссылка ЕСТЬ НЕ NULL 
	|						И ВТ_ИтогНДС.Документ = ВТ_ИтогНДС.Регистратор
	|					ТОГДА ВТ_ИтогНДС.Документ = СведенияСчетовФактурПолученных.СчетФактура.ДокументОснование
	|				КОГДА ВТ_ИтогНДС.Документ.Ссылка ЕСТЬ НЕ NULL 
	|						И ВТ_ИтогНДС.Документ <> ВТ_ИтогНДС.Регистратор
	|					ТОГДА ВТ_ИтогНДС.Регистратор = СведенияСчетовФактурПолученных.СчетФактура.ДокументОснование
	|				ИНАЧЕ ЛОЖЬ
	|			КОНЕЦ)
	|
	|УПОРЯДОЧИТЬ ПО
	|	ДокументПартии УБЫВ
	|ИТОГИ
	|	ВЫБОР
	|		КОГДА ЕСТЬNULL(ПризнакУчетаПоСредней, ЛОЖЬ)
	|			ТОГДА МИНИМУМ(СуммаОстаток)
	|		ИНАЧЕ СУММА(СуммаОстаток)
	|	КОНЕЦ КАК СуммаОстаток,
	|	ВЫБОР
	|		КОГДА ЕСТЬNULL(ПризнакУчетаПоСредней, ЛОЖЬ)
	|			ТОГДА МИНИМУМ(КоличествоОстаток)
	|		ИНАЧЕ СУММА(КоличествоОстаток)
	|	КОНЕЦ КАК КоличествоОстаток,
	|	СУММА(СуммаДокумента),
	|	СУММА(КоличествоДокумента)
	|ПО
	|	ПризнакУчетаПоСредней,
	|	Номенклатура";
	
	Запрос.УстановитьПараметр("НачалоПериодаБезОграничений", Дата("00010101000000"));	
	Запрос.УстановитьПараметр("КонецПериода" , КонецДня(ПараметрыОтчета.КонецПериода));
	Запрос.УстановитьПараметр("Организация"  , ПараметрыОтчета.СписокСтруктурныхЕдиниц);
	
	Субконто = Новый СписокЗначений;
	Субконто.Добавить(ПланыВидовХарактеристик.ВидыСубконтоТиповые.Номенклатура);
	Субконто.Добавить(ПланыВидовХарактеристик.ВидыСубконтоТиповые.Склады);
	Субконто.Добавить(ПланыВидовХарактеристик.ВидыСубконтоТиповые.Партии);
	Запрос.УстановитьПараметр("Субконто", Субконто);	
	
	СубконтоДляСредней = Новый СписокЗначений;
	СубконтоДляСредней.Добавить(ПланыВидовХарактеристик.ВидыСубконтоТиповые.Номенклатура);
	СубконтоДляСредней.Добавить(ПланыВидовХарактеристик.ВидыСубконтоТиповые.Склады);
	Запрос.УстановитьПараметр("СубконтоДляСредней", СубконтоДляСредней);
	
	Если Не ЗначениеЗаполнено(ПараметрыОтчета.СписокСтруктурныхЕдиниц) Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "Организация В (&Организация)", "");
	КонецЕсли;
	
	ТаблицаДанных = Новый ТаблицаЗначений;
	Колонки = ТаблицаДанных.Колонки;
	Колонки.Добавить("Номенклатура");
	Колонки.Добавить("СуммаОстаток");
	Колонки.Добавить("КоличествоОстаток");
	Колонки.Добавить("СчетФактура");
	Колонки.Добавить("СуммаДокумента");
	Колонки.Добавить("КоличествоДокумента");
	Колонки.Добавить("СуммаНДС");
	Колонки.Добавить("СуммаОборотаБезНДС");
	Колонки.Добавить("НаименованиеДокумента");
	Колонки.Добавить("ДокументНДС");
	Колонки.Добавить("НомерСФ");
	Колонки.Добавить("ДатаСФ");
	Колонки.Добавить("ДокументПартии");
	Колонки.Добавить("ПризнакУчетаПоСредней");
	Колонки.Добавить("Счет");
	
	ВыборкаПризнакУчета = Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	Пока ВыборкаПризнакУчета.Следующий() Цикл
		ВыборкаНоменклатура = ВыборкаПризнакУчета.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
		Пока ВыборкаНоменклатура.Следующий() Цикл
			//Для товаров, по которым ведется учет по средней, пытаемся сумму остатка покрыть имеющимися документами оборота расчетным путем
			Если ВыборкаНоменклатура.ПризнакУчетаПоСредней Тогда
				КоличествоОстаток = ВыборкаНоменклатура.КоличествоОстаток;
				СуммаОстаток = ВыборкаНоменклатура.СуммаОстаток;
				ВыборкаДетали = ВыборкаНоменклатура.Выбрать();
				Пока ВыборкаДетали.Следующий() и СуммаОстаток>0 Цикл
					КСписаниюКоличество = Мин(КоличествоОстаток, ВыборкаДетали.КоличествоДокумента);
					КСписаниюСумма =  Мин(СуммаОстаток, ВыборкаДетали.СуммаДокумента);
					Если КСписаниюСумма = ВыборкаДетали.СуммаДокумента Тогда
						СуммаВыбр = ВыборкаДетали.СуммаДокумента;
						СуммаНДС = ВыборкаДетали.СуммаНДС;
						СуммаОборотаБезНДС = ВыборкаДетали.СуммаОборотаБезНДС;
					Иначе
						СуммаВыбр = КСписаниюСумма; 
						СуммаНДС = ?(ВыборкаДетали.СуммаОстаток=0,0,КСписаниюСумма * ВыборкаДетали.СуммаНДС / ВыборкаДетали.СуммаДокумента);
						СуммаОборотаБезНДС = ?(ВыборкаДетали.СуммаОстаток=0,0,КСписаниюСумма * ВыборкаДетали.СуммаОборотаБезНДС / ВыборкаДетали.СуммаДокумента);
					КонецЕсли;
					КоличествоОстаток = КоличествоОстаток - КСписаниюКоличество;
					СуммаОстаток = СуммаОстаток - СуммаВыбр;
					НоваяСтрока = ТаблицаДанных.Добавить();
					ЗаполнитьЗначенияСвойств(НоваяСтрока, ВыборкаДетали);
					НоваяСтрока.КоличествоДокумента = КСписаниюКоличество;
					НоваяСтрока.СуммаДокумента = СуммаВыбр;
					НоваяСтрока.СуммаНДС = СуммаНДС;
					НоваяСтрока.СуммаОборотаБезНДС = СуммаОборотаБезНДС;
					НоваяСтрока.СуммаОстаток = КСписаниюСумма; 
				КонецЦикла;
			//Для товаров, по которым ведется партионный учет, закрываем сумму остатка документами партии 	
			Иначе
				ВыборкаДетали = ВыборкаНоменклатура.Выбрать();
				Пока ВыборкаДетали.Следующий() Цикл
					КоличествоОстаток = ВыборкаДетали.КоличествоОстаток;
					СуммаОстаток = ВыборкаДетали.СуммаОстаток;
					КСписаниюКоличество = Мин(КоличествоОстаток, ВыборкаДетали.КоличествоДокумента);
					Если КСписаниюКоличество = ВыборкаДетали.КоличествоДокумента Тогда
						СуммаВыбр = ВыборкаДетали.СуммаДокумента;
						СуммаНДС = ВыборкаДетали.СуммаНДС;
						СуммаОборотаБезНДС = ВыборкаДетали.СуммаОборотаБезНДС;
					Иначе
						СуммаВыбр = ?(ВыборкаДетали.КоличествоОстаток=0,0,КСписаниюКоличество * ВыборкаДетали.СуммаДокумента / ВыборкаДетали.КоличествоДокумента);
						СуммаНДС = ?(ВыборкаДетали.КоличествоОстаток=0,0,КСписаниюКоличество * ВыборкаДетали.СуммаНДС / ВыборкаДетали.КоличествоДокумента);
						СуммаОборотаБезНДС = ?(ВыборкаДетали.КоличествоОстаток=0,0,КСписаниюКоличество * ВыборкаДетали.СуммаОборотаБезНДС / ВыборкаДетали.КоличествоДокумента);
					КонецЕсли;
					НоваяСтрока = ТаблицаДанных.Добавить();  
					ЗаполнитьЗначенияСвойств(НоваяСтрока, ВыборкаДетали);
					НоваяСтрока.КоличествоДокумента = КСписаниюКоличество;
					НоваяСтрока.СуммаДокумента = СуммаВыбр;
					НоваяСтрока.СуммаНДС = СуммаНДС;
					НоваяСтрока.СуммаОборотаБезНДС = СуммаОборотаБезНДС;
					КоличествоОстаток = КоличествоОстаток - КСписаниюКоличество;
					СуммаОстаток = СуммаОстаток - СуммаВыбр;
				КонецЦикла;
			КонецЕсли
		КонецЦикла;
	КонецЦикла;
	
	ВнешниеНаборыДанных = Новый Структура("ТаблицаДанных", ТаблицаДанных);
	
	Возврат ВнешниеНаборыДанных;
		                                
КонецФункции

// В процедуре можно доработать компоновщик перед выводом в отчет
// Изменения сохранены не будут
Процедура ПередКомпоновкойМакета(ПараметрыОтчета, Схема, КомпоновщикНастроек) Экспорт
	
	Если ПараметрыОтчета.ВидОтчета = "ПроизвольныйОтчет" ИЛИ ПараметрыОтчета.РежимРасшифровки Тогда
		Схема.МакетыЗаголовковГруппировок[0].ИмяГруппировки = "";
	Иначе
		Схема.МакетыЗаголовковГруппировок[0].ИмяГруппировки = "Группировка";
	КонецЕсли;
	
	//Задаем параметры
	БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "Периодичность", ПараметрыОтчета.Периодичность);
	
	Если ЗначениеЗаполнено(ПараметрыОтчета.НачалоПериода) Тогда
		БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "НачалоПериода", НачалоДня(ПараметрыОтчета.НачалоПериода));
	КонецЕсли;
	Если ЗначениеЗаполнено(ПараметрыОтчета.КонецПериода) Тогда
		БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "КонецПериода", КонецДня(ПараметрыОтчета.КонецПериода));
		БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "ПараметрПериод", КонецДня(ПараметрыОтчета.КонецПериода));
	Иначе
		БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "ПараметрПериод", КонецДня(ТекущаяДата()));
	КонецЕсли;
	
	БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "Налогоплательщик"              , ПараметрыОтчета.Налогоплательщик);
	Если ЗначениеЗаполнено(ПараметрыОтчета.СписокСтруктурныхЕдиниц) Тогда
		БухгалтерскиеОтчетыКлиентСервер.ДобавитьОтбор(КомпоновщикНастроек, "Организация", ПараметрыОтчета.СписокСтруктурныхЕдиниц, ВидСравненияКомпоновкиДанных.ВСписке);			
	КонецЕсли;
	
	// Дополнительные данные
	БухгалтерскиеОтчетыВызовСервера.ДобавитьДополнительныеПоля(ПараметрыОтчета, КомпоновщикНастроек);
	
	//Отбор
	БухгалтерскиеОтчеты.ДобавитьОтборПоОрганизациямИПодразделениям(КомпоновщикНастроек, ПараметрыОтчета);
	
	//Группировка
	//Очищаем группировку компоновщика и задаем группировку из настроек
	КомпоновщикНастроек.Настройки.Структура.Очистить();
	
	Структура = КомпоновщикНастроек.Настройки;
	Для Каждого ПолеВыбраннойГруппировки Из ПараметрыОтчета.Группировка Цикл 
		Если ПолеВыбраннойГруппировки.Использование Тогда
			Структура = Структура.Структура.Добавить(Тип("ГруппировкаКомпоновкиДанных"));
			ПолеГруппировки = Структура.ПоляГруппировки.Элементы.Добавить(Тип("ПолеГруппировкиКомпоновкиДанных"));
			ПолеГруппировки.Использование  = Истина;
			ПолеГруппировки.Поле           = Новый ПолеКомпоновкиДанных(ПолеВыбраннойГруппировки.Поле);
			Если ПолеВыбраннойГруппировки.ТипГруппировки = Перечисления.ТипДетализацииСтандартныхОтчетов.Иерархия Тогда
				ПолеГруппировки.ТипГруппировки = ТипГруппировкиКомпоновкиДанных.Иерархия;
			ИначеЕсли ПолеВыбраннойГруппировки.ТипГруппировки = Перечисления.ТипДетализацииСтандартныхОтчетов.ТолькоИерархия Тогда
				ПолеГруппировки.ТипГруппировки = ТипГруппировкиКомпоновкиДанных.ТолькоИерархия;
			Иначе
				ПолеГруппировки.ТипГруппировки = ТипГруппировкиКомпоновкиДанных.Элементы;
			КонецЕсли;
			//Для налогового регистра добавляем поле
			Если ПолеВыбраннойГруппировки.Поле = "Номенклатура" Тогда
				ПолеВыбора = Структура.Выбор.Элементы.Добавить(Тип("ВыбранноеПолеКомпоновкиДанных"));
				ПолеВыбора.Заголовок = "№ п/п";
				ПолеВыбора.Поле = Новый ПолеКомпоновкиДанных("СистемныеПоля.НомерПоПорядкуВГруппировке");;
			КонецЕсли;
			Структура.Выбор.Элементы.Добавить(Тип("АвтоВыбранноеПолеКомпоновкиДанных"));
			Структура.Порядок.Элементы.Добавить(Тип("АвтоЭлементПорядкаКомпоновкиДанных"));
		КонецЕсли;
	КонецЦикла;
	
	Структура = Структура.Структура.Добавить(Тип("ГруппировкаКомпоновкиДанных"));
	ПолеГруппировки = Структура.ПоляГруппировки.Элементы.Добавить(Тип("ПолеГруппировкиКомпоновкиДанных"));
	ПолеГруппировки.Использование  = Истина;
	ПолеГруппировки.Поле           = Новый ПолеКомпоновкиДанных("");
	ПолеГруппировки.ТипГруппировки = ТипГруппировкиКомпоновкиДанных.Элементы;
	Структура.Выбор.Элементы.Добавить(Тип("АвтоВыбранноеПолеКомпоновкиДанных"));
	Структура.Порядок.Элементы.Добавить(Тип("АвтоЭлементПорядкаКомпоновкиДанных"));
	
	// Период
	БухгалтерскиеОтчетыВызовСервера.ДобавитьГруппировкуПоПериоду(ПараметрыОтчета, Структура);
	
	
КонецПроцедуры

Процедура ПослеВыводаРезультата(ПараметрыОтчета, Результат) Экспорт
	
	БухгалтерскиеОтчетыВызовСервера.ОбработкаРезультатаОтчета(ПараметрыОтчета.ИдентификаторОтчета, Результат);

КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ
Процедура ЗаполнитьПараметрыРасшифровкиОтчета(Адрес, Расшифровка, ПараметрыРасшифровки) Экспорт
	
	// Инициализируем список мунктов меню
	СписокПунктовМеню = Новый СписокЗначений();
	
	// Заполниим соответствие полей которые мы хотим получить из данных расшифровки
	СоответствиеПолей = Новый Структура();
	ДанныеОтчета = ПолучитьИзВременногоХранилища(Адрес);
	
	
	ЗначениеРасшифровки = ДанныеОтчета.ДанныеРасшифровки.Элементы[Расшифровка];
	Если ТипЗнч(ЗначениеРасшифровки) = Тип("ЭлементРасшифровкиКомпоновкиДанныхПоля") Тогда
		Для Каждого ПолеРасшифровки ИЗ ЗначениеРасшифровки.ПолучитьПоля() Цикл
			Если ЗначениеЗаполнено(ПолеРасшифровки.Значение) И ПолеРасшифровки.Значение <> "Показатель" И ПолеРасшифровки.Значение <> "ПоказательПартии" Тогда
				ПараметрыРасшифровки.Вставить("ОткрытьОбъект", Истина);
				ПараметрыРасшифровки.Вставить("Значение",  ПолеРасшифровки.Значение);
				Возврат;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	// Укажем что открывать объект сразу не нужно
	ПараметрыРасшифровки.Вставить("ОткрытьОбъект", Ложь);
	
	Если ДанныеОтчета = Неопределено Тогда 
		ПараметрыРасшифровки.Вставить("СписокПунктовМеню", СписокПунктовМеню);
		Возврат;
	Иначе
		Если ДанныеОтчета.Объект.РежимРасшифровки Тогда
			ПараметрыРасшифровки.Вставить("СписокПунктовМеню", СписокПунктовМеню);
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
	КомпоновщикНастроек = Новый КомпоновщикНастроекКомпоновкиДанных;
	КомпоновщикНастроек.ЗагрузитьНастройки(ДанныеОтчета.ДанныеРасшифровки.Настройки);
	КомпоновщикНастроек.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(ДанныеОтчета.Объект.СхемаКомпоновкиДанных));
	
	МассивПолей = БухгалтерскиеОтчетыВызовСервера.ПолучитьМассивПолейРасшифровки(Расшифровка, ДанныеОтчета.ДанныеРасшифровки, КомпоновщикНастроек, Истина);
	РасшифровкаОборотаНДС = Ложь;
	Показатель = "Показатель";//Параметр расшифровки поля из макета
	Для Каждого ПолеРасшифровки Из МассивПолей Цикл
		Если ТипЗнч(ПолеРасшифровки) = Тип("ЗначениеПоляРасшифровкиКомпоновкиДанных")
			И (ПолеРасшифровки.Значение = "Показатель" ИЛИ ПолеРасшифровки.Значение = "ПоказательПартии") Тогда
			Показатель = ПолеРасшифровки.Поле;
			РасшифровкаОборотаНДС = ПолеРасшифровки.Значение = "ПоказательПартии"; 
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	// Прежде всего интересны данные группировочных полей
	Для Каждого Группировка Из ДанныеОтчета.Объект.Группировка Цикл
		Если Группировка.Использование Тогда
			СоответствиеПолей.Вставить(Группировка.Поле);
		КонецЕсли;
	КонецЦикла;
	
	СоответствиеПолей.Вставить("Период");
	СоответствиеПолей.Вставить("Показатель");
		
	// Инициализация пользовательских настроек
	ПользовательскиеНастройки = Новый ПользовательскиеНастройкиКомпоновкиДанных;
	ДополнительныеСвойства = ПользовательскиеНастройки.ДополнительныеСвойства;
	ДополнительныеСвойства.Вставить("РежимРасшифровки",  Истина);
	ДополнительныеСвойства.Вставить("НачалоПериода",     ДанныеОтчета.Объект.НачалоПериода);
	ДополнительныеСвойства.Вставить("КонецПериода",      ДанныеОтчета.Объект.КонецПериода);
	ДополнительныеСвойства.Вставить("ВыводитьЗаголовок", ДанныеОтчета.Объект.ВыводитьЗаголовок);
	ДополнительныеСвойства.Вставить("ВыводитьПодписи",   ДанныеОтчета.Объект.ВыводитьПодписи);
	ДополнительныеСвойства.Вставить("МакетОформления",   ДанныеОтчета.Объект.МакетОформления);
	ДополнительныеСвойства.Вставить("ВыводитьДиаграмму", Ложь);
	ДополнительныеСвойства.Вставить("ПоказательБУ",      Истина);
	ДополнительныеСвойства.Вставить("СписокСтруктурныхЕдиниц", ДанныеОтчета.Объект.СписокСтруктурныхЕдиниц);
	ДополнительныеСвойства.Вставить("ВидОтчета", 		 ДанныеОтчета.Объект.ВидОтчета);
	ДополнительныеСвойства.Вставить("Налогоплательщик" , ДанныеОтчета.Объект.Налогоплательщик);
	
	// Получаем соответствие полей доступных в расшифровке
	Данные_Расшифровки = Новый Соответствие();
	
	Если ДанныеОтчета.ДанныеРасшифровки <> Неопределено Тогда
		// Ищем интересующие нас поля в заданной расшифровке
		Для каждого ЭлементДанных Из СоответствиеПолей Цикл
			// Получаем элемент расшифровки, в котором нужно искать поля
			Родитель = ДанныеОтчета.ДанныеРасшифровки.Элементы[Расшифровка];
			// Вызываем рекурсивный поиск поля
			ЗначениеРасшифровки = ПолучитьЗначениеРасшифровки(Родитель, ЭлементДанных.Ключ);
			Если ЗначениеРасшифровки <> Неопределено Тогда
				// Значение нашлось, помещаем в структуру
				Данные_Расшифровки.Вставить(ЭлементДанных.Ключ, ЗначениеРасшифровки);
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	//Добавляем источник расшифровки
	СписокПунктовМеню.Добавить("РегистрНалоговогоУчетаПоОборотуВВидеОстатковТоваров", НСтр("ru = 'Налоговый регистр по обороту в виде остатков товаров '")); //Вставляем название отчета
	ИДРасшифровки = "РегистрНалоговогоУчетаПоОборотуВВидеОстатковТоваров"; //Вставляем название отчета
	
	Период = Данные_Расшифровки.Получить("Период");
	
	Если ЗначениеЗаполнено(Период) Тогда
		ДополнительныеСвойства.Вставить("КонецПериода" , КонецДня(БухгалтерскиеОтчетыКлиентСервер.КонецПериода(Период, "ДЕНЬ")));
		ДополнительныеСвойства.Вставить("НачалоПериода", НачалоДня(БухгалтерскиеОтчетыКлиентСервер.НачалоПериода(Период, "ДЕНЬ")));
	КонецЕсли;
	
	ОтборПоЗначениямРасшифровки = ПользовательскиеНастройки.Элементы.Добавить(Тип("ОтборКомпоновкиДанных"));
	ОтборПоЗначениямРасшифровки.ИдентификаторПользовательскойНастройки = "Отбор";
	
	Для Каждого ЗначениеРасшифровки Из Данные_Расшифровки Цикл
		Если ЗначениеРасшифровки.Ключ <> "Период" Тогда
			БухгалтерскиеОтчетыКлиентСервер.ДобавитьОтбор(ОтборПоЗначениямРасшифровки, ЗначениеРасшифровки.Ключ, ЗначениеРасшифровки.Значение);
		КонецЕсли;
	КонецЦикла;
	
	//Передаем текущую группировку в расшифровку
	Группировка = Новый Массив();
	Для Каждого СтрокаГруппировки Из ДанныеОтчета.Объект.Группировка Цикл
		Если СтрокаГруппировки.Использование Тогда
			СтрокаДляРасшифровки = Новый Структура("Использование, Поле, Представление, ТипГруппировки");
			ЗаполнитьЗначенияСвойств(СтрокаДляРасшифровки, СтрокаГруппировки);
			Группировка.Добавить(СтрокаДляРасшифровки);
		КонецЕсли;
	КонецЦикла;
	ДополнительныеСвойства.Вставить("Группировка", Группировка);
	
	//Передаем дополнительные поля, которыми будем расшифровывать
	ДополнительныеПоля = Новый Массив();
	Если ДанныеОтчета.Объект.ВидОтчета = "ПроизвольныйОтчет" Тогда
		Для Каждого СтрокаДополнительногоПоля Из ДанныеОтчета.Объект.ДополнительныеПоля Цикл
			Если СтрокаДополнительногоПоля.Использование Тогда
				СтрокаДляРасшифровки = Новый Структура("Использование, Поле, Представление, ТипГруппировки");
				ЗаполнитьЗначенияСвойств(СтрокаДляРасшифровки, СтрокаДополнительногоПоля);
				ДополнительныеПоля.Добавить(СтрокаДляРасшифровки);
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	ДополнительноеПоле = Новый Структура("Использование, Поле, Представление, ТипГруппировки",
	                                   Истина, ?(РасшифровкаОборотаНДС ,"ДокументПартии","СчетФактура"), "Документ", Перечисления.ТипДетализацииСтандартныхОтчетов.Элементы);
	ДополнительныеПоля.Добавить(ДополнительноеПоле);
	ДополнительныеСвойства.Вставить("ДополнительныеПоля", ДополнительныеПоля);
	
	НастройкиРасшифровки = Новый Структура();
	НастройкиРасшифровки.Вставить(ИДРасшифровки , ПользовательскиеНастройки);
	ДанныеОтчета.Вставить("НастройкиРасшифровки", НастройкиРасшифровки);
	
	ПоместитьВоВременноеХранилище(ДанныеОтчета, Адрес);
	
	ПараметрыРасшифровки.Вставить("СписокПунктовМеню", СписокПунктовМеню);
	
КонецПроцедуры

// Возвращает значение искомого поля из элемента расшифровки.
//
Функция ПолучитьЗначениеРасшифровки(Элемент, ИмяПоля)
	
	Если ТипЗнч(Элемент) = Тип("ЭлементРасшифровкиКомпоновкиДанныхПоля") Тогда
		// Ищем поля в текущем элементе
		Поле = Элемент.ПолучитьПоля().Найти(ИмяПоля);
		Если Поле <> Неопределено Тогда
			// Возвращаем значение найденного поля
			Возврат Поле.Значение;
		КонецЕсли;
	КонецЕсли;
	
	// Если поле не нашлось, или текущий элемент не содержит полей
	// ищем поля среди родителей элемента (вышестоящие группировки).
	Родители  = Элемент.ПолучитьРодителей();
	Если Родители.Количество() > 0 Тогда
		
		Для Каждого Родитель Из Родители Цикл
			// Вызываем рекурсивный поиск поля
			ЗначениеРасшифровки = ПолучитьЗначениеРасшифровки(Родитель, ИмяПоля);
			
			Если ЗначениеРасшифровки <> Неопределено Тогда
				Возврат ЗначениеРасшифровки;
			КонецЕсли;
			
		КонецЦикла;
	КонецЕсли;
	
	// Если ничего не нашлось
	Возврат Неопределено;
	
КонецФункции


#КонецЕсли