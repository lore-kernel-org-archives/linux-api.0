From: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Subject: Re: [PATCH v9 2/4] pid: Implement pidfd_getfd syscall
Date: Mon, 13 Jan 2020 15:58:07 +0100
Message-ID: <CAK8P3a10iVg6dyvGGLjjdvyUcBQhzC5zmwBzS_Bfpk0FQE4k5Q@mail.gmail.com>
References: <20200107175927.4558-1-sargun@sargun.me> <20200107175927.4558-3-sargun@sargun.me>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20200107175927.4558-3-sargun-GaZTRHToo+CzQB+pC5nmwQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sargun Dhillon <sargun-GaZTRHToo+CzQB+pC5nmwQ@public.gmane.org>
Cc: "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux FS-devel Mailing List <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Tycho Andersen <tycho-E0fblnxP3wo@public.gmane.org>, Jann Horn <jannh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Aleksa Sarai <cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>, Christian Brauner <christian.brauner-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Gian-Carlo Pascutto <gpascutto-4eJtQOnFJqFBDgjK7y7TUQ@public.gmane.org>, =?UTF-8?Q?Emilio_Cobos_=C3=81lvarez?= <ealvarez-4eJtQOnFJqFBDgjK7y7TUQ@public.gmane.org>, Florian Weimer <fweimer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jed Davis <jld-4eJtQOnFJqFBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Tue, Jan 7, 2020 at 6:59 PM Sargun Dhillon <sargun-GaZTRHToo+CzQB+pC5nmwQ@public.gmane.org> wrote:
> +/**
> + * sys_pidfd_getfd() - Get a file descriptor from another process
> + *
> + * @pidfd:     the pidfd file descriptor of the process
> + * @fd:                the file descriptor number to get
> + * @flags:     flags on how to get the fd (reserved)
> + *
> + * This syscall gets a copy of a file descriptor from another process
> + * based on the pidfd, and file descriptor number. It requires that
> + * the calling process has the ability to ptrace the process represented
> + * by the pidfd. The process which is having its file descriptor copied
> + * is otherwise unaffected.
> + *
> + * Return: On success, a cloexec file descriptor is returned.
> + *         On error, a negative errno number will be returned.
> + */
> +SYSCALL_DEFINE3(pidfd_getfd, int, pidfd, int, fd,
> +               unsigned int, flags)

This is the most sensible definition I can see. I can not tell
whether we should or want to have it, but if everyone thinks
this is a good idea, then this ABI makes sense.

Reviewed-by: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
