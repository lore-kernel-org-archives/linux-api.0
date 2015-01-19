From: Johannes Stezenbach <js-FF7aIK3TAVNeoWH0uzbU5w@public.gmane.org>
Subject: Re: [PATCH v3 00/13] Add kdbus implementation
Date: Mon, 19 Jan 2015 21:19:06 +0100
Message-ID: <20150119201906.GA337@sig21.net>
References: <1421435777-25306-1-git-send-email-gregkh@linuxfoundation.org>
 <20150119180642.GA27957@sig21.net>
 <20150119183806.GA8479@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150119183806.GA8479-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Cc: arnd-r2nGTMty4D4@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, gnomes-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org, teg-B22kvLQNl6c@public.gmane.org, jkosina-AlSwsSmVLrQ@public.gmane.org, luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, daniel-cYrQPVfZoowdnm+yROfE0A@public.gmane.org, dh.herrmann-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, tixxdz-Umm1ozX2/EEdnm+yROfE0A@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Tue, Jan 20, 2015 at 02:38:06AM +0800, Greg Kroah-Hartman wrote:
> Yes, I do agree, there are lots of existing ipc solutions today that
> kdbus is not designed for, nor would it be good to use it for.  The
> majority of them being IPC that crosses the network layer, as there are
> lots of good solutions today for that problem.  That being said, I do
> know one research group that has kdbus working cross-network, just "to
> try it out", but I don't know what ever came of it.
...
> Everyone uses D-Bus today for everything on their system, so by
> replacing the underlying library with kdbus, they will continue to use
> it for everything without having to change any application or library
> code at all.

These two statements somehow contradict. From my admittedly very
limited experience, I never used D-Bus because it did not
fit my usage scenarios: I never needed a bus, only point-to-point
links like pipes or sockets.

Let me rephrase my previous, lengthy mail: Will kdbus only
support the same IPC model as D-Bus (just with higher
performance and some bells and whistles), or will it
be useful for other scenarios?  Like, can two programs
use it to communicate directly without the need of
any daemon?  (And if so, would there be any advantage
compared to traditional UNIX IPC methods?)

You were comparing kdbus and Binder.  Why?
So far my impression is that D-Bus and Binder are
completely seperate things, not just because of
the thread vs. event-loop programming model but
also because Binder is not a bus (i.e. no multicast messaging).

> Hope this helps,

Well, it made your intentions a bit clearer, but it does
not help to sell kdbus to me, sorry ;-/


Thanks,
Johannes
