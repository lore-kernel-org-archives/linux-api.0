From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH v1 1/4] lib: introduce copy_struct_from_user() helper
Date: Wed, 25 Sep 2019 10:48:31 -0700
Message-ID: <CAHk-=wjagt257WHiOr2v1Bx_3q7tuzogabw_1EnodKm0vt+-WQ@mail.gmail.com>
References: <20190925165915.8135-1-cyphar@cyphar.com> <20190925165915.8135-2-cyphar@cyphar.com>
 <CAHk-=wjFeNjhtUxQ8npmXORz5RLQU7B_3wD=45eug1+MXnuYvA@mail.gmail.com> <20190925172049.skm6ohnnxpofdkzv@yavin>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190925172049.skm6ohnnxpofdkzv@yavin>
Sender: linux-kernel-owner@vger.kernel.org
To: Aleksa Sarai <cyphar@cyphar.com>
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Alexander Shishkin <alexander.shishkin@linux.intel.com>, Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@kernel.org>, Christian Brauner <christian@brauner.io>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Al Viro <viro@zeniv.linux.org.uk>, GNU C Library <libc-alpha@sourceware.org>, Linux API <linux-api@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Wed, Sep 25, 2019 at 10:21 AM Aleksa Sarai <cyphar@cyphar.com> wrote:
>
> Just to make sure I understand, the following diff would this solve the
> problem? If so, I'll apply it, and re-send in a few hours.

Actually, looking at it more, it's still buggy.

That final "size smaller than unsigned long" doesn't correctly handle
the case of (say) a single byte in the middle of a 8-byte word.

So you need to do something like this:

    int is_zeroed_user(const void __user *from, size_t size)
  {
        unsigned long val, mask, align;

        if (unlikely(!size))
                return true;

        if (!user_access_begin(from, size))
                return -EFAULT;

        align = (uintptr_t) from % sizeof(unsigned long);
        from -= align;
        size += align;

        mask = ~aligned_byte_mask(align);

        while (size >= sizeof(unsigned long)) {
                unsafe_get_user(val, (unsigned long __user *) from, err_fault);
                val &= mask;
                if (unlikely(val))
                        goto done;
                mask = ~0ul;
                from += sizeof(unsigned long);
                size -= sizeof(unsigned long);
        }

        if (size) {
                /* (@from + @size) is unaligned. */
                unsafe_get_user(val, (unsigned long __user *) from, err_fault);
                mask &= aligned_byte_mask(size);
                val &= mask;
        }

  done:
        user_access_end();
        return (val == 0);
  err_fault:
        user_access_end();
        return -EFAULT;
  }

note how "mask" carries around from the very beginning all the way to
the end, and "align" itself is no longer used after mask has been
calculated.

That's required because of say a 2-byte read at offset 5. You end up
with "align=5, size=7" at the beginning, and mask needs to be
0x00ffff0000000000 (on little-endian) for that final access.

Anyway, I checked, and the above seems to generate ok code quality
too. Sadly "unsafe_get_user()" cannot use "asm goto" because of a gcc
limitation (no asm goto with outputs), so it's not _perfect_, but
that's literally a compiler limitation.

But I didn't actually _test_ the end result. You should probably
verify that it gets the right behavior exactly for those interesting
cases where we mask both the beginning and the end.

            Linus
