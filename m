From: James Morris <jmorris@namei.org>
Subject: Re: [PATCH V37 04/29] Enforce module signatures if the kernel is
 locked down
Date: Fri, 9 Aug 2019 08:43:05 +1000 (AEST)
Message-ID: <alpine.LRH.2.21.1908090842390.14740@namei.org>
References: <20190731221617.234725-1-matthewgarrett@google.com> <20190731221617.234725-5-matthewgarrett@google.com> <20190801142157.GA5834@linux-8ccs> <CACdnJusD_9W9tFqwKptDTA8fZU8HrSvsEQhKo0WS9QxLpgz5tA@mail.gmail.com> <20190808100059.GA30260@linux-8ccs>
 <CACdnJuu6gFQUQQOVj2MwL5+dx+XsBKY=Uq58r7F8Lr2C0Gi_TA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CACdnJuu6gFQUQQOVj2MwL5+dx+XsBKY=Uq58r7F8Lr2C0Gi_TA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Matthew Garrett <mjg59@google.com>
Cc: Jessica Yu <jeyu@kernel.org>, LSM List <linux-security-module@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, David Howells <dhowells@redhat.com>, Kees Cook <keescook@chromium.org>
List-Id: linux-api@vger.kernel.org

On Thu, 8 Aug 2019, Matthew Garrett wrote:

> On Thu, Aug 8, 2019 at 3:01 AM Jessica Yu <jeyu@kernel.org> wrote:
> > If you're confident that a hard dependency is not the right approach,
> > then perhaps we could add a comment in the Kconfig (You could take a
> > look at the comment under MODULE_SIG_ALL in init/Kconfig for an
> > example)? If someone is configuring the kernel on their own then it'd
> > be nice to let them know, otherwise having a lockdown kernel without
> > module signatures would defeat the purpose of lockdown no? :-)
> 
> James, what would your preference be here? Jessica is right that not
> having CONFIG_MODULE_SIG enabled means lockdown probably doesn't work
> as expected, but tying it to the lockdown LSM seems inappropriate when
> another LSM could be providing lockdown policy and run into the same
> issue. Should this just be mentioned in the CONFIG_MODULE_SIG Kconfig
> help?

I agree and yes mention it in the help.  A respin of just this patch is 
fine.

-- 
James Morris
<jmorris@namei.org>
