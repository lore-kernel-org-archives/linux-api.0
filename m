From: "Frank Filz" <ffilzlnx-mn4gwa5WIIQysxA8WJXlww@public.gmane.org>
Subject: RE: [PATCH v12 00/49] Richacls
Date: Fri, 23 Oct 2015 13:03:59 -0700
Message-ID: <002f01d10dcd$f5f9f170$e1edd450$@mindspring.com>
References: <1445625722-13791-1-git-send-email-agruenba@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1445625722-13791-1-git-send-email-agruenba-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Content-Language: en-us
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Andreas Gruenbacher' <agruenba-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, 'Alexander Viro' <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, 'Theodore Ts'o' <tytso-3s7WtUTddSA@public.gmane.org>, 'Andreas Dilger' <adilger.kernel-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org>, "'J. Bruce Fields'" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>, 'Jeff Layton' <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>, 'Trond Myklebust' <trond.myklebust-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>, 'Anna Schumaker' <anna.schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>, 'Dave Chinner' <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, xfs-VZNHf3L845pBDgjK7y7TUQ@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Andreas Gruenbacher:
> 
> Here is another update of the richacl patch queue.  I would like to ask
for
> feedback so that the core and local filesystem code (patches 1-25) can be
> merged in the 4.4 merge window.
> 
> Changes since the last posting (http://lwn.net/Articles/661078/):
> 
>  * On ext4, filesystems with the richacl feature can no longer be mounted
>    with -o noacl; richacls cannot be turned off.
> 
>  * XFS was listing richacl xattrs as "trusted.system.richacl"; this has
>    been fixed.
> 
>  * Some definitions have been moved from include/linux/ to
>    include/uapi/linux/.  The license of the uapi headers has been changed
>    to LGPL.

Thanks for that last. I kept meaning to ask about that for cleaner use in
Ganesha.

Frank



---
This email has been checked for viruses by Avast antivirus software.
https://www.avast.com/antivirus

--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
