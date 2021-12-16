import { library, dom } from '@fortawesome/fontawesome-svg-core'
import { fas } from '@fortawesome/free-solid-svg-icons'
// import { fab } from '@fortawesome/free-brands-svg-icons'
import { faGithub } from '@fortawesome/free-brands-svg-icons'

import 'phoenix_html'
import './live-view.js'
import 'bootstrap'

library.add(fas, faGithub)
dom.watch()
