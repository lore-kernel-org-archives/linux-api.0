From: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [RFC PATCH v9 for 4.15 01/14] Restartable sequences system call
Date: Fri, 13 Oct 2017 14:05:50 -0700
Message-ID: <CA+55aFwvNS95ByZJTh1yG25QfaD0K0ZByK3iXeeRU8LafFiGFQ@mail.gmail.com>
References: <20171012230326.19984-1-mathieu.desnoyers@efficios.com>
 <20171012230326.19984-2-mathieu.desnoyers@efficios.com> <CA+55aFy54Sk63VkS3HFnd4MPiSbgV6==NaYwr+D9sjG6KZGmHQ@mail.gmail.com>
 <DM5PR15MB1690DA99E4AA74FBE54CF7F9CF480@DM5PR15MB1690.namprd15.prod.outlook.com>
 <CA+55aFzPBES0JOYuZhuNM7NKN+G9ytZQT2daueFPw0j9HGpdGQ@mail.gmail.com> <20171013205418.GM3521@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171013205418.GM3521-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Paul McKenney <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: Ben Maurer <bmaurer-b10kYP2dOMg@public.gmane.org>, Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>, David Goldblatt <davidgoldblatt-b10kYP2dOMg@public.gmane.org>, Qi Wang <qiwang-b10kYP2dOMg@public.gmane.org>, Boqun Feng <boqun.feng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Dave Watson <davejwatson-b10kYP2dOMg@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>, Chris Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Russell King <linux@arm>
List-Id: linux-api@vger.kernel.org

On Fri, Oct 13, 2017 at 1:54 PM, Paul E. McKenney
<paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org> wrote:
>>
>> And if nobody can be bothered to write the user-level code and test
>> this patch-series, then obviously it's not important enough for the
>> kernel to merge it.
>
> My guess is that it will take some time, probably measured in months,
> to carry out this level of integration and testing to.

That would be an argument if this was a new patch series. "Wait a few months".

But that just isn't the case here.

The fact is, these patches have been floating around in one form or
another not for a couple of months, but for years. There's a LWN
article about it from 2015, and it wasn't new back then either (slides
from 2013).

I wouldn't be surprised if there had been academic _papers_ written
about the notion.

So if there  *still* is no actual real code around this, then that
just strengthens my point - no way should we merge something where
people haven't actually bothered to write the user-mode component for
years and years.

It really boils down to: "if nobody can be bothered to write the user
mode parts after several years, why should it be merged into the
kernel"?

I don't think that's too much to ask for.

                Linus
