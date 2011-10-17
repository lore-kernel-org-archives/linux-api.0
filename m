From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH, v10 3/3] cgroups: introduce timer slack controller
Date: Mon, 17 Oct 2011 16:49:29 +0200
Message-ID: <1318862969.4172.45.camel@twins>
References: <1318705910.2664.5.camel@laptop>
	 <20111017013921.GA30035@tango.0pointer.de>
	 <20111017032232.GA4816@srcf.ucam.org> <4E9BBB6D.4050004@linux.intel.com>
	 <1318837019.6594.29.camel@twins> <alpine.LFD.2.02.1110171119580.3240@ionos>
	 <20111017124647.GA12838@srcf.ucam.org> <1318856786.4172.22.camel@twins>
	 <20111017141147.GA14581@srcf.ucam.org> <1318861707.4172.32.camel@twins>
	 <20111017144013.GA15447@srcf.ucam.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20111017144013.GA15447@srcf.ucam.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Matthew Garrett <mjg@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Arjan van de Ven <arjan@linux.intel.com>, Lennart Poettering <mzxreary@0pointer.de>, Andrew Morton <akpm@linux-foundation.org>, "Kirill A. Shutemov" <kirill@shutemov.name>, Paul Menage <menage@google.com>, Li Zefan <lizf@cn.fujitsu.com>, containers@lists.linux-foundation.org, jacob.jun.pan@linux.intel.com, linux-kernel@vger.kernel.org, Matt Helsley <matthltc@us.ibm.com>, linux-api@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>, harald@redhat.com, david@fubar.dk, greg@kroah.com
List-Id: linux-api@vger.kernel.org

On Mon, 2011-10-17 at 15:40 +0100, Matthew Garrett wrote:
> On Mon, Oct 17, 2011 at 04:28:27PM +0200, Peter Zijlstra wrote:
> > On Mon, 2011-10-17 at 15:11 +0100, Matthew Garrett wrote:
> > > Whether or not you want the animation to carry on animating is policy, 
> > > and you need something to be the policy agent. Let's say firefox is 
> > > invisible. I now grab a copy of its window contents. What do I get?
> > 
> > An XDamage and repaint from the X client, after which your copy will
> > complete and you get what you asked for?
> 
> An XDamage and then an asynchronous RPC call to the remote server to 
> identify the contents of the next frame before drawing them, plus some 
> sort of new synchronisation mechanism for blocking the X query until 
> that point?

Why would this be a problem? 

I mean, why would getting a copy of an otherwise invisible surface be a
performance sensitive path? If the compositor needs the surface it would
make it visible and send the XDamage once and keep it visible henceforth
until the time it again becomes invisible, at which point you have to
stop updates again.

The normal case is where things are visible and things are kept
up-to-date, that doesn't change.

> > >  in preference to merging a piece 
> > > of code that's functionally consistent with the rest of the cgroups 
> > > infrastructure?
> > 
> > Yep.. because as of yet there isn't a sane use-case to warrant adding
> > the maintenance burden. Any cgroup controller is functionally
> > consistent, per definition, that doesn't make it useful or even sane.
> 
> Timers are a resource. People want to manage that resource. cgroups are 
> a convenient mechanism for managing resources.

Yes, and a ball is round (unless you're a USA-ian, in which case they're
ovoid), what's your point?
