From: Andreas Gruenbacher <agruenba-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC v7 14/41] richacl: Create-time inheritance
Date: Mon, 21 Sep 2015 22:37:25 +0200
Message-ID: <CAHc6FU4kK5fj6Xgyb1vPsnsQ079EpTfkxYC6XAiT1vEQvikBrw@mail.gmail.com>
References: <1441448856-13478-1-git-send-email-agruenba@redhat.com>
	<1441448856-13478-15-git-send-email-agruenba@redhat.com>
	<20150918175840.GA21506@fieldses.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150918175840.GA21506-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

2015-09-18 19:58 GMT+02:00 J. Bruce Fields <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>:
> On Sat, Sep 05, 2015 at 12:27:09PM +0200, Andreas Gruenbacher wrote:
>> +                     if (dir_ace->e_flags & RICHACE_NO_PROPAGATE_INHERIT_ACE)
>> +                             ace->e_flags &= ~RICHACE_INHERITANCE_FLAGS;
>> +                     else if ((dir_ace->e_flags & RICHACE_FILE_INHERIT_ACE) &&
>> +                              !(dir_ace->e_flags & RICHACE_DIRECTORY_INHERIT_ACE))
>
> The FILE_INHERIT_ACE check there is redundant since we already know
> dir_ace is inheritable.
>
> (So, OK, it isn't wrong to check it again but let's not make this
> condition any more complicated than necessary.)

Indeed, we can turn it into:

        if (dir_ace->e_flags & RICHACE_NO_PROPAGATE_INHERIT_ACE)
                ace->e_flags &= ~RICHACE_INHERITANCE_FLAGS;
        else if (!(dir_ace->e_flags & RICHACE_DIRECTORY_INHERIT_ACE))
                ace->e_flags |= RICHACE_INHERIT_ONLY_ACE;

>> +static struct richacl *
>> +richacl_inherit_inode(const struct richacl *dir_acl, struct inode *inode)
>> +{
>> +     struct richacl *acl;
>> +     mode_t mask;
>> +
>> +     acl = richacl_inherit(dir_acl, S_ISDIR(inode->i_mode));
>> +     if (acl) {
>> +             mask = inode->i_mode;
>> +             if (richacl_equiv_mode(acl, &mask) == 0) {
>> +                     richacl_put(acl);
>> +                     acl = NULL;
>
> Why is it correct to ignore entirely the inherited acl in this case?
>
> Oh, I see, I'm forgetting that richacl_equiv_mode is setting the mask,
> which will get applied at the end of this function.  In my defense,
> maybe it's easy to overlook a side effect in an if condition.... But I
> don't have a better idea.  OK.

Yes. I'll leave that as it is.

> So, nits aside:
>
>         Reviewed-by: J. Bruce Fields <bfields-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Thanks,
Andreas
