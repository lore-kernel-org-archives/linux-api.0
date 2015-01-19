From: Johannes Stezenbach <js-FF7aIK3TAVNeoWH0uzbU5w@public.gmane.org>
Subject: Re: [PATCH v3 00/13] Add kdbus implementation
Date: Tue, 20 Jan 2015 00:38:12 +0100
Message-ID: <20150119233812.GA1874@sig21.net>
References: <1421435777-25306-1-git-send-email-gregkh@linuxfoundation.org>
 <20150119180642.GA27957@sig21.net>
 <20150119183806.GA8479@kroah.com>
 <20150119201906.GA337@sig21.net>
 <20150119203155.GA15441@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150119203155.GA15441-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Cc: arnd-r2nGTMty4D4@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, gnomes-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org, teg-B22kvLQNl6c@public.gmane.org, jkosina-AlSwsSmVLrQ@public.gmane.org, luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, daniel-cYrQPVfZoowdnm+yROfE0A@public.gmane.org, dh.herrmann-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, tixxdz-Umm1ozX2/EEdnm+yROfE0A@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Tue, Jan 20, 2015 at 04:31:55AM +0800, Greg Kroah-Hartman wrote:
> On Mon, Jan 19, 2015 at 09:19:06PM +0100, Johannes Stezenbach wrote:
> > These two statements somehow contradict. From my admittedly very
> > limited experience, I never used D-Bus because it did not
> > fit my usage scenarios: I never needed a bus, only point-to-point
> > links like pipes or sockets.
> 
> Great, then you don't need this, no need to worry about it at all, why
> are we having this conversation? :)

Well, for one because that's what I wanted to find out...

> > Well, it made your intentions a bit clearer, but it does
> > not help to sell kdbus to me, sorry ;-/
> 
> It's not my "goal" to sell kdbus to you, if you don't want it, great,

I used this language because I think you're not providing
the facts that would allow me to judge for myself whether
kdbus is a good idea.  Those automotive applications you
were talking about, what was the OS they were ported from
and what was the messaging API they used?

> But odds are, you are using a system with D-Bus today, if not, then you
> are using Linux in a very specific and limited manner, which is
> wonderful, in that case this whole thread isn't really pertinent.
> 
> Lots of people do use D-Bus, and for those users, that is what this
> patchset is for.

As I said before, I'm seeing about a dozen D-Bus messages per minute,
nothing that would justify adding kdbus to the kernel for
performance reasons.  Wrt security I'm also not aware of any
open issues with D-Bus.  Thus I doubt normal users of D-Bus
would see any benefit from kdbus.  I also think none of the
applications I can install from my distribution has any performance
issue with D-Bus.

And this is the point where I ask myself if I missed something.


Thanks,
Johannes
