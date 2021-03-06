const Messages = {
    OPENWEBM: 0
};

function handleClick(event) {
    const url = event.target.src;
    if (url !== "") {
        if (url !== undefined && event.target.nodeName === "VIDEO") {
            extension = url.split('.').pop().toLowerCase();
            if (extension.substring(0,4) === "webm") {
                safari.extension.dispatchMessage(Messages.OPENWEBM, { url: url });
            }
        }
    } else {
        if (event.target.nodeName === "VIDEO"){
            let sourceCount = 0;
            let url;
            for (i = 0; i < event.target.childNodes.length; i++) {
                if (event.target.childNodes[i].nodeName === "SOURCE") {
                    sourceCount += 1;
                    extension = event.target.childNodes[i].src.split('.').pop().toLowerCase();
                    if (extension.substring(0,4) === "webm") {
                        url = event.target.childNodes[i].src;
                    }
                }
            }
            if (url !== undefined && sourceCount === 1) {
                safari.extension.dispatchMessage(Messages.OPENWEBM, { url: url });
            }
        }
    }
}

function handleContextMenu(event) {
    var target = event.target;
    while (target != null && target.nodeType == Node.ELEMENT_NODE && target.nodeName.toLowerCase() != "a") {
        target = target.parentNode;
    }
    safari.extension.setContextMenuEventUserInfo(event, { "url": target.href });
}

document.addEventListener("click", handleClick, false);
document.addEventListener("contextmenu", handleContextMenu, false);
