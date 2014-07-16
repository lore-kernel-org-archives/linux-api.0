From: Kees Cook <keescook@chromium.org>
Subject: [PATCH v11 0/11] seccomp: add thread sync ability
Date: Wed, 16 Jul 2014 14:50:31 -0700
Message-ID: <1405547442-26641-1-git-send-email-keescook@chromium.org>
Return-path: <linux-arch-owner@vger.kernel.org>
Sender: linux-arch-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>, Andy Lutomirski <luto@amacapital.net>, Oleg Nesterov <oleg@redhat.com>, James Morris <jmorris@namei.org>, "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>, Alexei Starovoitov <ast@plumgrid.com>, Andrew Morton <akpm@linux-foundation.org>, Daniel Borkmann <dborkman@redhat.com>, Will Drewry <wad@chromium.org>, Julien Tinnes <jln@chromium.org>, David Drysdale <drysdale@google.com>, linux-api@vger.kernel.org, x86@kernel.org, linux-arm-kernel@lists.infradead.org, linux-mips@linux-mips.org, linux-arch@vger.kernel.org, linux-security-module@vger.kernel.org
List-Id: linux-api@vger.kernel.org

This adds the ability for threads to request seccomp filter
synchronization across their thread group (at filter attach time).
For example, for Chrome to make sure graphic driver threads are fully
confined after seccomp filters have been attached.

To support this, locking on seccomp changes via thread-group-shared
sighand lock is introduced, along with refactoring of no_new_privs. Races
with thread creation are handled via delayed duplication of the seccomp
task struct field and cred_guard_mutex.

This includes a new syscall (instead of adding a new prctl option),
as suggested by Andy Lutomirski and Michael Kerrisk.

Thanks!

-Kees

v11:
 - updated writer locking commit log for clarity (luto)
 - clarified writer lock thread flag setting comment (luto)
 - inverted SECCOMP_FILTER_FLAG_MASK (luto)
 - renamed is_acestor parameter (luto)
 - added BUG_ON to catch currently impossible integer overflow (luto)
v10:
 - dropped pending-kill checks (oleg)
 - tweaked memory barriers (oleg)
v9:
 - rearranged/split patches to make things more reviewable
 - added use of cred_guard_mutex to solve exec race (oleg, luto)
 - added barriers for TIF_SECCOMP vs seccomp.mode race (oleg, luto)
 - fixed missed copying of nnp state after v8 refactor (oleg)
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
