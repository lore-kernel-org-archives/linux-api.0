From: Kees Cook <keescook@chromium.org>
Subject: [PATCH v8 0/9] seccomp: add thread sync ability
Date: Tue, 24 Jun 2014 13:48:04 -0700
Message-ID: <1403642893-23107-1-git-send-email-keescook@chromium.org>
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
Cc: Kees Cook <keescook@chromium.org>, Oleg Nesterov <oleg@redhat.com>, Andy Lutomirski <luto@amacapital.net>, "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>, Alexei Starovoitov <ast@plumgrid.com>, Andrew Morton <akpm@linux-foundation.org>, Daniel Borkmann <dborkman@redhat.com>, Will Drewry <wad@chromium.org>, Julien Tinnes <jln@chromium.org>, David Drysdale <drysdale@google.com>, linux-api@vger.kernel.org, x86@kernel.org, linux-arm-kernel@lists.infradead.org, linux-mips@linux-mips.org, linux-arch@vger.kernel.org, linux-security-module@vger.kernel.org
List-Id: linux-api@vger.kernel.org

This adds the ability for threads to request seccomp filter
synchronization across their thread group (at filter attach time).
For example, for Chrome to make sure graphic driver threads are fully
confined after seccomp filters have been attached.

To support this, locking on seccomp changes via thread-group-shared
sighand lock is introduced, along with refactoring of no_new_privs. Races
with thread creation are handled via delayed duplication of the seccomp
task struct field.

This includes a new syscall (instead of adding a new prctl option),
as suggested by Andy Lutomirski and Michael Kerrisk.

Thanks!

-Kees

v8:
 - drop use of tasklist_lock, appears redundant against sighand (oleg)
 - reduced use of smp_load_acquire to logical minimum (oleg)
 - change nnp to a task struct held atomic flags field (oleg, luto)
 - drop needless irqflags changes in fork.c for holding sighand lock (oleg)
 - cleaned up use of thread for-each loop (oleg)
 - rearranged patch order to keep syscall changes adjacent
 - added example code to manpage (mtk)
v7:
 - rebase on Linus's tree (merged with network bpf changes)
 - wrote manpage text documenting API (follows this series)
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
