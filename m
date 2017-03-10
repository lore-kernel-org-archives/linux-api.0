From: Cyrill Gorcunov <gorcunov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Subject: [patch 0/3] fs,epoll: Add ability to call kcmp to find target files
Date: Fri, 10 Mar 2017 11:16:55 +0300
Message-ID: <20170310081655.462925968@openvz.org>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, akpm-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, avagin-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org, xemul-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org, mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, kir-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, gorcunov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org
List-Id: linux-api@vger.kernel.org

Hi! This is slightly updated series for epoll extension
in procfs and kcmp syscall. The procfs patch and manpage
is unchanged while kcmp syscall is slightly updated to
drop hard to read if()'s and shrink memory pressue with
kcmp_epoll_slot argument.

Please take a look, once time permit. Being playing with
this patches via criu directly, works as expected.

https://lists.openvz.org/pipermail/criu/2017-February/036031.html
