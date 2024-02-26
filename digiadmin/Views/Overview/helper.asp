 .Add "backgroundColor",oJSON.Collection()
                    With .Item("backgroundColor")
                        idx1=1
                        For Each Item In DeviceList.Items
                            .Add idx1,"rgba(255, 206, 86, 0.2)"
                            idx1=idx1+1
                        Next
                    End With
                    With .Item("backgroundColor")
                        idx1=1
                        For Each Item In DeviceList.Items
                            .Add idx1, "rgba(255, 99, 132, 0.2)"
                            idx1=idx1+1
                        Next
                    End With
                    .Add "borderColor",oJSON.Collection()
                    With .Item("borderColor")
                        idx1=1
                        For Each Item In DeviceList.Items
                            .Add idx1,"rgba(255, 206, 86, 1)"
                            idx1=idx1+1
                        Next
                    End With
                    With .Item("borderColor")
                        idx1=1
                        For Each Item In DeviceList.Items
                            .Add idx1, "rgba(255,99,132,1)"
                            idx1=idx1+1
                        Next
                    End With
                End With
                idx=idx+1
                ''.Add idx,oJSON.Collection()
                ''With .Item(idx)
                ''    .Add "label","Produktion"
                ''    .Add "data",oJSON.Collection()
                ''    With .Item("data")
                ''        idx1=1
                ''        For Each Item In DeviceList.Items
                ''            .Add idx1,Item.Cnt
                ''            idx1=idx1+1
                ''        Next
                ''    End With
                ''End With