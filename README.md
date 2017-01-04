#About
This is a simple DFS site written in RoR. All rights reserved. Improves upon the current models via the database design which allows addition of any sort of game or sport the admins wish to include, all through a web interface. A temporary prototype can be found

#Features
Deposit/Payment system in place to automatically add balance to user account upon verified payment. Multiple payment structures. An easy to use admin panel to handle daily activities. Most importantly, it features the ability to add new games/sports to the site without writing any code, and can be done easily through the admin panel.

#USAGE
To 
admin account = test@test.com
password = password

Currently prototyped, many routes must be removed


Navigate to admin panel

features

Depositing 
	The deposits handler has been removed as the associated paypal business account has been deactivated.  The code should still paint the picture of how it works
	A unique payment experience is created for each deposit, with the user being asked to pay the amount they requested to deposit
	Upon the payment being verified the amount paid is added to the user’s balance
	Withdrawals are not automatic, as they are meant to be checked manually prior to approval


	