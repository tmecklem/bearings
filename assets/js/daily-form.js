import { Socket } from 'phoenix'

export default class DailyForm {

  constructor() {
    this.channel = this.initChannel()
    this.goalsForm = document.querySelector('.goals-form')
  }

  initChannel() {
    let socket = new Socket('/socket', {})
    socket.connect()

    let channel = socket.channel(`dailies:${this.getDailyId()}`, {username: this.getUserName()})
    return channel
  }

  getDailyId() {
    // Gets the date from the location, allowing
    // us to get the daily ID to connect to the
    // right channel.
    const location = document.location.href
    return location.match(/(\d{4})-(\d{1,2})-(\d{1,2})/)[0]
  }

  getUserName() {
    // Gets the username from location
    // The channel requires the username
    // to be passed in as a parameter
    return document.location.href.match(/\/(.*)\/(.*)\/dailies/)[2]
  }

  joinDailyChannel() {
    this.channel.join()
      .receive('ok', () => {
       this.initAddGoalButton()
       this.setChannelEventListeners()
     })
      .receive('error', resp => { console.log('Failed to join daily channel', resp) })
  }

  initAddGoalButton() {
    const addGoalButton = document.getElementById('add-goal-btn')
    if (addGoalButton) {
      addGoalButton.addEventListener('click', (event) => {
        this.channel.push('add_goal')
      }, false)
    }
  }

  setChannelEventListeners() {
    this.channel.on('new_goal_form', (payload) => {
      console.log('Got new goal with ', payload)
      if (this.goalsForm) {
        while (this.goalsForm.firstChild) {
          this.goalsForm.removeChild(this.goalsForm.firstChild)
        }
        this.goalsForm.insertAdjacentHTML('beforeend', payload.html)
        this.attachRemoveBtnEventListeners()
        this.attachSaveBtnEventListeners()
      }
    })
  }

  attachRemoveBtnEventListeners() {
    const btns = this.goalsForm.querySelectorAll('.remove-btn')
    if (btns && btns.length > 0) {
      btns.forEach((btn) => {
        btn.addEventListener('click', (e) => {
          this.channel.push(btn.data.eventMessage)
        }, false)
      })
    }
  }

  attachSaveBtnEventListeners() {
    const btns = this.goalsForm.querySelectorAll('.save-btn')
    if (btns && btns.length > 0) {
      btns.forEach((btn) => {
        btn.addEventListener('click', (e) => {
          const index = btn.data.index
          const input = this.goalsForm.querySelector(`#goal-${index}`)
          this.channel.push(btn.data.eventMessage, {body: input.value})
        }, false)
      })
    }
  }
}