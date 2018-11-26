From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [RFC PATCH v4 1/5] glibc: Perform rseq(2) registration at nptl
 init and thread creation
Date: Mon, 26 Nov 2018 11:30:51 -0500 (EST)
Message-ID: <1284855405.12857.1543249851299.JavaMail.zimbra@efficios.com>
References: <20181121183936.8176-1-mathieu.desnoyers@efficios.com> <1150466925.11664.1542992720871.JavaMail.zimbra@efficios.com> <20181123173019.GK23599@brightrain.aerifal.cx> <865273158.11687.1542995541389.JavaMail.zimbra@efficios.com> <20181123183558.GM23599@brightrain.aerifal.cx> <1758017676.12041.1543007347347.JavaMail.zimbra@efficios.com> <87bm6cqm31.fsf@oldenburg.str.redhat.com> <688718071.12798.1543247469553.JavaMail.zimbra@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <688718071.12798.1543247469553.JavaMail.zimbra@efficios.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Florian Weimer <fweimer@redhat.com>
Cc: Rich Felker <dalias@libc.org>, carlos <carlos@redhat.com>, Joseph Myers <joseph@codesourcery.com>, Szabolcs Nagy <szabolcs.nagy@arm.com>, libc-alpha <libc-alpha@sourceware.org>, Thomas Gleixner <tglx@linutronix.de>, Ben Maurer <bmaurer@fb.com>, Peter Zijlstra <peterz@infradead.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Will Deacon <will.deacon@arm.com>, Dave Watson <davejwatson@fb.com>, Paul Turner <pjt@google.com>, linux-kernel <linux-kernel@vger.kernel.org>, linux-api <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

----- On Nov 26, 2018, at 10:51 AM, Mathieu Desnoyers mathieu.desnoyers@efficios.com wrote:

> ----- On Nov 26, 2018, at 3:28 AM, Florian Weimer fweimer@redhat.com wrote:
> 
>> * Mathieu Desnoyers:
>> 
>>> Using a "weak" symbol in early adopter libraries is important, so they
>>> can be loaded together into the same process without causing loader
>>> errors due to many definitions of the same strong symbol.
>> 
>> This is not how ELF dynamic linking works.  If the symbol name is the
>> same, one definition interposes the others.
>> 
>> You need to ensure that the symbol has the same size everywhere, though.
>> There are some tricky interactions with symbol versions, too.  (The
>> interposing libraries must not use symbol versioning.)
> 
> I was under the impression that loading the same strong symbol into an
> application multiple times would cause some kind of warning if non-weak. I did
> some testing to figure out which case I remembered would cause this.
> 
> When compiling with "-fno-common", dynamic and static linking work fine, but
> trying to add multiple instances of a given symbol into a single object fails
> with:
> 
> /tmp/ccSakXZV.o:(.bss+0x0): multiple definition of `a'
> /tmp/ccQBJBOo.o:(.bss+0x0): first defined here
> 
> Even if the symbol has the same size.
> 
> So considering that we don't care about compiling into a single object here,
> and only care about static and dynamic linking of libraries, indeed the "weak"
> symbol is not useful.
> 
> So let's make __rseq_abi and __rseq_refcount strong symbols then ?

Actually, looking into ld(1) --warn-common, it looks like "weak" would be cleaner
after all, especially for __rseq_abi which we needs to be initialized to a specific
value, which is therefore not a common symbol.

"      --warn-common
           Warn when a common symbol is combined with another common symbol or with a symbol definition.  Unix
           linkers allow this somewhat sloppy practice, but linkers on some other operating systems do not.
           This option allows you to find potential problems from combining global symbols.  Unfortunately,
           some C libraries use this practice, so you may get some warnings about symbols in the libraries as
           well as in your programs."

Thoughts ?

Thanks,

Mathieu

> 
> Thanks,
> 
> Mathieu
> 
> --
> Mathieu Desnoyers
> EfficiOS Inc.
> http://www.efficios.com

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
