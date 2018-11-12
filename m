From: Daniel Colascione <dancol@google.com>
Subject: Re: Official Linux system wrapper library?
Date: Mon, 12 Nov 2018 06:40:00 -0800
Message-ID: <CAKOZuevg6Bivv_E1CnhZA8OrUtSyCcwZPcNo7zE3J6+tQcEP7w@mail.gmail.com>
References: <CAKOZuesB4R=dCz4merWQN0FSCGrXmOgUUr4ienSbStBJguNv8g@mail.gmail.com>
 <bbc12da5-830e-99a7-95e3-d9da42947dc9@gmail.com> <877ehjx447.fsf@oldenburg.str.redhat.com>
 <CAKOZues5SEESpJU=6MDTrPXTA1KTZFGNQE4Lw4t0fO-WBTU62w@mail.gmail.com>
 <45cf58e0-909e-262c-5b9f-b91d62350a79@arm.com> <20181112143506.GC7377@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181112143506.GC7377@thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "Theodore Y. Ts'o" <tytso@mit.edu>, Szabolcs Nagy <Szabolcs.Nagy@arm.com>, Daniel Colascione <dancol@google.com>, Florian Weimer <fweimer@redhat.com>, nd <nd@arm.com>, "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>, linux-kernel <linux-kernel@vger.kernel.org>, Joel Fernandes <joelaf@google.com>, Linux API <linux-api@vger.kernel.org>, Willy Tarreau <w@1wt.eu>, Vlastimil Babka <vbabka@suse.cz>, Carlos O'Donell <carlos@redhat.com>, "libc-alpha@sourceware.org" <libc-alpha@sourceware.org>
List-Id: linux-api@vger.kernel.org

On Mon, Nov 12, 2018 at 6:35 AM, Theodore Y. Ts'o <tytso@mit.edu> wrote:
> On Mon, Nov 12, 2018 at 12:45:26PM +0000, Szabolcs Nagy wrote:
>> >> A lot of the new system calls lack clear specifications or are just
>> >> somewhat misdesigned.  For example, pkey_alloc
>> > [snip]
>> >> getrandom still causes boot delays
>
> I'll note that what some people consider misdesigns, others consider
> "fix CVE's".
>
> Some people may consider it more important to avoid boot delays;
> others would consider internet-wide security problems, ala
> https://factorable.net to be higher priority.
>
> It's clear this is one area where I and some glibc developers have had
> a difference of opinion.  The bigger problem is that if a single glibc
> developer is able to veto any new system call, maybe we *do* need to
> have a kernel-provided library which bypasses glibc....

Historically speaking, the liberum veto has not led to good governance.
