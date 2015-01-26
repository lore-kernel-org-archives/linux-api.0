From: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 01/13] kdbus: add documentation
Date: Mon, 26 Jan 2015 15:42:47 +0100
Message-ID: <54C65267.7090905@gmail.com>
References: <1421435777-25306-1-git-send-email-gregkh@linuxfoundation.org> <1421435777-25306-2-git-send-email-gregkh@linuxfoundation.org> <54BE5DC8.70706@gmail.com> <54BE9D08.7010804@zonque.org> <54BF805B.4000609@gmail.com> <54BFDAAA.50203@zonque.org> <54C0CE8A.5080805@gmail.com> <20150123155402.GB2159@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150123155402.GB2159-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Cc: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Daniel Mack <daniel-cYrQPVfZoowdnm+yROfE0A@public.gmane.org>, arnd-r2nGTMty4D4@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, gnomes-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org, teg-B22kvLQNl6c@public.gmane.org, jkosina-AlSwsSmVLrQ@public.gmane.org, luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dh.herrmann-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, tixxdz-Umm1ozX2/EEdnm+yROfE0A@public.gmane.org, Johannes Stezenbach <js-FF7aIK3TAVNeoWH0uzbU5w@public.gmane.org>, Theodore T'so <tytso-3s7WtUTddSA@public.gmane.org>, christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hi Greg,

First of all, I seem to have offended you. That was not my intention.
It's certainly not my intent to disparage you or your work (or for 
that matter, the other kdbus developers). Insofar as any of the wordings 
I've used suggested otherwise, I do apologize.

I'll comment on various points below, keeping it as technical as I can.
Then I have a couple of general questions at the end with the goal
of ensuring that my comments are not coming from a broken world view.

On 01/23/2015 04:54 PM, Greg Kroah-Hartman wrote:
> On Thu, Jan 22, 2015 at 11:18:50AM +0100, Michael Kerrisk (man-pages) wrote:
>>>> And that process seems to be frequent and ongoing even now. (And 
>>>> it's to your great credit that the API/ABI breaks are clearly and honestly 
>>>> marked in the kdbus.h changelog.) All of this lightens the burden of API
>>>> design for kernel developers, but I'm concerned that the long-term pain
>>>> for user-space developers who use an API which (in my estimation) may
>>>> come to be widely used will be enormous.
>>>
>>> Yes, we've jointly reviewed the API details again until just recently to
>>> unify structs and enums etc, and added fields to make the ioctls structs
>>> more versatile for possible future additions. By that, we effectively
>>> broke the ABI, but we did that because we know we can't do such things
>>> again in the future.
>>>
>>> But again - I don't see how this would be different when using syscalls
>>> rather than ioctls to transport information between the driver and
>>> userspace. Could you elaborate?
>>
>> My suspicion is that not nearly enough thinking has yet been done about
>> the design of the API. That's based on these observations:
>>
>> * Documentation that is, considering the size of the API, *way* too thin.
>> * Some parts of the API not documented at all (various kdbus_item blobs)
>> * ABI changes happening even quite recently
>> * API oddities such as the 'kernel_flags' fields. Why do I need to
>>   be told what flags the kernel supports on *every* operation?
>>
>> The above is just after a day of looking hard at kdbus.txt. I strongly
>> suspect I'd find a lot of other issues if I spent more time on kdbus.
> 
> "not enough thinking"?
> 
> We started working on kdbus 2 years ago this FOSDEM (in a few weeks.)
> Before that we have been thinking about this for many years, learning
> from the previous attempts to get this type of feature merged into the
> kernel, talking with users about what they need for this, and soliciting
> kernel developer's opinions on what type of API would be best for this
> type of feature.
> 
> Since then we have done nothing but constantly revise the API.  My first
> mock ups were way too simple, and in discussing things with people much
> more knowledgeable about D-Bus, they pointed out the problems, and we
> iterated.  And iterated.  And iterated some more.  We have worked with
> just about every userspace libdbus developer group, including QtDbus
> developers as well as glib developers.  Now not all of them agreed with
> some of our decisions in the implementation, which is fair enough, you
> can't please everyone, but they _all_ agree that what we have now is the
> proper way to implement this type of functionality and have reviewed the
> features as being correct and compatible with their needs and users.
> 
> Those discussions have happened in emails, presentations, meetings, and
> hackfests pretty much continuously for the past 2 years all around the
> world.
> 
> We have stress-tested the api with both unit tests (which are included
> here in the patch set) as well as a real-world implementation (sd-bus in
> the systemd source repo.)  That real-world implementation successfully
> has been booting many of our daily machines for many months now.

Notwithstanding that I don't see how a unit test stress tests an API 
*design*, I've no reason to doubt that kdbus works. But that's not the 
point of my concern. I worry how usable this API is going to be for the 
world at large.

> Yes, the documentation can always be better, but please don't confuse
> the lack of understanding how D-Bus works and its model with the lack of
> understanding this kdbus implementation, the two are not comparable.
> For some good primers on what D-Bus is, and the terminology it expects
> see:
> 	http://dbus.freedesktop.org/doc/dbus-tutorial.html
> and also:
> 	http://dbus.freedesktop.org/doc/dbus-faq.html#other-ipc
> 
> We are not going to put a basic "here is what D-Bus is and how to use
> it" into the kernel tree, that is totally outside the scope here.

I didn't expect that you should do that. But it does touch on a general 
question that I'll leave to the end of this mail.

> I suggest reading the tutorial above, and then going back and reading
> the kdbus documentation provided.  If you think we are lacking stuff on
> the kdbus side, we will be glad to flush out any needed areas.
> 
> Also, Daniel has said he will work on a basic userspace "example"
> library to show how to use this api, which might make the api a bit
> easier to understand.
> 
> However, I personally don't think this "example code" is necessary at
> all.  We don't ask for this type of "simple examples" from other new
> kernel apis we create and add to the kernel all the time.   We require
> there to be a user of the api, but not one that is so well documented
> that others can write a from-scratch raw userspace replacement.

What you've just summarized there is how low a bar we've historically 
set in API design. Thus, the API is littered with (for example) dozens 
of system calls that were insufficiently well thought out in their 
design, and have subsequently been superseded by replacements that 
fixed the design mistakes. One of the cause of that problems is the
targeting of "*a* user of the API"--general purpose APIs need to be
considered from the point of view of multiple potentially different 
use cases. And I'm certainly not talking about being able to reimplement
the API, But, the API is a contract, and it needs to be well understood
by its creators and consumers in order that they can assess and use that
API. Extensive Documentation generally is the best way to do that.

And, anyway, I had understood that there was a rough consensus that we do
want to see more tests/examples and documentation happening in the future.
Certainly, the number kernel developers who are taking a shot at
writing man pages these days is refreshing. (We are 7/7 for man-page
documented system calls in the 3.17-3.19 frame. That's a trend I've done 
my best to encourage, and hope to see continue in the future.) And now
we have kselftest, in part thanks to your good efforts.

> Specific examples of this are my previously mentioned ioctl users
> (btrfs, mei, mic, openvlan, etc.), and the grand-daddy of all horrid
> apis, DRM.

You've made this comparison a number of times, but I think it misses
a crucial point. Those examples are all(?) domain-specific APIs with
relatively few users in terms of user-space applications, whereas, 
IIUC, kdbus is intended to be an IPC mechanism that can be employed
by user-space applications in a general-purpose fashion, and upon 
which potentially a multitude of different applications might be built.
That's why I think the decision to use an ioctl()-based interface 
needs to be considered from a (very) skeptical point of view: no other 
general-purpose IPC mechanism employs such an approach. (Again, see
one of my general questions at the end of this mail.)

> Users aren't going to be writing their own "raw kdbus" libraries.  Or if
> they are, they are going to start with one of the existing
> implementations we have (the test examples and sd-bus, and I think there
> is a native Go implementation somewhere as well.)  Users are going to be
> using those libraries to write their code, and to be honest, the user
> api for sd-bus is a delight to use compared to the "old style" libdbus
> interface as we have the benefit of 10 years of experience working with
> D-Bus apis in the wild now to learn from past mistakes.
> 
> Back to the API.  We have taken review comments on the previous postings
> of the code and reworked the API, moving it from a character device to
> be a filesystem, which ended up making things a lot easier in the end, a
> good example of a review process that is working.  Those changes are
> a sign that our development review process works.  People pointed out
> problems in our character api that we hadn't thought about from the
> kernel implementation side.  And so we changed them and the code is
> better and more robust because of it, a success story for our review
> process.
> 
> Personally, I was the one that started down the character device node
> path, so blame that design decision on me, not the other developers
> here.  And I was wrong with that, but moving from character to a
> filesystem wasn't a huge change, the structures and interactions all
> remained almost identical, as the logic behind the API is, in my
> opinion, correct for the problem it is addressing.
> 
> The 37 different developers who have contributed to this code base are
> quite talented and skilled and experienced in user and kernel apis,
> having implemented many apis of their own that users rely on every day.

Yes, but I am not sure that the 15 developers who made each made 1 commit
(out of 2816 to date) would have done much work on the API. And probably 
the same is true for the 9 more who made just 2 or 3 commits. As one
would expect, the great deal of the good work has been done by a small
core: just shy of 95% commits by the top 5 committers.

> Yes, we all make design mistakes, and you might not agree with some of
> them, that's fine.  But it is flat out rude to say that we have not been
> thinking about this, when I would guess that this is one of the largest
> (in time and contributions) kernel development feature to be worked on
> in the past few years.
>
> And yes, I'm being very defensive, as I take this very seriously, so
> please, don't so lightly dismiss us as not knowing what we are doing, as
> frankly, we do.

Greg, I did not say you hadn't been thinking about this [API design].
(But I acknowledge my words could have been better chosen.) However,
API design is hard to get right, and causes endless pain when it's wrong.
And by now I've been watching long enough to know that the mistakes
are frequent. Even Davide Libenzi, who once upon a time was one of our 
more prolific and talented creators of APIs made mistakes. Thus, for
example, as we speak, the third iteration of epoll_wait() is in 
development (epoll_wait() ==> epoll_pwait() ==> epoll_pwait1()). 
And epoll is an API that is significantly simpler than kdbus.

In my observation, a good API design is a well documented API design.
Otherwise, it's virtually impossible to think thoroughly about the API,
and that is especially true as the API gets larger. (And AFAICS, the
kdbus API is bigger than, for example, the epoll API by an order of
magnitude, or so.) Part of that documentation also should include some
concrete examples of the use of the API. Again because it helps people
to think about and assess the API. (This is especially the case for
the fresh minds that explore the new API for the first time without 
having the preconceptions that are almost inevitable for the creators 
of the API.)

(BTW, I'm not ignoring your contents about the D-Bus spec above. But 
kdbus is a free-standing API, IIUC, and as such, it should be assessed 
on its own.)

I would summarize your statement above, as "trust us, we know what 
we're doing". With respect, my default position is not to trust. It's
nothing personal: API design is hard, and mistakes are too often made.
What I want to say in return is "trust us", where "us" is used very
inclusively to mean: the kernel maintainers, and for that matter 
user-space programmers, who need enough information that we can make a
well-informed assessment of the merits of an API that will need to be 
supported forever and may have a multitude of different users. In 
my assessment, the current information is far from sufficient, and 
it's a considerable risk to merge the API lacking such information.

> Thanks for making it this far, I'll go back to technical discussions of
> the API now, as that's what we should be doing, not casting aspirations
> as to the aptitude of the people involved.

Greg, that comment, with its implication that I am not concerned about
technical matters, but rather with something more malicious was quite 
uncalled for.

But, I am happy to return to technical matters. And I think it best to 
start with a couple of fundamental questions, since some of the comments
I've seen to date from different kdbus developers seem to conflict:

1. Is this intended to be a general purpose API that might see a 
   multitude of different users, or is it thought of as an API designed 
   to support a few specific users such as D-Bus and maybe a handful of 
   others? I had thought the former, but when you point me in the 
   direction of the D-Bus spec, I start to have doubts.

2. Is the API to be invoked directly by applications or is intended to
   be used only behind specific libraries? You seem to be saying that
   the latter is the case (here, I'm referring to your comment above 
   about sd-bus). However, when I asked David Herrmann a similar
   question I got this responser:

      "kdbus is in no way bound to systemd. There are ongoing efforts 
       to port glib and qt to kdbus natively. The API is pretty simple 
       and I don't see how a libkdbus would simplify things. In fact, 
       even our tests only have slim wrappers around the ioctls to 
       simplify error-handling in test-scenarios."

   To me, that implies that users will employ the raw kernel API.

Thanks,

Michael


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
