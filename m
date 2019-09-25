From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH v1 1/4] lib: introduce copy_struct_from_user() helper
Date: Wed, 25 Sep 2019 10:10:37 -0700
Message-ID: <CAHk-=wjFeNjhtUxQ8npmXORz5RLQU7B_3wD=45eug1+MXnuYvA@mail.gmail.com>
References: <20190925165915.8135-1-cyphar@cyphar.com> <20190925165915.8135-2-cyphar@cyphar.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190925165915.8135-2-cyphar@cyphar.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Aleksa Sarai <cyphar@cyphar.com>
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Alexander Shishkin <alexander.shishkin@linux.intel.com>, Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@kernel.org>, Christian Brauner <christian@brauner.io>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Al Viro <viro@zeniv.linux.org.uk>, GNU C Library <libc-alpha@sourceware.org>, Linux API <linux-api@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Wed, Sep 25, 2019 at 10:00 AM Aleksa Sarai <cyphar@cyphar.com> wrote:
>
> +int is_zeroed_user(const void __user *from, size_t size)

I like how you've done this, but it's buggy and only works on 64-bit.

All the "u64" and "8" cases need to be "unsigned long" and
"sizeof(unsigned long)".

Part of that requirement is:

> +               unsafe_get_user(val, (u64 __user *) from, err_fault);

This part works fine - although 64-bit accesses migth be much more
expensive and the win of unrolling might not be sufficient - but:

> +               if (align) {
> +                       /* @from is unaligned. */
> +                       val &= ~aligned_byte_mask(align);
> +                       align = 0;
> +               }

This part fundamentally only works on 'unsigned long'.

         Linus
