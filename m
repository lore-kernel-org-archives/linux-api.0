From: "James Johnston" <johnstonj.public-Kk+ApOtKMVJWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH v21 00/22] Richacls
Date: Mon, 23 May 2016 01:20:15 -0000
Message-ID: <036701d1b491$44b3b2a0$ce1b17e0$@codenest.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-us
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, 'Jeremy Allison' <jra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, 'Volker Lendecke' <Volker.Lendecke-3ekOc4rQMZmzQB+pC5nmwQ@public.gmane.org>, 'Andreas Gruenbacher' <agruenba-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, 'Christoph Hellwig' <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

> On Tue, May 10, 2016 at 06:18:10AM +0200, Volker Lendecke wrote:
> > On Tue, May 10, 2016 at 12:02:33AM +0200, Andreas Gruenbacher wrote:
> > > What more can I do to finally get this merged?
> > 
> > While I am not the one to comment on kernel specifics, from a pure Samba
> > user space perspective let me say: We need this. NOW.
>
> +1 from me. This is something that many vendors need
> and have needed for a very long time. Getting this
> in will allow *large* amounts of existing storage to
> be migrated to Linux.

As a "mere" end-user of SAMBA, +1 from me also...  It's my understanding
that this patch set would help eliminate the need for hacks like
vfs_acl_xattr that store ACLs in extended attributes that only SAMBA
understands.  If the file system itself can respect the ACLs that seems
like a lot cleaner solution.

James
