import "bootstrap";
import { autocomplete } from '../components/autocomplete';
autocomplete();

const clBtn = document.getElementById('user_photo')
if (clBtn) {
  const loader = document.getElementById('photo-loader')
  loader.addEventListener('click', (e) => {
    e.preventDefault()
    clBtn.click()
  })
}
