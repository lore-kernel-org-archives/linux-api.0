From: Andy Lutomirski <luto@kernel.org>
Subject: Re: [PATCH V33 01/30] security: Support early LSMs
Date: Thu, 20 Jun 2019 22:23:44 -0700
Message-ID: <CALCETrX87W4FE1xHF_W4=Do25Ci=LJxnvxNHMs9CTOFo4988aw@mail.gmail.com>
References: <20190621011941.186255-1-matthewgarrett@google.com> <20190621011941.186255-2-matthewgarrett@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190621011941.186255-2-matthewgarrett@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Matthew Garrett <matthewgarrett@google.com>
Cc: James Morris <jmorris@namei.org>, linux-security@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Matthew Garrett <mjg59@google.com>
List-Id: linux-api@vger.kernel.org

On Thu, Jun 20, 2019 at 6:22 PM Matthew Garrett
<matthewgarrett@google.com> wrote:
>
> The lockdown module is intended to allow for kernels to be locked down
> early in boot - sufficiently early that we don't have the ability to
> kmalloc() yet. Add support for early initialisation of some LSMs, and
> then add them to the list of names when we do full initialisation later.

I'm confused.  What does it even mean to lock down the kernel before
we're ready to run userspace code?  We can't possibly be attacked by
user code before there is any to attack us.

Am I missing something here?

--Andy
