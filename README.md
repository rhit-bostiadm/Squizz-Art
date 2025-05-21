# Squizz Art README

## Directions for running Squizz Art:

1. Make sure Node JS and Express is installed (run "npm install express").
2. In one terminal, navigate to "Squizz-Art/server" and run "node server.js". This will print out the IP it is hosting on.
3. For the network communication to work, a line of code in "draw_page.dart" needs to be changed to the IP the server prints out. Change line 31 to 'ws://{IP}:8080'.
4. In a second terminal, navigate to "Squizz-Art/squizz_art" and run the command "flutter run -d chrome --web-hostname {IP} --web-port 80". The host's firewalls will need to be disabled for different machines to connect to Squizz Art.
