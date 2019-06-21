From: Matthew Garrett <mjg59@google.com>
Subject: Re: [PATCH V33 03/30] security: Add a static lockdown policy LSM
Date: Fri, 21 Jun 2019 12:37:36 -0700
Message-ID: <CACdnJut_C_h2JjryDxEm9U_rpSJFkVyxq3iCW9=AhwcdVig=9g@mail.gmail.com>
References: <20190621011941.186255-1-matthewgarrett@google.com>
 <20190621011941.186255-4-matthewgarrett@google.com> <201906202028.5AB58C3@keescook>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <201906202028.5AB58C3@keescook>
Sender: linux-kernel-owner@vger.kernel.org
To: Kees Cook <keescook@chromium.org>
Cc: James Morris <jmorris@namei.org>, linux-security@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, David Howells <dhowells@redhat.com>
List-Id: linux-api@vger.kernel.org

On Thu, Jun 20, 2019 at 8:44 PM Kees Cook <keescook@chromium.org> wrote:
>
> On Thu, Jun 20, 2019 at 06:19:14PM -0700, Matthew Garrett wrote:
> > +/*
> > + *  If you add to this, remember to extend lockdown_reasons in
> > + *  security/lockdown/lockdown.c.
> > + */
>
> Best to add something like:
>
> BUILD_BUG_ON(ARRAY_SIZE(lockdown_reasons), LOCKDOWN_CONFIDENTIALLY_MAX);
>
> to actually enforce this.

I don't think this will work - it'll only catch cases where someone
adds a new enum after LOCKDOWN_CONFIDENTIALITY_MAX.

> >  enum lockdown_reason {
> >       LOCKDOWN_NONE,
> >       LOCKDOWN_INTEGRITY_MAX,
> > diff --git a/security/Kconfig b/security/Kconfig
> > index 1d6463fb1450..c35aa72103df 100644
> > --- a/security/Kconfig
> > +++ b/security/Kconfig
> > @@ -236,12 +236,13 @@ source "security/apparmor/Kconfig"
> >  source "security/loadpin/Kconfig"
> >  source "security/yama/Kconfig"
> >  source "security/safesetid/Kconfig"
> > +source "security/lockdown/Kconfig"
> >
> >  source "security/integrity/Kconfig"
> >
> >  config LSM
> >       string "Ordered list of enabled LSMs"
> > -     default "yama,loadpin,safesetid,integrity,selinux,smack,tomoyo,apparmor"
> > +     default "lockdown,yama,loadpin,safesetid,integrity,selinux,smack,tomoyo,apparmor"
>
> Is this needed? It seems like the early LSMs are totally ignored for
> ordering?

It's relevant if it's not configured as an early LSM.

> > +config SECURITY_LOCKDOWN_LSM
> > +     bool "Basic module for enforcing kernel lockdown"
> > +     depends on SECURITY
> > +     help
> > +       Build support for an LSM that enforces a coarse kernel lockdown
> > +       behaviour.
> > +
> > +config SECURITY_LOCKDOWN_LSM_EARLY
> > +        bool "Enable lockdown LSM early in init"
>
> whitespace glitches?

Fxied.

> > +static enum lockdown_reason kernel_locked_down;
>
> What's the use-case for runtime changing this value? (If you didn't, you
> could make it __ro_after_init.)

Cases where the admin wants to make the policy more strict after boot
via securityfs.

> > +     for (i = 0; i < ARRAY_SIZE(lockdown_levels); i++) {
> > +             enum lockdown_reason level = lockdown_levels[i];
> > +
> > +             if (lockdown_reasons[level]) {
> > +                     const char *label = lockdown_reasons[level];
> > +
> > +                     if (kernel_locked_down == level)
> > +                             offset += sprintf(temp+offset, "[%s] ", label);
> > +                     else
> > +                             offset += sprintf(temp+offset, "%s ", label);
> > +             }
> > +     }
>
> I thought there were helpers for this kind of thing?

I'll check, I'm bad at finding these new fangled things.

> Ah, I see now: it *might* be an early LSM. What states are missed if not
> early? Only parameters? I think the behavior differences need to be
> spelled out in Kconfig (or somewhere...)

Ok.
