document.querySelectorAll("a.no-nav").forEach(function(link) {
  link.addEventListener("click", function(event) {
    event.preventDefault();
  });
});

document.querySelectorAll(".countup").forEach(function(el) {
  var target = parseFloat(el.dataset.target || "0");
  var prefix = el.dataset.prefix || "";
  var suffix = el.dataset.suffix || "";
  var decimals = parseInt(el.dataset.decimals || (Number.isInteger(target) ? "0" : "1"), 10);
  var duration = 900;
  var startTime = null;

  function render(value) {
    el.textContent = prefix + value.toFixed(decimals) + suffix;
  }

  function step(timestamp) {
    if (!startTime) startTime = timestamp;
    var progress = Math.min((timestamp - startTime) / duration, 1);
    var current = target * progress;
    render(current);
    if (progress < 1) {
      window.requestAnimationFrame(step);
    } else {
      render(target);
    }
  }

  window.requestAnimationFrame(step);
});
