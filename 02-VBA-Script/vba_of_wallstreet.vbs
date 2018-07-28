Sub CountTickerVolume()

For Each ws In Worksheets
        
        ws.Range("J1").Value = "Ticker"
        ws.Range("K1").Value = "Yearly Change"
        ws.Range("L1").Value = "Percent Change"
        ws.Range("M1").Value = "Total Stock Volume"
        
        Dim lastRowOfColumnA As Double
        Dim summaryTableRowNumber As Double
        Dim totalStockVolume As Double
        Dim yearStartStockValue As Double
        Dim yearEndStockValue As Double
        
       
        
        
        
        lastRowOfColumnA = ws.Cells(Rows.Count, 1).End(xlUp).Row
        
        summaryTableRowNumber = 2 'starting from row 2 to skip headers
        totalStockVolume = 0
        
        yearStartStockValue = ws.Range("C2").Value
        
        For i = 2 To lastRowOfColumnA
            ws.Range("J" & summaryTableRowNumber) = ws.Cells(i, 1)
           
            
            
            If ws.Cells(i, 1).Value <> ws.Cells(i + 1, 1).Value Then
                
                
                    yearEndStockValue = ws.Range("F" & i).Value
                    
                    yearlyChange = yearEndStockValue - yearStartStockValue
                    
                    ws.Range("K" & summaryTableRowNumber).Value = yearlyChange
                    
                    Dim yearlyChangePercentage As Double
                    
                    If yearStartStockValue = 0 Then
                         yearlyChangePercentage = 0
                     Else
                         yearlyChangePercentage = yearlyChange / yearStartStockValue
                    End If
                    
                    ws.Range("L" & summaryTableRowNumber).Value = yearlyChangePercentage
                    ws.Range("L" & summaryTableRowNumber).NumberFormat = "0.00%"
                    
                    If yearlyChange > 0 Then
                    
                        ws.Range("K" & summaryTableRowNumber).Interior.Color = ColorConstants.vbGreen
                    
                    Else
                    
                        ws.Range("K" & summaryTableRowNumber).Interior.Color = ColorConstants.vbRed
                    
                    End If
                                                         
                    
                    yearStartStockValue = ws.Range("C" & i + 1).Value
                    
                    
                    
                    summaryTableRowNumber = summaryTableRowNumber + 1
                    totalStockVolume = 0
              
                
                
            
            Else
                
                
                totalStockVolume = ws.Range("G" & i).Value + totalStockVolume
                ws.Range("M" & summaryTableRowNumber).Value = totalStockVolume
                
            End If
            
            
            
        
        Next i
        
        
        
 
        
        Dim lastRowOfColumnL As Double
        lastRowOfColumnL = ws.Cells(Rows.Count, 12).End(xlUp).Row
        
     

        Dim percentageRange As Range, totalVolumeRange As Range, FindRange As Range
        Set percentageRange = ws.Range("L1:L" & lastRowOfColumnL)
        Set totalVolumeRange = ws.Range("M1:M" & lastRowOfColumnL)
        
        Dim greatestIncreasePercentage As Double
        Dim greatestIncreasePercentTicker As String
        
        greatestIncreasePercentage = Application.Max(percentageRange)
        Dim maxPercentageRow As Double
        Set FindRange = percentageRange.Find(what:=greatestIncreasePercentage * 100)
        maxPercentageRow = FindRange.Row
        greatestIncreasePercentTicker = ws.Range("J" & maxPercentageRow)
        
        Dim greatestDecreasePercentage As Double, greatestDecreasePercentTicker As String
        
        greatestDecreasePercentage = Application.Min(percentageRange)
        Dim minPercentageRow As Double
        Set FindRange = percentageRange.Find(what:=greatestDecreasePercentage * 100)
        minPercentageRow = FindRange.Row
        greatestDecreasePercentTicker = ws.Range("J" & minPercentageRow)
        
        Dim greatestTotalVolume As Double
        Dim greatestTotalVolumeTicker As String
        
        greatestTotalVolume = Application.Max(totalVolumeRange)
        Dim maxTotalVolumeRow As Double
        Set FindRange = totalVolumeRange.Find(what:=greatestTotalVolume)
        maxTotalVolumeRow = FindRange.Row
        greatestTotalVolumeTicker = ws.Range("J" & maxTotalVolumeRow)
        
        ws.Range("Q1") = "Ticker"
        ws.Range("R1") = "Value"
        
        ws.Range("P2").Value = "Greatest % Increase"
        ws.Range("Q2").Value = greatestIncreasePercentTicker
        ws.Range("R2").Value = greatestIncreasePercentage
        ws.Range("R2").NumberFormat = "0.00%"
        
        ws.Range("P3").Value = "Greatest % Decrease"
        ws.Range("Q3").Value = greatestDecreasePercentTicker
        ws.Range("R3").Value = greatestDecreasePercentage
        ws.Range("R3").NumberFormat = "0.00%"
        
        ws.Range("P4").Value = "Greatest Total Volume"
        ws.Range("Q4").Value = greatestTotalVolumeTicker
        ws.Range("R4").Value = greatestTotalVolume
        

Next ws
      


End Sub


