From: David Herrmann <dh.herrmann-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 01/13] kdbus: add documentation
Date: Tue, 27 Jan 2015 16:05:20 +0100
Message-ID: <CANq1E4SkHhs1pWUe-TzG7bzk1M-Q++mB2vmQGuYx0RMF53wg4Q@mail.gmail.com>
References: <1421435777-25306-1-git-send-email-gregkh@linuxfoundation.org>
	<1421435777-25306-2-git-send-email-gregkh@linuxfoundation.org>
	<54BE5DC8.70706@gmail.com>
	<54BE9D08.7010804@zonque.org>
	<54BF805B.4000609@gmail.com>
	<54BFDAAA.50203@zonque.org>
	<54C0CE8A.5080805@gmail.com>
	<CANq1E4S=3qNw599L85uj-8aXwxeV+mcurB_Nu_rHH8opAeePjw@mail.gmail.com>
	<54C10DDC.9000503@gmail.com>
	<20150123160854.GA5210@kroah.com>
	<54C65346.5070504@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <54C65346.5070504-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Austin S Hemmelgarn <ahferroin7-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Daniel Mack <daniel-cYrQPVfZoowdnm+yROfE0A@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, One Thousand Gnomes <gnomes-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>, Tom Gundersen <teg-B22kvLQNl6c@public.gmane.org>, Theodore T'so <tytso-3s7WtUTddSA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Djalal Harouni <tixxdz-Umm1ozX2/EEdnm+yROfE0A@public.gmane.org>, Johannes Stezenbach <js-FF7aIK3TAVNeoWH0uzbU5w@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hi

On Mon, Jan 26, 2015 at 3:46 PM, Michael Kerrisk (man-pages)
<mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> Hello Greg,
>
> On 01/23/2015 05:08 PM, Greg Kroah-Hartman wrote:
>> On Thu, Jan 22, 2015 at 09:49:00AM -0500, Austin S Hemmelgarn wrote:
>>> While I agree that there should be a way for userspace to get the l=
ist of
>>> supported operations, userspace apps will only actually care about =
that
>>> once, when they begin talking to kdbus, because (ignoring the live =
kernel
>>> patching that people have been working on recently) the list of sup=
ported
>>> operations isn't going to change while the system is running.  Whil=
e a u64
>>> copy has relatively low overhead, it does have overhead, and that i=
s very
>>> significant when you consider part of the reason some people want k=
dbus is
>>> for the performance gain.  Especially for those automotive applicat=
ions that
>>> have been mentioned which fire off thousands of messages during sta=
rt-up,
>>> every little bit of performance is significant.
>>
>> A single u64 in a structure is not going to be measurable at all,
>> processors just copy memory too fast these days for 4 extra bytes to=
 be
>> noticable.
>
> It depends on the definition of measurable, I suppose, but this state=
ment
> appears incorrect to me. In some cases (e.g., kdbus_msg_info) we're t=
alking
> about *two* u64 fields (kernel_gs, kernel_msg_flags) being used to pa=
ss back
> sets of valid flags. That's 16 bytes, and it definitely makes a diffe=
rence.
> Simply running a loop that does a naive memcpy() in a tight user-spac=
e
> loop (code below), I see the following for the execution of 1e9 loops=
:
>
>     Including the two extra u64 fields: 3.2 sec
>     Without the two extra u64 fields:   2.6 sec
>
> On the same box, doing 1e9 calls to getppid() (i.e., pretty much the
> simplest syscall, giving us a rough measure of the context switch) ta=
kes
> 68 seconds. In other words, the cost of copying those 16 bytes is abo=
ut 1%
> of the base context switch/syscall cost. I assume the costs of copyin=
g
> those 16 bytes across the kernel-user-space boundary would not be che=
aper,
> but have not tested that. If my assumption is correct, then 1% seems =
a
> significant figure to me in an API whose raison d'=C3=AAtre is speed.

I have no idea how this is related to any kdbus ioctl?

A 16byte copy does not affect the performance of kdbus message
transactions in any way that matters.

>> So let's make this as easy as possible for userspace, making
>> it simpler logic there, which is much more important than saving
>> theoretical time in the kernel.
>
> But this also missed the other part of the point. Copying these field=
s on
> every operation, when in fact they are only needed once, clutters the=
 API,
> in my opinion. Good APIs are as simple as they can be to do their job=
=2E
> Redundancy is an enemy of simplicity. Simplest would have been a one =
time
> API that returns a structure containing all of the supported flags ac=
ross
> the API. Alternatively, the traditional EINVAL approach is well under=
stood,
> and suffices.

We're going to drop "kernel_flags" in favor of a new
KDBUS_FLAG_NEGOTIATE flag which asks the kernel to do feature
negotiation for this ioctl and return the supported flags/items inline
(overwriting the passed data). The ioctl will not be executed and will
not affect the state of the FD.
I hope this keeps the API simple.

Thanks
David
