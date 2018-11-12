From: Daniel Colascione <dancol@google.com>
Subject: Re: Official Linux system wrapper library?
Date: Mon, 12 Nov 2018 05:19:14 -0800
Message-ID: <CAKOZuetdgk1QYhx1538-98rFpogMin=8DkPnCtU9_=ip23Vk7w@mail.gmail.com>
References: <CAKOZuesB4R=dCz4merWQN0FSCGrXmOgUUr4ienSbStBJguNv8g@mail.gmail.com>
 <bbc12da5-830e-99a7-95e3-d9da42947dc9@gmail.com> <877ehjx447.fsf@oldenburg.str.redhat.com>
 <CAKOZues5SEESpJU=6MDTrPXTA1KTZFGNQE4Lw4t0fO-WBTU62w@mail.gmail.com> <875zx2vhpd.fsf@oldenburg.str.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <875zx2vhpd.fsf@oldenburg.str.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Florian Weimer <fweimer@redhat.com>
Cc: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>, linux-kernel <linux-kernel@vger.kernel.org>, Joel Fernandes <joelaf@google.com>, Linux API <linux-api@vger.kernel.org>, Willy Tarreau <w@1wt.eu>, Vlastimil Babka <vbabka@suse.cz>, Carlos O'Donell <carlos@redhat.com>, "libc-alpha@sourceware.org" <libc-alpha@sourceware.org>
List-Id: linux-api@vger.kernel.org

On Mon, Nov 12, 2018 at 12:11 AM, Florian Weimer <fweimer@redhat.com> wrote:
> * Daniel Colascione:
>
>> If the kernel provides a system call, libc should provide a C wrapper
>> for it, even if in the opinion of the libc maintainers, that system
>> call is flawed.
>
> It's not that simple, I think.  What about bdflush?  socketcall?
> getxpid?  osf_gettimeofday?  set_robust_list?

What about them? Mentioning that these system calls exist is not in
itself an argument.

> There are quite a few
> irregularities

So?

> and some editorial discretion appears to be unavoidable.

That's an assertion, not an argument, and I strongly disagree. *Why*
do you think "editorial discretion" is unavoidable? What privileges
glibc's judgement here? What would go wrong if socketcall and
set_robust_list and so on had wrappers? If applications chose to use
these lower-level wrappers instead of higher-level facilities, they
take on responsibility for using the APIs properly.

> Even if we were to provide perfectly consistent system call wrappers
> under separate names, we'd still expose different calling conventions
> for things like off_t to applications, which would make using some of
> the system calls quite difficult and surprisingly non-portable.

We can learn something from how Windows does things. On that system,
what we think of as "libc" is actually two parts. (More, actually, but
I'm simplifying.) At the lowest level, you have the semi-documented
ntdll.dll, which contains raw system call wrappers and arcane
kernel-userland glue. On top of ntdll live the "real" libc
(msvcrt.dll, kernel32.dll, etc.) that provide conventional
application-level glue. The tight integration between ntdll.dll and
the kernel allows Windows to do very impressive things. (For example,
on x86_64, Windows has no 32-bit ABI as far as the kernel is
concerned! You can still run 32-bit programs though, and that works
via ntdll.dll essentially shimming every system call and switching the
processor between long and compatibility mode as needed.) Normally,
you'd use the higher-level capabilities, but if you need something in
ntdll (e.g., if you're Cygwin) nothing stops your calling into the
lower-level system facilities directly. ntdll is tightly bound to the
kernel; the higher-level libc, not so.

We should adopt a similar approach. Shipping a lower-level
"liblinux.so" tightly bound to the kernel would not only let the
kernel bypass glibc's "editorial discretion" in exposing new
facilities to userspace, but would also allow for tighter user-kernel
integration that one can achieve with a simplistic syscall(2)-style
escape hatch. (For example, for a long time now, I've wanted to go
beyond POSIX and improve the system's signal handling API, and this
improvement requires userspace cooperation.) The vdso is probably too
small and simplistic to serve in this role; I'd want a real library.
