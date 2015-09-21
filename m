From: Andreas Gruenbacher <agruenba-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC v7 13/41] richacl: Check if an acl is equivalent to a file mode
Date: Tue, 22 Sep 2015 01:26:58 +0200
Message-ID: <CAHc6FU4W30vkDfjnh-a5dyi1vHBavmqa2Yt5Jn29AQn9FwHq_g@mail.gmail.com>
References: <1441448856-13478-1-git-send-email-agruenba@redhat.com>
	<1441448856-13478-14-git-send-email-agruenba@redhat.com>
	<20150917182219.GB13825@fieldses.org>
	<20150918005607.GB16699@fieldses.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150918005607.GB16699-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

2015-09-18 2:56 GMT+02:00 J. Bruce Fields <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>:
> On Thu, Sep 17, 2015 at 02:22:19PM -0400, bfields wrote:
>> On Sat, Sep 05, 2015 at 12:27:08PM +0200, Andreas Gruenbacher wrote:
>> > ACLs are considered equivalent to file modes if they only consist of
>> > owner@, group@, and everyone@ entries, the owner@ permissions do not
>> > depend on whether the owner is a member in the owning group, and no
>> > inheritance flags are set.  This test is used to avoid storing richacls
>> > if the acl can be computed from the file permission bits.
>>
>> We're assuming here that it's OK for us to silently rearrange an ACL as
>> long as the result is still equivalent (in the sense that the permission
>> algorithm would always produce the same result).
>>
>> I guess that's OK by me, but it might violate user expectations in some
>> simple common cases, so may be worth mentioning in documentation
>> someplace if we don't already.
>
> Also your notion of mode-equivalence here is interesting, it's actually
> a strict subset of the ACLs that produce the same permission results as
> a mode.  (For example, everyone:rwx,bfields:rwx is equivalent to 0777
> but won't be considered mode-equivalent by this algorithm.)

Yes, the algorithm should better not surprise the user by being too clever.

> I think the choices you've made probably make the most sense, they just
> wouldn't have been obvious to me.  Anyway, so, OK by me:
>
>         Reviewed-by: J. Bruce Fields <bfields-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Thanks,
Andreas
