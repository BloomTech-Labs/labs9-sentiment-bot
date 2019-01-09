import React from 'react';
import "./Avatar.css"

const Avatar = props => {
    return (
        <img src={props.imageSrc} alt="avatar"></img>
    )
}

export default Avatar;