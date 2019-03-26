From: Daniel Colascione <dancol@google.com>
Subject: Re: [PATCH v1 2/4] pid: add pidctl()
Date: Tue, 26 Mar 2019 10:00:27 -0700
Message-ID: <CAKOZuev7sSTEaOAiKjs+WKtr8uDoeSSDS__YFoZVM0nCQQh5mA@mail.gmail.com>
References: <20190326155513.26964-1-christian@brauner.io> <20190326155513.26964-3-christian@brauner.io>
 <CAKOZuet18Lc+N7NaXN=cOcg_q8CxDkhYVss9enVhh6RBRUXpjg@mail.gmail.com>
 <20190326162337.o256x7hiodu2qfyg@brauner.io> <20190326163142.4eh5qpgiqvygf26w@brauner.io>
 <20190326163452.uku4bgkessxzxvai@brauner.io> <CALCETrXdyTxJZBXR02Dd=fnZYNLxFYgiJfnJCONBK5khy7JPVQ@mail.gmail.com>
 <20190326164634.ba5dko6weazp3zyd@brauner.io>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190326164634.ba5dko6weazp3zyd@brauner.io>
Sender: linux-kernel-owner@vger.kernel.org
To: Christian Brauner <christian@brauner.io>
Cc: Andy Lutomirski <luto@kernel.org>, Jann Horn <jannh@google.com>, Konstantin Khlebnikov <khlebnikov@yandex-team.ru>, David Howells <dhowells@redhat.com>, "Serge E. Hallyn" <serge@hallyn.com>, "Eric W. Biederman" <ebiederm@xmission.com>, Linux API <linux-api@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>, Kees Cook <keescook@chromium.org>, Alexey Dobriyan <adobriyan@gmail.com>, Thomas Gleixner <tglx@linutronix.de>, Michael Kerrisk-manpages <mtk.manpages@gmail.com>, Jonathan Kowalski <bl0pbl33p@gmail.com>, "Dmitry V. Levin" <ldv@altlinux.org>, Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>, Nagarathnam Muthusamy <nagarathnam.muthusamy@oracle.com>, Aleksa Sarai <cyphar@cyphar.com>
List-Id: linux-api@vger.kernel.org

On Tue, Mar 26, 2019 at 9:46 AM Christian Brauner <christian@brauner.io> wrote:
>
> On Tue, Mar 26, 2019 at 09:42:59AM -0700, Andy Lutomirski wrote:
> > On Tue, Mar 26, 2019 at 9:34 AM Christian Brauner <christian@brauner.io> wrote:
> > >
> > > On Tue, Mar 26, 2019 at 05:31:42PM +0100, Christian Brauner wrote:
> > > > On Tue, Mar 26, 2019 at 05:23:37PM +0100, Christian Brauner wrote:
> > > > > On Tue, Mar 26, 2019 at 09:17:07AM -0700, Daniel Colascione wrote:
> > > > > > Thanks for the patch.
> > > > > >
> > > > > > On Tue, Mar 26, 2019 at 8:55 AM Christian Brauner <christian@brauner.io> wrote:
> > > > > > >
> > > > > > > The pidctl() syscalls builds on, extends, and improves translate_pid() [4].
> > > > > > > I quote Konstantins original patchset first that has already been acked and
> > > > > > > picked up by Eric before and whose functionality is preserved in this
> > > > > > > syscall:
> > > > > >
> > > > > > We still haven't had a much-needed conversation about splitting this
> > > > > > system call into smaller logical operations. It's important that we
> > > > > > address this point before this patch is merged and becomes permanent
> > > > > > kernel ABI.
> > > > >
> > > > > I don't particularly mind splitting this into an additional syscall like
> > > > > e.g.  pidfd_open() but then we have - and yes, I know you'll say
> > > > > syscalls are cheap - translate_pid(), and pidfd_open(). What I like
> > > > > about this rn is that it connects both apis in a single syscall
> > > > > and allows pidfd retrieval across pid namespaces. So I guess we'll see
> > > > > what other people think.
> > > >
> > > > There's something to be said for
> > > >
> > > > pidfd_open(pid_t pid, int pidfd, unsigned int flags);
> > > >
> > > > /* get pidfd */
> > > > int pidfd = pidfd_open(1234, -1, 0);
> > > >
> > > > /* convert to procfd */
> > > > int procfd = pidfd_open(-1, 4, 0);
> > > >
> > > > /* convert to pidfd */
> > > > int pidfd = pidfd_open(4, -1, 0);
> > >
> > > probably rather:
> > >
> > > int pidfd = pidfd_open(-1, 4, PIDFD_TO_PROCFD);
> >
> > Do you mean:
> >
> > int procrootfd = open("/proc", O_DIRECTORY | O_RDONLY);
> > int procfd = pidfd_open(procrootfd, pidfd, PIDFD_TO_PROCFD);
> >
> > or do you have some other solution in mind to avoid the security problem?
>
> Yes, we need the proc root obviously. I just jotted this down.
>
> We probably would need where one of the fds can refer to the proc root.
>
> pidfd_open(pid_t, int fd, int fd, 0)

Indeed. This is precisely the pidfd-procfd translation API I proposed
in the last paragraph of [1].

[1] https://lore.kernel.org/lkml/CAKOZuetCFgu0B53+mGmQ3+539MPT_tiu-PACx2ATvihHrrmUKg@mail.gmail.com/
