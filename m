From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH v1 1/4] lib: introduce copy_struct_from_user() helper
Date: Wed, 25 Sep 2019 11:13:18 -0700
Message-ID: <CAHk-=wgcHw-O1sXw2jfJEHSVa2xmJcP9dzUmy71Cqk7_wVLSFQ@mail.gmail.com>
References: <20190925165915.8135-1-cyphar@cyphar.com> <20190925165915.8135-2-cyphar@cyphar.com>
 <CAHk-=wjFeNjhtUxQ8npmXORz5RLQU7B_3wD=45eug1+MXnuYvA@mail.gmail.com>
 <20190925172049.skm6ohnnxpofdkzv@yavin> <CAHk-=wjagt257WHiOr2v1Bx_3q7tuzogabw_1EnodKm0vt+-WQ@mail.gmail.com>
 <20190925180412.GK26530@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190925180412.GK26530@ZenIV.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Aleksa Sarai <cyphar@cyphar.com>, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Alexander Shishkin <alexander.shishkin@linux.intel.com>, Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@kernel.org>, Christian Brauner <christian@brauner.io>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, GNU C Library <libc-alpha@sourceware.org>, Linux API <linux-api@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Wed, Sep 25, 2019 at 11:04 AM Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> IMO it's better to lift reading the first word out of the loop, like this:
>   ...
> Do you see any problems with that variant?

That looks fine to me too.

It's a bit harder for humans to read because of how it reads the word
from user space one iteration early, but from a code generation
standpoint it probably is better.

So slightly subtler source code, and imho harder to read, but it looks
correct to me.

             Linus
