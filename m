From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH v1 1/4] lib: introduce copy_struct_from_user() helper
Date: Wed, 25 Sep 2019 13:23:27 -0700
Message-ID: <CAHk-=whSHi46gH-aE8bQsv7hvKDSHpWKQyLW3qF3caAB59cH+g@mail.gmail.com>
References: <20190925165915.8135-1-cyphar@cyphar.com> <20190925165915.8135-2-cyphar@cyphar.com>
 <CAHk-=wjFeNjhtUxQ8npmXORz5RLQU7B_3wD=45eug1+MXnuYvA@mail.gmail.com>
 <20190925172049.skm6ohnnxpofdkzv@yavin> <CAHk-=wjagt257WHiOr2v1Bx_3q7tuzogabw_1EnodKm0vt+-WQ@mail.gmail.com>
 <20190925180412.GK26530@ZenIV.linux.org.uk> <CAHk-=wgcHw-O1sXw2jfJEHSVa2xmJcP9dzUmy71Cqk7_wVLSFQ@mail.gmail.com>
 <20190925194331.GL26530@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190925194331.GL26530@ZenIV.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Aleksa Sarai <cyphar@cyphar.com>, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Alexander Shishkin <alexander.shishkin@linux.intel.com>, Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@kernel.org>, Christian Brauner <christian@brauner.io>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, GNU C Library <libc-alpha@sourceware.org>, Linux API <linux-api@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Wed, Sep 25, 2019 at 12:43 PM Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> FWIW, I would probably add a kernel-space analogue of that thing at the
> same time - check that an area is all-zeroes is not all that rare.

Hmm. Maybe.

> Another thing is that for s390 we almost certainly want something better
> than word-by-word.  IIRC, word-sized userland accesses really hurt there.
> It's nowhere near as critical as with strncpy_from_user(), but with the
> same underlying issue.

Well, s390 does have those magic "area" instructions, but part of why
it's expensive on s390 is that they haven't implemented the
"user_access_begin()/end()' stuff. I think s390 could use that to at
least minimize some of the costs.

With the common case presumably being just a couple of words, it migth
not be worth it doing anything more than that even on s390.

Interestingly (or perhaps not) if I read the internal s390
implementation correctly, they kind of _have_ that concept and they
use it internally. It's just that they call it "enable_sacf_uaccess()"
and "disable_sacf_uaccess()" instead.

           Linus
