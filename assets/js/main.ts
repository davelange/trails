import { Socket } from "phoenix";
import { Channel, connect } from "./userSocket";
import { uniqueNamesGenerator, colors, animals } from "unique-names-generator";
import { UserPosition } from "./types";

const self = uniqueNamesGenerator({
  dictionaries: [colors, animals],
  length: 2,
});

let users: UserPosition[] = [];

const onConnect: Channel["onConnect"] = (data) => {
  console.log("we are inside");
  users = data;
};

const onUserUpdate: Channel["onUserUpdate"] = (data) => {
  switch (data.action) {
    case "join":
      users.push({ user_name: data.user_name, position: { x: 0, y: 0 } });
      break;

    case "leave":
      users = users.filter(({ user_name }) => user_name !== data.user_name);
      break;
  }
  console.log(users);
};

const onNewPos: Channel["onNewPos"] = (data) => {
  users = users.map((user) =>
    user.user_name === data.user_name ? data : user
  );

  console.log(users);
};

const { sendNewPos } = connect({
  args: {
    user_name: self,
  },
  onConnect,
  onConnectFail: () => console.log("it broke"),
  onNewPos,
  onUserUpdate,
});

const handleMouseMove = (event: MouseEvent) => {
  const { clientX, clientY } = event;

  sendNewPos({
    x: clientX,
    y: clientY,
  });
};

document.addEventListener("click", handleMouseMove);
