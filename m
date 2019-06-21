From: Matthew Garrett <mjg59@google.com>
Subject: Re: [PATCH V33 01/30] security: Support early LSMs
Date: Fri, 21 Jun 2019 12:27:46 -0700
Message-ID: <CACdnJusxhsYenacOEJkDXqVC13qoEd5eNXDgxWT_x8tz4bV5cQ@mail.gmail.com>
References: <20190621011941.186255-1-matthewgarrett@google.com>
 <20190621011941.186255-2-matthewgarrett@google.com> <CALCETrX87W4FE1xHF_W4=Do25Ci=LJxnvxNHMs9CTOFo4988aw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CALCETrX87W4FE1xHF_W4=Do25Ci=LJxnvxNHMs9CTOFo4988aw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@kernel.org>
Cc: James Morris <jmorris@namei.org>, linux-security@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Thu, Jun 20, 2019 at 10:23 PM Andy Lutomirski <luto@kernel.org> wrote:
>
> On Thu, Jun 20, 2019 at 6:22 PM Matthew Garrett
> <matthewgarrett@google.com> wrote:
> >
> > The lockdown module is intended to allow for kernels to be locked down
> > early in boot - sufficiently early that we don't have the ability to
> > kmalloc() yet. Add support for early initialisation of some LSMs, and
> > then add them to the list of names when we do full initialisation later.
>
> I'm confused.  What does it even mean to lock down the kernel before
> we're ready to run userspace code?  We can't possibly be attacked by
> user code before there is any to attack us.

Certain kernel parameters can be disabled by lockdown, so we want to
have policy available before that parsing happens.
