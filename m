From: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Subject: Re: [PATCHv5 1/3] syscalls,x86: implement execveat() system call
Date: Wed, 22 Oct 2014 11:44:29 -0700
Message-ID: <CALCETrWbj=BTDyKqtbSKteANj3J3UFZnrvWv9DMosCoEZaSoeA@mail.gmail.com>
References: <1413978269-17274-1-git-send-email-drysdale@google.com> <1413978269-17274-2-git-send-email-drysdale@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1413978269-17274-2-git-send-email-drysdale-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Drysdale <drysdale-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Meredydd Luff <meredydd-zPN50pYk8eUaUu29zAJCuw@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, X86 ML <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-arch <linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Wed, Oct 22, 2014 at 4:44 AM, David Drysdale <drysdale-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
> Add a new system execveat(2) syscall. execveat() is to execve() as
> openat() is to open(): it takes a file descriptor that refers to a
> directory, and resolves the filename relative to that.
>

>         bprm->file = file;
> -       bprm->filename = bprm->interp = filename->name;
> +       if (fd == AT_FDCWD || filename->name[0] == '/') {
> +               bprm->filename = filename->name;
> +       } else {
> +               /*
> +                * Build a pathname that reflects how we got to the file,
> +                * either "/dev/fd/<fd>" (for an empty filename) or
> +                * "/dev/fd/<fd>/<filename>".
> +                */
> +               pathbuf = kmalloc(PATH_MAX, GFP_TEMPORARY);
> +               if (!pathbuf) {
> +                       retval = -ENOMEM;
> +                       goto out_unmark;
> +               }
> +               bprm->filename = pathbuf;
> +               if (filename->name[0] == '\0')
> +                       sprintf(pathbuf, "/dev/fd/%d", fd);

If the fd is O_CLOEXEC, then this will result in a confused child
process.  Should we fail exec attempts like that for non-static
programs?  (E.g. set filename to "" or something and fix up the binfmt
drivers to handle that?)

> +               else
> +                       snprintf(pathbuf, PATH_MAX,
> +                                "/dev/fd/%d/%s", fd, filename->name);

Does this need to handle the case where the result exceeds PATH_MAX?

--Andy
