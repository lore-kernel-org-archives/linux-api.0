From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [RFC PATCH glibc 1/4] glibc: Perform rseq(2) registration at
 nptl init and thread creation (v4)
Date: Mon, 14 Jan 2019 15:27:28 -0500 (EST)
Message-ID: <1031872348.636.1547497648914.JavaMail.zimbra@efficios.com>
References: <20181204192141.4684-1-mathieu.desnoyers@efficios.com> <87h8fkz6qx.fsf@oldenburg2.str.redhat.com> <1681283664.1380.1547152315426.JavaMail.zimbra@efficios.com> <87fttv9iic.fsf@oldenburg2.str.redhat.com> <394676913.486.1547493757710.JavaMail.zimbra@efficios.com> <87y37n8202.fsf@oldenburg2.str.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <87y37n8202.fsf@oldenburg2.str.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Florian Weimer <fweimer@redhat.com>
Cc: carlos <carlos@redhat.com>, Joseph Myers <joseph@codesourcery.com>, Szabolcs Nagy <szabolcs.nagy@arm.com>, libc-alpha <libc-alpha@sourceware.org>, Thomas Gleixner <tglx@linutronix.de>, Ben Maurer <bmaurer@fb.com>, Peter Zijlstra <peterz@infradead.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Will Deacon <will.deacon@arm.com>, Dave Watson <davejwatson@fb.com>, Paul Turner <pjt@google.com>, Rich Felker <dalias@libc.org>, linux-kernel <linux-kernel@vger.kernel.org>, linux-api <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

----- On Jan 14, 2019, at 2:37 PM, Florian Weimer fweimer@redhat.com wrote:

> * Mathieu Desnoyers:
>=20
>> ----- On Jan 14, 2019, at 10:55 AM, Florian Weimer fweimer@redhat.com wr=
ote:
>>
>>> * Mathieu Desnoyers:
>>>=20
>>>> Therefore, both symbols will end up in
>>>> sysdeps/unix/sysv/linux/Versions.
>>>=20
>>> I'm not sure what you mean by that.  The physical location in the
>>> directory tree has little effect on which shared object the symbol is
>>> placed in; that will need other changes.
>>
>> I'm currently moving the symbol definitions to csu/rseq-sym.c. On Linux,
>> its content is overridden by a new sysdeps/unix/sysv/linux/rseq-sym.c
>> which contains both __rseq_abi and __rseq_refcount symbols. On other
>> platforms, it is a stub file.
>=20
> You don't need a stub file if you use the =E2=80=9Cifeq ($(subdir),csu)=
=E2=80=9D
> construct.

OK

>=20
> The other question is whether this belongs into the csu subdirectory.
> Since TLS is not available in ld.so, the initialization would have to
> happen rather late, after relocation, but before ELF constructors are
> run.
>=20
> (A side effect is that the rseq area would not be usable from IFUNC
> resolvers.)

Do you have a specific directory location in mind where we should put
the built object ? e.g. "ifeq ($(subdir),posix)" or
"ifeq ($(subdir),misc)" ?

Moreover, from where should we call the rseq initialization ? I'm having
trouble with invalid system calls parameters if I place it in
LIBC_START_MAIN() just before or after the call to __pthread_initialize_min=
imal.
I get what appears to be invalid parameters to sys_rseq, possibly due to
stack corruption (?). I'm investigating at the moment. But if you prefer
we call the rseq init from elsewhere, please let me know.

Thanks,

Mathieu

--=20
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
