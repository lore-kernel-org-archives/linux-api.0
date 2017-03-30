From: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Subject: Re: [PATCH RFC 0/4] proc: support multiple separate proc instances
 per pidnamespace
Date: Thu, 30 Mar 2017 12:12:31 -0700
Message-ID: <CALCETrWooKTtViVh4ik9e-3nLs3NET9wptgxhjS9V499sfUJQA@mail.gmail.com>
References: <1490887379-25880-1-git-send-email-tixxdz@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1490887379-25880-1-git-send-email-tixxdz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Djalal Harouni <tixxdz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Alexey Gladkov <gladkov.alexey-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, James Bottomley <James.Bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Dongsu Park <dpark-VwIFZPTo/vqsTnJN9+BGXg@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Alexey Dobriyan <adobriyan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "kernel-hardening-ZwoEplunGu1jrUoiu81ncdBPR1lH4CV8@public.gmane.org" <kernel-hardening-ZwoEplunGu1jrUoiu81ncdBPR1lH4CV8@public.gmane.org>, LSM List <linux-security-module-u79uwXL29TY@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Thu, Mar 30, 2017 at 8:22 AM, Djalal Harouni <tixxdz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> Hi,
>
> This RFC can be applied on top of Linus' tree 89970a04d7
>
> This RFC implements support for multiple separate proc instances inside
> the same pid namespace. This allows to solve lot of problems that
> today's use case face.
>
> Historically procfs was tied to pid namespaces, and mount options were
> propagated to all other procfs instances in the same pid namespace. This
> solved several use cases in that time. However today we face new
> problems, there are mutliple container implementations there, some of
> them want to hide pid entries, others want to hide non-pid entries,
> others want to have sysctlfs, others want to share pid namespace with
> private procfs mounts. All these with current implementation won't work
> since all options will be propagated to all procfs mounts.
>
> This series allow to have new instances of procfs per pid namespace where
> each instance can have its own mount option inside the same pid namespace=
.
> This was also suggested by Andy Lutomirski.
>
>
> Now:
> $ sudo mount -t proc -o unshare,hidepid=3D2 none /test
>
> The option 'unshare' will allow to mount a new instance of procfs inside
> the same pid namespace.
>
> Before:
> $ stat /proc/slabinfo
>
>   File: =E2=80=98/proc/slabinfo=E2=80=99
>   Size: 0               Blocks: 0          IO Block: 1024   regular empty=
 file
> Device: 4h/4d   Inode: 4026532046  Links: 1
>
> $ stat /test3/slabinfo
>
>   File: =E2=80=98/test3/slabinfo=E2=80=99
>   Size: 0               Blocks: 0          IO Block: 1024   regular empty=
 file
> Device: 4h/4d   Inode: 4026532046  Links: 1
>
>
> After:
> $ stat /proc/slabinfo
>
>   File: =E2=80=98/proc/slabinfo=E2=80=99
>   Size: 0               Blocks: 0          IO Block: 1024   regular empty=
 file
> Device: 4h/4d   Inode: 4026532046  Links: 1
>
> $ stat /test3/slabinfo
>
>   File: =E2=80=98/test3/slabinfo=E2=80=99
>   Size: 0               Blocks: 0          IO Block: 1024   regular empty=
 file
> Device: 31h/49d Inode: 4026532046  Links: 1
>
>
> Any better name for the option 'unshare' ? suggestions ?
>
> I was going to use 'version=3D2' but then this may sound more like a
> proc2 fs which currently impossible to implement since it will share
> locks with the old proc.
>
>
> Al, Eric any comments please ?

I like the concept, except that I think it would be nice to avoid
needing 'unshare', perhaps by making unsharing the default and making
hidepid work backwards compatibly if needed.
