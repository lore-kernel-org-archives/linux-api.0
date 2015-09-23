From: =?UTF-8?Q?Andreas_Gr=C3=BCnbacher?= <andreas.gruenbacher-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC v7 24/41] richacl: Set the other permissions to the other mask
Date: Wed, 23 Sep 2015 16:12:42 +0200
Message-ID: <CAHpGcMJMgtqGDsxUYFXqVmenaLxdJHL3VO8byV0GtSkdrQMggw@mail.gmail.com>
References: <1441448856-13478-1-git-send-email-agruenba@redhat.com>
	<1441448856-13478-25-git-send-email-agruenba@redhat.com>
	<20150923140307.GB27083@fieldses.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150923140307.GB27083-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>
Cc: Andreas Gruenbacher <agruenba-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux FS-devel Mailing List <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API Mailing List <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, LSM List <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

2015-09-23 16:03 GMT+02:00 J. Bruce Fields <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>:
> On Sat, Sep 05, 2015 at 12:27:19PM +0200, Andreas Gruenbacher wrote:
>> +static int
>> +richacl_set_other_permissions(struct richacl_alloc *alloc)
>> +{
>> +     struct richacl *acl = alloc->acl;
>> +     unsigned int x = RICHACE_POSIX_ALWAYS_ALLOWED;
>> +     unsigned int other_mask = acl->a_other_mask & ~x;
>> +     struct richace *ace = acl->a_entries + acl->a_count - 1;
>> +
>> +     if (!(other_mask &&
>> +           (acl->a_flags & RICHACL_WRITE_THROUGH) &&
>> +           (acl->a_flags & RICHACL_MASKED)))
>> +             return 0;
>
> By the way, I think this is only called after checking MASKED--so the
> MASKED check here could be a WARN_ON, or could just be dropped.  Ditto
> for the following patch.

Hmm, yes. I'll drop that.

Thanks,
Andreas
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
