From: Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>
Subject: Re: [PATCH 01/13] kdbus: add documentation
Date: Wed, 21 Jan 2015 10:19:13 -0500
Message-ID: <20150121151913.GA4798@thunk.org>
References: <1421435777-25306-1-git-send-email-gregkh@linuxfoundation.org>
 <1421435777-25306-2-git-send-email-gregkh@linuxfoundation.org>
 <54BE5DC8.70706@gmail.com>
 <54BE9D08.7010804@zonque.org>
 <54BF805B.4000609@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <54BF805B.4000609-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Daniel Mack <daniel-cYrQPVfZoowdnm+yROfE0A@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, arnd-r2nGTMty4D4@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, gnomes-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org, teg-B22kvLQNl6c@public.gmane.org, jkosina-AlSwsSmVLrQ@public.gmane.org, luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dh.herrmann-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, tixxdz-Umm1ozX2/EEdnm+yROfE0A@public.gmane.org, Johannes Stezenbach <js-FF7aIK3TAVNeoWH0uzbU5w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Wed, Jan 21, 2015 at 11:32:59AM +0100, Michael Kerrisk (man-pages) wrote:
> It's rather an optional driver than a core kernel feature.
> 
> Given the various things that I've seen said about kdbus, the
> preceding sentence makes little sense to me:
> 
> * kdbus will be the framework supporting user-space D-Bus in the
>   future, and also used by systemd, and so on pretty much every 
>   desktop system.

I have to agree with Michael here; it's really, **really**
disengenuous to say that that if you don't want kdbus, you can just
#ifconfig it out.  The fact that it systemd will be using it means
that it will very shortly become a core kernel feature which is
absolutely mandatory.  Sure, maybe it can be configured out for "tiny
kernels", just as in theory we can configure out the VM system for
really tiny embedded systems.  But we should be treating this as
something that is not optional, because the reality is that's the way
it's going to be in very short order.  So if that means to use proper
system calls instead of ioctls, we should do that.

       	     	     		   - Ted
