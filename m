From: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 01/13] kdbus: add documentation
Date: Fri, 23 Jan 2015 12:47:01 +0100
Message-ID: <54C234B5.7040607@gmail.com>
References: <1421435777-25306-1-git-send-email-gregkh@linuxfoundation.org>	<1421435777-25306-2-git-send-email-gregkh@linuxfoundation.org>	<54BE5DC8.70706@gmail.com>	<54BE9D08.7010804@zonque.org>	<54BF805B.4000609@gmail.com>	<54BFDAAA.50203@zonque.org>	<54C0CE8A.5080805@gmail.com> <CANq1E4S=3qNw599L85uj-8aXwxeV+mcurB_Nu_rHH8opAeePjw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CANq1E4S=3qNw599L85uj-8aXwxeV+mcurB_Nu_rHH8opAeePjw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Herrmann <dh.herrmann-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Daniel Mack <daniel-cYrQPVfZoowdnm+yROfE0A@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, One Thousand Gnomes <gnomes-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>, Tom Gundersen <teg-B22kvLQNl6c@public.gmane.org>, Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Djalal Harouni <tixxdz-Umm1ozX2/EEdnm+yROfE0A@public.gmane.org>, Johannes Stezenbach <js-FF7aIK3TAVNeoWH0uzbU5w@public.gmane.org>, Theodore T'so <tytso-3s7WtUTddSA@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hi David,

On 01/22/2015 02:46 PM, David Herrmann wrote:
> Hi Michael
> 
> On Thu, Jan 22, 2015 at 11:18 AM, Michael Kerrisk (man-pages)
> <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>> On 01/21/2015 05:58 PM, Daniel Mack wrote:
>>>>> Also, the context the kdbus commands operate on originate from a
>>>>> mountable special-purpose file system.
>>>>
>>>> It's not clear to me how this point implies any particular API design
>>>> choice.
>>>
>>> It emphasizes the fact that our ioctl API can only be used with the
>>> nodes exposed by kdbusfs, and vice versa. I think operations on
>>> driver-specific files do not justify a new 'generic' syscall API.
>>
>> I see your (repeated) use of words like "driver" as just a distraction,
>> I'm sorry. "Driver-specific files" is an implementation detail. The
>> point is that kdbus provides a complex, general-purpose feature for all
>> of userland. It is core infrastructure that will be used by key pieces
>> of the plumbing layer, and likely by many other applications as well.
>> *Please* stop suggesting that it is not core infrastructure: kdbus
>> has the potential to be a great IPC that will be very useful to many,
>> many user-space developers.
> 
> We called it an 'ipc driver' so far. It is in no way meant as
> distraction. Feel free to call it 'core infrastructure'. I think we
> can agree that we want it to be generically useful, like other ipc
> mechanisms, including UDS and netlink.

Yes.

>> (By the way, we have precedents for device/filesystem-specific system
>> calls. Even a recent one, in memfd_create().)
> 
> memfd_create() is in no way file-system specific. Internally, it uses
> shmem, but that's an implementation detail. The API does not expose
> this in any way. If you were referring to sealing, it's implemented as
> fcntl(), not as a separate syscall. Furthermore, sealing is only
> limited to shmem as it's the only volatile storage. It's not an API
> restriction. Other volatile file-systems are free to implement
> sealing.

My bad. I mispoke there.

>>>> ioctl() is a get-out-of-jail free card when it comes to API design.
>>>
>>> And how are syscalls different in that regard when they would both
>>> transport the same data structures?
>>
>> My general impression is that when it comes to system calls,
>> there's usually a lot more up front thought about API design.
> 
> This is no technical reason why to use syscalls over ioctls. Imho,
> it's rather a reason to improve the kernel's ioctl-review process.

Agreed it's not a technical reason. But the distinction I make 
does capture how things usually work.

[...]

>>>> Rather
>>>> than thinking carefully and long about a set of coherent, stable APIs that
>>>> provide some degree of type-safety to user-space, one just adds/changes/removes
>>>> an ioctl.
>>>
>>> Adding another ioctl in the future for cases we didn't think about
>>> earlier would of course be considered a workaround; and even though such
>>> things happen all the time, it's certainly something we'd like to avoid.
>>>
>>> However, we would also need to add another syscall in such cases, which
>>> is even worse IMO. So that's really not an argument against ioctls after
>>> all. What fundamental difference between a raw syscall and a ioctl,
>>> especially with regards to type safety, is there which would help us here?
>>
>> Type safety helps user-space application developers. System calls have
>> it, ioctl() does not.
> 
> This is simply not true. There is no type-safety in:
>     syscall(__NR_xyz, some, random, arguments)
> 
> The only way a syscall gets 'type-safe', is to provide a wrapper
> function. Same applies to ioctls. But people tend to not do that for
> ioctls, which is, again, not a technical argument against ioctls. It's
> a matter of psychology, though.

Yes, I see I wasn't quite clear enough. I should have said:

    Type safety helps user-space application developers. 
    *As typically provided to user-space via libc wrappers*,
    system calls have it, ioctl() does not.

And system call wrappers are generally provided pretty much automatically
by libcs (at least, mostly, there's some to-ing and fro-ing about this in
glibc-land these days as you are aware from the memfd_create() story;
http://thread.gmane.org/gmane.comp.lib.glibc.alpha/45884/focus=46937).

So, in practice user-space programmers typically automatically get type
safety with system calls, but not with ioctl().

> I still don't see a technical reason to use syscalls. API proposals welcome!
> We're now working on a small kdbus helper library, which provides
> type-safe ioctl wrappers, item-iterators and documented examples. But,
> like syscalls, nobody is forced to use the wrappers. The API design is
> not affected by this.
> 
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
> 
> Ok, working on that.
> 
>> * Some parts of the API not documented at all (various kdbus_item blobs)
> 
> All public structures have documentation in kdbus.h. It may need
> improvements, though.

Again -- that's very thin--one liners aand sentence fragments for the most 
part. (Not that I think that needs to be fixed, just that that doesn't
fit with my definition of "documented", which should be something like
what I've requested for kdbus.txt.)

>> * ABI changes happening even quite recently
> 
> Please elaborate why 'recent ABI-changes' are a sign of a premature API.
> 
> I seriously doubt any API can be called 'perfect'. On the contrary, I
> believe that all APIs could be improved continuously. The fact that
> we, at one point, settle on an API is an admission of
> backwards-compatibility. I in no way think it's a sign of
> 'perfection'.

I agree that no API is perfect. But some emerge from the starting gate 
in much better state than others. kdbus will likely be an important API,
and it's important that it's well designed one at the outset.

> With kdbus our plan is to give API-guarantees starting with upstream
> inclusion. We know, that our API will not be perfect, none is. But we
> will try hard to fix anything that comes up, as long as we can. And
> this effort will manifest in ABI-breaks.

Fair enough. My concern is that upstream inclusion is being rushed before
the API design can be well assessed.

>> * API oddities such as the 'kernel_flags' fields. Why do I need to
>>   be told what flags the kernel supports on *every* operation?
> 
> If we only returned EINVAL on invalid arguments, user-space had to
> probe for each flag to see whether it's supported. By returning the
> set of supported flags, user-space can cache those and _reliably_ know

(Not sure why you emphasize "reliably" here...)

> which flags are supported.
> We decided the overhead of a single u64 copy on each ioctl is
> preferred over a separate syscall/ioctl to query kernel flags. If you
> disagree, please elaborate (preferably with a suggestion how to do it
> better).

Well that's a quite unconventional design choice. Determining the set
of supported flags in an API is a one-time operation. The natural--and
I would say, *obviously* better--approach to this would be either the
traditional EINVAL approach or an API that is called once to retrieve 
the set of supported flags. Instead, kdbus clutters the APIs with a 
mostly unneeded extra piece of information on *every* call, and 
fractionally increases the run time, for no good reason.

Now, you might say that my suggested alternatives are not obviously
better. My response is that, at the very least, in the documentation
I'd expect to see this unconventional approach clearly highlighted 
and accompanied with a sound reason for choosing it. (Note: so far I 
still haven't actually seen a sound reason...)
 
>> The above is just after a day of looking hard at kdbus.txt. I strongly
>> suspect I'd find a lot of other issues if I spent more time on kdbus.
> 
> If you find the time, please do! Any hints how a specific part of the
> API could be done better, is highly appreciated. A lot of the more or
> less recent changes were done due to reviews from glib developers.

Could you point me at those reviews (mailing list archives?)?

So, I'm thinking about things such as the following:

* The odd choice of ioctl() as the API mechanism for what should become
  a key user-space API. (BTW, which other widely used IPC API ever
  took the approach of ioctl() as the mechanism?)

* Weak justifications for unconventional API design choices such
  as the 'kernel_flags' above.

* Thin documentation that doesn't provide nearly enough detail,
  has no worked examples of the use of the APIs (when it should 
  contain a multitude of such examples), and has no rationale 
  for the API design choices [1].

* An API design that consists of 16 ioctl() requests and 20+ 
  structures exchanged between user and kernel space being called 
  "simple". (Clearly it is not.)

Given a list of points like that, I worry that not nearly enough
thought has been put into design of the API, and certainly would be 
very concerned to think that it might be merged into mainline
in the near future. 

At this point, I think the onus is on the kdbus developers to 
provide strong evidence that they have a good API design, one that 
will well serve the needs of thousands of user-space programmers for
the next few decades. Such evidence would include at least:

  * Detailed documentation that fully described all facets of the API
  * A number of working, well documented example programs that start
    (very) simple, and ramp up to demonstrate more complex pieces
    of the API.
  * Documented rationale for API design choices.

To date, much of that sort of evidence is lacking, and I worry that
the job of proper API design will be left to someone else, someone
who devises a user-space library that provides a suitable 
abstraction on top of the current ioctl() API (but may be forced to
make design compromises because of design failings in the underlying
kernel API).

> More help is always welcome!

That's what I'm trying to do at the moment...

Cheers,

Michael


[1] Elsewhere in this thread, you've said that "with bus-proxy and 
    systemd we have two huge users of kdbus that put a lot of 
    pressure on API design." I would have expected that the results 
    of that pressure should be captured in documentation of the
    rationale for the API design. I haven't found any of that, 
    so far.

-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
