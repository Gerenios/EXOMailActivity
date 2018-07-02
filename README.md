# EXOMailActivity
PowerShell module for querying mail activities.

With this PowerShell module, you can query user's Exchange Online mail activities using an undocumented ActivityAccess API.
The API allows access to a log which stores activities for longer time than the "official" activity logs. 
This helps organisations to perform forensic activities in case of data breach or malware attacks.

## Usage
``` PowerShell
# Save credentials to a variable
$creds=Get-Credential

# Query for the first 500 mail logins of a user
Get-MailActivity -Credentials $cred -User "john.doe@example.com" -MaxResult 500 -ActivityType ServerLogon
# Query for the next 500 mail logins of a user
Get-MailActivity -MaxResult 500 -StartFrom 500 -ActivityType ServerLogon

# Get delivered messages and message details 
$Activities=Get-MailActivity -Credentials $cred -User "john.doe@example.com" -MaxResult 500 -ActivityType MessageDelivered
Get-MailActivityDetails -ActivityItemId $Activities[0].ActivityItemId -IncludeBody

```


## Credits
Based on the research of CrowdStrike https://www.crowdstrike.com/blog/hiding-in-plain-sight-using-the-office-365-activities-api-to-investigate-business-email-compromises/
