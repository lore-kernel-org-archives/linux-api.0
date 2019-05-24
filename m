From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH v7 5/5] namei: resolveat(2) syscall
Date: Fri, 24 May 2019 15:59:19 -0700
Message-ID: <CAHk-=whbFMg4+HuWOBuHpvDNiAyowX2HUowv3+pt8vPWk5W-YQ@mail.gmail.com>
References: <20190507164317.13562-1-cyphar@cyphar.com> <20190507164317.13562-6-cyphar@cyphar.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190507164317.13562-6-cyphar@cyphar.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Aleksa Sarai <cyphar@cyphar.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Jeff Layton <jlayton@kernel.org>, "J. Bruce Fields" <bfields@fieldses.org>, Arnd Bergmann <arnd@arndb.de>, David Howells <dhowells@redhat.com>, Christian Brauner <christian@brauner.io>, Eric Biederman <ebiederm@xmission.com>, Andy Lutomirski <luto@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Alexei Starovoitov <ast@kernel.org>, Kees Cook <keescook@chromium.org>, Jann Horn <jannh@google.com>, Tycho Andersen <tycho@tycho.ws>, David Drysdale <drysdale@google.com>, Chanho Min <chanho.min@lge.com>, Oleg Nesterov <oleg@redhat.com>, Aleksa Sarai <asarai@suse.de>, Linux Containers <containers@lists.linux-foundation.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Tue, May 7, 2019 at 9:44 AM Aleksa Sarai <cyphar@cyphar.com> wrote:
>
> The most obvious syscall to add support for the new LOOKUP_* scoping
> flags would be openat(2) (along with the required execveat(2) change
> included in this series). However, there are a few reasons to not do
> this:

So honestly, this last patch is what turns me off the whole thing.

It goes from a nice new feature ("you can use O_NOSYMLINKS to disallow
symlink traversal") to a special-case joke that isn't worth it any
more. You get a useless path descrptor back from s special hacky
system call, you don't actually get the useful data that you probably
*want* the open to get you.

Sure, you could eventually then use a *second* system call (openat
with O_EMPTYPATH) to actually get something you can *use*, but at this
point you've just wasted everybodys time and effort with a pointless
second system call.

So I really don't see the point of this whole thing. Why even bother.
Nobody sane will ever use that odd two-systemcall model, and even if
they did, it would be slower and inconvenient.

The whole and only point of this seems to be the two lines that say

       if (flags & ~VALID_RESOLVE_FLAGS)
              return -EINVAL;

but that adds absolutely zero value to anything.  The argument is that
"we can't add it to existing flags, because old kernels won't honor
it", but that's a completely BS argument, since the user has to have a
fallback anyway for the old kernel case - so we literally could much
more conveniently just expose it as a prctl() or something to _ask_
the kernel what flags it honors.

So to me, this whole argument means that "Oh, we'll make it really
inconvenient to actually use this".

If we want to introduce a new system call that allows cool new
features, it should have *more* powerful semantics than the existing
ones, not be clearly weaker and less useful.

So how about making the new system call be something that is a
*superset* of "openat()" so that people can use that, and then if it
fails, just fall back to openat(). But if it succeeds, it just
succeeds, and you don't need to then do other system calls to actually
make it useful.

Make the new system call something people *want* to use because it's
useful, not a crippled useless thing that has some special case use
for some limited thing and just wastes system call space.

Example *useful* system call attributes:

 - make it like openat(), but have another argument with the "limit flags"

 - maybe return more status of the resulting file. People very
commonly do "open->fstat" just to get the size for mmap or to check
some other detail of the file before use.

In other words, make the new system call *useful*. Not some castrated
"not useful on its own" thing.

So I still support the whole "let's make it easy to limit path lookup
in sane ways", but this model of then limiting using the result sanely
just makes me a sad panda.

                     Linus
