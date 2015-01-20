From: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Subject: Re: [PATCH v3 00/13] Add kdbus implementation
Date: Tue, 20 Jan 2015 09:13:59 +0800
Message-ID: <20150120011359.GE865@kroah.com>
References: <1421435777-25306-1-git-send-email-gregkh@linuxfoundation.org>
 <20150119180642.GA27957@sig21.net>
 <20150119183806.GA8479@kroah.com>
 <20150119201906.GA337@sig21.net>
 <20150119203155.GA15441@kroah.com>
 <20150119233812.GA1874@sig21.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150119233812.GA1874-FF7aIK3TAVNeoWH0uzbU5w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Johannes Stezenbach <js-FF7aIK3TAVNeoWH0uzbU5w@public.gmane.org>
Cc: arnd-r2nGTMty4D4@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, gnomes-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org, teg-B22kvLQNl6c@public.gmane.org, jkosina-AlSwsSmVLrQ@public.gmane.org, luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, daniel-cYrQPVfZoowdnm+yROfE0A@public.gmane.org, dh.herrmann-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, tixxdz-Umm1ozX2/EEdnm+yROfE0A@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Tue, Jan 20, 2015 at 12:38:12AM +0100, Johannes Stezenbach wrote:
> On Tue, Jan 20, 2015 at 04:31:55AM +0800, Greg Kroah-Hartman wrote:
> > On Mon, Jan 19, 2015 at 09:19:06PM +0100, Johannes Stezenbach wrote:
> > > These two statements somehow contradict. From my admittedly very
> > > limited experience, I never used D-Bus because it did not
> > > fit my usage scenarios: I never needed a bus, only point-to-point
> > > links like pipes or sockets.
> > 
> > Great, then you don't need this, no need to worry about it at all, why
> > are we having this conversation? :)
> 
> Well, for one because that's what I wanted to find out...
> 
> > > Well, it made your intentions a bit clearer, but it does
> > > not help to sell kdbus to me, sorry ;-/
> > 
> > It's not my "goal" to sell kdbus to you, if you don't want it, great,
> 
> I used this language because I think you're not providing
> the facts that would allow me to judge for myself whether
> kdbus is a good idea.  Those automotive applications you
> were talking about, what was the OS they were ported from
> and what was the messaging API they used?

They were ported from QNX and I don't know the exact api, it is wrapped
up in a library layer for them to use.  And typically, they run about
40 thousand messages in the first few seconds of startup time.  Or was
it 400 thousand?  Something huge and crazy to be doing on tiny ARM
chips, but that's the IVI industry for you :(

> > But odds are, you are using a system with D-Bus today, if not, then you
> > are using Linux in a very specific and limited manner, which is
> > wonderful, in that case this whole thread isn't really pertinent.
> > 
> > Lots of people do use D-Bus, and for those users, that is what this
> > patchset is for.
> 
> As I said before, I'm seeing about a dozen D-Bus messages per minute,
> nothing that would justify adding kdbus to the kernel for
> performance reasons.  Wrt security I'm also not aware of any
> open issues with D-Bus.  Thus I doubt normal users of D-Bus
> would see any benefit from kdbus.  I also think none of the
> applications I can install from my distribution has any performance
> issue with D-Bus.

That's because people have not done anything really needing performance
on the desktop over D-Bus in the past due to how slow the current
implementation is.  Now that this is being resolved, that can change,
and there are demos out there of even streaming audio over kdbus with no
problems.

But performance is not just the only reason we want this in the kernel,
I listed a whole long range of them.  Sure, it's great to now be faster,
cutting down the number of context switches and copies by a huge amount,
but the other things are equally important for future development
(namespaces, containers, security, early-boot, etc.)

> And this is the point where I ask myself if I missed something.

Don't focus purely on performance for your existing desktop system,
that's not the only use case here.  There are lots of others, as I
document, that can benefit and want this.

One "fun" thing I've been talking to someone about is the ability to
even port binder to be on top of kdbus.  But that's just a research
project, and requires some API changes on the userspace binder side, but
it shows real promise, and would then mean that we could deprecate the
old binder code and a few hundred million devices could then use kdbus
instead.  But that's long-term goals, not really all that relevant here,
but it shows that having a solid bus IPC mechanism is a powerful thing
that we have been missing in the past from Linux.

thanks,

greg k-h
