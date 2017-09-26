From: Alexey Dobriyan <adobriyan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 1/2 v2] fdmap(2)
Date: Tue, 26 Sep 2017 21:43:08 +0300
Message-ID: <20170926184308.GB14724@avx2>
References: <20170924200620.GA24368@avx2>
 <CALCETrWWUuzF7HaQAS2rf69KcqBrB9epvQPPgKEoK4MNbdVmEw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CALCETrWWUuzF7HaQAS2rf69KcqBrB9epvQPPgKEoK4MNbdVmEw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Randy Dunlap <rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Djalal Harouni <tixxdz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Alexey Gladkov <gladkov.alexey-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Tatsiana_Brouka-uRwfk40T5oI@public.gmane.org, Aliaksandr_Patseyenak1-uRwfk40T5oI@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Sun, Sep 24, 2017 at 02:31:23PM -0700, Andy Lutomirski wrote:
> On Sun, Sep 24, 2017 at 1:06 PM, Alexey Dobriyan <adobriyan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> > From: Aliaksandr Patseyenak <Aliaksandr_Patseyenak1-uRwfk40T5oI@public.gmane.org>
> >
> > Implement system call for bulk retrieveing of opened descriptors
> > in binary form.
> >
> > Some daemons could use it to reliably close file descriptors
> > before starting. Currently they close everything upto some number
> > which formally is not reliable. Other natural users are lsof(1) and CRIU
> > (although lsof does so much in /proc that the effect is thoroughly buried).
> >
> > /proc, the only way to learn anything about file descriptors may not be
> > available. There is unavoidable overhead associated with instantiating
> > 3 dentries and 3 inodes and converting integers to strings and back.
> >
> > Benchmark:
> >
> >         N=1<<22 times
> >         4 opened descriptors (0, 1, 2, 3)
> >         opendir+readdir+closedir /proc/self/fd vs fdmap
> >
> >         /proc 8.31 ą 0.37%
> >         fdmap 0.32 ą 0.72%
> 
> This doesn't have the semantic problem that pidmap does, but I still
> wonder why this can't be accomplished by adding a new file in /proc.

It can be done in /proc but the point of the exercise is to skip all the
overhead: in this case dcache, 1 descriptor for readdir, conversion
from binary to string.

The problem is much deeper, namely, EIATF people force everyone else
to cater to Unix shells so that they can do read() on them because
Unix shells can't do system calls like real programming languages.
The only way to fix this problem is to ignore Unix shells and start
introducing binary system calls so that normal people aren't forced
to make their programs slower than necessary.

Example: lsof(1) does close() from 3 to 1023 inclusive on startup.
I don't know why but it does it. 1 syscall = 1 us, 1000 syscalls = 1 ms
wasted because all of them will return -EBADF normally. With fdmap(2),
lsof would do 2 fdmap() calls (1 real + 1 to confirm no more descriptors
are available + 0 closes in normal situation). That's 2 syscalls vs 1020.

Obviously, for binary model to work fdmap(2) needs to be complemented
by other system calls all of which will bypass /proc for, say, extracting
/proc/$PID/fd/$i symlink content and fdinfo. Currently, if you use
fdmap(2) you still have to fish in /proc for the rest of the data.
