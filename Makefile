build:
	elm make src/Main.elm --output elm.js
	sass src/main.scss > main.css
