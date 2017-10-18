From: Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>
Subject: Re: [RFC PATCH for 4.15 14/14] Restartable sequences: Provide self-tests
Date: Wed, 18 Oct 2017 16:45:28 +1100
Message-ID: <87fuahhuvb.fsf@concordia.ellerman.id.au>
References: <20171012230326.19984-1-mathieu.desnoyers@efficios.com> <20171012230326.19984-15-mathieu.desnoyers@efficios.com> <871sm3n6sy.fsf@concordia.ellerman.id.au> <1998166049.42520.1508179805908.JavaMail.zimbra@efficios.com> <87d15mjc1g.fsf@concordia.ellerman.id.au> <1618170495.42951.1508248216596.JavaMail.zimbra@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1618170495.42951.1508248216596.JavaMail.zimbra-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Cc: "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Boqun Feng <boqun.feng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Dave Watson <davejwatson-b10kYP2dOMg@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Russell King <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>, Chris Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Ben Maurer <bmaurer-b10kYP2dOMg@public.gmane.org>, rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andrew Morton <akpm@linux>
List-Id: linux-api@vger.kernel.org

Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org> writes:

> ----- On Oct 17, 2017, at 6:36 AM, Michael Ellerman mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org wrote:
>
>> Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org> writes:
>> 
>>> Hi Michael,
>>>
>>> With your changes integrated, both rseq and cpu-opv selftests fail to
>>> build if I pass e.g. -j32 to make.
>>>
>>> cd tools/testing/selftests/cpu-opv
>>>
>>> efficios@compudjdev:~/git/linux-percpu-dev/tools/testing/selftests/cpu-opv$ make
>>> clean; make
>>> rm -f -r
>>> /home/efficios/git/linux-percpu-dev/tools/testing/selftests/cpu-opv/basic_cpu_opv_test
>>> gcc -O2 -Wall -g -I./ -I../../../../usr/include/    basic_cpu_opv_test.c
>>> cpu-op.c cpu-op.h   -o basic_cpu_opv_test
>>>
>>> efficios@compudjdev:~/git/linux-percpu-dev/tools/testing/selftests/cpu-opv$ make
>>> clean; make -j32
>>> rm -f -r
>>> /home/efficios/git/linux-percpu-dev/tools/testing/selftests/cpu-opv/basic_cpu_opv_test
>>> gcc -O2 -Wall -g -I./ -I../../../../usr/include/    basic_cpu_opv_test.c
>>> cpu-op.c cpu-op.h   -o basic_cpu_opv_test
>>> gcc -O2 -Wall -g -I./ -I../../../../usr/include/    basic_cpu_opv_test.c  -o
>>> /home/efficios/git/linux-percpu-dev/tools/testing/selftests/cpu-opv/basic_cpu_opv_test
>>> /tmp/ccDthnqM.o: In function `test_memcpy_op':
>>> /home/efficios/git/linux-percpu-dev/tools/testing/selftests/cpu-opv/basic_cpu_opv_test.c:364:
>>> undefined reference to `cpu_op_get_current_cpu'
>>> /home/efficios/git/linux-percpu-dev/tools/testing/selftests/cpu-opv/basic_cpu_opv_test.c:365:
>>> undefined reference to `cpu_opv'
>> ...
>>> make: ***
>>> [/home/efficios/git/linux-percpu-dev/tools/testing/selftests/cpu-opv/basic_cpu_opv_test]
>>> Error 1
>>> make: *** Waiting for unfinished jobs....
>>>
>>> Any idea what is going on here ?
>> 
>> Ugh sorry, yes.
>> 
>> New patch below should fix it. Tested with -j:
>
> Perfect, folding it into my series.

Thanks.

> I see that the "all" target was redundant here.

Yeah.

Unfortunately lib.mk has grown a bit more complicated than I would like,
including defining the all target.

It does make for nice short Makefiles for individual test directories,
but it's not all that easy to use if you're not familiar with it [or
even if you are, as I demostrated here :)]

cheers
