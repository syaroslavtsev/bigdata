# какие столбцы
#   publish:  ItemID ProductID price_real shipping_real
#   sold: ItemID

# параметры которые нужно передавать
#   1. путь у config
#   2. дата начала
#	  3. дата конца
#   4. категирия товаров
#   5. бренд товаров

probPrice <- function(sql)
{

# создаем запрос для publish
queryPublish =paste("select publish.ItemID, publish.ProductID, publish.price_real, publish.shipping_real ",
                    "from ", myDbname, ".publish", ", ", myDbname, ".products ",
                    "where publish.ProductID=products.ProductID", sql, ";", sep = "");

# запрос для sold
querySold = paste("select sold.ItemID ",
                  "from ", myDbname, ".sold ",
                  "where sold.ItemID in (select publish.ItemID from ",myDbname, ".publish, ", myDbname, ".products where publish.ProductID = products.ProductID", sql, ");", sep = "");

# считываем таблицу
data.publish <- readTable(queryPublish);
data.sold <- readTable(querySold);

if(!checkTable(data.publish) || !checkTable(data.sold))
{
  return(NULL);
}#  если в таблице не достаточно элементов тогда пишем ERROR

# если достаточно элементов тогда рисуем гистограмму
if(checkTable(data.publish) & checkTable(data.sold))
{
  # функция обработки таблицы
  data.publish = change.publish(data.publish);
  data.sold = change.sold(data.sold);
  
  # созлаем точки на очи X гистограммы
  maxPrice = log10(max(data.publish$price_real+data.publish$shipping_real,na.rm = T))+0.2;
  myBreaks = seq(0, maxPrice, by = 0.1);
  
  
  plotProbPrice <- function(publish = data.publish,
                            sold = data.sold){
    
    soldPrice = merge(subset(sold, select = c(ItemID)), 
                      subset(publish, select = c(ItemID, price_real, shipping_real)),
                      by.x = "ItemID", 
                      by.y = "ItemID");
    
    sold_hist_count = hist(log10(soldPrice$price_real+soldPrice$shipping_real),
                           breaks = myBreaks,
                           plot = F)$counts;
    
    publish_hist_count = hist(log10(publish$price_real+publish$shipping_real),
                              breaks = myBreaks, 
                              plot = F)$counts;
    
    
    y = ifelse(publish_hist_count!=0,sold_hist_count/publish_hist_count,0);
    x = seq(0.05, maxPrice+0.1,0.1)[1:(length(myBreaks)-1)]
    
    id = seq(1,length(x),1)
    res = data.frame(id, x, y);
    return(res);

  }#  функция постороения гистограммы которая возвращает имя 
  
  return(plotProbPrice());  # вызов функции построения гистограммы
  
}
}