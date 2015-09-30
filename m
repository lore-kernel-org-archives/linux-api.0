From: Tycho Andersen <tycho.andersen@canonical.com>
Subject: checkpoint/restore of seccomp filters v3
Date: Wed, 30 Sep 2015 12:13:35 -0600
Message-ID: <1443636820-17083-1-git-send-email-tycho.andersen@canonical.com>
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Kees Cook <keescook@chromium.org>, Alexei Starovoitov <ast@kernel.org>
Cc: Will Drewry <wad@chromium.org>, Oleg Nesterov <oleg@redhat.com>, Andy Lutomirski <luto@amacapital.net>, Pavel Emelyanov <xemul@parallels.com>, "Serge E. Hallyn" <serge.hallyn@ubuntu.com>, Daniel Borkmann <daniel@iogearbox.net>, linux-kernel@vger.kernel.org, netdev@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Hi all,

Here's a re-worked set for c/r of seccomp filters which keeps around the
original bpf program passed to the kernel instead of trying to dump the
ebpf version. There are various comments/questions in the individual patch
notes.

I'm not sure this needs to go via net-next any more, as the impact in net/
is fairly minimal, and it seems more seccomp heavy. As such, this set is
based on seccomp/tip.

Thoughts welcome,

Tycho

P.S. Man page patches to come once we agree on the API :)
