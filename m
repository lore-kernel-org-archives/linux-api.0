From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v2] signal: add procfd_signal() syscall
Date: Sat, 1 Dec 2018 00:15:08 +0100
Message-ID: <CAK8P3a3XRLUsoG0GJ8mkp6LGHRHtVg0eV0RZfrMoPcEgyHcCZA@mail.gmail.com>
References: <20181120105124.14733-1-christian@brauner.io> <87in0g5aqo.fsf@oldenburg.str.redhat.com>
 <36323361-90BD-41AF-AB5B-EE0D7BA02C21@amacapital.net> <993B98AC-51DF-4131-AF7F-7DA2A7F485F1@brauner.io>
 <CALCETrWnQNMQcCmFZrftVVYgAMW6DT3gyxvVb_v9_enUCUkHiw@mail.gmail.com>
 <20181129195551.woe2bl3z3yaysqb6@brauner.io> <6E21165F-2C76-4877-ABD9-0C86D55FD6AA@amacapital.net>
 <CAK8P3a2i9DFaS9-3A9V_pKwFfwVR0bDqgLosmivge3Cx2VyiuQ@mail.gmail.com>
 <87y39b2lm2.fsf@xmission.com> <20181130065606.kmilbbq46oeycjp5@brauner.io>
 <CAK8P3a0kqPii5TwFAo_JHLX=o_FDMFVKXxgzzbDjLFZ7OQ5QCQ@mail.gmail.com>
 <CALCETrW2aphWwEY4=hUwo_JBCvkQyMjxzxGd9FCW017kMLaMOQ@mail.gmail.com>
 <CAK8P3a1isSRCd-OLJK15C+gSJdpeR=zEXghc8+AMM5QYYw3Tyg@mail.gmail.com>
 <EC87B1BE-BDD0-414F-85F8-806C3CC4DD07@brauner.io> <CAKOZuesEPFnkd7YGbu82TRQwhR=KPwNW8GpYTw=719_xmJx9FA@mail.gmail.com>
 <CAK8P3a2x3nQKKvLBSH8G9R6w+sv=09y3h7gWdFYUMNAsB8aj6g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAK8P3a2x3nQKKvLBSH8G9R6w+sv=09y3h7gWdFYUMNAsB8aj6g@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Daniel Colascione <dancol@google.com>
Cc: christian@brauner.io, Andy Lutomirski <luto@kernel.org>, "Eric W . Biederman" <ebiederm@xmission.com>, Florian Weimer <fweimer@redhat.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "Serge E. Hallyn" <serge@hallyn.com>, Jann Horn <jannh@google.com>, Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>, cyphar@cyphar.com, Al Viro <viro@zeniv.linux.org.uk>, Linux FS-devel Mailing List <linux-fsdevel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Tim Murray <timmurray@google.com>, linux-man@vger.kernel.org, Kees Cook <keescook@chromium.org>
List-Id: linux-api@vger.kernel.org

On Sat, Dec 1, 2018 at 12:12 AM Arnd Bergmann <arnd@arndb.de> wrote:
>
> On Sat, Dec 1, 2018 at 12:05 AM Daniel Colascione <dancol@google.com> wrote:
> > On Fri, Nov 30, 2018 at 2:26 PM Christian Brauner <christian@brauner.io> wrote:
> > > On December 1, 2018 11:09:58 AM GMT+13:00, Arnd Bergmann <arnd@arndb.de> wrote:
> > >
> > > One humble point I would like to make is that what I care about most is a sensible way forward without having to redo essential parts of how syscalls work.
> > > I don't want to introduce a sane, small syscall that ends up breaking all over the place because we decided to fix past mistakes that technically have nothing to do with the patch itself.
> > > However, I do sympathize and understand these concerns.
> >
> > IMHO, it's fine to just replicate all the splits we have for the
> > existing signal system calls. It's ugly, but once it's done, it'll be
> > done for a long time. I can't see a need to add even more signal
> > system calls after this one.
>
> We definitely need waitid_time64() and rt_sigtimedwait_time64()
> in the very near future.

To clarify: we probably don't need rt_sigtimedwait_time64() for
x32, as it already has a 64-bit time_t. We might need waitid_time64()
or something similar though, since the plan now is to change the
time resolution for rusage to nanoseconds (__kernel_timespec)
now. The exact behavior and name of waitid_time64() is still
a matter of discussion.

       Arnd
