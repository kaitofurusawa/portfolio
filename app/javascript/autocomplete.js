document.addEventListener('turbo:load', () => {
  const input = document.getElementById('board-search-input');
  const list = document.getElementById('autocomplete-list');
  if (!input || !list) return;

  let timer = null;

  input.addEventListener('input', function() {
    clearTimeout(timer);
    const query = this.value.trim();
    if (query.length < 1) {
      list.innerHTML = '';
      return;
    }

    timer = setTimeout(() => {
      fetch(`/boards/autocomplete?term=${encodeURIComponent(query)}`)
        .then(response => {
          if (!response.ok) throw new Error("Network response was not ok");
          return response.json();
        })
        .then(data => {
          list.innerHTML = '';
          if (!Array.isArray(data) || data.length === 0) {
            return;
          }
          data.forEach(item => {
            const li = document.createElement('li');
            li.textContent = item;
            li.style.cursor = 'pointer';
            li.style.padding = '0.5em';
            li.addEventListener('mousedown', function(e) {
              input.value = this.textContent;
              list.innerHTML = '';
            });
            list.appendChild(li);
          });
        })
        .catch(error => {
          list.innerHTML = '';
        });
    }, 200);
  });

  input.addEventListener('blur', () => {
    setTimeout(() => {
      list.innerHTML = '';
    }, 100);
  });

  if (input.form) {
    input.form.addEventListener('submit', () => {
      list.innerHTML = '';
    });
  }
});
