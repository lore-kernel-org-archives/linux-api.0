From: Jann Horn <jannh@google.com>
Subject: Re: For review: documentation of clone3() system call
Date: Mon, 28 Oct 2019 16:12:09 +0100
Message-ID: <CAG48ez3q=BeNcuVTKBN79kJui4vC6nw0Bfq6xc-i0neheT17TA@mail.gmail.com>
References: <CAKgNAkjo2WHq+zESU1iuCHJJ0x-fTNrakS9-d1+BjzUuV2uf2Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAKgNAkjo2WHq+zESU1iuCHJJ0x-fTNrakS9-d1+BjzUuV2uf2Q@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Michael Kerrisk-manpages <mtk.manpages@gmail.com>
Cc: Christian Brauner <christian@brauner.io>, lkml <linux-kernel@vger.kernel.org>, linux-man <linux-man@vger.kernel.org>, Kees Cook <keescook@chromium.org>, Florian Weimer <fweimer@redhat.com>, Oleg Nesterov <oleg@redhat.com>, Arnd Bergmann <arnd@arndb.de>, David Howells <dhowells@redhat.com>, Pavel Emelyanov <xemul@virtuozzo.com>, Andrew Morton <akpm@linux-foundation.org>, Adrian Reber <adrian@lisas.de>, Andrei Vagin <avagin@gmail.com>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Fri, Oct 25, 2019 at 6:59 PM Michael Kerrisk (man-pages)
<mtk.manpages@gmail.com> wrote:
> I've made a first shot at adding documentation for clone3(). You can
> see the diff here:
> https://git.kernel.org/pub/scm/docs/man-pages/man-pages.git/commit/?id=3D=
faa0e55ae9e490d71c826546bbdef954a1800969
[...]
>    clone3()
>        The  clone3() system call provides a superset of the functionality
>        of the older clone() interface.  It also provides a number of  API
>        improvements,  including: space for additional flags bits; cleaner
>        separation in the use of various arguments;  and  the  ability  to
>        specify the size of the child's stack area.

You might want to note somewhere that its flags can't be
seccomp-filtered because they're stored in memory, making it
inappropriate to use in heavily sandboxed processes.

>            struct clone_args {
>                u64 flags;        /* Flags bit mask */
>                u64 pidfd;        /* Where to store PID file descriptor
>                                     (int *) */
>                u64 child_tid;    /* Where to store child TID,
>                                     in child's memory (int *) */
>                u64 parent_tid;   /* Where to store child TID,
>                                     in parent's memory (int *) */
>                u64 exit_signal;  /* Signal to deliver to parent on
>                                     child termination */
>                u64 stack;        /* Pointer to lowest byte of stack */
>                u64 stack_size;   /* Size of stack */
>                u64 tls;          /* Location of new TLS */
>            };
>
>        The size argument that is supplied to clone3() should be  initial=
=E2=80=90
>        ized  to  the  size of this structure.  (The existence of the size
>        argument permits future extensions to the clone_args structure.)
>
>        The stack for the child process is  specified  via  cl_args.stack,
>        which   points   to  the  lowest  byte  of  the  stack  area,  and

Here and in the comment in the struct above, you say that .stack
"points to the lowest byte of the stack area", but isn't that
architecture-dependent? For most architectures, I think it should
instead be "is the initial stack pointer", with the exception of IA64
(and maybe others, I'm not sure). For example, on X86, when launching
a thread with an initially empty stack, it points directly *after* the
end of the stack area.

>        cl_args.stack_size, which specifies  the  size  of  the  stack  in
>        bytes.   In the case where the CLONE_VM flag (see below) is speci=
=E2=80=90

stack_size is ignored on most architectures.

>        fied, a stack must be explicitly allocated and specified.   Other=
=E2=80=90
>        wise,  these  two  fields  can  be  specified as NULL and 0, which
>        causes the child to use the same stack area as the parent (in  the
>        child's own virtual address space).
[...]
>    Equivalence between clone() and clone3() arguments
>        Unlike  the  older  clone()  interface, where arguments are passed
>        individually, in the newer clone3() interface  the  arguments  are
>        packaged  into  the clone_args structure shown above.  This struc=
=E2=80=90
>        ture allows for a superset  of  the  information  passed  via  the
>        clone() arguments.
>
>        The following table shows the equivalence between the arguments of
>        clone() and the fields in  the  clone_args  argument  supplied  to
>        clone3():
>
>               clone()         clone(3)        Notes
>                               cl_args field
>               flags & ~0xff   flags
>               parent_tid      pidfd           See CLONE_PIDFD
>               child_tid       child_tid       See CLONE_CHILD_SETTID
>               parent_tid      parent_tid      See CLONE_PARENT_SETTID
>               flags & 0xff    exit_signal
>               stack           stack
>
>               ---             stack_size

(except that on ia64, stack_size also exists in clone2(), and if
you're not on ia64, stack_size doesn't do anything, at least on X86,
so showing them side by side like this doesn't really make sense)
