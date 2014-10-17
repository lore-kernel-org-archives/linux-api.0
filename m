From: John Stultz <john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] staging: android: binder: move to the "real" part of the kernel
Date: Thu, 16 Oct 2014 20:25:33 -0700
Message-ID: <CALAqxLXDZ4Q_C456o_A-V_LkcY=wpoC30kvNavyVaZRu7uK9fQ@mail.gmail.com>
References: <20141016124741.GA3832@kroah.com>
	<CALAqxLU05D8qQA47E77PiuuN7eVt66WEq1qn+PqdE-tpEUzFpw@mail.gmail.com>
	<20141016231221.GA13592@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20141016231221.GA13592-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Cc: lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Santosh Shilimkar <santosh.shilimkar-l0cyMroinI0@public.gmane.org>, =?UTF-8?B?QXJ2ZSBIasO4bm5ldsOlZw==?= <arve-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, Sumit Semwal <sumit.semwal-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Rebecca Schultz Zavin <rebecca-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, Christoffer Dall <christoffer.dall-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Anup Patel <anup.patel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Thu, Oct 16, 2014 at 4:12 PM, Greg Kroah-Hartman
<gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org> wrote:
> On Thu, Oct 16, 2014 at 10:09:04AM -0700, John Stultz wrote:
>> On Thu, Oct 16, 2014 at 5:47 AM, Greg Kroah-Hartman
>> <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org> wrote:
>> > From: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
>> >
>> > The Android binder code has been "stable" for many years now.  No matter
>>
>> Well, ignoring the ABI break that landed in the last year. :)
>
> As no one noticed, it wasn't a "break" :)
>
>> > This was discussed in the Android miniconf at the Plumbers conference.
>> > If anyone has any objections to this, please let me know, otherwise I'm
>> > queueing this up for 3.19-rc1
>>
>> So my main concerns/thoughts here are:
>>
>> Who is going to maintain this? Has Arve agreed?
>
> Do we really need someone to do more work that has been done on it in
> the past as an official "maintainer"?  I'll be glad to do it, as I doubt
> it will require any time at all.

Ok. The only caution I have if Arve isn't involved is that we have in
the past merged cleanup changes that introduced bugs, and it wasn't
until Arve took at look at the new kernel that these were sorted out
(see e194fd8a5d8e0a7eeed239a8534460724b62fe2d). So I think if at all
possible getting his ack on things would be good.

>> Are the Android guys comfortable with the ABI stability rules they'll
>> now face?
>
> Just because something is in staging, doesn't mean you don't have to
> follow the same ABI stability rules as the rest of the kernel.  If a
> change had happened to this code that broke userspace in the past, I
> would have reverted it.  So this should not be anything different from
> what has been happening inthe past.
>
> And the Android developers said they were happy to see this code move
> into the "real" part of the kernel.

Alright then.


>> Currently in the android space no one but libbinder should use the
>> kernel interface.
>
> That is correct.  If you do that, you deserve all of the pain and
> suffering and rooted machines you will get.

You reference this issue quite a bit, and I have a handwavy sense of
the problem, but do you have a more detailed link to the specific
issue here?


>> Can we enforce that no one use this interface out-side of android (To
>> ensure its one of those "if the abi breaks and no one notices..." edge
>> cases)?
>
> This is the kernel, we can not dictate "use", that's the good part of
> the GPLv2 :)
>
> Again, as no one has done this before, I strongly doubt it will happen
> in the future.

Well, the longer something is in the kernel, the more likely someone
will depend on it.


>> I'm still hopeful that a libbinder over kdbus will eventually pan out.
>> I still see having two core IPC mechanisms (even if the use cases are
>> different in style) as a negative, and I worry this might reduce
>> motivation to unify things at the lower level. Granted, such work can
>> still continue, but the incentives do change.
>
> Yes, things are going to change in the future, there is work happening
> here, and there was a presentation at Plumbers about what is going to be
> coming.
>
> But all of the changes will be in new code.  Be it kdbus, or something
> else if that doesn't work out.  This existing binder.c file will not be
> changing at all.  This existing ABI, and codebase, is something that we
> have to maintain forever for those millions of devices out there in the
> real world today.  So as there really is nothing left to do on it, it
> deserves to be in the main part of the kernel source tree.

Well, realistically, those millions of devices out there will almost
*never* get a kernel version bump

But yes, I'm fine with it going in. I'm just a bit surprised at how
quickly thoughts change here.

This does raise the question if the same standard could be held to
ashmem then? That's a *much* simpler and easier to maintain chunk of
code, and is just as isolated, logic wise.  And while I think it would
be ideal if the unpinning feature could be done more generically, if
volatile ranges really doesn't have a future, then its maybe silly to
hold ashmem out as well?

thanks
-john
