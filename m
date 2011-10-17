From: Matthew Garrett <mjg@redhat.com>
Subject: Re: [PATCH, v10 3/3] cgroups: introduce timer slack controller
Date: Mon, 17 Oct 2011 15:11:47 +0100
Message-ID: <20111017141147.GA14581@srcf.ucam.org>
References: <20111014154348.ae6267aa.akpm@linux-foundation.org>
 <20111015112006.GA10173@tango.0pointer.de>
 <1318705910.2664.5.camel@laptop>
 <20111017013921.GA30035@tango.0pointer.de>
 <20111017032232.GA4816@srcf.ucam.org>
 <4E9BBB6D.4050004@linux.intel.com>
 <1318837019.6594.29.camel@twins>
 <alpine.LFD.2.02.1110171119580.3240@ionos>
 <20111017124647.GA12838@srcf.ucam.org>
 <1318856786.4172.22.camel@twins>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1318856786.4172.22.camel@twins>
Sender: linux-kernel-owner@vger.kernel.org
To: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Arjan van de Ven <arjan@linux.intel.com>, Lennart Poettering <mzxreary@0pointer.de>, Andrew Morton <akpm@linux-foundation.org>, "Kirill A. Shutemov" <kirill@shutemov.name>, Paul Menage <menage@google.com>, Li Zefan <lizf@cn.fujitsu.com>, containers@lists.linux-foundation.org, jacob.jun.pan@linux.intel.com, linux-kernel@vger.kernel.org, Matt Helsley <matthltc@us.ibm.com>, linux-api@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>, harald@redhat.com, david@fubar.dk, greg@kroah.com
List-Id: linux-api@vger.kernel.org

On Mon, Oct 17, 2011 at 03:06:26PM +0200, Peter Zijlstra wrote:
> On Mon, 2011-10-17 at 13:46 +0100, Matthew Garrett wrote:
> > They're orthogonal. Sometimes you want timer-driven behaviour (how else 
> > are you going to draw animations?) and that's obviously going to 
> > generate wakeups. This is for the idle case, where the user is no longer 
> > sitting in front of the machine but you don't want to trigger a full 
> > system suspend. We either need every application that ever uses 
> > timer-driven behaviour to support setting its own timer slack on some 
> > sort of external policy decision, or we need a way to let the kernel 
> > force them to.
> 
> No!! you want that application to stop drawing stuff that is invisible.
> Setting your own timerslack for something you know is pointless is worse
> than doing something pointless, its down right stupid.

Whether or not you want the animation to carry on animating is policy, 
and you need something to be the policy agent. Let's say firefox is 
invisible. I now grab a copy of its window contents. What do I get?

> Please, work with the X folks and make it an error to draw to invisible
> surfaces. And yes, I know that composition makes that a non-trivial
> problem. But at least the blank screen case should be trivial, and I
> suspect there's more tractable cases as well. Mostly the desktop is
> still a very static place and a few extra timer ticks for when you're
> spinning your desktop cube around isn't going to be a problem.

So, just to be clear on this, you want to change the semantics of X and 
modify every piece of userspace that currently uses X (because it'll now 
otherwise crash when the screen blanks) in preference to merging a piece 
of code that's functionally consistent with the rest of the cgroups 
infrastructure?

-- 
Matthew Garrett | mjg59@srcf.ucam.org
