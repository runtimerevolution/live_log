const consumer = ActionCable.createConsumer();

const url = `${window.location.href}/redis-data`;
const liveLogDiv = document.getElementById("live_log_id")

const Icons = {
  error: 'bi bi-exclamation-circle-fill',
  warn: 'bi bi-exclamation-triangle-fill',
  info: 'bi bi-info-circle-fill',
  exception: 'bi bi-x-circle-fill'
}

const copyElement = (e) => {
  navigator.clipboard.writeText(e.querySelector(".message").textContent);
  e.querySelector(".message i").classList.remove("bi-clipboard")
  e.querySelector(".message i").classList.add("bi-clipboard-check")
}

const resetState = (e) => {
  e.querySelector(".message i").classList.remove("bi-clipboard-check")
  e.querySelector(".message i").classList.add("bi-clipboard")
}

const htmlData = (data) => {
  const date = new Date(parseInt(data.time));
  return `
    <tr onclick="copyElement(this)" onmouseleave="resetState(this)" class="element bg-${data.type}">
      <td>
        <div class="tooltip ${data.type}">
          <i class="${Icons[data.type]}"></i>
          <span class="tooltiptext">${data.type.charAt(0).toUpperCase() + data.type.slice(1)}</span>
        </div>
      </td>
      <td class="text-${data.type}">${date.toLocaleTimeString('sv')}</td>
      <td class="message">${data.message} <i class="bi bi-clipboard hide"></i></td>
    </tr>
  `
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
