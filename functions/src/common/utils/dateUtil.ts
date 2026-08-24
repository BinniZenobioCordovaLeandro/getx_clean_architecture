export const hoursBetweenDates = (from: Date, to: Date): number => {
  const timeDifference = Math.abs(to.getTime() - from.getTime());
  return Math.ceil(timeDifference / (1000 * 3600));
};

export const daysBetweenDates = (from: Date, to: Date): number => {
  const hours = hoursBetweenDates(from, to);
  return hours * 24;
};

