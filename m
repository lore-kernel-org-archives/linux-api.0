From: Andy Lutomirski <luto@kernel.org>
Subject: Re: [RFC PATCH 04/14] pipe: Add O_NOTIFICATION_PIPE [ver #2]
Date: Thu, 7 Nov 2019 21:06:53 -0800
Message-ID: <CALCETrWeN9CGJHz0dzG1uH5Qjbr+xG3OKZuEd33eBY_rAzVkqQ@mail.gmail.com>
References: <157313371694.29677.15388731274912671071.stgit@warthog.procyon.org.uk>
 <157313375678.29677.15875689548927466028.stgit@warthog.procyon.org.uk>
 <CALCETrUka9KaOKFbNKUXcA6XvoFxiXPftctSHtN4DL35Cay61w@mail.gmail.com> <6964.1573152517@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <6964.1573152517@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: Andy Lutomirski <luto@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Casey Schaufler <casey@schaufler-ca.com>, Stephen Smalley <sds@tycho.nsa.gov>, Nicolas Dichtel <nicolas.dichtel@6wind.com>, raven@themaw.net, Christian Brauner <christian@brauner.io>, keyrings@vger.kernel.org, USB list <linux-usb@vger.kernel.org>, linux-block <linux-block@vger.kernel.org>, LSM List <linux-security-module@vger.kernel.org>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Thu, Nov 7, 2019 at 10:48 AM David Howells <dhowells@redhat.com> wrote:
>
> Andy Lutomirski <luto@kernel.org> wrote:
>
> > > Add an O_NOTIFICATION_PIPE flag that can be passed to pipe2() to indicate
> > > that the pipe being created is going to be used for notifications.  This
> > > suppresses the use of splice(), vmsplice(), tee() and sendfile() on the
> > > pipe as calling iov_iter_revert() on a pipe when a kernel notification
> > > message has been inserted into the middle of a multi-buffer splice will be
> > > messy.
> >
> > How messy?
>
> Well, iov_iter_revert() on a pipe iterator simply walks backwards along the
> ring discarding the last N contiguous slots (where N is normally the number of
> slots that were filled by whatever operation is being reverted).
>
> However, unless the code that transfers stuff into the pipe takes the spinlock
> spinlock and disables softirqs for the duration of its ring filling, what were
> N contiguous slots may now have kernel notifications interspersed - even if it
> has been holding the pipe mutex.
>
> So, now what do you do?  You have to free up just the buffers relevant to the
> iterator and then you can either compact down the ring to free up the space or
> you can leave null slots and let the read side clean them up, thereby
> reducing the capacity of the pipe temporarily.
>
> Either way, iov_iter_revert() gets more complex and has to hold the spinlock.

I feel like I'm missing something fundamental here.

I can open a normal pipe from userspace (with pipe() or pipe2()), and
I can have two threads.  One thread writes to the pipe with write().
The other thread writes with splice().  Everything works fine.  What's
special about notifications?
