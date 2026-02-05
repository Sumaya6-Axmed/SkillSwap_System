// src/utils/points.js
const BADGES = [
  { name: "Rookie Tutor", points: 50 },
  { name: "Skilled Tutor", points: 150 },
  { name: "Top Tutor", points: 300 }
];

const evaluateBadges = (user) => {
  const newBadges = [];

  BADGES.forEach((badge) => {
    if (
      user.points >= badge.points &&
      !user.badges.includes(badge.name)
    ) {
      newBadges.push(badge.name);
    }
  });

  return newBadges;
};

module.exports = {
  evaluateBadges
};
