#   myParse:  price, title


plotNN <- function(sql)
{
  # создаем запрос
  queryData = paste("select price, title, shipping ",
                    "from ", 'dima_parser', ".myParse ",
                    "where ind > -2 ", sql, ";", sep = "");
  
  parse <- readTable(queryData, 'dima_parser');
  
  if(nrow(parse)==0){
    return(NULL)
  }
  
  maxPrice = log10(max(parse$price+parse$shipping, na.rm = T))+0.3;
  
  myBreaks = seq(-0.1, maxPrice, by = 0.1);
  
  NN <-function(data = parse)
  {
    
    y = hist(log10(data$price+data$shipping),
                              breaks = myBreaks, 
                              plot = F)$counts;
    
    x = seq(0.05, maxPrice+0.1,0.1)[1:(length(myBreaks)-1)]
    
    id = seq(1,length(x),1)
    
    res = data.frame(id, x, y);
    
    return(res)
  }
  
  return(NN()) 
}
