From: Andreas Gruenbacher <agruenba-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC v6 02/40] vfs: Add MAY_CREATE_FILE and MAY_CREATE_DIR
 permission flags
Date: Wed, 2 Sep 2015 22:23:03 +0200
Message-ID: <CAHc6FU4L3e=OuH8_22zBgC45x0z77HDq9PqrgQ02hy3+vVYhRw@mail.gmail.com>
References: <1438689218-6921-1-git-send-email-agruenba@redhat.com>
	<1438689218-6921-3-git-send-email-agruenba@redhat.com>
	<20150902185300.GA3319@fieldses.org>
	<CAHc6FU62LQ8xnEbjsBprnud36AURg_ggifFoHOVM51-9vRJeDg@mail.gmail.com>
	<20150902192008.GB3319@fieldses.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150902192008.GB3319-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>
Cc: Andreas Gruenbacher <andreas.gruenbacher-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

2015-09-02 21:20 GMT+02:00 J. Bruce Fields <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>:
> Got it.  And maybe it should be obvious, but it might be worth a
> sentence in the changelog if it's not already explained elsewhere.--b.

Let me try adding a comment. Also I'll fix the next commit which adds
MAY_DELETE_SELF here: MAY_DELETE_SELF shouldn't go together with
MAY_WRITE.

Thanks,
Andreas
