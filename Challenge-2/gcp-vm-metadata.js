const projectId = 'dev';
const zone = 'us-central1-c'

const compute = require('@google-cloud/compute');

// List all instances in the given zone in the specified project.
async function listInstances() {
  const instancesClient = new compute.InstancesClient();

  const [instanceList] = await instancesClient.list({
    project: projectId,
    zone,
  });

  console.log(`Instances found in zone ${zone}:`);

  for (const instance of instanceList) {
    // console.log(` - ${instance.name} (${instance.machineType})`);
    console.log(instance);
  }
}

listInstances();
