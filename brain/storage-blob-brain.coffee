# Description:
#   Stores the brain in Azure Storage Blob
#
# Dependencies:
#   "azure-storage": "*"
#
# Configuration:
#   HUBOT_BRAIN_AZURE_STORAGE_ACCOUNT             - Azure Storage account name
#   HUBOT_BRAIN_AZURE_STORAGE_ACCESS_KEY          - Azure Storage Access Key
#   HUBOT_BRAIN_AZURE_STORAGE_CONTAINER           - Azure Storage Blob container name (defaults to 'hubot')
#
# Commands:
#
# Notes:
#   None
#
# Author:
#   bfcamara

util    = require "util"
azure   = require "azure-storage"

module.exports = (robot) ->

  loaded            = false
  initializing      = false
  account           = process.env.HUBOT_BRAIN_AZURE_STORAGE_ACCOUNT
  accessKey         = process.env.HUBOT_BRAIN_AZURE_STORAGE_ACCESS_KEY
  containerName     = process.env.HUBOT_BRAIN_AZURE_STORAGE_CONTAINER  or "hubot"
  
  blobName          = "brain-dump.json"
  lastBrainData     = ""

  unless account and accessKey
    throw new Error "Azure Storage Blob brain requires HUBOT_BRAIN_AZURE_STORAGE_ACCOUNT and \
      HUBOT_BRAIN_AZURE_STORAGE_ACCESS_KEY"

  blobSvc = azure.createBlobService account, accessKey
  
  init = ()->
    initializing = true
    blobSvc.createContainerIfNotExists containerName, (err, justCreated, response) ->
      initializing = false
      
      if err
        robot.logger.error "Error checking if container exists: #{util.inspect(err)}"
        return

      # we have the container already created
      if justCreated
        robot.logger.info "Just finished to create the container. There's no data to read."
        robot.brain.mergeData {}
        loaded = true
      else
        robot.logger.info "The container already exists."
        loadBrain()

  saveBrain = (data)->
    if !loaded
      robot.logger.debug "Not saving to Azure Storage Blob, because not loaded yet"
      init() if not initializing
      return

    brainData = JSON.stringify(data)
    if brainData is lastBrainData
      robot.logger.debug "Not saving to Azure Storage Blog, because no changes were detected in brain"
      return

    blobSvc.createBlockBlobFromText containerName, blobName, JSON.stringify(data), (err, blob, res) ->
      if err
        robot.logger.error "Error storing brain to Azure Storage Blob #{containerName}: #{util.inspect(err)}"
        init() if err.statusCode is 404 and not initializing
      else
        lastBrainData = brainData
        robot.logger.debug "Saved brain with success to #{containerName}"

  loadBrain = ->
    blobSvc.getBlobToText containerName, blobName, (err, text)->
      if err  
        robot.logger.error "Error getting brain from Azure Storage Blob #{containerName}: #{util.inspect(err)}"
        if err.statusCode is 404
          robot.logger.info "The blob doesn't exist yet. Initialiazing new brain data"
          robot.brain.mergeData {}
          loaded = true
      else
        robot.logger.debug "Brain loaded from blob storage"
        robot.brain.mergeData JSON.parse(text)
        loaded = true
        
  init()

  robot.brain.on 'save', (data)->
    saveBrain(data)

  robot.brain.on 'close', ->
    saveBrain(robot.brain.data)
