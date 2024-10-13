import { connect, Position, User } from "./userSocket";
import confetti from "canvas-confetti";

let selfElement: HTMLElement;

function throttle<T>(fn: (args: T) => void, interval = 500) {
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
    selfElement.style.left = `${x}%`;
    selfElement.style.top = `${y}%`;
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
        const x = (event.clientX / window.innerWidth) * 100;
        const y = (event.clientY / window.innerHeight) * 100;
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
