# WebView Components for LabVIEW

## WebView-BaseClas

Note: The following methods are executing in the USER Thread due to .net limitations.

- Go Back
- Go Forward
- Run Javascript
- Post WebMessage 
- Reload

Important: Calling "Run Javascript" continously or with long execution can block the block the UI thread in LabVIEW. Use instead "Post WebMessage" to send an action to an event handler in Javascript


## Components
### JsonEditor