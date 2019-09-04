From: Matthew Garrett <mjg59@google.com>
Subject: Re: [PATCH V40 03/29] security: Add a static lockdown policy LSM
Date: Wed, 4 Sep 2019 09:51:16 -0700
Message-ID: <CACdnJuvR7mqhpzEQZdgw9EE_PsM-QWQ_JmwFLcoeLbAuKCHnOA@mail.gmail.com>
References: <20190820001805.241928-1-matthewgarrett@google.com>
 <20190820001805.241928-4-matthewgarrett@google.com> <3440.1567182506@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <3440.1567182506@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: James Morris <jmorris@namei.org>, LSM List <linux-security-module@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Kees Cook <keescook@chromium.org>
List-Id: linux-api@vger.kernel.org

On Fri, Aug 30, 2019 at 9:28 AM David Howells <dhowells@redhat.com> wrote:
>
> Matthew Garrett <matthewgarrett@google.com> wrote:
>
> > +static char *lockdown_reasons[LOCKDOWN_CONFIDENTIALITY_MAX+1] = {
>
> const char *const maybe?

Seems reasonable.

> > +static enum lockdown_reason lockdown_levels[] = {LOCKDOWN_NONE,
> > +                                              LOCKDOWN_INTEGRITY_MAX,
> > +                                              LOCKDOWN_CONFIDENTIALITY_MAX};
> > +
>
> const?
>
> Isn't this also a 1:1 mapping?

Sorry, a 1:1 mapping to what?

> > +static int lock_kernel_down(const char *where, enum lockdown_reason level)
>
> Is the last parameter the reason or the level?  You're mixing the terms.

Fair.
