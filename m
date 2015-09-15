From: Palmer Dabbelt <palmer-96lFi9zoCfxBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH 04/13] Always expose MAP_UNINITIALIZED to userspace
Date: Mon, 14 Sep 2015 17:52:24 -0700 (PDT)
Message-ID: <55f76bc8.2108450a.97c6e.129a__22283.3031708889$1442289911$gmane$org@mx.google.com>
References: <20150915002358.GA12618@node.dhcp.inet.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kexec-bounces+glkk-kexec=m.gmane.org-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
In-Reply-To: <20150915002358.GA12618-nhfs4B5ZimeFUdmeq17FyvUpdFzICT1y@public.gmane.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/kexec>,
 <mailto:kexec-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/kexec/>
List-Post: <mailto:kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
List-Help: <mailto:kexec-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/kexec>,
 <mailto:kexec-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=subscribe>
Sender: "kexec" <kexec-bounces-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
Errors-To: kexec-bounces+glkk-kexec=m.gmane.org-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
To: kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org
Cc: dave-gkUM19QKKo4@public.gmane.org, linux-xtensa-PjhNF2WwrV/0Sa2dR60CXw@public.gmane.org, dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, jcmvbkbc-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, ast-uqk4Ao+rVK5Wk0Htik3J/w@public.gmane.org, aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, bhe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, tomi.valkeinen-l0cyMroinI0@public.gmane.org, 3chas3-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, plagnioj-sclMFOaUSTBWk0Htik3J/w@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, aishchuk-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, a.p.zijlstra-/NLkJaSkS4VmR6Xm/wNWPw@public.gmane.org, jikos-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org, acme-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, drysdale-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, chris-YvXeqwSYzG2sTnJN9+BGXg@public.gmane.org, iulia.manda21-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, geoff-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Mon, 14 Sep 2015 17:23:58 PDT (-0700), kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org wrote:
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
