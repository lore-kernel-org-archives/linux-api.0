From: Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH] binfmt_elf: Update READ_IMPLIES_EXEC logic for modern CPUs
Date: Tue, 23 Apr 2019 12:25:17 -0700
Message-ID: <CAGXu5j+H_f6NO8VB3JkJZCBbSosY-oqnkEcA8nnTokZGN2QdRw@mail.gmail.com>
References: <20190423181210.GA2443@beast> <CAG48ez0CeTEGDuwr+qAGBwsqm+Drj0dkFfr6_UDc+g-xM4BpiA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAG48ez0CeTEGDuwr+qAGBwsqm+Drj0dkFfr6_UDc+g-xM4BpiA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jann Horn <jannh@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Hector Marco-Gisbert <hecmargi@upv.es>, Jason Gunthorpe <jgg@mellanox.com>, kernel list <linux-kernel@vger.kernel.org>, the arch/x86 maintainers <x86@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Andy Lutomirski <luto@amacapital.net>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Mark Rutland <mark.rutland@arm.com>, linux-arm-kernel <linux-arm-kernel@lists.infradead.org>, musl@lists.openwall.com, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Tue, Apr 23, 2019 at 12:02 PM Jann Horn <jannh@google.com> wrote:
> It's probably worth going a bit more into detail in this description
> on how libraries typically allocate thread stacks.
>
> It looks like glibc will be fine; before commit 54ee14b3882
> (https://sourceware.org/git/?p=glibc.git;a=blobdiff;f=nptl/allocatestack.c;h=dc501650b8629eda4502f2016016f09106cfb526;hp=6ada1fe1381de104153c0627e27f09fe5ad02caa;hb=54ee14b3882;hpb=16a76cd23ce9d3924fa192395e730423e3dc8b36),
> thread stacks were always RWX, and since then, from what I can tell,
> thread stacks were executable depending on the executable's ELF
> headers (as parsed by glibc).

2003, which seems safely (?) in the past. :)

> But e.g. musl's __pthread_create() seems to hardcode
> PROT_READ|PROT_WRITE, which I think would mean that if someone built a
> multithreaded program with nested functions and linked with musl, that
> program would stop working? Or maybe I'm just reading the code wrong.

Rephrasing for myself: this could break multithread binaries linked
with musl and marked with PT_GNU_STACK to RWE since musl doesn't check
ELF headers to determine stack executable-ness when allocating stack
space in __pthread_create().

> Then again, I'm not sure whether anyone actually uses nested functions...

It is blissfully rare, but it seems common (?) for Fortran binaries.
Are there multithreaded fortran binaries linked with musl that will
break because of this? I guess it's possible. If that happens, we can
adjust the logic with notes of an actual case. :)

-- 
Kees Cook
