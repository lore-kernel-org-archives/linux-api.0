From: Adhemerval Zanella <adhemerval.zanella-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: Seccomp implications for glibc wrapper function changes
Date: Tue, 7 Nov 2017 19:14:54 -0200
Message-ID: <be4cc7fc-90c2-4370-2eab-8948d0ba75be@linaro.org>
References: <CAKgNAkixA6T7J_1Gs=5+riq6i=dr9XP4ZCGu67YVcuDNg3cT4g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAKgNAkixA6T7J_1Gs=5+riq6i=dr9XP4ZCGu67YVcuDNg3cT4g-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-GB
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, "libc-alpha-9JcytcrH/bA+uJoB2kUjGw@public.gmane.org" <libc-alpha-9JcytcrH/bA+uJoB2kUjGw@public.gmane.org>
Cc: Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org



On 07/11/2017 18:35, Michael Kerrisk (man-pages) wrote:
> Hello,
> 
> I was recently testing some code I'd written a while back that makes
> use of seccomp filters to control which system calls a process can
> make, and I got a surpise when someone showed the code no longer
> worked in on a system that had glibc 2.26.
> 
> The behavior change resulted from Adhemerval's glibc commit
> 
>      commit b41152d716ee9c5ba34495a54e64ea2b732139b5
>      Author: Adhemerval Zanella <adhemerval.zanella-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
>      Date:   Fri Nov 11 15:00:03 2016 -0200
> 
>         Consolidate Linux open implementation
>             [...]
>             3. Use __NR_openat as default syscall for open{64}.
> 
> The commit in question changed the glibc open() wrapper to swtcch from
> use the kernel's open() system call to using the kernel's openat()
> system call.
> 
> This change broke my code that was doing seccomp filtering for the
> open() system call number (__NR_open). The breakage in question is not
> serious, since this was really just demonstration code. However, I
> want to raise awareness that these sorts of changes have the potential
> to possibly cause breakages for some code using seccomp, and note that
> I think such changes should not be made lightly or gratuitously. (In
> the above commit, it's not clear why the switch was made to using
> openat(): there's no mention of the reasoning in the commit message,
> nor is there anything that is obvious from reading through the code
> change itself.)

Your code would 'break' if you run with on a new architecture that does
not implement __NR_open, which it is the default for new architecture
on Linux.

In fact I hardly consider this is a 'break' since the user API we
export does not have any constraint which underlying syscall we use.
For instance, a user can seccomp gettimeofday syscall on a system
without vDSO just to found out it is 'broken' on a vDSO kernel.

I think we should not constraint for this specific usercase; if one
is doing syscall filtering it is expected system level knowledge to
handle all possible syscalls related.  For instance, I would expect
that if the idea is to filtering open() libc implementation the
program should also filter __NR_openat and __NR_openat2 since it
is semantically possible to implement open() with __NR_openat2 if
the syscall is available.

Now for the reasoning of using __NR_openat is since we have support
for it on all architecture it meant less logic to handle possible
architecture differences. 
