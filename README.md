#About
This is a simple DFS site written in RoR. All rights reserved. Improves upon the current models via the database design which allows addition of any sort of game or sport the admins wish to include, all through a web interface. A temporary prototype can be found at http://dfsesports.herokuapp.com See below for admin account usage.

#Features
Deposit/Payment system in place to automatically add balance to user account upon verified payment. Multiple payment structures. An easy to use admin panel to handle daily activities. Most importantly, it features the ability to add new games/sports to the site without writing any code, and can be done easily through the admin panel. This automatically handles limiting the number of possible players at each position that a user can choose when building their lineup.  Also features one-click payouts of slates, where the winners/losers of all contests in a slate can be determined and have their balances updated with a single click.

#USAGE
To view the admin panel, use the below login
admin account = test@test.com
password = password

To add a new sport, add a gametype in the admin panel. Next, add teams and players to this sport. Add a slate for this sport. Add games(matchups) to the slate, add contests to the slate.

# Deposits/Payments
The deposits handler has been removed as the associated paypal business account has been deactivated. The code should still paint the picture of how it works. A unique checkout experience is created for each deposit, with the user being asked to pay the amount they requested to deposit. Upon the payment being verified the amount paid is added to the user’s balance
Withdrawals are not automatic, as they are meant to be checked manually prior to approval.


# Todo
Currently prototyped, many routes must be removed/actions to be changed. Frontend display bugs. Lineup builder is prototyped so it likely has a few bugs that will appear. Add new paypal business account. 



	