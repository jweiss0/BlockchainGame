import React from "react";

const Footer = () => (
    <div className="footer">
        <div className="footerContainer">
            <p className="footerText">Made during our time at</p>
            <a url="https://github.com/rcos/CSCI-4470-OpenSource">CSCI-4470-OpenSource</a>
            <a url="https://github.com/jweiss0/OSS-CryptoCasino" className="footerImg">
                <img src="./githubIcon.png" alt="Github Icon" height="30px" width="30px"></img>
            </a>
        </div>
    </div>
);

export default Footer;