// pull in desired CSS/SASS files
require( './styles/main.scss' );

var Elm = require( '../src/Main' );

var app = Elm.Main.fullscreen(localStorage.session || null);

app.ports.storeSession.subscribe(function(session) {
localStorage.session = session;
});

window.addEventListener("storage", function(event) {
if (event.storageArea === localStorage && event.key === "session") {
  app.ports.onSessionChange.send(event.newValue);
}
}, false);