# nscd_lean

A super-lean NSCD setup to boost DNS client performance. Enables only the hosts cache from NSCD and disables the rest.

### Parameters

`[paranoia]`

`low`: Enables negative lookup caching. Due to the NSCD internal cache sweep cycle of 15 seconds, the effect of a negatively cache hostname may last from 1 to 15 seconds.

`medium`: (default) Disables negative lookup caching.

`high`: Disables negative lookup caching and enables NSCD's paranoia mode where it restarts itself every hour.

### Examples
```
class { 'nscd_lean':
  paranoia => 'medium'
}
```

