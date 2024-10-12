import { Socket } from "phoenix";

// And connect to the path in "lib/trails_web/endpoint.ex". We pass the
// token for authentication. Read below how it should be used.
let socket = new Socket("/socket", {
  params: { token: (window as any)?.userToken || "" },
});

socket.connect();

type Position = {
  x: number;
  y: number;
};

export function connect() {
  let channel = socket.channel("trails:main");
  channel
    .join()
    .receive("ok", (resp) => {
      console.log("Joined", resp);
    })
    .receive("error", (resp) => {
      console.log("Unable to join", resp);
    });

  const sendNewPos = (data: Position) => channel.push("new_pos", data);

  return { sendNewPos };
}
