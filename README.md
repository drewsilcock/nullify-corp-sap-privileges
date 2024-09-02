# Nullify Privileges.app

Is corporate forcing [SAP SE's Privileges.app](https://github.com/SAP/macOS-enterprise-privileges) onto your Mac?

This will make it seem like it's not even there.

## How to I set it up?

Easy peasy:

```shell
git clone https://github.com/drewsilcock/nullify-corp-sap-privileges
cd nullify-corp-sap-privileges
./install.sh
```

## FAQ

### How do I know whether it's working?

If Privileges.app gets removed from the Dock, that bit is working. If you no longer need to escalate your privileges, that means that bit is probably also working.

To verify:

```shell
/Applications/Privileges.app/Contents/Resources/PrivilegesCLI --remove

# Should say you have "standard user rights" (unless it beat you to it)
/Applications/Privileges.app/Contents/Resources/PrivilegesCLI --status

# Will re-grant admin rights after maximum of 30 seconds.
sleep 30

# Should say you have "admin rights"
/Applications/Privileges.app/Contents/Resources/PrivilegesCLI --status
```

You should see that you have been automatically re-granted your admin permissions back.

### Do I need admin permissions?

This is all user-specific, so no, you don't need admin privileges to set this up. Although if you're using the Privileges.app program, you should have admin on your machine anyway...

### How can I trust you enough to install this?

Please don't! I'm not a trustworthy person. Just read the code instead, it's like 100 lines in total. You might even learn something along the way.

### Can't I just remove Privileges.app?

You can absolutely give yourself admin permissions and then remove Privileges.app as per [documented instructions on their wiki](https://github.com/SAP/macOS-enterprise-privileges/wiki/Uninstallation), however your IT may well have a policy set up to automatically re-install the application or to downgrade your privileges on the assumption that you should be using the Privileges app to upgrade them as needed.

### Will I get in trouble with IT if I do this?

I could see that as a very real possibility, please use your own judgement before using this.

Privileges.app logs when you're escalating permissions to the system logs (you can see it using Console.app and filtering "PROCESS=corp.sap.privileges.helper") so your IT department may be checking those logs for suspicious activity, and this would probably look fairly suspicious.

### What happens if this goes wrong and my computer sets on fire?

This code is provided without any guarantees whatsoever, so please take your issue up with your local fire department.

### Is this a good idea from a security perspective?

Honestly, not really.

### What does this actually do?

Two things:

- Sets up a script that runs every few seconds to automatically grant you admin permissions using the Privileges.app CLI.
- Sets up a script that watches the macOS Dock properties file and removes Privileges.app from the persistent apps if it sneaks its way in there, as it is wont to.

### How often does this run?

By default the admin granter runs every 30 seconds. You can change this by updating [`dev.silcock.drew.escalate-privileges.agent.plist`](./dev.silcock.drew.escalate-privileges.agent.plist) and changing the 30 to however many seconds you want.

The Dock remover runs whenever the Dock plist file is changed, but won't run more often than every 10 minutes. To change this, update the 600 to however many seconds you want in the [`dev.silcock.drew.remove-privileges-from-dock.agent.plist](./dev.silcock.drew.remove-privileges-from-dock.agent.plist) file.

### Does this use up all my CPU?

The actual escalate-privileges check takes about 10 ms on my MacBook Pro M3 so you should probably be ok. The Dock check takes about 100 ms but only runs every 30 minutes and only after the Dock plist file is updated.
