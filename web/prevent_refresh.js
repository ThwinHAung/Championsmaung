window.addEventListener('beforeunload', function (e) {
    // Customize the message here
    const message = 'You have unsaved changes. Are you sure you want to leave?';
  
    // Standardize the message across different browsers
    e.preventDefault();
    e.returnValue = message;
  
    return message; // For older browsers
  });
  