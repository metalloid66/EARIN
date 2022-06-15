const fs = require("fs");

function selectWithProb(events, size, probability) {
  if (probability != null) {
    const pSum = probability.reduce((sum, v) => sum + v);
    if (pSum < 1 - Number.EPSILON || pSum > 1 + Number.EPSILON) {
      throw Error("Overall probability has to be 1.");
    }
    if (probability.find((p) => p < 0) != undefined) {
      throw Error("Probability can not contain negative values");
    }
    if (events.length != probability.length) {
      throw Error("Events have to be same length as probability");
    }
  } else {
    probability = new Array(events.length).fill(1 / events.length);
  }

  var probabilityRanges = probability.reduce((ranges, v, i) => {
    var start = i > 0 ? ranges[i - 1][1] : 0 - Number.EPSILON;
    ranges.push([start, v + start + Number.EPSILON]);
    return ranges;
  }, []);

  var choices = new Array();
  for (var i = 0; i < size; i++) {
    var random = Math.random();
    var rangeIndex = probabilityRanges.findIndex(
      (v, i) => random > v[0] && random <= v[1]
    );
    choices.push(events[rangeIndex]);
  }
  return choices;
}

class Node {
  constructor(name, parents, probabilities) {
    this.name = name;
    this.parents = parents;
    this.probabilities = probabilities;
  }
  getProp(condition1, condition2 = undefined) {
    if (condition2 == undefined) {
      if (condition1 == true) {
        return this.probabilities["T"];
      }
      return this.probabilities["F"];
    }
    if (condition1 == true) {
      if (condition2 == true) {
        return this.probabilities["T,T"];
      }
      return this.probabilities["T,F"];
    }
    if (condition2 == true) {
      return this.probabilities["F,T"];
    }
    return this.probabilities["F,F"];
  }
}

class Probability {
  constructor(total = 0, totalT = 0, totalF = 0) {
    this.total = total;
    this.totalT = totalT;
    this.totalF = totalF;
  }

  increaseCount(condition) {
    if (condition[0] == true) {
      this.totalT += 1;
    } else {
      this.totalF += 1;
    }
    this.total += 1;
  }
}

class BayesianNetwork {
  constructor(file_name) {
    this.nodes = {};
    this.createNetwork(file_name);
  }

  createNetwork(file_name) {
    let network = JSON.parse(fs.readFileSync(file_name));

    if (network["nodes"] == undefined || network["relations"] == undefined)
      console.error("Invalid Network");

    for (const key of network["nodes"]) {
      let node = new Node(
        key,
        network["relations"][key]["parents"],
        network["relations"][key]["probabilities"]
      );

      this.nodes[node.name] = node;
    }
  }

  printNetwork() {
    console.log("\n--- Bayesian network: ---\n");
    console.log(this.nodes);
    console.log("-------------------------\n");
  }

  /**
   *
   * @param {*} evidence - Evidence to make the prediction given in an object format e.g {Flu: true}
   * @param {*} query - Names of nodes we want to predict given in an array e.g ["HighFever"]
   * @param {*} steps - The number of steps to perform the MCM algorithm
   */
  gibbs_sampler(evidence, query, steps) {
    let variables = evidence;
    let variablesToPredictArr = Object.values(this.nodes).map((node) => {
      if (Object.keys(variables).every((variable) => variable !== node.name)) {
        return node.name;
      }
    });
    variablesToPredictArr = variablesToPredictArr.filter((variablesToPredictArr) => {
      return variablesToPredictArr !== undefined;
    });
    let variablesToPredictObj = {};

    variablesToPredictArr.forEach((variable) => {
      variablesToPredictObj[variable] = Math.random() < 0.5;
    });

    let queryPredicitions = {};
    query.forEach((qur) => {
      queryPredicitions[qur] = new Probability();
    });

    // Random walking through network
    for (let i = 0; i < steps; i++) {
      let currentChoice =
        variablesToPredictArr[
          Math.floor(Math.random() * variablesToPredictArr.length)
        ];
      let predicatedChoice = this.predict(variables, currentChoice);
      variables[currentChoice] = predicatedChoice;
      queryPredicitions[currentChoice].increaseCount(predicatedChoice);
    }
    return queryPredicitions;
  }

  predict(variables, currentChoice) {
    let probabilities = [];
    let chosenNode = this.nodes[currentChoice];

    // HighFever with parents
    if (chosenNode.parents.length > 0) {
      probabilities.push(chosenNode.getProp(variables["Flu"], true));
      probabilities.push(chosenNode.getProp(variables["Flu"], false));
    } else {
      // Flu with no parents
      let probability = chosenNode.getProp(true);
      probability *= this.nodes["HighFever"].getProp(true, variables["Flu"]);
      probabilities.push(probability);

      probability = chosenNode.getProp(false);
      probability *= this.nodes["HighFever"].getProp(false, variables["Flu"]);
      probabilities.push(probability);

      // Normalizing probabilities
      probabilities = probabilities.map((prob) => {
        return prob / probabilities.reduce((p, c) => p + c);
      });
    }
    return selectWithProb([true, false], 2, probabilities);
  }
}

// Run the application

// Create the newtork
bn = new BayesianNetwork("flu.json");

// Print the network
bn.printNetwork();

// Run gibbs sampler -- Here we provide the evidence, query, and number of steps for MCM
ret = bn.gibbs_sampler({ Flu: true }, ["HighFever"], 10000);

console.log(
  "The results below indicate how likely and unlikely the event has had happend:"
);
for (let result in ret) {
  console.log(
    `${result}: ${ret[result].totalT / ret[result].total}% -----${
      ret[result].totalF / ret[result].total
    }% `
  );
}
