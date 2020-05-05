var passwordField;
var passwordConfirmationField;

document.addEventListener('turbolinks:load', function () {
  passwordField = document.querySelector('.password-field');
  passwordConfirmationField = document.querySelector('.password-confirmation-field');

  if (passwordField && passwordConfirmationField) {
    passwordField.addEventListener('input', passwordMatchIndicator);
    passwordConfirmationField.addEventListener('input', passwordMatchIndicator);
  }
});

function passwordMatchIndicator() {
  if (passwordConfirmationField.value.length > 0 ) {
    compareValues();
  } else {
    hideIcons();
  }
}

function compareValues() {
  document.querySelector('.password-icon-field').classList.remove('hidden');
  if (passwordField.value === passwordConfirmationField.value) {
    passwordsMatch();
  } else {
    passwordsDoNotMatch();
  }
}

function passwordsMatch() {
  document.querySelector('.octicon-check').classList.remove('hidden');
  alertIcon = document.querySelector('.octicon-alert').classList.add('hidden');
}

function passwordsDoNotMatch() {
  document.querySelector('.octicon-check').classList.add('hidden');
  alertIcon = document.querySelector('.octicon-alert').classList.remove('hidden');
}

function hideIcons() {
  document.querySelector('.octicon-check').classList.add('hidden');
  document.querySelector('.octicon-alert').classList.add('hidden');
  document.querySelector('.password-icon-field').classList.add('hidden');
}
