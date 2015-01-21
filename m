From: Daniel Mack <daniel-cYrQPVfZoowdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 01/13] kdbus: add documentation
Date: Wed, 21 Jan 2015 17:58:18 +0100
Message-ID: <54BFDAAA.50203@zonque.org>
References: <1421435777-25306-1-git-send-email-gregkh@linuxfoundation.org> <1421435777-25306-2-git-send-email-gregkh@linuxfoundation.org> <54BE5DC8.70706@gmail.com> <54BE9D08.7010804@zonque.org> <54BF805B.4000609@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <54BF805B.4000609-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, arnd-r2nGTMty4D4@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, gnomes-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org, teg-B22kvLQNl6c@public.gmane.org, jkosina-AlSwsSmVLrQ@public.gmane.org, luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: dh.herrmann-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, tixxdz-Umm1ozX2/EEdnm+yROfE0A@public.gmane.org, Johannes Stezenbach <js-FF7aIK3TAVNeoWH0uzbU5w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hi Michael,

On 01/21/2015 11:32 AM, Michael Kerrisk (man-pages) wrote:
> On 01/20/2015 07:23 PM, Daniel Mack wrote:

>> It's rather an optional driver than a core kernel feature.
> 
> Given the various things that I've seen said about kdbus, the
> preceding sentence makes little sense to me:
> 
> * kdbus will be the framework supporting user-space D-Bus in the
>   future, and also used by systemd, and so on pretty much every 
>   desktop system.
> * kdbus solves much of the bandwidth problem of D-Bus1. That,
>   along with a host of other features mean that there will be
>   a lot of user-space developers interested in using this API.
> * Various parties in user space are already expressing strong 
>   interest in kdbus.
> 
> My guess from the above? This will NOT be an "optional driver". 
> It *will be* a core kernel feature.

There will be userlands that will depend on kdbus, but that will still
not turn the "driver" into a core Linux kernel feature. We really want
it to be losely coupled from the rest of the kernel and optional after
all. The kernel people are working toward making more and more things
optional these days, and there will still be lots of systems that won't
be using kdbus.

>> Also, the context the kdbus commands operate on originate from a
>> mountable special-purpose file system.
> 
> It's not clear to me how this point implies any particular API design
> choice.

It emphasizes the fact that our ioctl API can only be used with the
nodes exposed by kdbusfs, and vice versa. I think operations on
driver-specific files do not justify a new 'generic' syscall API.

> Notwithstanding the fact that there's a lot of (good) information in
> kdbus.txt, there's not nearly enough for someone to create useful, 
> robust applications that use that API (and not enough that I as a
> reviewer feel comfortable about reviewing the API). As things stand,
> user-space developers will be forced to decipher large amounts of kernel
> code and existing applications in order to actually build things. And
> when they do, they'll be using one of the worst APIs known to man: ioctl(),
> an API that provides no type safety at all.

I don't see how ioctls are any worse than syscalls with pointers to
structures. One can screw up compatibility either way. How is an ioctl
wrapper/prototype any less type-safe than a syscall wrapper?

> ioctl() is a get-out-of-jail free card when it comes to API design.

And how are syscalls different in that regard when they would both
transport the same data structures? Also note that all kdbus ioctls
necessarily operate on a file descriptor context, which an ioctl passes
along by default.

> Rather
> than thinking carefully and long about a set of coherent, stable APIs that 
> provide some degree of type-safety to user-space, one just adds/changes/removes
> an ioctl.

Adding another ioctl in the future for cases we didn't think about
earlier would of course be considered a workaround; and even though such
things happen all the time, it's certainly something we'd like to avoid.

However, we would also need to add another syscall in such cases, which
is even worse IMO. So that's really not an argument against ioctls after
all. What fundamental difference between a raw syscall and a ioctl,
especially with regards to type safety, is there which would help us here?

> And that process seems to be frequent and ongoing even now. (And 
> it's to your great credit that the API/ABI breaks are clearly and honestly 
> marked in the kdbus.h changelog.) All of this lightens the burden of API
> design for kernel developers, but I'm concerned that the long-term pain
> for user-space developers who use an API which (in my estimation) may
> come to be widely used will be enormous.

Yes, we've jointly reviewed the API details again until just recently to
unify structs and enums etc, and added fields to make the ioctls structs
more versatile for possible future additions. By that, we effectively
broke the ABI, but we did that because we know we can't do such things
again in the future.

But again - I don't see how this would be different when using syscalls
rather than ioctls to transport information between the driver and
userspace. Could you elaborate?

> Concretely, I'd like to see the following in kdbus.txt:
> * A lot more detail, adding the various pieces that are currently missing.
>   I've mentioned already the absence of detail on the item blob structures, 
>   but there's probably several other pieces as well. My problem is that the
>   API is so big and hard to grok that it's hard to even begin to work out
>   what's missing from the documentation.
> * Fleshing out the API summaries with code snippets that illustrate the
>   use of the APIs.
> * At least one simple working example application, complete with a walk
>   through of how it's built and run.
> 
> Yes, all of this is a big demand. But this is a big API that is being added 
> to the kernel, and one that may become widely used and for a long time.

Fair enough. Everything that helps people understand and use the API in
a sane way is a good thing to have, and so is getting an assessment from
people how are exposed to this API for the first time.

We'll be working on restructuring the documentation.


Thanks,
Daniel
