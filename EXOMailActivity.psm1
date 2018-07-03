$EXOMailActivity_credentials
$EXOMailActivity_user

$token="EwAoA+l3BAAUv0lYxoez7x2t6RowHa2liVeLW/wAAawhWygBQh5LqeUI+UgVXXA5cXdxYqNuvCvnvFFW5nIhfVZ7Kt3xf8sPhR9uYlNWRrfceo46B+jKLF6iVREkvAVaKUQ35A0z6QAE4Oiogd/iB8cnPbs84veU86T7y8Do3M7ejfBWIp24jSy5pq5nR9vP3V1vusuDlss87sMDb7tHwWmqP0xz9WIRxzhpZcUnzYehbH1s78xKqbB50GJ/KQXunuQuhVtpnQ762fN5A7qffnqRfHC+VhN3WU8m/pJB5ebY19iOaGw4mEevq39GQMra1arqZNAoBdBrJ6++NGLBuFmFR1g8+8eSsRNWmQh2BIQnJXKSt/qGq+J8Q2VzaSMDZgAACBz5Nu1vnr1L+AHSJZWsudZ4l19fZs+W51lXqkn6Hisnm0n2FkU61WnKyTPBNIiZUPHivfPD6EHBNYYmTw61SCOPnErwenWAwMbG9xVwHaMk0ehUCJ9Sq2VQG4OCMKhn2xP9CjdhnPRI+zLb0m0k5EuiZ5eMgSDUC1NItpci/mZTDPalNctMHIC9bDQnER+33o2nZCI1K8Gpo/PQ7aKbo8QhTqDdtl7ZqxST1z71AyMaAxtiYuGMQXDvdIcCrEGiqhDpoLqgN6AVQW3U52vGE7kP8buyG0LEUThiK9/1t7eg+mzATzONIFKJqR2nP9b/CEKJM14b8Zd48YW632PbcUV4KZIiCRIBwjvuEqY/MxBcTRYjutjLgXR1VfUMqe9y1j3sdrBZpDcxW6jtXGWlaP+AmODD8rjwW+dLfaCGm/SfWQUc1oRomNNBQ0+DULs/YbWyRw6tcXh51DqqokbCS4pUZnnFC2OC6Y3Y5DGp/ehMqFsejBcKyg6kqVL/LVZO8hryGoWbSSmrCNw8HCTq2JdcqOO4rSkRdieVmjC3rZzkKmHbI9ACsEJNJb0i/+g10rJ9AeAstO3UMt++bhnzUFEW6infTLH4H5ajtvueaGfsYsRbwJNRuEnMqGlEwbYfcTBVvhh65ppxhvLMSmxAp1/3/7g7Jt0/xrFBxzTPzIPXdo00Ag=="


function Get-MailActivity 
{
<#
.SYNOPSIS
Queries user's Exchange Online Mail Activity log.

.Description
Queries given user's Exchange Online Mail Activity log using "hidden" ActivityAccess API.
  
.Parameter Credentials
Credentials used to connect to Exchange Online. If not given, uses previously used credentials.

.Parameter User
User whose email activity is queried. Should be in email format. If not given, uses previously used user.

.Parameter EndTime
End time. If not given, will be the current time. Can be in any format PowerShell understands.

.Parameter StartTime
Start time. If not given, will be 1 month before the End time. Can be in any format PowerShell understands.

.Parameter MaxResults
The maximum number of activities returned (default 500). Must be more than 0 and less than 1000.

.Parameter StartFrom
The position where activities are returned. Can be used for pagination.

.Parameter ActivityType
Returns activites based on selected ActivityType.
Delete:                  A message was deleted (by a user or by Exchange)
Forward:                 A message was forwarded
LinkClicked:             A link in a message was clicked (does not apply to all application types)
MarkAsRead:              A message was marked as read
MarkAsUnread:            A message was marked as unread
MessageDelivered:        A message was delivered to the mailbox
MessageSent:             A message was sent from the mailbox
Move:                    A message was moved (by a user or by Exchange)
OpenenedAnAttachment:    An attachment was opened (does not apply to all application types)
ReadingPaneDisplayEnd:   A message was deselected in the reading pane
ReadingPaneDisplayStart: A message was selected in the reading pane (a message was viewed)
Reply:                   A message was replied to (also ReplyAll)
SearchResult:            Search results were generated
ServerLogon:             A logon event occurred (may also be accompanied by a Logon activity)

.Parameter ApplicationType
Returns activites based on selected ApplicationType.
Exchange:   Exchange Online
IMAP4:      IMAP4 client
Lync:       Lync / Skype for Business
MacMail:    MacOS Mail
MacOutlook: MacOS Outlook
Mobile:     Mobile browser
Outlook:    Windows Outlook
POP3:       POP3 client
Web:        Outlook on the web

.Example
C:\PS>$cred=Get-Credential
C:\PS>Get-MailActivity -Credentials $cred -User "john.doe@example.com"

.Example
C:\PS>Get-MailActivity -Credentials $cred -User "john.doe@example.com" -MaxResult 500 -ActivityType ServerLogon
C:\PS>Get-MailActivity -MaxResult 500 -StartFrom 500 -ActivityType ServerLogon

.Link
Get-MailActivityDetails

#>
    [cmdletbinding()]
    Param(
        [Parameter(Mandatory=$False, HelpMessage="Credentials used to connect to Exchange Online.")]
        [System.Management.Automation.PSCredential]$Credentials,
    
        [Parameter(Mandatory=$False, HelpMessage="User whose email activity is queried. Should be in email format.")]
        [String]$User,
        
        [Parameter(Mandatory=$False, HelpMessage="Start time. If not given, will be 1 month before the End time. Can be in any format PowerShell understands.")]
        [DateTime]$StartTime,

        [Parameter(Mandatory=$False, HelpMessage="End time. If not given, will be the current time. Can be in any format PowerShell understands.")]
        [DateTime]$EndTime,

        [Parameter(Mandatory=$False, HelpMessage="The maximum number of activities returned (default 500). Must be more than 0 and less than 1000.")]
        [Int]$MaxResults=500,

        [Parameter(Mandatory=$False, HelpMessage="The position where activities are returned. Can be used for pagination.")]
        [Int]$StartFrom=0,

        [Parameter(Mandatory=$False, HelpMessage="Returns activites based on selected ActivityType.")]
        [ValidateSet('Delete','Forward','LinkClicked','MarkAsRead','MarkAsUnread','MessageDelivered','MessageSent','Move','OpenedAnAttachment','ReadingPaneDisplayEnd','ReadingPaneDisplayStart','Reply','SearchResult','ServerLogon')]
        [String]$ActivityType,

        [Parameter(Mandatory=$False, HelpMessage="Returns activites based on selected ApplicationType.")]
        [ValidateSet('Exchange','IMAP4','Lync','MacMail','MacOutlook','Mobile','Outlook','POP3','Web')]
        [String]$ApplicationType
    )
    Process
    {
        # Check the credentials or use previous ones
        If($Credentials -eq $null)
        {
            if($script:EXOMailActivity_credentials -eq $null)
            {
                Throw "Credentials not set!"
            }
            else
            {
                Write-Verbose ("Using saved credentials: "+ $script:EXOMailActivity_credentials.UserName)
                $Credentials = $script:EXOMailActivity_credentials
            }
        }
        else
        {
            Write-Verbose ("Saving credentials: "+$Credentials.UserName)
            $script:EXOMailActivity_credentials = $Credentials
        }

        # Check the user or use previous one
        If([string]::IsNullOrEmpty($User))
        {
            if([string]::IsNullOrEmpty($script:EXOMailActivity_user))
            {
                Throw "User not set!"
            }
            else
            {
                Write-Verbose ("Using saved user: "+$script:EXOMailActivity_user)
                $User = $script:EXOMailActivity_user
            }
        }
        else
        {
            Write-Verbose "Saving user: $User"
            $script:EXOMailActivity_user = $User
        }

        If(($MaxResults -gt 1000) -or ($MaxResults -lt 1))
        {
            Throw "Invalid value for MaxResults, must be 1-1000 "
        }
        If($EndTime -eq $null)
        {
            # Set EndTime to current time
            $EndTime = Get-Date
        }
        If($StartTime -eq $null)
        {
            # Set StartTime to 1 month before current time
            $StartTime = $EndTime.AddMonths(-1)
        }

        # All parameters are valid so we're good to go!

        # Create a headers required by the Activity API
        $headers = @{"Prefer" = 'exchange.behavior="ActivityAccess"'}
        $headers += @{"Accept"="application/json; odata.metadata=none"}

        # Create a url - Select only standard properties and sort by TimeStamp
        $api_url="https://outlook.office365.com/api/v1.0/Users('$user')/Activities?`$orderby=TimeStamp+asc&`$select=TimeStamp,ActivityIdType,ActivityCreationTime,ActivityItemId,AppIdType,ClientSessionId,CustomProperties"
        
        # Add filter for StartTime and EndTime
        $StartTimeStr=$StartTime.ToUniversalTime().ToString("u").Replace(" ","T")
        $EndTimeStr=$EndTime.ToUniversalTime().ToString("u").Replace(" ","T")
        $api_url+="&`$filter=(TimeStamp ge $StartTimeStr and TimeStamp le $EndTimeStr"

        # Add filter for ActivityType
        if(![string]::IsNullOrEmpty($ActivityType))
        {
            $api_url+=" and ActivityIdType eq '$ActivityType'"
        }

        # Add filter for ApplicationType
        if(![string]::IsNullOrEmpty($ApplicationType))
        {
            $api_url+=" and AppIdType eq '$ApplicationType'"
        }

        # Close the Filter and Add MaxResults
        $api_url+=")&`$top=$MaxResults"
        
        # Add StartFrom
        If($StartFrom -gt 0)
        {
            $api_url+="&`$skip=$StartFrom"
        }

        # Verbose
        Write-Verbose "Querying API: $api_url"

        $response=try{
            # Invoke the API call
            $responseBody=Invoke-RestMethod $api_url -Headers $headers -Credential $Credentials
            $responseBody.value
        }
        Catch{
            # Get the error details
            $exception=$_
            $http_error=$exception.Exception.Message
            $result = $exception.Exception.Response.GetResponseStream()
            $reader = New-Object System.IO.StreamReader($result)
            $reader.BaseStream.Position = 0
            $reader.DiscardBufferedData()
            $responseBody=($reader.ReadToEnd()|ConvertFrom-Json).error
            $responseBody | Add-Member -NotePropertyName "HTTP error" -NotePropertyValue $http_error
            $responseBody
        }

        # Return the results
        return $response
    }
}

function Get-MailActivityDetails 
{
<#
.SYNOPSIS
Queries message details.

.Description
Queries message details from given user's Exchange Online mailbox using Outlook API.
  
.Parameter Credentials
Credentials used to connect to Exchange Online. If not given, uses previously used credentials.

.Parameter User
User whose email activity is queried. Should be in email format. If not given, uses previously used user.

.Parameter ActivityItemId
ActivityItemId of the email message.

.Parameter IncludeBody
Include body of the email message.


.Example
C:\PS>$cred=Get-Credential
C:\PS>Get-MailActivityDetails -Credentials $cred -User "john.doe@example.com" -ActivityItemId "AAAABC=="

.Example
C:\PS>$Activities=Get-MailActivity -Credentials $cred -User "john.doe@example.com" -MaxResult 500 -ActivityType MessageDelivered
C:\PS>Get-MailActivityDetails -ActivityItemId $Activities[0].ActivityItemId -IncludeBody

.Link
Get-MailActivity

#>
    [cmdletbinding()]
    Param(
        [Parameter(Mandatory=$False, HelpMessage="Credentials used to connect to Exchange Online.")]
        [System.Management.Automation.PSCredential]$Credentials,
    
        [Parameter(Mandatory=$False, HelpMessage="User whose email activity is queried. Should be in email format.")]
        [String]$User,
        
        [Parameter(Mandatory=$False, HelpMessage="ActivityItemId of the email message.")]
        [String]$ActivityItemId,

        [Parameter(Mandatory=$False, HelpMessage="Include body of the email message.")]
        [switch]$IncludeBody
    )
    Process
    {
        # Check the credentials or use previous ones
        If($Credentials -eq $null)
        {
            if($script:EXOMailActivity_credentials -eq $null)
            {
                Throw "Credentials not set!"
            }
            else
            {
                Write-Verbose ("Using saved credentials: "+ $script:EXOMailActivity_credentials.UserName)
                $Credentials = $script:EXOMailActivity_credentials
            }
        }
        else
        {
            Write-Verbose ("Saving credentials: "+$Credentials.UserName)
            $script:EXOMailActivity_credentials = $Credentials
        }

        # Check the user or use previous one
        If([string]::IsNullOrEmpty($User))
        {
            if([string]::IsNullOrEmpty($script:EXOMailActivity_user))
            {
                Throw "User not set!"
            }
            else
            {
                Write-Verbose ("Using saved user: "+$script:EXOMailActivity_user)
                $User = $script:EXOMailActivity_user
            }
        }
        else
        {
            Write-Verbose "Saving user: $User"
            $script:EXOMailActivity_user = $User
        }

        # Create a url - Select only standard properties and sort by TimeStamp
        $api_url="https://outlook.office365.com/api/v1.0/Users('$user')/Messages/$ActivityItemId"

        # Use select if IncludeBody not set
        if(!$IncludeBody)
        {
            $api_url+="?`$select=BccRecipients,BodyPreview,Categories,CcRecipients,ChangeKey,ConversationId,DateTimeCreated,DateTimeLastModified,DateTimeReceived,DateTimeSent,From,HasAttachments,Id,Importance,IsDeliveryReceiptRequested,IsDraft,IsRead,IsReadReceiptRequested,ParentFolderId,ReplyTo,Sender,Subject,ToRecipients,WebLink"
        }

        # Verbose
        Write-Verbose "Querying API: $api_url"

        $response=try{
            # Invoke the API call
            $responseBody=Invoke-RestMethod $api_url -Credential $Credentials
            $responseBody
        }
        Catch{
            # Get the error details
            $exception=$_
            $http_error=$exception.Exception.Message
            $result = $exception.Exception.Response.GetResponseStream()
            $reader = New-Object System.IO.StreamReader($result)
            $reader.BaseStream.Position = 0
            $reader.DiscardBufferedData()
            $responseBody=($reader.ReadToEnd()|ConvertFrom-Json).error
            $responseBody | Add-Member -NotePropertyName "HTTP error" -NotePropertyValue $http_error
            $responseBody
        }
        
        # Return the results
        return $response
    }
}