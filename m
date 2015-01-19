From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH v3 00/13] Add kdbus implementation
Date: Tue, 20 Jan 2015 04:31:55 +0800
Message-ID: <20150119203155.GA15441@kroah.com>
References: <1421435777-25306-1-git-send-email-gregkh@linuxfoundation.org>
 <20150119180642.GA27957@sig21.net>
 <20150119183806.GA8479@kroah.com>
 <20150119201906.GA337@sig21.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150119201906.GA337@sig21.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Johannes Stezenbach <js@sig21.net>
Cc: arnd@arndb.de, ebiederm@xmission.com, gnomes@lxorguk.ukuu.org.uk, teg@jklm.no, jkosina@suse.cz, luto@amacapital.net, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, daniel@zonque.org, dh.herrmann@gmail.com, tixxdz@opendz.org
List-Id: linux-api@vger.kernel.org

On Mon, Jan 19, 2015 at 09:19:06PM +0100, Johannes Stezenbach wrote:
> On Tue, Jan 20, 2015 at 02:38:06AM +0800, Greg Kroah-Hartman wrote:
> > Yes, I do agree, there are lots of existing ipc solutions today that
> > kdbus is not designed for, nor would it be good to use it for.  The
> > majority of them being IPC that crosses the network layer, as there are
> > lots of good solutions today for that problem.  That being said, I do
> > know one research group that has kdbus working cross-network, just "to
> > try it out", but I don't know what ever came of it.
> ...
> > Everyone uses D-Bus today for everything on their system, so by
> > replacing the underlying library with kdbus, they will continue to use
> > it for everything without having to change any application or library
> > code at all.
> 
> These two statements somehow contradict. From my admittedly very
> limited experience, I never used D-Bus because it did not
> fit my usage scenarios: I never needed a bus, only point-to-point
> links like pipes or sockets.

Great, then you don't need this, no need to worry about it at all, why
are we having this conversation? :)

> Let me rephrase my previous, lengthy mail: Will kdbus only
> support the same IPC model as D-Bus (just with higher
> performance and some bells and whistles), or will it
> be useful for other scenarios?  Like, can two programs
> use it to communicate directly without the need of
> any daemon?  (And if so, would there be any advantage
> compared to traditional UNIX IPC methods?)

It's a totally different model, as you point out from what you are
thinking of "traditional" IPC methods (side note, which of the 15+
current IPC methods do you consider "traditional", we have a lot of them
these days...)

> You were comparing kdbus and Binder.  Why?

Why not?  :)

Seriously, they are related in a way, see my long blog post for all of
the details about it if you are curious.

> So far my impression is that D-Bus and Binder are
> completely seperate things, not just because of
> the thread vs. event-loop programming model but
> also because Binder is not a bus (i.e. no multicast messaging).

People compare them a lot, which is why I brought it up, it's a
discussion that needed to be made.

> > Hope this helps,
> 
> Well, it made your intentions a bit clearer, but it does
> not help to sell kdbus to me, sorry ;-/

It's not my "goal" to sell kdbus to you, if you don't want it, great,
don't worry about it, don't build it on your kernels, and the world will
be fine.  Consider it like any other "driver" or filesystem, if you
don't need it, there's nothing to even discuss.

But odds are, you are using a system with D-Bus today, if not, then you
are using Linux in a very specific and limited manner, which is
wonderful, in that case this whole thread isn't really pertinent.

Lots of people do use D-Bus, and for those users, that is what this
patchset is for.

Hope that helps clear things up,

greg k-h
