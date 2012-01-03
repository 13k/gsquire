# GSquire

Back in the Age of Heroes, GSquire would carry thy armor and sword, would get
thy lordship dressed and accompany in battle. He would fight side by side with
those who stood brave against the toughest of the foes. These were good times
to be alive.

Then a swift, strange, wind blew upon this land and everything we knew was
washed away and replaced by something new. All we used to know about living,
eating, singing and smiling was made anew. Not everyone could handle that, many
were forced into this. Those who were born during this time, never knew how was
the world before.

Some received this wind as a blessing from gods, others deemed it cursed. The
only agreement was in calling it Web 2.0.

## Really, WTF is this?

GSquire is a Google Tasks squire. More explicitly, it is one more fucking tool
to handle all the fucking data. Its main purpose is to export/import tasks
across accounts and as a side effect it has powers to create, read, update and
delete those tasks too.

A commandline interface is provided and can be used to dump tasklists to files
also to import them on another account. It also has commands to create, read,
update and delete tasks and tasklists, so you feel a real hacker reading and
writing stuff on a black screen.

Lastly, and of course, it can be used as a library.

Now you should be aware that you could come up with very creative ways to write
and manage a shitload more of data, and everyone is expected to do it, right?

_Remember kids: data, like [Ubik](http://en.wikipedia.org/wiki/Ubik), is
everywhere. Take as directed and do not exceed recommended dosage._

## I want to deal with a shitload more of data

* Instantiate an {GSquire::Application#initialize Application} and access its
  `accounts` (instance attribute)
* Access the {GSquire::Accounts#authorize_url authorization url} and
  {GSquire::Accounts#authorize! add} an account
* Embrace and {GSquire::Accounts#[] hold} that account
* Keep pushing the {GSquire::Client#create_task bright},
  {GSquire::Client#create_tasklist shiny}, {GSquire::Client#delete_tasklist
  colorful}, {GSquire::Client#task tasty}, {GSquire::Client#tasklist nice},
  {GSquire::Client#tasklists chuncky bacon}, {GSquire::Client#tasks pretty} and
  {GSquire::Client#update_tasklist amazing} buttons!

## I want to deal with a shitload more of data from a black screen

* Turn off the lights (enhances special effects)
* Take the **red** pill (special effects begin)
* As fast as you can, type `gsquire help`
