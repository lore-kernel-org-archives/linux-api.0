From: Matthew Garrett <mjg59@google.com>
Subject: Re: [PATCH V40 04/29] lockdown: Enforce module signatures if the
 kernel is locked down
Date: Wed, 4 Sep 2019 09:57:52 -0700
Message-ID: <CACdnJuuTRQM9SQvLMqW+C=6ukQPpvkwqFZ6U+wnL4uYxcG14Ww@mail.gmail.com>
References: <20190820001805.241928-1-matthewgarrett@google.com>
 <20190820001805.241928-5-matthewgarrett@google.com> <3638.1567182673@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <3638.1567182673@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: James Morris <jmorris@namei.org>, LSM List <linux-security-module@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Kees Cook <keescook@chromium.org>, Jessica Yu <jeyu@kernel.org>
List-Id: linux-api@vger.kernel.org

On Fri, Aug 30, 2019 at 9:31 AM David Howells <dhowells@redhat.com> wrote:
>
> Matthew Garrett <matthewgarrett@google.com> wrote:
>
> >  enum lockdown_reason {
> >       LOCKDOWN_NONE,
> > +     LOCKDOWN_MODULE_SIGNATURE,
> >       LOCKDOWN_INTEGRITY_MAX,
> >       LOCKDOWN_CONFIDENTIALITY_MAX,
> >  };
>
> Aren't you mixing disjoint sets?

The goal is to be able to check whether any given lockdown reason is a
matter of integrity or confidentiality in a straightforward way.

> > +     [LOCKDOWN_MODULE_SIGNATURE] = "unsigned module loading",
>
> Wouldn't it be better to pass this string as a parameter to
> security_locked_down()?

I thought about that, but it's not how any other LSM hooks behave. I
think it's probably easier to revisit that when we see how other LSMs
want to make use of the data.
