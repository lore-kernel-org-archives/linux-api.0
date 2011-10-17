From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH, v10 3/3] cgroups: introduce timer slack controller
Date: Mon, 17 Oct 2011 17:11:00 +0200
Message-ID: <1318864260.4172.54.camel@twins>
References: <20111017032232.GA4816@srcf.ucam.org>
	 <4E9BBB6D.4050004@linux.intel.com> <1318837019.6594.29.camel@twins>
	 <alpine.LFD.2.02.1110171119580.3240@ionos>
	 <20111017124647.GA12838@srcf.ucam.org> <1318856786.4172.22.camel@twins>
	 <20111017141147.GA14581@srcf.ucam.org> <1318861707.4172.32.camel@twins>
	 <20111017144013.GA15447@srcf.ucam.org> <1318862969.4172.45.camel@twins>
	 <20111017145952.GB15769@srcf.ucam.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20111017145952.GB15769@srcf.ucam.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Matthew Garrett <mjg@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Arjan van de Ven <arjan@linux.intel.com>, Lennart Poettering <mzxreary@0pointer.de>, Andrew Morton <akpm@linux-foundation.org>, "Kirill A. Shutemov" <kirill@shutemov.name>, Paul Menage <menage@google.com>, Li Zefan <lizf@cn.fujitsu.com>, containers@lists.linux-foundation.org, jacob.jun.pan@linux.intel.com, linux-kernel@vger.kernel.org, Matt Helsley <matthltc@us.ibm.com>, linux-api@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>, harald@redhat.com, david@fubar.dk, greg@kroah.com
List-Id: linux-api@vger.kernel.org

On Mon, 2011-10-17 at 15:59 +0100, Matthew Garrett wrote:
> On Mon, Oct 17, 2011 at 04:49:29PM +0200, Peter Zijlstra wrote:
> > On Mon, 2011-10-17 at 15:40 +0100, Matthew Garrett wrote:
> > > On Mon, Oct 17, 2011 at 04:28:27PM +0200, Peter Zijlstra wrote:
> > > > An XDamage and repaint from the X client, after which your copy will
> > > > complete and you get what you asked for?
> > > 
> > > An XDamage and then an asynchronous RPC call to the remote server to 
> > > identify the contents of the next frame before drawing them, plus some 
> > > sort of new synchronisation mechanism for blocking the X query until 
> > > that point?
> > 
> > Why would this be a problem? 
> > 
> > I mean, why would getting a copy of an otherwise invisible surface be a
> > performance sensitive path? If the compositor needs the surface it would
> > make it visible and send the XDamage once and keep it visible henceforth
> > until the time it again becomes invisible, at which point you have to
> > stop updates again.
> 
> I'm not saying that it's a problem. I'm saying that your approach 
> changes behavioural semantics in a way that may violate application 
> expectations just as surely as changing the timer behaviour does. 
> There's no free approach.

I'm not saying its free, I'm saying its a much better approach since it
gets rid of the entire problem instead of papering over the worst of it.

> > > Timers are a resource. People want to manage that resource. cgroups are 
> > > a convenient mechanism for managing resources.
> > 
> > Yes, and a ball is round (unless you're a USA-ian, in which case they're
> > ovoid), what's your point?
> 
> If there's no reason to want to manage that resource, why do we support 
> timer slack at all?

So that individual applications can provide their timing tolerance and
the OS can group these timers in order to optimize idle time or whatnot.

Indiscriminately changing the slack for a whole group of otherwise
unrelated applications will violate their timing tolerances and break
them in non-obvious ways.


  
What I'm saying is that its much better to attack the primary source of
evil in a manner that is unforgiving instead of trying to avoid the
worst excesses and cause non-obvious breakage.

For a while people were promoting the idea that its good to be lenient
in what you accept as input and strict in what you send out. I think
people are starting to realize that was a horrid mistake since now
they're getting utter crap and people don't even know what right is
anymore.
