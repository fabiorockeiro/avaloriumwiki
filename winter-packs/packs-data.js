/* Valores e recompensas dos Pacotes Avalorium Halloween. */
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
    prey: { name: 'Prey Cards', icon: 'prey-wildcards.gif', idleMotion: true },
    mysterious: { name: 'Mysterious Bag', icon: 'mysterious-bag.gif' },
    outfit: { name: 'Outfit + Mount', icon: 'outfit-box.gif', extraIcon: 'mount-box.gif' },
    reroll: { name: 'Task Reroll', icon: 'task-reroll.gif' },
    stone: { name: 'Stone Bag Nível 2', icon: 'stone-bag-2.gif' },
    stone3: { name: 'Stone Bag Nível 3', icon: 'stone-bag-3.gif' },
    lucky: { name: 'Lucky Bag', icon: 'lucky-bag.gif' },
    task: { name: 'Double Task', icon: 'double-task.gif' },
    drome: { name: 'Drome Cube', icon: 'drome-cube.gif', idleMotion: true },
    materials: { name: 'Bag of Materials', icon: 'bag-of-materials.gif', removeWhite: true },
    goldenRaid: { name: 'Golden Raid Token', icon: 'golden-raid-token.gif' }
  },
  packs: [
    { id: 'bronze', name: 'BRONZE', price: 50, tc: 450, color: '#e4a36e', rewards: [['roulette',1],['mystic',2],['bronze',4],['prey',5],['mysterious',2],['outfit',1],['reroll',1],['stone',1],['task',1],['drome',1],['goldenRaid',4]] },
    { id: 'prata', name: 'PRATA', price: 100, tc: 1100, color: '#c0d6e9', rewards: [['roulette',2],['mystic',4],['silver',4],['prey',10],['mysterious',4],['outfit',2],['reroll',2],['stone',2],['lucky',1],['task',2],['drome',2],['materials',4],['goldenRaid',8]] },
    { id: 'ouro', name: 'OURO', price: 200, tc: 2600, color: '#f1ce74', rewards: [['roulette',4],['mystic',6],['silver',6],['prey',20],['mysterious',8],['outfit',5],['reroll',5],['stone',4],['lucky',3],['task',5],['drome',4],['materials',8],['goldenRaid',10]] },
    { id: 'platina', name: 'PLATINA', price: 500, tc: 7500, color: '#71dded', rewards: [['roulette',10],['legend',4],['gold',8],['prey',50],['mysterious',20],['outfit',7],['reroll',7],['stone',6],['lucky',5],['task',7],['drome',8],['materials',10],['goldenRaid',20]] },
    { id: 'diamante', name: 'DIAMANTE', price: 700, tc: 12000, color: '#bd9cff', rewards: [['roulette',14],['legend',6],['crystal',6],['prey',60],['mysterious',28],['outfit',10],['reroll',10],['stone',8],['lucky',7],['task',10],['drome',16],['materials',12],['goldenRaid',24]] },
    { id: 'rubi', name: 'RUBI', price: 1000, tc: 19000, color: '#ff8296', featured: true, rewards: [['roulette',28],['legend',10],['crystal',10],['prey',100],['mysterious',40],['outfit',20],['reroll',15],['stone3',10],['lucky',14],['task',15],['drome',22],['materials',18],['goldenRaid',48]] }
  ]
};
