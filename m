From: ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org (Eric W. Biederman)
Subject: Re: [PATCH 0/5 RFC] Add an interface to discover relationships between namespaces
Date: Mon, 25 Jul 2016 10:17:15 -0500
Message-ID: <87y44pd9xg.fsf@x220.int.ebiederm.org>
References: <1468520419-28220-1-git-send-email-avagin@openvz.org>
	<c9bdaf3d-ec93-d754-81ac-9f524a0d0954@gmail.com>
	<20160721210650.GA10989@outlook.office365.com>
	<1515f5f2-5a49-fcab-61f4-8b627d3ba3e2@gmail.com>
	<CANaxB-w8H8Wo8FmtmBBZTpJX-ZDGRQx0rbm9E5c9WbduQ_Ukmw@mail.gmail.com>
	<e2811bf1-4b86-e115-bcdb-301d6f2546eb@gmail.com>
	<87lh0pg8jx.fsf@x220.int.ebiederm.org>
	<44ca0e41-dc92-45b1-2a6c-c41a048a072d@gmail.com>
	<20160725145445.GA19879@mail.hallyn.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160725145445.GA19879-7LNsyQBKDXoIagZqoN9o3w@public.gmane.org> (Serge E. Hallyn's
	message of "Mon, 25 Jul 2016 09:54:45 -0500")
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>
Cc: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Andrew Vagin <avagin-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, "criu@openvz.org" <criu-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, James Bottomley <James.Bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, Andrey Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

"Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org> writes:

> Quoting Michael Kerrisk (man-pages) (mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org):
>> Hi Eric,
>> 
>> On 07/25/2016 03:18 PM, Eric W. Biederman wrote:
>> >"Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> writes:
>> >
>> >>Hi Andrey,
>> >>
>> >>On 07/22/2016 08:25 PM, Andrey Vagin wrote:
>> >>Perhaps add "and the caller does not have CAP_SYS_ADMIN" in the initial
>> >>user namespace"?
>> >
>> >Having looked at that bit of code I don't think capabilities really
>> >have a role to play.
>> 
>> Yes, I caught up with that now. I await to see how this plays out
>> in the next patch version.
>
> Thanks - that had caught my eye but I hadn't had time to look into the
> justification for this.  Hiding this kind of thing indeed seems wrong to
> me, unless there is a really good justification for it, i.e. a way
> to use that info in an exploit.

To avoid breaking checkpoint/restart we need to limit information to the
namespaces the caller is a member of for the user and pid namespaces.

This roughly duplicates the parentage checks in ns_capable.

Conceptually this is the same as limiting .. in a chroot environment.

Eric
