From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Subject: Re: Official Linux system wrapper library?
Date: Sun, 11 Nov 2018 07:55:30 +0100
Message-ID: <bbc12da5-830e-99a7-95e3-d9da42947dc9@gmail.com>
References: <CAKOZuesB4R=dCz4merWQN0FSCGrXmOgUUr4ienSbStBJguNv8g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAKOZuesB4R=dCz4merWQN0FSCGrXmOgUUr4ienSbStBJguNv8g@mail.gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Daniel Colascione <dancol@google.com>, linux-kernel <linux-kernel@vger.kernel.org>
Cc: mtk.manpages@gmail.com, Joel Fernandes <joelaf@google.com>, Linux API <linux-api@vger.kernel.org>, Willy Tarreau <w@1wt.eu>, Vlastimil Babka <vbabka@suse.cz>, Florian Weimer <fweimer@redhat.com>, Carlos O'Donell <carlos@redhat.com>, "libc-alpha@sourceware.org" <libc-alpha@sourceware.org>
List-Id: linux-api@vger.kernel.org

[adding in glibc folk for comment]

On 11/10/18 7:52 PM, Daniel Colascione wrote:
> Now that glibc is basically not adding any new system call wrappers,
> how about publishing an "official" system call glue library as part of
> the kernel distribution, along with the uapi headers? I don't think
> it's reasonable to expect people to keep using syscall(__NR_XXX) for
> all new functionality, especially as the system grows increasingly
> sophisticated capabilities (like the new mount API, and hopefully the
> new process API) outside the strictures of the POSIX process.

As a quick glance at the glibc NEWS file shows, the above is not
quite true:

[[
Version 2.28
* The renameat2 function has been added...
* The statx function has been added...

Version 2.27
* Support for memory protection keys was added.  The <sys/mman.h> header now
  declares the functions pkey_alloc, pkey_free, pkey_mprotect...
* The copy_file_range function was added.

Version 2.26
* New wrappers for the Linux-specific system calls preadv2 and pwritev2.

Version 2.25
* The getrandom [function] have been added.
]]

I make that 11 system call wrappers added in the last 2 years.

That said, of course, there are many system calls that lack wrappers [1],
and the use of syscall() is undesirable.

The glibc folk do have their reasons for being conservative around
adding system calls (https://lwn.net/Articles/655028/). However, at
this point, I think one of the limiting factors is developer time
on the glibc project. Quite possibly, they just need some help to
add more (properly designed) wrappers faster.

Cheers,

Michael

[1] https://sourceware.org/bugzilla/show_bug.cgi?id=6399 is a
    longstanding example.

-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
