# React - unwanted component rerendering

## Prelim

The attached `.jsx` files describe a very simple app, consisting of:

- a list of users, `Cory`, `Meg` and `Bob`
- a button next to each user, marked `Delete`

When a `Delete` button is clicked, the associated user is removed from the list. However, you notice this causes **all** `User` components to rerender.

- what components would you expect to be rerendered? Why?
- suggest possible root causes and solutions for the app

You can assume `index.jsx` is transpiled and mounted in a HTML page correctly.

## Further prompts

- why might all components rerendering be a problem?
  - rerendering is expensive
  - if `User` becomes a parent component, children would also be affected
  - we would like deleting a user to be a `O(1)` action rather than `O(n)`
- how does React decide when to rerender a component? (i.e. explain the data model)
  - by default, when a component recieves different `props` or `state`
  - what kind of comparison is used to check differences - shallow
- what is the flow of data/event between the parent and child components?
  - flux flow, i.e. one-way cycle rather than two-way data binding
- how do ES6 arrow functions differ from ES5 standard functions
  - implicit binding of self to the new function closure
  - each arrow function has new identity when executed at runtime

## General discussion

- state management
  - stateless functional components
    - easy to test, reason about
    - suited to simple tasks
  - stateful components
    - essentially a small application
    - requires store/state mocking for tests
  - external stores (redux etc)
    - removes part of the component model, possibly over-separating concerns
    - easily serialisable (e.g. to web storage)
- why React?
  - unidirectional data model
  - shadow DOM for fast diffing before rendering
