From: Palmer Dabbelt <palmer@dabbelt.com>
Subject: Re: [PATCH 04/13] Always expose MAP_UNINITIALIZED to userspace
Date: Mon, 14 Sep 2015 17:52:24 -0700 (PDT)
Message-ID: <55f76bc8.2108450a.97c6e.129a__14936.612887732$1442278392$gmane$org@mx.google.com>
References: <20150915002358.GA12618@node.dhcp.inet.fi>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20150915002358.GA12618@node.dhcp.inet.fi>
Sender: linux-fsdevel-owner@vger.kernel.org
To: kirill@shutemov.name, arnd@arndb.de
Cc: dhowells@redhat.com, viro@zeniv.linux.org.uk, ast@plumgrid.com, aishchuk@linux.vnet.ibm.com, aarcange@redhat.com, akpm@linux-foundation.org, luto@kernel.org, acme@kernel.org, bhe@redhat.com, 3chas3@gmail.com, chris@zankel.net, dave@sr71.net, dyoung@redhat.com, drysdale@google.com, davem@davemloft.net, ebiederm@xmission.com, geoff@infradead.org, gregkh@linuxfoundation.org, hpa@zytor.com, mingo@kernel.org, iulia.manda21@gmail.com, plagnioj@jcrosoft.com, jikos@kernel.org, josh@joshtriplett.org, kexec@lists.infradead.org, linux-api@vger.kernel.org, linux-arch@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-xtensa@linux-xtensa.org, mathieu.desnoyers@efficios.com, jcmvbkbc@gmail.com, paulmck@linux.vnet.ibm.com, a.p.zijlstra@chello.nl, tglx@linutronix.de, tomi.valkeinen@ti.com, vgoyal@redhat.com, x86@kernel.org
List-Id: linux-api@vger.kernel.org

On Mon, 14 Sep 2015 17:23:58 PDT (-0700), kirill@shutemov.name wrote:
> On Mon, Sep 14, 2015 at 03:50:38PM -0700, Palmer Dabbelt wrote:
>> This used to be hidden behind CONFIG_MMAP_ALLOW_UNINITIALIZED, so
>> userspace wouldn't actually ever see it be non-zero.  While I could
>> have kept hiding it, the man pages seem to indicate that
>> MAP_UNINITIALIZED should be visible:
>>
>>   mmap(2)
>>   MAP_UNINITIALIZED (since Linux 2.6.33)
>>     Don't clear anonymous pages.  This flag is intended to improve
>>     performance on embedded devices.  This flag is honored only if the
>>     kernel was configured with the CONFIG_MMAP_ALLOW_UNINITIALIZED
>>     option.  Because of the security implications, that option is
>>     normally enabled only on embedded devices (i.e., devices where one
>>     has complete control of the contents of user memory).
>>
>> and since the only time it shows up in my /usr/include is in this
>> header I believe this should have been visible to userspace (as
>> non-zero, which wouldn't do anything when or'd into the flags) all
>> along.
>
> Are you sure about "wouldn't do anything"?

That was bad writing for me.  I'd originally written something like "I
believe this should have been visible to userspace all along", but
then added the ()'s.  I meant to say:

 * I think MAP_UNINITIALIZED should have been non-zero in userspace.
 * MAP_UNINITAILIZED was zero in userspace.
 * A zero MAP_UNINITIALIZED does nothing when OR'd in.

> Suspiciously, 0x4000000 is also (1 << MAP_HUGE_SHIFT). I'm not sure if any
> architecture has order-1 huge pages, but still looks like we have conflict
> here.
>
> I think it's harmful to expose non-zero MAP_UNINITIALIZED to system which
> potentially can handle multiple users. Or non-trivial user space in
> general.

This doesn't have MAP_UNINITIALIZED do anything by default, it just
defines the flag the same way on all systems.  I was under the
impression that this just happened if I set MAP_UNINITIALIZED.
Looking at MAP_HUGE_SHIFT it mmap.c, that's definitely why my mmap()
test case ignored the set MAP_UNINITIALIZED on my PC.

I'm going to make this

 #ifndef MAP_UNINITAILIZED
 #define MAP_UNINITAILIZED 0
 #endif

and then leave Xtensa's port alone.  This is what Arnd suggested
originally, sorry for the extra work!

> Should we leave it at least under '#ifndef CONFIG_MMU'? I don't think it's
> possible to have single ABI for MMU and MMU-less systems anyway. And we
> can avoid conflict with MAP_HUGE_SHIFT this way.

The whole goal here was to eliminate "#ifndef CONFIG_*" from the
user-visible headers.  This all started because I got bit by a very
similar-looking bug (see patch #1), so I'd prefer not to go down that
route.

> P.S. MAP_UNINITIALIZED itself looks very broken to me. I probably need dig
> mailing list on why it was allowed.
> But that's other topic.
