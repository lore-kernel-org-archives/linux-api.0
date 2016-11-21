From: Cyril Hrubis <chrubis@suse.cz>
Subject: Re: Formal description of system call interface
Date: Mon, 21 Nov 2016 17:58:53 +0100
Message-ID: <20161121165853.GC27353@rei.lan>
References: <CACT4Y+YYgs43nJnyg3B9cHWOue62iMW3ZgXQKiKG12A1NVMgtg@mail.gmail.com>
 <20161107103819.GA11374@rei.lan>
 <20161121103752.70ad1418@gandalf.local.home>
 <CACT4Y+Z4a08puQsxDyCQGuWwmqgnW5aCYDDQecqtY7NTMj4mVA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CACT4Y+Z4a08puQsxDyCQGuWwmqgnW5aCYDDQecqtY7NTMj4mVA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dmitry Vyukov <dvyukov@google.com>
Cc: syzkaller <syzkaller@googlegroups.com>, Linux API <linux-api@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Michael Kerrisk-manpages <mtk.manpages@gmail.com>, Thomas Gleixner <tglx@linutronix.de>, Sasha Levin <levinsasha928@gmail.com>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, scientist@fb.com, Arnd Bergmann <arnd@arndb.de>, Carlos O'Donell <carlos@redhat.com>, Kostya Serebryany <kcc@google.com>, Mike Frysinger <vapier@google.com>, Dave Jones <davej@codemonkey.org.uk>, Tavis Ormandy <taviso@google.com>
List-Id: linux-api@vger.kernel.org

Hi!
> > Looking ahead into the future, I was also thinking that if this becomes
> > robust, we could also start an integration specification, that could
> > describe how different system calls interact with each other. Like
> > open() to read(), write() and close().
> >
> > But this is just an idea that popped in my head while reading this
> > thread. We want to start small first, but still could keep this in the
> > back of our minds for future enhancements.
> 
> 
> FWIW syzkaller does something along these lines.
> It has notion of 'resources' and of input/output arguments.
> Then it can figure out that e.g. open creates fd's, so it should be called
> before any reads/writes (provided that we want to pass in valid fd's).
> It does not have notion of "destructors" for resources (e.g. close
> destroys the passed in resource). But it should be easy to describe.

Logical extension would be to teach it that creat(), for instance,
returns file descriptor and creates a file as a side effect. That file
then could be used for a stat() or unlink() concurently, etc. But we
should also consider that not all file descriptors or files are equal,
so we may end up with some classes of files and file descriptors
some of them suitable for different subsets of operations.

I think that defining classes of objects and defining how syscalls
transform their state may yield something usable. But that would require
some serious thinking and a few trial and error implementations.

-- 
Cyril Hrubis
chrubis@suse.cz
