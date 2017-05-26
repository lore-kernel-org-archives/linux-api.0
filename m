From: "Fuzzey, Martin" <mfuzzey-mB3Nsq4MPf1BDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH v2] firmware: fix sending -ERESTARTSYS due to signal on fallback
Date: Fri, 26 May 2017 22:23:03 +0200
Message-ID: <CANh8QzyqQ5hubWJvWYxgoQ3baL6sgoQPSzEHMY0tu8WNGS2gZA@mail.gmail.com>
References: <20170524205658.GK8951@wotan.suse.de> <20170524214027.7775-1-mcgrof@kernel.org>
 <CALCETrXUrirO-vg3M+MGhn=0gZTwx0phsRDS4TCwWWgNYC6RsA@mail.gmail.com>
 <CAB=NE6VENGmTEZ3_8EWmv6bhT81k=szg0_POWJm2SP+V21CeBw@mail.gmail.com>
 <CALCETrU4__YUGk36PN=FbuEf0SBaTrxQQqm4sWs2NrZ+6WN7jA@mail.gmail.com>
 <CANh8QzwPb_+RKs5QVt7mdFk8h_rOMVS3j9m0OADgvzBtNqBBLg@mail.gmail.com> <20170526194001.GR8951@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170526194001.GR8951-B4tOwbsTzaBolqkO4TVVkw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Luis R. Rodriguez" <mcgrof-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Nicolas <nbroeking-BUHhN+a2lJ4@public.gmane.org>, John Ewalt <jewalt-d4N2ExZK1jaSe5ORCPIMD9BPR1lH4CV8@public.gmane.org>, Dmitry Torokhov <dmitry.torokhov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Daniel Wagner <wagi-kQCPcA+X3s7YtjvyW6yDsg@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, rafal-g1n6cQUeyibVItvQsEIGlw@public.gmane.org, Arend Van Spriel <arend.vanspriel-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, "Rafael J. Wysocki" <rjw-LthD3rsA81gm4RdzfppkhA@public.gmane.org>, "Li, Yi" <yi1.li-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, atull-yzvPICuk2ABMcg4IHK0kFoH6Mc4MB0Vx@public.gmane.org, Moritz Fischer <moritz.fischer-+aYTwkv1SeIAvxtiuMwx3w@public.gmane.org>, Petr Mladek <pmladek-IBi9RG/b67k@public.gmane.org>, Johannes Berg <johannes.berg-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Luca Coelho <luciano.coelho-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Emmanu
List-Id: linux-api@vger.kernel.org

On 26 May 2017 at 21:40, Luis R. Rodriguez <mcgrof-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> On Thu, May 25, 2017 at 10:28:38AM +0200, Fuzzey, Martin wrote:
>> On 25 May 2017 at 06:13, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
>> >>>
>> >>> Can you give a simple example of what's going on and why it matters?
>> >>>
>>
>>
>> Here is the use case in which I ran into this problem.
>>
>> I have a driver which does request_firmware() when a write() is done
>> to a sysfs file.
>>
>> The write() was being done by an android init script (with the init
>> interpreter "write" command).
>> init, of course, forks lots of processes and some of the children die.
>>
>> So the scenario was the following:
>>
>
> No no, this is not how the fallback system works.
>

I was (implicitly) describing the fallback mechanism.
Indeed as you say the kernel now first tries to load the firmware
itself without involving userspace.
I'm describing what happens *after* this fails and the kernel falls
back to userspace

The sysfs file I was talking about is *not* the sysfs file involved in
the firmware loading mechanism
but a *custom* sysfs file used by a driver to *trigger* the call to
request_firmware() [synchronous] in the first place.

That is, my driver does not do request_firmware() in its probe()
function like most but when requested by
userspace. That's a valid usage as far as I can tell. Nothing says
request_firmware() is only allowed from probe.

Not sure it is relevant here but here's the reason for doing it this
way: (skip this bit if not interested)
I have a small microcontroller used to manage the power to the main CPU.
It is connected to the CPU by a GPIO line.
On power up the microcrontroller powers up the main CPU and starts a timer.
If the application doesn't start in time the microcontroller power
cycles the CPU.

In addition to the the above the microcontroller is connected to the
CPU by a I2C bus for various other functions
including firmware update (of the microcontroller software).
In order to keep the critical power up code on the microcontroller
very simple the I2C connection is not available
until *after* the power up confirmation by the GPIO line.

So, on the linux side, there is a custom driver which exports a sysfs
entry that userspace writes to in order to confirm
startup.
The driver, when that sysfs file is written to, first sets the GPIO
line to signal the microcontroller that the application has
started so it can stop its timer and activate the I2C interface. Then
it does a request_firmware() to obtain the firmware
the microcontroler is supposed to have. It then verifies it using
commands over I2C to compare checksums etc and
updates it if needed.


>> 5) A child dies and raises SIGCHLD
>
> What child? The process doing the write() ?
>
A child of the process doing the write on the drivers custom sysfs
entry that triggered the request_firmware()

> Martin seems to be arguing -ERESTARTSYS should be sent back instead given
> it is what the wait returned after all.
>

Yes


> If you're talking about a custom driver of sorts that triggered
> a request_firmware() call (note sync) then yes your earlier description
> is accurate and in this case as well the driver specific sysfs interface
> can end up returning the same error.
>

Exactly


> If this file is custom then its up to you to decide what you want
> for error on that file, but for the firmware_class.c I do agree on
> returning an agreed upon error so drivers can Do The Right Thing (TM).
>

Yes


>> 9) The system call machinery invokes the signal handler
>> 10) The signal handler does its stuff
>> 11) Because SA_RESTART was set the system call is restarted (calling
>> the sysfs .store) and we try it all again from step 2
>
> OK so this seems to reveal an internal working of some android
> loader of some sort. Thanks.
>

Nothing Android specific here.

This is the standard *linux* behaviour.
The retry is done *in the kernel* not on the android userspace side


>> Note that, on the the userspace side  write() is only called once
>
> The write is to the custom driver trigger which calls request_firmware() ?
>

Yes



> This could mean we get a loop on finit_module() if a signal is detected
> on firmware_request() on every call. Is that fine? Is it expected ?

Ok so here we are talking about the standard case of
request_firmware() being called from probe()
If the driver is a loadable module then yes the it will be retried.
If it gets a signal on every try then something else is wrong I'd say

If the driver is compiled in then there is no retry since the call to probe
doesn't go through the syscall machinary. But there shouldn't be a
signal either in that
case since it's not being called from a userspace process in that case.

> So you seem to be suggesting the driver's should decide to mask or
> not -ERSTARTSYS.
>

Only if the driver knows that it is not restartable *itself*.
Shoudn't happen very often


Martin
