import { Socket } from "phoenix";
import { connect } from "./userSocket";

console.log("loaded");

const { sendNewPos } = connect({
  onConnect: () => console.log("we are inside"),
  onConnectFail: () => console.log("it broke"),
  onNewPos: (data) => console.log(data),
});

const handleMouseMove = (event: MouseEvent) => {
  const { clientX, clientY } = event;

  sendNewPos({
    x: clientX,
    y: clientY,
  });
};

const mousemoveListener = document.addEventListener("click", handleMouseMove);
