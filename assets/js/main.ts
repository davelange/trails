import { connect } from "./userSocket";
import { uniqueNamesGenerator, colors, animals } from "unique-names-generator";

const name = uniqueNamesGenerator({
  dictionaries: [colors, animals],
  length: 2,
});

const { sendNewPos } = connect({
  user_name: name,
});

const handleMouseMove = (event: MouseEvent) => {
  const { clientX, clientY } = event;

  sendNewPos({
    x: clientX,
    y: clientY,
  });
};

document.addEventListener("click", handleMouseMove);
