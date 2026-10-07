(() => {

		const categories = {
			arrows: {
				label: "flechas ou bolts",
				cost: "8kk",
				items: [8000, 9200, 10000, 11200, 12000],
				hourOff: [720, 920, 1091, 1344, 1600],
				hourOn: [960, 1274, 1565, 2016, 2160]
			},
			runes: {
				label: "runas",
				cost: "6kk",
				items: [6000, 6900, 7500, 8400, 9000],
				hourOff: [540, 690, 818, 1008, 1200],
				hourOn: [720, 955, 1174, 1512, 1620]
			},
			potions: {
				label: "poções",
				cost: "6kk",
				items: [3000, 3450, 3750, 4200, 4500],
				hourOff: [270, 345, 409, 504, 600],
				hourOn: [360, 478, 587, 756, 810]
			}
		};

		const tiers = [
			{ id: "T1", name: "Iniciante", timeOff: "11h 6min", timeOn: "8h 20min" },
			{ id: "T2", name: "Aprendiz", timeOff: "10h", timeOn: "7h 13min" },
			{ id: "T3", name: "Especialista", timeOff: "9h 10min", timeOn: "6h 23min" },
			{ id: "T4", name: "Mestre Encantador", timeOff: "8h 20min", timeOn: "5h 33min" },
			{ id: "T5", name: "Grão-Mestre Encantador", timeOff: "7h 30min", timeOn: "5h 33min" }
		];

		const fmt = new Intl.NumberFormat("pt-BR");
		let cat = "arrows";
		let shop = false;

		function render() {
			const data = categories[cat];
			const hours = shop ? data.hourOn : data.hourOff;
			document.getElementById("rows").innerHTML = tiers.map(function (tier, index) {
				const time = shop ? tier.timeOn : tier.timeOff;
				return "<tr class=\"" + (tier.id === "T5" ? "top" : "") + "\">" +
					"<td><span class=\"badge\">" + tier.id + "</span></td>" +
					"<td class=\"grau\">" + tier.name + "</td>" +
					"<td class=\"items\">" + fmt.format(data.items[index]) + "</td>" +
					"<td class=\"time\">" + time + "</td>" +
					"<td class=\"hour\">" + fmt.format(hours[index]) + "</td>" +
					"</tr>";
			}).join("");

			const mode = shop ? "com oficina completa" : "sem oficina extra";
			document.getElementById("summary").innerHTML =
				"No <strong>T1</strong>, um pedido cheio entrega <strong>" + fmt.format(data.items[0]) +
				" " + data.label + "</strong> em <strong>" + (shop ? tiers[0].timeOn : tiers[0].timeOff) +
				"</strong>. No <strong>T5</strong>, o mesmo pedido entrega <strong>" + fmt.format(data.items[4]) +
				"</strong> em <strong>" + (shop ? tiers[4].timeOn : tiers[4].timeOff) + "</strong> (" + mode + ").";

			document.getElementById("meta").innerHTML =
				"<span>Custo deste pedido: <b>" + data.cost + "</b> em gold. Não precisa ter refill na mochila.</span>" +
				"<span>Por hora é a média com o hireling produzindo sem parar.</span>";
		}

		document.querySelectorAll("[data-cat]").forEach(function (button) {
			button.addEventListener("click", function () {
				cat = button.getAttribute("data-cat");
				document.querySelectorAll("[data-cat]").forEach(function (other) {
					other.setAttribute("aria-pressed", other === button ? "true" : "false");
				});
				render();
			});
		});

		document.querySelectorAll("[data-shop]").forEach(function (button) {
			button.addEventListener("click", function () {
				shop = button.getAttribute("data-shop") === "on";
				document.querySelectorAll("[data-shop]").forEach(function (other) {
					other.setAttribute("aria-pressed", other === button ? "true" : "false");
				});
				render();
			});
		});

		render();
	
})();
