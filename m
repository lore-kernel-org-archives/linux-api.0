From: "Andries E. Brouwer" <Andries.Brouwer-rh8NL+sEX9E@public.gmane.org>
Subject: Re: [patch 0/3] [RFC] kernel/glibc mismatch of "readlink" syscall?
Date: Tue, 28 Oct 2008 10:11:48 +0100
Message-ID: <20081027204509.GA27111@ub>
References: <20081023145054.998439866@marvin.suse.de> <cfd18e0f0810241553x77194611o11655a89871dc210@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <cfd18e0f0810241553x77194611o11655a89871dc210-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: Daniel Gollub <dgollub-l3A5Bk7waGM@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ltp-list-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, "A.E. Brouwer" <aeb-ek1Qb6IBo2Pz+pZb47iToQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Fri, Oct 24, 2008 at 05:53:25PM -0500, Michael Kerrisk wrote:

> Hi Daniel,
> 
> On Thu, Oct 23, 2008 at 9:50 AM, Daniel Gollub <dgollub-l3A5Bk7waGM@public.gmane.org> wrote:
>>
>> found something which looks for me like a kernel/glibc syscall mismatch.
>>
>> The standard and the manpages and glibc have
>> ssize_t readlink(..., size_t bufsize);
>>
>> But the kernel has
>>
>> linux-2.6/include/linux/syscalls.h:
>> asmlinkage long sys_readlink(..., int bufsiz);
>>
>> All readlink prototypes, expect the one in the kernel, have an unsigned
>> buffer size.
> 
> I agree; the inconsistency is strange.

Hmm. I am inclined not to agree. There is no reason to expect
any particular relation between the kernel prototype of sys_foo
(if such a function exists)
and the user space prototype of the foo() C-library function.

The POSIX standard, man-pages, libc include files document the
userspace / libc interface, not the system call interface.
The system call interface is mostly undocumented.

The kernel prototype is chosen for kernel-internal or historical reasons.

Andries


sys_ppc32.c:
/* Note: it is necessary to treat bufsiz as an unsigned int ... */
asmlinkage long compat_sys_readlink(..., u32 bufsiz)

--
To unsubscribe from this list: send the line "unsubscribe linux-man" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
