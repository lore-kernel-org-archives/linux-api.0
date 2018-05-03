From: Christian Brauner <christian.brauner@canonical.com>
Subject: Re: [PATCH 0/6 resend] statfs: handle mount propagation
Date: Thu, 3 May 2018 15:57:41 +0200
Message-ID: <CAPP7u0Vy8KL1GMSFuH4UYV5JFYLLz8iJvNtq2Pp84UjmvkuNYw@mail.gmail.com>
References: <20180502154239.14013-1-christian.brauner@ubuntu.com>
 <20180502160939.GU30522@ZenIV.linux.org.uk> <CAPP7u0VPyWAsL_kkb4JnJHMmK=kM0m4zRjVjst1iHDd6V=t0mQ@mail.gmail.com>
 <20180503134317.GA30522@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180503134317.GA30522@ZenIV.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <christian.brauner@canonical.com>, Linus Torvalds <torvalds@linux-foundation.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>, Thomas Gleixner <tglx@linutronix.de>, Kate Stewart <kstewart@linuxfoundation.org>, Greg KH <gregkh@linuxfoundation.org>, Philippe Ombredanne <pombredanne@nexb.com>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Thu, May 03, 2018 at 02:43:17PM +0100, Al Viro wrote:
> On Thu, May 03, 2018 at 03:04:36PM +0200, Christian Brauner wrote:
>
> > >From a userspace perspective we often run into the case where we simply
> > want to know whether a given mountpoint is MS_SHARED or is MS_SLAVE.
> > If it is we remount it as MS_PRIVATE to prevent any propagation from
> > happening. We don't care about the peer relationship or how the
> > propagation is exactly setup. We only want to prevent any propagation
> > from happening.
>
> So what's to stop you from doing exactly that --
> mount(NULL, "/", NULL, MS_PRIVATE | MS_REC, NULL)
> without bothering with statfs() in the first place?  It's not like the
> damn thing had been costly - it's O(mounts in your namespace) with not
> to high constant, and in any case cheaper than allocating all of them
> back when you did clone(2).  Confused...

That's the case for the whole rootfs. But there are cases where I want
to leave the rootfs itself alone and only remount some paths.

>
> > The above case is what I see most often. A more specific use-case is to
> > differentiate between MS_SLAVE and MS_SHARED mountpoints.
> > Mountpoints that are MS_SLAVE are kept intact and mountpoints that are
> > MS_SHARED are made MS_PRIVATE.
> >
> > For both cases the only way to do this right now is by parsing
> > /proc/<pid>/mountinfo. Yes, it is doable but still it is somewhat costly
> > and annoying as e.g. those mount propagation fields are optional.
>
> Umm...  And how would you get the list of mountpoints to feed to statfs()
> if not by parsing mountinfo?  IDGI...

There are cases where you have list of known-mountpoints or paths to
check but you don't necessarily know whether they are MS_SHARED or
MS_SLAVE.

There's also a case where I send a list of fds via SCM_RIGHTS to an
isolated process that calls fstatvfs() on these fds to determine their
mount flags without changing them but cache this info.

Christian
