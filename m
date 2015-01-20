From: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Subject: Re: [PATCH v3 00/13] Add kdbus implementation
Date: Tue, 20 Jan 2015 19:26:09 +0800
Message-ID: <20150120112609.GA17198@kroah.com>
References: <1421435777-25306-1-git-send-email-gregkh@linuxfoundation.org>
 <20150119180642.GA27957@sig21.net>
 <20150119183806.GA8479@kroah.com>
 <20150119201906.GA337@sig21.net>
 <20150119203155.GA15441@kroah.com>
 <20150119233812.GA1874@sig21.net>
 <20150120011359.GE865@kroah.com>
 <20150120105712.GA6260@sig21.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150120105712.GA6260-FF7aIK3TAVNeoWH0uzbU5w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Johannes Stezenbach <js-FF7aIK3TAVNeoWH0uzbU5w@public.gmane.org>
Cc: arnd-r2nGTMty4D4@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, gnomes-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org, teg-B22kvLQNl6c@public.gmane.org, jkosina-AlSwsSmVLrQ@public.gmane.org, luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, daniel-cYrQPVfZoowdnm+yROfE0A@public.gmane.org, dh.herrmann-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, tixxdz-Umm1ozX2/EEdnm+yROfE0A@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Tue, Jan 20, 2015 at 11:57:12AM +0100, Johannes Stezenbach wrote:
> On Tue, Jan 20, 2015 at 09:13:59AM +0800, Greg Kroah-Hartman wrote:
> > On Tue, Jan 20, 2015 at 12:38:12AM +0100, Johannes Stezenbach wrote:
> > > Those automotive applications you
> > > were talking about, what was the OS they were ported from
> > > and what was the messaging API they used?
> > 
> > They were ported from QNX and I don't know the exact api, it is wrapped
> > up in a library layer for them to use.  And typically, they run about
> > 40 thousand messages in the first few seconds of startup time.  Or was
> > it 400 thousand?  Something huge and crazy to be doing on tiny ARM
> > chips, but that's the IVI industry for you :(
> 
> So I did some googling and found in QNX servers create a channel
> to receive messages, and clients connect to this channel.
> Multiple clients can connect to the channel.

Hence, a bus :)

> But it is not a bus -- no multicast/broadcast, and no name
> service or policy rules like D-Bus has.  To me it looks
> to be similar in functionality to UNIX domain sockets.

It's not as complex as D-Bus, but it's still subscribing to things and
getting messages.

> My guess is that the people porting from QNX were just confused
> and their use of D-Bus was in error.  Maybe they should've used
> plain sockets, capnproto, ZeroMQ or whatever.

I tend to trust that they knew what they were doing, they wouldn't have
picked D-Bus for no good reason.

> Well, IMHO you got it backwards.  Before adding a complex new IPC
> API to the kernel you should do the homework and gather some
> evidence that there will be enough users to justify the addition.

systemd wants this today for early boot.  It will remove lots of code
and enable a lot of good things to happen.  The first email in this
thread describes this quite well, is that not sufficient?

> FWIW, my gut feeling was that the earlier attempts to add a new
> IPC primitve like multicast UNIX domain sockets
> http://thread.gmane.org/gmane.linux.kernel/1255575/focus=1257999
> were a much saner approach.  But now I think the comments
> from this old thread have not been addressed, instead the
> new approach just made the thing more complex and
> put in ipc/ instead of net/ to bypass the guards.

Not at all, the networking maintainers said that that proposal was not
acceptable to them at all and it should not be done in the networking
stack at all.  So this was solution was created instead, which provides
a lot more things than the old networking patches did, which shows that
the networking developers were right to reject it.

thanks,

greg k-h
