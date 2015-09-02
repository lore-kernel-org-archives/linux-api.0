From: Andreas Gruenbacher <agruenba-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC v6 02/40] vfs: Add MAY_CREATE_FILE and MAY_CREATE_DIR
 permission flags
Date: Wed, 2 Sep 2015 21:06:32 +0200
Message-ID: <CAHc6FU62LQ8xnEbjsBprnud36AURg_ggifFoHOVM51-9vRJeDg@mail.gmail.com>
References: <1438689218-6921-1-git-send-email-agruenba@redhat.com>
	<1438689218-6921-3-git-send-email-agruenba@redhat.com>
	<20150902185300.GA3319@fieldses.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150902185300.GA3319-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>
Cc: Andreas Gruenbacher <andreas.gruenbacher-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

2015-09-02 20:53 GMT+02:00 J. Bruce Fields <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>:
>> @@ -453,7 +453,8 @@ static int sb_permission(struct super_block *sb, struct inode *inode, int mask)
>>   * this, letting us set arbitrary permissions for filesystem access without
>>   * changing the "normal" UIDs which are used for other things.
>>   *
>> - * When checking for MAY_APPEND, MAY_WRITE must also be set in @mask.
>> + * When checking for MAY_APPEND, MAY_CREATE_FILE, MAY_CREATE_DIR,
>> + * MAY_WRITE must also be set in @mask.
>
> Why?

So that file systems that don't support MAY_APPEND can ignore the flag
and will then automatically check for MAY_WRITE instead.

> (Also: written as a simple list like that, it's a ambiguous how to
> parse that comment: I think you mean that MAY_WRITE must be set whenever
> MAY_APPEND, MAY_CREATE_FILE, or MAY_CREATE_DIR are set.)

Yes, that's better.

Thanks,
Andreas
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
