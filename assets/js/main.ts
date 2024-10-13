import { connect, Position, User } from "./userSocket";
import confetti from "canvas-confetti";

let selfElement: HTMLElement;

function throttle<T>(fn: (args: T) => void, interval = 200) {
  let enabled = true;

  return (data: T) => {
    if (enabled) {
      enabled = false;
      fn(data);
      setTimeout(() => (enabled = true), interval);
    }
  };
}

function updateLocalPosition({ x, y }: Position) {
  if (selfElement) {
    selfElement.style.left = `${x}px`;
    selfElement.style.top = `${y}px`;
  } else {
    selfElement = document.querySelector("[data-self]") as HTMLElement;
  }
}

function onMount(user: User) {
  connect({
    user,
    onJoin({ channel }) {
      const throttledSend = throttle((data: Position) =>
        channel.push("new_pos", data)
      );

      const handleMouseMove = (event: MouseEvent) => {
        const { clientX: x, clientY: y } = event;
        updateLocalPosition({ x, y });
        throttledSend({ x, y });
      };

      const handleClick = (event: MouseEvent) => {
        channel.push("confetti", {
          x: event.clientX / window.innerWidth,
          y: event.clientY / window.innerHeight,
        });
      };

      channel.on("confetti", (position) => {
        confetti({
          origin: position,
        });
      });

      document.addEventListener("mousemove", handleMouseMove);
      document.addEventListener("click", handleClick);
    },
  });
}

window.addEventListener("phx:mount", (event: unknown) => {
  onMount((event as any).detail);
});
