From: Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>
Subject: Re: [Ksummit-discuss] [MAINTAINERS SUMMIT] & [TECH TOPIC] Improve
 regression tracking
Date: Wed, 5 Jul 2017 11:43:16 -0400
Message-ID: <20170705114316.424a9e28@gandalf.local.home>
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
        <20170705112047.23ee09f6@gandalf.local.home>
        <1499268748.3668.20.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1499268748.3668.20.camel-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Cc: Carlos O'Donell <carlos-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, ksummit-discuss-cunTk1MwBs98uUxBSJOaYoYkZiVZrdSR2LY78lusg7I@public.gmane.org, Thorsten Leemhuis <linux-rCxcAJFjeRkk+I/owrrOrA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Wed, 05 Jul 2017 08:32:28 -0700
James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org> wrote:


> > openSuSE has it enabled? I hope not for its production config, as
> > lockdep has a huge performance penalty.  
> 
> Then, surely, it's the last thing we want when tracking down race
> conditgions since it will alter timings dramatically.

It's to be run when you want to make sure locking order is at least not
an issue. And it's not about running when tracking down race
conditions, its to be run when developing new code.


> 
> > I'm thinking you don't have it enabled. What config are you looking
> > at? The actual config that does the testing of locks is
> > CONFIG_PROVE_LOCKING, which selects LOCKDEP to be compiled in.  
> 
> This is what it has:
> 
> jejb@jarvis:~/git/linux-build> grep LOCKDEP /boot/config-4.4.73-18.17-default 
> CONFIG_LOCKDEP_SUPPORT=y

That means your architecture supports it, it's not enabled.

-- Steve
