From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Subject: Re: Revised futex(2) man page for review
Date: Mon, 27 Jul 2015 13:10:55 +0200
Message-ID: <55B611BF.8040908@gmail.com>
References: <55166C01.7000803@gmail.com> <20150328114725.GJ27490@worktop.programming.kicks-ass.net> <20150328120337.GB32047@worktop.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150328120337.GB32047@worktop.ger.corp.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Peter Zijlstra <peterz@infradead.org>
Cc: mtk.manpages@gmail.com, Thomas Gleixner <tglx@linutronix.de>, Darren Hart <dvhart@linux.intel.com>, Carlos O'Donell <carlos@redhat.com>, Ingo Molnar <mingo@elte.hu>, Jakub Jelinek <jakub@redhat.com>, "linux-man@vger.kernel.org" <linux-man@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>, Davidlohr Bueso <dave@stgolabs.net>, Arnd Bergmann <arnd@arndb.de>, Steven Rostedt <rostedt@goodmis.org>, Linux API <linux-api@vger.kernel.org>, Torvald Riegel <triegel@redhat.com>, Roland McGrath <roland@hack.frob.com>, Darren Hart <dvhart@infradead.org>, Anton Blanchard <anton@samba.org>, Eric Dumazet <edumazet@google.com>, bill o gallmeister <bgallmeister@gmail.com>, Jan Kiszka <jan.kiszka@siemens.com>, Daniel Wagner <wagi@monom.org>, Rich Felker <dalias@libc.org>, Andy Lutomirski <luto@amacapital.net>, bert hubert <bert.hubert@netherlabs.nl>, Rusty Russell <rusty@rustcorp>
List-Id: linux-api@vger.kernel.org

Hi Peter,

On 03/28/2015 01:03 PM, Peter Zijlstra wrote:
> On Sat, Mar 28, 2015 at 12:47:25PM +0100, Peter Zijlstra wrote:
>>        FUTEX_WAIT (since Linux 2.6.0)
>>               This operation tests that the value at the futex word =
pointed to
>>               by the address uaddr still contains the expected value=
 val,  and
>>               if  so,  then sleeps awaiting FUTEX_WAKE on the futex =
word.  The
>>               load of the value of the futex word is an atomic  memo=
ry  access
>>               (i.e.,  using  atomic  machine  instructions  of  the =
respective
>>               architecture).  This load,  the  comparison  with  the=
  expected
>>               value,  and  starting  to  sleep  are  performed  atom=
ically and
>>               totally ordered with respect to other futex  operation=
s  on  the
>>               same  futex  word.  If the thread starts to sleep, it =
is consid=E2=80=90
>>               ered a waiter on this futex word.  If the futex value =
 does  not
>>               match  val,  then  the  call  fails  immediately  with=
 the error
>>               EAGAIN.
>>
>>               The purpose of the comparison with the expected value =
is to pre=E2=80=90
>>               vent  lost  wake-ups: If another thread changed the va=
lue of the
>>               futex word after the calling thread decided to  block =
 based  on
>>               the  prior  value, and if the other thread executed a =
=46UTEX_WAKE
>>               operation (or similar wake-up) after the value change =
and before
>>               this  FUTEX_WAIT  operation,  then  the  latter will o=
bserve the
>>               value change and will not start to sleep.
>>
>>               If the timeout argument is non-NULL, its contents spec=
ify a rel=E2=80=90
>>               ative   timeout   for   the  wait,  measured  accordin=
g  to  the
>>               CLOCK_MONOTONIC clock.  (This interval will be rounded=
 up to the
>>               system clock granularity, and kernel scheduling delays=
 mean that
>>               the blocking interval may overrun by a small amount.) =
 If  time=E2=80=90
>>               out is NULL, the call blocks indefinitely.
>=20
> Would it not be better to only state that the wait will not return
> before the timeout -- unless woken -- and not bother with clock
> granularity and scheduling delays?

Many of the pages that talk about system calls that have timeouts
carry similar language, since people often have confusions about what t=
ime
timeout (e.g., that it's an upper limit, not a minimum; or that it's pr=
ecise
to some very small granularity). Why do you think the language here is =
a
problem?

Cheers,

Michael



--=20
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
