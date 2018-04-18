From: Florian Weimer <fw@deneb.enyo.de>
Subject: sendmmsg flags userspace ABI change in kernel 4.6
Date: Wed, 18 Apr 2018 21:03:55 +0200
Message-ID: <874lk8jq04.fsf@mid.deneb.enyo.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-api@vger.kernel.org, netdev@vger.kernel.org, linux-sctp@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Tom Herbert <tom@herbertland.com>, mjw@fedoraproject.org
List-Id: linux-api@vger.kernel.org

Since this commit:

commit 28a94d8fb35b3a75b802f368ae6f4a9f6b0d435a
Author: Tom Herbert <tom@herbertland.com>
Date:   Mon Mar 7 14:11:02 2016 -0800

    net: Allow MSG_EOR in each msghdr of sendmmsg

    This patch allows setting MSG_EOR in each individual msghdr passed
    in sendmmsg. This allows a sendmmsg to send multiple messages when
    using SOCK_SEQPACKET.

    Signed-off-by: Tom Herbert <tom@herbertland.com>
    Signed-off-by: David S. Miller <davem@davemloft.net>

the msg_flags argument in individual msghdr arguments is longer
completely ignored for SOCK_SEQPACKET sockets.  msg_flags was and is
still documented as ignored for sendmsg(2), so by analogy for
sendmmsg(2) as well.

It seems that valgrind does not know about this yet, and due to
limited use of SCTP, this userspace ABI change has not been noticed so
far.

What are the plans in this area?  Will other kinds of sockets start
using the msghdr flags for sending?

A fully backwards-compatibility way to achieve this would be to
specify that you have to pass a new flag to sendmmsg (MSG_PERHDR?), in
its flags argument, to activate the per-msghdr flags.

The glibc DNS stub resolver relies on the previously documented
behavior, and I wonder how widely we should backport the change:

  https://sourceware.org/bugzilla/show_bug.cgi?id=23037

If the MSG_PERHDR route will be taken, we can skip this work, and
valgrind can flag uninitialized bits in msg_flags only if MSG_PERHDR
is passed.  (I believe it would be difficult for valgrind to look at
the socket type to determine whether undefined bits need reporting.)
