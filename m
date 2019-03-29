From: Jann Horn <jannh@google.com>
Subject: Re: [PATCH v2 2/5] pid: add pidfd_open()
Date: Sat, 30 Mar 2019 00:45:46 +0100
Message-ID: <CAG48ez0Arzdtjxj9zVVTaL=T6tX16e6OcR75rtk9mavCbnMK6w@mail.gmail.com>
References: <20190329155425.26059-1-christian@brauner.io> <20190329155425.26059-3-christian@brauner.io>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190329155425.26059-3-christian@brauner.io>
Sender: linux-kernel-owner@vger.kernel.org
To: Christian Brauner <christian@brauner.io>
Cc: Andy Lutomirski <luto@kernel.org>, David Howells <dhowells@redhat.com>, "Serge E. Hallyn" <serge@hallyn.com>, Linux API <linux-api@vger.kernel.org>, kernel list <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>, "Eric W. Biederman" <ebiederm@xmission.com>, Konstantin Khlebnikov <khlebnikov@yandex-team.ru>, Kees Cook <keescook@chromium.org>, Alexey Dobriyan <adobriyan@gmail.com>, Thomas Gleixner <tglx@linutronix.de>, Michael Kerrisk-manpages <mtk.manpages@gmail.com>, Jonathan Kowalski <bl0pbl33p@gmail.com>, "Dmitry V. Levin" <ldv@altlinux.org>, Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>, Nagarathnam Muthusamy <nagarathnam.muthusamy@oracle.com>, Aleksa Sarai <cyphar@cyphar.com>, Al Viro <viro@zeniv.li>
List-Id: linux-api@vger.kernel.org

On Fri, Mar 29, 2019 at 4:54 PM Christian Brauner <christian@brauner.io> wrote:
> /* Introduction */
> This adds the pidfd_open() syscall.
> pidfd_open() allows to retrieve file descriptors for a given pid. This
> includes both file descriptors for processes and file descriptors for
> threads.

Looks good to me, overall. Apart from a few nits below:
Reviewed-by: Jann Horn <jannh@google.com>

[...]
> diff --git a/kernel/pid.c b/kernel/pid.c
> index 20881598bdfa..8c9e15e0e463 100644
> --- a/kernel/pid.c
> +++ b/kernel/pid.c
[...]
> +static struct file *pidfd_open_proc_pid(const struct file *procf, pid_t pid,
> +                                       const struct pid *pidfd_pid)
> +{
> +       char name[12]; /* int to strlen + \0 but with */

nit: comment suddenly ends at "but with"?

[...]
> +}
> +
> +static inline int pidfd_to_procfd(int procfd, struct file *pidfd_file)
> +{
> +       long fd;

nit: This should probably be an int?

[...]
> +       return fd;
> +}
[...]
> +static long pidfd_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
> +{
> +       int procfd = arg;

nit: I think it'd be semantically cleaner to move this assignment into
the switch case, but I don't feel about it strongly.

> +       switch (cmd) {
> +       case PIDFD_GET_PROCFD:
> +               return pidfd_to_procfd(procfd, file);
> +       default:
> +               return -ENOTTY;
> +       }
> +}
