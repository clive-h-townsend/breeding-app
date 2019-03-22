import styled from 'styled-components';
import {Link} from 'react-router-dom'


const NavBar = styled.nav`
  background-color: black;
  padding: 1%;
  

`

const HeaderLink = styled(Link)`
  background-color: grey;
  color: white;
  padding: 14px 25px;
  text-align: center; 
  text-decoration: none;
  display: inline-block;
  :hover {
    color: blue;
    background-color: #e6e6e6;
  }
`

const LogoutButton = styled.button`

  background-color: grey;
  border:none;
  color: white;
  font-size: 1em;
  padding: 14px 25px;
  text-align: center; 
  text-decoration: none;
  :hover {
    color: red;
    background-color: #e6e6e6;
  }
`

export {HeaderLink, LogoutButton, NavBar};