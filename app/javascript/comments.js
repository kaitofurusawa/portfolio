document.addEventListener("turbo:submit-end", (event) => {
  if (event.target.id === "new_comment_form" && event.detail.success) {
    event.target.reset();
  }
});

document.addEventListener("turbo:before-fetch-request", (event) => {
  if (event.target.id === "new_comment_form") {
    const errorMessages = event.target.querySelectorAll(".error-message");
    errorMessages.forEach((message) => {
      message.style.display = "none";
    });
  }
});
