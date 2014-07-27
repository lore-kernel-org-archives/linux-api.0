From: David Drysdale <drysdale-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: General flags to turn things off (getrandom, pid lookup, etc)
Date: Sun, 27 Jul 2014 13:26:11 +0100
Message-ID: <CAHse=S-UoSgLoV4nwv3rbTHZjdVWAy44AAXLVoZ7N4kynZwGJA@mail.gmail.com>
References: <CALCETrWGvBfrX1W5XaFgJZhKHLf+oac9YrwPR3ppK=deQtu5hA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CALCETrWGvBfrX1W5XaFgJZhKHLf+oac9YrwPR3ppK=deQtu5hA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Cc: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Julien Tinnes <jln-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Paolo Bonzini <pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, LSM List <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Paul Moore <paul-r2n+y4ga6xFZroRs9YW3xA@public.gmane.org>, James Morris <james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Meredydd Luff <meredydd-zPN50pYk8eUaUu29zAJCuw@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, Henrique de Moraes Holschuh <hmh-N3TV7GIv+o9fyO9Q7EP/yw@public.gmane.org>, linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Fri, Jul 25, 2014 at 7:30 PM, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org> wrote:
> [new thread because this sort of combines two threads]
>
> There is recent interest in having a way to turn generally-available
> kernel features off.  Maybe we should add a good one so we can stop
> bikeshedding and avoid proliferating dumb interfaces.
>
> Things that might want to be turn-off-able include:
>  - getrandom with GRND_RANDOM [from the getrandom threads]
>  - Any lookup of a non-self pid [from the capsicum thread]
>  - Any lookup of a pid outside the caller thread group [capsicum]
>  - Various architectural things (personal wishlist), e.g.:
>     - RDTSC and userspace HPET access
>     - CPUID?
>     - 32-bit GDT code segments [huge attack surface]
>     - 64-bit GDT code segments [probably pointless]
>
> I would propose a new syscall for this:
>
> long restrict_userspace(int mode, int type, int value, int flags);
>
> mode is RESTRICT_SET, RESTRICT_GET, or RESTRICT_LOCK.
>
> type is RESTRICT_GRND_RANDOM, RESTRICT_PID_SCOPE, RESTRICT_X86_TIMING, etc.
>
> Value is zero if RESTRICT_GET.  Otherwise value is the desired value,
> generally 0 or 1.  For RESTRICT_PID_SCOPE, value would be
> RESTRICT_PID_SCOPE_ANY, RESTRICT_PID_SCOPE_THREADGROUP, or
> RESTRICT_PID_SCOPE_SELF.
>
> flags must be zero.  Someday, someone will propose a thread-sync flag.

Today, me: proposed :-)

> restrict_userspace requires either no_new_privs or CAP_SYS_ADMIN in
> the current user namespace.
>
> Thoughts?
>
> --Andy
>
> --
> Andy Lutomirski
> AMA Capital Management, LLC
