From: Kees Cook <keescook@chromium.org>
Subject: [PATCH v6 0/9] seccomp: add thread sync ability
Date: Tue, 10 Jun 2014 20:25:12 -0700
Message-ID: <1402457121-8410-1-git-send-email-keescook@chromium.org>
Return-path: <linux-mips-bounce@linux-mips.org>
Sender: linux-mips-bounce@linux-mips.org
Errors-to: linux-mips-bounce@linux-mips.org
List-help: <mailto:ecartis@linux-mips.org?Subject=help>
List-unsubscribe: <mailto:ecartis@linux-mips.org?subject=unsubscribe%20linux-mips>
List-software: Ecartis version 1.0.0
List-subscribe: <mailto:ecartis@linux-mips.org?subject=subscribe%20linux-mips>
List-owner: <mailto:ralf@linux-mips.org>
List-post: <mailto:linux-mips@linux-mips.org>
List-archive: <http://www.linux-mips.org/archives/linux-mips/>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>, Andy Lutomirski <luto@amacapital.net>, Oleg Nesterov <oleg@redhat.com>, Will Drewry <wad@chromium.org>, Julien Tinnes <jln@chromium.org>, David Drysdale <drysdale@google.com>, Alexei Starovoitov <ast@plumgrid.com>, John Johansen <john.johansen@canonical.com>, Andrew Morton <akpm@linux-foundation.org>, x86@kernel.org, linux-arm-kernel@lists.infradead.org, linux-mips@linux-mips.org, linux-api@vger.kernel.org, linux-arch@vger.kernel.org, linux-security-module@vger.kernel.org
List-Id: linux-api@vger.kernel.org

[re-send with smaller CC list]

This adds the ability for threads to request seccomp filter
synchronization across their thread group (at filter attach time).
For example, for Chrome to make sure graphic driver threads are fully
confined after seccomp filters have been attached.

To support this, locking on seccomp changes is introduced, along with
refactoring of no_new_privs. Races with thread creation/death are handled
via tasklist_lock.

This includes a new syscall (instead of adding a new prctl option),
as suggested by Andy Lutomirski and Michael Kerrisk.

Thanks!

-Kees

v6:
 - switch from seccomp-specific lock to thread-group lock to gain atomicity
 - implement seccomp syscall across all architectures with seccomp filter
 - clean up sparse warnings around locking
v5:
 - move includes around (drysdale)
 - drop set_nnp return value (luto)
 - use smp_load_acquire/store_release (luto)
 - merge nnp changes to seccomp always, fewer ifdef (luto)
v4:
 - cleaned up locking further, as noticed by David Drysdale
v3:
 - added SECCOMP_EXT_ACT_FILTER for new filter install options
v2:
 - reworked to avoid clone races
