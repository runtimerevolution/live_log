const consumer = ActionCable.createConsumer();

const url = `${window.location.href}/redis-data`;
const liveLogDiv = document.getElementById("live_log_id")

const Icons = {
  error: 'fa-exclamation-circle',
  warn: 'fa-exclamation-triangle',
  info: 'fa-info-circle',
  exception: 'fa-times-circle'
}

const copyElement = (e) => {
  navigator.clipboard.writeText(e.textContent.trim());
  e.querySelector("i").classList.remove("fa-files-o")
  e.querySelector("i").classList.add("fa-check")
}

const resetState = (e) => {
  e.querySelector("i").classList.remove("fa-check")
  e.querySelector("i").classList.add("fa-files-o")
  e.querySelector("i").style.opacity = "0"
}

const over = (e) => {
  e.querySelector("i").style.opacity = "1"
}

const htmlData = (data) => {
  const date = new Date(parseInt(data.time));

  return `
    <div class="flex-row-container ${data.type}">
      <div class="flex-row-item short-description color-${data.type} wrapper" style="gap: 20px">
        <i class="fa ${Icons[data.type]} color-${data.type}" aria-hidden="true"></i>
        <span><strong>${data.type}</strong></span>
      </div>
      <div class="flex-row-item short-description color-secondary"><strong>${date}</strong></div>
      <div onclick="copyElement(this)" onmouseleave="resetState(this)" onmouseover="over(this)" class="flex-row-item description color-dark">
        <div class="wrapper" style="gap: 10px; cursor: pointer">
          ${htmlMessage(data)}
          <i class="fa fa-files-o" style="opacity:0" aria-hidden="true"></i>
        </div>
      </div>
    </div>
  `
}

const htmlMessage = ({message, type}) => {
  const msg = JSON.parse(message)
  if(type === "exception" && msg.exception) {
    return `<div><span class="color-error">${msg.exception}: </span>${msg.exception_message}</div>`
  }
  return `<span>${message}</span>`
}

consumer.subscriptions.create("LiveLog::LiveLogChannel", {
  async connected() {
    const data = await (await fetch(url)).json()
    liveLogDiv.innerHTML = ''

    data.forEach(elem => {
      liveLogDiv.insertAdjacentHTML("beforeend", htmlData(elem))
    });
  },
  disconnected() {
    liveLogDiv.innerHTML = ''
  },
  received(receivedData) {
    const [data] = receivedData;
    liveLogDiv.insertAdjacentHTML("afterbegin", htmlData(data))
  }
});
