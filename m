From: Christian Brauner <christian@brauner.io>
Subject: Re: [PATCH v2] signal: add procfd_signal() syscall
Date: Sat, 01 Dec 2018 10:57:11 +1300
Message-ID: <DCA81C46-30A4-4B6A-AA1F-9DCC102968C9@brauner.io>
References: <20181120105124.14733-1-christian@brauner.io> <87in0g5aqo.fsf@oldenburg.str.redhat.com> <36323361-90BD-41AF-AB5B-EE0D7BA02C21@amacapital.net> <993B98AC-51DF-4131-AF7F-7DA2A7F485F1@brauner.io> <CALCETrWnQNMQcCmFZrftVVYgAMW6DT3gyxvVb_v9_enUCUkHiw@mail.gmail.com> <20181129195551.woe2bl3z3yaysqb6@brauner.io> <6E21165F-2C76-4877-ABD9-0C86D55FD6AA@amacapital.net> <CAK8P3a2i9DFaS9-3A9V_pKwFfwVR0bDqgLosmivge3Cx2VyiuQ@mail.gmail.com> <87y39b2lm2.fsf@xmission.com> <20181130065606.kmilbbq46oeycjp5@brauner.io> <CAK8P3a0kqPii5TwFAo_JHLX=o_FDMFVKXxgzzbDjLFZ7OQ5QCQ@mail.gmail.com> <CALCETrW2aphWwEY4=hUwo_JBCvkQyMjxzxGd9FCW017kMLaMOQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CALCETrW2aphWwEY4=hUwo_JBCvkQyMjxzxGd9FCW017kMLaMOQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Andrew Lutomirski <luto@kernel.org>, Florian Weimer <fweimer@redhat.com>, LKML <linux-kernel@vger.kernel.org>, "Serge E. Hallyn" <serge@hallyn.com>, Jann Horn <jannh@google.com>, Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>, Aleksa Sarai <cyphar@cyphar.com>, Al Viro <viro@zeniv.linux.org.uk>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Daniel Colascione <dancol@google.com>, Tim Murray <timmurray@google.com>, linux-man <linux-man@vger.kernel.org>, Kees Cook <keescook@chromium.org>
List-Id: linux-api@vger.kernel.org

On December 1, 2018 5:35:45 AM GMT+13:00, Andy Lutomirski <luto@kernel=2Eor=
g> wrote:
>On Fri, Nov 30, 2018 at 3:41 AM Arnd Bergmann <arnd@arndb=2Ede> wrote:
>> siginfo_t as it is now still has a number of other downsides, and
>Andy in
>> particular didn't like the idea of having three new variants on x86
>> (depending on how you count)=2E His alternative suggestion of having
>> a single syscall entry point that takes a 'signfo_t __user *' but
>interprets
>> it as compat_siginfo depending on
>in_compat_syscall()/in_x32_syscall()
>> should work correctly, but feels wrong to me, or at least
>inconsistent
>> with how we do this elsewhere=2E
>
>If everyone else is okay with it, I can get on board with three
>variants on x86=2E  What I can't get on board with is *five* variants on

Thanks Andy, that helps a lot=2E
I'm okay with it=2E Does this require any additional changes to how the sy=
scall
is currently hooked up?

>x86, which would be:
>
>procfd_signal via int80 / the 32-bit vDSO: the ia32 structure
>
>syscall64 with nr =3D=3D 335 (presumably): 64-bit
>
>syscall64 with nr =3D=3D 548 | 0x40000000: x32
>
>syscall64 with nr =3D=3D 548: 64-bit entry but in_compat_syscall() =3D=3D
>true, behavior is arbitrary
>
>syscall64 with nr =3D=3D 335 | 0x40000000: x32 entry, but
>in_compat_syscall() =3D=3D false, behavior is arbitrary
>
>This mess isn't really Christian's fault -- it's been there for a
>while, but it's awful and I don't think we want to perpetuate it=2E
>
>Obviously, I'd prefer a variant where the structure that's passed in
>is always the same=2E
>
>BTW, do we consider siginfo_t to be extensible?  If so, and if we pass

I would prefer if we could consider it extensible=2E
If so I would prefer if we could pass in a size argument=2E

>in a pointer, presumably we should pass a length as well=2E
