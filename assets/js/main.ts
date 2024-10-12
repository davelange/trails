import { connect } from "./userSocket";

const { sendNewPos } = connect();

const handleMouseMove = (event: MouseEvent) => {
  const { clientX, clientY } = event;

  sendNewPos({
    x: clientX,
    y: clientY,
  });
};

document.addEventListener("mousemove", handleMouseMove);
