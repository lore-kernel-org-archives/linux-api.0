From: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 01/13] kdbus: add documentation
Date: Wed, 21 Jan 2015 11:32:59 +0100
Message-ID: <54BF805B.4000609@gmail.com>
References: <1421435777-25306-1-git-send-email-gregkh@linuxfoundation.org> <1421435777-25306-2-git-send-email-gregkh@linuxfoundation.org> <54BE5DC8.70706@gmail.com> <54BE9D08.7010804@zonque.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <54BE9D08.7010804-cYrQPVfZoowdnm+yROfE0A@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Daniel Mack <daniel-cYrQPVfZoowdnm+yROfE0A@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, arnd-r2nGTMty4D4@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, gnomes-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org, teg-B22kvLQNl6c@public.gmane.org, jkosina-AlSwsSmVLrQ@public.gmane.org, luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, dh.herrmann-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, tixxdz-Umm1ozX2/EEdnm+yROfE0A@public.gmane.org, Johannes Stezenbach <js-FF7aIK3TAVNeoWH0uzbU5w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hello Daniel,

On 01/20/2015 07:23 PM, Daniel Mack wrote:
> On 01/20/2015 02:53 PM, Michael Kerrisk (man-pages) wrote:
>> This is an enormous and complex API. Why is the API ioctl() based,
>> rather than system-call-based? Have we learned nothing from the hydra
>> that the futex() multiplexing syscall became? (And kdbus is an order
>> of magnitude more complex, by the look of things.) At the very least,
>> a *good* justification of why the API is ioctl()-based should be part
>> of this documentation file.
> 
> I think the simplest reason is because we want to be able to build kdbus
> as a module. 

This isn't any _good_ justification...

> It's rather an optional driver than a core kernel feature.

Given the various things that I've seen said about kdbus, the
preceding sentence makes little sense to me:

* kdbus will be the framework supporting user-space D-Bus in the
  future, and also used by systemd, and so on pretty much every 
  desktop system.
* kdbus solves much of the bandwidth problem of D-Bus1. That,
  along with a host of other features mean that there will be
  a lot of user-space developers interested in using this API.
* Various parties in user space are already expressing strong 
  interest in kdbus.

My guess from the above? This will NOT be an "optional driver". 
It *will be* a core kernel feature.

> IMO, kernel primitives should be syscalls, but kdbus is not a primitive
> but an elaborate subsystem.

Agreed. It's an elaborate subsystem. But that fact doesn't in itself
dictate any particular API design choice.

> Also, the context the kdbus commands operate on originate from a
> mountable special-purpose file system.

It's not clear to me how this point implies any particular API design
choice.

> Hence, we decided not to use a
> global kernel interface but specific ioctls on the nodes exposed by kdbusfs.

I don't follow the reasoning here at all. Here's what we have, if I
have grasped it roughly correctly:

* 16 ioctls exposed to user space.
* some 20 different structures exchanged between kernel and user space
* about 14k lines of kernel code implement the above
* some rather thin documentation of the whole lot

Sorry if that last point seems rather harsh. I know that you personally 
have done a lot of work on the kdbus.txt file. David Herrmann asserts
that this is a simple API. It is not. He also suggests that there is
no need for a libkdbus. I don't know whether that's right or not, but the
point is then that there's an expectation that the raw kernel API is what
user space will need to work with. 

Notwithstanding the fact that there's a lot of (good) information in
kdbus.txt, there's not nearly enough for someone to create useful, 
robust applications that use that API (and not enough that I as a
reviewer feel comfortable about reviewing the API). As things stand,
user-space developers will be forced to decipher large amounts of kernel
code and existing applications in order to actually build things. And
when they do, they'll be using one of the worst APIs known to man: ioctl(),
an API that provides no type safety at all.

ioctl() is a get-out-of-jail free card when it comes to API design. Rather
than thinking carefully and long about a set of coherent, stable APIs that 
provide some degree of type-safety to user-space, one just adds/changes/removes
an ioctl. And that process seems to be frequent and ongoing even now. (And 
it's to your great credit that the API/ABI breaks are clearly and honestly 
marked in the kdbus.h changelog.) All of this lightens the burden of API
design for kernel developers, but I'm concerned that the long-term pain
for user-space developers who use an API which (in my estimation) may
come to be widely used will be enormous.

Concretely, I'd like to see the following in kdbus.txt:
* A lot more detail, adding the various pieces that are currently missing.
  I've mentioned already the absence of detail on the item blob structures, 
  but there's probably several other pieces as well. My problem is that the
  API is so big and hard to grok that it's hard to even begin to work out
  what's missing from the documentation.
* Fleshing out the API summaries with code snippets that illustrate the
  use of the APIs.
* At least one simple working example application, complete with a walk
  through of how it's built and run.

Yes, all of this is a big demand. But this is a big API that is being added 
to the kernel, and one that may become widely used and for a long time.
It's imperative that the API is well documented, and as well designed as
possible. Furthermore, with such improved documentation I feel we'd be in 
a better position to evaluate the merits of an ioctl()-based API versus
some other approach.

Thanks,

Michael




-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
