import { Socket } from "phoenix";
import { OnJoinData, Position, UserPosition, UserUpdate } from "./types";

// And connect to the path in "lib/trails_web/endpoint.ex". We pass the
// token for authentication. Read below how it should be used.
let socket = new Socket("/socket", {
  params: { token: (window as any)?.userToken || "" },
});

socket.connect();

export type Channel = {
  args: { user_name: string };
  onConnect: (data: OnJoinData) => void;
  onConnectFail: () => void;
  onNewPos: (data: UserPosition) => void;
  onUserUpdate: (data: UserUpdate) => void;
};

export function connect({
  args,
  onConnect,
  onConnectFail,
  onNewPos,
  onUserUpdate,
}: Channel) {
  let channel = socket.channel("trails:lobby", args);
  channel
    .join()
    .receive("ok", (resp) => {
      onConnect(resp);
    })
    .receive("error", (resp) => {
      console.log("Unable to join", resp);
      onConnectFail();
    });

  channel.on("new_pos", onNewPos);
  channel.on("user_update", onUserUpdate);

  const sendNewPos = (data: Position) => channel.push("new_pos", data);

  return { sendNewPos };
}
