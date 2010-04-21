From: ebiederm@xmission.com (Eric W. Biederman)
Subject: Re: [PATCH 3/3] p9auth: add p9auth driver
Date: Tue, 20 Apr 2010 21:45:02 -0700
Message-ID: <m1zl0xo1m9.fsf@fess.ebiederm.org>
References: <20100421012749.GA21338@us.ibm.com>
	<20100421012908.GB24251@us.ibm.com> <20100421030406.GB10258@kroah.com>
	<20100421034532.GA9254@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <20100421034532.GA9254@us.ibm.com> (Serge E. Hallyn's message of "Tue\, 20 Apr 2010 22\:45\:32 -0500")
Sender: linux-security-module-owner@vger.kernel.org
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: Greg KH <greg@kroah.com>, lkml <linux-kernel@vger.kernel.org>, David Howells <dhowells@redhat.com>, Ashwin Ganti <ashwin.ganti@gmail.com>, rsc@swtch.com, ericvh@gmail.com, linux-security-module@vger.kernel.org, Ron Minnich <rminnich@gmail.com>, jt.beard@gmail.com, Andrew Morton <akpm@linux-foundation.org>, Andrew Morgan <morgan@kernel.org>, oleg@us.ibm.com, Eric Paris <eparis@redhat.com>, linux-api@vger.kernel.org, Randy Dunlap <rdunlap@xenotime.net>
List-Id: linux-api@vger.kernel.org

"Serge E. Hallyn" <serue@us.ibm.com> writes:

> Quoting Greg KH (greg@kroah.com):
>> On Tue, Apr 20, 2010 at 08:29:08PM -0500, Serge E. Hallyn wrote:
>> > This is a driver that adds Plan 9 style capability device
>> > implementation.  See Documentation/p9auth.txt for a description
>> > of how to use this.
>> 
>> Hm, you didn't originally write this driver, so it would be good to get
>> some original authorship information in here to keep everything correct,
>> right?
>
> That's why I left the MODULE_AUTHOR line in there - not sure what
> else to do for that.  I'll add a comment in p9auth.txt, especially
> pointing back to Ashwin's original paper.
>
>> >  Documentation/p9auth.txt     |   47 ++++
>> >  drivers/char/Kconfig         |    2 +
>> >  drivers/char/Makefile        |    2 +
>> >  drivers/char/p9auth/Kconfig  |    9 +
>> >  drivers/char/p9auth/Makefile |    1 +
>> >  drivers/char/p9auth/p9auth.c |  517 ++++++++++++++++++++++++++++++++++++++++++
>> 
>> Is this code really ready for drivers/char/?  What has changed in it
>> that makes it ok to move out of the staging tree?
>
> It was dropped from staging :)  I don't particularly care to see it
> go back into staging, as opposed to working out issues out of tree
> (assuming they are solvable).  For one thing, as you note below,
> there is the question of whether it should be a device driver at
> all.
>
>> And who is going to maintain it?  You?  Or someone else?
>
> If Ashwin doesn't want to maintain it, I'll do it.  Either way.
>
>> >  6 files changed, 578 insertions(+), 0 deletions(-)
>> >  create mode 100644 Documentation/p9auth.txt
>> >  create mode 100644 drivers/char/p9auth/Kconfig
>> >  create mode 100644 drivers/char/p9auth/Makefile
>> >  create mode 100644 drivers/char/p9auth/p9auth.c
>> > 
>> > diff --git a/Documentation/p9auth.txt b/Documentation/p9auth.txt
>> > new file mode 100644
>> > index 0000000..14a69d8
>> > --- /dev/null
>> > +++ b/Documentation/p9auth.txt
>> > @@ -0,0 +1,47 @@
>> > +The p9auth device driver implements a plan-9 factotum-like
>> > +capability API.  Tasks which are privileged (authorized by
>> > +possession of the CAP_GRANT_ID privilege (POSIX capability))
>> > +can write new capabilities to /dev/caphash.  The kernel then
>> > +stores these until a task uses them by writing to the
>> > +/dev/capuse device.  Each capability represents the ability
>> > +for a task running as userid X to switch to userid Y and
>> > +some set of groups.  Each capability may be used only once,
>> > +and unused capabilities are cleared after two minutes.
>> > +
>> > +The following examples shows how to use the API.  Shell 1
>> > +contains a privileged root shell.  Shell 2 contains an
>> > +unprivileged shell as user 501 in the same user namespace.  If
>> > +not already done, the privileged shell should create the p9auth
>> > +devices:
>> > +
>> > +	majfile=/sys/module/p9auth/parameters/cap_major
>> > +	minfile=/sys/module/p9auth/parameters/cap_minor
>> > +	maj=`cat $majfile`
>> > +	mknod /dev/caphash c $maj 0
>> > +	min=`cat $minfile`
>> > +	mknod /dev/capuse c $maj 1
>> > +	chmod ugo+w /dev/capuse
>> 
>> That is incorrect, you don't need the cap_major/minor files at all, the
>> device node should be automatically created for you, right?
>
> Hmm, where?  Not in /dev on my SLES11 partition...
>
>> And do you really want to do all of this control through a device node?
>> Why?
>
> Well...
>
> At first I was thinking same as you were.  So I was going to switch
> to a pure syscall-based approach.  But it just turned out more
> complicated.  The factotum server would call sys_grantid(), and
> the target task would end up doing some huge sys_setresugid() or
> else multiple syscalls using the granted id.  It just was uglier.
> I think there's an experimental patchset sitting somewhere I could
> point to (if I weren't embarassed :).
>
> Another possibility would be to use netlink, but that doesn't
> appear as amenable to segragation by user namespaces.  The pid
> (presumably/hopefully global pid, as __u32) is available, so it
> shouldn't be impossible, but a simple device with simple synchronous
> read/write certainly has its appeal.  Firing off a message hoping
> that at some point our credentials will be changes, less so.

pid in the netlink context is the netlink port-id.  It is a very
different concept from struct pid.  These days netlink calls to
the kernel are synchronous, not that I would encourage netlink
for anything except networking code.

Can we make this a trivial filesystem?  I expect that would match
up better with whatever plan9 userspace apps already exist,
remove the inode double translation, and would make it much more
reasonable to do a user namespace aware version  if and when
that becomes necessary.

Eric
