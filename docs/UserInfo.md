# UserInfo

## Properties
|Name |Type |Description |
|--- |--- |--- |
|*identity*|String|The identity of the user
|*friendlyName*|String|The friendly name of the user
|*attributes*|Object|Any custom attributes assigned to the user
|*isOnline*|Boolean|Whether the user is online
|*isNotifiable*|Boolean|Whether the user is able to receive push notifications

## Methods

### `setAttributes(attributes)` : Promise
|Name |Type |Description |
|--- |--- |--- |
|*attributes*|Object|The new attributes object

### `setFriendlyName(name)` : Promise
|Name |Type |Description |
|--- |--- |--- |
|*friendlyName*|String|The new friendlyName

#### `close()`
Remove the listeners on this instance. Call in `componentWillUnmount()`.

### Events

#### `onUpdated(type)`
|Name |Type |Description |
|--- |--- |--- |
|*type*|Constants.TCHUserInfoUpdate|The type of update **iOS Only**