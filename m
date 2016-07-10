From: ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org (Eric W. Biederman)
Subject: Re: [CRIU] Introspecting userns relationships to other namespaces?
Date: Sun, 10 Jul 2016 15:29:47 -0500
Message-ID: <87furhjkxw.fsf@x220.int.ebiederm.org>
References: <c2a26220-69f2-f2f5-491a-e43abd9a6f92@gmail.com>
	<87r3b7pxja.fsf@x220.int.ebiederm.org>
	<CAKgNAkgQbxLH-B3N3Xti3LLis+1Y-SJD2h1DEaXao7zTDA7pug@mail.gmail.com>
	<20160706141348.GB20728@mail.hallyn.com>
	<CAKgNAkhtQNg0mVv6ei_JigNz3njo_G3opE+rzd4OtKpa2hQe9g@mail.gmail.com>
	<20160707133631.GA2994@mail.hallyn.com>
	<1467903712.2347.16.camel@HansenPartnership.com>
	<20160709031528.GA25507@odin.tremily.us>
	<87ziprmrln.fsf@x220.int.ebiederm.org>
	<20160710053609.GB4868@outlook.office365.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160710053609.GB4868-1ViLX0X+lBJGNQ1M2rI3KwRV3xvJKrda@public.gmane.org> (Andrew Vagin's
	message of "Sat, 9 Jul 2016 22:36:11 -0700")
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrew Vagin <avagin-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Cc: "W. Trevor King" <wking-vJI2gpByivqcqzYg7KEe8g@public.gmane.org>, criu-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Andrew Vagin <avagin-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org> writes:

> On Fri, Jul 08, 2016 at 10:13:08PM -0500, Eric W. Biederman wrote:
>> "W. Trevor King" <wking-vJI2gpByivqcqzYg7KEe8g@public.gmane.org> writes:
>> 
>> > On Thu, Jul 07, 2016 at 08:01:52AM -0700, James Bottomley wrote:
>> >> In theory, we could get nsfs to show this information as an option
>> >> (just add a show_options entry to the superblock ops), but the
>> >> problem is that although each namespace has a parent user_ns,
>> >> there's no way to get it without digging in the namespace specific
>> >> structure.  Probably we should restructure to move it into
>> >> ns_common, then we could display it (and enforce all namespaces
>> >> having owning user_ns) but it would be a reasonably large (but
>> >> mechanical) change.
>> >
>> > It sounds like everyone is either positive or or neutral on this
>> > groundwork, even if we haven't decided if/how to expose the
>> > information to userspace.  I'm happy to work up a patch while the rest
>> > of the discussion continues.  I'm also happy to let someone else work
>> > up the patch, if anyone else is chomping at the bit ;).
>> 
>> I am dubious on moving all of the user namespace members into ns_common.
>> 
>> I would happy to be proved wrong but I suspect in the cases where we
>> actually use that user namespace the code will become uglier.  Making
>> the ordinary uses uglier to make a rare corner case nicer is the wrong
>> trade off.
>> 
>> But feel free to try it is certainly worth doing if it doesn't make the
>> code that uses the user namespaces uglier.
>
> If it's interesting for someone, I have this patch in my tree
> https://github.com/avagin/linux-task-diag/commit/63b32df68ae8d3a3842bae42bbcae3468db76d85
>
> I can't say that it makes something uglier.

I have only skimmed things but overall it looks better than I had
feared.

At the same time I really really don't like losing the parent pointer in
the user namespace case.  That is seriously obfuscating.

Eric
