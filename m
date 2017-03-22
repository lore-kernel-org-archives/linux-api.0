From: Thomas Garnier <thgarnie@google.com>
Subject: Re: [PATCH v3 2/4] x86/syscalls: Specific usage of verify_pre_usermode_state
Date: Wed, 22 Mar 2017 13:41:54 -0700
Message-ID: <CAJcbSZHhHjJ4h-4D4r7ocZxj2ys1rgNuq6iG_Q-q0kxfcitDQw@mail.gmail.com>
References: <20170311000501.46607-1-thgarnie@google.com> <20170311000501.46607-2-thgarnie@google.com>
 <20170311094200.GA27700@gmail.com> <733ed189-6c01-2975-a81a-6fbfe4b7b593@zytor.com>
 <2d9aad2a-a677-40d2-c179-379fb6e9f194@zytor.com> <CAJcbSZG6F3DsiBMjizTbzaccvU5_RKdspU06wQ8yi+JT+EW2Jw@mail.gmail.com>
 <CALCETrVVo4aQosdjfUPBf=JWyVWE_cHavbBKX5Swv_HbV__RNw@mail.gmail.com>
 <CAJcbSZEFWzPVfxVzOF5r1yywkgMObxOt8W+1efuTUsv+82FBpg@mail.gmail.com>
 <7389c6e7-87dc-ea0d-5b2a-7925b8c8d33e@zytor.com> <CAJcbSZGjos1K9qvQWPTpr4COEcnW6Sn_jo7hCezGbh-BhPAH7w@mail.gmail.com>
 <8fa1a789-231f-dc2c-4a43-6406194259f9@zytor.com> <CAJcbSZGrD2q7ymUSFNMtvwL+JUzbQ5WNA=MU6tpJ6XVnfJipcw@mail.gmail.com>
 <CAJcbSZEi6vxf8zGrLuLE3WGzBJYTrLEAC_Esx7pJx8MHn35qCg@mail.gmail.com> <60718a28-1f67-3612-49b0-84ac685e1eba@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <kernel-hardening-return-7065-glkh-kernel-hardening=m.gmane.org@lists.openwall.com>
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
In-Reply-To: <60718a28-1f67-3612-49b0-84ac685e1eba@zytor.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andy Lutomirski <luto@amacapital.net>, Ingo Molnar <mingo@kernel.org>, Martin Schwidefsky <schwidefsky@de.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, David Howells <dhowells@redhat.com>, Arnd Bergmann <arnd@arndb.de>, Al Viro <viro@zeniv.linux.org.uk>, Dave Hansen <dave.hansen@intel.com>, =?UTF-8?Q?Ren=C3=A9_Nyffenegger?= <mail@renenyffenegger.ch>, Andrew Morton <akpm@linux-foundation.org>, Kees Cook <keescook@chromium.org>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, Andy Lutomirski <luto@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Nicolas Pitre <nicolas.pitre@linaro.org>, Petr Mladek <pmladek@suse.com>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, Helge Deller <deller@gmx.de>, Rik van Riel <riel@redhat.com>, John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix>
List-Id: linux-api@vger.kernel.org

On Wed, Mar 22, 2017 at 1:21 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 03/22/17 12:15, Thomas Garnier wrote:
>> On Wed, Mar 15, 2017 at 10:43 AM, Thomas Garnier <thgarnie@google.com> wrote:
>>> Thanks for the feedback. I will look into inlining by default (looking
>>> at code size on different arch), the updated patch for x86 in the
>>> meantime:
>>
>> I did couple checks and it doesn't seem worth it. I will send a v4
>> with the change below for additional feedback.
>
> Can you specify what that means?

If I set inline by default, the compiler chose not to inline it on
x86. If I force inline the size impact was actually bigger (without
the architecture specific code).

>
> On x86, where there is only one caller of this, it really seems like it
> ought to reduce the overhead to almost zero (since it most likely is
> hidden in the pipeline.)
>
> I would like to suggest defining it inline if
> CONFIG_ARCH_NO_SYSCALL_VERIFY_PRE_USERMODE_STATE is set; I really don't
> care about an architecture which doesn't have it.

But if there is only one caller, does the compiler is not suppose to
inline the function based on options?

The assembly will call it too, so I would need an inline and a
non-inline based on the caller.

>
> Note that the upcoming 5-level paging (LA57) support will make
> TASK_SIZE_MAX dependent on the CPU.  The best way to handle that is
> probably to tag this immediate with an assembly alternative rather than
> loading it from a memory variable (most likely taking a cache hit.)
>
>         -hpa
>



-- 
Thomas
