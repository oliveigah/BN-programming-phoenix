# 1 - Introducing Phoenix

- Phoenix is a web framework designed for real time communication, exchanging small data each time instead of one massive update
- The secret sauce of phoenix is the right mix of many features found on other technologies, metaprogramming like lisp, DSLs like ruby, transformations series like clojure, and high scalability with erlang.
- Some of the most noticible features are channels and reactive friendly apis, like some of the best JS frameworks, but it works on scale

## 1.1 - Productive

- Phoenix provides a good amount of very common features right out of the box, which enable programmers be more productive by does not have to worry about such commom tasks like database connection and JSON decoding
- On the framework's classic productivity vs maintainablitiy problem, phoenix takes an layered approach to complexity, layering instead of hiding it.
- It is a highly opinionated framework
- Out of the box, phoenix provides a baseline strucuture to work with, if the need to make a obscure change arrises, the developer can pick under the hood of each complexity layer
- Each of these layers have great documentation avaiable online, on terminal or text editors
- Data immutability achieved by the functional paradigm of elixir plays a great role on maintainablitiy

## 1.2 - Concurrent

- Phoenix leverages the [BEAM concurrency model](https://techfromscratch.com.br/book-notes/elixir-in-action/chapter_5.html) to provide efficient usage of hardware
- This simplification of concurency makes developers life easier and results in more productivity

## 1.3 - Beautiful Code

- Phoenix abstractions leverage macros functionality to make otherwise complex tasks easier and reusable
- The modularity of these abstractions makes phoenix highly extensible

## 1.4 - Interactive

- Phoenix leverages [BEAM concurrency model](https://techfromscratch.com.br/book-notes/elixir-in-action/chapter_5.html) to provide a way out of scale by forgetting, providing light weight processes to keep connections and state
- This enable building highly interactive real time applications

## 1.5 - Reliabe

- Phoenix leverages [OTP supervisors](https://techfromscratch.com.br/book-notes/elixir-in-action/chapter_8.html#8-3-supervisors) to provide nice error handling and self restore connections
- This increases system's reliability
