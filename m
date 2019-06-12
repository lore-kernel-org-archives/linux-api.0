From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [PATCH 1/5] glibc: Perform rseq(2) registration at C startup
 and thread creation (v10)
Date: Wed, 12 Jun 2019 10:36:03 -0400 (EDT)
Message-ID: <512441263.43096.1560350163180.JavaMail.zimbra@efficios.com>
References: <20190503184219.19266-1-mathieu.desnoyers@efficios.com> <87muj2k4ov.fsf@oldenburg2.str.redhat.com> <1528929896.22217.1559326257155.JavaMail.zimbra@efficios.com> <87o93d4lqb.fsf@oldenburg2.str.redhat.com> <117220011.27079.1559663870037.JavaMail.zimbra@efficios.com> <87wohzorj0.fsf@oldenburg2.str.redhat.com> <1329439108.43041.1560348962006.JavaMail.zimbra@efficios.com> <87blz27uio.fsf@oldenburg2.str.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <87blz27uio.fsf@oldenburg2.str.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Florian Weimer <fweimer@redhat.com>
Cc: carlos <carlos@redhat.com>, Joseph Myers <joseph@codesourcery.com>, Szabolcs Nagy <szabolcs.nagy@arm.com>, libc-alpha <libc-alpha@sourceware.org>, Thomas Gleixner <tglx@linutronix.de>, Ben Maurer <bmaurer@fb.com>, Peter Zijlstra <peterz@infradead.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Will Deacon <will.deacon@arm.com>, Dave Watson <davejwatson@fb.com>, Paul Turner <pjt@google.com>, Rich Felker <dalias@libc.org>, linux-kernel <linux-kernel@vger.kernel.org>, linux-api <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

----- On Jun 12, 2019, at 4:22 PM, Florian Weimer fweimer@redhat.com wrote:

> * Mathieu Desnoyers:
> 
>>> It's the registration from libc.so which needs some care.  In
>>> particular, we must not override an existing registration.
>>
>> OK, so it could check if __rseq_abi.cpu_id is -1, and only
>> perform registration if it is the case. Or do you have another
>> approach in mind ?
> 
> No, __rseq_abi will not be shared with the outer libc, so the inner libc
> will always see -1 there, even if the outer libc has performed
> registration.
> 
> libio/vtables.c has some example what you can do:
> 
>  /* In case this libc copy is in a non-default namespace, we always
>     need to accept foreign vtables because there is always a
>     possibility that FILE * objects are passed across the linking
>     boundary.  */
>  {
>    Dl_info di;
>    struct link_map *l;
>    if (!rtld_active ()
>        || (_dl_addr (_IO_vtable_check, &di, &l, NULL) != 0
>            && l->l_ns != LM_ID_BASE))
>      return;
>  }
> 
> _IO_vtable_check would have to be replaced with your own function; the
> actual function doesn't really matter.
> 
> The rtld_active check covers the static dlopen case, where
> rtld_active () is false in the inner libc.

Then out of curiosity, would it also work if I check for

if (!__libc_multiple_libcs)

in LIBC_START_MAIN ?

Thanks,

Mathieu

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
