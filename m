From: Andreas Gruenbacher <agruenba-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC v7 26/41] richacl: Apply the file masks to a richacl
Date: Thu, 24 Sep 2015 17:48:20 +0200
Message-ID: <CAHc6FU4LW9vtuYSxE3Lj6o25O3NzVaFW8XC1kQy=d+KNixC5Bg@mail.gmail.com>
References: <1441448856-13478-1-git-send-email-agruenba@redhat.com>
	<1441448856-13478-27-git-send-email-agruenba@redhat.com>
	<20150922191108.GC19127@fieldses.org>
	<20150923191832.GA29577@fieldses.org>
	<CAHc6FU4YkLJUAQEfH7CG8sAzXYbGzg_ibyT7m26Fc1p26v1=VQ@mail.gmail.com>
	<20150923203357.GC30521@fieldses.org>
	<CAHc6FU4Jh=-K5=DBERP3-vv8Sak4XGjVJgJ85mTeyPiApUhz+g@mail.gmail.com>
	<20150923210531.GC29349@fieldses.org>
	<CAHc6FU7W-oLTOqBxmzAOY5mM37-J6NcnXrhm2SnoDXqHBJbhRQ@mail.gmail.com>
	<20150924152851.GC3823@fieldses.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150924152851.GC3823-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andreas Gruenbacher <agruen-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

2015-09-24 17:28 GMT+02:00 J. Bruce Fields <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>:
> I guess Samba's only choice on reading an ACL will be to split OWNER@
> ACEs into inheritable and effective parts and then replace the "who" on
> the latter by the current owner.

Right, that's when translating from richacls to Windows ACLs.

> On writing do you think it should try to translate ACEs for users
> matching the current owner to OWNER@ ACEs, or are you assuming it should
> leave those untouched?

In the other direction, from Windows ACLs to richacls, Samba at least
shouldn't have to do that mapping. There may still be cases where it
wants to do that mapping though.

Thanks,
Andreas
