# `ussd-menu-builder`

A motoko library for building USSD apps on the IC.

## Usage

### Install with mops

You need `mops` installed. In your project directory run:

```
mops add ussd-menu-builder
```

In the Motoko source file, import the package as follows:

```motoko
import Ussd "mo:ussd-menu-builder/Ussd";
import { 
    newMenu; 
    newMenuItem; 
    newMenuItemWithOptions;
    addMenuItem;
    // other functions...
} "mo:ussd-menu-builder/Ussd";
```

### Example

Building a USSD app using the library is fairly straightfoward. You can check [/example](https://github.com/akimau/motoko-ussd-menu-builder/tree/main/example) directory for a demo.