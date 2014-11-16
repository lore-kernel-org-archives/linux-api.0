From: Rich Felker <dalias@aerifal.cx>
Subject: Re: [RFC] Possible new execveat(2) Linux syscall
Date: Sun, 16 Nov 2014 17:08:59 -0500
Message-ID: <20141116220859.GY22465@brightrain.aerifal.cx>
References: <CAHse=S8ccC2No5EYS0Pex=Ng3oXjfDB9woOBmMY_k+EgxtODZA@mail.gmail.com>
 <20141116195246.GX22465@brightrain.aerifal.cx>
 <CALCETrWWUyizL8HxZKaYE+xuV5eGi8mQcequT9HPvvac=X-dLg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <libc-alpha-return-54413-glibc-alpha=m.gmane.org@sourceware.org>
List-Unsubscribe: <mailto:libc-alpha-unsubscribe-glibc-alpha=m.gmane.org@sourceware.org>
List-Subscribe: <mailto:libc-alpha-subscribe@sourceware.org>
List-Archive: <http://sourceware.org/ml/libc-alpha/>
List-Post: <mailto:libc-alpha@sourceware.org>
List-Help: <mailto:libc-alpha-help@sourceware.org>, <http://sourceware.org/ml/#faqs>
Sender: libc-alpha-owner@sourceware.org
Content-Disposition: inline
In-Reply-To: <CALCETrWWUyizL8HxZKaYE+xuV5eGi8mQcequT9HPvvac=X-dLg@mail.gmail.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: libc-alpha <libc-alpha@sourceware.org>, musl@lists.openwall.com, Andrew Morton <akpm@linux-foundation.org>, David Drysdale <drysdale@google.com>, Linux API <linux-api@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>
List-Id: linux-api@vger.kernel.org

On Sun, Nov 16, 2014 at 01:20:39PM -0800, Andy Lutomirski wrote:
> On Nov 16, 2014 11:53 AM, "Rich Felker" <dalias@aerifal.cx> wrote:
> >
> > On Fri, Nov 14, 2014 at 02:54:19PM +0000, David Drysdale wrote:
> > > Hi,
> > >
> > > Over at the LKML[1] we've been discussing a possible new syscall, execveat(2),
> > > and it would be good to hear a glibc perspective about it (and whether there
> > > are any interface changes that would make it easier to use from userspace).
> > >
> > > The syscall prototype is:
> > >   int execveat(int fd, const char *pathname,
> > >                       char *const argv[],  char *const envp[],
> > >                       int flags); /* AT_EMPTY_PATH, AT_SYMLINK_NOFOLLOW */
> > > and it works similarly to execve(2) except:
> > >  - the executable to run is identified by the combination of fd+pathname, like
> > >    other *at(2) syscalls
> > >  - there's an extra flags field to control behaviour.
> > > (I've attached a text version of the suggested man page below)
> > >
> > > One particular benefit of this is that it allows an fexecve(3) implementation
> > > that doesn't rely on /proc being accessible, which is useful for sandboxed
> > > applications.  (However, that does only work for non-interpreted programs:
> > > the name passed to a script interpreter is of the form "/dev/fd/<fd>/<path>"
> > > or "/dev/fd/<fd>", so the executed interpreter will normally still need /proc
> > > access to load the script file).
> > >
> > > How does this sound from a glibc perspective?
> >
> > I've been following the discussions so far and everything looks mostly
> > okay. There are still issues to be resolved with the different
> > semantics between Linux O_PATH and what POSIX requires for O_EXEC (and
> > O_SEARCH) but as long as the intent is that, once O_EXEC is defined to
> > save the permissions at the time of open and cause them to be used in
> > place of the current file permissions at the time of execveat
> 
> Is something missing here?
> 
> FWIW, I don't understand O_PATH or O_EXEC very well, so from my POV,
> help would be appreciated.

Yes. POSIX requires that permission checks for execution (fexecve with
O_EXEC file descriptors) and directory-search (*at functions with
O_SEARCH file descriptors) succeed if the open operation succeeded --
the permissions check is required to take place at open time rather
than at exec/search time. There's a separate discussion about how to
make this work on the kernel side.

> > One major issue however is FD_CLOEXEC with scripts. Last I checked,
> > this didn't work because the file is already closed by the time the
> > interpreted runs. The intended usage of fexecve is almost certainly to
> > call it with the file descriptor set close-on-exec; otherwise, there
> > would be no clean way to close it, since the program being executed
> > doesn't know that it's being executed via fexecve. So this is a
> > serious problem that needs to be solved if it hasn't already. I have
> > some ideas I could offer, but I'm not an expert on the kernel side
> > things so I'm not sure they'd be correct.
> 
> Bring on the ideas.

My thought is that when the kernel opens the binary and sees that it's
a script that needs an interpreter, the kernel should not pass
/proc/self/fd/%d to the interpreter, but instead should pass the name
of a new magic symlink in /proc/self that's connected to the inode for
the script to be executed but that ceases to exist as soon as it's
opened. In theory this could also be used for suid scripts to make
them secure.

> FWIW, I've often thought that interpreter binaries should mark
> themselves as such to enable better interactions with the kernel.

That's hard since users expect to be able to use arbitrary
interpreters (and sometimes even pass through multiple ones, e.g.
#!/usr/bin/env perl).

Rich
