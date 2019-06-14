From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [PATCH 1/5] glibc: Perform rseq(2) registration at C startup
 and thread creation (v10)
Date: Fri, 14 Jun 2019 09:39:10 -0400 (EDT)
Message-ID: <1503067753.3387.1560519550939.JavaMail.zimbra@efficios.com>
References: <20190503184219.19266-1-mathieu.desnoyers@efficios.com> <802638054.3032.1560506584705.JavaMail.zimbra@efficios.com> <87ftocwkei.fsf@oldenburg2.str.redhat.com> <1635690189.3049.1560507249693.JavaMail.zimbra@efficios.com> <87tvcsv1pk.fsf@oldenburg2.str.redhat.com> <1190407525.3131.1560516910936.JavaMail.zimbra@efficios.com> <1085273942.3137.1560517301721.JavaMail.zimbra@efficios.com> <69a53ec2ce184af29c4cae58e0b2fb57@AcuMS.aculab.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <69a53ec2ce184af29c4cae58e0b2fb57@AcuMS.aculab.com>
Sender: linux-kernel-owner@vger.kernel.org
To: David Laight <David.Laight@ACULAB.COM>
Cc: Florian Weimer <fweimer@redhat.com>, carlos <carlos@redhat.com>, Joseph Myers <joseph@codesourcery.com>, Szabolcs Nagy <szabolcs.nagy@arm.com>, libc-alpha <libc-alpha@sourceware.org>, Thomas Gleixner <tglx@linutronix.de>, Ben Maurer <bmaurer@fb.com>, Peter Zijlstra <peterz@infradead.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Will Deacon <will.deacon@arm.com>, Dave Watson <davejwatson@fb.com>, Paul Turner <pjt@google.com>, Rich Felker <dalias@libc.org>, linux-kernel <linux-kernel@vger.kernel.org>, linux-api <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

----- On Jun 14, 2019, at 3:29 PM, David Laight David.Laight@ACULAB.COM wrote:

> From: Mathieu Desnoyers
>> Sent: 14 June 2019 14:02
> ...
>> But my original issue remains: if I define a variable called __rseq_handled
>> within either the main executable or the preloaded library, it overshadows
>> the libc one:
> 
> 1) That is the was elf symbol resolution is required to work.
>   Otherwise variables like 'errno' (non-thread safe form) wouldn't work.
> 
> 2) Don't do it then :-)
>   Names starting with __ will be reserved (probably 'for the implementation').
> 
> The real 'fun' starts because, under some circumstances, looking up a symbol as:
>	foo = dlsym(lib_handle, "foo");
> Can find the data item instead of the function!
> Usually it works (even when foo is global data) because 'lib_handle' refers
> to a different symbol table.
> But it can go horribly wrong.

I was setting __rseq_handled too soon, before re-relocation of the dynamic linker.
I moved the initialization after re-relocation and it works fine now.

The purpose of __rseq_handled is to allow early adopter libraries and applications
to define their own global instance of the symbol, and check whether the libc
they are linked against handle rseq registration or not.

libc specifies the layout of that variable (an integer). The dynamic linker
chooses one of those instances so it's used in the global symbol table of the
program. The important thing is that all libraries agree on that global symbol.
Of course this is not compatible with libraries compiled with forced "hidden"
symbols only.

Thanks,

Mathieu

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
