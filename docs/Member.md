# Member

## Properties
|Name |Type |Description |
|--- |--- |--- |
|*identity*|String|The identity of the user
|*channelSid*|String|The channel id
|*lastConsumedMessageIndex*|Integer|The index of the last message the member consumed
|*lastConsumptionTimestamp*|Date|The timestamp of the last message consumption

## Methods

#### `getUserDescriptor()` : Promise
Returns a snapshot in time of user information for the current member

#### `getAndSubscribeUser()` : Promise
Returns user information for the current member
