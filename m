From: Andres Freund <andres@anarazel.de>
Subject: Re: [RFC PATCH 00/14] pipe: Keyrings, Block and USB notifications
 [ver #3]
Date: Mon, 10 Feb 2020 16:56:26 -0800
Message-ID: <20200211005626.7yqjf5rbs3vbwagd@alap3.anarazel.de>
References: <157909503552.20155.3030058841911628518.stgit@warthog.procyon.org.uk>
 <CAHk-=wjrrOgznCy3yUmcmQY1z_7vXVr6GbvKiy8cLvWbxpmzcw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAHk-=wjrrOgznCy3yUmcmQY1z_7vXVr6GbvKiy8cLvWbxpmzcw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Howells <dhowells@redhat.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Casey Schaufler <casey@schaufler-ca.com>, Stephen Smalley <sds@tycho.nsa.gov>, Nicolas Dichtel <nicolas.dichtel@6wind.com>, Ian Kent <raven@themaw.net>, Christian Brauner <christian@brauner.io>, keyrings@vger.kernel.org, linux-usb@vger.kernel.org, linux-block <linux-block@vger.kernel.org>, LSM List <linux-security-module@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

Hi,

I only just now noticed this work after Dave Chinner pointed towards the
feature in the email leading to
https://lore.kernel.org/linux-fsdevel/20200211000405.5fohxgpt554gmnhu@alap3.anarazel.de/

On 2020-01-15 12:10:32 -0800, Linus Torvalds wrote:
> So I no longer hate the implementation, but I do want to see the
> actual user space users come out of the woodwork and try this out for
> their use cases.

Postgres has been looking for something roughly like this, fwiw (or
well, been forced to).

While it's better than it used to be (due to b4678df184b3), we still
have problems to reliably detect buffered IO errors, especially when
done across multiple processes.  We can't easily keep an fd open that
predates all writes to a file until, and ensure that fsyncs will happen
only on that fd. The primary reasons for that are
1) every connection (& some internal jobs) is a process, and neither do
want to to fsyncing each touched file in short-lived connections, nor is
it desirable to have to add the complication of having to transfer fds
between processes just to reliably get an error in fsync().
2) we have to cope with having more files open than allowed, so we have
a layer that limits the number of OS level FDs open at the same time. We
don't want to fsync whenever we have to juggle open fds though, as
that'd be too costly.

So it'd good to have a way to *reliably* know when writeback io failed,
so we can abort a checkpoint if necessary, and instead perform journal
replay.


For our purposes we'd probably want errors on the fs/superblock level,
rather than block devices. It's not always easy to map between blockdevs
and relevant filesystems, there are errors above the block layer, and we
definitely don'tt want to crash & restart a database just because
somebody pulled an USB storage device that didn't have any of the
database's data on it.

An earlier version of this patchset had some support for that, albeit
perhaps not fully implemented (no errors raised, afaict?):
https://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-fs.git/commit/?h=notifications&id=338eec77a0cb29a7d2ae9350066c1990408ae58e

Is the plan to pick this up again once the basic feature is in?


A few notes from the email referenced above (that actually seem to belong
into this thread more than the other:

1) From the angle of reliably needing to detect writeback errors, I find it
somewhat concerning that an LSM may end up entirely filtering away error
notifications, without a consumer being able to detect that:

+void __post_watch_notification(struct watch_list *wlist,
+			       struct watch_notification *n,
+			       const struct cred *cred,
+			       u64 id)
+{
...
+		if (security_post_notification(watch->cred, cred, n) < 0)
+			continue;

It's an unpleasant thought that an overly restrictive [-ly configured]
LSM could lead to silently swallowing data integrity errors.

2) It'd be good if there were documentation, aimed at userland consumers
of this, explaining what the delivery guarantees are. To be useful for
us, it needs to be guaranteed that consuming all notifications ensures
that there are no pending notifications queued up somewhere (so we can
do fsync(data); fsync(journal); check_for_errors();
durable_rename(checkpoint_state.tmp, checkpoint_state);).

3) What will the permission model for accessing the notifications be?
It seems currently anyone, even within a container/namespace or
something, will see blockdev errors from everywhere?  The earlier
superblock support (I'm not sure I like that name btw, hard to
understand for us userspace folks), seems to have required exec
permission, but nothing else.

Greetings,

Andres Freund
