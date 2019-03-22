import styled from 'styled-components';



const Standard = styled.input`

    color: black;
    width: 50%;
    text-align: center;
    font-size: 2em;
    margin: 15px;
    border-width: 3px;
    border-style: solid;
    border-radius: 15px;

`

const General = styled.textarea`

    color: black;
    width:50%
    height:10em;


`

const Paragraph = styled.textarea`

    color: red;
    width: 60%;
    height: 10em;

`

const Code = styled.textarea`

    color: blue;
    font-family: "Courier New";
    width: 50%;
    height: 3em;
    

`

export {Standard, Paragraph, Code, General};