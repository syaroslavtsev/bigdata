﻿# BigData 
 - Загрузка стабильной версии API для работы с R скриптами в репозиторий
 - Загрузка стабильных R скриптов в репозиторий
 - Composer инициализирует поект и вытягивате зависимости 

    (проект готов к работе)

 - Обращение к скрипту 
 - Настройка пользователем параметров для обработки данных
 - Передача параметров R скрипту
 - Получение ответа от R скрипта
 - Вывод результата пользователю

# запуск сервера
- запускаем Rscript server.R передаем ему полный путь config.csv
    - Загрузка config
    - Подключение readData.R в котором считываються все параметры для доступа к базе данных и описаны функции для получения таблиц из базы.
    - Подключение скриптов которые будут возвращать данные для построения графиков
    - Подключение скриптов которые будут возвращать таблицы
    - Старт сервера
        - сервер принимает POST запрос с параметрами (scriptName, ...)
        - обработка запроса 
        - отправка ответа в Json формате

# структура папок
- bigData - rootdir
    - res - resourse(config, ...)
    - src - all scripts


# Документация к сервисным скриптам 
- server.R
	- Скрипт который запускает сервер по обработке запросов
	- Принимает через командную строку адрес config.csv

- readData.R
	- Скрипт в котором описаны функции получения и обработки данных из бызы

- decoder.R
	- Скрипт для парсинга RQL запроса
	- В начале определены константы которые отвечают за название логических и скалярных операторов 

# Документация к скриптам 
- plotPublishPrice.R
	- Имя отчета: гистограмма цены выставленных товаров
	- Принимает: бренд, номер категории, начальная дата, конечная дата 
	- Ось Х: логарифм по основанию 10 от цены товара
	- Ось У: количество выставленных товаров из данного ценового интервала
	- Возвращает: JSON вида {id,x*,y} *x-центры ценовых промежутков
	- начальная дата 2015-06-01

- plotSoldPrice.R
    - Имя отчета: гистограмма цены проданых товаров
    - Принимает: бренд, номер категории, начальная дата, конечная дата
    - Ось Х: логарифм по основанию 10 от цены товара
    - Ось У: количество проданных товаров из данного ценового интервала
    - Возвращает: JSON вида {id,x*,y} *x-центры ценовых промежутков
    - начальная дата 2015-06-01

- plotProbPrice.R
    - Имя отчета: график вероятности продажи товара из заданной ценовой категории
    - Принимает: бренд, номер категории, начальную дата, конечная дата
    - Ось Х: логарифм по основанию 10 от цены товара
    - Ось У: Оценка вероятности продажи товара из данной ценовой категории
    - Возвращает: JSON вида {id,x,y}
    - начальная дата 2015-06-01

- plotProfPrice.R
    - Имя отчета: график прибыли от одного выставления товара из заданой ценовой категории
    - Принимает: бренд, номер категории, начальная дата, конечная дата
    - Ось Х: логарифм по основанию 10 от цены товара
    - Ось У: Оценка прибыли от одного выставления товара из заданой ценовой категории
    - Возвращает: JSON вида {id,x,y}
    - начальная дата 2015-06-01

- plotPublishDay.R
    - Имя отчета: гистограмма количества выставлений по дням недели
    - Принимает: бренд, номер категории, начальная дата, конечная дата
    - Ось Х: день недели
    - Ось У: количество товаров которые были выставленый в данный день недели
    - Возвращает: JSON вида {id,x,y}
    - начальная дата 2015-06-01

- plotSoldDay.R
    - Имя отчета: гистограмма количества породаж в зависимости от дня выставления
    - Принимает: бренд, номер категории, начальная дата, конечная дата
    - Ось Х: день недели
    - Ось У: количество проданых товаров которые были выставлены в данный день недели
    - Возвращает: JSON вида {id,x,y}
    - начальная дата 2015-06-01

- plotProbDay.R
    - Имя отчета: график вероятности продажи товара выставленного в заданый день недели
    - Принимает: бренд, номер категории, начальная дата, конечная дата
    - Ось Х: день недели
    - Ось У: оценка вероятности продажи товара выставленного в заданный день недели
    - Возвращает: JSON вида {id,x,y}
    - начальная дата 2015-06-01

- plotCreatedDay.R
    - Имя отчета: гистограмма количества продаж в каждый день недели 
    - Принимает: бренд, номер категории, начальная дата, конечная дата
    - Ось Х: день недели
    - Ось У: количество товаров проданых в данный день
    - Возвращает: JSON вида {id,x,y}
    - начальная дата 2015-06-01

- plotPublishTime.R
    - Имя отчета: гистограмма количества выставлений в каждый часв течении дня
    - Принимает: бренд, номер категории, начальная дата, конечная дата
    - Ось Х: время суток(час)
    - Ось У: количество выставленых в заданый чвс товаров
    - Возвращает: JSON вида {id,x,y}
    - начальная дата 2015-06-01

- plotSoldTime.R
    - Имя отчета: гистограмма количества проданных товаров выставленых в заданое время
    - Принимает: бренд, номер категории, начальная дата, конечная дата
    - Ось Х: время суток(час)
    - Ось У: количество проданных товаров которые были выставлены в заданое время
    - Возвращает: JSON вида {id,x,y}
    - начальная дата 2015-06-01

- plotProbTime.R
    - Имя отчета: график вероятности продажи товара выставленного в заданое время суток
    - Принимает: бредн, намер категории, начальная дата, конечная дата
    - Ось Х: время суток(час)
    - Ось У: Оценка вероятности продажи товара выставленого заданое время суток
    - Возвращает: JSON вида {id,x,y}
    - начальная дата 2015-06-01

- plotCreatedTime.R
    - Имя отчета: гистограмма количетва продаж в каждый час дня
    - Принимает бренд, номер категории, начальная дата, конечна дата
    - Ось Х: время суток(час)
    - Ось У: количество продынных товаров в заданое время суток
    - Возвращает: JSON вида {id,x,y}
    - начальная дата 2015-06-01

- plotCreatedTimeWithTZ.R
    - Имя отчета: гистограмма количества продаж в каждый час дня с учетом часовых почсов
    - Принимает: бренд, номер категории, начальная дата, конечная дата
    - Ось Х: время суток в штате где выло куплено товар
    - Ось У: количество продынных товаров в заданое время суток с учетом часовых поясов
    - Возвращает: JSON вида {id,x,y}
    - начальная дата 2015-06-01

- tableCategoryPrice.R
    - Имя отчета: таблица частот по ценовым категориям товаров
    - Принимает: бренд, номер категории, начальная дата, конечная дата
    - Столбцы:  category_price(ценовая категория), count_sold(количество проданных), count_publish(количество выставленых), prob(оценка вероятности продажи), prof_mounth(оценка прибыли за месяц), new_prob(оценка вероятности продажи при выставлениия на 10 дней), new_prof_mounth(оценка прибыли за месяц при выставлении на 10 дней),delta_prof_mounth(разница в прибыли), id(id строки)
    - Возвращает: JSON таблицу с задаными елементами
    - начальная дата 2015-06-01

- tableCategoryID.R
    - Имя отчета: таблица частот по категориям товаров
    - Принимает: бренд, номер категории, начальная дата, конечная дата
    - Столбцы: ebaycategory_id(номер категории), count_sold(количество приданных), count_push(количество выставленных), mean_price(средняя цена по категории), prob(оценка вероятности продажи), prof_mounth(оценка прибыли за месяц), new_prob(оценка вероятности продажи при выставлении на 10 дней), new_prof_mounth(оценка прибыли за месяц при выставлении на 10 дней), delta_prof_mounth(разница в прибыли), id(id строки)
    - ВВозвращает: JSON таблицу с задаными елементами
    - начальная дата 2015-06-01

- tableProduct.R
    - Имя отчета: таблица частот по отдельным товарам
    - Принимает: бренд, номер категории, начальная дата, конечная дата
    - Столбцы: ProductID, count_sold(количество проданных), count_push(количество выставленных), price(цена товара), prob(оценка вероятности продажи), prof_mounth(оценка прибыли за месяц), new_prob(оценка вероятности продажи пир выставлении на 10 дней), new_prof_mounth(оценка прибыли за месяц при выставлении на 10 дней), delta_prof_mounth(разница прибыли), id(id строки)
    - Возвращает: JSON таблицу с задаными елементами
    - начальная дата 2015-06-01

- tableModel.R
    - Имя отчета: таблица популярности каждой из марок мотоциклов
    - Столбцы: vehicle_id(id марки мотоцикла), count_sold(количество проданных товаров которые подходят данной марке), count_publish(количество выставленных товаров которые подходят данной марке), id(id строки)
    - Возвращает: JSON таблицу с задаными елементами
    - начальная дата 2015-06-01

- tableProductModel.R
    - Имя отцета: таблица популярности деталей по маркам которым она подходит
    - Столбцы: ProductID, count_model_sold(количество проданых товаров которы подходят тем же маркам мотоциклов), count_model_publish(количество выставленных товаров которые подходят тем же маркам мотоцыклов), prob(оценка вероятности продажи товара который подходит тем же маркам мотоциклов), id(id строки)
    - Возвращает: JSON таблицу с задаными елементами
    - начальная дата 2015-06-01

- getBrand.R
    - Имя отчета: список брендов товаров которые есть у нас в наличии
    - Столбцы: id(id строки), name(название бренда), value(значение бренда совпадает с названием)
    - Возвращает: JSON таблицу с задаными елементами

- getCategory.R
    - Имя отчета: список категорий товаров которые есть у нас в наличии 
    - Столбцы: id(id строки), name(имя категоии), value(номер категории)
    - Возвращает: JSON таблицу с задаными елементами

- bestProducts.R
    - Имя отчета: список товаров которые продались больше всего на ebay
    - Столбцы: id(id строки), title(тайтл товара), count_sold(количество продаж данного товара начиная с 2016-01-22)
    - Возвращает JSON таблицу с задаными елементами
- bestCompetitor.R
    - Имя отчета: список продавцов и количество продаж этих продавцов
    - Столбцы: id(id строки), seller_name(ник продавца), count_sold(количество продаж данного продавца с 2016-01-22)
    - Возвращает: JSON таблицу с задаными елементами
- NN.R
    - Имя отчета: гистограмма цен выставленных товаров с задаными словами
    - Принимает: начальная дата(start_time>=), конечная дата(start_time<=), слова которые должны встречаться в title(title like), слова которые не должны встречаться в title(title not like)
    - Ось Х: логарифм по основанию 10 от цены товара
    - Ось у: количество продаж
    - Возвращает: JSON{id, x, y}

- NNSold.R
    - Имя отчета: гистограмма цен проданых товаров с задаными словами
    - Принимает: начальная дата(start_time>=), конечная дата(start_time<=), слова которые должны встречаться в title(title like), слова которые не должны встречаться в title(title not like)
    - Ось Х: логарифм по основанию 10 от цены товара
    - Ось у: количество продаж
    - Возвращает: JSON{id, x, y}