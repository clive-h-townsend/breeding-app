import styled from 'styled-components';



const LargeAvatar = styled.img`
    border-radius: 50%;
    width: 150px;

`

const ImageUploadDiv = styled.div`

    height: '100vh';
    display: 'flex';
    flexDirection: 'column';
    alignItems: 'center';
    justifyContent: 'center';

`

const UploadImage = styled.img`

    height:300px;
    width: 400px;

`

const PostImage = styled.img`

    display: block;
    margin-left: auto;
    margin-right: auto;
    max-width: 70%;
    height: auto;

`

export {LargeAvatar, ImageUploadDiv, UploadImage, PostImage};