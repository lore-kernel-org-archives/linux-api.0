From: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Subject: Re: [RFC PATCH for 4.15 v3 14/22] cpu_opv: selftests: Implement
 selftests
Date: Tue, 21 Nov 2017 16:46:11 +0000 (UTC)
Message-ID: <78388403.19365.1511282771630.JavaMail.zimbra@efficios.com>
References: <20171121141900.18471-1-mathieu.desnoyers@efficios.com> <20171121141900.18471-15-mathieu.desnoyers@efficios.com> <c311cd4b-4d8f-bfb5-3731-2cb2eefa4865@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <c311cd4b-4d8f-bfb5-3731-2cb2eefa4865-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: shuah <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Boqun Feng <boqun.feng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Dave Watson <davejwatson-b10kYP2dOMg@public.gmane.org>, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-api <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Russell King <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>, Chris Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Ben Maurer <bmaurer-b10kYP2dOMg@public.gmane.org>, rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Catalin Marinas <cata>
List-Id: linux-api@vger.kernel.org

----- On Nov 21, 2017, at 10:17 AM, shuah shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org wrote:

[...]

>> +int main(int argc, char **argv)
>> +{
>> +	int ret = 0;
>> +
>> +	ret |= test_compare_eq_same();
>> +	ret |= test_compare_eq_diff();
>> +	ret |= test_compare_ne_same();
>> +	ret |= test_compare_ne_diff();
>> +	ret |= test_2compare_eq_index();
>> +	ret |= test_2compare_ne_index();
>> +	ret |= test_memcpy();
>> +	ret |= test_memcpy_u32();
>> +	ret |= test_memcpy_mb_memcpy();
>> +	ret |= test_add();
>> +	ret |= test_two_add();
>> +	ret |= test_or();
>> +	ret |= test_and();
>> +	ret |= test_xor();
>> +	ret |= test_lshift();
>> +	ret |= test_rshift();
>> +	ret |= test_cmpxchg_success();
>> +	ret |= test_cmpxchg_fail();
>> +	ret |= test_memcpy_fault();
>> +	ret |= test_unknown_op();
>> +	ret |= test_max_ops();
>> +	ret |= test_too_many_ops();
>> +	ret |= test_memcpy_single_too_large();
>> +	ret |= test_memcpy_single_ok_sum_too_large();
>> +	ret |= test_page_fault();
>> +
> 
> Where do pass counts get printed. I am seeing error messages when tests fail,
> not seeing any pass messages. It would be nice to use ksft framework for
> counting pass/fail for these series of tests that get run.

done. New output:

TAP version 13
(standard_in) 1: syntax error
selftests: basic_cpu_opv_test
========================================
TAP version 13
ok 1 test_compare_eq same test
ok 2 test_compare_eq different test
ok 3 test_compare_ne same test
ok 4 test_compare_ne different test
ok 5 test_2compare_eq index test
ok 6 test_2compare_ne index test
ok 7 test_memcpy test
ok 8 test_memcpy_u32 test
ok 9 test_memcpy_mb_memcpy test
ok 10 test_add test
ok 11 test_two_add test
ok 12 test_or test
ok 13 test_and test
ok 14 test_xor test
ok 15 test_lshift test
ok 16 test_rshift test
ok 17 test_cmpxchg success test
ok 18 test_cmpxchg fail test
ok 19 test_memcpy_fault test
ok 20 test_unknown_op test
ok 21 test_max_ops test
ok 22 test_too_many_ops test
ok 23 test_memcpy_single_too_large test
ok 24 test_memcpy_single_ok_sum_too_large test
ok 25 test_page_fault test
Pass 25 Fail 0 Xfail 0 Xpass 0 Skip 0 Error 0
1..25
ok 1.. selftests: basic_cpu_opv_test [PASS]

(note the "(standard_in) 1: syntax error" for which I provided a fix
in a separate thread still appears with my make version)

[...]

>> diff --git a/tools/testing/selftests/lib.mk b/tools/testing/selftests/lib.mk
>> index 5bef05d6ba39..441d7bc63bb7 100644
>> --- a/tools/testing/selftests/lib.mk
>> +++ b/tools/testing/selftests/lib.mk
>> @@ -105,6 +105,9 @@ COMPILE.S = $(CC) $(ASFLAGS) $(CPPFLAGS) $(TARGET_ARCH) -c
>>  LINK.S = $(CC) $(ASFLAGS) $(CPPFLAGS) $(LDFLAGS) $(TARGET_ARCH)
>>  endif
>>  
>> +# Selftest makefiles can override those targets by setting
>> +# OVERRIDE_TARGETS = 1.
>> +ifeq ($(OVERRIDE_TARGETS),)
>>  $(OUTPUT)/%:%.c
>>  	$(LINK.c) $^ $(LDLIBS) -o $@
>>  
>> @@ -113,5 +116,6 @@ $(OUTPUT)/%.o:%.S
>>  
>>  $(OUTPUT)/%:%.S
>>  	$(LINK.S) $^ $(LDLIBS) -o $@
>> +endif
>>  
>>  .PHONY: run_tests all clean install emit_tests
>> 
> 
> As I said before, please do this change in a separate patch.

Sorry, it appears that I missed this comment last time. Will move
this change to a separate patch.

Thanks,

Mathieu


-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
