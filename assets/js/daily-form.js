export default class DailyForm {

  constructor() {
    const addGoalButton = document.getElementById("add-goal-btn");
    if (addGoalButton) {
      addGoalButton.addEventListener('click', (event) => {
        this.addGoal();
      }, false);
    }
  }

  addGoal() {
    const goalsDiv = document.querySelector('.goals-form');
    const goalsCount = goalsDiv.querySelectorAll('.form-control').length;
    const newInput = this.createGoalForm(goalsCount);

    goalsDiv.appendChild(newInput);
  }

  createGoalForm(goalsCount) {
    const row = this.createDiv(`row goal-inputs-${goalsCount}`);
    const inputCol = this.createDiv('col-10');
    const input = this.createGoalInput(goalsCount);
    const removeCol = this.createDiv('col');
    const removeBtn = this.createRemoveBtn(goalsCount);
    inputCol.appendChild(input);
    removeCol.appendChild(removeBtn);
    row.appendChild(inputCol);
    row.appendChild(removeCol);
    return row;
  }

  createDiv(className) {
    const div = document.createElement('div');
    div.setAttribute('class', className);
    return div;
  }

  createGoalInput(goalsCount) {
    const input = document.createElement('input');
    input.setAttribute('class', 'form-control');
    input.setAttribute('data-test', `goal-${goalsCount}`);
    input.setAttribute('id', `daily_goals_${goalsCount}_body`);
    input.setAttribute('name', `daily[goals][${goalsCount}][body]`);
    input.setAttribute('type', 'text');
    return input;
  }

  createRemoveBtn(index) {
    const btn = document.createElement('button');
    btn.setAttribute('class', 'btn btn-danger');
    btn.setAttribute('type', 'button')
    btn.innerText ='Remove';
    btn.addEventListener('click', (e) => {
      this.removeGoal(index);
    }, false);
    return btn;
  }

  removeGoal(index) {
    const goalInputs = document.querySelector(`.goal-inputs-${index}`);
    goalInputs.remove();
  }
}