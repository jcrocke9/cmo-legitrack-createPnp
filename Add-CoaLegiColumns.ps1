Import-Module SharePointPnPPowerShellOnline -NoClobber

function Add-CoaSiteColumn {
    $columnXml = @(
        '<Field ID="e2d7556d-b67d-42fd-b883-bc8ef1fef0c3" Name="legiNumber" DisplayName="Bill Number" Type="Text" Group="LegiStation"></Field>',
        '<Field ID="264346f4-bda5-4c8e-99e0-6f68cb702670" Name="legiChamber" DisplayName="Chamber" Type="Text" Group="LegiStation"></Field>',
        '<Field ID="9a69b990-d2a4-4f59-9286-e80363897b97" Name="legiDateIntro" DisplayName="Introduced" Type="DateTime" Format="DateOnly" Group="LegiStation"></Field>',
        '<Field ID="9d7a2e52-9dd0-4bd8-a325-853cc911334b" Name="legiOutcome" DisplayName="Outcome" Type="Text" Group="LegiStation"></Field>',
        '<Field ID="df3958d8-a3bb-4f51-b252-28f73c59e90e" Name="legiBody" DisplayName="Body" Type="Note" Group="LegiStation"></Field>',
        '<Field ID="19bb5d56-2937-4bce-a520-2b1711c5d0de" Name="legiId" DisplayName="Bill Unique ID" Type="Number" Group="LegiStation"></Field>',
        '<Field ID="184457f6-a3ca-4d8c-98b5-d567c31fffad" Name="legiUserId" DisplayName="Bill User" Type="Number" Group="LegiStation"></Field>'
    );

    $columnXml | ForEach-Object {
        Add-PnPFieldFromXml -FieldXml $_
    }
}

function Add-CoaPnpColumn {
    $ct = Get-PnPContentType -Identity "Item"
    Add-PnPContentType -Name "Bill" -Group "LegiStation" -ParentContentType $ct
    
}

function Add-CoaColumnToCt {
    $columnNames = @('legiNumber','legiChamber','legiDateIntro','legiOutcome','legiBody','legiId','legiUserId');

    $columnNames | ForEach-Object {
        Add-PnPFieldToContentType -Field $_ -ContentType Bill
    }
}

function Add-CoaList {
    New-PnPList -Title "Bills" -Template "Custom" -EnableVersioning -EnableContentTypes
    Add-PnPContentTypeToList -List "Bills" -ContentType "Bill"
    Add-PnPView -List "Bills" -Title "AllBills" -RowLimit 5000 -Fields 'legiNumber',"Title",'legiChamber','legiDateIntro' -SetAsDefault
    Add-PnPView -List "Bills" -Title "AllTesterBills" -RowLimit 5000 -Fields "Title",'legiBody','legiId','legiUserId'
    Set-PnPDefaultContentTypeToList -List "Bills" -ContentType "Bill"
}
