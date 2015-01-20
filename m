From: Daniel Mack <daniel-cYrQPVfZoowdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 01/13] kdbus: add documentation
Date: Tue, 20 Jan 2015 19:23:04 +0100
Message-ID: <54BE9D08.7010804@zonque.org>
References: <1421435777-25306-1-git-send-email-gregkh@linuxfoundation.org> <1421435777-25306-2-git-send-email-gregkh@linuxfoundation.org> <54BE5DC8.70706@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <54BE5DC8.70706-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, arnd-r2nGTMty4D4@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, gnomes-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org, teg-B22kvLQNl6c@public.gmane.org, jkosina-AlSwsSmVLrQ@public.gmane.org, luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: daniel-cYrQPVfZooxQFI55V6+gNQ@public.gmane.org, dh.herrmann-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, tixxdz-Umm1ozX2/EEdnm+yROfE0A@public.gmane.org, Johannes Stezenbach <js-FF7aIK3TAVNeoWH0uzbU5w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 01/20/2015 02:53 PM, Michael Kerrisk (man-pages) wrote:
> This is an enormous and complex API. Why is the API ioctl() based,
> rather than system-call-based? Have we learned nothing from the hydra
> that the futex() multiplexing syscall became? (And kdbus is an order
> of magnitude more complex, by the look of things.) At the very least,
> a *good* justification of why the API is ioctl()-based should be part
> of this documentation file.

I think the simplest reason is because we want to be able to build kdbus
as a module. It's rather an optional driver than a core kernel feature.
IMO, kernel primitives should be syscalls, but kdbus is not a primitive
but an elaborate subsystem.

Also, the context the kdbus commands operate on originate from a
mountable special-purpose file system. Hence, we decided not to use a
global kernel interface but specific ioctls on the nodes exposed by kdbusfs.


Thanks,
Daniel
