From: Johannes Stezenbach <js-FF7aIK3TAVNeoWH0uzbU5w@public.gmane.org>
Subject: Re: [PATCH v3 00/13] Add kdbus implementation
Date: Tue, 20 Jan 2015 14:24:37 +0100
Message-ID: <20150120132437.GB7545@sig21.net>
References: <1421435777-25306-1-git-send-email-gregkh@linuxfoundation.org>
 <20150119180642.GA27957@sig21.net>
 <20150119183806.GA8479@kroah.com>
 <20150119201906.GA337@sig21.net>
 <20150119203155.GA15441@kroah.com>
 <20150119233812.GA1874@sig21.net>
 <20150120011359.GE865@kroah.com>
 <20150120105712.GA6260@sig21.net>
 <20150120112609.GA17198@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150120112609.GA17198-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Cc: arnd-r2nGTMty4D4@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, gnomes-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org, teg-B22kvLQNl6c@public.gmane.org, jkosina-AlSwsSmVLrQ@public.gmane.org, luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, daniel-cYrQPVfZoowdnm+yROfE0A@public.gmane.org, dh.herrmann-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, tixxdz-Umm1ozX2/EEdnm+yROfE0A@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Tue, Jan 20, 2015 at 07:26:09PM +0800, Greg Kroah-Hartman wrote:
> On Tue, Jan 20, 2015 at 11:57:12AM +0100, Johannes Stezenbach wrote:
> > 
> > So I did some googling and found in QNX servers create a channel
> > to receive messages, and clients connect to this channel.
> > Multiple clients can connect to the channel.
> 
> Hence, a bus :)
> 
> > But it is not a bus -- no multicast/broadcast, and no name
> > service or policy rules like D-Bus has.  To me it looks
> > to be similar in functionality to UNIX domain sockets.
> 
> It's not as complex as D-Bus, but it's still subscribing to things and
> getting messages.

Apparently you don't read what I write, probably you're not interested
in this discussion anymore...
QNX uses the term "channel" but it does not refer to a bus
or subscription facility, it is more like a socket in listening state.

> > My guess is that the people porting from QNX were just confused
> > and their use of D-Bus was in error.  Maybe they should've used
> > plain sockets, capnproto, ZeroMQ or whatever.
> 
> I tend to trust that they knew what they were doing, they wouldn't have
> picked D-Bus for no good reason.

The automotive developers I had the pleasure to work with would
use anything which is available via a mouse click in the
commercial Embedded Linux SDK IDE of their choice :)
Let's face it: QNX has a single IPC solution while Linux has
a confusing multitude of possibilities.

> > Well, IMHO you got it backwards.  Before adding a complex new IPC
> > API to the kernel you should do the homework and gather some
> > evidence that there will be enough users to justify the addition.
> 
> systemd wants this today for early boot.  It will remove lots of code
> and enable a lot of good things to happen.  The first email in this
> thread describes this quite well, is that not sufficient?

The first mail in this thread doesn't even mention systemd,
instead it has a lot of "marketing" buzzwords.
Of course it is no secret that systemd is the driving force
behind kdbus, but no public record exists to explain why
kdbus was chosen and designed the way it is, what alternatives
were considered and rejected etc.  (or if there is, please send a link)

> > FWIW, my gut feeling was that the earlier attempts to add a new
> > IPC primitve like multicast UNIX domain sockets
> > http://thread.gmane.org/gmane.linux.kernel/1255575/focus=1257999
> > were a much saner approach.  But now I think the comments
> > from this old thread have not been addressed, instead the
> > new approach just made the thing more complex and
> > put in ipc/ instead of net/ to bypass the guards.
> 
> Not at all, the networking maintainers said that that proposal was not
> acceptable to them at all and it should not be done in the networking
> stack at all.  So this was solution was created instead, which provides
> a lot more things than the old networking patches did, which shows that
> the networking developers were right to reject it.

Please read the gmane thread to the end.  It seems there were
several indications that D-Bus can be improved in userspace
using existing kernel facilities.  Havoc Pennington's mail
I quoted in my first response also contains some hints
about it.  I have no idea if any of this has ever been
pursued.  While adding complexity to critical net/ code paths
is probematic and a good reason to reject it, this was not
the only reason, the major one being "not neccessary".


Thanks,
Johannes
