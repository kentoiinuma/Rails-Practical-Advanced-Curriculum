document.addEventListener("DOMContentLoaded", function() {
    const picker = document.querySelector(".your-date-time-picker-class");
    if (picker) {
      const minutePicker = picker.querySelector(".minute-class"); // このクラス名は、実際のHTMLに依存します。
      if (minutePicker) {
        minutePicker.style.display = "none";
      }
    }
  });
  