From: Andreas Gruenbacher <agruenba-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC v7 22/41] richacl: Propagate everyone@ permissions to other aces
Date: Wed, 23 Sep 2015 03:24:29 +0200
Message-ID: <CAHc6FU5Ug3rN2-znFeABpdn+LCHgvzOnSRB4BCepNS6mToJVZg@mail.gmail.com>
References: <1441448856-13478-1-git-send-email-agruenba@redhat.com>
	<1441448856-13478-23-git-send-email-agruenba@redhat.com>
	<20150918215611.GD22671@fieldses.org>
	<20150921192441.GA12968@fieldses.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150921192441.GA12968-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andreas Gruenbacher <agruen-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

2015-09-21 21:24 GMT+02:00 J. Bruce Fields <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>:
> On Fri, Sep 18, 2015 at 05:56:11PM -0400, bfields wrote:
>> On Sat, Sep 05, 2015 at 12:27:17PM +0200, Andreas Gruenbacher wrote:
>> > +   /*
>> > +    * If the owner mask contains permissions which are not in the group
>> > +    * mask, the group mask contains permissions which are not in the other
>> > +    * mask, or the owner class contains permissions which are not in the
>>
>> s/owner class/owner mask?
>>
>> > +    * other mask, we may need to propagate permissions up from the
>> > +    * everyone@ allow ace.  The third condition is implied by the first
>> > +    * two.
>> > +    */
>> > +   if (!((acl->a_owner_mask & ~acl->a_group_mask) ||
>> > +         (acl->a_group_mask & ~acl->a_other_mask)))
>> > +           return 0;
>>
>> The code looks right, but I don't understand the preceding comment.
>>
>> For example,
>>
>>       owner mask: rw
>>       group mask:  wx
>>       other mask: rw
>>
>> satisfies the first two conditions, but not the third.
>>
>> Also, I don't understand why the first condition would imply that we
>> might need to propagate permissions.
>
> OK, maybe I get the part about the owner mask containing permissions
> not in the group mask: we'll need to insert a deny ace for the bits in
> the other mask but not in the group mask, and then we'll need an allow
> ace for the owner to get those bits back.  I think?

That is indeed the reason, and it also seems clear that this wasn't
documented well enough. Let me remove the offending comment and tiny
optimization, and add better comments instead.

>> > +                   if (richace_is_allow(ace) || richace_is_deny(ace)) {
>
> The v4 spec allows aces other than allow and deny aces (audit and
> alarm), but I didn't think you were implementing those.

Right, I don't see that happening. I'll remove that as well.

Thanks,
Andreas
