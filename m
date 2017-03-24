From: Thomas Garnier <thgarnie-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] lkdtm: add bad USER_DS test
Date: Fri, 24 Mar 2017 08:17:11 -0700
Message-ID: <CAJcbSZHJ1WFcE7QY6qLM9RMUJbGXxTpp3WsCNJBX4h1U-4HEjA@mail.gmail.com>
References: <20170323203419.GA62859@beast> <20170324081450.GA5891@osiris>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170324081450.GA5891@osiris>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Heiko Carstens <heiko.carstens-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>
Cc: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Martin Schwidefsky <schwidefsky-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Dave Hansen <dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, =?UTF-8?Q?Ren=C3=A9_Nyffenegger?= <mail-gLCNRsNSrVdVZEhyV+6z5nIPMjoJpjVV@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "Paul E . McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Pavel Tikhomirov <ptikhomirov-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, Stephen Smalley <sds-+05T5uksL2qpZYMLLGbcSA@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H . Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Paolo Bonzini <pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Josh
List-Id: linux-api@vger.kernel.org

On Fri, Mar 24, 2017 at 1:14 AM, Heiko Carstens
<heiko.carstens-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org> wrote:
> On Thu, Mar 23, 2017 at 01:34:19PM -0700, Kees Cook wrote:
>> This adds CORRUPT_USER_DS to check that the get_fs() test on syscall return
>> still sees USER_DS during the new VERIFY_PRE_USERMODE_STATE checks.
>>
>> Signed-off-by: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
>
> ...
>
>> +void lkdtm_CORRUPT_USER_DS(void)
>> +{
>> +     /*
>> +      * Test that USER_DS has been set correctly on exiting a syscall.
>> +      * Since setting this higher than USER_DS (TASK_SIZE) would introduce
>> +      * an exploitable condition, we lower it instead, since that should
>> +      * not create as large a problem on an unprotected system.
>> +      */
>> +     mm_segment_t lowfs;
>> +#ifdef MAKE_MM_SEG
>> +     lowfs = MAKE_MM_SEG(TASK_SIZE - PAGE_SIZE);
>> +#else
>> +     lowfs = TASK_SIZE - PAGE_SIZE;
>> +#endif
>> +
>> +     pr_info("setting bad task size limit\n");
>> +     set_fs(lowfs);
>> +}
>
> This won't work on architectures where the set_fs() argument does not
> contain an address but an address space identifier. This is true e.g. for
> s390 and as far as I know also for sparc.
> On s390 we have complete distinct address spaces for kernel and user space
> that each start at address zero.
>

The patch that enforce USER_DS is disabled on s390 anyway. I guess, we
can just do a set_fs(KERNEL_DS) for the others.


-- 
Thomas
