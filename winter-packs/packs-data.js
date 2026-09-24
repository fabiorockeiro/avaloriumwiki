/* Edite somente este arquivo para atualizar preços, créditos e recompensas. */
window.AvaloriumPacksData = {
  donateUrl: 'https://avaloriumot.com/index.php/account/manage?redirect=https%3A%2F%2Favaloriumot.com%2Findex.php%2Fstore',
  items: {
    roulette: { name: 'Roulette Token', icon: 'roulette-token.gif' },
    mystic: { name: 'Mystic Exercise', icon: 'mystic-exercise.gif' },
    legend: { name: 'Legend Exercise', icon: 'legend-exercise.gif' },
    bronze: { name: 'Bronze EXP Scroll', icon: 'bronze-exp-scroll.gif' },
    silver: { name: 'Silver EXP Scroll', icon: 'silver-exp-scroll.gif' },
    gold: { name: 'Gold EXP Scroll', icon: 'gold-exp-scroll.gif' },
    crystal: { name: 'Crystal EXP Scroll', icon: 'crystal-exp-scroll.gif' },
    prey: { name: 'Prey Wildcards', icon: 'prey-wildcards.gif', idleMotion: true },
    mysterious: { name: 'Mysterious Bag', icon: 'mysterious-bag.gif' },
    outfit: { name: 'Outfit + Mount', icon: 'outfit-box.gif', extraIcon: 'mount-box.gif' },
    stone: { name: 'Stone Bag Nível 1', icon: 'stone-bag-1.gif' },
    task: { name: 'Double Task', icon: 'double-task.gif' },
    drome: { name: 'Drome Cube', icon: 'drome-cube.gif', idleMotion: true },
    tier: { name: 'Tier Transfer', icon: 'tier-transfer.gif' },
    lucky: { name: 'Lucky Bag', icon: 'lucky-bag.gif' },
    materials: { name: 'Bag of Materials', icon: 'bag-of-materials.gif', removeWhite: true }
  },
  packs: [
    { id: 'bronze', name: 'BRONZE', price: 50, tc: 375, color: '#e4a36e', rewards: [['roulette',1],['mystic',1],['bronze',2],['prey',5],['mysterious',2]] },
    { id: 'prata', name: 'PRATA', price: 100, tc: 900, color: '#c0d6e9', rewards: [['roulette',2],['mystic',2],['silver',2],['prey',10],['mysterious',4],['outfit',1],['stone',1],['task',1],['drome',1]] },
    { id: 'ouro', name: 'OURO', price: 200, tc: 2100, color: '#f1ce74', rewards: [['roulette',4],['mystic',3],['silver',3],['prey',20],['mysterious',8],['outfit',2],['tier',1],['stone',2],['task',1],['drome',2]] },
    { id: 'platina', name: 'PLATINA', price: 500, tc: 6000, color: '#71dded', rewards: [['roulette',10],['legend',2],['gold',4],['prey',50],['mysterious',20],['outfit',5],['tier',2],['stone',5],['lucky',1],['task',2],['drome',4],['materials',2]] },
    { id: 'diamante', name: 'DIAMANTE', price: 700, tc: 9450, color: '#bd9cff', rewards: [['roulette',14],['legend',3],['crystal',3],['prey',60],['mysterious',28],['outfit',7],['tier',2],['stone',7],['lucky',3],['task',2],['drome',8],['materials',4]] },
    { id: 'rubi', name: 'RUBI', price: 1000, tc: 15000, color: '#ff8296', featured: true, rewards: [['roulette',20],['legend',4],['crystal',5],['prey',80],['mysterious',40],['outfit',10],['tier',3],['stone',14],['lucky',5],['task',3],['drome',16],['materials',8]] }
  ]
};
