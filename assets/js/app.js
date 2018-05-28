import '../css/app.scss'
import '@babel/polyfill'
import 'phoenix_html'
import 'bootstrap'
import DailyForm from './daily-form'

if (document.getElementById('add-goal-btn')) {
  DailyForm.init()
}
