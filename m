From: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Subject: Re: [RFC PATCH v9 for 4.15 01/14] Restartable sequences system call
Date: Wed, 18 Oct 2017 16:28:12 +0000 (UTC)
Message-ID: <505591961.43853.1508344092267.JavaMail.zimbra@efficios.com>
References: <20171012230326.19984-1-mathieu.desnoyers@efficios.com> <CA+55aFwvNS95ByZJTh1yG25QfaD0K0ZByK3iXeeRU8LafFiGFQ@mail.gmail.com> <135399003.40850.1507930608890.JavaMail.zimbra@efficios.com> <165916d7-2f86-445a-9c84-f6444b5e753b@redhat.com> <20171016164600.GO2482@two.firstfloor.org> <21865534.42661.1508192263844.JavaMail.zimbra@efficios.com> <CY4PR15MB168879D6220D976B04FE482CCF4C0@CY4PR15MB1688.namprd15.prod.outlook.com> <20171018062226.GB18857@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171018062226.GB18857-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Cc: Ben Maurer <bmaurer-b10kYP2dOMg@public.gmane.org>, Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>, Carlos O'Donell <carlos-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, David Goldblatt <davidgoldblatt-b10kYP2dOMg@public.gmane.org>, Qi Wang <qiwang-b10kYP2dOMg@public.gmane.org>, Boqun Feng <boqun.feng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Dave Watson <davejwatson-b10kYP2dOMg@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Chris Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>Andrew
List-Id: linux-api@vger.kernel.org

----- On Oct 18, 2017, at 2:22 AM, Greg Kroah-Hartman gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org wrote:

> On Tue, Oct 17, 2017 at 04:19:41PM +0000, Ben Maurer wrote:
>> Hey,
>> 
>> > So far the restrictions I see for libraries using this symbol are:
>> > - They should never be unloaded,
>> > - They should never be loaded with dlopen RTLD_LOCAL flag.
>> 
>> We talked a bit about this off-list but I wanted to state publicly
>> that I think this model works well for our use case. Specifically,
>> 
>> (1) It reduces complexity by focusing on the common case -- long term
>> we expect glibc to manage the process of using this feature and
>> registering/deregistering threads for rseq. Unloading isn't a
>> challenge in these situations, so why add the complexity for it?
> 
> You never install a new version of glibc on a running system, and expect
> everything to keep running successfully?  Breaking that would not be
> good...

If we share the __rseq_abi TLS weak symbol between glibc, applications,
and early-adopter libraries, we just need those early adopters to
check whether the TLS is already registered (cpu_id field >= 0), and
don't bother doing their lazy registration if it's already been done
for them (either by glibc or by the application).

If either the application or a lazy-registering library gets a EBUSY
errno from rseq registration, it can consider that another library
already performed the registration for them (probably glibc).

As long as early adopter libraries don't expect to be sole users
of __rseq_abi, upgrading to newer glibc should work fine.

But this means we need to get all early adopters to get it right from
the get-go, or things could break when you compose them.

Thoughts ?

Thanks,

Mathieu

> 
> thanks,
> 
> greg k-h

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
