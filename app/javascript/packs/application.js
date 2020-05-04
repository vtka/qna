import 'core-js/stable'
import 'regenerator-runtime/runtime'
import "cocoon-js";
import "gist-embed/dist/gist-embed.min.js"
import '../src/scss/application.scss'

require("@rails/ujs").start()
require("turbolinks").start()
require("@rails/activestorage").start()
require("jquery")
require("channels")

require("../answers")
require("../questions")
require("../embed")
require("../votes")

console.log('Hello World from Webpacker')
