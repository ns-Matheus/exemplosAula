shiftPressed = false;
  
$(document).ready(function() {
	document.onkeydown = data => {
		const key = data.key;
		if (key === "Shift") {
			shiftPressed = true;
		}
	}

	document.onkeyup = data => {
		const key = data.key;
		if (key === "Escape"){
			$.post("http://monkey_homes_v2/chestClose");

		} else if (key === "Shift") {
			shiftPressed = false;
		}
	}

	var ctrlDown = false,
		ctrlKey = 17,
		cmdKey = 91,
		vKey = 86,
		cKey = 67;

	$(document).keydown(function(e) {
		if (e.keyCode == ctrlKey || e.keyCode == cmdKey) ctrlDown = true;
	}).keyup(function(e) {
		if (e.keyCode == ctrlKey || e.keyCode == cmdKey) ctrlDown = false;
	});

	$(".amount").keydown(function(e) {
		if (ctrlDown && (e.keyCode == vKey || e.keyCode == cKey)) return false;
	});
});

function updateDrag() {
	$('.populated').draggable({
		helper: 'clone'
	});

	$('.empty').droppable({
		hoverClass: 'hoverControl',
		drop: function(event,ui){
			if(ui.draggable.parent()[0] == undefined) return;

			const shiftPressed = event.shiftKey;
			const origin = ui.draggable.parent()[0].classList[0];
			if (origin === undefined) return;
			const tInv = $(this).parent()[0].classList[0];
			
			itemData = { key: ui.draggable.data('item-key'), slot: ui.draggable.data('slot') };
			const target = $(this).data('slot');

			if (itemData.key === undefined || target === undefined) return;

			let amount = 0;
			let itemAmount = parseInt(ui.draggable.data('amount'));

			if (shiftPressed)
				amount = itemAmount;
			else if($(".amount").val() == "" | parseInt($(".amount").val()) <= 0)
				amount = 1;
			else
				amount = parseInt($(".amount").val());

			if(amount > itemAmount)
				amount = itemAmount;

			$('.populated, .empty').off("draggable droppable");

			let clone1 = ui.draggable.clone();
			let slot2 = $(this).data("slot"); 

			if(amount == itemAmount){
				let clone2 = $(this).clone();
				let slot1 = ui.draggable.data("slot");

				$(this).replaceWith(clone1);
				ui.draggable.replaceWith(clone2);
				
				$(clone1).data("slot", slot2);
				$(clone2).data("slot", slot1);
			} else {
				let newAmountOldItem = itemAmount - amount;
				let weight = parseFloat(ui.draggable.data("peso"));
				let newWeightClone1 = (amount*weight).toFixed(2);
				let newWeightOldItem = (newAmountOldItem*weight).toFixed(2);

				ui.draggable.data("amount",newAmountOldItem);

				clone1.data("amount",amount);

				$(this).replaceWith(clone1);
				$(clone1).data("slot",slot2);

				ui.draggable.children(".top").children(".itemAmount").html(formatarNumero(ui.draggable.data("amount")) + "x");
				ui.draggable.children(".top").children(".itemWeight").html(newWeightOldItem);
				
				$(clone1).children(".top").children(".itemAmount").html(formatarNumero(clone1.data("amount")) + "x");
				$(clone1).children(".top").children(".itemWeight").html(newWeightClone1);
			}

			updateDrag()

			if (tInv == "invLeft") {
				if (origin == "invLeft") {
					$.post("http://monkey_homes_v2/populateSlot", JSON.stringify({
						item: itemData.key,
						slot: itemData.slot,
						target: target,
						amount: parseInt(amount)
					}))

					$('.amount').val("");
				} else if (origin == "invRight") {
					$.post("http://monkey_homes_v2/takeItem", JSON.stringify({
						item: itemData.key,
						slot: target,
						amount: parseInt(amount)
					}));

					$('.amount').val("");
				}
			} else if (tInv == "invRight") {
				if (origin == "invLeft") {
					$.post("http://monkey_homes_v2/storeItem", JSON.stringify({
						item: itemData.key,
						slot: itemData.slot,
						amount: parseInt(amount)
					}));

					$('.amount').val("");
				} else if (origin == "invRight") {
					updateChest()
				}
			}
		}
	});

	$('.populated').droppable({
		hoverClass: 'hoverControl',
		drop: function(event,ui){
			if(ui.draggable.parent()[0] == undefined) return;

			const shiftPressed = event.shiftKey;
			const origin = ui.draggable.parent()[0].classList[0];
			if (origin == undefined) return;
			const tInv = $(this).parent()[0].classList[0];

			itemData = { key: ui.draggable.data('item-key'), slot: ui.draggable.data('slot') };
			const target = $(this).data('slot');

			if (itemData.key === undefined || target === undefined) return;

			let amount = 0;
			let itemAmount = parseInt(ui.draggable.data('amount'));

			if (shiftPressed)
				amount = itemAmount;
			else if($(".amount").val() == "" | parseInt($(".amount").val()) <= 0)
				amount = 1;
			else
				amount = parseInt($(".amount").val());

			if(amount > itemAmount)
				amount = itemAmount;

			$('.populated, .empty, .use').off("draggable droppable");

			if(ui.draggable.data('item-key') == $(this).data('item-key')){
				let newSlotAmount = amount + parseInt($(this).data('amount'));
				let newSlotWeight = ui.draggable.data("peso") * newSlotAmount;

				$(this).data('amount',newSlotAmount);
				$(this).children(".top").children(".itemAmount").html(formatarNumero(newSlotAmount) + "x");
				$(this).children(".top").children(".itemWeight").html(newSlotWeight.toFixed(2));

				if(amount == itemAmount) {
					ui.draggable.replaceWith(`<div class="item empty" data-slot="${ui.draggable.data('slot')}"></div>`);
				} else {
					let newMovedAmount = itemAmount - amount;
					let newMovedWeight = parseFloat(ui.draggable.data("peso")) * newMovedAmount;

					ui.draggable.data('amount',newMovedAmount);
					ui.draggable.children(".top").children(".itemAmount").html(formatarNumero(newMovedAmount) + "x");
					ui.draggable.children(".top").children(".itemWeight").html(newMovedWeight.toFixed(2));
				}
			} else {
				if (origin == "invRight" && tInv == "invLeft") return;

				let clone1 = ui.draggable.clone();
				let clone2 = $(this).clone();

				let slot1 = ui.draggable.data("slot");
				let slot2 = $(this).data("slot");

				ui.draggable.replaceWith(clone2);
				$(this).replaceWith(clone1);

				$(clone1).data("slot",slot2);
				$(clone2).data("slot",slot1);
			}

			updateDrag()

			if (tInv == "invLeft") {
				if (origin == "invLeft"){
					$.post("http://monkey_homes_v2/updateSlot", JSON.stringify({
						item: itemData.key,
						slot: itemData.slot,
						target: target,
						amount: parseInt(amount)
					}));

					$('.amount').val("");
				} else if (origin == "invRight"){
					$.post("http://monkey_homes_v2/sumSlot", JSON.stringify({
						item: itemData.key,
						slot: target,
						amount: parseInt(amount)
					}));

					$('.amount').val("");
				}
			} else if (tInv == "invRight") {
				if (origin == "invLeft") {
					$.post("http://monkey_homes_v2/storeItem", JSON.stringify({
						item: itemData.key,
						slot: itemData.slot,
						amount: parseInt(amount)
					}));

					$('.amount').val("");
				} else if (origin == "invRight") {
					updateChest()
				}
			}
		}
	});
}

function colorPicker(percent) {
	var colorPercent = "#2e6e4c";

	if (percent >= 100)
		colorPercent = "rgba(255,255,255,0)";

	if (percent >= 51 && percent <= 75)
		colorPercent = "#fcc458";

	if (percent >= 26 && percent <= 50)
		colorPercent = "#fc8a58";

	if (percent <= 25)
		colorPercent = "#fc5858";

	return colorPercent;
}

function updateChest() {
	$.post("http://monkey_homes_v2/requestChest",JSON.stringify({}),(data) => {
		$(".weightTextLeft").html(`<h2>Inventário</h2><span><i class="far fa-weight-hanging"></i> ${(data["peso"]).toFixed(2)} / ${(data["maxpeso"]).toFixed(2)}</span>`);
		$(".weightBarLeft").html(`<div id="weightContent" style="width: ${data["peso"] / data["maxpeso"] * 100}%"></div>`);
		$(".weightTextRight").html(`<h2>Baú</h2><span><i class="far fa-weight-hanging"></i> ${(data["peso2"]).toFixed(2)} / ${(data["maxpeso2"]).toFixed(2)}</span>`);
		$(".weightBarRight").html(`<div id="weightContent" style="width: ${data["peso2"] / data["maxpeso2"] * 100}%"></div>`);
		$(".invLeft").html("");
		$(".invRight").html("");

		const nameList2 = data.inventario2.sort((a,b) => (a.name > b.name) ? 1: -1);

		if (data["infos"] !== undefined) {
			$("#infoId").html(data.infos[1]);
			$("#infoNome").html(data.infos[0]);
			$("#infoNumero").html(data.infos[2]);
			$("#infoBanco").html(data.infos[4]);
			$("#infoCoins").html(data.infos[5]);
			$("#infoIdentidade").html(data.infos[3]);
		} else {
			$("#infoId").html("-");
			$("#infoNome").html("-");
			$("#infoNumero").html("-");
			$("#infoBanco").html("-");
			$("#infoCoins").html("-");
			$("#infoIdentidade").html("-");
		}

		for (let x = 1; x <= 100; x++){
			const slot = x.toString();

			if (data.inventario[slot] !== undefined) {
				const v = data.inventario[slot];
				let actualPercent

				if (v["days"]) {
					const maxDurability = 86400 * v["days"];
					const newDurability = (maxDurability - v["durability"]) / maxDurability;
					actualPercent = newDurability * 100;

				} else {
					actualPercent = v["durability"] * 100;
					if (actualPercent < 5.0) {
						actualPercent = 5.0
					}
				}

				const item = `<div class="item populated" data-item-key="${v.key}" data-slot="${slot}" data-amount="${v.amount}" data-peso="${v.peso}">
					<img class="mb-2" src="https://j4v4.site/MC/itens/${v["index"]}.png" onerror="imageError()" />
					<h6 class="font-16 m-0 delimitarTexto">${v.name}</h6>
					<small class="font-12">${(v.peso*v.amount).toFixed(2)}</small> / <small class="font-12">${formatarNumero(v.amount)} <small>UN</small></small>

					<div class="durability" style="width: ${parseInt(actualPercent)}%; background: ${colorPicker(actualPercent)};"></div>
				</div>`;

				$(".invLeft").append(item);
			} else {
				const item = `<div class="item empty" data-slot="${slot}"></div>`;

				$(".invLeft").append(item);
			}
		}

		for (let x = 1; x <= 100; x++){
			const slot = x.toString();

			if (nameList2[x-1] !== undefined) {
				const v = nameList2[x-1];
				let actualPercent

				if (v["days"]) {
					const maxDurability = 86400 * v["days"];
					const newDurability = (maxDurability - v["durability"]) / maxDurability;
					actualPercent = newDurability * 100;

				} else {
					actualPercent = v["durability"] * 100;
				}

				const item = `<div class="item populated" data-item-key="${v.key}" data-slot="${slot}" data-amount="${v.amount}" data-peso="${v.peso}">
					<img class="mb-2" src="https://j4v4.site/MC/itens/${v["index"]}.png" onerror="imageError()" />
					<h6 class="font-16 m-0 delimitarTexto">${v.name}</h6>
					<small>${(v.peso*v.amount).toFixed(2)}</small> / <small>${formatarNumero(v.amount)} <small>UN</small></small>

					<div class="durability" style="width: ${parseInt(actualPercent)}%; background: ${colorPicker(actualPercent)};"></div>
				</div>`;

				$(".invRight").append(item);
			} else {
				const item = `<div class="item empty" data-slot="${slot}"></div>`;

				$(".invRight").append(item);
			}
		}
		
		updateDrag()
	});
}

function formatarNumero(n) {
	var n = n.toString();
	var r = '';
	var x = 0;

	for (var i = n.length; i > 0; i--){
		r += n.substr(i - 1, 1) + (x == 2 && i != 1 ? '.' : '');
		x = x == 2 ? 0 : x + 1;
	}

	return r.split('').reverse().join('');
}