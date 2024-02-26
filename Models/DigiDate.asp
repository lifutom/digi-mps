<%
Class DigiDate

    Private mDate

    Public Property Let actDate (Value)
        If Value <> "" Then
           mDate = Value
           Init
        Else
            InitEmpty
        End If
    End Property

    Public Property Get actDate
        actDate = mDate
    End Property

    Public curYear
    Public curMonth
    Public curDay
    Public curHour
    Public curMinute
    Public curSecond

    Public curTime
    Public curShortTime

    Public curDBDate
    Public curDBDateTime

    Private Sub Class_Initialize()

    End Sub

    Private Sub Class_Terminate()
    End Sub

    Private Sub Init

        curYear = CStr(Year(mDate))
        curMonth = Right("00" & Month(mDate),2)
        curDay = Right("00" & Day(mDate),2)

        curHour = Right("00" & Hour(mDate),2)
        curMinute = Right("00" & Minute(mDate),2)
        curSecond = Right("00" & Second(mDate),2)

        curTime = curHour & ":" & curMinute & ":" & curSecond
        curShortTime = curHour & ":" & curMinute

        curDBDate = curYear & "-" & curMonth  & "-" & curDay
        curDBDateTime = curDBDate & " " & curTime

    End Sub

    Private Sub InitEmpty

        mDate = ""
        curYear = ""
        curMonth = ""
        curDay = ""

        curHour = ""
        curMinute = ""
        curSecond = ""
        curTime = ""
        curShortTime = ""

        curDBDate = ""
        curDBDateTime = ""

    End Sub

End Class
%>