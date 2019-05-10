From: Jann Horn <jannh@google.com>
Subject: Re: [PATCH v6 5/6] binfmt_*: scope path resolution of interpreters
Date: Fri, 10 May 2019 22:10:32 +0200
Message-ID: <20190510201032.GA253532@google.com>
References: <20190506165439.9155-1-cyphar@cyphar.com>
 <20190506165439.9155-6-cyphar@cyphar.com>
 <CAG48ez0-CiODf6UBHWTaog97prx=VAd3HgHvEjdGNz344m1xKw@mail.gmail.com>
 <87o94d6aql.fsf@xmission.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <87o94d6aql.fsf@xmission.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Aleksa Sarai <cyphar@cyphar.com>, Andy Lutomirski <luto@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, Jeff Layton <jlayton@kernel.org>, "J. Bruce Fields" <bfields@fieldses.org>, Arnd Bergmann <arnd@arndb.de>, David Howells <dhowells@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, Alexei Starovoitov <ast@kernel.org>, Kees Cook <keescook@chromium.org>, Christian Brauner <christian@brauner.io>, Tycho Andersen <tycho@tycho.ws>, David Drysdale <drysdale@google.com>, Chanho Min <chanho.min@lge.com>, Oleg Nesterov <oleg@redhat.com>, Aleksa Sarai <asarai@suse.de>, Linus Torvalds <torvalds@linux-foundation.org>, containers@lists.linux-foundation.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Tue, May 07, 2019 at 07:38:58PM -0500, Eric W. Biederman wrote:
> Jann Horn <jannh@google.com> writes:
> > In my opinion, CVE-2019-5736 points out two different problems:
> >
> > The big problem: The __ptrace_may_access() logic has a special-case
> > short-circuit for "introspection" that you can't opt out of;
> 
> Once upon a time in a galaxy far far away I fixed a bug where we missing
> ptrace_may_access checks on various proc files and systems using selinux
> stopped working.  At the time selinux did not allow ptrace like access
> to yourself.  The "introspection" special case was the quick and simple
> work-around.
> 
> There is nothing fundamental in having the "introspection" special case
> except that various lsms have probably grown to depend upon it being
> there.  I expect without difficulty we could move the check down
> into the various lsms.  Which would get that check out of the core
> kernel code.

Oh, if that's an option, that would be great, I think.


But this means, for example, that a non-root, non-dumpable process can't
open /proc/self/maps anymore, or open /proc/self/fd/*, and things like
that, without making itself dumpable. I would be surprised if there is
no code out there that relies on that.

>From what I can tell, without the introspection special case,
introspection would fail in the following cases (assuming that the
process is not capable and isn't using sys_setfs[ug]id()):

 - ruid/euid/suid are not all the same
 - rgid/egid/sgid are not all the same
 - process is not dumpable

I think that there probably should be some way for a non-dumpable
process to look at its own procfs entries? If we could start from a
clean slate, I'd propose an opt-in flag to openat() for that, but
since we don't have a clean slate, I'd be afraid of breaking things
with that. But maybe I'm just being overly careful here?
