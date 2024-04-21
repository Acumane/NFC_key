const express = require('express');
const bodyParser = require('body-parser');

const app = express();
app.use(bodyParser.json());

app.post('/api/nfc', (req, res) => {
    const nfcId = req.body.nfc_id;
    console.log('Received NFC ID:', nfcId);

    // Implement your verification logic here
    // For demonstration, we assume the NFC ID is valid if it's not empty
    if (nfcId && nfcId.length > 0) {
        res.status(200).send('User verified successfully!');
    } else {
        res.status(401).send('Verification failed!');
    }
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
    console.log(`Server running on port ${PORT}`);
});
