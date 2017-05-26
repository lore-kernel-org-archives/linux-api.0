From: "Luis R. Rodriguez" <mcgrof-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2] firmware: fix sending -ERESTARTSYS due to signal on
 fallback
Date: Fri, 26 May 2017 21:40:01 +0200
Message-ID: <20170526194001.GR8951@wotan.suse.de>
References: <20170524205658.GK8951@wotan.suse.de>
 <20170524214027.7775-1-mcgrof@kernel.org>
 <CALCETrXUrirO-vg3M+MGhn=0gZTwx0phsRDS4TCwWWgNYC6RsA@mail.gmail.com>
 <CAB=NE6VENGmTEZ3_8EWmv6bhT81k=szg0_POWJm2SP+V21CeBw@mail.gmail.com>
 <CALCETrU4__YUGk36PN=FbuEf0SBaTrxQQqm4sWs2NrZ+6WN7jA@mail.gmail.com>
 <CANh8QzwPb_+RKs5QVt7mdFk8h_rOMVS3j9m0OADgvzBtNqBBLg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CANh8QzwPb_+RKs5QVt7mdFk8h_rOMVS3j9m0OADgvzBtNqBBLg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Fuzzey, Martin" <mfuzzey-mB3Nsq4MPf1BDgjK7y7TUQ@public.gmane.org>, Nicolas <nbroeking-BUHhN+a2lJ4@public.gmane.org>, Dmitry Torokhov <dmitry.torokhov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Luis R. Rodriguez" <mcgrof-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Daniel Wagner <wagi-kQCPcA+X3s7YtjvyW6yDsg@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, jewalt-d4N2ExZK1jaSe5ORCPIMD9BPR1lH4CV8@public.gmane.org, rafal-g1n6cQUeyibVItvQsEIGlw@public.gmane.org, Arend Van Spriel <arend.vanspriel-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, "Rafael J. Wysocki" <rjw-LthD3rsA81gm4RdzfppkhA@public.gmane.org>, "Li, Yi" <yi1.li-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, atull-yzvPICuk2ABMcg4IHK0kFoH6Mc4MB0Vx@public.gmane.org, Moritz Fischer <moritz.fischer-+aYTwkv1SeIAvxtiuMwx3w@public.gmane.org>, Petr Mladek <pmladek-IBi9RG/b67k@public.gmane.org>, Johannes Berg <johannes.berg-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Luca Coelho <luciano.coelho-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Emmanuel Grumbach <emmanuel.grumbach-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Kalle Valo <kvalo-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, AK
List-Id: linux-api@vger.kernel.org

On Thu, May 25, 2017 at 10:28:38AM +0200, Fuzzey, Martin wrote:
> On 25 May 2017 at 06:13, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> >>>
> >>> Can you give a simple example of what's going on and why it matters?
> >>>
> 
> 
> Here is the use case in which I ran into this problem.
> 
> I have a driver which does request_firmware() when a write() is done
> to a sysfs file.
> 
> The write() was being done by an android init script (with the init
> interpreter "write" command).
> init, of course, forks lots of processes and some of the children die.
> 
> So the scenario was the following:
> 
> 1) Android init calls write() on the sysfs file
> 2) The sysfs .store() callback registered by a driver is called
> 3) The driver calls request_firmware()
> 4) request_firmware() sends the firmware load request to userspace and
> calls wait_for_completion_interruptible()

No no, this is not how the fallback system works.

Please have a look at the latest documentation revamp [0], in particular
the fallback mechanism [1], hopefully this clarifies other details you might
like to know about this first part.

Please note I *highly* encourage relying on the uevent fallback mechanism,
given the custom fallback mechanism has its own quirks and from my own review
I'd be pretty wary about using it.

[0] https://www.kernel.org/doc/html/latest/driver-api/firmware/index.html
[1] https://www.kernel.org/doc/html/latest/driver-api/firmware/fallback-mechanisms.html

Here is the correct summary:

1) Driver issues request_firmware()
2) firmware_class looks for the firmware on the local filesystem, if it
   does not find it and the fallback mechanism is enabled
   firmware_class issues uevent for the device that requested the firmware
3) Userspace is expected to be monitoring for these uevents and based on
   them should only *then* try a write() on the respective sysfs file.
4) The kernel actually uses swait_event_interruptible_timeout() as of
   v4.10 due to commit 5b029624948d6 ("firmware: do not use fw_lock for
   fw_state protection"), before it used wait_for_completion_interruptible_timeout().
   It uses this to *wait* for the sysfs write to complete, so can be
   woken up by it.

Please note we just uncovered another issue on firmware_class reported by
Nicolas when multiple cards are used and a signal of completion on sucesss or
error is not issued [2] for which John Ewalt has suggested a fix for [3].
I just reviewed this yesterday and determiend the swake_up()/swake_up_all()
fix is one atomic fix for 5b029624948d6 which moved us to swait given otherwise
we won't wake up all waiters on the same file. The wait stuff is used for
other means not well documented than the sysfs interface: if multiple 
requests come in for the same file we batch up these requests as one and
wait for a signal so we can rely on the same file fetch to write to the
pending request. Unfortunately I have discovered yesterday we have quite a
bit of fail paths that never sent the swake_up_all() (this would be
a completion on kernels older than v4.10) on *many* error paths. Note
though there is only one wait used and it uses:

	swait_event_interruptible_timeout()	>= v4.10
	wait_for_completion_interruptible_timeout() older

Since this is interruptible, and has a timeout it does mean if we have
a reboot the wait will be killed.

Since this wait also has a timeout it means we will have an end if
userspace never does anything.

5) Two sysfs files are exposed:

        /sys/$DEVPATH/loading
		echo 1 > loading # starts load
		echo 0 > loading # indicates load is done
				 # asking to load data to driver
		echo -1 > loading # indicates an error occured

For detail see firmware_loading_store(), note we check for fw_state_is_aborted()
before proceeding.

        /sys/$DEVPATH/data

For details see firmware_data_read(), note it checks for fw_state_is_done()
early on before proceeding. fw_state_is_done() includes an abort check:

static inline bool __fw_state_is_done(enum fw_status status)                    
{                                                                               
        return status == FW_STATUS_DONE || status == FW_STATUS_ABORTED;         
}   

[2] https://bugzilla.kernel.org/show_bug.cgi?id=195477
[3] https://bugzilla.kernel.org/attachment.cgi?id=256493&action=diff&collapsed=&headers=1&format=raw

> 5) A child dies and raises SIGCHLD

What child? The process doing the write() ?

If we have userspace doing a write() on the sysfs interface then
firmware_loading_store() gets kicked off, it should actually try to complete,
unless the singal was processed early in which case the write would bail early
on fw_state_is_done() check.

Otherwise I suppose the kernel can send a signal pending to the swait but
its not clear under what conditions exactly.

> 6) wait_for_completion_interruptible() returns -ERESTARTSYS due to the signal

That's for kernels older than v4.10, on >= v4.10 that would be
swait_event_interruptible_timeout() and I confirm -ERESTARTSYS can
be sent as a return value.

> 7) request_firmware() [before this patch] translated that to -EAGAIN

Right, this is today's default error if we fail on the wait. This error would
be returned to the *driver*. This is returned on _request_firmware_load() and
sent back to the request_firmware_*() call.

Martin seems to be arguing -ERESTARTSYS should be sent back instead given
it is what the wait returned after all.

> 8) The driver (in my case) ignored this [because the firmware was not
> critical - it was for checking if a microcontroler was up to date]
> (but it could have returned it to userspace, same problem)

I agree that using -EAGAIN for a signal is incorrect and we should propagate
something more reasonable to the driver, but also given that firmware loading
is typically a bad idea on init but is acceptable on probe, it could mean a
driver propagates this to userspace.

Another issue to consider here is drivers using request_firmware_nowait() may
not get an actual error passed down given the lack of semantics of the
firmware_class. This will be fixed later on the driver data API but for now
it means async callbacks can only infer what might have happened. The callback
must be revised in this light to ensure some sanity check is done of some sort.

So to say that the driver ignored it is saying that the sync call was used
for sure and we know that it ignored -EAGAIN. Is that the case ?

If not what driver was used that ignored -EAGAIN? If it was an async callback
no error value is passed and what you are dealing with is more of an issue
with lack of semantics in the callback very likely and the inability to
deal with error respectively.

So we have three separate issues here:

1) A driver's possible lack of propagation errors
2) The actual error returned by firmware_class and semantics on async callback
3) What errors we should send on syfs files if a file if interrupted or error

The gruseome TLDR details below.

=========================================================

1) A driver's possible lack of propagation errors

Given 2) drivers should take care to be pedantic about how they deal with
errors. In particular if an async callback is used, a signal received
may mean the callback can only check for NULL, and it can only infer if
an error occurred. If the driver deals with daisy chaining files it might
mean it could skip over files without treating fatal errors accordingly.

2) The actual error returned by firmware_class and semantics on async callback

The async callbacks only get NULL on the firmware passed if an error was
detected, it cannot know if a specific error actually occurred. Currently only
sync calls can get the actual -EAGAIN (and if we stich this the respective
-ERESTARTSYS). This will be fixed with the driver data API, as it allows
callbacks to get the actual error passed.

Also, since async callbacks can be used on probe, but we don't want to delay
boot and since init + probe() are batched together we tend to not want to wait
on probe, so this is why many drivers returns right away after an async
firmware call. Even though we have async probe now (and drivers can prefer
this) that still would mean userspace does not get the actual error value. Its
up to drivers to also be able to take down the driver on error if an async call
for fw is used and it fails. The actual error on an async call will only be
available in the future, right now only NULL is passed.

Care with the above lack of current semantics must be taken into account

A user API question still stands as to if we want to send -ERESTARTSYS to
drivers to potentially send back to userspace on driver load given this
can still be sent for sync calls today and we are sending -EAGAIN.

3) What errors we should send on syfs files if a file if interrupted or error

We could capture an error happened on any of the sysfs files by checking
the firwmware status. For instance fw_state_is_aborted() checks on
firmware_loading_store(); fw_state_is_done() on firmware_data_read();
or fw_state_is_done() check on firmware_data_write().

Right now the errors we pass vary. As an example firmware_data_write()
can fail with -ENODEV if for some reason a signal was sent and we
bailed early. That -EPERM on !capable(CAP_SYS_RAWIO) should probably
be changed to -EACCESS. The firmware_data_read() sends -ENODEV() on
error. firmware_loading_store() sends the size of the buffer passed
to us on error -- that seems like an issue.

> The point being that, due to a signal (SIGCHLD) which has nothing to
> do with the firmware loading process, the firmware load was not done.

Who gets SIGCHLD and how does this exactly get to swait_event_interruptible_timeout()
or wait_for_completion_interruptible_timeout() exactly ?

> Also EAGAIN is the same error used if the load request times out so it
> was impossible to distinguish the two cases.

I agree this is an issue.

> ERESTARTSYS is an internal error and is not returned to userspace.
> Instead it is handled by the linux syscall machinery which,

Not accurate, we just never pass it on the firmware_class.c on
swait_event_interruptible_timeout() error. In fact we mask all
errors to -EAGAIN, and if the timeout ran out we just send
-ETIMEDOUT. If the request was aborted early the error -ENOENT
is sent.

> after
> processing the signal either restarts (transpently to userspace) the
> syscall or returns EINTR to userspace (depending if the signal handler
> users SA_RESTART - see man 7 signal)
> 
> 
> With this patch here is what happens:
> 
> 1) Android init calls write() on the sysfs file
> 2) The sysfs .store() callback registered by a driver is called
> 3) The driver calls request_firmware()
> 4) request_firmware() sends the firmware load request to userspace and
> calls wait_for_completion_interruptible()
> 5) A child dies and raises SIGCHLD
> 6) wait_for_completion_interruptible() returns -ERESTARTSYS due to the signal
> 7) request_firmware() [with this patch] returns -ERESTARTSYS
> 8) The driver returns -ERSTARTSYS from its sysfs .store method

If you're talking about a custom driver of sorts that triggered
a request_firmware() call (note sync) then yes your earlier description
is accurate and in this case as well the driver specific sysfs interface
can end up returning the same error.

If this file is custom then its up to you to decide what you want
for error on that file, but for the firmware_class.c I do agree on
returning an agreed upon error so drivers can Do The Right Thing (TM).

> 9) The system call machinery invokes the signal handler
> 10) The signal handler does its stuff
> 11) Because SA_RESTART was set the system call is restarted (calling
> the sysfs .store) and we try it all again from step 2

OK so this seems to reveal an internal working of some android
loader of some sort. Thanks.

> Note that, on the the userspace side  write() is only called once

The write is to the custom driver trigger which calls request_firmware() ?

> (the
> restart is transparent to userspace which is oblivious to all this)
> The kernel side write() (which calls .store() is called multiple times
> (so that code does need to know about this)

Even if the signal is captured and -ERSTARTSYS is sent down to a custom
sysfs file trigger which called request_firmware(), if -ERSTARTSYS
triggers userspace to try again the old sysfs loader for the fallback
mechanism will not be available anymore, so actually I'd be surprised
if the retry designed by android works here. It *would* have to
retry the whole thing again, starting from the custom trigger.

> >>> ERESTARTSYS and friends are highly magical, and I'm not convinced that
> >>> allowing _request_firmware_load to return -ERESTARTSYS is actually a
> >>> good idea.  What if there are system calls that can't handle this
> >>> style of restart that start being restarted as a result?

Given the above explanation I see the concern now. In our case I believe a
valid concern would be sending -ERESTARTSYS to the system call finit_module()
given request_firmware() could be called on probe and if a stupid driver did a
sync call on probe it could potentially send -ERESTARTSYS down.

This could mean we get a loop on finit_module() if a signal is detected
on firmware_request() on every call. Is that fine? Is it expected ?

> If the caller is unable to restart (for example if the driver's
> .store() callback had already done lots of stuff that couldn't be
> undone) it is free to translate -ERSTARTSYS to -EINTR before
> returning.
> But request_frimware() can't know about that.

So you seem to be suggesting the driver's should decide to mask or
not -ERSTARTSYS.

Do we send -ERSTARTSYS on any other paths on finit_module() ?

> >>> Maybe SIGCHLD shouldn't interrupt firmware loading?
> 
> I don't think there's a way of doing that without disabling all
> signals (ie using the non interruptible wait variants).

It could be an option if we deem such API is needed.

> It used to be that way (which is why I only ran into this after
> updating from an ancient 3.16 kernel to a slightly less ancient 4.4)

Indeed and back then I think we only ever returned -ENOMEM on error !

> But there are valid reasons for wanting to be able to interrupt
> firmware loading (like being able to kill the userspace helper)

Let's call it the fallback mechanism, as we should. OK so if the
fallback helper is called I fail to see how this is detrimental,
we'd just timeout, no ?

  Luis
