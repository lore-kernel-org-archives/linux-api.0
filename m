From: Jann Horn <jannh@google.com>
Subject: Re: [PATCH v6 5/6] binfmt_*: scope path resolution of interpreters
Date: Fri, 10 May 2019 22:41:41 +0200
Message-ID: <20190510204141.GB253532@google.com>
References: <20190506165439.9155-1-cyphar@cyphar.com>
 <20190506165439.9155-6-cyphar@cyphar.com>
 <CAG48ez0-CiODf6UBHWTaog97prx=VAd3HgHvEjdGNz344m1xKw@mail.gmail.com>
 <20190506191735.nmzf7kwfh7b6e2tf@yavin>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190506191735.nmzf7kwfh7b6e2tf@yavin>
Sender: linux-kernel-owner@vger.kernel.org
To: Aleksa Sarai <cyphar@cyphar.com>
Cc: Andy Lutomirski <luto@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, Jeff Layton <jlayton@kernel.org>, "J. Bruce Fields" <bfields@fieldses.org>, Arnd Bergmann <arnd@arndb.de>, David Howells <dhowells@redhat.com>, Eric Biederman <ebiederm@xmission.com>, Andrew Morton <akpm@linux-foundation.org>, Alexei Starovoitov <ast@kernel.org>, Kees Cook <keescook@chromium.org>, Christian Brauner <christian@brauner.io>, Tycho Andersen <tycho@tycho.ws>, David Drysdale <drysdale@google.com>, Chanho Min <chanho.min@lge.com>, Oleg Nesterov <oleg@redhat.com>, Aleksa Sarai <asarai@suse.de>, Linus Torvalds <torvalds@linux-foundation.org>, containers@lists.linux-foundation.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Tue, May 07, 2019 at 05:17:35AM +1000, Aleksa Sarai wrote:
> On 2019-05-06, Jann Horn <jannh@google.com> wrote:
> > In my opinion, CVE-2019-5736 points out two different problems:
> >
> > The big problem: The __ptrace_may_access() logic has a special-case
> > short-circuit for "introspection" that you can't opt out of; this
> > makes it possible to open things in procfs that are related to the
> > current process even if the credentials of the process wouldn't permit
> > accessing another process like it. I think the proper fix to deal with
> > this would be to add a prctl() flag for "set whether introspection is
> > allowed for this process", and if userspace has manually un-set that
> > flag, any introspection special-case logic would be skipped.
> 
> We could do PR_SET_DUMPABLE=3 for this, I guess?

Hmm... I'd make it a new prctl() command, since introspection is
somewhat orthogonal to dumpability. Also, dumpability is per-mm, and I
think the introspection flag should be per-thread.

> > An additional problem: /proc/*/exe can be used to open a file for
> > writing; I think it may have been Andy Lutomirski who pointed out some
> > time ago that it would be nice if you couldn't use /proc/*/fd/* to
> > re-open files with more privileges, which is sort of the same thing.
> 
> This is something I'm currently working on a series for, which would
> boil down to some restrictions on how re-opening of file descriptors
> works through procfs.

Ah, nice!

> However, execveat() of a procfs magiclink is a bit hard to block --
> there is no way for userspace to to represent a file being "open for
> execute" so they are all "open for execute" by default and blocking it
> outright seems a bit extreme (though I actually hope to eventually add
> the ability to mark an O_PATH as "open for X" to resolveat(2) -- hence
> why I've reserved some bits).

(For what it's worth, I'm mostly concerned about read vs write, not
really about execute, since execute really is just another form of
reading in my opinion.)

> (Thinking more about it, there is an argument that I should include the
> above patch into this series so that we can block re-opening of fds
> opened through resolveat(2) without explicit flags from the outset.)
