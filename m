From: Andreas Gruenbacher <agruenba-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC v7 22/41] richacl: Propagate everyone@ permissions to other aces
Date: Tue, 22 Sep 2015 01:44:21 +0200
Message-ID: <CAHc6FU5QD04bw53mX=pVGmnz2v-w6EhmLftc-OHm_Gnkm2_u-A@mail.gmail.com>
References: <1441448856-13478-1-git-send-email-agruenba@redhat.com>
	<1441448856-13478-23-git-send-email-agruenba@redhat.com>
	<20150918213611.GC22671@fieldses.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150918213611.GC22671-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andreas Gruenbacher <agruen-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

2015-09-18 23:36 GMT+02:00 J. Bruce Fields <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>:
> On Sat, Sep 05, 2015 at 12:27:17PM +0200, Andreas Gruenbacher wrote:
>> +     if (!richace_is_owner(who) &&
>> +         richace_is_everyone(ace) && richace_is_allow(ace) &&
>
> That richace_is_allow(ace) check is redundant at this point, isn't it?

Yes, I'll change that.

>> +         !(allow & ~(ace->e_mask & acl->a_other_mask)))
>
> Uh, I wish C had a subset-of operator, that construct took me longer to
> work out than I should admit.
>
>> +             allow = 0;
>> +
>> +     if (allow) {
>> +             if (allow_last)
>> +                     return richace_change_mask(alloc, &allow_last,
>> +                                                allow_last->e_mask | allow);
>> +             else {
>> +                     struct richace who_copy;
>> +
>> +                     richace_copy(&who_copy, who);
>> +                     ace = acl->a_entries + acl->a_count - 1;
>
> Isn't ace already set to the last ace?

Yes indeed, that line can also go.

Thanks,
Andreas
