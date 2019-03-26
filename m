From: Christian Brauner <christian@brauner.io>
Subject: Re: [PATCH v1 2/4] pid: add pidctl()
Date: Tue, 26 Mar 2019 18:05:58 +0100
Message-ID: <20190326170557.y5fbn7lfegfllhwt@brauner.io>
References: <20190326155513.26964-1-christian@brauner.io>
 <20190326155513.26964-3-christian@brauner.io>
 <CAKOZuet18Lc+N7NaXN=cOcg_q8CxDkhYVss9enVhh6RBRUXpjg@mail.gmail.com>
 <20190326162337.o256x7hiodu2qfyg@brauner.io>
 <20190326163142.4eh5qpgiqvygf26w@brauner.io>
 <20190326163452.uku4bgkessxzxvai@brauner.io>
 <CAKOZuetcp=UPRWDkLUxLTmu-vqdN6qSmN9=0uP8MUuwyLoYfEA@mail.gmail.com>
 <20190326164354.qecuzkqz6ic2433i@brauner.io>
 <CAKOZueuXtWwC+U9-q3QG41p-fwjMxmujTUegmVkorLzFcY2-SA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAKOZueuXtWwC+U9-q3QG41p-fwjMxmujTUegmVkorLzFcY2-SA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Daniel Colascione <dancol@google.com>
Cc: Jann Horn <jannh@google.com>, Konstantin Khlebnikov <khlebnikov@yandex-team.ru>, Andy Lutomirski <luto@kernel.org>, David Howells <dhowells@redhat.com>, "Serge E. Hallyn" <serge@hallyn.com>, "Eric W. Biederman" <ebiederm@xmission.com>, Linux API <linux-api@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>, Kees Cook <keescook@chromium.org>, Alexey Dobriyan <adobriyan@gmail.com>, Thomas Gleixner <tglx@linutronix.de>, Michael Kerrisk-manpages <mtk.manpages@gmail.com>, Jonathan Kowalski <bl0pbl33p@gmail.com>, "Dmitry V. Levin" <ldv@altlinux.org>, Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>, Nagarathnam Muthusamy <nagarathnam.muthusamy@oracle.com>, Aleksa Sarai <cyphar@cyph>
List-Id: linux-api@vger.kernel.org

On Tue, Mar 26, 2019 at 09:50:28AM -0700, Daniel Colascione wrote:
> On Tue, Mar 26, 2019 at 9:44 AM Christian Brauner <christian@brauner.io> wrote:
> >
> > On Tue, Mar 26, 2019 at 09:38:31AM -0700, Daniel Colascione wrote:
> > > On Tue, Mar 26, 2019 at 9:34 AM Christian Brauner <christian@brauner.io> wrote:
> > > >
> > > > On Tue, Mar 26, 2019 at 05:31:42PM +0100, Christian Brauner wrote:
> > > > > On Tue, Mar 26, 2019 at 05:23:37PM +0100, Christian Brauner wrote:
> > > > > > On Tue, Mar 26, 2019 at 09:17:07AM -0700, Daniel Colascione wrote:
> > > > > > > Thanks for the patch.
> > > > > > >
> > > > > > > On Tue, Mar 26, 2019 at 8:55 AM Christian Brauner <christian@brauner.io> wrote:
> > > > > > > >
> > > > > > > > The pidctl() syscalls builds on, extends, and improves translate_pid() [4].
> > > > > > > > I quote Konstantins original patchset first that has already been acked and
> > > > > > > > picked up by Eric before and whose functionality is preserved in this
> > > > > > > > syscall:
> > > > > > >
> > > > > > > We still haven't had a much-needed conversation about splitting this
> > > > > > > system call into smaller logical operations. It's important that we
> > > > > > > address this point before this patch is merged and becomes permanent
> > > > > > > kernel ABI.
> > > > > >
> > > > > > I don't particularly mind splitting this into an additional syscall like
> > > > > > e.g.  pidfd_open() but then we have - and yes, I know you'll say
> > > > > > syscalls are cheap - translate_pid(), and pidfd_open(). What I like
> > > > > > about this rn is that it connects both apis in a single syscall
> > > > > > and allows pidfd retrieval across pid namespaces. So I guess we'll see
> > > > > > what other people think.
> > > > >
> > > > > There's something to be said for
> > > > >
> > > > > pidfd_open(pid_t pid, int pidfd, unsigned int flags);
> > > > >
> > > > > /* get pidfd */
> > > > > int pidfd = pidfd_open(1234, -1, 0);
> > > > >
> > > > > /* convert to procfd */
> > > > > int procfd = pidfd_open(-1, 4, 0);
> > > > >
> > > > > /* convert to pidfd */
> > > > > int pidfd = pidfd_open(4, -1, 0);
> > > >
> > > > probably rather:
> > > >
> > > > int pidfd = pidfd_open(-1, 4, PIDFD_TO_PROCFD);
> > > > int procfd = pidfd_open(-1, 4, PROCFD_TO_PIDFD);
> > > > int pidfd = pidfd_open(1234, -1, 0);
> > >
> > > These three operations look like three related but distinct functions
> > > to me, and in the second case, the "pidfd_open" name is a bit of a
> > > misnomer. IMHO, the presence of an "operation name" field in any API
> > > is usually a good indication that we're looking at a family of related
> > > APIs, not a single coherent operation.
> >
> > So I'm happy to accommodate the need for a clean api even though I
> > disagree that what we have in pidctl() is unclean.
> > But I will not start sending a pile of syscalls. There is nothing
> > necessarily wrong to group related APIs together.
> 
> In the email I sent just now, I identified several specific technical
> disadvantages arising from unnecessary grouping of system calls. We
> have historical evidence in the form of socketcall that this grouping
> tends to be regrettable. I don't recall your identifying any
> offsetting technical advantages. Did I miss something?
> 
> > By these standards the
> > new mount API would need to be like 30 different syscalls, same for
> > keyring management.
> 
> Can you please point out the problem that would arise from splitting
> the mount and keyring APIs this way? One could have made the same
> argument about grouping socket operations, and this socket-operation
> grouping ended up being a mistake.

The main reasons why I am not responding to such mails is that I don't
want long tangents about very generic issues. If you can find support
from people that prefer to split this into three separate syscalls:

pidfd_open()
pidfd_procfd()
procfd_pidfd()

I'm happy to do it this way. But it seems we can find a compromise, e.g.
by having

pidfd_open(pid_t pid, int fd, int fd, unsigned int flags)

and avoid that whole email waterfall.
