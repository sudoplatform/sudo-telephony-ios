## Pod
New pod version

## Defects fixed and features added
Insert Jira defect or story links. Include brief descriptions.

## Additional changes required in consuming application
Describe any APIs that were updated or required changes to be made in
the consuming application.

## How to test
Describe how the reviewer should test the new pod.

## Tests
Describe tests added or updated in the project of origin.

## Development Checklist

- [ ] Ensure `bundle exec pod install` was used to update the pod

## Secure Development Lifecycle

- [ ] Are there any specific security, privacy and data protection should be considered by the reviewer of this MR?


- [ ] Have the documented threat models been updated as a result of this change? 


- [ ] Have all high and medium severity findings from static code analysis tools have been addressed?  If not, which findings have not been addressed, and why?


- [ ] Are new log messages free of sensitive data, such as user content or personal information?


- [ ] Are newly integrated third-party services accessed over encrypted connections?


- [ ] For mobile apps, are new third party credentials obtained from back-end services rather than hard-coded in the app?


- [ ] Where new files are created, do they have owner and permissions set based on the principle of least privilege?


- [ ] For API implementations, has user input been stripped from error responses?
