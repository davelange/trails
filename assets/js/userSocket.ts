import { Channel, Socket, Push } from "phoenix";

// And connect to the path in "lib/trails_web/endpoint.ex". We pass the
// token for authentication. Read below how it should be used.
let socket = new Socket("/socket", {
  params: { token: (window as any)?.userToken || "" },
});

socket.connect();

export type Position = {
  x: number;
  y: number;
};

type OnJoin = (args: { channel: Channel }) => void;

export function connect({ onJoin, name }: { onJoin: OnJoin; name: string }) {
  let channel = socket.channel("trails:main", { name });
  channel
    .join()
    .receive("ok", (resp) => {
      console.log("Joined", resp);
      onJoin({ channel });
    })
    .receive("error", (resp) => {
      console.log("Unable to join", resp);
    });
}
