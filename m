From: Daniel Colascione <dancol@google.com>
Subject: Re: [PATCH v1 2/4] pid: add pidctl()
Date: Tue, 26 Mar 2019 09:33:52 -0700
Message-ID: <CAKOZueubdBMVyVg_7rmuT5KCJSvHK+FehkODkRgTmUKz0Ka_Bw@mail.gmail.com>
References: <20190326155513.26964-1-christian@brauner.io> <20190326155513.26964-3-christian@brauner.io>
 <CAKOZuet18Lc+N7NaXN=cOcg_q8CxDkhYVss9enVhh6RBRUXpjg@mail.gmail.com> <20190326162337.o256x7hiodu2qfyg@brauner.io>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190326162337.o256x7hiodu2qfyg@brauner.io>
Sender: linux-kernel-owner@vger.kernel.org
To: Christian Brauner <christian@brauner.io>
Cc: Jann Horn <jannh@google.com>, Konstantin Khlebnikov <khlebnikov@yandex-team.ru>, Andy Lutomirski <luto@kernel.org>, David Howells <dhowells@redhat.com>, "Serge E. Hallyn" <serge@hallyn.com>, "Eric W. Biederman" <ebiederm@xmission.com>, Linux API <linux-api@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>, Kees Cook <keescook@chromium.org>, Alexey Dobriyan <adobriyan@gmail.com>, Thomas Gleixner <tglx@linutronix.de>, Michael Kerrisk-manpages <mtk.manpages@gmail.com>, Jonathan Kowalski <bl0pbl33p@gmail.com>, "Dmitry V. Levin" <ldv@altlinux.org>, Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>, Nagarathnam Muthusamy <nagarathnam.muthusamy@oracle.com>, Aleksa Sarai <cyphar@cyph>
List-Id: linux-api@vger.kernel.org

On Tue, Mar 26, 2019 at 9:23 AM Christian Brauner <christian@brauner.io> wrote:
>
> On Tue, Mar 26, 2019 at 09:17:07AM -0700, Daniel Colascione wrote:
> > Thanks for the patch.
> >
> > On Tue, Mar 26, 2019 at 8:55 AM Christian Brauner <christian@brauner.io> wrote:
> > >
> > > The pidctl() syscalls builds on, extends, and improves translate_pid() [4].
> > > I quote Konstantins original patchset first that has already been acked and
> > > picked up by Eric before and whose functionality is preserved in this
> > > syscall:
> >
> > We still haven't had a much-needed conversation about splitting this
> > system call into smaller logical operations. It's important that we
> > address this point before this patch is merged and becomes permanent
> > kernel ABI.
>
> I don't particularly mind splitting this into an additional syscall like
> e.g.  pidfd_open() but then we have - and yes, I know you'll say
> syscalls are cheap - translate_pid(), and pidfd_open(). What I like
> about this rn is that it connects both apis in a single syscall
> and allows pidfd retrieval across pid namespaces. So I guess we'll see
> what other people think.

Thanks. I also appreciate a clean unification of related
functionality, but I'm concerned that this API in particular --- due
in part to its *ctl() name --- will become a catch-all facility for
doing *anything* with processes. (Granted, heavy use of a new, good,
and clean API would be a good problem to have.) This
single-system-call state of affairs would make it more awkward than
necessary to do system-call level logging (say, strace -e), enable or
disable tracing of specific operations with ftrace, apply some kinds
of SELinux policy, and so on, and the only advantage of the single
system call design that I can see right now is the logical
cleanliness.

I'd propose splitting the call, or if we can't do that, renaming it to
something else --- pidfd_query --- so that it's less likely to become
a catch-all operation holder.
