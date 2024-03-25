﻿Функция КонтейнерМетодов() Экспорт
	
	Контейнер = Неопределено;
	ИспользоватьВнешнююОбработку = ЭСФВызовСервера.ИспользоватьВнешнююОбработку();
	
	#Если ТолстыйКлиентОбычноеПриложение Тогда
		
		// Если база клиент-серверная, то это точно только клиент.
		// Если база файловая, то это может быть как клиент, так и сервер.
		
		// Если выполняется препроцессоре ТолстыйКлиентОбычноеПриложение,
		// то код ВнешниеОбработки.Подключить() вызовет ошибку,
		// поэтому внешняя обработка для данного режима подлкючается через файл.
		
		Контейнер = Неопределено;
		
	#ИначеЕсли ТонкийКлиент ИЛИ ВебКлиент ИЛИ ТолстыйКлиентУправляемоеПриложение Тогда
		
		// Это точно клиент на управляемые формы.
		
		Если ИспользоватьВнешнююОбработку Тогда
			ИмяВнешнейОбработки = ЭСФВызовСервера.ПодключитьВнешнююОбработку();
			Контейнер = ПолучитьФорму("ВнешняяОбработка." + ИмяВнешнейОбработки + ".Форма.КлиентУправляемаяВС");
		Иначе
			Контейнер = ПолучитьФорму("Обработка.ОбменЭСФ.Форма.КлиентУправляемаяВС");
		КонецЕсли;
		
	#ИначеЕсли Сервер ИЛИ ВнешнееСоединение Тогда
		
		// Это сервер и только сервер, без разницы управляемое приложение или обычное.
		
		Если ИспользоватьВнешнююОбработку Тогда
			ИмяВнешнейОбработки = ЭСФВызовСервера.ПодключитьВнешнююОбработку();
			Контейнер = ВнешниеОбработки.Создать(ИмяВнешнейОбработки);
		Иначе
			Контейнер = Обработки.ОбменЭСФ.Создать();
		КонецЕсли;
		
	#Иначе
		
		// Вызов переопределяемого модуля для остальных видов инструкций препроцессора.
		
		ВСКлиентСерверПереопределяемый.КонтейнерМетодов(Контейнер, ИспользоватьВнешнююОбработку);
		
	#КонецЕсли
	
	Возврат Контейнер;
	
КонецФункции

Функция НоваяКоллекцияПодписейЭД(Знач КоллекцияSignedContent, Знач ДанныеКлючаЭЦП, ДанныеПрофиляИСЭСФ = Неопределено) Экспорт
	
	Контейнер = ВСКлиентСервер.КонтейнерМетодов();
	
	КоллекцияПодписейЭСФ = Новый Соответствие;
	Для Каждого Элемент Из КоллекцияSignedContent Цикл
		Подпись = Контейнер.СоздатьЭЦП(Элемент.Значение, ДанныеКлючаЭЦП.КлючBase64, ДанныеКлючаЭЦП.Пароль);
		КоллекцияПодписейЭСФ.Вставить(Элемент.Ключ, Подпись);
	КонецЦикла;
		
	Возврат КоллекцияПодписейЭСФ;
	
КонецФункции


////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКИИ

#Область ПреобразованиеСтроковыхТиповВТипыИБ_И_Обратно

Функция СтатусИБ(Знач СтатусУТТН) Экспорт
	
	
	ВРегСтатусИСЭСФ = ВРег(СтатусУТТН);
	
	Если ВРегСтатусИСЭСФ = "CREATED" Тогда
		Статус = ПредопределенноеЗначение("Перечисление.СтатусыУТТН.Созданный");
		
	ИначеЕсли ВРегСтатусИСЭСФ = "PROCESSED" Тогда
		Статус = ПредопределенноеЗначение("Перечисление.СтатусыУТТН.Обработанный");
		
	ИначеЕсли ВРегСтатусИСЭСФ = "CANCELED" Тогда
		Статус = ПредопределенноеЗначение("Перечисление.СтатусыУТТН.Отмененный");
		
	ИначеЕсли ВРегСтатусИСЭСФ = "FAILED" Тогда
		Статус = ПредопределенноеЗначение("Перечисление.СтатусыУТТН.Ошибочный");
		
	ИначеЕсли ВРегСтатусИСЭСФ = "DRAFT" Тогда
		Статус = ПредопределенноеЗначение("Перечисление.СтатусыУТТН.Черновик");
		
	ИначеЕсли ВРегСтатусИСЭСФ = "IN_PROCESSING" Тогда
		Статус = ПредопределенноеЗначение("Перечисление.СтатусыУТТН.Обрабатывается");
	
	Иначе
		Статус = ПредопределенноеЗначение("Перечисление.СтатусыУТТН.ПустаяСсылка");
		
	КонецЕсли;
	
	Возврат Статус;
	
КонецФункции

Функция ВидФормы_ИСЭСФ(Знач ВидИБ) Экспорт
	
	Если ВидИБ = ПредопределенноеЗначение("Перечисление.ТипыФормВС.ВнутреннееПеремещение")
		ИЛИ ВидИБ = ПредопределенноеЗначение("Перечисление.ТипыФормВС.ДекларацияНаТовары") 
		ИЛИ ВидИБ = ПредопределенноеЗначение("Перечисление.ТипыФормВС.ПеремещениеМеждуФилиалами") Тогда
		
		Вид = "MOVEMENT";
		
	ИначеЕсли ВидИБ = ПредопределенноеЗначение("Перечисление.ТипыФормВС.Производство") Тогда
		Вид = "MANUFACTURE";
		
	ИначеЕсли ВидИБ = ПредопределенноеЗначение("Перечисление.ТипыФормВС.Остатки")
		ИЛИ ВидИБ = ПредопределенноеЗначение("Перечисление.ТипыФормВС.ВводОстатковНаВС") Тогда
		
		Вид = "BALANCE";
		
	ИначеЕсли ВидИБ = ПредопределенноеЗначение("Перечисление.ТипыФормВС.СписаниеТоваровНеВС") Тогда
		Вид = "WRITE_OFF";	
		
	ИначеЕсли ВидИБ = ПредопределенноеЗначение("Перечисление.ТипыФормВС.Списание") Тогда
		Вид = "WRITE_OFF";	
		
	ИначеЕсли ВидИБ = ПредопределенноеЗначение("Перечисление.ТипыФормВС.КорректировкаОстатков") Тогда
		Вид = "BALANCE_CORRECTION";		
		
	ИначеЕсли ВидИБ = ПредопределенноеЗначение("Перечисление.ТипыФормВС.Детализация") Тогда
		Вид = "DETAILING";
		
	ИначеЕсли ВидИБ = ПредопределенноеЗначение("Перечисление.ТипыФормВС.ФизическаяМетка") Тогда
		Вид = "PHYSICAL_LABEL";
		
	ИначеЕсли ВидИБ = ПредопределенноеЗначение("Перечисление.ТипыФормВС.ДетализацияИмпорта") Тогда
		Вид = "IMPORT_DETAILING";
	Иначе	
		Вид = "";
		
	КонецЕсли;
	
	Возврат Вид;
	
КонецФункции

Функция ВидФормы_ИБ(Знач ТипУТТН) Экспорт
	
	
	ВРегвидУТТН = ВРег(ТипУТТН);
	
	Если ВРегвидУТТН = "MOVEMENT" Тогда
		ТипФормы = ПредопределенноеЗначение("Перечисление.ТипыФормВС.ВнутреннееПеремещение");
		
	ИначеЕсли ВРегвидУТТН = "MANUFACTURE" Тогда
		ТипФормы = ПредопределенноеЗначение("Перечисление.ТипыФормВС.Производство");
		
	ИначеЕсли ВРегвидУТТН = "BALANCE" Тогда
		ТипФормы = ПредопределенноеЗначение("Перечисление.ТипыФормВС.Остатки");
		
	ИначеЕсли ВРегвидУТТН = "WRITE_OFF" Тогда
		ТипФормы = ПредопределенноеЗначение("Перечисление.ТипыФормВС.Списание");
		
	ИначеЕсли ВРегвидУТТН = "BALANCE_CORRECTION" Тогда
		ТипФормы = ПредопределенноеЗначение("Перечисление.ТипыФормВС.КорректировкаОстатков");
		
	ИначеЕсли ВРегвидУТТН = "DETAILING" Тогда
		ТипФормы = ПредопределенноеЗначение("Перечисление.ТипыФормВС.Детализация");
	
	ИначеЕсли ВРегвидУТТН = "PHYSICAL_LABEL" Тогда
		ТипФормы = ПредопределенноеЗначение("Перечисление.ТипыФормВС.ФизическаяМетка");
		
	ИначеЕсли ВРегвидУТТН = "IMPORT_DETAILING" Тогда
		ТипФормы = ПредопределенноеЗначение("Перечисление.ТипыФормВС.ДетализацияИмпорта");
		
	Иначе
		ТипФормы = "";
		
	КонецЕсли;
	
	Возврат ТипФормы;
	
КонецФункции

Функция ПричинаСписания_ИСЭСФ(Знач ПричинаИБ) Экспорт
	
	Если ПричинаИБ = ПредопределенноеЗначение("Перечисление.ПричинаСписанияВС.Производство") Тогда
		Причина = "MANUFACTURE";
		
	ИначеЕсли ПричинаИБ = ПредопределенноеЗначение("Перечисление.ПричинаСписанияВС.Порча") Тогда
		Причина = "DAMAGE";
		
	ИначеЕсли ПричинаИБ = ПредопределенноеЗначение("Перечисление.ПричинаСписанияВС.Утилизация") Тогда
		Причина = "RECYCLING";
		
	ИначеЕсли ПричинаИБ = ПредопределенноеЗначение("Перечисление.ПричинаСписанияВС.Рекламация") Тогда
		Причина = "RECLAMATION";	
		
	ИначеЕсли ПричинаИБ = ПредопределенноеЗначение("Перечисление.ПричинаСписанияВС.Утеря") Тогда
		Причина = "LOSS";		
		
	ИначеЕсли ПричинаИБ = ПредопределенноеЗначение("Перечисление.ПричинаСписанияВС.НеУчитываетсяНаВС") Тогда
		Причина = "IS_NOT_VSTORE";
		
	ИначеЕсли ПричинаИБ = ПредопределенноеЗначение("Перечисление.ПричинаСписанияВС.РеализованоВРозничнойТорговле") Тогда
		Причина = "SOLD_IN_RETAIL_OR_COUPONS";
		
	ИначеЕсли ПричинаИБ = ПредопределенноеЗначение("Перечисление.ПричинаСписанияВС.НаМедицинскиеНужды") Тогда
		Причина = "MEDICAL_NEEDS";
		
	ИначеЕсли ПричинаИБ = ПредопределенноеЗначение("Перечисление.ПричинаСписанияВС.НаТехническиеНужды") Тогда
		Причина = "TECHNICAL_NEEDS";
		
	ИначеЕсли ПричинаИБ = ПредопределенноеЗначение("Перечисление.ПричинаСписанияВС.ЕстественнаяУбыльВПределахНорм") Тогда
		Причина = "NATURAL_DECREASE_IN_NORM";
		
	ИначеЕсли ПричинаИБ = ПредопределенноеЗначение("Перечисление.ПричинаСписанияВС.ЕстественнаяУбыльСверхНорм") Тогда
		Причина = "NATURAL_DECREASE_OVER_NORM";
		
	ИначеЕсли ПричинаИБ = ПредопределенноеЗначение("Перечисление.ПричинаСписанияВС.Хищение") Тогда
		Причина = "THEFT";
		
	ИначеЕсли ПричинаИБ = ПредопределенноеЗначение("Перечисление.ПричинаСписанияВС.ЗаСчетВиновногоЛица") Тогда
		Причина = "WRITE_OFF_BY_GUILTY";
		
	ИначеЕсли ПричинаИБ = ПредопределенноеЗначение("Перечисление.ПричинаСписанияВС.СоциальныйПакет") Тогда
		Причина = "SOCIAL_PACKAGE";
		
	ИначеЕсли ПричинаИБ = ПредопределенноеЗначение("Перечисление.ПричинаСписанияВС.ОтсутствуетТребованиеСНТ") Тогда
		Причина = "NO_REQUIREMENTS_FOR_SNT";
		
	ИначеЕсли ПричинаИБ = ПредопределенноеЗначение("Перечисление.ПричинаСписанияВС.ПереработкаДавальческогоСырья") Тогда
		Причина = "CONVERSION";
		
	ИначеЕсли ПричинаИБ = ПредопределенноеЗначение("Перечисление.ПричинаСписанияВС.Услуга") Тогда
		Причина = "SERVICE";
		
	ИначеЕсли ПричинаИБ = ПредопределенноеЗначение("Перечисление.ПричинаСписанияВС.ТоварВведенОшибочно") Тогда
		Причина = "MISTAKE";
		
	ИначеЕсли ПричинаИБ = ПредопределенноеЗначение("Перечисление.ПричинаСписанияВС.УчетОСФА") Тогда
		Причина = "ACCOUNTING_FIXED_ASSETS";
		
	ИначеЕсли ПричинаИБ = ПредопределенноеЗначение("Перечисление.ПричинаСписанияВС.РеализованоПоВсемВидамОплат") Тогда
		Причина = "COUPONS_OR_CARDS_PAYMENTS";
	
	ИначеЕсли ПричинаИБ = ПредопределенноеЗначение("Перечисление.ПричинаСписанияВС.Прочие") Тогда
		Причина = "OTHER";			
		
	Иначе
		Причина = "";
		
	КонецЕсли;
																		
	Возврат Причина;
	
КонецФункции

Функция ТипДетализации_ИСЭСФ(Знач ТипДетализацииИБ) Экспорт

	Если ТипДетализацииИБ = ПредопределенноеЗначение("Перечисление.ВидДетализации.Комплектация") Тогда
		ТипДетализации = "PACKING";
		
	ИначеЕсли ТипДетализацииИБ = ПредопределенноеЗначение("Перечисление.ВидДетализации.КонвертацияМеждуЕИ") Тогда
		ТипДетализации = "CONVERSION";
		
	ИначеЕсли ТипДетализацииИБ = ПредопределенноеЗначение("Перечисление.ВидДетализации.Разукомплектация") Тогда
		ТипДетализации = "UNPACKING";
		
	ИначеЕсли ТипДетализацииИБ = ПредопределенноеЗначение("Перечисление.ВидДетализации.Пересортица") Тогда
		ТипДетализации = "RE_SORTING";
		
	ИначеЕсли ТипДетализацииИБ = ПредопределенноеЗначение("Перечисление.ВидДетализации.РедактированиеДанных") Тогда
		ТипДетализации = "EDITING";	
		
	Иначе
		ТипДетализации = "";
		
	КонецЕсли;
																		
	Возврат ТипДетализации;

КонецФункции

Функция ТпПошлины_ИСЭСФ(Знач ТипПошлиныИБ) Экспорт
	
	Если ТипПошлиныИБ = ПредопределенноеЗначение("Перечисление.ТипыПошлинВС.ВТО") Тогда
		ТипПошлины = "WTO";
	ИначеЕсли ТипПошлиныИБ = ПредопределенноеЗначение("Перечисление.ТипыПошлинВС.ЕАЭС") Тогда
		ТипПошлины = "EAEU";
	ИначеЕсли ТипПошлиныИБ = ПредопределенноеЗначение("Перечисление.ТипыПошлинВС.ЕТТ") Тогда
		ТипПошлины = "CCT";
	Иначе
		ТипПошлины = "NOT_INSTALLED";
	КонецЕсли;
	
	Возврат ТипПошлины;		
		
КонецФункции

Функция ПричинаСписания_ИБ(Знач ПричинаИСЭСФ) Экспорт
	
	Если ПричинаИСЭСФ = "MANUFACTURE" Тогда
		ПричинаИБ = ПредопределенноеЗначение("Перечисление.ПричинаСписанияВС.Производство");
		
	ИначеЕсли ПричинаИСЭСФ = "DAMAGE" Тогда
		ПричинаИБ = ПредопределенноеЗначение("Перечисление.ПричинаСписанияВС.Порча");
		
	ИначеЕсли ПричинаИСЭСФ = "RECYCLING" Тогда
		ПричинаИБ = ПредопределенноеЗначение("Перечисление.ПричинаСписанияВС.Утилизация");
		
	ИначеЕсли ПричинаИСЭСФ = "RECLAMATION" Тогда
		ПричинаИБ = ПредопределенноеЗначение("Перечисление.ПричинаСписанияВС.Рекламация");	
		
	ИначеЕсли ПричинаИСЭСФ = "LOSS" Тогда
		ПричинаИБ = ПредопределенноеЗначение("Перечисление.ПричинаСписанияВС.Утеря");		
		
	ИначеЕсли ПричинаИСЭСФ = "IS_NOT_VSTORE" Тогда
		ПричинаИБ = ПредопределенноеЗначение("Перечисление.ПричинаСписанияВС.НеУчитываетсяНаВС");	
		
	ИначеЕсли ПричинаИСЭСФ = "SOLD_IN_RETAIL_OR_COUPONS" Тогда
		ПричинаИБ = ПредопределенноеЗначение("Перечисление.ПричинаСписанияВС.РеализованоВРозничнойТорговле");
		
	ИначеЕсли ПричинаИСЭСФ = "MEDICAL_NEEDS" Тогда
		ПричинаИБ = ПредопределенноеЗначение("Перечисление.ПричинаСписанияВС.НаМедицинскиеНужды");
		
	ИначеЕсли ПричинаИСЭСФ = "TECHNICAL_NEEDS" Тогда
		ПричинаИБ = ПредопределенноеЗначение("Перечисление.ПричинаСписанияВС.НаТехническиеНужды");
		
	ИначеЕсли ПричинаИСЭСФ = "NATURAL_DECREASE_IN_NORM" Тогда
		ПричинаИБ = ПредопределенноеЗначение("Перечисление.ПричинаСписанияВС.ЕстественнаяУбыльВПределахНорм");
		
	ИначеЕсли ПричинаИСЭСФ = "NATURAL_DECREASE_OVER_NORM" Тогда
		ПричинаИБ = ПредопределенноеЗначение("Перечисление.ПричинаСписанияВС.ЕстественнаяУбыльСверхНорм");
		
	ИначеЕсли ПричинаИСЭСФ = "THEFT" Тогда
		ПричинаИБ = ПредопределенноеЗначение("Перечисление.ПричинаСписанияВС.Хищение");
		
	ИначеЕсли ПричинаИСЭСФ = "WRITE_OFF_BY_GUILTY" Тогда
		ПричинаИБ = ПредопределенноеЗначение("Перечисление.ПричинаСписанияВС.ЗаСчетВиновногоЛица");
		
	ИначеЕсли ПричинаИСЭСФ = "SOCIAL_PACKAGE" Тогда
		ПричинаИБ = ПредопределенноеЗначение("Перечисление.ПричинаСписанияВС.СоциальныйПакет");
		
	ИначеЕсли ПричинаИСЭСФ = "NO_REQUIREMENTS_FOR_SNT" Тогда
		ПричинаИБ = ПредопределенноеЗначение("Перечисление.ПричинаСписанияВС.ОтсутствуетТребованиеСНТ");
		
	ИначеЕсли ПричинаИСЭСФ = "CONVERSION" Тогда
		ПричинаИБ = ПредопределенноеЗначение("Перечисление.ПричинаСписанияВС.ПереработкаДавальческогоСырья");
		
	ИначеЕсли ПричинаИСЭСФ = "SERVICE" Тогда
		ПричинаИБ = ПредопределенноеЗначение("Перечисление.ПричинаСписанияВС.Услуга");
		
	ИначеЕсли ПричинаИСЭСФ = "MISTAKE" Тогда
		ПричинаИБ = ПредопределенноеЗначение("Перечисление.ПричинаСписанияВС.ТоварВведенОшибочно");
		
	ИначеЕсли ПричинаИСЭСФ = "ACCOUNTING_FIXED_ASSETS" Тогда
		ПричинаИБ = ПредопределенноеЗначение("Перечисление.ПричинаСписанияВС.УчетОСФА");
		
	ИначеЕсли ПричинаИСЭСФ = "COUPONS_OR_CARDS_PAYMENTS" Тогда
		ПричинаИБ = ПредопределенноеЗначение("Перечисление.ПричинаСписанияВС.РеализованоПоВсемВидамОплат");
	
	ИначеЕсли ПричинаИСЭСФ = "OTHER" Тогда
		ПричинаИБ = ПредопределенноеЗначение("Перечисление.ПричинаСписанияВС.Прочие");			
		
	Иначе
		ПричинаИБ = "";
		
	КонецЕсли;
	
	Возврат ПричинаИБ;
	
КонецФункции

Функция ТипДетализации_ИБ(Знач ТипДетализацииИСЭСФ) Экспорт

	Если ТипДетализацииИСЭСФ = "PACKING" Тогда
		ТипДетализацииИБ = ПредопределенноеЗначение("Перечисление.ВидДетализации.Комплектация");
		
	ИначеЕсли ТипДетализацииИСЭСФ = "CONVERSION" Тогда
		ТипДетализацииИБ = ПредопределенноеЗначение("Перечисление.ВидДетализации.КонвертацияМеждуЕИ");
		
	ИначеЕсли ТипДетализацииИСЭСФ = "UNPACKING" Тогда
		ТипДетализацииИБ = ПредопределенноеЗначение("Перечисление.ВидДетализации.Разукомплектация");
		
	ИначеЕсли ТипДетализацииИСЭСФ = "RE_SORTING" Тогда
		ТипДетализацииИБ = ПредопределенноеЗначение("Перечисление.ВидДетализации.Пересортица");
		
	ИначеЕсли ТипДетализацииИСЭСФ = "EDITING" Тогда
		ТипДетализацииИБ = ПредопределенноеЗначение("Перечисление.ВидДетализации.РедактированиеДанных");	
		
	Иначе
		ТипДетализацииИБ = "";
		
	КонецЕсли;
																		
	Возврат ТипДетализацииИБ;

КонецФункции

Функция ТпПошлины_ИБ(Знач ТипПошлиныИСЭСФ) Экспорт
	
	Если ТипПошлиныИСЭСФ = "WTO" Тогда
		ТипПошлины = ПредопределенноеЗначение("Перечисление.ТипыПошлинВС.ВТО");
	ИначеЕсли ТипПошлиныИСЭСФ =  "EAEU" Тогда
		ТипПошлины = ПредопределенноеЗначение("Перечисление.ТипыПошлинВС.ЕАЭС");
	ИначеЕсли ТипПошлиныИСЭСФ = "CCT" Тогда
		ТипПошлины = ПредопределенноеЗначение("Перечисление.ТипыПошлинВС.ЕТТ");
	Иначе
		ТипПошлины = ПредопределенноеЗначение("Перечисление.ТипыПошлинВС.НеУстановлено");
	КонецЕсли;
	
	Возврат ТипПошлины;		
		
КонецФункции

Функция СтатусСклада_ИБ(Знач СтатусСкладаИСЭСФ) Экспорт
	
	ВРегСтатусИСЭСФ = ВРег(СтатусСкладаИСЭСФ);
	
	Если ВРегСтатусИСЭСФ = "VALID" Тогда
		СтатусСкладаИБ = ПредопределенноеЗначение("Перечисление.СтатусыВиртуальныхСкладов.Активен");
	ИначеЕсли ВРегСтатусИСЭСФ = "INVALID" Тогда
		СтатусСкладаИБ = ПредопределенноеЗначение("Перечисление.СтатусыВиртуальныхСкладов.Неактивен");
	Иначе
		СтатусСкладаИБ = ПредопределенноеЗначение("Перечисление.СтатусыВиртуальныхСкладов.ПустаяСсылка");
	КонецЕсли;
	
	Возврат СтатусСкладаИБ;
	
КонецФункции

Функция ТипСклада_ИБ(Знач ТипСкладаИСЭСФ) Экспорт
	
	ВРегТипСкладИСЭСФ = ВРег(ТипСкладаИСЭСФ);
	
	Если ВРегТипСкладИСЭСФ = "POINT_OF_SALE" Тогда
		ТипСкладаИБ = ПредопределенноеЗначение("Перечисление.ТипыВиртуальныхСкладов.ТочкаПродаж");
	ИначеЕсли ВРегТипСкладИСЭСФ = "STORE_HOUSE" Тогда
		ТипСкладаИБ = ПредопределенноеЗначение("Перечисление.ТипыВиртуальныхСкладов.Склад");
	ИначеЕсли ВРегТипСкладИСЭСФ = "MOBILE_STORE" Тогда
		ТипСкладаИБ = ПредопределенноеЗначение("Перечисление.ТипыВиртуальныхСкладов.МобильныйСклад");
	Иначе
		ТипСкладаИБ = ПредопределенноеЗначение("Перечисление.ТипыВиртуальныхСкладов.ПустаяСсылка");
	КонецЕсли;
	
	Возврат ТипСкладаИБ;
	
КонецФункции

Функция МаксимальноеКоличествоСтрокДокументаЭДВС() Экспорт
	
	Возврат 200;
	
КонецФункции

#КонецОбласти 

#Область СлужебныеПроцедурыИФункции 

Функция НаправлениеДвиженияТоваров(Знач НаправлениеИБ) Экспорт
	
	Если НаправлениеИБ = ПредопределенноеЗначение("Перечисление.НаправленияЭСФ.Входящий") Тогда
		Направление =  "INCOME";
		
	ИначеЕсли НаправлениеИБ = ПредопределенноеЗначение("Перечисление.НаправленияЭСФ.Исходящий") Тогда
		Направление = "OUTCOME";
		
	Иначе
		Направление = "";
		
	КонецЕсли;
	
	Возврат Направление;
	
КонецФункции

Функция ДействиеОтмена() Экспорт	
	Возврат "Отмена";	
КонецФункции

Функция ИмяСобытияЗаписьЭДВС() Экспорт 
	Возврат "Запись_ЭлектронныйДокументВС";	
КонецФункции

Функция ИмяСобытияСинхронизацияЭДВС() Экспорт 
	Возврат "Синхронизация_ЭДВС";	
КонецФункции

Функция ИмяСобытияСинхронизацияГСВС() Экспорт 
	Возврат "Синхронизация_ГСВС";	
КонецФункции

Функция ПустыеПараметрыФормыИзменениеСтатусовЭДВС() Экспорт
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Действие", "");
	ПараметрыФормы.Вставить("МассивЭД", Новый Массив);
	ПараметрыФормы.Вставить("ЗапускатьФоновоеЗадание", Ложь);
	
	Возврат ПараметрыФормы;
	
КонецФункции 

Функция ПолучитьПредставлениеПериода(НачалоПериода = '00010101', КонецПериода = '00010101', ТолькоДаты  = Ложь) Экспорт
	
	ТекстПериод = "";
	
	Если ЗначениеЗаполнено(КонецПериода) Тогда 
		Если КонецПериода >= НачалоПериода Тогда
			ТекстПериод = ?(ТолькоДаты, "", " за ") + ПредставлениеПериода(НачалоДня(НачалоПериода), КонецДня(КонецПериода), "ФП = Истина");
		Иначе
			ТекстПериод = "";
		КонецЕсли;
	ИначеЕсли ЗначениеЗаполнено(НачалоПериода) И Не ЗначениеЗаполнено(КонецПериода) Тогда
		ТекстПериод = ?(ТолькоДаты, "", " за ") + ПредставлениеПериода(НачалоДня(НачалоПериода), КонецДня(Дата(3999, 11, 11)), "ФП = Истина");
		ТекстПериод = СтрЗаменить(ТекстПериод, Сред(ТекстПериод, Найти(ТекстПериод, " - ")), " - ...");
	КонецЕсли;
	
	Возврат ТекстПериод;
	
КонецФункции

Функция ОпределитьТипПроисхожденияПоПризнакуПроисхождения(ПризнакПроисхождения, ТипФормы = Неопределено, Строка = Неопределено) Экспорт
	
	Если ПризнакПроисхождения = "1" Или ПризнакПроисхождения = "2" 
		//Если признак происхождения не заполнен и это детализация импорта
		ИЛИ (ТипФормы = ПредопределенноеЗначение("Перечисление.ТипыФормВС.ДетализацияИмпорта")
		И Строка <> Неопределено 
		И ( НЕ ПустаяСтрока(Строка.ТоварНаименованиеВРамкахТС)
			ИЛИ НЕ ПустаяСтрока(Строка.НомерПозицииВДекларацииИлиЗаявлении)
			ИЛИ НЕ ПустаяСтрока(Строка.НомерЗаявленияВРамкахТС))) Тогда
			
		ТипПроисхождения = ПредопределенноеЗначение("Перечисление.ТипПроисхожденияТоваровВС.Импорт");
	ИначеЕсли ПризнакПроисхождения = "3" Или ПризнакПроисхождения = "4" 
		ИЛИ ТипФормы = ПредопределенноеЗначение("Перечисление.ТипыФормВС.Производство") Тогда
		ТипПроисхождения = ПредопределенноеЗначение("Перечисление.ТипПроисхожденияТоваровВС.Производство");
	Иначе
		ТипПроисхождения = ПредопределенноеЗначение("Перечисление.ТипПроисхожденияТоваровВС.ПроисхождениеНеопределено");
	КонецЕсли;
	
	Возврат ТипПроисхождения;
		
КонецФункции

Функция ОпределитьТипПошлины(НомерЗаявленияВРамкахТС) Экспорт
	
	ФасетФНО328 = "[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][N][0-9][0-9][0-9][0-9][0-9]";
	
	ФасетГТД = "[0-9][0-9][0-9][0-9][0-9][/][0-9][0-9][0-9][0-9][0-9][0-9][/][0-9][0-9][0-9][0-9][0-9][0-9][0-9]";
	
	//Фасет документа СНТ KZ-SNT-0001-790730400068-20210924-55584157
	ФасетСНТ = "KZ[-]SNT[-][0-9][0-9][0-9][0-9][-][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][-][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][-][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]";
	
	ТипПошлины = ПредопределенноеЗначение("Перечисление.ТипыПошлинВС.НеУстановлено");
	
	Если ВСВызовСервера.СтрокаСоответствуетФасету(НомерЗаявленияВРамкахТС, ФасетФНО328)
		ИЛИ ВСВызовСервера.СтрокаСоответствуетФасету(НомерЗаявленияВРамкахТС, ФасетСНТ) Тогда
		ТипПошлины = ПредопределенноеЗначение("Перечисление.ТипыПошлинВС.ЕАЭС");
	ИначеЕсли ВСВызовСервера.СтрокаСоответствуетФасету(НомерЗаявленияВРамкахТС, ФасетГТД) Тогда
		ПервыйСимволВПоследнемФасете = Сред(НомерЗаявленияВРамкахТС, 14, 1);
		
		Если ПервыйСимволВПоследнемФасете = "1" Тогда
			ТипПошлины = ПредопределенноеЗначение("Перечисление.ТипыПошлинВС.ВТО");
		Иначе
			ТипПошлины = ПредопределенноеЗначение("Перечисление.ТипыПошлинВС.ЕТТ");
		КонецЕсли;
	Иначе
		ТипПошлины = ПредопределенноеЗначение("Перечисление.ТипыПошлинВС.НеУстановлено");
	КонецЕсли;
	
	Возврат ТипПошлины;
			
КонецФункции

Функция ОпределитьСтрануПоПризнакуПроисхождения(ПризнакПроисхождения)  Экспорт
	Если ПризнакПроисхождения = "3" ИЛИ ПризнакПроисхождения = "4" Тогда
		Возврат ВСВызовСервера.ПолучитьПредопределеннуюСтрануКазахстан();	
	КонецЕсли
КонецФункции

Функция ОпределитьПризнакПроисхожденияТовара(ТипПроисхождения, ПризнакПеречняИзьятий) Экспорт
	
	Если ТипПроисхождения = ПредопределенноеЗначение("Перечисление.ТипПроисхожденияТоваровВС.Импорт") Тогда
		Если ПризнакПеречняИзьятий = ИСТИНА Тогда
			ПризнакПроисхождения = "1";
		Иначе
			ПризнакПроисхождения = "2";
		КонецЕсли;
	ИначеЕсли ТипПроисхождения = ПредопределенноеЗначение("Перечисление.ТипПроисхожденияТоваровВС.Производство") Тогда
		Если ПризнакПеречняИзьятий = ИСТИНА Тогда
			ПризнакПроисхождения = "3";
		Иначе
			ПризнакПроисхождения = "4";
		КонецЕсли;
	Иначе
		ПризнакПроисхождения = "5";
	КонецЕсли;	
			
	Возврат ПризнакПроисхождения;
		
КонецФункции

Функция ОпределитьТипПроисхождения(НомерЗаявленияВРамкахТС) Экспорт
	
	СтруктураДанных = Новый Структура;
	
	СтруктураДанных.Вставить("ТипПошлины", ПредопределенноеЗначение("Перечисление.ТипыПошлинВС.НеУстановлено"));
	СтруктураДанных.Вставить("ТипПроисхождения", ПредопределенноеЗначение("Перечисление.ТипПроисхожденияТоваровВС.ПроисхождениеНеопределено"));

	ФасетФНО328 = "[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][N][0-9][0-9][0-9][0-9][0-9]";
	
	ФасетГТД = "[0-9][0-9][0-9][0-9][0-9][/][0-9][0-9][0-9][0-9][0-9][0-9][/][0-9][0-9][0-9][0-9][0-9][0-9][0-9]";
	
	//Фасет документа СНТ KZ-SNT-0001-790730400068-20210924-55584157
	ФасетСНТ = "KZ[-]SNT[-][0-9][0-9][0-9][0-9][-][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][-][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][-][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]";
	
	//фасет сертификата когда указано 11 символов
	ФасетСертификата11 = "KZ[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]";
	
	//фасет сертификата когда указано 13 символов
	ФасетСертификата13 = "KZ[A-Z][A-Z][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]";

	Если ВСВызовСервера.СтрокаСоответствуетФасету(НомерЗаявленияВРамкахТС, ФасетФНО328)
		ИЛИ ВСВызовСервера.СтрокаСоответствуетФасету(НомерЗаявленияВРамкахТС, ФасетСНТ) Тогда
		
		СтруктураДанных.Вставить("ТипПошлины", ПредопределенноеЗначение("Перечисление.ТипыПошлинВС.ЕАЭС"));
		СтруктураДанных.Вставить("ТипПроисхождения", ПредопределенноеЗначение("Перечисление.ТипПроисхожденияТоваровВС.Импорт"));
		
	ИначеЕсли ВСВызовСервера.СтрокаСоответствуетФасету(НомерЗаявленияВРамкахТС, ФасетГТД) Тогда
		
		ПервыйСимволВПоследнемФасете = Сред(НомерЗаявленияВРамкахТС, 14, 1);
		
		Если ПервыйСимволВПоследнемФасете = "1" Тогда
			СтруктураДанных.Вставить("ТипПошлины", ПредопределенноеЗначение("Перечисление.ТипыПошлинВС.ВТО"));
		Иначе
			СтруктураДанных.Вставить("ТипПошлины", ПредопределенноеЗначение("Перечисление.ТипыПошлинВС.ЕТТ"));
		КонецЕсли;
		
		СтруктураДанных.Вставить("ТипПроисхождения", ПредопределенноеЗначение("Перечисление.ТипПроисхожденияТоваровВС.Импорт"));
			
	ИначеЕсли ВСВызовСервера.СтрокаСоответствуетФасету(НомерЗаявленияВРамкахТС, ФасетСертификата11) ИЛИ ВСВызовСервера.СтрокаСоответствуетФасету(НомерЗаявленияВРамкахТС, ФасетСертификата13) Тогда
		
		СтруктураДанных.Вставить("ТипПошлины", ПредопределенноеЗначение("Перечисление.ТипыПошлинВС.НеУстановлено"));
		СтруктураДанных.Вставить("ТипПроисхождения", ПредопределенноеЗначение("Перечисление.ТипПроисхожденияТоваровВС.Производство"));

	КонецЕсли;
	
	Возврат СтруктураДанных;
			
КонецФункции


//Выделяет дату из регистрационного номера импортного документа
//По номеру ГТД данная функция может выделять только дату по документам с 2000 года. 
//
//Параметры:
//  РегистрационныйНомер, Строка - рег.номер импортного документа - ГТД или Заявления о ввозе товаров
//
Функция ПолучитьДатуИзРегНомера(РегистрационныйНомер ) Экспорт
	
	ДатаИмпорта = Дата(1,1,1);
	
	ДлинаНомера = СтрДлина(РегистрационныйНомер);
	
	//пример корректного номер ДТ 51419/170418/0980955
	//предполагаем что это ДТ
	Если ДлинаНомера = 20 Тогда
		ДатаСтрокой = Сред(РегистрационныйНомер, 7, 6);
		Год = "20" + Сред(ДатаСтрокой, 5, 2);
		Месяц = Сред(ДатаСтрокой, 3, 2);
		День =  Сред(ДатаСтрокой, 0, 2);
		
		Попытка
			ДатаИмпорта = Дата(Год + Месяц + День);
		Исключение
		КонецПопытки;	
		
		//предполагаем что это ФНО 328	
		//пример корректного номер ДТ 620210052018N99103
	ИначеЕсли ДлинаНомера = 18 Тогда
		ДатаСтрокой = Сред(РегистрационныйНомер, 5, 8);
		Год = Сред(ДатаСтрокой, 5, 4);
		Месяц = Сред(ДатаСтрокой, 3, 2);
		День =  Сред(ДатаСтрокой, 0, 2);
		
		Попытка
			ДатаИмпорта = Дата(Год + Месяц + День);
		Исключение
		КонецПопытки;	
		
	КонецЕсли;
		
	Возврат ДатаИмпорта;	
	
КонецФункции

Функция ИмяСобытияЗаписьВС() Экспорт 
	Возврат "Запись_ВиртуальныйСклад";	
КонецФункции

#КонецОбласти

#Область ИдентификаторыТРУ

Функция СтруктураИдентификатораТовара(ИдентификаторТовара) Экспорт
	
	//пример полного идентификатора сожердащего все коды
	// физическая метка может отсутствовать
	//05.10.10.01-2701190000/8602026474128[JF1SJ9LC5JG385200]<3620>(957)
	//
	СтруктураИдентификатора = Новый Структура("КодКПВЭД, КодГСВСПолный, КодТНВЭД, МеткаТовара, КодGTIN", "","","","","");
	
	СтруктураИдентификатора.КодКПВЭД = ОпределитьКПВЭДПоИдентификатору(ИдентификаторТовара);
	СтруктураИдентификатора.КодТНВЭД = ОпределитьТНВЭДПоИдентификатору(ИдентификаторТовара);
	СтруктураИдентификатора.КодGTIN  = ОпределитьGTINПоИдентификатору(ИдентификаторТовара);
	
	Если ЗначениеЗаполнено(СтруктураИдентификатора.КодКПВЭД) Тогда
		
		Если ЗначениеЗаполнено(СтруктураИдентификатора.КодТНВЭД) Тогда
			КодГСВС = СтруктураИдентификатора.КодКПВЭД + "-" + СтруктураИдентификатора.КодТНВЭД;
			Если ЗначениеЗаполнено(СтруктураИдентификатора.КодGTIN) Тогда
				КодГСВС = КодГСВС + "/" + СтруктураИдентификатора.КодGTIN;
			КонецЕсли;
		Иначе			
			КодГСВС = СтруктураИдентификатора.КодКПВЭД;
		КонецЕсли;
		
		СтруктураИдентификатора.КодГСВСПолный = КодГСВС;
		
	КонецЕсли;	
	
	СтруктураИдентификатора.МеткаТовара = ОпределитьМеткуПоИдентификатору(ИдентификаторТовара);		
	
	Возврат СтруктураИдентификатора;
	
КонецФункции	

Функция ОпределитьКПВЭДПоИдентификатору(ИдентификаторТовара) Экспорт
	
	КПВЭД = "";
	Если СтрДлина(ИдентификаторТовара) >= 11 Тогда
		
		КПВЭД = Сред(ИдентификаторТовара, 1, 11);
		
		Если Сред(КПВЭД, 3,1) = "." И Сред(КПВЭД, 6,1) = "." И Сред(КПВЭД, 9,1) = "." Тогда
			
			Попытка
				ПерваяЧасть = Число(Сред(КПВЭД, 1,2));
				ВтораяЧасть = Число(Сред(КПВЭД, 4,2));
				ТретьяЧасть = Число(Сред(КПВЭД, 7,2));
				ЧетвертаяЧасть = Число(Сред(КПВЭД, 10,2));
			Исключение
				ПерваяЧасть = Неопределено;
				ВтораяЧасть = Неопределено;
				ТретьяЧасть = Неопределено;
				ЧетвертаяЧасть = Неопределено;
			КонецПопытки;
		КонецЕсли;
		
		Если ПерваяЧасть = Неопределено Или ВтораяЧасть = Неопределено Или ТретьяЧасть = Неопределено Или ЧетвертаяЧасть = Неопределено Тогда
			КПВЭД = "";
		КонецЕсли;
	КонецЕсли;
	
	Возврат КПВЭД;
	
КонецФункции

Функция ОпределитьТНВЭДПоИдентификатору(ИдентификаторТовара) Экспорт
	
	ТНВЭД = "";
	Если СтрДлина(ИдентификаторТовара) >= 22 Тогда
		
		ТНВЭД = Сред(ИдентификаторТовара, 13, 10);
		
		Попытка
			ТНВЭДЧисло = Число(ТНВЭД);
		Исключение
			ТНВЭДЧисло = 0;
		КонецПопытки;
		
		Если ТНВЭДЧисло = 0 Тогда
			ТНВЭД = "";
		КонецЕсли;	
		
	КонецЕсли;
	
	Возврат ТНВЭД;
	
КонецФункции

Функция ОпределитьМеткуПоИдентификатору(ИдентификаторТовара) Экспорт
	
	Метка = "";
	
	ПерваяПозиция = СтрНайти(ИдентификаторТовара, "[");
	ВтораяПозиция = СтрНайти(ИдентификаторТовара, "]");
	
	Если ПерваяПозиция <> 0 И ВтораяПозиция <> 0 Тогда
		ЧислоСимволов = ВтораяПозиция - (ПерваяПозиция + 1); 
		
		Метка = Сред(ИдентификаторТовара, ПерваяПозиция+1, ЧислоСимволов);
	КонецЕсли;	
	
	Возврат Метка;
	
КонецФункции

#КонецОбласти 

#Область Цвета

Функция ЦветСостоянияЭДВС(Знач Состояние) Экспорт
	
	Если Состояние = ПредопределенноеЗначение("Перечисление.СостоянияЭДВС.Сформирован")
		ИЛИ Состояние = ПредопределенноеЗначение("Перечисление.СостоянияЭДВС.ОбрабатываетсяСервером") Тогда
		
		Цвет = ЭСФКлиентСервер.ЦветСиний();
		
	ИначеЕсли Состояние = ПредопределенноеЗначение("Перечисление.СостоянияЭДВС.ОбработанНаСервере")
		ИЛИ Состояние = ПредопределенноеЗначение("Перечисление.СостоянияЭДВС.НеПодлежитОтправке") Тогда
		
		Цвет = ЭСФКлиентСервер.ЦветЗеленый();
		
	ИначеЕсли Состояние = ПредопределенноеЗначение("Перечисление.СостоянияЭДВС.ОтклоненСервером")
	      ИЛИ Состояние = ПредопределенноеЗначение("Перечисление.СостоянияЭДВС.Отменен") Тогда
		  
		Цвет = ЭСФКлиентСервер.ЦветКрасный();
		
	Иначе
		
		Цвет = ЭСФКлиентСервер.ЦветСиний();
		
	КонецЕсли;
	
	Возврат Цвет;
	
КонецФункции

Функция ЦветСтатусВС(Знач Статус) Экспорт
	
	Если Статус = ПредопределенноеЗначение("Перечисление.СтатусыВиртуальныхСкладов.Активен") Тогда		
		Цвет = ЭСФКлиентСервер.ЦветЗеленый();		
	ИначеЕсли Статус = ПредопределенноеЗначение("Перечисление.СтатусыВиртуальныхСкладов.Неактивен") Тогда
		Цвет = ЭСФКлиентСервер.ЦветКрасный();	
	ИначеЕсли Статус = ПредопределенноеЗначение("Перечисление.СтатусыВиртуальныхСкладов.НеСозданВС") Тогда
		Цвет = ЭСФКлиентСервер.ЦветСерый();
	Иначе	
		Цвет = ЭСФКлиентСервер.ЦветСиний();	
	КонецЕсли;
	
	Возврат Цвет;
	
КонецФункции
	
#КонецОбласти 

#Область СостояниеЭДВС

Функция СостояниеЭДВС(Статус, ЕстьТоварыСПустымИдентификатором, ТипФормы = Неопределено) Экспорт
	
	Если ТипФормы = ПредопределенноеЗначение("Перечисление.ТипыФормВС.ДекларацияНаТовары") //ИЛИ ТипФормы = ПредопределенноеЗначение("Перечисление.ТипыФормВС.ДетализацияИмпорта")) 
		И ЕстьТоварыСПустымИдентификатором Тогда
		
		Состояние = ПредопределенноеЗначение("Перечисление.СостоянияЭДВС.ОжидаетИдентификацииТоваровНаВС");
	
	ИначеЕсли ТипФормы = ПредопределенноеЗначение("Перечисление.ТипыФормВС.КорректировкаДанных") Тогда
		
		Состояние = ПредопределенноеЗначение("Перечисление.СостоянияЭДВС.НеПодлежитОтправке");	
	
	ИначеЕсли Статус = ПредопределенноеЗначение("Перечисление.СтатусыУТТН.ПустаяСсылка")
		ИЛИ Статус = ПредопределенноеЗначение("Перечисление.СтатусыУТТН.Черновик")
		ИЛИ Статус = ПредопределенноеЗначение("Перечисление.СтатусыУТТН.Созданный") Тогда
		
		Состояние = ПредопределенноеЗначение("Перечисление.СостоянияЭДВС.Сформирован");
		
	ИначеЕсли Статус = ПредопределенноеЗначение("Перечисление.СтатусыУТТН.Ошибочный") Тогда
		
		Состояние = ПредопределенноеЗначение("Перечисление.СостоянияЭДВС.ОтклоненСервером");
		
	ИначеЕсли Статус = ПредопределенноеЗначение("Перечисление.СтатусыУТТН.Отмененный") Тогда
		
		Состояние = ПредопределенноеЗначение("Перечисление.СостоянияЭДВС.Отменен");
		
	ИначеЕсли Статус = ПредопределенноеЗначение("Перечисление.СтатусыУТТН.Обрабатывается") Тогда
		
		Состояние = ПредопределенноеЗначение("Перечисление.СостоянияЭДВС.ОбрабатываетсяСервером");
		
	ИначеЕсли Статус = ПредопределенноеЗначение("Перечисление.СтатусыУТТН.Обработанный") Тогда
		
		Если ЕстьТоварыСПустымИдентификатором Тогда
			Состояние = ПредопределенноеЗначение("Перечисление.СостоянияЭДВС.ОжидаетИдентификацииТоваровНаВС");
		Иначе
			Состояние = ПредопределенноеЗначение("Перечисление.СостоянияЭДВС.ОбработанНаСервере");
		КонецЕсли;
		
	Иначе
		
		Состояние = ПредопределенноеЗначение("Перечисление.СостоянияЭДВС.ПустаяСсылка");
		
	КонецЕсли;
	
	Возврат Состояние;
	
КонецФункции

Функция ПолучитьСостояниеЭДВС(ЭДВС) Экспорт
	
	//ПодлежитОтправке = (ЭДВС.ТоварыВС.Количество() > 0 ИЛИ ЭДВС.ИсходныеТоварыВС.Количество() > 0);
	
	ПодлежитОтправке = (ЭДВС.ТоварыВС.Количество() > 0 ИЛИ ЭДВС.ИсходныеТоварыВС.Количество() > 0 ИЛИ ЭДВС.ТипФормы = ПредопределенноеЗначение("Перечисление.ТипыФормВС.КорректировкаДанных"));
	
	
	Если ЭДВС.ТипФормы = ПредопределенноеЗначение("Перечисление.ТипыФормВС.ДекларацияНаТовары") // Или ЭДВС.ТипФормы = ПредопределенноеЗначение("Перечисление.ТипыФормВС.ДетализацияИмпорта") 
		Тогда
		ЕстьТоварыСПустымИдентификатором = ВСВызовСервера.ПроверитьЭДВСНаНаличиеИдентификаторовТоваровВС(ЭДВС);
	ИначеЕсли ЭДВС.Статус = ПредопределенноеЗначение("Перечисление.СтатусыУТТН.Обработанный") Тогда
		ЕстьТоварыСПустымИдентификатором = ВСВызовСервера.ПроверитьЭДВСНаНаличиеИдентификаторовТоваровВС(ЭДВС);
	КонецЕсли;
	
	Если Не ПодлежитОтправке Тогда 
		Состояние = ПредопределенноеЗначение("Перечисление.СостоянияЭДВС.НеПодлежитОтправке");
	Иначе
		Состояние = ВСКлиентСервер.СостояниеЭДВС(ЭДВС.Статус, ЕстьТоварыСПустымИдентификатором, ЭДВС.ТипФормы);;
	КонецЕсли;
	
	Возврат Состояние;
	
КонецФункции

Функция ОпределитьGTINПоИдентификатору(ИдентификаторТовара) Экспорт
	//GTIN - Global Trade Item Number - Глобальный Номер Товарной Позиции
	ГНТП = "";
	Если СтрДлина(ИдентификаторТовара) >= 36 Тогда
		НачалоГНТП = СтрНайти(ИдентификаторТовара, "/");
		Если НачалоГНТП > 0 Тогда
			НачалоФизМетки = СтрНайти(ИдентификаторТовара, "[",, НачалоГНТП);
			НачалоИДТовара = СтрНайти(ИдентификаторТовара, "<",,НачалоГНТП);
			НачалоИДСклада = СтрНайти(ИдентификаторТовара, "(",,НачалоГНТП);
			
			
			Если НачалоФизМетки = 0 Тогда
				НачалоФизМетки = 10000;
			КонецЕсли;
			Если НачалоИДТовара = 0 Тогда
				НачалоИДТовара = 10000;
			КонецЕсли;
			Если НачалоИДСклада = 0 Тогда
				НачалоИДСклада = 10000;
			КонецЕсли;
			
			КонецГНТП = Мин(НачалоФизМетки, НачалоИДТовара, НачалоИДСклада);
			
			ГНТП = Сред(ИдентификаторТовара, НачалоГНТП+1, КонецГНТП - НачалоГНТП-1);
			
			Попытка
				ГНТПЧисло = Число(ГНТП);
			Исключение
				ГНТПЧисло = 0;
			КонецПопытки;
			
			Если ГНТПЧисло = 0 Тогда
				ГНТП = "";
			КонецЕсли;	
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат ГНТП;
	
КонецФункции

#КонецОбласти 