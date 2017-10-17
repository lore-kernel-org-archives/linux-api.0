From: Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>
Subject: Re: [RFC PATCH for 4.15 14/14] Restartable sequences: Provide self-tests
Date: Tue, 17 Oct 2017 21:36:59 +1100
Message-ID: <87d15mjc1g.fsf@concordia.ellerman.id.au>
References: <20171012230326.19984-1-mathieu.desnoyers@efficios.com> <20171012230326.19984-15-mathieu.desnoyers@efficios.com> <871sm3n6sy.fsf@concordia.ellerman.id.au> <1998166049.42520.1508179805908.JavaMail.zimbra@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1998166049.42520.1508179805908.JavaMail.zimbra-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Cc: "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Boqun Feng <boqun.feng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Dave Watson <davejwatson-b10kYP2dOMg@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Russell King <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>, Chris Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Ben Maurer <bmaurer-b10kYP2dOMg@public.gmane.org>, rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andrew Morton <akpm@linux>
List-Id: linux-api@vger.kernel.org

Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org> writes:

> Hi Michael,
>
> With your changes integrated, both rseq and cpu-opv selftests fail to
> build if I pass e.g. -j32 to make.
>
> cd tools/testing/selftests/cpu-opv
>
> efficios@compudjdev:~/git/linux-percpu-dev/tools/testing/selftests/cpu-opv$ make clean; make
> rm -f -r /home/efficios/git/linux-percpu-dev/tools/testing/selftests/cpu-opv/basic_cpu_opv_test   
> gcc -O2 -Wall -g -I./ -I../../../../usr/include/    basic_cpu_opv_test.c cpu-op.c cpu-op.h   -o basic_cpu_opv_test
>
> efficios@compudjdev:~/git/linux-percpu-dev/tools/testing/selftests/cpu-opv$ make clean; make -j32
> rm -f -r /home/efficios/git/linux-percpu-dev/tools/testing/selftests/cpu-opv/basic_cpu_opv_test   
> gcc -O2 -Wall -g -I./ -I../../../../usr/include/    basic_cpu_opv_test.c cpu-op.c cpu-op.h   -o basic_cpu_opv_test
> gcc -O2 -Wall -g -I./ -I../../../../usr/include/    basic_cpu_opv_test.c  -o /home/efficios/git/linux-percpu-dev/tools/testing/selftests/cpu-opv/basic_cpu_opv_test
> /tmp/ccDthnqM.o: In function `test_memcpy_op':
> /home/efficios/git/linux-percpu-dev/tools/testing/selftests/cpu-opv/basic_cpu_opv_test.c:364: undefined reference to `cpu_op_get_current_cpu'
> /home/efficios/git/linux-percpu-dev/tools/testing/selftests/cpu-opv/basic_cpu_opv_test.c:365: undefined reference to `cpu_opv'
...
> make: *** [/home/efficios/git/linux-percpu-dev/tools/testing/selftests/cpu-opv/basic_cpu_opv_test] Error 1
> make: *** Waiting for unfinished jobs....
>
> Any idea what is going on here ?

Ugh sorry, yes.

New patch below should fix it. Tested with -j:

  ~/linux/tools/testing/selftests$ make TARGETS="rseq cpu-opv" -j
  make[1]: Entering directory '/home/michael/linux/tools/testing/selftests/rseq'
  gcc -O2 -Wall -g -I./ -I../cpu-opv/ -I../../../../usr/include/    basic_test.c rseq.h rseq-ppc.h rseq-x86.h rseq-arm.h rseq.c ../cpu-opv/cpu-op.c ../cpu-opv/cpu-op.h -lpthread -o /home/michael/linux/tools/testing/selftests/rseq/basic_test
  gcc -O2 -Wall -g -I./ -I../cpu-opv/ -I../../../../usr/include/    basic_percpu_ops_test.c rseq.h rseq-ppc.h rseq-x86.h rseq-arm.h rseq.c ../cpu-opv/cpu-op.c ../cpu-opv/cpu-op.h -lpthread -o /home/michael/linux/tools/testing/selftests/rseq/basic_percpu_ops_test
  gcc -O2 -Wall -g -I./ -I../cpu-opv/ -I../../../../usr/include/    param_test.c rseq.h rseq-ppc.h rseq-x86.h rseq-arm.h rseq.c ../cpu-opv/cpu-op.c ../cpu-opv/cpu-op.h -lpthread -o /home/michael/linux/tools/testing/selftests/rseq/param_test
  make[1]: Leaving directory '/home/michael/linux/tools/testing/selftests/rseq'
  make[1]: Entering directory '/home/michael/linux/tools/testing/selftests/cpu-opv'
  gcc -O2 -Wall -g -I./ -I../../../../usr/include/    basic_cpu_opv_test.c cpu-op.c cpu-op.h  -o /home/michael/linux/tools/testing/selftests/cpu-opv/basic_cpu_opv_test
  make[1]: Leaving directory '/home/michael/linux/tools/testing/selftests/cpu-opv'
  ~/linux/tools/testing/selftests$ make TARGETS="rseq cpu-opv" clean
  make[1]: Entering directory '/home/michael/linux/tools/testing/selftests/rseq'
  rm -f -r /home/michael/linux/tools/testing/selftests/rseq/basic_test /home/michael/linux/tools/testing/selftests/rseq/basic_percpu_ops_test /home/michael/linux/tools/testing/selftests/rseq/param_test   
  make[1]: Leaving directory '/home/michael/linux/tools/testing/selftests/rseq'
  make[1]: Entering directory '/home/michael/linux/tools/testing/selftests/cpu-opv'
  rm -f -r /home/michael/linux/tools/testing/selftests/cpu-opv/basic_cpu_opv_test   
  make[1]: Leaving directory '/home/michael/linux/tools/testing/selftests/cpu-opv'
  ~/linux/tools/testing/selftests$ cd cpu-opv/
  ~/linux/tools/testing/selftests/cpu-opv$ make -j
  gcc -O2 -Wall -g -I./ -I../../../../usr/include/    basic_cpu_opv_test.c cpu-op.c cpu-op.h  -o /home/michael/linux/tools/testing/selftests/cpu-opv/basic_cpu_opv_test
  ~/linux/tools/testing/selftests/cpu-opv$ make clean
  rm -f -r /home/michael/linux/tools/testing/selftests/cpu-opv/basic_cpu_opv_test   
  ~/linux/tools/testing/selftests/cpu-opv$ cd ../rseq/
  ~/linux/tools/testing/selftests/rseq$ make -j
  gcc -O2 -Wall -g -I./ -I../cpu-opv/ -I../../../../usr/include/    basic_test.c rseq.h rseq-ppc.h rseq-x86.h rseq-arm.h rseq.c ../cpu-opv/cpu-op.c ../cpu-opv/cpu-op.h -lpthread -o /home/michael/linux/tools/testing/selftests/rseq/basic_test
  gcc -O2 -Wall -g -I./ -I../cpu-opv/ -I../../../../usr/include/    basic_percpu_ops_test.c rseq.h rseq-ppc.h rseq-x86.h rseq-arm.h rseq.c ../cpu-opv/cpu-op.c ../cpu-opv/cpu-op.h -lpthread -o /home/michael/linux/tools/testing/selftests/rseq/basic_percpu_ops_test
  gcc -O2 -Wall -g -I./ -I../cpu-opv/ -I../../../../usr/include/    param_test.c rseq.h rseq-ppc.h rseq-x86.h rseq-arm.h rseq.c ../cpu-opv/cpu-op.c ../cpu-opv/cpu-op.h -lpthread -o /home/michael/linux/tools/testing/selftests/rseq/param_test
  ~/linux/tools/testing/selftests/rseq$ make clean
  rm -f -r /home/michael/linux/tools/testing/selftests/rseq/basic_test /home/michael/linux/tools/testing/selftests/rseq/basic_percpu_ops_test /home/michael/linux/tools/testing/selftests/rseq/param_test   



cheers

diff --git a/tools/testing/selftests/cpu-opv/Makefile b/tools/testing/selftests/cpu-opv/Makefile
index 81d0596824ee..d27bd0f74deb 100644
--- a/tools/testing/selftests/cpu-opv/Makefile
+++ b/tools/testing/selftests/cpu-opv/Makefile
@@ -1,13 +1,7 @@
 CFLAGS += -O2 -Wall -g -I./ -I../../../../usr/include/
-LDFLAGS += -lpthread
 
-TESTS = basic_cpu_opv_test
-
-all: $(TESTS)
-%: %.c cpu-op.c cpu-op.h
-       $(CC) $(CFLAGS) -o $@ $^ $(LDFLAGS)
+TEST_GEN_PROGS = basic_cpu_opv_test
 
 include ../lib.mk
 
-clean:
-       $(RM) $(TESTS)
+$(TEST_GEN_PROGS): cpu-op.c cpu-op.h
diff --git a/tools/testing/selftests/rseq/Makefile b/tools/testing/selftests/rseq/Makefile
index 7f0153556b80..7f625147b7fe 100644
--- a/tools/testing/selftests/rseq/Makefile
+++ b/tools/testing/selftests/rseq/Makefile
@@ -1,13 +1,8 @@
 CFLAGS += -O2 -Wall -g -I./ -I../cpu-opv/ -I../../../../usr/include/
-LDFLAGS += -lpthread
+LDLIBS += -lpthread
 
-TESTS = basic_test basic_percpu_ops_test param_test
-
-all: $(TESTS)
-%: %.c rseq.h rseq-*.h rseq.c ../cpu-opv/cpu-op.c ../cpu-opv/cpu-op.h
-       $(CC) $(CFLAGS) -o $@ $^ $(LDFLAGS)
+TEST_GEN_PROGS = basic_test basic_percpu_ops_test param_test
 
 include ../lib.mk
 
-clean:
-       $(RM) $(TESTS)
+$(TEST_GEN_PROGS): rseq.h rseq-*.h rseq.c ../cpu-opv/cpu-op.c ../cpu-opv/cpu-op.h
