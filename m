From: Jonathan Kowalski <bl0pbl33p@gmail.com>
Subject: Re: [PATCH v2 0/5] pid: add pidfd_open()
Date: Sun, 31 Mar 2019 23:03:07 +0100
Message-ID: <CAGLj2rF1CbnpKehrSCwkT22NfwJv5f-G_Wh0r1FY4XFad9Q7zg@mail.gmail.com>
References: <20190329155425.26059-1-christian@brauner.io> <CAHk-=wjq4dTPcz-qsvhpm5F42SDHCoqEWv1V=rs_kt6MC=ZThA@mail.gmail.com>
 <BCD99947-5F55-4116-8F74-D6832E50340B@brauner.io> <CAHk-=whcA0kAWGqet9oJdyttjhP7J4PcU2Ly=n_Qyo6rMJNxRg@mail.gmail.com>
 <CAKOZuevv_QgvzmusA+yey76vo4hn9bEVwud2RumuOr0K4++15A@mail.gmail.com>
 <CAHk-=wj0o8BiUrYiM5ZcTS6JxBh1M60O36Ms8-EqLQ139=1L4g@mail.gmail.com>
 <20190330171215.3yrfxwodstmgzmxy@brauner.io> <CAHk-=whF6gnRVbJaArZna4e=tejfrzmNQtRbWjnuSSKpBn+jQg@mail.gmail.com>
 <132107F4-F56B-4D6E-9E00-A6F7C092E6BD@amacapital.net> <CAHk-=wiaLtH41Mc5qAjOeCWavPqV0DhS581KYa0QBt8uraTK1Q@mail.gmail.com>
 <20190331211041.vht7dnqg4e4bilr2@brauner.io> <CAHk-=wi3AE1-iRQ_7LOeSMNAMrGxRdC=gTjD30duVw4XRchcNQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAHk-=wi3AE1-iRQ_7LOeSMNAMrGxRdC=gTjD30duVw4XRchcNQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Christian Brauner <christian@brauner.io>, Andy Lutomirski <luto@amacapital.net>, Daniel Colascione <dancol@google.com>, Jann Horn <jannh@google.com>, Andrew Lutomirski <luto@kernel.org>, David Howells <dhowells@redhat.com>, "Serge E. Hallyn" <serge@hallyn.com>, Linux API <linux-api@vger.kernel.org>, Linux List Kernel Mailing <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>, "Eric W. Biederman" <ebiederm@xmission.com>, Konstantin Khlebnikov <khlebnikov@yandex-team.ru>, Kees Cook <keescook@chromium.org>, Alexey Dobriyan <adobriyan@gmail.com>, Thomas Gleixner <tglx@linutronix.de>, Michael Kerrisk-manpages <mtk.manpages@gmail.com>, "Dmitry V. Levin" <ldv@altlinux.org>, Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@re>
List-Id: linux-api@vger.kernel.org

On Sun, Mar 31, 2019 at 10:18 PM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> On Sun, Mar 31, 2019 at 2:10 PM Christian Brauner <christian@brauner.io> wrote:
> >
> > I don't think that we want or can make them equivalent since that would
> > mean we depend on procfs.
>
> Sure we can.
>
> If /proc is enabled, then you always do that dance YOU ALREADY WROTE
> THE CODE FOR to do the stupid ioctl.
>
> And if /procfs isn't enabled, then you don't do that.
>
> Ta-daa. Done. No stupid ioctl, and now /proc and pidfd_open() return
> the same damn thing.

So this is already inherently broken with the /proc filesystem mounted
with hidepid=2. What type of object will it return when CONFIG_PROC_FS
is enabled, but I cannot see anyone's /proc entry except the
processe's running as my own user.

>
> And guess what? If /proc isn't enabled, then obviously pidfd_open()
> gives you the /proc-less thing, but at least there is no crazy "two
> different file descriptors for the same thing" situation, because then
> the /proc one doesn't exist.

There will be when you have no procfs mount for the PID namespace.
What do you return in that case? You run into the problem of two types
of descriptors on the same system.

If you choose to error out, the whole API is useless.

Yes, you can now argue that if I use hidepid=2 and cannot see other
process's /proc entry other than my own user, I wouldn't be able to
kill them anyway, so erroring out is fine, but let's not forget
CAP_KILL.

>
> Notice? No incompatibility. No crazy stupid new "convert one to the
> other", because "the other model" NEVER EXISTS. There is only one
> pidfd - it might be proc-less if CONFIG_PROC isn't there, but let's
> face it, nobody even cares, because nobody ever disabled /proc anyway.

I agree that the ioctl really sucks, but using /proc sucks even further.

Processes have their own namespace, and that is not the filesystem, it
is the PID namespace. As such, pidfd_open should be my open() for an
addressable task I can see in my PID namespace, unrelated to /proc.

Then, processes could pass a pidfd for something in their namespace
*elsewhere*, crossing namespace boundaries, as file descriptors remain
unaffected by that, and subject to kernel permissions, you could
implement some neat communication primitive just through such process
descriptors (which are stable).

It's like the filesystem in some sense, the processes form some
hierarchy, so I should be only be able to open something I can address
in this namespace. It is otherwise a gross layering violation if the
/proc filesystem works like some sort of backdoor to open some
different kind of descriptors pidfd calls accept (and it ends up
working for those I cannot even see).

>
> And no need for some new "convert" interface (ioctl or other).
>
> Problem solved.
>
>                    Linus
