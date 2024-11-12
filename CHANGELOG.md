# Changelog

## [0.2.1](https://github.com/3d-omics/ht_quant/compare/v0.2.0...v0.2.1) (2024-11-12)


### Bug Fixes

* add tidyr, update and pin ([a6ac043](https://github.com/3d-omics/ht_quant/commit/a6ac0434fe1c8ac64379f33b527bb988d379586a))


### Performance Improvements

* group fastp and star align. modify profile so it only handles integers ([5e0e6f9](https://github.com/3d-omics/ht_quant/commit/5e0e6f9093b1d0c7946226f274d383862defb4d7))
* run reads in the head node ([4dc4b18](https://github.com/3d-omics/ht_quant/commit/4dc4b18fc60aa4afa1a46ea60c5a6dd1eb487eb7))

## [0.2.0](https://github.com/3d-omics/ht_quant/compare/v0.1.0...v0.2.0) (2024-08-06)


### Features

* pin dependencies ([123de53](https://github.com/3d-omics/ht_quant/commit/123de536ef2a6ce8128771724e2251ea84f8f043))

## [0.1.0](https://github.com/3d-omics/ht_quant/compare/v0.0.1...v0.1.0) (2024-05-22)


### Features

* cache references and index; extract to profile ([74d1352](https://github.com/3d-omics/ht_quant/commit/74d1352794a1b9bcdb8da3e843f2bf37430705f7))
* disable default adapters ([e1f347c](https://github.com/3d-omics/ht_quant/commit/e1f347ccab8497274d30774e169515bd724851e0))
* **environments:** update everything ([9c05755](https://github.com/3d-omics/ht_quant/commit/9c057552caed6d8ffd673a6ce8a577f73cb7b7a0))
* **fastp:** compress with pigz ([8d78a69](https://github.com/3d-omics/ht_quant/commit/8d78a69b82417cb91344379307dd9899da4b2dda))
* **fastp:** if adaptors are empty, assume the default ones ([ec0a097](https://github.com/3d-omics/ht_quant/commit/ec0a097727b671872058aeb33db381afd0b51c49))
* **folders:** reorganize properly ([2528242](https://github.com/3d-omics/ht_quant/commit/252824269b7f802cb56d5371bce22bc70a04948b))
* **gha:** name cache ([09ba04e](https://github.com/3d-omics/ht_quant/commit/09ba04e838c06c79fa33b76ae3605f92adcc0f1d))
* **gha:** sort lines ([edcd963](https://github.com/3d-omics/ht_quant/commit/edcd96396c45553d237b64ffe2d7be283f0ed527))
* **gha:** split into steps ([faa3a4b](https://github.com/3d-omics/ht_quant/commit/faa3a4ba5fbb5cf2733d59cabe547e23b4912401))
* modify yaml to be with : notation ([b031d87](https://github.com/3d-omics/ht_quant/commit/b031d87b3ad05e030ff993319484c1e191922dd9))
* move profile to new location ([ee1a01e](https://github.com/3d-omics/ht_quant/commit/ee1a01ec22be2faccfdd1aa5de7a7f2681c7a4bd))
* **preprocess:** add pigz ([4de4181](https://github.com/3d-omics/ht_quant/commit/4de4181b7bb41df09888c076f8194bc8468ba990))
* **preprocess:** rename rules; extract resources to profile ([7d39061](https://github.com/3d-omics/ht_quant/commit/7d39061b22f63e6663ecca6624a55ffc815d8be7))
* **preprocess:** update env ([2fc671f](https://github.com/3d-omics/ht_quant/commit/2fc671fda3d29e628778e7ecc45eb036588dd8de))
* **quantify:** no more folder per library ([f50e4f0](https://github.com/3d-omics/ht_quant/commit/f50e4f047fbdd27d7408a3bb7d294d632fe9eae8))
* **quantify:** remove protected files ([256db4c](https://github.com/3d-omics/ht_quant/commit/256db4cf7a7ecde6b4fae091dcc58ec794d10b64))
* **quantify:** rename rules; extract resources to profile; separate index and align ([4c28057](https://github.com/3d-omics/ht_quant/commit/4c280577327a789f3c40456352e3c14818323e08))
* raise latency to 1 min ([c9fe9c4](https://github.com/3d-omics/ht_quant/commit/c9fe9c48f4d1be7fad49cf6f9ffd2087f86663ee))
* **readme:** precommit everything ([c3820a3](https://github.com/3d-omics/ht_quant/commit/c3820a3a9fa4d2511ac16ebc236ac191c87d6e52))
* **readme:** update everything ([ec9d548](https://github.com/3d-omics/ht_quant/commit/ec9d54884163550e9616ae8bc49dc48813cab5dc))
* reduce samples to speed up testing ([230dae9](https://github.com/3d-omics/ht_quant/commit/230dae9e027ce681a3647af7bf96456b91295b81))
* **reference:** rename rules, readability ([f279335](https://github.com/3d-omics/ht_quant/commit/f2793352c7c652499f57e7292e84dff18921a9bd))
* **renaming:** wrong rule names ([eb9853c](https://github.com/3d-omics/ht_quant/commit/eb9853c2f95e6dbdbdcb74196eafce41fed7ee0c))
* restructure repo ([48819d8](https://github.com/3d-omics/ht_quant/commit/48819d85a90cbb43cbfcf555f9758ace5bd41a6b))
* **rulegraph:** update ([c4aa33e](https://github.com/3d-omics/ht_quant/commit/c4aa33ec0692ad5c0e15c2abcf36175e37e21991))
* **run:** add local run script ([be1bf21](https://github.com/3d-omics/ht_quant/commit/be1bf214a2eb891961e312f4338642cb4c7583c8))
* sample_id, library_id ([8a898f3](https://github.com/3d-omics/ht_quant/commit/8a898f33be07d6d4a92120458b3fc1a2b63c66ef))
* **sample:** simplify test dataset ([a3a1308](https://github.com/3d-omics/ht_quant/commit/a3a130873d50e22203f14a5c99323126721715a0))
* update and lint environments ([227929c](https://github.com/3d-omics/ht_quant/commit/227929c7376e0b6093a08cd0cb95f033a692818e))
* update rules to new nomenclature ([35a5445](https://github.com/3d-omics/ht_quant/commit/35a544590b7ebe84a20c99317e92eb3021b4711e))
* update rules to new nomenclature ([af5e988](https://github.com/3d-omics/ht_quant/commit/af5e988fc9477f96b012f8b962904cd6ba2e55c5))


### Bug Fixes

* **gha:** back to custom action ([0f5c371](https://github.com/3d-omics/ht_quant/commit/0f5c3713628c70ccc527e26eb8f3696c64da8b71))
* **gha:** check GHA now that snakemake 8.1.0 is published ([6f2b880](https://github.com/3d-omics/ht_quant/commit/6f2b88084037ef6260cb37973ccbc594d74ab1ac))
* **gha:** disable cache removal; upgrade pre-commit ([12d114c](https://github.com/3d-omics/ht_quant/commit/12d114ce44594dfba3e7d3d5b9fd8d400059866f))
* **gha:** point action to just v1 ([4d82cfe](https://github.com/3d-omics/ht_quant/commit/4d82cfe2cbcefb7b43a233b5e8a54d0b32482e96))
* **gha:** put the downloading into a signle line ([dcbdd42](https://github.com/3d-omics/ht_quant/commit/dcbdd4266bd47aecf269e087a8fb9ff5b039fe5e))
* **gha:** put the downloading into a signle line ([cf846b5](https://github.com/3d-omics/ht_quant/commit/cf846b52977d23b7570d736a5740e633e2ecdbb0))
* **gha:** reorder lines again ([45043bf](https://github.com/3d-omics/ht_quant/commit/45043bfc5cae35f1d093378bfe018a6b38576141))
* **gha:** typo ([339cb5c](https://github.com/3d-omics/ht_quant/commit/339cb5c2f5381150ffac77a711d063bb7d1acc7f))
* **gha:** update caching action to the custom repo ([559109a](https://github.com/3d-omics/ht_quant/commit/559109aa4e20393ee68057d42582fecdb2b2331f))
* **gha:** update snakemake action to 1.25.1 ([2903a78](https://github.com/3d-omics/ht_quant/commit/2903a78b301908c79dfb8002b6c0b5c6ccaaf98b))
* **gha:** use temporary action ([acb06c6](https://github.com/3d-omics/ht_quant/commit/acb06c65a49d9771f63e45f376bdfe8bcc2d0791))
* linting ([f137425](https://github.com/3d-omics/ht_quant/commit/f137425c035d00616107713f3ea9b2e486aa5263))
* remove output dir ([e889ed9](https://github.com/3d-omics/ht_quant/commit/e889ed932b64d8f1ed2010579d019811f5fe20f3))
* rename rules ([0b223af](https://github.com/3d-omics/ht_quant/commit/0b223af98b2d41322e6c8abb591ce59f14b50266))
* **report:** downgrade python ([b61b282](https://github.com/3d-omics/ht_quant/commit/b61b282c7552c2e08e8d3113c02c0c74c2ff4437))
* **report:** use correct report names ([04364fb](https://github.com/3d-omics/ht_quant/commit/04364fb11bbc9a1fc7cf29701d5411aca7f4c946))
