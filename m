From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH 0/6 resend] statfs: handle mount propagation
Date: Thu, 3 May 2018 14:43:17 +0100
Message-ID: <20180503134317.GA30522@ZenIV.linux.org.uk>
References: <20180502154239.14013-1-christian.brauner@ubuntu.com>
 <20180502160939.GU30522@ZenIV.linux.org.uk>
 <CAPP7u0VPyWAsL_kkb4JnJHMmK=kM0m4zRjVjst1iHDd6V=t0mQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAPP7u0VPyWAsL_kkb4JnJHMmK=kM0m4zRjVjst1iHDd6V=t0mQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Christian Brauner <christian.brauner@canonical.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-fsdevel@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, hch@infradead.org, tglx@linutronix.de, kstewart@linuxfoundation.org, Greg KH <gregkh@linuxfoundation.org>, pombredanne@nexb.com, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Thu, May 03, 2018 at 03:04:36PM +0200, Christian Brauner wrote:

> >From a userspace perspective we often run into the case where we simply
> want to know whether a given mountpoint is MS_SHARED or is MS_SLAVE.
> If it is we remount it as MS_PRIVATE to prevent any propagation from
> happening. We don't care about the peer relationship or how the
> propagation is exactly setup. We only want to prevent any propagation
> from happening.

So what's to stop you from doing exactly that --
	mount(NULL, "/", NULL, MS_PRIVATE | MS_REC, NULL)
without bothering with statfs() in the first place?  It's not like the
damn thing had been costly - it's O(mounts in your namespace) with not
to high constant, and in any case cheaper than allocating all of them
back when you did clone(2).  Confused...

> The above case is what I see most often. A more specific use-case is to
> differentiate between MS_SLAVE and MS_SHARED mountpoints.
> Mountpoints that are MS_SLAVE are kept intact and mountpoints that are
> MS_SHARED are made MS_PRIVATE.
> 
> For both cases the only way to do this right now is by parsing
> /proc/<pid>/mountinfo. Yes, it is doable but still it is somewhat costly
> and annoying as e.g. those mount propagation fields are optional.

Umm...  And how would you get the list of mountpoints to feed to statfs()
if not by parsing mountinfo?  IDGI...
