From: Matthew Garrett <mjg59@google.com>
Subject: Re: [PATCH V33 01/30] security: Support early LSMs
Date: Fri, 21 Jun 2019 12:26:51 -0700
Message-ID: <CACdnJuu5SvLndNs9GBm724wLOz+QFuu3agbH4Prndt9LG=Xcbw@mail.gmail.com>
References: <20190621011941.186255-1-matthewgarrett@google.com>
 <20190621011941.186255-2-matthewgarrett@google.com> <201906202010.49D16E03@keescook>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <201906202010.49D16E03@keescook>
Sender: linux-kernel-owner@vger.kernel.org
To: Kees Cook <keescook@chromium.org>
Cc: James Morris <jmorris@namei.org>, linux-security@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Thu, Jun 20, 2019 at 8:22 PM Kees Cook <keescook@chromium.org> wrote:
>
> On Thu, Jun 20, 2019 at 06:19:12PM -0700, Matthew Garrett wrote:
> > The lockdown module is intended to allow for kernels to be locked down
> > early in boot - sufficiently early that we don't have the ability to
> > kmalloc() yet. Add support for early initialisation of some LSMs, and
> > then add them to the list of names when we do full initialisation later.
>
> So, if I'm reading correctly, these "early LSMs":
>
> - start up before even boot parameter parsing has happened
> - have their position in the LSM ordering ignored
> - are initialized in boot order
> - cannot use kmalloc, as well as probably lots of other things

Accurate. I've expanded the description.

> >       pr_info("Security Framework initializing\n");
>
> I'd rather this was kept in security_init() since it's the string to
> search for when debugging normal LSM initialization.

Ok.

> >
> > @@ -343,6 +342,30 @@ int __init security_init(void)
> >            i++)
> >               INIT_HLIST_HEAD(&list[i]);
> >
> > +     for (lsm = __start_early_lsm_info; lsm < __end_early_lsm_info; lsm++) {
> > +             if (!lsm->enabled)
> > +                     lsm->enabled = &lsm_enabled_true;
> > +             initialize_lsm(lsm);
> > +     }
>
> This should call prepare_lsm() before initialize_lsm(). While not needed
> for this specific LSM, it would be nice to at least do the blog size
> calculations and keep everything the same as other LSMs.

Ok.

> > +
> > +     return 0;
> > +}
> > +
> > +/**
> > + * security_init - initializes the security framework
> > + *
> > + * This should be called early in the kernel initialization sequence.
> > + */
> > +int __init security_init(void)
> > +{
> > +     struct lsm_info *lsm;
> > +
> > +     /* Append the names of the early LSM modules now */
>
> I would clarify this comment more: "... that kmalloc() is available."

Ok,
