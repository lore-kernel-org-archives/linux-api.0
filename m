From: Florian Weimer <fweimer@redhat.com>
Subject: Re: Official Linux system wrapper library?
Date: Mon, 12 Nov 2018 09:11:10 +0100
Message-ID: <875zx2vhpd.fsf@oldenburg.str.redhat.com>
References: <CAKOZuesB4R=dCz4merWQN0FSCGrXmOgUUr4ienSbStBJguNv8g@mail.gmail.com>
        <bbc12da5-830e-99a7-95e3-d9da42947dc9@gmail.com>
        <877ehjx447.fsf@oldenburg.str.redhat.com>
        <CAKOZues5SEESpJU=6MDTrPXTA1KTZFGNQE4Lw4t0fO-WBTU62w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAKOZues5SEESpJU=6MDTrPXTA1KTZFGNQE4Lw4t0fO-WBTU62w@mail.gmail.com>
        (Daniel Colascione's message of "Sun, 11 Nov 2018 06:22:59 -0800")
Sender: linux-kernel-owner@vger.kernel.org
To: Daniel Colascione <dancol@google.com>
Cc: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>, linux-kernel <linux-kernel@vger.kernel.org>, Joel Fernandes <joelaf@google.com>, Linux API <linux-api@vger.kernel.org>, Willy Tarreau <w@1wt.eu>, Vlastimil Babka <vbabka@suse.cz>, Carlos O'Donell <carlos@redhat.com>, "libc-alpha@sourceware.org" <libc-alpha@sourceware.org>
List-Id: linux-api@vger.kernel.org

* Daniel Colascione:

> If the kernel provides a system call, libc should provide a C wrapper
> for it, even if in the opinion of the libc maintainers, that system
> call is flawed.

It's not that simple, I think.  What about bdflush?  socketcall?
getxpid?  osf_gettimeofday?  set_robust_list?  There are quite a few
irregularities, and some editorial discretion appears to be unavoidable.

Even if we were to provide perfectly consistent system call wrappers
under separate names, we'd still expose different calling conventions
for things like off_t to applications, which would make using some of
the system calls quite difficult and surprisingly non-portable.

Thanks,
Florian
