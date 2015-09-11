From: =?UTF-8?Q?Andreas_Gr=C3=BCnbacher?= <andreas.gruenbacher-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC v7 10/41] richacl: Permission check algorithm
Date: Sat, 12 Sep 2015 00:12:16 +0200
Message-ID: <CAHpGcMJofUKKumcUe=6LOFZrVcJRM5APchbCQpfQzbMK7N1FYg@mail.gmail.com>
References: <1441448856-13478-1-git-send-email-agruenba@redhat.com>
	<1441448856-13478-11-git-send-email-agruenba@redhat.com>
	<20150911211617.GF11677@fieldses.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150911211617.GF11677-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>
Cc: Andreas Gruenbacher <agruenba-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux FS-devel Mailing List <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API Mailing List <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, LSM List <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

2015-09-11 23:16 GMT+02:00 J. Bruce Fields <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>:
> On Sat, Sep 05, 2015 at 12:27:05PM +0200, Andreas Gruenbacher wrote:
>> +             /*
>> +              * Apply the group file mask to entries other than owner@ and
>> +              * everyone@ or user entries matching the owner.  This ensures
>> +              * that we grant the same permissions as the acl computed by
>> +              * richacl_apply_masks().
>> +              *
>> +              * Without this restriction, the following richacl would grant
>> +              * rw access to processes which are both the owner and in the
>> +              * owning group, but not to other users in the owning group,
>> +              * which could not be represented without masks:
>> +              *
>> +              *  owner:rw::mask
>> +              *  group@:rw::allow
>> +              */
>> +             if ((acl->a_flags & RICHACL_MASKED) && richace_is_allow(ace))
>> +                     ace_mask &= acl->a_group_mask;
>
> I'm having trouble understanding this.  I think the problem is that I
> don't really understand the notation in your example.  Is a_group_mask
> zero in that example?  I think it must be, in which case, OK I think I
> get it.

Yes. I'm not sure if the example becomes easier to understand when the
empty group mask and perhaps also the other mask is included.

> (Though I still have to think about it a little more to convince myself
> that richacl_apply_masks() always gets the same result.)

I have tried to break the algorithm into digestible pieces. Do you see
another way to make things easier to understand?

Thanks,
Andreas
