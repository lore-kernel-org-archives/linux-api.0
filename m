From: Andrey Vagin <avagin@openvz.org>
Subject: =?UTF-8?q?=5BPATCH=200/3=5D=20signalfd=3A=20a=20kernel=20interface=20for=20dumping/restoring=20pending=20signals=20=28v3=29?=
Date: Mon, 14 Jan 2013 20:53:52 +0400
Message-ID: <1358182435-19245-1-git-send-email-avagin@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: criu@openvz.org, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, Andrey Vagin <avagin@openvz.org>, Serge Hallyn <serge.hallyn@canonical.com>, Oleg Nesterov <oleg@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, "Eric W. Biederman" <ebiederm@xmission.com>, Al Viro <viro@zeniv.linux.org.uk>, Pavel Emelyanov <xemul@parallels.com>, Cyrill Gorcunov <gorcunov@openvz.org>, Michael Kerrisk <mtk.manpages@gmail.com>
List-Id: linux-api@vger.kernel.org


The idea is simple. We need to get the siginfo for each signal on dump,
and then return it back on restore.

The first problem is that the kernel doesn=E2=80=99t report complete si=
ginfo-s
in user-space. In a signal handler the kernel strips SI_CODE from
siginfo. When a siginfo is received from signalfd, it has a different
format with fixed sizes of fields. The interface of signalfd was
extended. If a signalfd is created with the flag SFD_RAW, it returns
siginfo in a raw format.

rt_sigqueueinfo looks suitable for restoring signals, but it can=E2=80=99=
t send
siginfo with a positive si_code, because these codes are reserved for
the kernel. In the real world each person has right to do anything with
himself, so I think a process should able to send any siginfo to itself=
=2E

v2: add ability to dump signals without dequeuing them.
    pread with non-zero offset is used for this. offset encodes
    a queue (private of shared) and a sequence number of a signal
    in the queue. Thanks to Oleg for this idea.
v3: minor cleanups

Cc: Serge Hallyn <serge.hallyn@canonical.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Pavel Emelyanov <xemul@parallels.com>
CC: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>

Andrey Vagin (3):
  signal: allow to send any siginfo to itself
  signalfd: add ability to return siginfo in a raw format (v2)
  signalfd: add ability to read siginfo-s without dequeuing signals (v4=
)

 fs/signalfd.c                 | 109 ++++++++++++++++++++++++++++++++++=
+++++---
 include/uapi/linux/signalfd.h |   6 +++
 kernel/signal.c               |   6 ++-
 3 files changed, 113 insertions(+), 8 deletions(-)

--=20
1.7.11.7
