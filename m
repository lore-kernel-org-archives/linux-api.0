From: Christian Brauner <christian@brauner.io>
Subject: Re: [PATCH v2] signal: add procfd_signal() syscall
Date: Sat, 01 Dec 2018 14:25:10 +1300
Message-ID: <7D934AED-82E4-4DC3-8CCB-973680316B60@brauner.io>
References: <20181120105124.14733-1-christian@brauner.io> <87in0g5aqo.fsf@oldenburg.str.redhat.com> <36323361-90BD-41AF-AB5B-EE0D7BA02C21@amacapital.net> <993B98AC-51DF-4131-AF7F-7DA2A7F485F1@brauner.io> <CALCETrWnQNMQcCmFZrftVVYgAMW6DT3gyxvVb_v9_enUCUkHiw@mail.gmail.com> <20181129195551.woe2bl3z3yaysqb6@brauner.io> <6E21165F-2C76-4877-ABD9-0C86D55FD6AA@amacapital.net> <CAK8P3a2i9DFaS9-3A9V_pKwFfwVR0bDqgLosmivge3Cx2VyiuQ@mail.gmail.com> <20181129213458.4h44dpg6ltqow4k4@brauner.io> <CAK8P3a1_if7+Ak2eefU6JeZT9KW827gkLHaObX-QOsHrB5ZwfA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAK8P3a1_if7+Ak2eefU6JeZT9KW827gkLHaObX-QOsHrB5ZwfA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: Andy Lutomirski <luto@amacapital.net>, Andy Lutomirski <luto@kernel.org>, Florian Weimer <fweimer@redhat.com>, "Eric W . Biederman" <ebiederm@xmission.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "Serge E. Hallyn" <serge@hallyn.com>, Jann Horn <jannh@google.com>, Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>, cyphar@cyphar.com, Al Viro <viro@zeniv.linux.org.uk>, Linux FS-devel Mailing List <linux-fsdevel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Daniel Colascione <dancol@google.com>, Tim Murray <timmurray@google.com>, linux-man@vger.kernel.org, Kees Cook <keescook@chromium.org>
List-Id: linux-api@vger.kernel.org

On November 30, 2018 10:40:49 AM GMT+13:00, Arnd Bergmann <arnd@arndb=2Ede>=
 wrote:
>On Thu, Nov 29, 2018 at 10:35 PM Christian Brauner
><christian@brauner=2Eio> wrote:
>> On Thu, Nov 29, 2018 at 10:02:13PM +0100, Arnd Bergmann wrote:
>> > On Thu, Nov 29, 2018 at 9:14 PM Andy Lutomirski
><luto@amacapital=2Enet> wrote:
>> >
>> > Is the current procfd_signal() proposal (under whichever name)
>sufficient
>> > to correctly implement both sys_rt_sigqueueinfo() and
>sys_rt_tgsigqueueinfo()?
>>
>> Yes, I see no reason why not=2E My idea is to extend it - after we have
>a
>> basic version in - to also work with:
>> /proc/<pid>/task/<tid>
>> If I'm not mistaken this should be sufficient to get
>rt_tgsigqueueinfo=2E
>> The thread will be uniquely identified by the tid descriptor and no
>> combination of /proc/<pid> and /proc/<pid>/task/<tid> is needed=2E Does
>> that sound reasonable?
>
>Yes=2E So it would currently replace rt_gsigqueueinfo() but
>not rt_tgsigqueueinfo(), and could be extended to do both
>afterwards, without making the interface ugly in any form?

Yes=2E :)

>
>I suppose we can always add more flags if needed, and you
>already ensure that flags is zero for the moment=2E

Yep=2E

>
>> > Can we implement sys_rt_sigtimedwait() based on signalfd()?
>> >
>> > If yes, that would leave waitid(), which already needs a
>replacement
>> > for y2038, and that should then also return a signalfd_siginfo=2E
>> > My current preference for waitid() would be to do a version that
>> > closely resembles the current interface, but takes a
>signalfd_siginfo
>> > and a __kernel_timespec based rusage replacement (possibly
>> > two of them to let us map wait6), but does not operate on procfd or
>> > take a signal mask=2E That would require yet another syscall, but I
>> > don't think I can do that before we want to have the set of y2038
>> > safe syscalls=2E
>>
>> All sounds reasonable to me but that's not a blocker for the current
>> syscall though, is it?
>
>I'd like to at least understand about sys_rt_sigtimedwait() before
>we go on, so we all know what's coming, and document the
>plans in the changelog=2E
>
>waitid() probably remains on my plate anyway, and I hope understand
>where we're at with it=2E
>
>     Arnd
