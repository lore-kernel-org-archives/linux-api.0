From: Andy Lutomirski <luto@kernel.org>
Subject: Re: [PATCH v6 5/6] binfmt_*: scope path resolution of interpreters
Date: Fri, 10 May 2019 14:20:23 -0700
Message-ID: <CALCETrW2nn=omqJb4p+m-BDsCOhg+YZQ3ELd4BdhODV3G44gfA@mail.gmail.com>
References: <20190506165439.9155-1-cyphar@cyphar.com> <20190506165439.9155-6-cyphar@cyphar.com>
 <CAG48ez0-CiODf6UBHWTaog97prx=VAd3HgHvEjdGNz344m1xKw@mail.gmail.com>
 <20190506191735.nmzf7kwfh7b6e2tf@yavin> <20190510204141.GB253532@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190510204141.GB253532@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jann Horn <jannh@google.com>
Cc: Aleksa Sarai <cyphar@cyphar.com>, Andy Lutomirski <luto@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, Jeff Layton <jlayton@kernel.org>, "J. Bruce Fields" <bfields@fieldses.org>, Arnd Bergmann <arnd@arndb.de>, David Howells <dhowells@redhat.com>, Eric Biederman <ebiederm@xmission.com>, Andrew Morton <akpm@linux-foundation.org>, Alexei Starovoitov <ast@kernel.org>, Kees Cook <keescook@chromium.org>, Christian Brauner <christian@brauner.io>, Tycho Andersen <tycho@tycho.ws>, David Drysdale <drysdale@google.com>, Chanho Min <chanho.min@lge.com>, Oleg Nesterov <oleg@redhat.com>, Aleksa Sarai <asarai@suse.de>, Linus Torvalds <torvalds@linux-foundation.org>, Linux Containers <containers@lists.linux-foundation.org>, linux-fsdevel <linux-fsdevel@vger>
List-Id: linux-api@vger.kernel.org

On Fri, May 10, 2019 at 1:41 PM Jann Horn <jannh@google.com> wrote:
>
> On Tue, May 07, 2019 at 05:17:35AM +1000, Aleksa Sarai wrote:
> > On 2019-05-06, Jann Horn <jannh@google.com> wrote:
> > > In my opinion, CVE-2019-5736 points out two different problems:
> > >
> > > The big problem: The __ptrace_may_access() logic has a special-case
> > > short-circuit for "introspection" that you can't opt out of; this
> > > makes it possible to open things in procfs that are related to the
> > > current process even if the credentials of the process wouldn't permit
> > > accessing another process like it. I think the proper fix to deal with
> > > this would be to add a prctl() flag for "set whether introspection is
> > > allowed for this process", and if userspace has manually un-set that
> > > flag, any introspection special-case logic would be skipped.
> >
> > We could do PR_SET_DUMPABLE=3 for this, I guess?
>
> Hmm... I'd make it a new prctl() command, since introspection is
> somewhat orthogonal to dumpability. Also, dumpability is per-mm, and I
> think the introspection flag should be per-thread.

I've lost track of the context here, but it seems to me that
mitigating attacks involving accidental following of /proc links
shouldn't depend on dumpability.  What's the actual problem this is
trying to solve again?
