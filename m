From: Christian Brauner <christian@brauner.io>
Subject: Re: [PATCH v2 0/5] pid: add pidfd_open()
Date: Mon, 1 Apr 2019 14:04:52 +0200
Message-ID: <20190401120450.e4k2m434qyqj4yrn@brauner.io>
References: <CAHk-=whcA0kAWGqet9oJdyttjhP7J4PcU2Ly=n_Qyo6rMJNxRg@mail.gmail.com>
 <CAKOZuevv_QgvzmusA+yey76vo4hn9bEVwud2RumuOr0K4++15A@mail.gmail.com>
 <CAHk-=wj0o8BiUrYiM5ZcTS6JxBh1M60O36Ms8-EqLQ139=1L4g@mail.gmail.com>
 <20190330171215.3yrfxwodstmgzmxy@brauner.io>
 <CAHk-=whF6gnRVbJaArZna4e=tejfrzmNQtRbWjnuSSKpBn+jQg@mail.gmail.com>
 <132107F4-F56B-4D6E-9E00-A6F7C092E6BD@amacapital.net>
 <CAHk-=wiaLtH41Mc5qAjOeCWavPqV0DhS581KYa0QBt8uraTK1Q@mail.gmail.com>
 <20190331211041.vht7dnqg4e4bilr2@brauner.io>
 <CAHk-=wi3AE1-iRQ_7LOeSMNAMrGxRdC=gTjD30duVw4XRchcNQ@mail.gmail.com>
 <18C7FCB9-2CBA-4237-94BB-9C4395A2106B@amacapital.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <18C7FCB9-2CBA-4237-94BB-9C4395A2106B@amacapital.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@amacapital.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Daniel Colascione <dancol@google.com>, Jann Horn <jannh@google.com>, Andrew Lutomirski <luto@kernel.org>, David Howells <dhowells@redhat.com>, "Serge E. Hallyn" <serge@hallyn.com>, Linux API <linux-api@vger.kernel.org>, Linux List Kernel Mailing <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>, "Eric W. Biederman" <ebiederm@xmission.com>, Konstantin Khlebnikov <khlebnikov@yandex-team.ru>, Kees Cook <keescook@chromium.org>, Alexey Dobriyan <adobriyan@gmail.com>, Thomas Gleixner <tglx@linutronix.de>, Michael Kerrisk-manpages <mtk.manpages@gmail.com>, Jonathan Kowalski <bl0pbl33p@gmail.com>, "Dmitry V. Levin" <ldv@altlinux.org>, Andrew Morton <akpm@linux-foundation.org>, Oleg
List-Id: linux-api@vger.kernel.org

On Sun, Mar 31, 2019 at 08:13:38PM -0600, Andy Lutomirski wrote:
> 
> 
> > On Mar 31, 2019, at 3:17 PM, Linus Torvalds <torvalds@linux-foundation.org> wrote:
> > 
> >> On Sun, Mar 31, 2019 at 2:10 PM Christian Brauner <christian@brauner.io> wrote:
> >> 
> >> I don't think that we want or can make them equivalent since that would
> >> mean we depend on procfs.
> > 
> > Sure we can.
> > 
> > If /proc is enabled, then you always do that dance YOU ALREADY WROTE
> > THE CODE FOR to do the stupid ioctl.
> > 
> > And if /procfs isn't enabled, then you don't do that.
> > 
> > Ta-daa. Done. No stupid ioctl, and now /proc and pidfd_open() return
> > the same damn thing.
> > 
> > And guess what? If /proc isn't enabled, then obviously pidfd_open()
> > gives you the /proc-less thing, but at least there is no crazy "two
> > different file descriptors for the same thing" situation, because then
> > the /proc one doesn't exist.
> > 
> 
> I wish we could do this, and, in a clean design, it would be a no-brainer.  But /proc has too much baggage.  Just to mention two such things, there’s “net” and “../sys”.  This crud is why we have all kinds of crazy rules that prevent programs in sandboxes from making a new mounts and mounting /proc in it.  If we make it possible to clone a new process and this access /proc without having /proc mounted, we’ll open up a big can of worms.
> 
> Maybe we could have a sanitized view of /proc and make a pidfd be a directory fd pointing at that.

We can also just create something like an internal bind-mount without a
parent, i.e. similar to

open_tree(<internal-procfs-mount>, "<pid>", OPEN_TREE_CLONE);

on a clone(CLONE_PIDFD);

that would block any openat(fd, "..");
