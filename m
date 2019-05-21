From: Christian Brauner <christian@brauner.io>
Subject: Re: [PATCH 1/2] open: add close_range()
Date: Tue, 21 May 2019 18:41:42 +0200
Message-ID: <20190521164141.rbehqnghiej3gfua@brauner.io>
References: <20190521150006.GJ17978@ZenIV.linux.org.uk>
 <20190521113448.20654-1-christian@brauner.io>
 <28114.1558456227@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <28114.1558456227@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, jannh@google.com, fweimer@redhat.com, oleg@redhat.com, tglx@linutronix.de, torvalds@linux-foundation.org, arnd@arndb.de, shuah@kernel.org, tkjos@android.com, ldv@altlinux.org, miklos@szeredi.hu, linux-alpha@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-ia64@vger.kernel.org, linux-m68k@lists.linux-m68k.org, linux-mips@vger.kernel.org, linux-parisc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org, linux-sh@vger.kernel.org, sparclinux@vger.kernel.org, linux-xtensa@linux-xtensa.org, linux-arch@vger.kernel.org, linux-kselftest@vger.kernel.org, x86@kernel.org
List-Id: linux-api@vger.kernel.org

On Tue, May 21, 2019 at 05:30:27PM +0100, David Howells wrote:
> Al Viro <viro@zeniv.linux.org.uk> wrote:
> 
> > Umm...  That's going to be very painful if you dup2() something to MAX_INT and
> > then run that; roughly 2G iterations of bouncing ->file_lock up and down,
> > without anything that would yield CPU in process.
> > 
> > If anything, I would suggest something like
> > 
> > 	fd = *start_fd;
> > 	grab the lock
> >         fdt = files_fdtable(files);
> > more:
> > 	look for the next eviction candidate in ->open_fds, starting at fd
> > 	if there's none up to max_fd
> > 		drop the lock
> > 		return NULL
> > 	*start_fd = fd + 1;
> > 	if the fscker is really opened and not just reserved
> > 		rcu_assign_pointer(fdt->fd[fd], NULL);
> > 		__put_unused_fd(files, fd);
> > 		drop the lock
> > 		return the file we'd got
> > 	if (unlikely(need_resched()))
> > 		drop lock
> > 		cond_resched();
> > 		grab lock
> > 		fdt = files_fdtable(files);
> > 	goto more;
> > 
> > with the main loop being basically
> > 	while ((file = pick_next(files, &start_fd, max_fd)) != NULL)
> > 		filp_close(file, files);
> 
> If we can live with close_from(int first) rather than close_range(), then this
> can perhaps be done a lot more efficiently by:

Yeah, you mentioned this before. I do like being able to specify an
upper bound to have the ability to place fds strategically after said
upper bound.
I have used this quite a few times where I know that given task may have
inherited up to m fds and I want to inherit a specific pipe who's fd I
know. Then I'd dup2(pipe_fd, <upper_bound + 1>) and then close all
other fds. Is that too much of a corner case?

Christian
