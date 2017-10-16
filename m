From: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Subject: Re: [RFC PATCH for 4.15 14/14] Restartable sequences: Provide
 self-tests
Date: Mon, 16 Oct 2017 18:50:05 +0000 (UTC)
Message-ID: <1998166049.42520.1508179805908.JavaMail.zimbra@efficios.com>
References: <20171012230326.19984-1-mathieu.desnoyers@efficios.com> <20171012230326.19984-15-mathieu.desnoyers@efficios.com> <871sm3n6sy.fsf@concordia.ellerman.id.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <871sm3n6sy.fsf-W0DJWXSxmBNbyGPkN3NxC2scP1bn1w/D@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>
Cc: "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Boqun Feng <boqun.feng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Dave Watson <davejwatson-b10kYP2dOMg@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Russell King <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>, Chris Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Ben Maurer <bmaurer-b10kYP2dOMg@public.gmane.org>, rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andrew Morton <akpm@linux>
List-Id: linux-api@vger.kernel.org

Hi Michael,

With your changes integrated, both rseq and cpu-opv selftests fail to
build if I pass e.g. -j32 to make.

cd tools/testing/selftests/cpu-opv

efficios@compudjdev:~/git/linux-percpu-dev/tools/testing/selftests/cpu-opv$ make clean; make
rm -f -r /home/efficios/git/linux-percpu-dev/tools/testing/selftests/cpu-opv/basic_cpu_opv_test   
gcc -O2 -Wall -g -I./ -I../../../../usr/include/    basic_cpu_opv_test.c cpu-op.c cpu-op.h   -o basic_cpu_opv_test

efficios@compudjdev:~/git/linux-percpu-dev/tools/testing/selftests/cpu-opv$ make clean; make -j32
rm -f -r /home/efficios/git/linux-percpu-dev/tools/testing/selftests/cpu-opv/basic_cpu_opv_test   
gcc -O2 -Wall -g -I./ -I../../../../usr/include/    basic_cpu_opv_test.c cpu-op.c cpu-op.h   -o basic_cpu_opv_test
gcc -O2 -Wall -g -I./ -I../../../../usr/include/    basic_cpu_opv_test.c  -o /home/efficios/git/linux-percpu-dev/tools/testing/selftests/cpu-opv/basic_cpu_opv_test
/tmp/ccDthnqM.o: In function `test_memcpy_op':
/home/efficios/git/linux-percpu-dev/tools/testing/selftests/cpu-opv/basic_cpu_opv_test.c:364: undefined reference to `cpu_op_get_current_cpu'
/home/efficios/git/linux-percpu-dev/tools/testing/selftests/cpu-opv/basic_cpu_opv_test.c:365: undefined reference to `cpu_opv'
/tmp/ccDthnqM.o: In function `test_2compare_ne_op':
/home/efficios/git/linux-percpu-dev/tools/testing/selftests/cpu-opv/basic_cpu_opv_test.c:279: undefined reference to `cpu_op_get_current_cpu'
/home/efficios/git/linux-percpu-dev/tools/testing/selftests/cpu-opv/basic_cpu_opv_test.c:280: undefined reference to `cpu_opv'
/tmp/ccDthnqM.o: In function `test_2compare_eq_op':
/home/efficios/git/linux-percpu-dev/tools/testing/selftests/cpu-opv/basic_cpu_opv_test.c:189: undefined reference to `cpu_op_get_current_cpu'
/home/efficios/git/linux-percpu-dev/tools/testing/selftests/cpu-opv/basic_cpu_opv_test.c:190: undefined reference to `cpu_opv'
/tmp/ccDthnqM.o: In function `test_compare_ne_op':
/home/efficios/git/linux-percpu-dev/tools/testing/selftests/cpu-opv/basic_cpu_opv_test.c:108: undefined reference to `cpu_op_get_current_cpu'
/home/efficios/git/linux-percpu-dev/tools/testing/selftests/cpu-opv/basic_cpu_opv_test.c:109: undefined reference to `cpu_opv'
/tmp/ccDthnqM.o: In function `test_compare_eq_op':
/home/efficios/git/linux-percpu-dev/tools/testing/selftests/cpu-opv/basic_cpu_opv_test.c:34: undefined reference to `cpu_op_get_current_cpu'
/home/efficios/git/linux-percpu-dev/tools/testing/selftests/cpu-opv/basic_cpu_opv_test.c:35: undefined reference to `cpu_opv'
/tmp/ccDthnqM.o: In function `test_add_op':
/home/efficios/git/linux-percpu-dev/tools/testing/selftests/cpu-opv/basic_cpu_opv_test.c:430: undefined reference to `cpu_op_get_current_cpu'
/home/efficios/git/linux-percpu-dev/tools/testing/selftests/cpu-opv/basic_cpu_opv_test.c:431: undefined reference to `cpu_op_add'
/tmp/ccDthnqM.o: In function `test_two_add_op':
/home/efficios/git/linux-percpu-dev/tools/testing/selftests/cpu-opv/basic_cpu_opv_test.c:479: undefined reference to `cpu_op_get_current_cpu'
/home/efficios/git/linux-percpu-dev/tools/testing/selftests/cpu-opv/basic_cpu_opv_test.c:480: undefined reference to `cpu_opv'
/tmp/ccDthnqM.o: In function `test_or_op':
/home/efficios/git/linux-percpu-dev/tools/testing/selftests/cpu-opv/basic_cpu_opv_test.c:522: undefined reference to `cpu_op_get_current_cpu'
/home/efficios/git/linux-percpu-dev/tools/testing/selftests/cpu-opv/basic_cpu_opv_test.c:523: undefined reference to `cpu_opv'
/tmp/ccDthnqM.o: In function `test_and_op':
/home/efficios/git/linux-percpu-dev/tools/testing/selftests/cpu-opv/basic_cpu_opv_test.c:565: undefined reference to `cpu_op_get_current_cpu'
/home/efficios/git/linux-percpu-dev/tools/testing/selftests/cpu-opv/basic_cpu_opv_test.c:566: undefined reference to `cpu_opv'
/tmp/ccDthnqM.o: In function `test_xor_op':
/home/efficios/git/linux-percpu-dev/tools/testing/selftests/cpu-opv/basic_cpu_opv_test.c:608: undefined reference to `cpu_op_get_current_cpu'
/home/efficios/git/linux-percpu-dev/tools/testing/selftests/cpu-opv/basic_cpu_opv_test.c:609: undefined reference to `cpu_opv'
/tmp/ccDthnqM.o: In function `test_lshift_op':
/home/efficios/git/linux-percpu-dev/tools/testing/selftests/cpu-opv/basic_cpu_opv_test.c:651: undefined reference to `cpu_op_get_current_cpu'
/home/efficios/git/linux-percpu-dev/tools/testing/selftests/cpu-opv/basic_cpu_opv_test.c:652: undefined reference to `cpu_opv'
/tmp/ccDthnqM.o: In function `test_rshift_op':
/home/efficios/git/linux-percpu-dev/tools/testing/selftests/cpu-opv/basic_cpu_opv_test.c:695: undefined reference to `cpu_op_get_current_cpu'
/home/efficios/git/linux-percpu-dev/tools/testing/selftests/cpu-opv/basic_cpu_opv_test.c:696: undefined reference to `cpu_opv'
/tmp/ccDthnqM.o: In function `test_cmpxchg_op':
/home/efficios/git/linux-percpu-dev/tools/testing/selftests/cpu-opv/basic_cpu_opv_test.c:731: undefined reference to `cpu_op_get_current_cpu'
/home/efficios/git/linux-percpu-dev/tools/testing/selftests/cpu-opv/basic_cpu_opv_test.c:732: undefined reference to `cpu_op_cmpxchg'
/home/efficios/git/linux-percpu-dev/tools/testing/selftests/cpu-opv/basic_cpu_opv_test.c:731: undefined reference to `cpu_op_get_current_cpu'
/home/efficios/git/linux-percpu-dev/tools/testing/selftests/cpu-opv/basic_cpu_opv_test.c:732: undefined reference to `cpu_op_cmpxchg'
collect2: error: ld returned 1 exit status
make: *** [/home/efficios/git/linux-percpu-dev/tools/testing/selftests/cpu-opv/basic_cpu_opv_test] Error 1
make: *** Waiting for unfinished jobs....

Any idea what is going on here ?

Thanks,

Mathieu

----- On Oct 15, 2017, at 10:51 PM, Michael Ellerman mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org wrote:

> Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org> writes:
> 
>> Implements two basic tests of RSEQ functionality, and one more
>> exhaustive parameterizable test.
>>
>> The first, "basic_test" only asserts that RSEQ works moderately
>> correctly.
>> E.g. that:
>> - The CPUID pointer works
>> - Code infinitely looping within a critical section will eventually be
>>   interrupted.
>> - Critical sections are interrupted by signals.
>>
>> "basic_percpu_ops_test" is a slightly more "realistic" variant,
>> implementing a few simple per-cpu operations and testing their
>> correctness.
>>
>> "param_test" is a parametrizable restartable sequences test. See
>> the "--help" output for usage.
> 
> Thanks for providing selftests :)
> 
> The Makefiles could use a little clean up:
>  - cpu-opv doesn't need libpthread
>  - you don't need to define your own rule just for building
>  - use TEST_GEN_PROGS to hook into the right parts of lib.mk
>  - .. which means you can use the clean rule in lib.mk
> 
> 
> I notice you didn't add rseq or cpu-opv to the list of TARGETS in
> tools/testing/selftests/Makefile, was that deliberate?
> 
> Feel free to squash this patch in if you're happy to.
> 
> This still works with:
>  $ make -C tools/testing/selftests TARGETS=rseq
> 
> and:
>  $ cd tools/testing/selftests/rseq; make
> 
> cheers
> 
> diff --git a/tools/testing/selftests/cpu-opv/Makefile
> b/tools/testing/selftests/cpu-opv/Makefile
> index 81d0596824ee..d41670ad5c43 100644
> --- a/tools/testing/selftests/cpu-opv/Makefile
> +++ b/tools/testing/selftests/cpu-opv/Makefile
> @@ -1,13 +1,9 @@
> CFLAGS += -O2 -Wall -g -I./ -I../../../../usr/include/
> -LDFLAGS += -lpthread
> 
> -TESTS = basic_cpu_opv_test
> +TEST_GEN_PROGS = basic_cpu_opv_test
> 
> -all: $(TESTS)
> -%: %.c cpu-op.c cpu-op.h
> -	$(CC) $(CFLAGS) -o $@ $^ $(LDFLAGS)
> +all: $(TEST_GEN_PROGS)
> 
> -include ../lib.mk
> +$(TEST_GEN_PROGS): cpu-op.c cpu-op.h
> 
> -clean:
> -	$(RM) $(TESTS)
> +include ../lib.mk
> diff --git a/tools/testing/selftests/rseq/Makefile
> b/tools/testing/selftests/rseq/Makefile
> index 7f0153556b80..9f8257b4ce14 100644
> --- a/tools/testing/selftests/rseq/Makefile
> +++ b/tools/testing/selftests/rseq/Makefile
> @@ -1,13 +1,10 @@
> CFLAGS += -O2 -Wall -g -I./ -I../cpu-opv/ -I../../../../usr/include/
> -LDFLAGS += -lpthread
> +LDLIBS += -lpthread
> 
> -TESTS = basic_test basic_percpu_ops_test param_test
> +TEST_GEN_PROGS = basic_test basic_percpu_ops_test param_test
> 
> -all: $(TESTS)
> -%: %.c rseq.h rseq-*.h rseq.c ../cpu-opv/cpu-op.c ../cpu-opv/cpu-op.h
> -	$(CC) $(CFLAGS) -o $@ $^ $(LDFLAGS)
> +all: $(TEST_GEN_PROGS)
> 
> -include ../lib.mk
> +$(TEST_GEN_PROGS): rseq.h rseq-*.h rseq.c ../cpu-opv/cpu-op.c
> ../cpu-opv/cpu-op.h
> 
> -clean:
> -	$(RM) $(TESTS)
> +include ../lib.mk

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
