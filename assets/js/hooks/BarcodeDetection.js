import Quagga from "quagga";

export default {
  mounted() {
    const hook = this;
    const scannerButton = hook.el;
    const scannerElem = document.querySelector('#scanner');

    scannerButton.addEventListener("click", () => {
      const isbnInput = document.querySelector('#isbn-input');
      scannerButton.innerHTML = "Loading...";

      Quagga.init({
        inputStream: {
          name: "Live",
          type: "LiveStream",
          target: scannerElem
        },
        decoder: {
          readers: ["ean_reader"]
        }
      }, function (err) {
        if (err) {
          console.log(err);
          scannerElem.removeAttribute("hidden");
          scannerElem.innerHTML = err;
          return
        }

        scannerButton.innerHTML = "Scan";
        scannerElem.removeAttribute("hidden");
        Quagga.start();
        Quagga.onDetected((result) => {
          // console.log(result.codeResult.code);
          isbnInput.value = result.codeResult.code;
          scannerElem.setAttribute("hidden", "true");
          Quagga.stop();
        });
      });
    });
  }
};