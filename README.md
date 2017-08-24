hubot-azure-scripts
===================

**DEPRECATED**: this package is deprecated. Use `hubot-azure-brain` instead (https://github.com/coryallegory/hubot-azure-brain) which is a fork of this project.

The original idea of this package was to provide hubot scripts to manage Azure resources.
However, currently, what this package provides is just an implementation of a Hubot brain to
persist in an Azure blob storage. If you are looking just for the brain implementation
you should use use the separate package `hubot-azure-brain` which you can find it [here](https://github.com/coryallegory/hubot-azure-brain)
and is a fork of this project.

## Installation

Install it using `npm install hubot-azure-scripts`

## Scripts

There are no scripts yet. We'll include some in the future


## Brain

This module provides a brain implementation to store it in a Azure Storage Blob.

You need to edit the `external-scrips.json` to include the file `hubot-azure-scripts/brain/storage-blob-brain`, 
and remove the the `redis-brain` from the `hubot-scripts.json` file.

Then you have to define the following environment variables:

+  `HUBOT_BRAIN_USE_STORAGE_EMULATOR` - Whether or not to use the Azure Storage Emulator
+  `HUBOT_BRAIN_AZURE_STORAGE_ACCOUNT` - The Azure storage account name
+  `HUBOT_BRAIN_AZURE_STORAGE_ACCESS_KEY` - The Azure storage access key
+  `HUBOT_BRAIN_AZURE_STORAGE_CONTAINER` - The Azure storage container. If not defined defaults to `hubot`




