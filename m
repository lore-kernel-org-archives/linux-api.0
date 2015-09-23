From: Andreas Gruenbacher <agruenba-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC v7 26/41] richacl: Apply the file masks to a richacl
Date: Wed, 23 Sep 2015 22:40:18 +0200
Message-ID: <CAHc6FU4Jh=-K5=DBERP3-vv8Sak4XGjVJgJ85mTeyPiApUhz+g@mail.gmail.com>
References: <1441448856-13478-1-git-send-email-agruenba@redhat.com>
	<1441448856-13478-27-git-send-email-agruenba@redhat.com>
	<20150922191108.GC19127@fieldses.org>
	<20150923191832.GA29577@fieldses.org>
	<CAHc6FU4YkLJUAQEfH7CG8sAzXYbGzg_ibyT7m26Fc1p26v1=VQ@mail.gmail.com>
	<20150923203357.GC30521@fieldses.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150923203357.GC30521-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andreas Gruenbacher <agruen-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

2015-09-23 22:33 GMT+02:00 J. Bruce Fields <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>:
> The same could be said if there's a group-i-belong-to:rwx::allow entry,
> do we make that exception too?

We cannot because that would be incorrect for all other group members.

Andreas
