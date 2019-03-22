import ReactGA from 'react-ga';


const GoogleAnalytics = (page) => {
    ReactGA.initialize('UA-');
    ReactGA.pageview('/' + page);
  };

  export {GoogleAnalytics};
