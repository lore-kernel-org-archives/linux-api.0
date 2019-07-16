From: Matthew Garrett <mjg59@google.com>
Subject: Re: [PATCH V35 27/29] tracefs: Restrict tracefs when the kernel is
 locked down
Date: Tue, 16 Jul 2019 16:22:38 -0700
Message-ID: <CACdnJut3FDAqpELYOicR9-tYCF+G_213J0nGJHeR5EPqXqToVg@mail.gmail.com>
References: <20190715195946.223443-1-matthewgarrett@google.com>
 <20190715195946.223443-28-matthewgarrett@google.com> <20190716191439.59a1ac32@gandalf.local.home>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190716191439.59a1ac32@gandalf.local.home>
Sender: linux-kernel-owner@vger.kernel.org
To: Steven Rostedt <rostedt@goodmis.org>
Cc: James Morris <jmorris@namei.org>, LSM List <linux-security-module@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Tue, Jul 16, 2019 at 4:14 PM Steven Rostedt <rostedt@goodmis.org> wrote:
> Small nit, but please add this as the first declaration, to keep the
> "upside-down x-mas tree" look. I know some of the other functions in
> this file don't follow that (which should be cleaned up some day), but
> I'd like to avoid adding more that breaks the aesthetic of the code.

ACK.

> > +
> > +     if (fops)
>
> I think you meant "if (!fops)".

Blink. Whoops! Yup.
