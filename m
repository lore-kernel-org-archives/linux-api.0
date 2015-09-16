From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [PATCH 6/7] [RFC] [media]: v4l2: introduce v4l2_timeval
Date: Wed, 16 Sep 2015 08:51:14 +0200
Message-ID: <55F91162.8030002@xs4all.nl>
References: <1442332148-488079-1-git-send-email-arnd@arndb.de> <1442332148-488079-7-git-send-email-arnd@arndb.de> <55F846E7.2040006@xs4all.nl> <2432018.5rA5LXfiBo@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-media-owner@vger.kernel.org>
In-Reply-To: <2432018.5rA5LXfiBo@wuerfel>
Sender: linux-media-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org, y2038@lists.linaro.org, Mauro Carvalho Chehab <mchehab@osg.samsung.com>, linux-api@vger.kernel.org, linux-samsung-soc@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On 09/15/2015 10:26 PM, Arnd Bergmann wrote:
> On Tuesday 15 September 2015 18:27:19 Hans Verkuil wrote:
>> On 09/15/2015 05:49 PM, Arnd Bergmann wrote:
>>> The v4l2 API uses a 'struct timeval' to communicate time stamps to user
>>> space. This is broken on 32-bit architectures as soon as we have a C library
>>> that defines time_t as 64 bit, which then changes the structure layout of
>>> struct v4l2_buffer.
>>>
>>> Fortunately, almost all v4l2 drivers use monotonic timestamps and call
>>> v4l2_get_timestamp(), which means they don't also have a y2038 problem.
>>> This means we can keep using the existing binary layout of the structure
>>> and do not need to worry about defining a new kernel interface for
>>> userland with 64-bit time_t.
>>>
>>> A possible downside of this approach is that it breaks any user space
>>> that tries to assign the timeval structure returned from the kernel
>>> to another timeval, or to pass a pointer to it into a function that
>>> expects a timeval. Those will cause a build-time warning or error
>>> that can be fixed up in a backwards compatible way.
>>>
>>> The alternative to this patch is to leave the structure using
>>> 'struct timeval', but then we have to rework the kernel to let
>>> it handle both 32-bit and 64-bit time_t for 32-bit user space
>>> processes.
>>
>> Cool. Only this morning I was thinking about what would be needed in v4l2
>> to be y2038 safe, and here it is!
> 
> Nice!
> 
> fwiw, I also have a list of drivers at
> https://docs.google.com/spreadsheets/d/1HCYwHXxs48TsTb6IGUduNjQnmfRvMPzCN6T_0YiQwis/edit?usp=sharing
> which lists all known files that still need changing, in case you are
> wondering what else needs to be done, though it currently only covers
> things that nobody so far has started working on, and I have a couple
> patches on my disk that need polishing (I pushed out the v4l2 portion
> of that as a start)

I just *thought* about it, I never said I would do it! :-)

> 
>>> @@ -839,7 +845,7 @@ struct v4l2_buffer {
>>>  	__u32			bytesused;
>>>  	__u32			flags;
>>>  	__u32			field;
>>> -	struct timeval		timestamp;
>>> +	struct v4l2_timeval	timestamp;
>>>  	struct v4l2_timecode	timecode;
>>>  	__u32			sequence;
>>>  
>>>
>>
>> I suspect that quite a few apps use assign the timestamp to another timeval
>> struct. A quick grep in v4l-utils (which we maintain) shows at least two of
>> those assignments. Ditto for xawtv3.
> 
> Ok, that is very helpful information, thanks for finding that!
> 
>> So I don't think v4l2_timeval is an option as it would break userspace too badly.
> 
> Agreed, we definitely don't want to break building user space with
> existing environments, i.e. 64-bit architectures, or 32-bit architectures
> with 32-bit time_t.
> 
>> An alternative to supporting a 64-bit timeval for 32-bit userspace is to make a
>> new y2038-aware struct and a new set of ioctls and use this opportunity to clean
>> up and extend the v4l2_buffer struct.
>>
>> So any 32-bit app that needs to be y2038 compliant would just use the new
>> struct and ioctls.
>>
>> But this is something to discuss among the v4l2 developers.
> 
> Ok. We generally to require as few source level changes to user space
> as possible for the conversion, and we want to make sure that when
> using a 32-bit libc with 64-bit time_t, we don't accidentally get
> broken interfaces (i.e. we should get a compile error whenever we
> can't get it right automatically).
> 
> One aspect that makes v4l2_buffer special is that the binary format
> is already clean for y2038 (once patch 4/7 "exynos4-is: use monotonic
> timestamps as advertized" gets merged), and we only need to worry about
> what happens when user space disagrees about the size of timeval.
> 
> Let me describe the options that I can think of here:
> 
> a) Similar to my first attempt, define a new struct v4l2_timeval, but
>    only use it when building with a y2038-aware libc, so we don't break
>    existing environments:
> 
> 	/* some compile-time conditional that we first need to agree on with libc */
> 	#if __BITS_PER_TIME_T > __BITS_PER_LONG
> 	struct v4l2_timeval { long tv_sec; long tv_usec; }
> 	#else
> 	#define v4l2_timeval timeval
> 	#endif
> 
>    This means that any user space that currently assumes the timestamp
>    member to be a 'struct timeval' has to be changed to access the members
>    individually, or get a build error.
>    The __BITS_PER_TIME_T trick has to be used in a couple of other subsystems
>    too, as some of them have no other way to identify an interface

I don't like this as this means some applications will compile on 64 bit or
with a non-y2038-aware libc, but fail on a 32-bit with y2038-aware libc. This
will be confusing and it may take a long time before the application developer
discovers this.

> b) Keep the header file unchanged, but deal with both formats of v4l2_buffer
>    in the kernel. Fortunately, all ioctls that pass a v4l2_buffer have
>    properly defined command codes, and it does not get passed using a
>    read/write style interface. This means we move the v4l2_buffer32
>    handling from v4l2-compat-ioctl32.c to v4l2-ioctl.c and add an in-kernel
>    v4l2_buffer64 that matches the 64-bit variant of v4l2_buffer.
>    This way, user space can use either definition of time_t, and the
>    kernel will just handle them natively.
>    This is going to be the most common way to handle y2038 compatibility
>    in device drivers, and it has the additional advantage of simplifying
>    the compat path.

This would work.

> c) As you describe above, introduce a new v4l2_buffer replacement with
>    a different layout that does not reference timeval. For this case, I
>    would recommend using a single 64-bit nanosecond timestamp that can
>    be generated using ktime_get_ns().
>    However, to avoid ambiguity with the user space definition of struct
>    timeval, we still have to hide the existing 'struct v4l2_buffer' from
>    y2038-aware user space by enclosing it in '#if __BITS_PER_TIME_T > 
>    __BITS_PER_LONG' or similar.

Right, and if we do that we still have the problem I describe under a). So we
would need to implement b) regardless.

In other words, choosing c) doesn't depend on y2038 and it should be decided
on its own merits.

I've proposed this as a topic to the media workshop we'll have during the Linux
Kernel Summit.

Regards,

	Hans
