From: Matthew Garrett <mjg59@google.com>
Subject: Re: [PATCH V40 03/29] security: Add a static lockdown policy LSM
Date: Tue, 10 Sep 2019 06:06:17 -0400
Message-ID: <CACdnJuvfJ-L-3a5PVL+fWi6XwKb7EBONG8jEwbR=uHkA3wcxOQ@mail.gmail.com>
References: <20190820001805.241928-1-matthewgarrett@google.com>
 <20190820001805.241928-4-matthewgarrett@google.com> <3440.1567182506@warthog.procyon.org.uk>
 <CACdnJuvR7mqhpzEQZdgw9EE_PsM-QWQ_JmwFLcoeLbAuKCHnOA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CACdnJuvR7mqhpzEQZdgw9EE_PsM-QWQ_JmwFLcoeLbAuKCHnOA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: James Morris <jmorris@namei.org>, LSM List <linux-security-module@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Kees Cook <keescook@chromium.org>
List-Id: linux-api@vger.kernel.org

On Wed, Sep 4, 2019 at 12:51 PM Matthew Garrett <mjg59@google.com> wrote:
> On Fri, Aug 30, 2019 at 9:28 AM David Howells <dhowells@redhat.com> wrote:
> > > +static int lock_kernel_down(const char *where, enum lockdown_reason level)
> >
> > Is the last parameter the reason or the level?  You're mixing the terms.
>
> Fair.

Actually, on re-reading, I think this correct - this is setting the
lockdown level, it's just that the lockdown level is an enum
lockdown_reason for the sake of convenience.
