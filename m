From: Cyrill Gorcunov <gorcunov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Subject: [RFC 0/3] fs,epoll: Add ability to call kcmp to find target files
Date: Tue, 21 Feb 2017 19:59:44 +0300
Message-ID: <20170221165944.180372636@openvz.org>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, akpm-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, avagin-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org, xemul-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org, mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, kir-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, gorcunov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org, jbaron-JqFfY2XvxFXQT0dZR+AlfA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Hi! In previous series EPOLL_CTL_DUP operation has been discussed
but considered as potentially scary. So here is an another approach:

 - extend fdinfo of epoll files with inode, device and file position
   for every target, which allow the reader to gather targets with
   this bundle as a key for primary sorting

 - extent kcmp to check if some particular file is matching one
   sitting inside epoll queue (duplicate numbers are resolved with
   offset parameter)

Please take a look once time permit. Note that I did only basic
testing (without CRIU) but it should fit our needs because we
sort and lookup regualr files by same scheme. So I'm about to
implemet full criu support for this new kernel features in
a couple of days thus any comments are *higly* appreciated.

NB: Initially I added

	if (file_ns_capable(epi->ffd.file, ns, CAP_SYS_ADMIN))

into fdinfo output to check if caller is allowed to see
target ino/dev/pos but dropped it later because if process
is added file descriptor into epoll queue it mean fdstat
and such already can be called and this information is
already obtained, so I don't this it's information
disclosure.

	Cyrill
