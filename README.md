hubot-azure-scripts
===================

Hubot module to provide a bunch of Azure scripts and a brain implementation targeting 
Azure Storage Account

Install it using `npm install hubot-azure-scripts`

## Scripts

There are no scripts yet. We'll include some in the future


## Brain

This module provides a brain implementation to store it in a Azure Storage Blob.

You need to edit the `external-scrips.json` to include the file `hubot-azure-scripts/brain/azure-blob-brain`, 
and remove the the `redis-brain` from the `hubot-scripts.json` file.

Then you have to define the followinf environment variables:

+  `HUBOT_BRAIN_AZURE_STORAGE_ACCOUNT` - The Azure storage account name
+  `HUBOT_BRAIN_AZURE_STORAGE_ACCESS_KEY` - The Azure storage access key
+  `HUBOT_BRAIN_AZURE_STORAGE_CONTAINER` - The Azure storage container. If not defined defaults to `hubot`




