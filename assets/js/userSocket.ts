import { Socket } from "phoenix";

// And connect to the path in "lib/trails_web/endpoint.ex". We pass the
// token for authentication. Read below how it should be used.
let socket = new Socket("/socket", {
  params: { token: (window as any)?.userToken || "" },
});

socket.connect();

type NewPositionData = {
  x: number;
  y: number;
};

type Channel = {
  onConnect: () => void;
  onConnectFail: () => void;
  onNewPos: (data: NewPositionData) => void;
};

export function connect({ onConnect, onConnectFail, onNewPos }: Channel) {
  let channel = socket.channel("trails:lobby", {});
  channel
    .join()
    .receive("ok", (resp) => {
      console.log("Joined successfully", resp);
      onConnect();
    })
    .receive("error", (resp) => {
      console.log("Unable to join", resp);
      onConnectFail();
    });

  channel.on("new_pos", onNewPos);

  const sendNewPos = (data: NewPositionData) => channel.push("new_pos", data);

  return { sendNewPos };
}
