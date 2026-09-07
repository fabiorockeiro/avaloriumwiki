(() => {
    const triggers = document.querySelectorAll('[data-raid-zoom]');
    if (!triggers.length) return;
    const dialog = document.createElement('dialog');
    dialog.className = 'raid-zoom';
    dialog.setAttribute('aria-labelledby', 'raid-zoom-title');
    dialog.innerHTML = '<div class="raid-zoom-head"><p id="raid-zoom-title"></p><button class="raid-zoom-close" type="button">Fechar ×</button></div><div class="raid-zoom-body"></div>';
    document.body.append(dialog);
    let previousOverflow = '';
    triggers.forEach(trigger => trigger.addEventListener('click', () => {
        const crop = document.createElement('div');
        crop.className = trigger.className;
        crop.style.cssText = trigger.style.cssText;
        const img = trigger.querySelector('img').cloneNode();
        img.loading = 'eager';
        crop.append(img);
        dialog.querySelector('#raid-zoom-title').textContent = img.alt;
        dialog.querySelector('.raid-zoom-body').replaceChildren(crop);
        previousOverflow = document.body.style.overflow;
        document.body.style.overflow = 'hidden';
        dialog.showModal();
    }));
    dialog.querySelector('.raid-zoom-close').addEventListener('click', () => dialog.close());
    dialog.addEventListener('click', event => {
        const rect = dialog.getBoundingClientRect();
        if (event.target === dialog && (event.clientX < rect.left || event.clientX > rect.right || event.clientY < rect.top || event.clientY > rect.bottom)) dialog.close();
    });
    dialog.addEventListener('close', () => { document.body.style.overflow = previousOverflow; });
})();
