# какие столбцы
#   publish:  ItemID ProductID price_real shipping_real
#   sold: ItemID

# параметры которые нужно передавать
#   1. путь у config
#   2. процент наценки
#   3. дата начала
#	  4. дата конца
#   5. категирия товаров
#   6. бренд товаров

# считываес параметры с консоля
args <- commandArgs(trailingOnly = T);

# считываем путь у config
confFile = args[1];

# считываем config
config <- read.table(paste(confFile,"config.csv",sep = ""), sep = ",",header = T);

# считываем текущую директорию с config
myDir = as.character(config[1,6]);

# устанавливаем директорию
setwd(myDir);


{
  myProf =as.integer(args[2]);
  begDate = ifelse(args[2]!="NA", paste(" and publish.add_date > '", args[2],"'",sep=""),"");
  endDate = ifelse(args[3]!="NA", paste(" and publish.add_date < '", args[3],"'",sep=""),"");
  CategoryID = ifelse(args[4]!="NA", paste(" and products.ebaycategory_id = ", args[4], sep = ""), "");
  brand = ifelse(args[5]!="NA", paste( " and products.brand = ",args[5], sep = ""), "");
}# считываем остальные параметры с консоля

# запускаем скрипт с функциями считывания таблиц
source("readData.R");

# создаем запрос для publish
queryPublish =paste("select publish.ItemID, publish.ProductID, publish.price_real, publish.shipping_real ",
                    "from ", myDbname, ".publish", ", ", myDbname, ".products ",
                    "where publish.ProductID=products.ProductID", brand, CategoryID,begDate, endDate, ";", sep = "");

# запрос для sold
querySold = paste("select sold.ItemID ",
                  "from ", myDbname, ".sold ",
                  "where sold.ItemID in (select publish.ItemID from ",myDbname, ".publish, ", myDbname, ".products where publish.ProductID = products.ProductID", brand, CategoryID, 
                  begDate, endDate, ");", sep = "");

# считываем таблицу
data.publish <- readTable(queryPublish);
data.sold <- readTable(querySold);

if(!checkTable(data.publish) || !checkTable(data.sold))
{
  print("ERROR");
}#  если в таблице не достаточно элементов тогда пишем ERROR

# если достаточно элементов тогда рисуем гистограмму
if(checkTable(data.publish) & checkTable(data.sold))
{
  # функция обработки таблицы
  data.publish = change.publish();
  data.sold = change.sold();
  
  # созлаем точки на очи X гистограммы
  maxPrice = log10(max(data.publish$price_real+data.publish$shipping_real,na.rm = T))+0.2;
  myBreaks = seq(0, maxPrice, by = 0.1);
  
  
  plotProfPrice <- function(publish = data.publish,
                            sold = data.sold,
                            colHist = myCol,
                            waySave = myRoute,
                            prof = myProf,
                            size = mySize){
    
    soldPrice = merge(subset(sold, select = c(ItemID)), 
                      subset(publish, select = c(ItemID, price_real, shipping_real)),
                      by.x = "ItemID", 
                      by.y = "ItemID");
    
    sold_hist_count = hist(log10(data.sold_and_price$price_real+data.sold_and_price$shipping_real),
                           breaks = myBreaks,
                           plot = F)$counts;
    
    publish_hist_count = hist(log10(publish$price_real+publish$shipping_real),
                              breaks = myBreaks, 
                              plot = F)$counts;
    
    
    prob_count = sold_hist_count/publish_hist_count[1:length(sold_hist_count)];
    
    prof = (10^myBreaks[1:length(prob_count)])*myProf/100;
    
    png(file=paste0(waySave, "plotProfPrice.png"),width = size[1], height = size[2]);
    
    plot(myBreaks[1:length(prof)],
         prob_count*prof,
         type = "o",
         main = "График прибыли относительно цены товара",
         xlab = "log10(Price)",
         ylab = "Profit");

    box();
    
    dev.off();
    
    
    return("plotProfPrice");
  }#  функция постороения гистограммы которая возвращает имя 
  
  plotProfPrice();  # вызов функции построения гистограммы
  
}