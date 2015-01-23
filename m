From: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Subject: Re: [PATCH 01/13] kdbus: add documentation
Date: Fri, 23 Jan 2015 23:54:02 +0800
Message-ID: <20150123155402.GB2159@kroah.com>
References: <1421435777-25306-1-git-send-email-gregkh@linuxfoundation.org>
 <1421435777-25306-2-git-send-email-gregkh@linuxfoundation.org>
 <54BE5DC8.70706@gmail.com>
 <54BE9D08.7010804@zonque.org>
 <54BF805B.4000609@gmail.com>
 <54BFDAAA.50203@zonque.org>
 <54C0CE8A.5080805@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <54C0CE8A.5080805-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Daniel Mack <daniel-cYrQPVfZoowdnm+yROfE0A@public.gmane.org>, arnd-r2nGTMty4D4@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, gnomes-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org, teg-B22kvLQNl6c@public.gmane.org, jkosina-AlSwsSmVLrQ@public.gmane.org, luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dh.herrmann-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, tixxdz-Umm1ozX2/EEdnm+yROfE0A@public.gmane.org, Johannes Stezenbach <js-FF7aIK3TAVNeoWH0uzbU5w@public.gmane.org>, Theodore T'so <tytso-3s7WtUTddSA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Thu, Jan 22, 2015 at 11:18:50AM +0100, Michael Kerrisk (man-pages) wrote:
> >> And that process seems to be frequent and ongoing even now. (And 
> >> it's to your great credit that the API/ABI breaks are clearly and honestly 
> >> marked in the kdbus.h changelog.) All of this lightens the burden of API
> >> design for kernel developers, but I'm concerned that the long-term pain
> >> for user-space developers who use an API which (in my estimation) may
> >> come to be widely used will be enormous.
> > 
> > Yes, we've jointly reviewed the API details again until just recently to
> > unify structs and enums etc, and added fields to make the ioctls structs
> > more versatile for possible future additions. By that, we effectively
> > broke the ABI, but we did that because we know we can't do such things
> > again in the future.
> > 
> > But again - I don't see how this would be different when using syscalls
> > rather than ioctls to transport information between the driver and
> > userspace. Could you elaborate?
> 
> My suspicion is that not nearly enough thinking has yet been done about
> the design of the API. That's based on these observations:
> 
> * Documentation that is, considering the size of the API, *way* too thin.
> * Some parts of the API not documented at all (various kdbus_item blobs)
> * ABI changes happening even quite recently
> * API oddities such as the 'kernel_flags' fields. Why do I need to
>   be told what flags the kernel supports on *every* operation?
> 
> The above is just after a day of looking hard at kdbus.txt. I strongly
> suspect I'd find a lot of other issues if I spent more time on kdbus.

"not enough thinking"?

We started working on kdbus 2 years ago this FOSDEM (in a few weeks.)
Before that we have been thinking about this for many years, learning
from the previous attempts to get this type of feature merged into the
kernel, talking with users about what they need for this, and soliciting
kernel developer's opinions on what type of API would be best for this
type of feature.

Since then we have done nothing but constantly revise the API.  My first
mock ups were way too simple, and in discussing things with people much
more knowledgeable about D-Bus, they pointed out the problems, and we
iterated.  And iterated.  And iterated some more.  We have worked with
just about every userspace libdbus developer group, including QtDbus
developers as well as glib developers.  Now not all of them agreed with
some of our decisions in the implementation, which is fair enough, you
can't please everyone, but they _all_ agree that what we have now is the
proper way to implement this type of functionality and have reviewed the
features as being correct and compatible with their needs and users.

Those discussions have happened in emails, presentations, meetings, and
hackfests pretty much continuously for the past 2 years all around the
world.

We have stress-tested the api with both unit tests (which are included
here in the patch set) as well as a real-world implementation (sd-bus in
the systemd source repo.)  That real-world implementation successfully
has been booting many of our daily machines for many months now.

Yes, the documentation can always be better, but please don't confuse
the lack of understanding how D-Bus works and its model with the lack of
understanding this kdbus implementation, the two are not comparable.
For some good primers on what D-Bus is, and the terminology it expects
see:
	http://dbus.freedesktop.org/doc/dbus-tutorial.html
and also:
	http://dbus.freedesktop.org/doc/dbus-faq.html#other-ipc

We are not going to put a basic "here is what D-Bus is and how to use
it" into the kernel tree, that is totally outside the scope here.

I suggest reading the tutorial above, and then going back and reading
the kdbus documentation provided.  If you think we are lacking stuff on
the kdbus side, we will be glad to flush out any needed areas.

Also, Daniel has said he will work on a basic userspace "example"
library to show how to use this api, which might make the api a bit
easier to understand.

However, I personally don't think this "example code" is necessary at
all.  We don't ask for this type of "simple examples" from other new
kernel apis we create and add to the kernel all the time.  We require
there to be a user of the api, but not one that is so well documented
that others can write a from-scratch raw userspace replacement.
Specific examples of this are my previously mentioned ioctl users
(btrfs, mei, mic, openvlan, etc.), and the grand-daddy of all horrid
apis, DRM.

Users aren't going to be writing their own "raw kdbus" libraries.  Or if
they are, they are going to start with one of the existing
implementations we have (the test examples and sd-bus, and I think there
is a native Go implementation somewhere as well.)  Users are going to be
using those libraries to write their code, and to be honest, the user
api for sd-bus is a delight to use compared to the "old style" libdbus
interface as we have the benefit of 10 years of experience working with
D-Bus apis in the wild now to learn from past mistakes.

Back to the API.  We have taken review comments on the previous postings
of the code and reworked the API, moving it from a character device to
be a filesystem, which ended up making things a lot easier in the end, a
good example of a review process that is working.  Those changes are
a sign that our development review process works.  People pointed out
problems in our character api that we hadn't thought about from the
kernel implementation side.  And so we changed them and the code is
better and more robust because of it, a success story for our review
process.

Personally, I was the one that started down the character device node
path, so blame that design decision on me, not the other developers
here.  And I was wrong with that, but moving from character to a
filesystem wasn't a huge change, the structures and interactions all
remained almost identical, as the logic behind the API is, in my
opinion, correct for the problem it is addressing.

The 37 different developers who have contributed to this code base are
quite talented and skilled and experienced in user and kernel apis,
having implemented many apis of their own that users rely on every day.

Yes, we all make design mistakes, and you might not agree with some of
them, that's fine.  But it is flat out rude to say that we have not been
thinking about this, when I would guess that this is one of the largest
(in time and contributions) kernel development feature to be worked on
in the past few years.

And yes, I'm being very defensive, as I take this very seriously, so
please, don't so lightly dismiss us as not knowing what we are doing, as
frankly, we do.

Thanks for making it this far, I'll go back to technical discussions of
the API now, as that's what we should be doing, not casting aspirations
as to the aptitude of the people involved.

thanks,

greg k-h
