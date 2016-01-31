From: Stas Sergeev <stsp@list.ru>
Subject: Re: [PATCH 4/4] sigaltstack: allow disabling and re-enabling sas
 within sighandler
Date: Sun, 31 Jan 2016 20:33:27 +0300
Message-ID: <56AE4567.9000403@list.ru>
References: <56AE3369.2090709@list.ru> <56AE3626.7080706@list.ru>
 <CALCETrU1sB4FDkyrGcxY0CrCRr7qyGW0tzmpyaQDwM0UTjCRMw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CALCETrU1sB4FDkyrGcxY0CrCRr7qyGW0tzmpyaQDwM0UTjCRMw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@amacapital.net>
Cc: Linux kernel <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>, Amanieu d'Antras <amanieu@gmail.com>, Richard Weinberger <richard@nod.at>, Tejun Heo <tj@kernel.org>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Jason Low <jason.low2@hp.com>, Heinrich Schuchardt <xypron.glpk@gmx.de>, Andrea Arcangeli <aarcange@redhat.com>, Konstantin Khlebnikov <khlebnikov@yandex-team.ru>, Josh Triplett <josh@joshtriplett.org>, "Eric W. Biederman" <ebiederm@xmission.com>, Aleksa Sarai <cyphar@cyphar.com>, Paul Moore <pmoore@redhat.com>, Palmer Dabbelt <palmer@dabbelt.com>, Vladimir Davydov <vdavydov@parallels.com>, Linus Torvalds <torvalds@linux-foundation.org>
List-Id: linux-api@vger.kernel.org

31.01.2016 20:00, Andy Lutomirski =D0=BF=D0=B8=D1=88=D0=B5=D1=82:
> On Sun, Jan 31, 2016 at 8:28 AM, Stas Sergeev <stsp@list.ru> wrote:
>> linux implements the sigaltstack() in a way that makes it impossible=
 to
>> use with swapcontext(). Per the man page, sigaltstack is allowed to =
return
>> EPERM if the process is altering its sigaltstack while running on
>> sigaltstack.
>> This is likely needed to consistently return oss->ss_flags, that ind=
icates
>> whether the process is being on sigaltstack or not.
>> Unfortunately, linux takes that permission to return EPERM too liter=
ally:
>> it returns EPERM even if you don't want to change to another sigalts=
tack,
>> but only want to temporarily disable sigaltstack with SS_DISABLE.
>> You can't use swapcontext() without disabling sigaltstack first, or =
the
>> stack will be re-used and overwritten by a subsequent signal.
>>
>> With this patch, disabling sigaltstack inside a signal handler becam=
e
>> possible, and the swapcontext() can then be used safely. After switc=
hing
>> back to the sighandler, the app can re-enable the sigatlstack.
>> The oss->ss_flags will correctly indicate the current use of sigalts=
tack,
>> even if it is temporarily disabled. Any attempt to modify the sigalt=
stack
>> (rather than to disable or re-enable it) within the sighandler, will=
 still
>> be punished with EPERM as suggested by POSIX.
> This seems considerably more complicated than my previous proposal to
> add an SS_FORCE flag to say "I know what I'm doing.  Ignore POSIX and
> let me change the sigaltstack configuration even if it's in use".
> What's the advantage?
To me, the main advantage is to stay POSIX-compatible, rather
than adding the linux-specific flag. Please note that this flag does
not add any value other than to say "I want to ignore POSIX here"
in your interpretation of POSIX, and in my interpretation it doesn't
say even this, because in my interpretation the temporary disabling
is not prohibited. So if it doesn't even fit my interpretation, how wou=
ld
I write a man description for it? I'll have to first clarify the vague
wording to clearly sound your way, and then add the flag to override
this. This whole procedure looks very illogical to me. So to find out
if it is just me, I'd like to hear from anyone else supporting the idea
of adding this flag. If people think its existence is justified, then f=
ine.
But to me this flag is non-portable, while the both sigaltstack() and
swapcontext() are portable. So what will I gain with adding a
non-portable flag to my apps? A bunch of ifdefs?
IMHO as long as both swapcontext() and sigaltstack() are POSIX-compatib=
le,
they should be compatible with each other in a POSIX-compatible
way. If POSIX needs the linux-specific flags to make them compatible
with each other, then POSIX is inconsistent. So lets just don't interpr=
et
it the way that makes it so.

So in short:
Your concern is the patch complexity. Doing things your way will
however move the problem to the user: he will have to deal with the
linux-specific flags and add ifdefs for just a mere use of a=20
posix-compatible
interfaces.

There can also be the subtle technical differences.
With your approach the nested signal can AFAIU overflow the
the disabled sigaltstack because you don't maintain the oss->ss_flags
in a consistent way. There is an overflow protection code:
---
/*
  * If we are on the alternate signal stack and would overflow it, don'=
t.
  * Return an always-bogus address instead so we will die with SIGSEGV.
  */
  if (onsigstack && !likely(on_sig_stack(sp)))
          return (void __user *)-1L;
---
In your approach it will be bypassed.
And its not possible for an app to find out if it is running on a
sigaltstack now or not, after it is disabled.
Yes, maybe minor. But overall I see more disadvantages here
compared to the only disadvantage of my patch: its complexity.
But isn't the kernel developed to make user's life easier? :)
So to make it your way and start to add ifdef HAVE_SS_FORCE
to my apps, I'd like at least any other person to vote for your way.
Then fine.
