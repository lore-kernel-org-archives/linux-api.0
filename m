From: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Subject: Re: [Ksummit-discuss] [MAINTAINERS SUMMIT] & [TECH TOPIC] Improve
 regression tracking
Date: Wed, 05 Jul 2017 07:50:28 -0700
Message-ID: <1499266228.3668.10.camel@HansenPartnership.com>
References: <576cea07-770a-4864-c3f5-0832ff211e94@leemhuis.info>
         <20170703123025.7479702e@gandalf.local.home>
         <ad94dc65-cc9c-f4f1-27c1-5a48603c7f59@leemhuis.info>
         <20170705084528.67499f8c@gandalf.local.home>
         <4080ecc7-1aa8-2940-f230-1b79d656cdb4@redhat.com>
         <20170705092757.63dc2328@gandalf.local.home>
         <20170705140607.GA30187@kroah.com>
         <20170705143341.oees22k2snhtmkxo@sirena.org.uk>
         <20170705103658.226099c6@gandalf.local.home>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170705103658.226099c6-f9ZlEuEWxVcJvu8Pb33WZ0EMvNT87kid@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Mark Brown <broonie-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: ksummit-discuss-cunTk1MwBs98uUxBSJOaYoYkZiVZrdSR2LY78lusg7I@public.gmane.org, Carlos O'Donell <carlos-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, Thorsten Leemhuis <linux-rCxcAJFjeRkk+I/owrrOrA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Wed, 2017-07-05 at 10:36 -0400, Steven Rostedt wrote:
> On Wed, 5 Jul 2017 15:33:41 +0100
> Mark Brown <broonie-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> 
> > 
> > On Wed, Jul 05, 2017 at 04:06:07PM +0200, Greg KH wrote:
> > 
> > > 
> > > I don't mean to poo-poo the idea, but please realize that around
> > > 75% of the kernel is hardware/arch support, so that means that
> > > 75% of the changes/fixes deal with hardware things (yes, change
> > > is in direct correlation to size of the codebase in the tree,
> > > strange but true).  
> > 
> > Then add in all the fixes for concurrency/locking issues and so on
> > that're hard to reliably reproduce as well...
> 
> All tests should be run with lockdep enabled ;-)  Which a surprising
> few developers appear to do :-p

Lockdep checks the locking hierarchies and makes assumptions about them
which it then validates ... it doesn't tell you if the data you think
you're protecting was accessed outside the lock, which is the usual
source of concurrency problems.  In other words lockdep is useful but
it's not a panacea.

James
