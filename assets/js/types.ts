export type Position = {
  x: number;
  y: number;
};

export type UserUpdate = {
  action: "leave" | "join";
  user_name: string;
};

export type UserPosition = {
  position: Position;
  user_name: string;
};

export type OnJoinData = UserPosition[];
