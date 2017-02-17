From: Cyrill Gorcunov <gorcunov@openvz.org>
Subject: [RFC 0/2] fs,eventpoll: Add EPOLL_CTL_DUP into epoll_ctl syscall
Date: Fri, 17 Feb 2017 11:30:10 +0300
Message-ID: <20170217083010.268691613@openvz.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
Cc: viro@zeniv.linux.org.uk, akpm@linuxfoundation.org, avagin@virtuozzo.com, xemul@virtuozzo.com, mtk.manpages@gmail.com, kir@openvz.org, gorcunov@openvz.org
List-Id: linux-api@vger.kernel.org

In the series new EPOLL_CTL_DUP operation introduced, we need it
to be able to restore target file descriptors in case if they
were dup'ed (or received via unix message) before registering
and closed after, so the fdinfo info shows file number which
application no longer having.

Please take a look. Kir, I slightly updated manpage to mention
the reason why we need this operation.

	Cyrill
