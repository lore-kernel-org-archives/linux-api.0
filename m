From: ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org (Eric W. Biederman)
Subject: Re: [PATCHv3 8/8] cgroup: Add documentation for cgroup namespaces
Date: Wed, 07 Jan 2015 16:14:40 -0600
Message-ID: <87bnma6xwv.fsf@x220.int.ebiederm.org>
References: <1417744550-6461-9-git-send-email-adityakali@google.com>
	<548E17CE.8010704@nod.at>
	<CAGr1F2HA6mzFwgp5ngX8P7=198-5CmCjLmuCJ8j3eQ08J2d9Qw@mail.gmail.com>
	<54AB15BD.8020007@nod.at> <87lhlgpyxk.fsf@x220.int.ebiederm.org>
	<CAGr1F2HSi_D07r2c5CKOsjSR1+58k9G2MrtACsd+HV6XKvJ7cA@mail.gmail.com>
	<54AB2992.6060707@nod.at>
	<CAGr1F2EGOUSEd3-G4PS0mq=9kU1nWG4CwHUOQaNUATepc11_Sw@mail.gmail.com>
	<54ACFC38.5070007@nod.at> <87fvbmir9q.fsf@x220.int.ebiederm.org>
	<20150107193059.GA1857@mail.hallyn.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150107193059.GA1857-7LNsyQBKDXoIagZqoN9o3w@public.gmane.org> (Serge E. Hallyn's
	message of "Wed, 7 Jan 2015 20:30:59 +0100")
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>
Cc: Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, Serge Hallyn <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>, "linux-kernel@vger.kernel.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups mailinglist <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

"Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org> writes:

>>   By unified hierarchy I mean that  every mount of cgroupfs has the
>> same directories with the same processes in each directory.
>
> No, my reading of Documentation/cgroups/unified-hierarchy.txt is that
> unified hierarchy means that all (sane) controllers are co-mounted into
> one hierarchy.

I see what you mean.  If it is indeed the case than a mount of cgroupfs
using the unified hiearchy and can not specify which controllers are
present under that mount that very significant bug and presents a very
significant regression in user space flexibility.

I think you can still mount the unified hierarchy and select which
controls you want to see.  If you can not that is a change significantly
past what was agreed to and a regression fix needs to be applied.

With a unified hierarchy and separate controllers per mount many cgroup
using applications will continue to work as before without changes, or
with minimal changes.  That is what was agreed to and what I expect has
been actually implemented and it is what needs to be implemented in any
case.

I will see about making time to see where things are really at.

Eric
