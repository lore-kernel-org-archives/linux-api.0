From: David Howells <dhowells@redhat.com>
Subject: Re: [RFC PATCH 04/14] pipe: Add O_NOTIFICATION_PIPE [ver #2]
Date: Thu, 07 Nov 2019 18:48:37 +0000
Message-ID: <6964.1573152517@warthog.procyon.org.uk>
References: <CALCETrUka9KaOKFbNKUXcA6XvoFxiXPftctSHtN4DL35Cay61w@mail.gmail.com> <157313371694.29677.15388731274912671071.stgit@warthog.procyon.org.uk> <157313375678.29677.15875689548927466028.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CALCETrUka9KaOKFbNKUXcA6XvoFxiXPftctSHtN4DL35Cay61w@mail.gmail.com>
Content-ID: <6963.1573152517.1@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@kernel.org>
Cc: dhowells@redhat.com, Linus Torvalds <torvalds@linux-foundation.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Casey Schaufler <casey@schaufler-ca.com>, Stephen Smalley <sds@tycho.nsa.gov>, Nicolas Dichtel <nicolas.dichtel@6wind.com>, raven@themaw.net, Christian Brauner <christian@brauner.io>, keyrings@vger.kernel.org, USB list <linux-usb@vger.kernel.org>, linux-block <linux-block@vger.kernel.org>, LSM List <linux-security-module@vger.kernel.org>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

Andy Lutomirski <luto@kernel.org> wrote:

> > Add an O_NOTIFICATION_PIPE flag that can be passed to pipe2() to indica=
te
> > that the pipe being created is going to be used for notifications.  Thi=
s
> > suppresses the use of splice(), vmsplice(), tee() and sendfile() on the
> > pipe as calling iov_iter_revert() on a pipe when a kernel notification
> > message has been inserted into the middle of a multi-buffer splice will=
 be
> > messy.
>
> How messy?

Well, iov_iter_revert() on a pipe iterator simply walks backwards along the
ring discarding the last N contiguous slots (where N is normally the number=
 of
slots that were filled by whatever operation is being reverted).

However, unless the code that transfers stuff into the pipe takes the spinl=
ock
spinlock and disables softirqs for the duration of its ring filling, what w=
ere
N contiguous slots may now have kernel notifications interspersed - even if=
 it
has been holding the pipe mutex.

So, now what do you do?  You have to free up just the buffers relevant to t=
he
iterator and then you can either compact down the ring to free up the space=
 or
you can leave null slots and let the read side clean them up, thereby
reducing the capacity of the pipe temporarily.

Either way, iov_iter_revert() gets more complex and has to hold the spinloc=
k.

And if you don't take the spinlock whilst you're reverting, more notificati=
ons
can come in to make your life more interesting.

There's also a problem with splicing out from a notification pipe that the
messages are scribed onto preallocated buffers, but now the buffers need
refcounts and, in any case, are of limited quantity.

> And is there some way to make it impossible for this to happen?

Yes.  That's what I'm doing by declaring the pipe to be unspliceable up fro=
nt.

> Adding a new flag to pipe2() to avoid messy kernel code seems
> like a poor tradeoff.

By far the easiest place to check whether a pipe can be spliced to is in
get_pipe_info().  That's checking the file anyway.  After that, you can't m=
ake
the check until the pipe is locked.

Furthermore, if it's not done upfront, the change to the pipe might happen
during a splicing operation that's residing in pipe_wait()... which drops t=
he
pipe mutex.

David
