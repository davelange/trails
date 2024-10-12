import { connect, Position } from "./userSocket";

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

window.addEventListener("phx:mount", (event: unknown) => {
  const name = (event as any).detail.name;

  connect({
    name,
    onJoin({ channel }) {
      const throttledSend = throttle((data: Position) =>
        channel.push("new_pos", data)
      );

      const handleMouseMove = (event: MouseEvent) => {
        const { clientX: x, clientY: y } = event;
        updateLocalPosition({ x, y });
        throttledSend({ x, y });
      };

      document.addEventListener("mousemove", handleMouseMove);
    },
  });
});
