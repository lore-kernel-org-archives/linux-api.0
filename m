From: Christian Brauner <christian.brauner@ubuntu.com>
Subject: Re: [PATCH v15 0/9] open: introduce openat2(2) syscall
Date: Wed, 13 Nov 2019 00:06:48 +0100
Message-ID: <20191112230646.47dgr6bbnjv7vkrk@wittgenstein>
References: <20191105090553.6350-1-cyphar@cyphar.com>
 <20191111132404.y523iqicbn6fivx5@yavin.dot.cyphar.com>
 <201911121457.7D02692@keescook>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <201911121457.7D02692@keescook>
Sender: linux-kernel-owner@vger.kernel.org
To: Kees Cook <keescook@chromium.org>, Al Viro <viro@zeniv.linux.org.uk>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: Aleksa Sarai <cyphar@cyphar.com>, Jeff Layton <jlayton@kernel.org>, "J. Bruce Fields" <bfields@fieldses.org>, Arnd Bergmann <arnd@arndb.de>, David Howells <dhowells@redhat.com>, Shuah Khan <shuah@kernel.org>, Shuah Khan <skhan@linuxfoundation.org>, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Eric Biederman <ebiederm@xmission.com>, Andy Lutomirski <luto@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Alexei Starovoitov <ast@kernel.org>, Jann Horn <jannh@google.com>, Tycho Andersen <tycho@tycho.ws>, David Drysdale <drysdale@google.com>, Chanho Min <chanho.min@lge.com>, Oleg Nesterov <oleg@redhat.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Alexander Shishkin <alexander.shishkin@linux.intel.com>, Jiri
List-Id: linux-api@vger.kernel.org

On Tue, Nov 12, 2019 at 03:01:26PM -0800, Kees Cook wrote:
> On Tue, Nov 12, 2019 at 12:24:04AM +1100, Aleksa Sarai wrote:
> > On 2019-11-05, Aleksa Sarai <cyphar@cyphar.com> wrote:
> > > This patchset is being developed here:
> > >   <https://github.com/cyphar/linux/tree/openat2/master>
> > > 
> > > Patch changelog:
> > >  v15:
> > >   * Fix code style for LOOKUP_IN_ROOT handling in path_init(). [Linus Torvalds]
> > >   * Split out patches for each individual LOOKUP flag.
> > >   * Reword commit messages to give more background information about the
> > >     series, as well as mention the semantics of each flag in more detail.
> > > [...]
> > 
> > Ping -- this patch hasn't been touched for a week. Thanks.
> 
> If I've been following correctly, everyone is happy with this series.
> (i.e. Linus's comment appear to have been addressed.)
> 
> Perhaps the next question is should this go via a pull request by you to
> Linus directly during the v5.5 merge window, via akpm, via akpm, via
> Christian, or some other path? Besides Linus, it's not been clear who
> should "claim" this series. :)

I like this series and the same with the copy_struct_from_user() part of
it I've taken I'm happy to stuff this into a dedicated branch, merge it
into my for-next and send it for v5.5.
Though I'd _much_ rather see Al pick this up or have him give his
blessing first.

Christian
