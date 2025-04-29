self.onmessage = function (event) {
    const number = event.data;
    const result = [];

    let factorial = 1;
    for (let i = 1; i <= number; i++) {
        factorial *= i;
        result.push({ number: i, factorial: factorial });
    }

    postMessage(result);
};
