const style = document.createElement('style');
document.head.appendChild(style);

const searchField = document.getElementById('search')

searchField.addEventListener('keyup', (event) => {
  console.log('searching');
  const query = searchField.value.toLowerCase();
  const terms = query.split(' ').filter(term => term.length > 0);
  style.textContent = terms.map(term => `figure:not([data-name*='${term}'])`).join(', ') + ' { display: none; }';
})
