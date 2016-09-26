# Message

## Properties
|Name |Type |Description |
|--- |--- |--- |
|*sid*|String|The id of the message
|*index*|Number|The index of the message
|*author*|String|The identity of the author
|*body*|String|The message body
|*timestamp*|Date|The date object of the timestamp
|*dateUpdated*|Date|The date object of when the message was last updated **iOS Only**
|*lastUpdatedBy*|String|The identity of the user who last updated the message **iOS Only**
|*attributes*|Object|Any attributes added to the message

## Methods

### `updateBody(body) : Promise`
|Name |Type |Description |
|--- |--- |--- |
|*body*|String|The new body of the message

### `setAttributes(attributes) : Promise`
|Name |Type |Description |
|--- |--- |--- |
|*attributes*|Object|The new attributes to set on the message
