﻿
// (См. РегистрыСведений.ПулКодовМаркировкиСУЗИСМПТК.ПечатьЭтикетокСРезервированиемПоДокументу)
// 
// Параметры:
// 	ДанныеПечати - Структура - Данные для печати
// Возвращаемое значение:
// 	Структура, Неопределено - Описание:
// * РезультатРезервирования - Массив - Результат резервированных кодов маркировки
// * ТабличныйДокумент - ТабличныйДокумент - Напечатанные коды маркировки
Функция ПечатьЭтикетокСРезервированиемПоДокументу(ДанныеПечати) Экспорт
	
	Возврат РегистрыСведений.ПулКодовМаркировкиСУЗИСМПТК.ПечатьЭтикетокСРезервированиемПоДокументу(ДанныеПечати);
	
КонецФункции

// Функция выполняет формирование изображения штрихкода.
// Параметры: 
//   ПараметрыШтрихкода 
// Возвращаемое значение: 
//   Картинка - Картинка со сформированным штрихкодом или НЕОПРЕДЕЛЕНО.
Функция ПолучитьКартинкуШтрихкода(ПараметрыШтрихкода) Экспорт
	
	ВнешняяКомпонента = ИнтеграцияИСМПТКПереопределяемый.ПодключитьВнешнююКомпонентуПечатиШтрихкода();
	
	Если ВнешняяКомпонента = Неопределено Тогда
		ВызватьИсключение НСтр("ru = 'Ошибка подключения внешней компоненты печати штрихкода.'");                      
	КонецЕсли;
	
	// Зададим размер формируемой картинки.
	ВнешняяКомпонента.Ширина = Окр(ПараметрыШтрихкода.Ширина);
	ВнешняяКомпонента.Высота = Окр(ПараметрыШтрихкода.Высота);
	
	ВнешняяКомпонента.АвтоТип = Ложь;
	
	Если ПараметрыШтрихкода.ТипКода = 99 Тогда
		ТипШтрихкодаВрем = МенеджерОборудованияВызовСервера.ОпределитьТипШтрихкода(ПараметрыШтрихкода.Штрихкод);
		Если ТипШтрихкодаВрем = "EAN128" Тогда
			ВнешняяКомпонента.ТипКода = 2;
		ИначеЕсли ТипШтрихкодаВрем = "CODE128" Тогда
			ВнешняяКомпонента.ТипКода = 4;
		Иначе
			ВнешняяКомпонента.АвтоТип = Истина;
		КонецЕсли;
	Иначе
		ВнешняяКомпонента.АвтоТип = Ложь;
		ВнешняяКомпонента.ТипКода = ПараметрыШтрихкода.ТипКода;
	КонецЕсли;
	
	Если ПараметрыШтрихкода.Свойство("ПрозрачныйФон") Тогда
		ВнешняяКомпонента.ПрозрачныйФон = ПараметрыШтрихкода.ПрозрачныйФон;
	КонецЕсли;
	
	ВнешняяКомпонента.ОтображатьТекст = ПараметрыШтрихкода.ОтображатьТекст;
	
	// Формируем картинку штрихкода.
	ВнешняяКомпонента.ЗначениеКода = ПараметрыШтрихкода.Штрихкод; //РазборИОбработкаКодовМаркировкиИСМПТКСлужебный.СтрокуВBase64(ПараметрыШтрихкода.Штрихкод);
	//ВнешняяКомпонента.ТипВходныхДанных = 1;
	
	// Угол поворота штрихкода.
	ВнешняяКомпонента.УголПоворота = ?(ПараметрыШтрихкода.Свойство("УголПоворота"), ПараметрыШтрихкода.УголПоворота, 0);
	// Уровень коррекции QR кода (L=0, M=1, Q=2, H=3).
	ВнешняяКомпонента.УровеньКоррекцииQR = ?(ПараметрыШтрихкода.Свойство("УровеньКоррекцииQR"), ПараметрыШтрихкода.УровеньКоррекцииQR, 1);
	
	// Если установленная нами ширина меньше минимально допустимой для этого штрихкода.
	Если ВнешняяКомпонента.Ширина < ВнешняяКомпонента.МинимальнаяШиринаКода Тогда
		ВнешняяКомпонента.Ширина = ВнешняяКомпонента.МинимальнаяШиринаКода;
	КонецЕсли;
	
	// Если установленная нами высота меньше минимально допустимой для этого штрихкода.
	Если ВнешняяКомпонента.Высота < ВнешняяКомпонента.МинимальнаяВысотаКода Тогда
		ВнешняяКомпонента.Высота = ВнешняяКомпонента.МинимальнаяВысотаКода;
	КонецЕсли;

	Если ПараметрыШтрихкода.Свойство("РазмерШрифта") И (ПараметрыШтрихкода.РазмерШрифта > 0) 
		И (ПараметрыШтрихкода.ОтображатьТекст) И (ВнешняяКомпонента.РазмерШрифта <> ПараметрыШтрихкода.РазмерШрифта) Тогда
		ВнешняяКомпонента.РазмерШрифта = ПараметрыШтрихкода.РазмерШрифта;
	КонецЕсли;
	
	// Сформируем картинку
	ДвоичныеДанныеКартинки = ВнешняяКомпонента.ПолучитьШтрихкод();
	
	// Если картинка сформировалась.
	Если ДвоичныеДанныеКартинки <> Неопределено Тогда
		// Формируем из двоичных данных.
		Возврат Новый Картинка(ДвоичныеДанныеКартинки);
	КонецЕсли;
	
	Возврат Неопределено;

КонецФункции

Функция ПроверитьПризнакGS1УШаблона(ШаблонПечати) Экспорт
	
	Возврат ШаблонПечати.НеGS1;
	
КонецФункции

#Область ПечатьSSCC

Функция ПолучитьШаблонЭтикеткиSSCC() Экспорт
	
	Возврат ПечатьКодовМаркировкиИСМПТК.ПолучитьШаблонЭтикеткиSSCC();
	
КонецФункции

#КонецОбласти