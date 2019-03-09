Attribute VB_Name = "Hard_Stock_VBA"
Sub Hair_pulling()

'Loop through all worksheets

For Each ws In Worksheets

    'Create Variables to hold Ticker, Open Value, and Close Value

    Dim Ticker As String
    Dim Open_Value As Double
    Dim Close_Value As Double
    
    'Create Variable to hold the total Volume per Ticker
    Dim Total_Volume As Double
        Total_Volume = 0
    
    'Create column headers for summaries
    
    ws.Cells(1, 9).Value = "Ticker"
    ws.Cells(1, 10).Value = "Yearly Change"
    ws.Cells(1, 11).Value = "Percent Change"
    ws.Cells(1, 12).Value = "Total Stock Volume"
    
    ws.Cells(1, 16).Value = "Ticker"
    ws.Cells(1, 17).Value = "Value"
    ws.Cells(2, 15).Value = "Greatest % Increase"
    ws.Cells(3, 15).Value = "Greatest % Decrease"
    ws.Cells(4, 15).Value = "Greatest Total Volume"
    ws.Columns(15).AutoFit
    ws.Columns(17).AutoFit
    
    'Create way to keep track of rows in Summary

    Dim Summary_Row As Long
        Summary_Row = 2

    'Find last row of data

    Last_Row = ws.Cells(Rows.Count, 1).End(xlUp).Row
    Last_Row_Summary = ws.Cells(Rows.Count, 11).End(xlUp).Row
    
    'Create counter
    
    Dim Data_Row As Double
        Data_Row = 0

    'Loop through all Stock Data for Ticker and Volume

    For i = 2 To Last_Row

        'Check if we are still within the same ticker, if not...
    
        If ws.Cells(i, 1).Value <> ws.Cells(i + 1, 1).Value Then
    
            'Set Ticker name
        
            Ticker = ws.Cells(i, 1).Value
        
            'Set Volume amount
        
            Total_Volume = Total_Volume + ws.Cells(i, 7).Value
            
            'Get opening value
                 
            Open_Value = ws.Cells(i - Data_Row, 3).Value
            
            'Get closing value
                    
            Close_Value = ws.Cells(i, 6).Value
                
            'Calculate Yearly Change
                    
            Dim Yearly_Change As Double
                Yearly_Change = Close_Value - Open_Value
                        
            'Calculate Percent Change
                    
            Dim Percent_Change As Double
            
            If Open_Value <> 0 Then
            
                Percent_Change = Yearly_Change / Open_Value
                    
            Else
            
                Percent_Change = 1
                
            End If
        
            'Print Ticker to Summary Table
        
            ws.Range("I" & Summary_Row).Value = Ticker
        
            'Print Volume to Summary Table
        
            ws.Range("L" & Summary_Row).Value = Total_Volume
            
            'Print Yearly Change to Summary Table
            
            ws.Range("J" & Summary_Row).Value = Yearly_Change
            
            'Print Percent Change to Summary Table
        
            ws.Range("K" & Summary_Row).Value = Percent_Change
        
            'Add row to Summary
        
            Summary_Row = Summary_Row + 1
        
            'Set Volume amount back to zero
        
            Total_Volume = 0
            
            'Set row counter back to zero
            
            Data_Row = 0
        
        'If we are within the same ticker....
    
        Else
    
            'Add to total Volume
        
            Total_Volume = Total_Volume + ws.Cells(i, 7).Value
            
            Data_Row = Data_Row + 1
        
        End If
        
    Next i
    
    'Loop through summary table
    
    Dim j As Double
    
    For j = 2 To Last_Row_Summary
    
        'Format column J to 0.000000000
        
        ws.Cells(j, 10).NumberFormat = "0.000000000"
        
        'Format column K to percentage
        
        ws.Cells(j, 11).NumberFormat = "0.00%"
        
        'Make change greater than zero green and less than zero red for Column J
        
        Dim Red As Integer
            Red = 3
        Dim Green As Integer
            Green = 4
        
        If ws.Cells(j, 10).Value < 0 Then
        
            ws.Cells(j, 10).Interior.ColorIndex = Red
            
        Else
            
            ws.Cells(j, 10).Interior.ColorIndex = Green
        
        End If
        
    Next j
            
    'Set placeholder variables to find max increase, max decrease, and max total volume
    Dim Max As Double
        Max = 0
    Dim Min As Double
        Min = 0
    Dim MaxVol As Double
        MaxVol = 0
    
    'Loop through summary to find max increase, max decrease, and max total volume
    Dim k As Double
        k = 2
            
    For k = 2 To Last_Row_Summary
        
        'Identify Max increase
        If ws.Cells(k, 11).Value > Max Then
        
            'Update Max each time a higher percent change is identified
            Max = ws.Cells(k, 11).Value
            
            'Update summary table with ticker for Max
            ws.Cells(2, 16).Value = ws.Cells(k, 9).Value
        
        End If
        
        'Identify Min decrease
        If ws.Cells(k, 11).Value < Min Then
        
            'Update Min each time a lower percent change is identified
            Min = ws.Cells(k, 11).Value
            
            'Update summary table with ticker for Min
            ws.Cells(3, 16).Value = ws.Cells(k, 9).Value
        
        End If
        
        'Identify Max total volume
        If ws.Cells(k, 12).Value > MaxVol Then
            
            'update MaxVol each time a higher total is identified
            MaxVol = ws.Cells(k, 12).Value
            
            'update summary table with ticker for MaxVol
            ws.Cells(4, 16).Value = ws.Cells(k, 9).Value
        
        End If
        
    Next k
    
    'Update and format summary table for Max, Min, and MaxVol
    ws.Cells(2, 17).Value = Max
    ws.Cells(2, 17).NumberFormat = "0.00%"
    ws.Cells(3, 17).Value = Min
    ws.Cells(3, 17).NumberFormat = "0.00%"
    ws.Cells(4, 17).Value = MaxVol
    ws.Cells(4, 17).NumberFormat = "000,000"

Next ws

End Sub
