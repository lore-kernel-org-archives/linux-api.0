From: ebiederm@xmission.com (Eric W. Biederman)
Subject: Re: [PATCH v2] signal: add procfd_signal() syscall
Date: Sat, 01 Dec 2018 07:41:30 -0600
Message-ID: <87va4d1i0l.fsf@xmission.com>
References: <20181120105124.14733-1-christian@brauner.io>
        <87in0g5aqo.fsf@oldenburg.str.redhat.com>
        <36323361-90BD-41AF-AB5B-EE0D7BA02C21@amacapital.net>
        <993B98AC-51DF-4131-AF7F-7DA2A7F485F1@brauner.io>
        <CALCETrWnQNMQcCmFZrftVVYgAMW6DT3gyxvVb_v9_enUCUkHiw@mail.gmail.com>
        <20181129195551.woe2bl3z3yaysqb6@brauner.io>
        <6E21165F-2C76-4877-ABD9-0C86D55FD6AA@amacapital.net>
        <CAK8P3a2i9DFaS9-3A9V_pKwFfwVR0bDqgLosmivge3Cx2VyiuQ@mail.gmail.com>
        <87y39b2lm2.fsf@xmission.com>
        <20181130065606.kmilbbq46oeycjp5@brauner.io>
        <CAK8P3a0kqPii5TwFAo_JHLX=o_FDMFVKXxgzzbDjLFZ7OQ5QCQ@mail.gmail.com>
        <CALCETrW2aphWwEY4=hUwo_JBCvkQyMjxzxGd9FCW017kMLaMOQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CALCETrW2aphWwEY4=hUwo_JBCvkQyMjxzxGd9FCW017kMLaMOQ@mail.gmail.com>
        (Andy Lutomirski's message of "Fri, 30 Nov 2018 08:35:45 -0800")
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Christian Brauner <christian@brauner.io>, Florian Weimer <fweimer@redhat.com>, LKML <linux-kernel@vger.kernel.org>, "Serge E. Hallyn" <serge@hallyn.com>, Jann Horn <jannh@google.com>, Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>, Aleksa Sarai <cyphar@cyphar.com>, Al Viro <viro@zeniv.linux.org.uk>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Daniel Colascione <dancol@google.com>, Tim Murray <timmurray@google.com>, linux-man <linux-man@vger.kernel.org>, Kees Cook <keescook@chromium.org>
List-Id: linux-api@vger.kernel.org

Andy Lutomirski <luto@kernel.org> writes:

> On Fri, Nov 30, 2018 at 3:41 AM Arnd Bergmann <arnd@arndb.de> wrote:
>> siginfo_t as it is now still has a number of other downsides, and Andy in
>> particular didn't like the idea of having three new variants on x86
>> (depending on how you count). His alternative suggestion of having
>> a single syscall entry point that takes a 'signfo_t __user *' but interprets
>> it as compat_siginfo depending on in_compat_syscall()/in_x32_syscall()
>> should work correctly, but feels wrong to me, or at least inconsistent
>> with how we do this elsewhere.
>
> BTW, do we consider siginfo_t to be extensible?  If so, and if we pass
> in a pointer, presumably we should pass a length as well.

siginfo is extensible in the sense that the structure is 128 bytes
and we use at most 48 bytes.  siginfo gets embedded in stack frames when
signals get delivered so a size change upwards is non-trivial, and is
possibly and ABI break so I believe a length field would be pointless.

Eric
