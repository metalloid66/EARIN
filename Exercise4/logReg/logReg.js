import * as tf from "@tensorflow/tfjs";
import * as tfvis from "@tensorflow/tfjs-vis";
import * as Papa from "papaparse";

// Parse the data file
Papa.parsePromise = function (file) {
  return new Promise(function (complete, error) {
    Papa.parse(file, {
      header: true,
      download: true,
      dynamicTyping: true,
      complete,
      error,
    });
  });
};

// Load the data file
const loadData = async () => {
  const csvTrain = await Papa.parsePromise(
    "https://res.cloudinary.com/dsc8qplyp/raw/upload/v1651001140/csv_20_precent_train_test_dlwf4l.csv"
  );

  return [csvTrain.data];
};

/* Preprocess, divided and prepare data - begin */
const oneHot = (outcome) => Array.from(tf.oneHot([outcome], 2).dataSync());

const createDataset = (data, features, testSize, batchSize) => {
  const X = data.map((r) =>
    features.map((f) => {
      const val = r[f];
      return val === undefined ? 0 : val;
    })
  );

  const y = data.map((r) => {
    const outcome = r["'class'"] === undefined || r["'class'"] === "normal" ? 0 : 1;
    return oneHot(outcome);
  });

  const splitIdx = parseInt((1 - testSize) * data.length, 10);

  const ds = tf.data
    .zip({
      xs: tf.data.array(X),
      ys: tf.data.array(y),
    })
    .shuffle(data.length, 42);

  return [
    ds.take(splitIdx).batch(batchSize),
    ds.skip(splitIdx + 1).batch(batchSize),
    tf.tensor(X.slice(splitIdx)),
    tf.tensor(y.slice(splitIdx)),
  ];
};

/* Preprocess, divided and prepare data - end */

/* Training the model - begin */
const trainLogisticRegression = async (featureCount, trainDS, validDS) => {
  const model = tf.sequential();
  model.add(
    tf.layers.dense({
      units: 2,
      activation: "softmax",
      inputShape: [featureCount],
    })
  );

  model.compile({
    optimizer: tf.train.adam(0.001),
    loss: "binaryCrossentropy",
    metrics: ["accuracy"],
  });

  const trainLogs = [];
  const lossContainer = document.getElementById("loss-cont");
  const accContainer = document.getElementById("acc-cont");

  await model.fitDataset(trainDS, {
    epochs: 100,
    validationData: validDS,
    callbacks: {
      onEpochEnd: async (epoch, logs) => {
        trainLogs.push(logs);
        tfvis.show.history(lossContainer, trainLogs, ["loss", "val_loss"]);
        tfvis.show.history(accContainer, trainLogs, ["acc", "val_acc"]);
      },
    },
  });

  return model;
};

/* Training the model - end */

const run = async () => {
  const [trainData] = await loadData();

  const features = [
    "'duration'",
    "'src_bytes'",
    "'dst_bytes'",
    "'land'",
    "'wrong_fragment'",
    "'urgent'",
    "'hot'",
    "'num_failed_logins'",
    "'logged_in'",
    "'num_compromised'",
    "'root_shell'",
    "'su_attempted'",
    "'num_root'",
    "'num_file_creations'",
    "'num_shells'",
    "'num_access_files'",
    "'num_outbound_cmds'",
    "'is_host_login'",
    "'is_guest_login'",
    "'count'",
    "'srv_count'",
    "'serror_rate'",
    "'srv_serror_rate'",
    "'rerror_rate'",
    "'srv_rerror_rate'",
    "'same_srv_rate'",
    "'diff_srv_rate'",
    "'srv_diff_host_rate'",
    "'dst_host_count'",
    "'dst_host_srv_count'",
    "'dst_host_same_srv_rate'",
    "'dst_host_diff_srv_rate'",
    "'dst_host_same_src_port_rate'",
    "'dst_host_srv_diff_host_rate'",
    "'dst_host_serror_rate'",
    "'dst_host_srv_serror_rate'",
    "'dst_host_rerror_rate'",
    "'dst_host_srv_rerror_rate'",
  ];

  const [trainDS, validDS, xTest, yTest] = createDataset(
    trainData,
    features,
    0.3199,
    16
  );

  const model = await trainLogisticRegression(features.length, trainDS, validDS);
  console.log("Done training");

  // Prediction
  const preds = model.predict(xTest).argMax(-1);
  const labels = yTest.argMax(-1);

  const confusionMatrix = await tfvis.metrics.confusionMatrix(labels, preds);
  const container = document.getElementById("confusion-matrix");

  tfvis.render.confusionMatrix(container, {
    values: confusionMatrix,
    tickLabels: ["Normal", "Abnormal"],
  });
};

// Prepare the browser
if (document.readyState !== "loading") {
  run();
} else {
  document.addEventListener("DOMContentLoaded", run);
}
