// Once DOM has finished loading (by using 'defer' to reference this script), collect all code block elements
// and dynamically attach buttons to them for copying the code snippet text to the clipboard.
var allCodeElements = document.querySelectorAll("code");
allCodeElements.forEach((codeElement, index, parent) =>
{
	if (!IsFencedCodeBlock(codeElement))
		return;

	AddCopyCodeSnippetButtonToCodeElement(codeElement);
});

function IsFencedCodeBlock(codeElement)
{
	// Inline code snippets have a class name, but code blocks do not.
	return (codeElement.className ? false : true);
}

function AddCopyCodeSnippetButtonToCodeElement(codeElement)
{
	// Grab the Code Element's text before it's DOM is modified by anything, such as the Tooltip.
	// This may not be the most performant way to do this, as it will keep all code snippet text in memory in the
	// anonymous function defined below, but it's definitely the simplest. If we find this causes problems, we can
	// change back to storing only the codeElement.id and dynamically retrieving the contents in the CopyTextToClipboard function.
	var rawTextToCopyToClipboard = codeElement.innerText;
	var textToCopyToClipboard = rawTextToCopyToClipboard.trim();

	var buttonTooltipElement = document.createElement("span");
	buttonTooltipElement.classList = "TooltipText";

	// Instead of using a real button we use an <i> element, as per Font Awesome's instructions: https://fontawesome.com/v3.2.1/examples/
	var buttonElement = document.createElement("i");
	buttonElement.classList = 'CopyCodeSnippetToClipboardButton Tooltip far fa-copy';	// https://fontawesome.com/icons/copy?style=regular
	buttonElement.addEventListener('click',
		function () { CopyTextToClipboardAndUpdateTooltip(textToCopyToClipboard, buttonTooltipElement); });

	// The click event will update the tooltip text, so reset it when the mouse re-enters the button.
	buttonElement.addEventListener('mouseenter',
		function () { buttonTooltipElement.textContent = "Copy code snippet to clipboard" });

	// Add the dynamically created elements to the DOM.
	buttonElement.appendChild(buttonTooltipElement);
	codeElement.prepend(buttonElement);
}

function CopyTextToClipboardAndUpdateTooltip(textToCopyToClipboard, tooltipElement)
{
	navigator.clipboard.writeText(textToCopyToClipboard).then(
		function ()
		{
			tooltipElement.textContent = "Text copied to clipboard"
		},
		function (error)
		{
			console.error('Could not copy text to clipboard.', error);
			tooltipElement.textContent = "Problem occurred copying text to clipboard"
		}
	);
}
