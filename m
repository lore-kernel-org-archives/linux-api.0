From: Andreas Gruenbacher <agruenba-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC v6 08/40] richacl: Compute maximum file masks from an acl
Date: Wed, 2 Sep 2015 22:38:34 +0200
Message-ID: <CAHc6FU59RmihddjZ6vmTxDN4t+QqW-d37i1iH7Wh0xeqvjcq-g@mail.gmail.com>
References: <1438689218-6921-1-git-send-email-agruenba@redhat.com>
	<1438689218-6921-9-git-send-email-agruenba@redhat.com>
	<20150902195408.GC3319@fieldses.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150902195408.GC3319-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>
Cc: Andreas Gruenbacher <andreas.gruenbacher-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

2015-09-02 21:54 GMT+02:00 J. Bruce Fields <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>:
>> +     richacl_for_each_entry_reverse(ace, acl) {
>> +             if (richace_is_inherit_only(ace))
>> +                     continue;
>> +
>> +             if (richace_is_owner(ace) ||
>> +                 (richace_is_unix_user(ace) &&
>> +                  uid_eq(ace->e_id.uid, owner))) {
>> +                     if (richace_is_allow(ace))
>> +                             acl->a_owner_mask |= ace->e_mask;
>> +                     else if (richace_is_deny(ace))
>> +                             acl->a_owner_mask &= ~ace->e_mask;
>> +             } else if (richace_is_everyone(ace)) {
>> +                     if (richace_is_allow(ace)) {
>> +                             acl->a_owner_mask |= ace->e_mask;
>> +                             acl->a_group_mask |= ace->e_mask & gmask;
>> +                             acl->a_other_mask |= ace->e_mask;
>> +                     } else if (richace_is_deny(ace)) {
>> +                             acl->a_owner_mask &= ~ace->e_mask;
>> +                             acl->a_group_mask &= ~ace->e_mask;
>> +                             acl->a_other_mask &= ~ace->e_mask;
>> +                     }
>> +             } else {
>> +                     if (richace_is_allow(ace)) {
>> +                             acl->a_owner_mask |= ace->e_mask & gmask;
>> +                             acl->a_group_mask |= ace->e_mask & gmask;
>
> I think we do that because we don't (we can't) know whether the owner
> might match this ace, so we assume that it will match, as that's what
> gives us the maximum.

Yes.

> But on first glance this is a little counterintuitive and maybe worth a
> comment.

I agree.

Thanks,
Andreas
