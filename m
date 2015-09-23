From: Andreas Gruenbacher <agruenba-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC v7 25/41] richacl: Isolate the owner and group classes
Date: Wed, 23 Sep 2015 15:33:49 +0200
Message-ID: <CAHc6FU7_+fbyG0mEu3pUkfaV72AM0DzJnBES=b--koXJgo0a2g@mail.gmail.com>
References: <1441448856-13478-1-git-send-email-agruenba@redhat.com>
	<1441448856-13478-26-git-send-email-agruenba@redhat.com>
	<20150922190224.GA19127@fieldses.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150922190224.GA19127-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andreas Gruenbacher <agruen-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

2015-09-22 21:02 GMT+02:00 J. Bruce Fields <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>:
> On Sat, Sep 05, 2015 at 12:27:20PM +0200, Andreas Gruenbacher wrote:
>> +      * Compute the permissions already denied to @who.
>
> I'm not sure, but may be worth commenting on the lack of everyone denies
> here as you do in a couple places below.

Okay.

> As in the owner case, I think a goto would simplify the logic a little.

Yep, I'll clean that up.

>> +             /*
>> +              * Start from the entry before the trailing everyone@ allow
>> +              * entry.  We will not hit everyone@ entries in the loop.
>
> May as well skip the check below, in that case?

Indeed. You can almost tell from those few leftovers how the code has
evolved over time :)

Thanks,
Andreas
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
