# Description
Provide a description of the PR

# Proposed Changes 
List changes below in bullet format:

- Change 1
- Change 2
- Change 3

**Screenshots**
If applicable, add screenshots to help explain the proposed changes

### Issue Addressed
**Closes #[provide issue number to link here]**

### PR Checklist
Before submitting this PR, please check and verify below that the submission meets the below criteria:

- [ ] New/revised functions have associated tests
- [ ] New tests that make API calls use `httptest::with_mock_api` and any new mocks were added to `tests/testthat/fixtures/create_httptest_mocks.R`
- [ ] New/revised functions use appropriate naming conventions
- [ ] New/revised functions don't repeat code
- [ ] Code changes are less than **250** lines total
- [ ] Issues linked to the PR using [GitHub's list of keywords](https://docs.github.com/en/issues/tracking-your-work-with-issues/linking-a-pull-request-to-an-issue)
- [ ] The appropriate reviewer is assigned to the PR
- [ ] The appropriate developers are assigned to the PR

# Code Review
This section to be used by the reviewer and developers during Code Review after PR submission

### Code Review Checklist

- [ ] I checked that new files follow naming conventions and are in the right place
- [ ] I checked that documentation is complete, clear, and without typos
- [ ] I added/edited comments to explain "why" not "how"
- [ ] I checked that all new variable and function names follow naming conventions
- [ ] I checked that new tests have been written for key business logic and/or bugs that this PR fixes
- [ ] I checked that new tests address important edge cases
