From: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v3 2/4] x86/syscalls: Specific usage of verify_pre_usermode_state
Date: Thu, 23 Mar 2017 12:14:56 -0700
Message-ID: <201703231915.v2NJF848011670__32287.6345170245$1490297972$gmane$org@mail.zytor.com>
References: <20170311000501.46607-1-thgarnie@google.com> <20170311000501.46607-2-thgarnie@google.com> <20170311094200.GA27700@gmail.com> <733ed189-6c01-2975-a81a-6fbfe4b7b593@zytor.com> <2d9aad2a-a677-40d2-c179-379fb6e9f194@zytor.com> <CAJcbSZG6F3DsiBMjizTbzaccvU5_RKdspU06wQ8yi+JT+EW2Jw@mail.gmail.com> <CALCETrVVo4aQosdjfUPBf=JWyVWE_cHavbBKX5Swv_HbV__RNw@mail.gmail.com> <CAJcbSZEFWzPVfxVzOF5r1yywkgMObxOt8W+1efuTUsv+82FBpg@mail.gmail.com> <7389c6e7-87dc-ea0d-5b2a-7925b8c8d33e@zytor.com> <CAJcbSZGjos1K9qvQWPTpr4COEcnW6Sn_jo7hCezGbh-BhPAH7w@mail.gmail.com> <8fa1a789-231f-dc2c-4a43-6406194259f9@zytor.com> <CAJcbSZGrD2q7ymUSFNMtvwL+JUzbQ5WNA=MU6tpJ6XVnfJipcw@mail.gmail.com> <CAJcbSZEi6vxf8zGrLuLE3WGzBJYTrLEAC_Esx7pJx8MHn35qCg@mail.gmail.com> <60718a28-1f67-3612-49b0-84ac685e1eba@zytor.com> <CAJ
 cbSZHhHjJ4h-4D4r7ocZxj2ys1rgNuq6iG_Q-q0kxfcitDQw@mail.gmail.com> <679d163f-2927-ed56-71dc-976fcf5e213f@zytor.com> <CAJcbSZEouZ2v+q_i-3Xiba2FNT18ipKwF09838vvfSCwEi7e4Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJcbSZEouZ2v+q_i-3Xiba2FNT18ipKwF09838vvfSCwEi7e4Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Thomas Garnier <thgarnie-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Martin Schwidefsky <schwidefsky-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Heiko Carstens <heiko.carstens-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Dave Hansen <dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, =?ISO-8859-1?Q?Ren=E9_Nyffenegger?= <mail-gLCNRsNSrVdVZEhyV+6z5nIPMjoJpjVV@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, "Paul E . McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Nicolas Pitre <nicolas.pitre-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Petr Mladek <pmladek-IBi9RG/b67k@public.gmane.org>, Sebastian Andrzej Siewior <bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Sergey Senozhatsky <sergey.senozhatsky-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Helge
List-Id: linux-api@vger.kernel.org

Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,Stanislav Kinsburskiy <skinsbursky-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>,Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,Paolo Bonzini <pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,Dmitry Safonov <dsafonov-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>,Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>,Josh Poimboeuf <jpoimboe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,Brian Gerst <brgerst-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,Jan Beulich <JBeulich-IBi9RG/b67k@public.gmane.org>,Christian Borntraeger <borntraeger-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>,Fenghua Yu <fenghua.yu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>,He Chen <he.chen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>,Russell King <linux-I+IVW8TIWO2tmTQ+vhA3Yw@public.gmane.org>,Vladimir Murzin <vladimir.murzin-5wv7dgnIgG8@public.gmane.org>,Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>,Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>,Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>,James Morse <james.morse-5wv7dgnIgG8@public.gmane.org>,"David A . Long" <dave.long-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>,Pratyush Anand <panand-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,Laura Abbott <labbott-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,Andre Przywara <andre.przywara
 @arm.com>,Chris Metcalf <cmetcalf-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>,linux-s390 <linux-s390-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,the arch/x86 maintainers
<x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>,"linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>,Kernel Hardening <kernel-hardening-ZwoEplunGu1jrUoiu81ncdBPR1lH4CV8@public.gmane.org>
From: hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org
Message-ID: <E0C934E7-6789-4598-AF55-468C84B8568B-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>

On March 22, 2017 2:11:12 PM PDT, Thomas Garnier <thgarnie-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
>On Wed, Mar 22, 2017 at 1:49 PM, H. Peter Anvin <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org> wrote:
>> On 03/22/17 13:41, Thomas Garnier wrote:
>>>>> with the change below for additional feedback.
>>>>
>>>> Can you specify what that means?
>>>
>>> If I set inline by default, the compiler chose not to inline it on
>>> x86. If I force inline the size impact was actually bigger (without
>>> the architecture specific code).
>>>
>>
>> That's utterly bizarre.  Something strange is going on there.  I
>suspect
>> the right thing to do is to out-of-line the error case only, but even
>> that seems strange.  It should be something like four instructions
>inline.
>>
>
>The compiler seemed to often inline other functions called by the
>syscall handlers. I assume the growth was due to changes in code
>optimization because the function is much larger at the end.
>
>>>>
>>>> On x86, where there is only one caller of this, it really seems
>like it
>>>> ought to reduce the overhead to almost zero (since it most likely
>is
>>>> hidden in the pipeline.)
>>>>
>>>> I would like to suggest defining it inline if
>>>> CONFIG_ARCH_NO_SYSCALL_VERIFY_PRE_USERMODE_STATE is set; I really
>don't
>>>> care about an architecture which doesn't have it.
>>>
>>> But if there is only one caller, does the compiler is not suppose to
>>> inline the function based on options?
>>
>> If it is marked static in the same file, yes, but you have it in a
>> different file from what I can tell.
>
>If we do global optimization, it should. Having it as a static inline
>make it easier on all types of builds.
>
>>
>>> The assembly will call it too, so I would need an inline and a
>>> non-inline based on the caller.
>>
>> Where?  I don't see that anywhere, at least for x86.
>
>After the latest changes on x86, yes. On arm/arm64, we call it with
>the CHECK_DATA_CORRUPTION config.
>
>>
>>         -hpa
>>

If we do global optimization, yes, but global optimization (generally called link-time optimization, LTO, on Linux) is very much the exception and not the rule for the Linux kernel at this time.
-- 
Sent from my Android device with K-9 Mail. Please excuse my brevity.
