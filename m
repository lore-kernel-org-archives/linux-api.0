From: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Subject: Re: General flags to turn things off (getrandom, pid lookup, etc)
Date: Fri, 25 Jul 2014 13:21:31 -0700
Message-ID: <CALCETrULRhQCSPsgepntRuCbvx-guEKzpBUT4EoQi2-VU0P8bQ@mail.gmail.com>
References: <CALCETrWGvBfrX1W5XaFgJZhKHLf+oac9YrwPR3ppK=deQtu5hA@mail.gmail.com>
 <20140725201507.GA23410@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140725201507.GA23410-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dave Jones <davej-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Julien Tinnes <jln-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, David Drysdale <drysdale-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Paolo Bonzini <pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, LSM List <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Paul Moore <paul-r2n+y4ga6xFZroRs9YW3xA@public.gmane.org>, James Morris <james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Meredydd Luff <meredydd-zPN50pYk8eUaUu29zAJCuw@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, Henrique de Moraes Holschuh <hmh-N3TV7GIv+o9fyO9Q7EP/yw@public.gmane.org>, linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Fri, Jul 25, 2014 at 1:15 PM, Dave Jones <davej-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> On Fri, Jul 25, 2014 at 11:30:48AM -0700, Andy Lutomirski wrote:
>
>  > There is recent interest in having a way to turn generally-available
>  > kernel features off.  Maybe we should add a good one so we can stop
>  > bikeshedding and avoid proliferating dumb interfaces.
>  >
>  > Things that might want to be turn-off-able include:
>  >  - getrandom with GRND_RANDOM [from the getrandom threads]
>  >  - Any lookup of a non-self pid [from the capsicum thread]
>  >  - Any lookup of a pid outside the caller thread group [capsicum]
>  >  - Various architectural things (personal wishlist), e.g.:
>  >     - RDTSC and userspace HPET access
>  >     - CPUID?
>  >     - 32-bit GDT code segments [huge attack surface]
>  >     - 64-bit GDT code segments [probably pointless]
>
> I'm not sure there's value in disabling cpuid dev interface,
> when the instruction is unprivileged.

I meant the CPUID instruction.  Some CPUs have a setting that turns
off the CPUID instruction for user code.  In principle, all VMs can do
this, too, if the hypervisor would be kind enough to help out.

I only mentioned the x86 stuff here to make the point that there are
quite a few possibilities along these lines.  There's actually already
a way to turn off RDTSC, but it's not currently very useful because it
doesn't do the right thing for the vDSO.  That could be fixed, but
there's certainly no reason to make any of the other stuff here wait
for that.

>
>  > I would propose a new syscall for this:
>  >
>  > long restrict_userspace(int mode, int type, int value, int flags);
>
> do the restrictions happen system-wide like in say SELinux,
> or only within the calling process, like seccomp ?
>

The calling process and children, like seccomp.

--Andy
