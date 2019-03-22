import styled from 'styled-components';

const standardPadding = '2em';

const Paragraph = styled.div`

    color: blue;
    white-space: pre-line;
    border-radius: 3px;
    display: block;
    background: white;
    // &:hover {
    //     background: black;
    //     color: white;
    // }
    padding: ${standardPadding};
    

`

const Code = styled.div`

    white-space: pre-line;
    background:black;
    // &:hover {
    //     background: #130054;
    //     color: white;
    // }  
    font-family: "Courier New", Courier, monospace;
    font-size: 20px;
    letter-spacing: 0px;
    word-spacing: 0px;
    color: #FFFFFF;
    font-weight: normal;
    text-decoration: none;
    font-style: normal;
    font-variant: normal;
    text-transform: uppercase;

    padding: ${standardPadding};

`

export {Paragraph, Code};