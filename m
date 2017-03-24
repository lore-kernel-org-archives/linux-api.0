From: Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH] lkdtm: add bad USER_DS test
Date: Fri, 24 Mar 2017 10:46:41 -0700
Message-ID: <CAGXu5jJxNjdz3x1M3t9nhy590Bk67xwGxidYqJWytETb_PFgKQ@mail.gmail.com>
References: <20170323203419.GA62859@beast> <20170324081450.GA5891@osiris>
 <CAJcbSZHJ1WFcE7QY6qLM9RMUJbGXxTpp3WsCNJBX4h1U-4HEjA@mail.gmail.com> <a1ab8afa-5462-dc24-2106-0a6b43773c5b@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <kernel-hardening-return-7106-glkh-kernel-hardening=m.gmane.org@lists.openwall.com>
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
Sender: keescook@google.com
In-Reply-To: <a1ab8afa-5462-dc24-2106-0a6b43773c5b@de.ibm.com>
To: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Thomas Garnier <thgarnie@google.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, Martin Schwidefsky <schwidefsky@de.ibm.com>, David Howells <dhowells@redhat.com>, Arnd Bergmann <arnd@arndb.de>, Dave Hansen <dave.hansen@intel.com>, Al Viro <viro@zeniv.linux.org.uk>, Thomas Gleixner <tglx@linutronix.de>, =?UTF-8?Q?Ren=C3=A9_Nyffenegger?= <mail@renenyffenegger.ch>, Andrew Morton <akpm@linux-foundation.org>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, Ingo Molnar <mingo@kernel.org>, Oleg Nesterov <oleg@redhat.com>, Pavel Tikhomirov <ptikhomirov@virtuozzo.com>, Stephen Smalley <sds@tycho.nsa.gov>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Andy Lutomirski <luto@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, Rik van Riel <riel@redhat.com>, Josh Poimboeuf <jpoimboe@redhat.com>, Borislav Petkov <bp@alien8.de>, Brian Gerst <brgerst@gmail.com>
List-Id: linux-api@vger.kernel.org

On Fri, Mar 24, 2017 at 8:24 AM, Christian Borntraeger
<borntraeger@de.ibm.com> wrote:
> On 03/24/2017 04:17 PM, Thomas Garnier wrote:
>> On Fri, Mar 24, 2017 at 1:14 AM, Heiko Carstens
>> <heiko.carstens@de.ibm.com> wrote:
>>> On Thu, Mar 23, 2017 at 01:34:19PM -0700, Kees Cook wrote:
>>>> This adds CORRUPT_USER_DS to check that the get_fs() test on syscall return
>>>> still sees USER_DS during the new VERIFY_PRE_USERMODE_STATE checks.
>>>>
>>>> Signed-off-by: Kees Cook <keescook@chromium.org>
>>>
>>> ...
>>>
>>>> +void lkdtm_CORRUPT_USER_DS(void)
>>>> +{
>>>> +     /*
>>>> +      * Test that USER_DS has been set correctly on exiting a syscall.
>>>> +      * Since setting this higher than USER_DS (TASK_SIZE) would introduce
>>>> +      * an exploitable condition, we lower it instead, since that should
>>>> +      * not create as large a problem on an unprotected system.
>>>> +      */
>>>> +     mm_segment_t lowfs;
>>>> +#ifdef MAKE_MM_SEG
>>>> +     lowfs = MAKE_MM_SEG(TASK_SIZE - PAGE_SIZE);
>>>> +#else
>>>> +     lowfs = TASK_SIZE - PAGE_SIZE;
>>>> +#endif
>>>> +
>>>> +     pr_info("setting bad task size limit\n");
>>>> +     set_fs(lowfs);
>>>> +}
>>>
>>> This won't work on architectures where the set_fs() argument does not
>>> contain an address but an address space identifier. This is true e.g. for
>>> s390 and as far as I know also for sparc.
>>> On s390 we have complete distinct address spaces for kernel and user space
>>> that each start at address zero.
>>>
>>
>> The patch that enforce USER_DS is disabled on s390 anyway. I guess, we
>> can just do a set_fs(KERNEL_DS) for the others.
>
> that would enable the test, but it would also mean that lkdtm can be used by
> a program to escalate its rights. I think that is the reason why Kees did this
> lowfs things.

Yeah, but it seems like getting this right for all architectures isn't
sane. I'm going to change it to use KERNEL_DS but also post a SIGKILL
to the process. That way it'll still trigger the syscall return
checking, but will be unable to continue running with a potentially
uncaught KERNEL_DS.

-Kees

-- 
Kees Cook
Pixel Security
