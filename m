From: ebiederm@xmission.com (Eric W. Biederman)
Subject: Re: [PATCH v2] firmware: fix sending -ERESTARTSYS due to signal on fallback
Date: Fri, 26 May 2017 06:09:29 -0500
Message-ID: <87fufr3mdy.fsf@xmission.com>
References: <20170524205658.GK8951@wotan.suse.de>
        <20170524214027.7775-1-mcgrof@kernel.org>
        <CALCETrXUrirO-vg3M+MGhn=0gZTwx0phsRDS4TCwWWgNYC6RsA@mail.gmail.com>
        <CAB=NE6VENGmTEZ3_8EWmv6bhT81k=szg0_POWJm2SP+V21CeBw@mail.gmail.com>
        <CALCETrU4__YUGk36PN=FbuEf0SBaTrxQQqm4sWs2NrZ+6WN7jA@mail.gmail.com>
        <CANh8QzwPb_+RKs5QVt7mdFk8h_rOMVS3j9m0OADgvzBtNqBBLg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CANh8QzwPb_+RKs5QVt7mdFk8h_rOMVS3j9m0OADgvzBtNqBBLg@mail.gmail.com>
        (Martin Fuzzey's message of "Thu, 25 May 2017 10:28:38 +0200")
Sender: linux-kernel-owner@vger.kernel.org
To: "Fuzzey, Martin" <mfuzzey@parkeon.com>
Cc: Andy Lutomirski <luto@kernel.org>, "Luis R. Rodriguez" <mcgrof@kernel.org>, "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>, Linux API <linux-api@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>, Greg KH <gregkh@linuxfoundation.org>, Daniel Wagner <wagi@monom.org>, David Woodhouse <dwmw2@infradead.org>, jewalt@lgsinnovations.com, rafal@milecki.pl, Arend Van Spriel <arend.vanspriel@broadcom.com>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, "Li, Yi" <yi1.li@linux.intel.com>, atull@opensource.altera.com, Moritz Fischer <moritz.fischer@ettus.com>, Petr Mladek <pmladek@suse.com>, Johannes Berg <johannes.berg@intel.com>, Emmanuel Grumbach <emmanuel.grumbach@intel.com>, Luca Coelho <luciano.coelho@intel.com>, Kalle Valo <kvalo@codeaurora.org>
List-Id: linux-api@vger.kernel.org

"Fuzzey, Martin" <mfuzzey@parkeon.com> writes:

> On 25 May 2017 at 06:13, Andy Lutomirski <luto@kernel.org> wrote:
>>>>
>>>> Can you give a simple example of what's going on and why it matters?
>>>>
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
> 5) A child dies and raises SIGCHLD
> 6) wait_for_completion_interruptible() returns -ERESTARTSYS due to the signal
> 7) request_firmware() [before this patch] translated that to -EAGAIN
> 8) The driver (in my case) ignored this [because the firmware was not
> critical - it was for checking if a microcontroler was up to date]
> (but it could have returned it to userspace, same problem)
>
> The point being that, due to a signal (SIGCHLD) which has nothing to
> do with the firmware loading process, the firmware load was not done.
> Also EAGAIN is the same error used if the load request times out so it
> was impossible to distinguish the two cases.
>
> ERESTARTSYS is an internal error and is not returned to userspace.
> Instead it is handled by the linux syscall machinery which, after
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
> 9) The system call machinery invokes the signal handler
> 10) The signal handler does its stuff
> 11) Because SA_RESTART was set the system call is restarted (calling
> the sysfs .store) and we try it all again from step 2
>
> Note that, on the the userspace side  write() is only called once (the
> restart is transparent to userspace which is oblivious to all this)
> The kernel side write() (which calls .store() is called multiple times
> (so that code does need to know about this)
>
>
>>>> ERESTARTSYS and friends are highly magical, and I'm not convinced that
>>>> allowing _request_firmware_load to return -ERESTARTSYS is actually a
>>>> good idea.  What if there are system calls that can't handle this
>>>> style of restart that start being restarted as a result?
>>>
>
> If the caller is unable to restart (for example if the driver's
> .store() callback had already done lots of stuff that couldn't be
> undone) it is free to translate -ERSTARTSYS to -EINTR before
> returning.
> But request_frimware() can't know about that.
>
>
>>>> Maybe SIGCHLD shouldn't interrupt firmware loading?
>
> I don't think there's a way of doing that without disabling all
> signals (ie using the non interruptible wait variants).
> It used to be that way (which is why I only ran into this after
> updating from an ancient 3.16 kernel to a slightly less ancient 4.4)
> But there are valid reasons for wanting to be able to interrupt
> firmware loading (like being able to kill the userspace helper)

Perhaps simply using a killable wait and not a fully interruptible
wait would be better?

It sounds like the code really is not prepared for an truly
interruptible wait here.

Eric
