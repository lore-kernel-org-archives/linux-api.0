From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Subject: Re: Revised futex(2) man page for review
Date: Mon, 27 Jul 2015 13:10:49 +0200
Message-ID: <55B611B9.9030708@gmail.com>
References: <55166C01.7000803@gmail.com> <20150328114725.GJ27490@worktop.programming.kicks-ass.net> <20150427203705.GE29351@xo-6d-61-c0.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150427203705.GE29351@xo-6d-61-c0.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
To: Pavel Machek <pavel@ucw.cz>, Peter Zijlstra <peterz@infradead.org>
Cc: mtk.manpages@gmail.com, Thomas Gleixner <tglx@linutronix.de>, Darren Hart <dvhart@linux.intel.com>, Carlos O'Donell <carlos@redhat.com>, Ingo Molnar <mingo@elte.hu>, Jakub Jelinek <jakub@redhat.com>, "linux-man@vger.kernel.org" <linux-man@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>, Davidlohr Bueso <dave@stgolabs.net>, Arnd Bergmann <arnd@arndb.de>, Steven Rostedt <rostedt@goodmis.org>, Linux API <linux-api@vger.kernel.org>, Torvald Riegel <triegel@redhat.com>, Roland McGrath <roland@hack.frob.com>, Darren Hart <dvhart@infradead.org>, Anton Blanchard <anton@samba.org>, Eric Dumazet <edumazet@google.com>, bill o gallmeister <bgallmeister@gmail.com>, Jan Kiszka <jan.kiszka@siemens.com>, Daniel Wagner <wagi@monom.org>, Rich Felker <dalias@libc.org>, Andy Lutomirski <luto@amacapital.net>, bert hubert <bert.hubert@netherlabs.nl>, Rusty Russell <rusty@rustcorp>
List-Id: linux-api@vger.kernel.org

Hello Pavel,

On 04/27/2015 10:37 PM, Pavel Machek wrote:
> Hi!
>=20
>>               The FUTEX_WAIT_OP operation is equivalent to execute t=
he follow???
>>               ing  code  atomically  and totally ordered with respec=
t to other
>>               futex operations on any of the two supplied futex word=
s:
>=20
> "to executing"?

Yep. Fixed.

>>               The  operation  and  comparison  that  are  to  be per=
formed are
>>               encoded in the bits of  the  argument  val3.   Pictori=
ally,  the
>>               encoding is:
>>
>>                       +---+---+-----------+-----------+
>>                       |op |cmp|   oparg   |  cmparg   |
>>                       +---+---+-----------+-----------+
>>                         4   4       12          12    <=3D=3D # of b=
its
>>
>=20
> :-)
>=20
>> RETURN VALUE
>>        In the event of an error, all operations return -1  and  set =
 errno  to
>>        indicate  the  cause of the error.  The return value on succe=
ss depends
>>        on the operation, as described in the following list:
>=20
> Did you say (at the begining) that there is no glibc wrapper?

Yes, this could be clearer. I changed it to

RETURN VALUE
       In the event of an error (and assuming that futex()  was  invoke=
d
       via  syscall(2)), all operations return -1 and set errno to indi=
=E2=80=90
       cate the cause of the error.

>>        EINVAL The operation in futex_op is one of those that employs=
  a  time???
>>               out,  but  the supplied timeout argument was invalid (=
tv_sec was
>>               less than zero, or tv_nsec was not less than 1000,000,=
000).
>=20
> 1,000...?

=46ixed.

Thanks for the comments!

Cheers,

Michael


--=20
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
