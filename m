From: Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>
Subject: Re: [Ksummit-discuss] [MAINTAINERS SUMMIT] & [TECH TOPIC] Improve
 regression tracking
Date: Wed, 5 Jul 2017 11:20:47 -0400
Message-ID: <20170705112047.23ee09f6@gandalf.local.home>
References: <576cea07-770a-4864-c3f5-0832ff211e94@leemhuis.info>
        <20170703123025.7479702e@gandalf.local.home>
        <ad94dc65-cc9c-f4f1-27c1-5a48603c7f59@leemhuis.info>
        <20170705084528.67499f8c@gandalf.local.home>
        <4080ecc7-1aa8-2940-f230-1b79d656cdb4@redhat.com>
        <20170705092757.63dc2328@gandalf.local.home>
        <20170705140607.GA30187@kroah.com>
        <20170705143341.oees22k2snhtmkxo@sirena.org.uk>
        <20170705103658.226099c6@gandalf.local.home>
        <1499266228.3668.10.camel@HansenPartnership.com>
        <20170705105651.5da9c969@gandalf.local.home>
        <1499267389.3668.16.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1499267389.3668.16.camel-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Cc: ksummit-discuss-cunTk1MwBs98uUxBSJOaYoYkZiVZrdSR2LY78lusg7I@public.gmane.org, Carlos O'Donell <carlos-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, Thorsten Leemhuis <linux-rCxcAJFjeRkk+I/owrrOrA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Wed, 05 Jul 2017 08:09:49 -0700
James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org> wrote:

 
> > > you're protecting was accessed outside the lock, which is the usual
> > > source of concurrency problems.  In other words lockdep is useful
> > > but it's not a panacea.  
> > 
> > Still not an excuse to not have lockdep enabled during tests.  
> 
> OK, what makes you think lockdep isn't enabled?  Since Kconfig is so
> complex, I usually use a distro config ... they have it enabled (or at
> least openSUSE does), so it's enabled for everything I do.

openSuSE has it enabled? I hope not for its production config, as
lockdep has a huge performance penalty.

I'm thinking you don't have it enabled. What config are you looking at?
The actual config that does the testing of locks is
CONFIG_PROVE_LOCKING, which selects LOCKDEP to be compiled in.

-- Steve
