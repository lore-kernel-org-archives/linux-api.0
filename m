From: Christian Brauner <christian@brauner.io>
Subject: Re: [PATCH v1 2/4] pid: add pidctl()
Date: Tue, 26 Mar 2019 17:31:43 +0100
Message-ID: <20190326163142.4eh5qpgiqvygf26w@brauner.io>
References: <20190326155513.26964-1-christian@brauner.io>
 <20190326155513.26964-3-christian@brauner.io>
 <CAKOZuet18Lc+N7NaXN=cOcg_q8CxDkhYVss9enVhh6RBRUXpjg@mail.gmail.com>
 <20190326162337.o256x7hiodu2qfyg@brauner.io>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190326162337.o256x7hiodu2qfyg@brauner.io>
Sender: linux-kernel-owner@vger.kernel.org
To: Daniel Colascione <dancol@google.com>
Cc: Jann Horn <jannh@google.com>, Konstantin Khlebnikov <khlebnikov@yandex-team.ru>, Andy Lutomirski <luto@kernel.org>, David Howells <dhowells@redhat.com>, "Serge E. Hallyn" <serge@hallyn.com>, "Eric W. Biederman" <ebiederm@xmission.com>, Linux API <linux-api@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>, Kees Cook <keescook@chromium.org>, Alexey Dobriyan <adobriyan@gmail.com>, Thomas Gleixner <tglx@linutronix.de>, Michael Kerrisk-manpages <mtk.manpages@gmail.com>, Jonathan Kowalski <bl0pbl33p@gmail.com>, "Dmitry V. Levin" <ldv@altlinux.org>, Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>, Nagarathnam Muthusamy <nagarathnam.muthusamy@oracle.com>, Aleksa Sarai <cyphar@cyph>
List-Id: linux-api@vger.kernel.org

On Tue, Mar 26, 2019 at 05:23:37PM +0100, Christian Brauner wrote:
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

There's something to be said for

pidfd_open(pid_t pid, int pidfd, unsigned int flags);

/* get pidfd */
int pidfd = pidfd_open(1234, -1, 0);

/* convert to procfd */
int procfd = pidfd_open(-1, 4, 0);

/* convert to pidfd */
int pidfd = pidfd_open(4, -1, 0);
