# Killing Floor Play To Earn
Base template for running a server with play to earn support

## Using Database
- Setup [pte_databaseserver](https://github.com/Play-To-Earn-Currency/pte_databaseserver) in the same machine the server will run
- Download [Killing Floor](https://killingfloor.fandom.com/wiki/Dedicated_Server_(Killing_Floor_1)) server files
- Create the start script, template can be found on the wiki
- Add: ``?Mutator=PlayToEarnMutator.PlayToEarnMutator``
- Mutator files must be add to the ``KillingFloorDedicatedServer/System``
- Install a database like mysql or mariadb
- Create a user for the database: GRANT ALL PRIVILEGES ON pte_wallets.* TO 'pte_admin'@'localhost' IDENTIFIED BY 'supersecretpassword' WITH GRANT OPTION; FLUSH PRIVILEGES;
Create a table named ``killingfloor``
```sql
CREATE TABLE killingfloor (
    uniqueid VARCHAR(255) NOT NULL PRIMARY KEY,
    walletaddress VARCHAR(255) DEFAULT null,
    value DECIMAL(50, 0) NOT NULL DEFAULT 0
);
```

# Compiling (Windows)
- Download killing floor server files
- Include this mutator to the compiler section

``KF1DedicatedServer/System/KillingFloor.ini``
```ini
EditPackages=PlayToEarnMutator
```

---
### Option 1
- Use ``build.sh`` script
---
### Option 2
- Copy ``PlayToEarnMutator`` inside the killing floor server files
- Use ucc.exe to compile the mutators: ``ucc.exe make`` (Only Windows... for some reason)
- Remove compiled files to rebuild or it will be ignored

# Compiling (Linux)
Follow the steps for windows, but you will need to use wine for compiling

# Developing
- Download [UnrealScript](https://marketplace.visualstudio.com/items?itemName=EliotVU.uc) extension for vscode
- Download [KillingFloorSourceCode](https://github.com/InsultingPros/KillingFloor), and put it on this root folder
- Restart vscode