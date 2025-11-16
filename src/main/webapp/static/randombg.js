function setRandomBackground() {
    fetch('/web-lab2/api/random-background')
        .then(response => {
            if (!response.ok) {
                throw new Error('Failed to get background');
            }
            return response.text();
        })
        .then(bgPath => {
            if (bgPath && bgPath.trim() !== '') {
                document.body.style.backgroundImage = 'url(' + bgPath + ')';
            } else {
                console.warn('No background image received');
            }
        })
        .catch(error => {
            console.error('Error setting background:', error);
            // Fallback background if needed
            document.body.style.backgroundColor = '#f0f0f0';
        });
}

setRandomBackground();