# Elm SPA Boilerplate

This is a stripped down version of a [Real World elm app](https://github.com/chrisUsick/elm-spa-example).

## Usage

Run the following command to install dependencies if you don't have them already:  

```
npm install -g elm elm-live
```

Run the development server

Then, to build everything:

```
elm-live --output=elm.js src/Main.elm --pushstate --open --debug
```

(Leave off the `--debug` if you don't want the time-traveling debugger.)


