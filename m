From: "Richard W.M. Jones" <rjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: umask2 man page (was: Re: [PATCH v4 0/3] vfs: Define new syscall
 umask2 [formerly getumask])
Date: Wed, 13 Apr 2016 20:29:56 +0100
Message-ID: <20160413192955.GA28599@redhat.com>
References: <1460574336-18930-1-git-send-email-rjones@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: attachment; filename="umask2.2.txt"
In-Reply-To: <1460574336-18930-1-git-send-email-rjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org, zab-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, emunson-JqFfY2XvxFXQT0dZR+AlfA@public.gmane.org, paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org, xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org, sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org, milosz-B5zB6C1i6pkAvxtiuMwx3w@public.gmane.org, rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, gorcunov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, iulia.manda21-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, mguzik-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, adobriyan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, dave-h16yJtLeMjHk1uMJSBkQmQ@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, gorcunov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, fw-d32yF4oPJVt0XxTmqZlbVQ@public.gmane.org, walters-gPq2gbYjIk8dnm+yROfE0A@public.gmane.org
List-Id: linux-api@vger.kernel.org

UMASK(2)                   Linux Programmer's Manual                  U=
MASK(2)



NAME
       umask, umask2 - get and set file mode creation mask

SYNOPSIS
       #include <sys/types.h>
       #include <sys/stat.h>

       mode_t umask(mode_t mask);

       #define _GNU_SOURCE
       #include <fcntl.h>
       #include <sys/types.h>
       #include <sys/stat.h>

       mode_t umask2(mode_t mask, int flags);

DESCRIPTION
       umask()  sets  the calling process's file mode creation mask (um=
ask) to
       mask & 0777 (i.e., only the file permission bits of mask are use=
d), and
       returns the previous value of the mask.

       If flags is 0, then umask2() is the same as umask().

       If flags is UMASK_GET_MASK then umask2() ignores the mask parame=
ter and
       returns the process's current umask.  The process's current mask=
 is not
       modified in this case.

       The  umask  is  used  by open(2), mkdir(2), and other system cal=
ls that
       create files to modify the permissions placed on newly created f=
iles or
       directories.   Specifically,  permissions  in  the umask are tur=
ned off
       from the mode argument to open(2) and mkdir(2).

       Alternatively, if the parent directory has a default ACL (see  a=
cl(5)),
       the umask is ignored, the default ACL is inherited, the permissi=
on bits
       are set based on the inherited ACL, and permission bits absent  =
in  the
       mode  argument  are turned off.  For example, the following defa=
ult ACL
       is equivalent to a umask of 022:

           u::rwx,g::r-x,o::r-x

       Combining the effect of this default ACL with a mode argument  o=
f  0666
       (rw-rw-rw-), the resulting file permissions would be 0644 (rw-r-=
-r--).

       The  constants  that should be used to specify mask are describe=
d under
       stat(2).

       The typical default value for the process  umask  is  S_IWGRP | =
S_IWOTH
       (octal  022).   In the usual case where the mode argument to ope=
n(2) is
       specified as:

           S_IRUSR | S_IWUSR | S_IRGRP | S_IWGRP | S_IROTH | S_IWOTH

       (octal 0666) when creating a new file, the permissions on the re=
sulting
       file will be:

           S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH

       (because 0666 & ~022 =3D 0644; i.e., rw-r--r--).

RETURN VALUE
       The  umask()  system call always succeeds and the previous value=
 of the
       mask is returned.

       The umask2() system call returns the process's current  umask  o=
n  suc=E2=80=90
       cess.  On error it returns -1 and sets errno appropriately.

CONFORMING TO
       SVr4, 4.3BSD, POSIX.1-2001.

NOTES
       A  child  process created via fork(2) inherits its parent's umas=
k.  The
       umask is left unchanged by execve(2).

       The umask setting also affects the permissions assigned  to  POS=
IX  IPC
       objects  (mq_open(3), sem_open(3), shm_open(3)), FIFOs (mkfifo(3=
)), and
       UNIX domain sockets (unix(7)) created by the process.  The  umas=
k  does
       not  affect the permissions assigned to System V IPC objects cre=
ated by
       the process (using msgget(2), semget(2), shmget(2)).

SEE ALSO
       chmod(2), mkdir(2), open(2), stat(2), acl(5)

COLOPHON
       This page is part of release 4.00 of the Linux  man-pages  proje=
ct.   A
       description  of  the project, information about reporting bugs, =
and the
       latest    version    of    this    page,    can     be     found=
     at
       http://www.kernel.org/doc/man-pages/.



Linux                             2016-04-13                          U=
MASK(2)
