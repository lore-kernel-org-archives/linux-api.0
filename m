Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795128264;
	b=tjIAatJrhBDgeDzGLSI6xx8UEaWh7HlWKkgDs3hM9PB36QjLfu9ID87Kzc65qs4oCNg6
	 XR4dAkwBIzIZ5ocWeuB9pO9Y7OWTS+7LvuYNY51pNtaHg12L4S/MyBDiYKv8HMjvMRJu/
	 wuhf6+DM0M4rr7z9mOILBF2Nfs3Ca8L9QQh7UGSHPrHnrfV909SSQUTonG/5jMxPsb0+z
	 v6EIr5yGd495LxRiHqtpMVoIk7oBRpVbRpXcl1fQ7Ajwta+NHYs36eV0V/oZFVjOfWwtd
	 rdB4vIi4pmFD3UbJRDRNGk3viAqOL5Qz8igyg78H0rXRFsST0m0Q8SBQto4tNE7Efbg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795128264;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=x0ylktblEO74exFqF6Eoi6Rq3AOeKvvKOE/TIUcuigA=;
	b=lK5ItSQjhR5S8t2VejaWNrXE4aEr9Dcoxhk44x8WCuy8Vi5DJASWL35yDLa7x5sre8yQ
	 3a1gbHNacBtYrQAtla/2lMzieYbGWI2ABRpC7yuv7z1ljgeZy9RGhWDJxHhrHlRaeBJLH
	 R2sG6YIOsE+Og3GM97baQXX8CW+tjKyh1XUDIW7C6+DMalUq8qjRKjsR+k7E+Q/ofm1HC
	 bk9MaUSzj0D+n0opngUFkHHkjmnO1rjGUY0zXu3O4PdVc5p6k3N3bb1RxO9oCQ7hpIuFe
	 dHz/G4DpwrmA6M309zNsl7gzO+K4FCIClymxpOLK7+FNwbX+7x45heSbTy3zthBJBLw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ipKEmLKT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 3F18060A260F;
	Thu, 19 Nov 2026 22:44:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ipKEmLKT
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id A05D31F000D1;
	Thu, 19 Nov 2026 22:44:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795128263;
	bh=x0ylktblEO74exFqF6Eoi6Rq3AOeKvvKOE/TIUcuigA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ipKEmLKTDFFMrPc186WlfRZDwejiNdRa5eH2K9iT75l6dQD++m3OHWC50YCiBf7Xf
	 p8ekiKEN5RdAeUgkjpDy790IZiWYvRTZSzZvIkB+cS6E49FEqJCiibfAoAcvW7Ot7p
	 IS0qT6yTgMekhZCmt+8ZYT1mbeSq36SdOstwTUM8MipxewayJ3xXNGNMCcBYPKCUxE
	 TIrPlqc1e7gTgjVm7pl9bmxO1KTU2055IuYkoxRuDJTHIxKgTosqN9WCMU+bRHyUSv
	 y0mSN3cdIIzQxu8FupOF753HVAg9RpvEUBhP+Gc3WAR+ZcwBl1eXhy6fxYW1sUwutX
	 QizT6mInJdpdg==
From: Jarkko Sakkinen <jarkko@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: Jarkko Sakkinen <jarkko@kernel.org>,
	linux-api@vger.kernel.org,
	linux-arch@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org,
	linux-security-module@vger.kernel.org,
	Albert Ou <aou@eecs.berkeley.edu>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Alexandre Ghiti <alex@ghiti.fr>,
	Andreas Larsson <andreas@gaisler.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andy Lutomirski <luto@amacapital.net>,
	Andy Lutomirski <luto@kernel.org>,
	Anna-Maria Behnsen <anna-maria@linutronix.de>,
	Arnd Bergmann <arnd@arndb.de>,
	Ben Segall <bsegall@google.com>,
	Borislav Petkov <bp@alien8.de>,
	Casey Schaufler <casey@schaufler-ca.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Christian Brauner <brauner@kernel.org>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	Chris Zankel <chris@zankel.net>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	David Hildenbrand <david@kernel.org>,
	David Howells <dhowells@redhat.com>,
	Davidlohr Bueso <dave@stgolabs.net>,
	"David S. Miller" <davem@davemloft.net>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Frederic Weisbecker <frederic@kernel.org>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	"Hallgrimur H. Gunnarsson" <halg@google.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Helge Deller <deller@gmx.de>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Ingo Molnar <mingo@redhat.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Jan Kara <jack@suse.cz>,
	John Johansen <john.johansen@canonical.com>,
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
	Jonathan Corbet <corbet@lwn.net>,
	Josef Bacik <josef@toxicpanda.com>,
	Juri Lelli <juri.lelli@redhat.com>,
	Kees Cook <kees@kernel.org>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Magnus Lindholm <linmag7@gmail.com>,
	Manfred Spraul <manfred@colorfullife.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Matt Turner <mattst88@gmail.com>,
	Max Filippov <jcmvbkbc@gmail.com>,
	Mel Gorman <mgorman@suse.de>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Michal Hocko <mhocko@suse.com>,
	Michal Simek <monstr@monstr.eu>,
	Mike Rapoport <rppt@kernel.org>,
	Neal Gompa <neal@gompa.dev>,
	Nicholas Piggin <npiggin@gmail.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Paul Moore <paul@paul-moore.com>,
	Paul Walmsley <pjw@kernel.org>,
	Pavel Tikhomirov <ptikhomirov@virtuozzo.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Richard Henderson <richard.henderson@linaro.org>,
	Rich Felker <dalias@libc.org>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Russell King <linux@armlinux.org.uk>,
	Serge Hallyn <sergeh@kernel.org>,
	Shrikanth Hegde <sshegde@linux.ibm.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Thomas Gleixner <tglx@kernel.org>,
	Valentin Schneider <vschneid@redhat.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Vincenzo Frascino <vincenzo.frascino@arm.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Will Deacon <will@kernel.org>,
	Yoshinori Sato <ysato@users.sourceforge.jp>,
	Zygmunt Krynicki <zygmunt.krynicki@canonical.com>
Subject: [RFC PATCH v4 13/14] selftests/rootns: Add root namespace test suite
Date: Fri, 20 Nov 2026 00:43:11 +0200
Message-ID: <20261119224312.1037966-14-jarkko@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261119224312.1037966-1-jarkko@kernel.org>
References: <20261119224312.1037966-1-jarkko@kernel.org>
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Verify the root namespace and mount-namespace configuration uAPI and
security invariants across privileged, unprivileged, and edge-case
scenarios.

Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
---
 tools/testing/selftests/Makefile              |    1 +
 tools/testing/selftests/rootns/Makefile       |    5 +
 tools/testing/selftests/rootns/config         |   10 +
 .../testing/selftests/rootns/rootns_cells.py  | 1076 +++++++++++++++
 tools/testing/selftests/rootns/rootns_test.py | 1161 +++++++++++++++++
 tools/testing/selftests/rootns/test_smoke.sh  |   11 +
 6 files changed, 2264 insertions(+)
 create mode 100644 tools/testing/selftests/rootns/Makefile
 create mode 100644 tools/testing/selftests/rootns/config
 create mode 100755 tools/testing/selftests/rootns/rootns_cells.py
 create mode 100755 tools/testing/selftests/rootns/rootns_test.py
 create mode 100755 tools/testing/selftests/rootns/test_smoke.sh

diff --git a/tools/testing/selftests/Makefile b/tools/testing/selftests/Makefile
index 07c3719f8b04..7c44f93e57a4 100644
--- a/tools/testing/selftests/Makefile
+++ b/tools/testing/selftests/Makefile
@@ -117,6 +117,7 @@ TARGETS += rdma
 TARGETS += resctrl
 TARGETS += riscv
 TARGETS += rlimits
+TARGETS += rootns
 TARGETS += rseq
 TARGETS += rtc
 TARGETS += rust
diff --git a/tools/testing/selftests/rootns/Makefile b/tools/testing/selftests/rootns/Makefile
new file mode 100644
index 000000000000..62629d112e12
--- /dev/null
+++ b/tools/testing/selftests/rootns/Makefile
@@ -0,0 +1,5 @@
+# SPDX-License-Identifier: GPL-2.0
+include ../lib.mk
+
+TEST_PROGS := test_smoke.sh
+TEST_PROGS_EXTENDED := rootns_cells.py rootns_test.py
diff --git a/tools/testing/selftests/rootns/config b/tools/testing/selftests/rootns/config
new file mode 100644
index 000000000000..21b1aecc003b
--- /dev/null
+++ b/tools/testing/selftests/rootns/config
@@ -0,0 +1,10 @@
+CONFIG_CGROUPS=y
+CONFIG_IPC_NS=y
+CONFIG_NET_NS=y
+CONFIG_PID_NS=y
+CONFIG_PROC_FS=y
+CONFIG_ROOTNS=y
+CONFIG_TIME_NS=y
+CONFIG_TMPFS=y
+CONFIG_USER_NS=y
+CONFIG_UTS_NS=y
diff --git a/tools/testing/selftests/rootns/rootns_cells.py b/tools/testing/selftests/rootns/rootns_cells.py
new file mode 100755
index 000000000000..b690ed71a521
--- /dev/null
+++ b/tools/testing/selftests/rootns/rootns_cells.py
@@ -0,0 +1,1076 @@
+#!/usr/bin/env python3
+# SPDX-License-Identifier: GPL-2.0
+#
+# Copyright (C) 2026 Opinsys Oy
+
+from __future__ import annotations
+
+import argparse
+from collections.abc import Callable, Mapping, Sequence
+import ctypes
+from dataclasses import asdict, dataclass, field
+import errno
+import json
+import os
+import platform
+import selectors
+import signal
+import socket
+import sys
+from types import TracebackType
+from typing import Any, Final, NoReturn
+
+ROOTNS_KILL_ON_CLOSE: Final[int] = 0x00000001
+ROOTNS_CLOSE_ON_EXEC: Final[int] = 0x00000002
+ROOTNS_ALL_FLAGS: Final[int] = 0x00000003
+ROOTNS_IOCTL_MAGIC: Final[int] = 0xB9
+
+CLONE_NEWTIME: Final[int] = 0x00000080
+CLONE_VM: Final[int] = 0x00000100
+CLONE_FS: Final[int] = 0x00000200
+CLONE_FILES: Final[int] = 0x00000400
+CLONE_SIGHAND: Final[int] = 0x00000800
+CLONE_PIDFD: Final[int] = 0x00001000
+CLONE_VFORK: Final[int] = 0x00004000
+CLONE_PARENT: Final[int] = 0x00008000
+CLONE_THREAD: Final[int] = 0x00010000
+CLONE_NEWNS: Final[int] = 0x00020000
+CLONE_SYSVSEM: Final[int] = 0x00040000
+CLONE_NEWCGROUP: Final[int] = 0x02000000
+CLONE_NEWUTS: Final[int] = 0x04000000
+CLONE_NEWIPC: Final[int] = 0x08000000
+CLONE_NEWUSER: Final[int] = 0x10000000
+CLONE_NEWPID: Final[int] = 0x20000000
+CLONE_NEWNET: Final[int] = 0x40000000
+
+CLONE_CLEAR_SIGHAND: Final[int] = 1 << 32
+CLONE_INTO_CGROUP: Final[int] = 1 << 33
+CLONE_AUTOREAP: Final[int] = 1 << 34
+CLONE_NNP: Final[int] = 1 << 35
+CLONE_PIDFD_AUTOKILL: Final[int] = 1 << 36
+CLONE_EMPTY_MNTNS: Final[int] = 1 << 37
+CLONE_INTO_ROOTNS: Final[int] = 1 << 38
+
+CLONE_ARGS_SIZE_VER2: Final[int] = 88
+CLONE_ARGS_SIZE_VER3: Final[int] = 96
+
+AT_FDCWD: Final[int] = -100
+AT_EMPTY_PATH: Final[int] = 0x1000
+AT_RECURSIVE: Final[int] = 0x8000
+MNT_DETACH: Final[int] = 2
+MS_REC: Final[int] = 0x4000
+MS_PRIVATE: Final[int] = 1 << 18
+
+OPEN_TREE_CLONE: Final[int] = 1 << 0
+OPEN_TREE_CLOEXEC: Final[int] = os.O_CLOEXEC
+
+MOVE_MOUNT_F_EMPTY_PATH: Final[int] = 0x00000004
+MOVE_MOUNT_T_EMPTY_PATH: Final[int] = 0x00000040
+MOVE_MOUNT_T_MNTNS: Final[int] = 0x00000080
+MOVE_MOUNT_SET_GROUP: Final[int] = 0x00000100
+MOVE_MOUNT_BENEATH: Final[int] = 0x00000200
+
+FSOPEN_CLOEXEC: Final[int] = 0x00000001
+FSMOUNT_CLOEXEC: Final[int] = 0x00000001
+
+FSCONFIG_SET_FLAG: Final[int] = 0
+FSCONFIG_SET_STRING: Final[int] = 1
+FSCONFIG_CMD_CREATE: Final[int] = 6
+FSCONFIG_SET_ROOTNS: Final[int] = 9
+
+MOUNT_ATTR_RDONLY: Final[int] = 0x00000001
+MOUNT_ATTR_NOSUID: Final[int] = 0x00000002
+MOUNT_ATTR_NODEV: Final[int] = 0x00000004
+
+RESOLVE_IN_ROOT: Final[int] = 0x10
+
+PR_GET_DUMPABLE: Final[int] = 3
+PR_SET_DUMPABLE: Final[int] = 4
+PR_GET_NO_NEW_PRIVS: Final[int] = 39
+
+NSIO: Final[int] = 0xB7
+
+HOST_RUNTIME_ENTRIES: Final[tuple[str, ...]] = (
+    "usr",
+    "bin",
+    "sbin",
+    "lib",
+    "lib32",
+    "lib64",
+    "libx32",
+    "etc",
+    "opt",
+    "nix",
+)
+
+_WIDE_IOC_ARCHS: Final[tuple[str, ...]] = (
+    "ppc",
+    "ppc64",
+    "ppc64le",
+    "powerpc",
+    "sparc",
+    "sparc64",
+    "alpha",
+)
+
+
+def _is_wide_ioc_arch() -> bool:
+    mach = platform.machine().lower()
+    return mach in _WIDE_IOC_ARCHS or mach.startswith("mips")
+
+
+def _ioc(direction: int, magic: int, nr: int, size: int) -> int:
+    sizebits = 13 if _is_wide_ioc_arch() else 14
+    typeshift = 8
+    sizeshift = 16
+    dirshift = sizeshift + sizebits
+    return (
+        (direction << dirshift)
+        | (magic << typeshift)
+        | nr
+        | (size << sizeshift)
+    )
+
+
+def _io(magic: int, nr: int) -> int:
+    return _ioc(0, magic, nr, 0)
+
+
+def _iowr(magic: int, nr: int, size: int) -> int:
+    rw = 6 if _is_wide_ioc_arch() else 3
+    return _ioc(rw, magic, nr, size)
+
+
+class RootnsWaitArgs(ctypes.Structure):
+    flags: int
+    status: int
+    _fields_ = [
+        ("flags", ctypes.c_uint32),
+        ("status", ctypes.c_int32),
+    ]
+
+
+class CloneArgs(ctypes.Structure):
+    flags: int
+    pidfd: int
+    child_tid: int
+    parent_tid: int
+    exit_signal: int
+    stack: int
+    stack_size: int
+    tls: int
+    set_tid: int
+    set_tid_size: int
+    cgroup: int
+    rootns: int
+    _fields_ = [
+        ("flags", ctypes.c_uint64),
+        ("pidfd", ctypes.c_uint64),
+        ("child_tid", ctypes.c_uint64),
+        ("parent_tid", ctypes.c_uint64),
+        ("exit_signal", ctypes.c_uint64),
+        ("stack", ctypes.c_uint64),
+        ("stack_size", ctypes.c_uint64),
+        ("tls", ctypes.c_uint64),
+        ("set_tid", ctypes.c_uint64),
+        ("set_tid_size", ctypes.c_uint64),
+        ("cgroup", ctypes.c_uint64),
+        ("rootns", ctypes.c_uint64),
+    ]
+
+
+class OpenHow(ctypes.Structure):
+    flags: int
+    mode: int
+    resolve: int
+    _fields_ = [
+        ("flags", ctypes.c_uint64),
+        ("mode", ctypes.c_uint64),
+        ("resolve", ctypes.c_uint64),
+    ]
+
+
+ROOTNS_GET_NSFD: Final[int] = _io(ROOTNS_IOCTL_MAGIC, 0x01)
+ROOTNS_WAIT: Final[int] = _iowr(
+    ROOTNS_IOCTL_MAGIC, 0x02, ctypes.sizeof(RootnsWaitArgs)
+)
+ROOTNS_KILL: Final[int] = _io(ROOTNS_IOCTL_MAGIC, 0x03)
+
+NS_GET_USERNS: Final[int] = _io(NSIO, 0x01)
+NS_GET_PARENT: Final[int] = _io(NSIO, 0x02)
+NS_GET_NSTYPE: Final[int] = _io(NSIO, 0x03)
+
+
+def _syscall_numbers() -> dict[str, int]:
+    mach = platform.machine().lower()
+    if mach == "alpha":
+        base = 110
+    elif mach.startswith("mips"):
+        base = 5000 if ctypes.sizeof(ctypes.c_void_p) == 8 else 4000
+    else:
+        base = 0
+
+    nums: dict[str, int] = {
+        "open_tree": base + 428,
+        "move_mount": base + 429,
+        "fsopen": base + 430,
+        "fsconfig": base + 431,
+        "fsmount": base + 432,
+        "pidfd_open": base + 434,
+        "clone3": base + 435,
+        "openat2": base + 437,
+        "rootns": base + 473,
+    }
+    legacy: dict[str, dict[str, int]] = {
+        "x86_64": {"pivot_root": 155, "umount2": 166, "execveat": 322},
+        "i386": {"pivot_root": 217, "umount2": 52, "execveat": 358},
+        "i686": {"pivot_root": 217, "umount2": 52, "execveat": 358},
+        "aarch64": {"pivot_root": 41, "umount2": 39, "execveat": 281},
+        "riscv64": {"pivot_root": 41, "umount2": 39, "execveat": 281},
+        "loongarch64": {"pivot_root": 41, "umount2": 39, "execveat": 281},
+        "s390x": {"pivot_root": 217, "umount2": 52, "execveat": 354},
+        "ppc64le": {"pivot_root": 203, "umount2": 52, "execveat": 362},
+        "ppc64": {"pivot_root": 203, "umount2": 52, "execveat": 362},
+        "armv7l": {"pivot_root": 218, "umount2": 52, "execveat": 387},
+    }
+    nums.update(legacy.get(mach, legacy["x86_64"]))
+    return nums
+
+
+NR: Final[dict[str, int]] = _syscall_numbers()
+LIBC: Final[ctypes.CDLL] = ctypes.CDLL(None, use_errno=True)
+LIBC.syscall.restype = ctypes.c_long
+
+
+@dataclass(frozen=True)
+class WaitResult:
+    pid: int
+    status: int = 0
+
+    @property
+    def exit_code(self) -> int | None:
+        if self.pid <= 0:
+            return None
+        return os.waitstatus_to_exitcode(self.status)
+
+
+@dataclass(frozen=True)
+class CellInfo:
+    name: str
+    state: str
+    init_pid: int | None = None
+    exit_code: int | None = None
+
+
+@dataclass(frozen=True)
+class SpawnInfo:
+    pid: int
+    state: str
+
+
+def _os_err() -> NoReturn:
+    err = ctypes.get_errno()
+    raise OSError(err, os.strerror(err))
+
+
+def _cstr(val: str | bytes) -> bytes:
+    if isinstance(val, bytes):
+        return val
+    return os.fsencode(val)
+
+
+def syscall(nr: int, *args: Any) -> int:
+    ret: int = LIBC.syscall(ctypes.c_long(nr), *args)
+    if ret < 0:
+        _os_err()
+    return int(ret)
+
+
+def raw_ioctl(fd: int, cmd: int, arg: int = 0) -> int:
+    ret: int = LIBC.ioctl(
+        ctypes.c_int(fd), ctypes.c_ulong(cmd), ctypes.c_ulong(arg)
+    )
+    if ret < 0:
+        _os_err()
+    return int(ret)
+
+
+def rootns(
+    flags: int = ROOTNS_KILL_ON_CLOSE | ROOTNS_CLOSE_ON_EXEC,
+) -> int:
+    return syscall(NR["rootns"], ctypes.c_uint(flags))
+
+
+def rootns_get_nsfd(cfd: int, nstype: int) -> int:
+    return raw_ioctl(cfd, ROOTNS_GET_NSFD, nstype)
+
+
+def rootns_wait(cfd: int, flags: int = 0) -> WaitResult:
+    args = RootnsWaitArgs(flags=flags, status=0)
+    pid = raw_ioctl(cfd, ROOTNS_WAIT, ctypes.addressof(args))
+    return WaitResult(pid=pid, status=int(args.status))
+
+
+def rootns_kill(cfd: int, sig: int) -> None:
+    mask = (1 << (ctypes.sizeof(ctypes.c_ulong) * 8)) - 1
+    raw_ioctl(cfd, ROOTNS_KILL, sig & mask)
+
+
+def fsopen(fsname: str | bytes, flags: int = FSOPEN_CLOEXEC) -> int:
+    return syscall(
+        NR["fsopen"], ctypes.c_char_p(_cstr(fsname)), ctypes.c_uint(flags)
+    )
+
+
+def fsconfig(
+    fsfd: int,
+    cmd: int,
+    key: str | bytes | None = None,
+    value: str | bytes | None = None,
+    aux: int = 0,
+) -> None:
+    k_ptr = (
+        ctypes.c_char_p(_cstr(key)) if key is not None else ctypes.c_void_p(0)
+    )
+    v_ptr = (
+        ctypes.c_char_p(_cstr(value))
+        if value is not None
+        else ctypes.c_void_p(0)
+    )
+    syscall(
+        NR["fsconfig"],
+        ctypes.c_int(fsfd),
+        ctypes.c_uint(cmd),
+        k_ptr,
+        v_ptr,
+        ctypes.c_int(aux),
+    )
+
+
+def fsmount(
+    fsfd: int, flags: int = FSMOUNT_CLOEXEC, attr_flags: int = 0
+) -> int:
+    return syscall(
+        NR["fsmount"],
+        ctypes.c_int(fsfd),
+        ctypes.c_uint(flags),
+        ctypes.c_uint(attr_flags),
+    )
+
+
+def open_tree(dfd: int, path: str | bytes, flags: int) -> int:
+    return syscall(
+        NR["open_tree"],
+        ctypes.c_int(dfd),
+        ctypes.c_char_p(_cstr(path)),
+        ctypes.c_uint(flags),
+    )
+
+
+def move_mount(
+    from_dfd: int,
+    from_path: str | bytes,
+    to_dfd: int,
+    to_path: str | bytes,
+    flags: int,
+) -> None:
+    syscall(
+        NR["move_mount"],
+        ctypes.c_int(from_dfd),
+        ctypes.c_char_p(_cstr(from_path)),
+        ctypes.c_int(to_dfd),
+        ctypes.c_char_p(_cstr(to_path)),
+        ctypes.c_uint(flags),
+    )
+
+
+def openat2(
+    dfd: int,
+    path: str | bytes,
+    flags: int,
+    mode: int = 0,
+    resolve: int = 0,
+) -> int:
+    how = OpenHow(flags=flags, mode=mode, resolve=resolve)
+    return syscall(
+        NR["openat2"],
+        ctypes.c_int(dfd),
+        ctypes.c_char_p(_cstr(path)),
+        ctypes.byref(how),
+        ctypes.c_size_t(ctypes.sizeof(how)),
+    )
+
+
+def execveat(
+    dfd: int,
+    path: str | bytes,
+    argv: Sequence[str],
+    envp: Mapping[str, str] | Sequence[str] | None = None,
+    flags: int = 0,
+) -> NoReturn:
+    c_argv = (ctypes.c_char_p * (len(argv) + 1))(
+        *[_cstr(a) for a in argv], None
+    )
+    if envp is None:
+        env_items = [f"{k}={v}" for k, v in os.environ.items()]
+    elif isinstance(envp, Mapping):
+        env_items = [f"{k}={v}" for k, v in envp.items()]
+    else:
+        env_items = list(envp)
+    c_envp = (ctypes.c_char_p * (len(env_items) + 1))(
+        *[_cstr(e) for e in env_items], None
+    )
+    syscall(
+        NR["execveat"],
+        ctypes.c_int(dfd),
+        ctypes.c_char_p(_cstr(path)),
+        c_argv,
+        c_envp,
+        ctypes.c_int(flags),
+    )
+    _os_err()
+
+
+def pidfd_open(pid: int, flags: int = 0) -> int:
+    return syscall(NR["pidfd_open"], ctypes.c_int(pid), ctypes.c_uint(flags))
+
+
+def pivot_root(new_root: str | bytes, put_old: str | bytes) -> None:
+    syscall(
+        NR["pivot_root"],
+        ctypes.c_char_p(_cstr(new_root)),
+        ctypes.c_char_p(_cstr(put_old)),
+    )
+
+
+def umount2(target: str | bytes, flags: int = 0) -> None:
+    syscall(NR["umount2"], ctypes.c_char_p(_cstr(target)), ctypes.c_int(flags))
+
+
+def make_mount_private(target: str | bytes = "/") -> None:
+    ret: int = LIBC.mount(
+        ctypes.c_char_p(b"none"),
+        ctypes.c_char_p(_cstr(target)),
+        ctypes.c_void_p(0),
+        ctypes.c_ulong(MS_REC | MS_PRIVATE),
+        ctypes.c_void_p(0),
+    )
+    if ret < 0:
+        _os_err()
+
+
+def setns(fd: int, nstype: int = 0) -> None:
+    ret: int = LIBC.setns(ctypes.c_int(fd), ctypes.c_int(nstype))
+    if ret < 0:
+        _os_err()
+
+
+def unshare(flags: int) -> None:
+    ret: int = LIBC.unshare(ctypes.c_int(flags))
+    if ret < 0:
+        _os_err()
+
+
+def setgroups_empty() -> None:
+    ret: int = LIBC.setgroups(ctypes.c_size_t(0), ctypes.c_void_p(0))
+    if ret < 0:
+        _os_err()
+
+
+def prctl(
+    option: int,
+    arg2: int = 0,
+    arg3: int = 0,
+    arg4: int = 0,
+    arg5: int = 0,
+) -> int:
+    ret: int = LIBC.prctl(
+        ctypes.c_int(option),
+        ctypes.c_ulong(arg2),
+        ctypes.c_ulong(arg3),
+        ctypes.c_ulong(arg4),
+        ctypes.c_ulong(arg5),
+    )
+    if ret < 0:
+        _os_err()
+    return int(ret)
+
+
+def clone3_raw(args: CloneArgs, size: int | None = None) -> int:
+    actual_size = ctypes.sizeof(args) if size is None else size
+    sys.stdout.flush()
+    sys.stderr.flush()
+    return syscall(
+        NR["clone3"], ctypes.byref(args), ctypes.c_size_t(actual_size)
+    )
+
+
+def clone_into_rootns(
+    cfd: int,
+    extra_flags: int = 0,
+    exit_signal: int = int(signal.SIGCHLD),
+) -> tuple[int, int]:
+    pidfd_cell = ctypes.c_int(-1)
+    args = CloneArgs()
+    args.flags = CLONE_INTO_ROOTNS | extra_flags
+    args.exit_signal = exit_signal
+    args.rootns = cfd & 0xFFFFFFFFFFFFFFFF
+    if extra_flags & CLONE_PIDFD:
+        args.pidfd = ctypes.addressof(pidfd_cell)
+    pid = clone3_raw(args)
+    return pid, int(pidfd_cell.value)
+
+
+def run_in_rootns(
+    cfd: int,
+    fn: Callable[[], int | None],
+    extra_flags: int = 0,
+) -> int:
+    pid, _ = clone_into_rootns(cfd, extra_flags=extra_flags)
+    if pid == 0:
+        try:
+            os.close(cfd)
+            rc = fn()
+            os._exit(0 if rc is None else int(rc))
+        except BaseException:
+            os._exit(126)
+    return pid
+
+
+def make_rootns_mount(
+    cfd: int,
+    fstype: str,
+    attr_flags: int = 0,
+    options: Mapping[str, str | None] | None = None,
+) -> int:
+    fsfd = fsopen(fstype, FSOPEN_CLOEXEC)
+    try:
+        fsconfig(fsfd, FSCONFIG_SET_ROOTNS, aux=cfd)
+        if options:
+            for k, v in options.items():
+                if v is None:
+                    fsconfig(fsfd, FSCONFIG_SET_FLAG, key=k)
+                else:
+                    fsconfig(fsfd, FSCONFIG_SET_STRING, key=k, value=str(v))
+        fsconfig(fsfd, FSCONFIG_CMD_CREATE)
+        return fsmount(fsfd, FSMOUNT_CLOEXEC, attr_flags)
+    finally:
+        os.close(fsfd)
+
+
+@dataclass
+class Cell:
+    name: str
+    flags: int = ROOTNS_KILL_ON_CLOSE | ROOTNS_CLOSE_ON_EXEC
+    cfd: int = field(init=False, default=-1)
+    mntns_fd: int = field(init=False, default=-1)
+    root_dfd: int = field(init=False, default=-1)
+    init_pid: int | None = field(init=False, default=None)
+    exit_status: int | None = field(init=False, default=None)
+
+    def __post_init__(self) -> None:
+        self.cfd = rootns(self.flags)
+        self.mntns_fd = rootns_get_nsfd(self.cfd, CLONE_NEWNS)
+
+    def __enter__(self) -> Cell:
+        return self
+
+    def __exit__(
+        self,
+        exc_type: type[BaseException] | None,
+        exc: BaseException | None,
+        tb: TracebackType | None,
+    ) -> None:
+        self.close()
+
+    def setup_rootfs(
+        self,
+        dirs: Sequence[str] = ("proc", "tmp", "mnt"),
+        mount_procfs: bool = True,
+        host_runtime: bool = False,
+    ) -> None:
+        rootfd = make_rootns_mount(self.cfd, "tmpfs")
+        bind_dirs: list[str] = []
+        try:
+            for d in dirs:
+                os.mkdir(d, 0o755, dir_fd=rootfd)
+            if host_runtime:
+                for entry in HOST_RUNTIME_ENTRIES:
+                    host_path = f"/{entry}"
+                    if os.path.islink(host_path):
+                        os.symlink(
+                            os.readlink(host_path), entry, dir_fd=rootfd
+                        )
+                    elif os.path.isdir(host_path):
+                        os.mkdir(entry, 0o755, dir_fd=rootfd)
+                        bind_dirs.append(entry)
+            move_mount(
+                rootfd,
+                "",
+                self.mntns_fd,
+                "/",
+                MOVE_MOUNT_F_EMPTY_PATH | MOVE_MOUNT_T_MNTNS,
+            )
+            self.root_dfd = rootfd
+            rootfd = -1
+        finally:
+            if rootfd >= 0:
+                os.close(rootfd)
+        for entry in bind_dirs:
+            self.bind_mount(f"/{entry}", entry)
+        if mount_procfs and "proc" in dirs:
+            self.mount_fs("proc", "proc")
+
+    def mount_fs(
+        self,
+        fstype: str,
+        target: str,
+        attr_flags: int = 0,
+        options: Mapping[str, str | None] | None = None,
+    ) -> None:
+        mfd = make_rootns_mount(
+            self.cfd, fstype, attr_flags=attr_flags, options=options
+        )
+        try:
+            move_mount(
+                mfd,
+                "",
+                self.mntns_fd,
+                target.lstrip("/"),
+                MOVE_MOUNT_F_EMPTY_PATH | MOVE_MOUNT_T_MNTNS,
+            )
+        finally:
+            os.close(mfd)
+
+    def bind_mount(self, host_src: str, target: str) -> None:
+        mfd = open_tree(
+            AT_FDCWD,
+            host_src,
+            OPEN_TREE_CLONE | AT_RECURSIVE | OPEN_TREE_CLOEXEC,
+        )
+        try:
+            move_mount(
+                mfd,
+                "",
+                self.mntns_fd,
+                target.lstrip("/"),
+                MOVE_MOUNT_F_EMPTY_PATH | MOVE_MOUNT_T_MNTNS,
+            )
+        finally:
+            os.close(mfd)
+
+    def spawn(
+        self,
+        argv: Sequence[str],
+        env: Mapping[str, str] | None = None,
+        resolve_in_root: bool = True,
+    ) -> int:
+        bin_fd = -1
+        if resolve_in_root and self.root_dfd >= 0:
+            bin_fd = openat2(
+                self.root_dfd,
+                argv[0],
+                os.O_RDONLY | os.O_CLOEXEC,
+                resolve=RESOLVE_IN_ROOT,
+            )
+        try:
+            pid, _ = clone_into_rootns(
+                self.cfd, extra_flags=CLONE_AUTOREAP, exit_signal=0
+            )
+            if pid == 0:
+                try:
+                    os.close(self.cfd)
+                    os.close(self.mntns_fd)
+                    if self.root_dfd >= 0:
+                        os.close(self.root_dfd)
+                    if bin_fd >= 0:
+                        execveat(bin_fd, "", argv, env, AT_EMPTY_PATH)
+                    if env is None:
+                        os.execv(argv[0], list(argv))
+                    else:
+                        os.execve(argv[0], list(argv), dict(env))
+                except BaseException:
+                    os._exit(127)
+            if self.init_pid is None:
+                self.init_pid = pid
+            return pid
+        finally:
+            if bin_fd >= 0:
+                os.close(bin_fd)
+
+    def kill(self, sig: int = int(signal.SIGTERM)) -> None:
+        rootns_kill(self.cfd, sig)
+
+    def wait(self, nohang: bool = False) -> WaitResult:
+        res = rootns_wait(self.cfd, os.WNOHANG if nohang else 0)
+        if res.pid > 0:
+            self.exit_status = res.status
+        return res
+
+    @property
+    def status_str(self) -> str:
+        if self.init_pid is None:
+            return "created"
+        if self.exit_status is None:
+            return "running"
+        return "exited"
+
+    def info(self) -> CellInfo:
+        code = (
+            os.waitstatus_to_exitcode(self.exit_status)
+            if self.exit_status is not None
+            else None
+        )
+        return CellInfo(
+            name=self.name,
+            state=self.status_str,
+            init_pid=self.init_pid,
+            exit_code=code,
+        )
+
+    def close(self) -> None:
+        for attr in ("root_dfd", "mntns_fd", "cfd"):
+            fd: int = getattr(self, attr, -1)
+            if fd >= 0:
+                try:
+                    os.close(fd)
+                except OSError:
+                    pass
+                setattr(self, attr, -1)
+
+
+class CellService:
+    def __init__(self, sock_path: str) -> None:
+        self.sock_path = sock_path
+        self.sel = selectors.DefaultSelector()
+        self.cells: dict[str, Cell] = {}
+        self.running = True
+        if os.path.exists(sock_path):
+            os.unlink(sock_path)
+        self.srv = socket.socket(
+            socket.AF_UNIX, socket.SOCK_STREAM | socket.SOCK_CLOEXEC
+        )
+        self.srv.bind(sock_path)
+        self.srv.listen(16)
+        self.srv.setblocking(False)
+        self.sel.register(self.srv, selectors.EVENT_READ, self._on_accept)
+
+    def _reap_children(self) -> None:
+        while True:
+            try:
+                pid, _ = os.waitpid(-1, os.WNOHANG)
+                if pid == 0:
+                    break
+            except ChildProcessError:
+                break
+
+    def _on_cell_event(self, cell: Cell) -> None:
+        try:
+            res = cell.wait(nohang=True)
+            if res.pid > 0:
+                try:
+                    self.sel.unregister(cell.cfd)
+                except KeyError:
+                    pass
+        except OSError:
+            pass
+        self._reap_children()
+
+    def _on_accept(self) -> None:
+        conn, _ = self.srv.accept()
+        with conn:
+            data = b""
+            while not data.endswith(b"\n"):
+                chunk = conn.recv(4096)
+                if not chunk:
+                    break
+                data += chunk
+            if not data:
+                return
+            try:
+                req: dict[str, Any] = json.loads(data.decode("utf-8"))
+                resp: dict[str, Any] = {
+                    "ok": True,
+                    "result": self._dispatch(req),
+                }
+            except Exception as exc:
+                resp = {
+                    "ok": False,
+                    "error": str(exc),
+                    "errno": getattr(exc, "errno", None),
+                }
+            conn.sendall((json.dumps(resp) + "\n").encode("utf-8"))
+
+    def _dispatch(self, req: Mapping[str, Any]) -> Any:
+        op = str(req["op"])
+        if op == "ping":
+            return "pong"
+        if op == "shutdown":
+            self.running = False
+            return "bye"
+        if op == "list":
+            self._reap_children()
+            return [asdict(c.info()) for c in self.cells.values()]
+
+        name = str(req["name"])
+        if op == "create":
+            if name in self.cells:
+                raise OSError(errno.EEXIST, f"cell {name} already exists")
+            cell = Cell(name)
+            try:
+                host_runtime = req.get("mode", "host") == "host"
+                cell.setup_rootfs(
+                    mount_procfs=bool(req.get("proc", True)),
+                    host_runtime=host_runtime,
+                )
+            except Exception:
+                cell.close()
+                raise
+            self.cells[name] = cell
+            self.sel.register(
+                cell.cfd,
+                selectors.EVENT_READ,
+                lambda c=cell: self._on_cell_event(c),
+            )
+            return asdict(cell.info())
+
+        cell_opt = self.cells.get(name)
+        if cell_opt is None:
+            raise OSError(errno.ENOENT, f"unknown cell {name}")
+        cell = cell_opt
+
+        if op in ("start", "exec"):
+            pid = cell.spawn(
+                list(req["argv"]),
+                resolve_in_root=bool(req.get("resolve_in_root", True)),
+            )
+            return asdict(SpawnInfo(pid=pid, state=cell.status_str))
+        if op == "mount":
+            if req.get("bind"):
+                cell.bind_mount(str(req["source"]), str(req["target"]))
+            else:
+                cell.mount_fs(
+                    str(req["source"]),
+                    str(req["target"]),
+                    options=req.get("options"),
+                )
+            return str(req["target"])
+        if op == "kill":
+            cell.kill(int(req.get("sig", int(signal.SIGTERM))))
+            return name
+        if op == "wait":
+            res = cell.wait(nohang=bool(req.get("nohang", False)))
+            self._reap_children()
+            return asdict(res)
+        if op == "destroy":
+            try:
+                self.sel.unregister(cell.cfd)
+            except KeyError:
+                pass
+            cell.close()
+            del self.cells[name]
+            self._reap_children()
+            return name
+        raise ValueError(f"unsupported op {op}")
+
+    def serve_forever(self) -> None:
+        try:
+            while self.running:
+                for key, _ in self.sel.select(timeout=0.2):
+                    cb: Callable[[], None] = key.data
+                    cb()
+                self._reap_children()
+        finally:
+            self.close()
+
+    def close(self) -> None:
+        for cell in list(self.cells.values()):
+            try:
+                self.sel.unregister(cell.cfd)
+            except KeyError:
+                pass
+            cell.close()
+        self.cells.clear()
+        try:
+            self.sel.unregister(self.srv)
+        except KeyError:
+            pass
+        self.srv.close()
+        self.sel.close()
+        if os.path.exists(self.sock_path):
+            os.unlink(self.sock_path)
+        self._reap_children()
+
+
+@dataclass(frozen=True)
+class CellClient:
+    sock_path: str
+
+    def call(self, **req: Any) -> Any:
+        with socket.socket(
+            socket.AF_UNIX, socket.SOCK_STREAM | socket.SOCK_CLOEXEC
+        ) as s:
+            s.connect(self.sock_path)
+            s.sendall((json.dumps(req) + "\n").encode("utf-8"))
+            data = b""
+            while not data.endswith(b"\n"):
+                chunk = s.recv(4096)
+                if not chunk:
+                    break
+                data += chunk
+        resp: dict[str, Any] = json.loads(data.decode("utf-8"))
+        if not resp["ok"]:
+            err = resp.get("errno")
+            if err is not None:
+                raise OSError(int(err), str(resp["error"]))
+            raise RuntimeError(str(resp["error"]))
+        return resp["result"]
+
+    def ping(self) -> str:
+        return str(self.call(op="ping"))
+
+    def shutdown(self) -> str:
+        return str(self.call(op="shutdown"))
+
+    def list_cells(self) -> list[CellInfo]:
+        items: list[dict[str, Any]] = self.call(op="list")
+        return [CellInfo(**item) for item in items]
+
+    def create(
+        self, name: str, mode: str = "host", proc: bool = True
+    ) -> CellInfo:
+        data: dict[str, Any] = self.call(
+            op="create", name=name, mode=mode, proc=proc
+        )
+        return CellInfo(**data)
+
+    def start(
+        self,
+        name: str,
+        argv: Sequence[str],
+        resolve_in_root: bool = True,
+    ) -> SpawnInfo:
+        data: dict[str, Any] = self.call(
+            op="start",
+            name=name,
+            argv=list(argv),
+            resolve_in_root=resolve_in_root,
+        )
+        return SpawnInfo(**data)
+
+    def exec_cmd(
+        self,
+        name: str,
+        argv: Sequence[str],
+        resolve_in_root: bool = True,
+    ) -> SpawnInfo:
+        data: dict[str, Any] = self.call(
+            op="exec",
+            name=name,
+            argv=list(argv),
+            resolve_in_root=resolve_in_root,
+        )
+        return SpawnInfo(**data)
+
+    def mount(
+        self,
+        name: str,
+        source: str,
+        target: str,
+        bind: bool = False,
+        options: Mapping[str, str | None] | None = None,
+    ) -> str:
+        return str(
+            self.call(
+                op="mount",
+                name=name,
+                source=source,
+                target=target,
+                bind=bind,
+                options=dict(options) if options is not None else None,
+            )
+        )
+
+    def kill(self, name: str, sig: int = int(signal.SIGTERM)) -> str:
+        return str(self.call(op="kill", name=name, sig=sig))
+
+    def wait(self, name: str, nohang: bool = False) -> WaitResult:
+        data: dict[str, Any] = self.call(op="wait", name=name, nohang=nohang)
+        return WaitResult(pid=int(data["pid"]), status=int(data["status"]))
+
+    def destroy(self, name: str) -> str:
+        return str(self.call(op="destroy", name=name))
+
+
+def _cli() -> None:
+    parser = argparse.ArgumentParser()
+    parser.add_argument("--sock", default="/tmp/rootns-cells.sock")
+    sub = parser.add_subparsers(dest="cmd", required=True)
+    sub.add_parser("daemon")
+    sub.add_parser("ps")
+    sub.add_parser("shutdown")
+
+    p_create = sub.add_parser("create")
+    p_create.add_argument("name")
+    p_create.add_argument("--mode", choices=("host", "tmpfs"), default="host")
+
+    for cname in ("start", "exec"):
+        p_run = sub.add_parser(cname)
+        p_run.add_argument("name")
+        p_run.add_argument("argv", nargs=argparse.REMAINDER)
+
+    p_mnt = sub.add_parser("mount")
+    p_mnt.add_argument("name")
+    p_mnt.add_argument("source")
+    p_mnt.add_argument("target")
+    p_mnt.add_argument("--bind", action="store_true")
+
+    p_kill = sub.add_parser("kill")
+    p_kill.add_argument("name")
+    p_kill.add_argument("-s", "--sig", type=int, default=int(signal.SIGTERM))
+
+    p_wait = sub.add_parser("wait")
+    p_wait.add_argument("name")
+
+    p_rm = sub.add_parser("destroy")
+    p_rm.add_argument("name")
+
+    args = parser.parse_args()
+    if args.cmd == "daemon":
+        CellService(args.sock).serve_forever()
+        return
+
+    client = CellClient(args.sock)
+    if args.cmd == "ps":
+        print(json.dumps([asdict(c) for c in client.list_cells()], indent=2))
+    elif args.cmd == "shutdown":
+        print(json.dumps(client.shutdown()))
+    elif args.cmd == "create":
+        print(json.dumps(asdict(client.create(args.name, mode=args.mode))))
+    elif args.cmd in ("start", "exec"):
+        argv = (
+            args.argv[1:]
+            if args.argv and args.argv[0] == "--"
+            else list(args.argv)
+        )
+        fn = client.start if args.cmd == "start" else client.exec_cmd
+        print(json.dumps(asdict(fn(args.name, argv))))
+    elif args.cmd == "mount":
+        print(
+            json.dumps(
+                client.mount(
+                    args.name, args.source, args.target, bind=args.bind
+                )
+            )
+        )
+    elif args.cmd == "kill":
+        print(json.dumps(client.kill(args.name, args.sig)))
+    elif args.cmd == "wait":
+        res = client.wait(args.name)
+        print(json.dumps({"pid": res.pid, "exit_code": res.exit_code}))
+    elif args.cmd == "destroy":
+        print(json.dumps(client.destroy(args.name)))
+
+
+if __name__ == "__main__":
+    _cli()
diff --git a/tools/testing/selftests/rootns/rootns_test.py b/tools/testing/selftests/rootns/rootns_test.py
new file mode 100755
index 000000000000..7594b7a40c0c
--- /dev/null
+++ b/tools/testing/selftests/rootns/rootns_test.py
@@ -0,0 +1,1161 @@
+#!/usr/bin/env python3
+# SPDX-License-Identifier: GPL-2.0
+#
+# Copyright (C) 2026 Opinsys Oy
+
+from __future__ import annotations
+
+import ctypes
+from dataclasses import dataclass
+import errno
+import os
+import select
+import shutil
+import signal
+import socket
+import sys
+import tempfile
+import time
+from typing import Final
+import unittest
+
+import rootns_cells as rc
+
+PYTHON_BIN: Final[str] = os.path.realpath(sys.executable)
+SKIP_EXIT: Final[int] = 77
+SKIP_ERRNOS: Final[tuple[int, ...]] = (
+    errno.ENOSYS,
+    errno.EPERM,
+    errno.EACCES,
+    errno.EINVAL,
+    errno.ENOSPC,
+)
+
+
+@dataclass(frozen=True)
+class Payload:
+    code: str
+
+    def argv(self) -> list[str]:
+        return [PYTHON_BIN, "-S", "-c", self.code]
+
+
+WAIT_MOUNT_PAYLOAD: Final[Payload] = Payload(
+    """\
+import os
+import sys
+import time
+
+if os.getpid() != 1:
+    sys.exit(1)
+deadline = time.monotonic() + 5.0
+while time.monotonic() < deadline:
+    if os.path.ismount("/mnt") and os.path.exists("/mnt/done"):
+        with open("/mnt/done", "rb") as f:
+            sys.exit(0 if f.read() == b"ok\\n" else 2)
+    time.sleep(0.02)
+sys.exit(3)
+"""
+)
+
+WRITE_MOUNT_PAYLOAD: Final[Payload] = Payload(
+    """\
+import os
+import sys
+
+if not os.path.ismount("/mnt"):
+    sys.exit(1)
+with open("/mnt/done.tmp", "wb") as f:
+    f.write(b"ok\\n")
+os.replace("/mnt/done.tmp", "/mnt/done")
+"""
+)
+
+PAUSE_PAYLOAD: Final[Payload] = Payload(
+    """\
+import signal
+
+signal.pause()
+"""
+)
+
+
+@dataclass(frozen=True)
+class ProbeResult:
+    supported: bool
+    reason: str = ""
+
+
+@dataclass
+class SyncPipe:
+    r_fd: int
+    w_fd: int
+
+    @classmethod
+    def create(cls) -> SyncPipe:
+        r_fd, w_fd = os.pipe2(os.O_CLOEXEC)
+        return cls(r_fd=r_fd, w_fd=w_fd)
+
+    def close_read(self) -> None:
+        if self.r_fd >= 0:
+            os.close(self.r_fd)
+            self.r_fd = -1
+
+    def close_write(self) -> None:
+        if self.w_fd >= 0:
+            os.close(self.w_fd)
+            self.w_fd = -1
+
+    def close(self) -> None:
+        self.close_read()
+        self.close_write()
+
+    def read_bytes(self, n: int = 1) -> bytes:
+        return os.read(self.r_fd, n)
+
+    def write_bytes(self, data: bytes = b"1") -> None:
+        os.write(self.w_fd, data)
+
+    def wait_in_child(self, exit_code: int = 0) -> int:
+        self.close_write()
+        self.read_bytes()
+        self.close_read()
+        return exit_code
+
+
+@dataclass(frozen=True)
+class NsTypeCase:
+    name: str
+    nstype: int
+
+
+@dataclass(frozen=True)
+class BadCloneCase:
+    name: str
+    flags: int
+    exit_signal: int = int(signal.SIGCHLD)
+    expected_errno: int = errno.EINVAL
+
+
+@dataclass(frozen=True)
+class SignalCase:
+    name: str
+    sig: int
+    expected_errno: int
+
+
+NS_TYPE_CASES: Final[tuple[NsTypeCase, ...]] = (
+    NsTypeCase("mnt", rc.CLONE_NEWNS),
+    NsTypeCase("cgroup", rc.CLONE_NEWCGROUP),
+    NsTypeCase("uts", rc.CLONE_NEWUTS),
+    NsTypeCase("ipc", rc.CLONE_NEWIPC),
+    NsTypeCase("user", rc.CLONE_NEWUSER),
+    NsTypeCase("net", rc.CLONE_NEWNET),
+    NsTypeCase("time", rc.CLONE_NEWTIME),
+)
+
+BAD_CLONE_CASES: Final[tuple[BadCloneCase, ...]] = (
+    BadCloneCase("newns", rc.CLONE_NEWNS),
+    BadCloneCase("newpid", rc.CLONE_NEWPID),
+    BadCloneCase("newuser", rc.CLONE_NEWUSER),
+    BadCloneCase("empty_mntns", rc.CLONE_EMPTY_MNTNS),
+    BadCloneCase("fs", rc.CLONE_FS),
+    BadCloneCase(
+        "thread",
+        rc.CLONE_THREAD | rc.CLONE_SIGHAND | rc.CLONE_VM,
+        exit_signal=0,
+    ),
+    BadCloneCase("parent", rc.CLONE_PARENT, exit_signal=0),
+    BadCloneCase("sysvsem", rc.CLONE_SYSVSEM),
+    BadCloneCase("vm", rc.CLONE_VM),
+    BadCloneCase("vm_vfork", rc.CLONE_VM | rc.CLONE_VFORK),
+)
+
+BAD_SIGNAL_CASES: Final[tuple[SignalCase, ...]] = (
+    SignalCase("negative", -1, errno.EINVAL),
+    SignalCase("out_of_range", 9999, errno.EINVAL),
+    SignalCase("empty_rootns", 0, errno.ESRCH),
+)
+
+
+def _pause_forever() -> int:
+    signal.pause()
+    return 0
+
+
+def _reap_exit_code(pid: int) -> int:
+    _, status = os.waitpid(pid, 0)
+    if os.WIFEXITED(status):
+        return os.WEXITSTATUS(status)
+    if os.WIFSIGNALED(status):
+        return 128 + os.WTERMSIG(status)
+    return 255
+
+
+def _drop_to_uid(uid: int) -> None:
+    try:
+        rc.setgroups_empty()
+    except OSError as exc:
+        if exc.errno != errno.EPERM:
+            raise
+    os.setresgid(uid, uid, uid)
+    os.setresuid(uid, uid, uid)
+    rc.prctl(rc.PR_SET_DUMPABLE, 1)
+
+
+def _write_ugid_map(pid: int, host_uid: int, host_gid: int) -> None:
+    try:
+        with open(f"/proc/{pid}/setgroups", "wb") as f:
+            f.write(b"deny\n")
+    except OSError:
+        pass
+    with open(f"/proc/{pid}/uid_map", "wb") as f:
+        f.write(f"0 {host_uid} 1\n".encode())
+    with open(f"/proc/{pid}/gid_map", "wb") as f:
+        f.write(f"0 {host_gid} 1\n".encode())
+
+
+def _probe_pre_idmap_mkdir() -> ProbeResult:
+    try:
+        cfd = rc.rootns()
+    except OSError as exc:
+        if exc.errno in SKIP_ERRNOS:
+            return ProbeResult(False, f"rootns() unavailable: {exc}")
+        raise
+    try:
+        try:
+            mfd = rc.make_rootns_mount(cfd, "tmpfs")
+        except OSError as exc:
+            return ProbeResult(False, f"tmpfs mount unavailable: {exc}")
+        try:
+            os.mkdir("probe", 0o755, dir_fd=mfd)
+            return ProbeResult(True)
+        except OSError as exc:
+            if exc.errno == errno.EOVERFLOW:
+                return ProbeResult(
+                    False, "pre-idmap submount setup requires mapped userns"
+                )
+            raise
+        finally:
+            os.close(mfd)
+    finally:
+        os.close(cfd)
+
+
+def _send_fd(sock: socket.socket, fd: int) -> None:
+    sock.sendmsg(
+        [b"F"], [(socket.SOL_SOCKET, socket.SCM_RIGHTS, ctypes.c_int(fd))]
+    )
+
+
+def _recv_fd(sock: socket.socket) -> int:
+    _, ancdata, _, _ = sock.recvmsg(
+        1, socket.CMSG_SPACE(ctypes.sizeof(ctypes.c_int))
+    )
+    for cmsg_lvl, cmsg_type, cmsg_data in ancdata:
+        if cmsg_lvl == socket.SOL_SOCKET and cmsg_type == socket.SCM_RIGHTS:
+            buf = cmsg_data[: ctypes.sizeof(ctypes.c_int)]
+            return int(ctypes.c_int.from_buffer_copy(buf).value)
+    raise RuntimeError("missing SCM_RIGHTS fd")
+
+
+def _create_rootns_as_uid(uid: int) -> tuple[int, int]:
+    s_parent, s_child = socket.socketpair(socket.AF_UNIX, socket.SOCK_DGRAM)
+    pid = os.fork()
+    if pid == 0:
+        s_parent.close()
+        try:
+            _drop_to_uid(uid)
+            cfd = rc.rootns()
+            _send_fd(s_child, cfd)
+            os.close(cfd)
+            os._exit(0)
+        except OSError as exc:
+            if exc.errno in SKIP_ERRNOS:
+                os._exit(SKIP_EXIT)
+            os._exit(1)
+        finally:
+            s_child.close()
+    s_child.close()
+    try:
+        rlist, _, _ = select.select([s_parent], [], [], 5.0)
+        cfd = _recv_fd(s_parent) if rlist else -1
+    finally:
+        s_parent.close()
+    code = _reap_exit_code(pid)
+    return code, cfd
+
+
+class CellServiceTest(unittest.TestCase):
+    tmpdir: str
+    sock_path: str
+    daemon_pid: int
+    client: rc.CellClient
+
+    def setUp(self) -> None:
+        probe = _probe_pre_idmap_mkdir()
+        if not probe.supported:
+            self.skipTest(probe.reason)
+        self.tmpdir = tempfile.mkdtemp(prefix="rootns-cells-")
+        self.sock_path = os.path.join(self.tmpdir, "cells.sock")
+        self.daemon_pid = os.fork()
+        if self.daemon_pid == 0:
+            try:
+                rc.CellService(self.sock_path).serve_forever()
+                os._exit(0)
+            except BaseException:
+                os._exit(1)
+        self.client = rc.CellClient(self.sock_path)
+        for _ in range(50):
+            if os.path.exists(self.sock_path):
+                try:
+                    if self.client.ping() == "pong":
+                        break
+                except OSError:
+                    pass
+            time.sleep(0.05)
+        else:
+            self.fail("CellService daemon failed to start")
+
+    def tearDown(self) -> None:
+        daemon_pid = getattr(self, "daemon_pid", 0)
+        if daemon_pid > 0:
+            try:
+                self.client.shutdown()
+            except Exception:
+                os.kill(daemon_pid, signal.SIGKILL)
+            _reap_exit_code(daemon_pid)
+        tmpdir = getattr(self, "tmpdir", "")
+        if tmpdir:
+            shutil.rmtree(tmpdir, ignore_errors=True)
+
+    def test_cell_lifecycle_exec_and_hot_mount(self) -> None:
+        info = self.client.create("alpha", mode="host")
+        self.assertEqual(info.state, "created")
+        self.assertEqual(
+            self.client.list_cells(),
+            [rc.CellInfo(name="alpha", state="created")],
+        )
+
+        started = self.client.start("alpha", WAIT_MOUNT_PAYLOAD.argv())
+        self.assertEqual(started.state, "running")
+
+        self.client.mount("alpha", "tmpfs", "/mnt")
+        self.client.exec_cmd("alpha", WRITE_MOUNT_PAYLOAD.argv())
+
+        res = self.client.wait("alpha")
+        self.assertGreater(res.pid, 0)
+        self.assertEqual(res.exit_code, 0)
+
+        self.client.destroy("alpha")
+        self.assertEqual(self.client.list_cells(), [])
+
+    def test_cell_broadcast_kill(self) -> None:
+        self.client.create("killme", mode="host")
+        self.client.start("killme", PAUSE_PAYLOAD.argv())
+        self.client.exec_cmd("killme", PAUSE_PAYLOAD.argv())
+
+        self.client.kill("killme", int(signal.SIGKILL))
+        res = self.client.wait("killme")
+        self.assertEqual(res.exit_code, -int(signal.SIGKILL))
+        self.client.destroy("killme")
+
+
+class RootnsUapiTest(unittest.TestCase):
+    probe: ProbeResult
+    cell: rc.Cell | None
+
+    def setUp(self) -> None:
+        self.probe = _probe_pre_idmap_mkdir()
+        self.cell = None
+        if self.probe.supported:
+            self.cell = rc.Cell("test")
+            self.cell.setup_rootfs(
+                dirs=("proc", "tmp", "mnt"), mount_procfs=True
+            )
+
+    def tearDown(self) -> None:
+        if self.cell is not None:
+            self.cell.close()
+
+    def _require_cell(self) -> rc.Cell:
+        if not self.probe.supported or self.cell is None:
+            self.skipTest(self.probe.reason)
+        return self.cell
+
+    def test_create_flags(self) -> None:
+        self._require_cell()
+        with self.assertRaises(OSError) as cm:
+            rc.rootns((~rc.ROOTNS_ALL_FLAGS) & 0xFFFFFFFF)
+        self.assertEqual(cm.exception.errno, errno.EINVAL)
+
+    def test_get_nsfd(self) -> None:
+        try:
+            cfd = rc.rootns()
+        except OSError as exc:
+            if exc.errno in SKIP_ERRNOS:
+                self.skipTest(f"rootns() unavailable: {exc}")
+            raise
+        try:
+            for case in NS_TYPE_CASES:
+                with self.subTest(ns=case.name):
+                    nsfd = rc.rootns_get_nsfd(cfd, case.nstype)
+                    try:
+                        self.assertEqual(
+                            rc.raw_ioctl(nsfd, rc.NS_GET_NSTYPE), case.nstype
+                        )
+                    finally:
+                        os.close(nsfd)
+
+            with self.assertRaises(OSError) as cm:
+                rc.rootns_get_nsfd(cfd, rc.CLONE_NEWPID)
+            self.assertEqual(cm.exception.errno, errno.ESRCH)
+
+            with self.assertRaises(OSError) as cm:
+                rc.rootns_get_nsfd(cfd, 0)
+            self.assertEqual(cm.exception.errno, errno.EINVAL)
+
+            mntns_fd = rc.rootns_get_nsfd(cfd, rc.CLONE_NEWNS)
+            rootfd = rc.make_rootns_mount(cfd, "tmpfs")
+            rc.move_mount(
+                rootfd,
+                "",
+                mntns_fd,
+                "/",
+                rc.MOVE_MOUNT_F_EMPTY_PATH | rc.MOVE_MOUNT_T_MNTNS,
+            )
+            os.close(rootfd)
+            os.close(mntns_fd)
+
+            hold = SyncPipe.create()
+            pid = rc.run_in_rootns(cfd, hold.wait_in_child)
+            hold.close_read()
+            try:
+                nsfd = rc.rootns_get_nsfd(cfd, rc.CLONE_NEWPID)
+                try:
+                    self.assertEqual(
+                        rc.raw_ioctl(nsfd, rc.NS_GET_NSTYPE), rc.CLONE_NEWPID
+                    )
+                finally:
+                    os.close(nsfd)
+            finally:
+                hold.close_write()
+                self.assertEqual(_reap_exit_code(pid), 0)
+        finally:
+            os.close(cfd)
+
+    def test_wait_poll_and_clone_dead(self) -> None:
+        cell = self._require_cell()
+        cfd = cell.cfd
+
+        with self.assertRaises(OSError) as cm:
+            rc.raw_ioctl(cfd, rc.ROOTNS_WAIT, 0)
+        self.assertEqual(cm.exception.errno, errno.EINVAL)
+
+        with self.assertRaises(OSError) as cm:
+            rc.rootns_wait(cfd, (~os.WNOHANG) & 0xFFFFFFFF)
+        self.assertEqual(cm.exception.errno, errno.EINVAL)
+
+        for wait_flags in (0, os.WNOHANG):
+            with self.assertRaises(OSError) as cm:
+                rc.rootns_wait(cfd, wait_flags)
+            self.assertEqual(cm.exception.errno, errno.ECHILD)
+
+        hold = SyncPipe.create()
+        pid = rc.run_in_rootns(cfd, lambda: hold.wait_in_child(42))
+        hold.close_read()
+
+        self.assertEqual(
+            rc.rootns_wait(cfd, os.WNOHANG), rc.WaitResult(0, 0)
+        )
+        poller = select.poll()
+        poller.register(cfd, select.POLLIN)
+        self.assertEqual(poller.poll(0), [])
+
+        hold.close_write()
+        events = poller.poll(5000)
+        self.assertTrue(any(ev & select.POLLHUP for _, ev in events))
+
+        res = rc.rootns_wait(cfd, os.WNOHANG)
+        self.assertEqual(res.pid, pid)
+        self.assertEqual(res.exit_code, 42)
+        self.assertEqual(_reap_exit_code(pid), 42)
+
+        with self.assertRaises(OSError) as cm:
+            rc.clone_into_rootns(cfd)
+        self.assertEqual(cm.exception.errno, errno.ESRCH)
+
+    def test_kill_ioctl_and_kill_on_close(self) -> None:
+        cell = self._require_cell()
+        cfd = cell.cfd
+
+        for case in BAD_SIGNAL_CASES:
+            with self.subTest(sig=case.name):
+                with self.assertRaises(OSError) as cm:
+                    rc.rootns_kill(cfd, case.sig)
+                self.assertEqual(cm.exception.errno, case.expected_errno)
+
+        ready = SyncPipe.create()
+        hold = SyncPipe.create()
+
+        def init_proc() -> int:
+            ready.close()
+            hold.close()
+            signal.pause()
+            return 0
+
+        def member_proc() -> int:
+            ready.close_read()
+            hold.close_read()
+            os.setsid()
+            gc = os.fork()
+            if gc == 0:
+                ready.write_bytes(b"r")
+                ready.close_write()
+                signal.pause()
+                os._exit(0)
+            ready.close_write()
+            signal.pause()
+            return 0
+
+        pid1 = rc.run_in_rootns(cfd, init_proc)
+        pid2 = rc.run_in_rootns(cfd, member_proc)
+        ready.close_write()
+        hold.close_write()
+
+        self.assertEqual(ready.read_bytes(), b"r")
+        ready.close_read()
+
+        rc.rootns_kill(cfd, 0)
+        rc.rootns_kill(cfd, int(signal.SIGKILL))
+        self.assertEqual(hold.read_bytes(), b"")
+        hold.close_read()
+
+        self.assertEqual(_reap_exit_code(pid2), 128 + int(signal.SIGKILL))
+        self.assertEqual(_reap_exit_code(pid1), 128 + int(signal.SIGKILL))
+
+        with rc.Cell(
+            "koc", flags=rc.ROOTNS_KILL_ON_CLOSE | rc.ROOTNS_CLOSE_ON_EXEC
+        ) as cell2:
+            cell2.setup_rootfs(mount_procfs=False)
+            pid_koc = rc.run_in_rootns(cell2.cfd, _pause_forever)
+        self.assertEqual(_reap_exit_code(pid_koc), 128 + int(signal.SIGKILL))
+
+    def test_proc_submount_and_nested_namespaces(self) -> None:
+        cell = self._require_cell()
+        cell.mount_fs("tmpfs", "mnt")
+
+        def inside() -> int:
+            if os.getpid() != 1:
+                return 1
+            pids = [e for e in os.listdir("/proc") if e.isdigit()]
+            if pids != ["1"]:
+                return 2
+            with open("/mnt/hello", "wb") as f:
+                f.write(b"ok")
+            rc.unshare(rc.CLONE_NEWUTS | rc.CLONE_NEWIPC | rc.CLONE_NEWNET)
+            return 0
+
+        pid = rc.run_in_rootns(cell.cfd, inside)
+        res = cell.wait()
+        self.assertEqual(res.pid, pid)
+        self.assertEqual(res.exit_code, 0)
+        self.assertEqual(_reap_exit_code(pid), 0)
+
+    def test_setns_owner_vs_foreign(self) -> None:
+        cell = self._require_cell()
+        hold = SyncPipe.create()
+        pid = rc.run_in_rootns(cell.cfd, hold.wait_in_child)
+        hold.close_read()
+        try:
+            uts_fd = os.open(
+                f"/proc/{pid}/ns/uts", os.O_RDONLY | os.O_CLOEXEC
+            )
+            try:
+                w1 = os.fork()
+                if w1 == 0:
+                    try:
+                        rc.setns(uts_fd, rc.CLONE_NEWUTS)
+                        os._exit(0)
+                    except BaseException:
+                        os._exit(1)
+                self.assertEqual(_reap_exit_code(w1), 0)
+
+                if os.geteuid() == 0:
+                    w2 = os.fork()
+                    if w2 == 0:
+                        try:
+                            _drop_to_uid(1000)
+                        except OSError:
+                            os._exit(0)
+                        try:
+                            rc.setns(uts_fd, rc.CLONE_NEWUTS)
+                            os._exit(2)
+                        except OSError as exc:
+                            os._exit(0 if exc.errno == errno.EPERM else 3)
+                    self.assertEqual(_reap_exit_code(w2), 0)
+            finally:
+                os.close(uts_fd)
+        finally:
+            hold.close_write()
+            _reap_exit_code(pid)
+
+    def test_mount_and_fsconfig_validation(self) -> None:
+        self._require_cell()
+        cfd = rc.rootns()
+        mntns_fd = rc.rootns_get_nsfd(cfd, rc.CLONE_NEWNS)
+        try:
+            with self.assertRaises(OSError) as cm:
+                rc.move_mount(
+                    rc.AT_FDCWD, "/", mntns_fd, "/", rc.MOVE_MOUNT_T_MNTNS
+                )
+            self.assertEqual(cm.exception.errno, errno.EINVAL)
+
+            m1 = rc.make_rootns_mount(cfd, "tmpfs")
+            try:
+                rc.move_mount(
+                    m1,
+                    "",
+                    mntns_fd,
+                    "/",
+                    rc.MOVE_MOUNT_F_EMPTY_PATH | rc.MOVE_MOUNT_T_MNTNS,
+                )
+            finally:
+                os.close(m1)
+
+            m2 = rc.make_rootns_mount(cfd, "tmpfs")
+            try:
+                for alias in ("/", "."):
+                    with self.assertRaises(OSError) as cm:
+                        rc.move_mount(
+                            m2,
+                            "",
+                            mntns_fd,
+                            alias,
+                            rc.MOVE_MOUNT_F_EMPTY_PATH | rc.MOVE_MOUNT_T_MNTNS,
+                        )
+                    self.assertEqual(cm.exception.errno, errno.EBUSY)
+                with self.assertRaises(OSError) as cm:
+                    rc.move_mount(
+                        m2,
+                        "",
+                        mntns_fd,
+                        ".",
+                        rc.MOVE_MOUNT_F_EMPTY_PATH
+                        | rc.MOVE_MOUNT_T_MNTNS
+                        | rc.MOVE_MOUNT_BENEATH,
+                    )
+                self.assertEqual(cm.exception.errno, errno.EINVAL)
+            finally:
+                os.close(m2)
+
+            fsfd = rc.fsopen("tmpfs")
+            try:
+                rc.fsconfig(fsfd, rc.FSCONFIG_SET_ROOTNS, aux=cfd)
+                with self.assertRaises(OSError) as cm:
+                    rc.fsconfig(fsfd, rc.FSCONFIG_SET_ROOTNS, aux=cfd)
+                self.assertEqual(cm.exception.errno, errno.EBUSY)
+            finally:
+                os.close(fsfd)
+
+            bad_proc = rc.fsopen("proc")
+            try:
+                w_nonanc = os.fork()
+                if w_nonanc == 0:
+                    try:
+                        rc.unshare(rc.CLONE_NEWPID)
+                        inner = os.fork()
+                        if inner == 0:
+                            try:
+                                rc.fsconfig(
+                                    bad_proc, rc.FSCONFIG_SET_ROOTNS, aux=cfd
+                                )
+                                os._exit(1)
+                            except OSError as exc:
+                                if exc.errno != errno.EINVAL:
+                                    os._exit(2)
+                            try:
+                                rc.fsconfig(bad_proc, rc.FSCONFIG_CMD_CREATE)
+                                os._exit(3)
+                            except OSError as exc:
+                                os._exit(0 if exc.errno == errno.EBUSY else 4)
+                        os._exit(_reap_exit_code(inner))
+                    except BaseException:
+                        os._exit(5)
+                self.assertEqual(_reap_exit_code(w_nonanc), 0)
+            finally:
+                os.close(bad_proc)
+
+            cfd_lock = rc.rootns()
+            lock_mntns = rc.rootns_get_nsfd(cfd_lock, rc.CLONE_NEWNS)
+            try:
+                rfd = rc.make_rootns_mount(cfd_lock, "tmpfs")
+                os.mkdir("host_sub", 0o755, dir_fd=rfd)
+                sfd = rc.open_tree(
+                    rc.AT_FDCWD,
+                    "/tmp",
+                    rc.OPEN_TREE_CLONE
+                    | rc.AT_RECURSIVE
+                    | rc.OPEN_TREE_CLOEXEC,
+                )
+                rc.move_mount(
+                    sfd, "", rfd, "host_sub", rc.MOVE_MOUNT_F_EMPTY_PATH
+                )
+                os.close(sfd)
+                rc.move_mount(
+                    rfd,
+                    "",
+                    lock_mntns,
+                    "/",
+                    rc.MOVE_MOUNT_F_EMPTY_PATH | rc.MOVE_MOUNT_T_MNTNS,
+                )
+                os.close(rfd)
+
+                def try_umount_locked() -> int:
+                    try:
+                        rc.umount2("/host_sub", rc.MNT_DETACH)
+                        return 1
+                    except OSError as exc:
+                        return 0 if exc.errno == errno.EINVAL else 2
+
+                p_lock = rc.run_in_rootns(cfd_lock, try_umount_locked)
+                self.assertEqual(_reap_exit_code(p_lock), 0)
+            finally:
+                os.close(lock_mntns)
+                os.close(cfd_lock)
+
+            if os.geteuid() == 0:
+                code, u_cfd = _create_rootns_as_uid(1000)
+                if code == 0 and u_cfd >= 0:
+                    try:
+                        u_mntns = rc.rootns_get_nsfd(u_cfd, rc.CLONE_NEWNS)
+                        m_root = rc.make_rootns_mount(u_cfd, "tmpfs")
+                        rc.move_mount(
+                            m_root,
+                            "",
+                            u_mntns,
+                            "/",
+                            rc.MOVE_MOUNT_F_EMPTY_PATH | rc.MOVE_MOUNT_T_MNTNS,
+                        )
+                        os.close(m_root)
+
+                        attacker = os.fork()
+                        if attacker == 0:
+                            try:
+                                _drop_to_uid(2000)
+                            except OSError:
+                                os._exit(0)
+                            fsfd2 = rc.fsopen("tmpfs")
+                            try:
+                                rc.fsconfig(
+                                    fsfd2, rc.FSCONFIG_SET_ROOTNS, aux=u_cfd
+                                )
+                                os._exit(1)
+                            except OSError as exc:
+                                if exc.errno != errno.EPERM:
+                                    os._exit(2)
+                            finally:
+                                os.close(fsfd2)
+                            try:
+                                rc.clone_into_rootns(u_cfd)
+                                os._exit(3)
+                            except OSError as exc:
+                                if exc.errno != errno.EPERM:
+                                    os._exit(4)
+                            os._exit(0)
+                        self.assertEqual(_reap_exit_code(attacker), 0)
+                        os.close(u_mntns)
+                    finally:
+                        os.close(u_cfd)
+        finally:
+            os.close(mntns_fd)
+            os.close(cfd)
+
+    def test_clone_flags_and_pidns_ancestry(self) -> None:
+        cell = self._require_cell()
+        cfd = cell.cfd
+
+        empty_cfd = rc.rootns()
+        try:
+            with self.assertRaises(OSError) as cm:
+                rc.clone_into_rootns(empty_cfd, rc.CLONE_VFORK)
+            self.assertEqual(cm.exception.errno, errno.ENOENT)
+        finally:
+            os.close(empty_cfd)
+
+        args = rc.CloneArgs(
+            flags=rc.CLONE_INTO_ROOTNS,
+            exit_signal=int(signal.SIGCHLD),
+            rootns=cfd,
+        )
+        with self.assertRaises(OSError) as cm:
+            rc.clone3_raw(args, size=rc.CLONE_ARGS_SIZE_VER2)
+        self.assertEqual(cm.exception.errno, errno.EINVAL)
+
+        for case in BAD_CLONE_CASES:
+            with self.subTest(flag=case.name):
+                with self.assertRaises(OSError) as cm:
+                    rc.clone_into_rootns(
+                        cfd,
+                        extra_flags=case.flags,
+                        exit_signal=case.exit_signal,
+                    )
+                self.assertEqual(cm.exception.errno, case.expected_errno)
+
+        allowed = (
+            rc.CLONE_VFORK
+            | rc.CLONE_PIDFD
+            | rc.CLONE_CLEAR_SIGHAND
+            | rc.CLONE_NNP
+        )
+        old_umask = os.umask(0o077)
+        try:
+            rc.prctl(rc.PR_SET_DUMPABLE, 1)
+            pid, pidfd = rc.clone_into_rootns(cfd, extra_flags=allowed)
+            if pid == 0:
+                cur_umask = os.umask(0o022)
+                dumpable = rc.prctl(rc.PR_GET_DUMPABLE)
+                ok = (
+                    os.getpid() == 1
+                    and rc.prctl(rc.PR_GET_NO_NEW_PRIVS) == 1
+                    and cur_umask == 0o077
+                    and dumpable != 1
+                )
+                os._exit(0 if ok else 1)
+        finally:
+            os.umask(old_umask)
+        self.assertGreaterEqual(pidfd, 0)
+        os.close(pidfd)
+        self.assertEqual(_reap_exit_code(pid), 0)
+
+        with rc.Cell("exdev") as cell2:
+            cell2.setup_rootfs(mount_procfs=False)
+            w = os.fork()
+            if w == 0:
+                try:
+                    rc.unshare(rc.CLONE_NEWPID)
+                    inner = os.fork()
+                    if inner == 0:
+                        try:
+                            rc.clone_into_rootns(cell2.cfd)
+                            os._exit(1)
+                        except OSError as exc:
+                            os._exit(0 if exc.errno == errno.EXDEV else 2)
+                    os._exit(_reap_exit_code(inner))
+                except BaseException:
+                    os._exit(3)
+            self.assertEqual(_reap_exit_code(w), 0)
+
+    def test_concurrent_bootstrap(self) -> None:
+        cell = self._require_cell()
+        cfd = cell.cfd
+        start = SyncPipe.create()
+        ready = SyncPipe.create()
+        init_gate = SyncPipe.create()
+        peer_gate = SyncPipe.create()
+
+        workers: list[int] = []
+        for idx in range(4):
+            wpid = os.fork()
+            if wpid == 0:
+                start.close_write()
+                ready.close_read()
+                init_gate.close_write()
+                peer_gate.close_write()
+                start.read_bytes()
+                start.close_read()
+
+                def entrant(worker_idx: int = idx) -> int:
+                    my_pid = os.getpid()
+                    ready.write_bytes(bytes([worker_idx, my_pid]))
+                    ready.close_write()
+                    gate = init_gate if my_pid == 1 else peer_gate
+                    gate.read_bytes()
+                    init_gate.close_read()
+                    peer_gate.close_read()
+                    return 0
+
+                cpid = rc.run_in_rootns(cfd, entrant)
+                ready.close_write()
+                init_gate.close_read()
+                peer_gate.close_read()
+                os._exit(0 if _reap_exit_code(cpid) == 0 else 1)
+            workers.append(wpid)
+
+        start.close_read()
+        ready.close_write()
+        init_gate.close_read()
+        peer_gate.close_read()
+        start.close_write()
+
+        seen_pids: set[int] = set()
+        init_idx = -1
+        for _ in range(4):
+            msg = ready.read_bytes(2)
+            self.assertEqual(len(msg), 2)
+            if msg[1] == 1:
+                init_idx = msg[0]
+            seen_pids.add(msg[1])
+        ready.close_read()
+
+        self.assertEqual(seen_pids, {1, 2, 3, 4})
+        self.assertGreaterEqual(init_idx, 0)
+
+        peer_gate.close_write()
+        for i, wpid in enumerate(workers):
+            if i != init_idx:
+                self.assertEqual(_reap_exit_code(wpid), 0)
+        init_gate.close_write()
+        self.assertEqual(_reap_exit_code(workers[init_idx]), 0)
+
+        res = cell.wait()
+        self.assertGreater(res.pid, 0)
+        self.assertEqual(res.exit_code, 0)
+
+    def test_pivot_root_and_standalone_mntns_hot_mount(self) -> None:
+        cell = self._require_cell()
+        go = SyncPipe.create()
+        ready = SyncPipe.create()
+        hold = SyncPipe.create()
+
+        def init_pivot() -> int:
+            go.close_write()
+            ready.close_read()
+            hold.close_write()
+            if go.read_bytes() != b"g":
+                return 1
+            go.close_read()
+            tfd = rc.fsopen("tmpfs")
+            rc.fsconfig(tfd, rc.FSCONFIG_CMD_CREATE)
+            mfd = rc.fsmount(tfd)
+            os.close(tfd)
+            os.mkdir("old_root", 0o755, dir_fd=mfd)
+            os.mkdir("sub", 0o755, dir_fd=mfd)
+            pfd = os.open(
+                "pivoted",
+                os.O_CREAT | os.O_WRONLY | os.O_CLOEXEC,
+                0o644,
+                dir_fd=mfd,
+            )
+            os.close(pfd)
+            rc.move_mount(
+                mfd, "", rc.AT_FDCWD, "/mnt", rc.MOVE_MOUNT_F_EMPTY_PATH
+            )
+            os.close(mfd)
+            os.chdir("/mnt")
+            rc.pivot_root(".", "old_root")
+            os.chdir("/")
+            rc.umount2("/old_root", rc.MNT_DETACH)
+            ready.write_bytes(b"p")
+            ready.close_write()
+            hold.read_bytes()
+            hold.close_read()
+            return 0
+
+        pid1 = rc.run_in_rootns(cell.cfd, init_pivot)
+        go.close_read()
+        ready.close_write()
+        hold.close_read()
+        try:
+            _write_ugid_map(pid1, os.geteuid(), os.getegid())
+            go.write_bytes(b"g")
+            go.close_write()
+
+            self.assertEqual(ready.read_bytes(), b"p")
+            ready.close_read()
+
+            cell.mount_fs("tmpfs", "sub")
+
+            pid2 = rc.run_in_rootns(
+                cell.cfd,
+                lambda: (
+                    0
+                    if os.path.exists("/pivoted") and os.path.ismount("/sub")
+                    else 1
+                ),
+            )
+            self.assertEqual(_reap_exit_code(pid2), 0)
+        finally:
+            hold.close_write()
+            self.assertEqual(_reap_exit_code(pid1), 0)
+
+        ext_ready = SyncPipe.create()
+        ext_hold = SyncPipe.create()
+        plain_pid = os.fork()
+        if plain_pid == 0:
+            ext_ready.close_read()
+            ext_hold.close_write()
+            try:
+                rc.unshare(rc.CLONE_NEWNS)
+                rc.make_mount_private("/")
+                tfd = rc.fsopen("tmpfs")
+                rc.fsconfig(tfd, rc.FSCONFIG_CMD_CREATE)
+                mfd = rc.fsmount(tfd)
+                os.close(tfd)
+                rc.move_mount(
+                    mfd, "", rc.AT_FDCWD, "/tmp", rc.MOVE_MOUNT_F_EMPTY_PATH
+                )
+                os.close(mfd)
+                os.mkdir("/tmp/target", 0o755)
+                ext_ready.write_bytes(b"r")
+                ext_ready.close_write()
+                ext_hold.read_bytes()
+                ext_hold.close_read()
+                os._exit(0 if os.path.ismount("/tmp/target") else 2)
+            except BaseException:
+                os._exit(1)
+        ext_ready.close_write()
+        ext_hold.close_read()
+        try:
+            self.assertEqual(ext_ready.read_bytes(), b"r")
+            ext_ready.close_read()
+            ext_mntns = os.open(
+                f"/proc/{plain_pid}/ns/mnt", os.O_RDONLY | os.O_CLOEXEC
+            )
+            try:
+                tfd = rc.fsopen("tmpfs")
+                rc.fsconfig(tfd, rc.FSCONFIG_CMD_CREATE)
+                mfd = rc.fsmount(tfd)
+                os.close(tfd)
+                with self.assertRaises(OSError) as cm:
+                    rc.move_mount(
+                        mfd,
+                        "",
+                        ext_mntns,
+                        "tmp/..",
+                        rc.MOVE_MOUNT_F_EMPTY_PATH | rc.MOVE_MOUNT_T_MNTNS,
+                    )
+                self.assertEqual(cm.exception.errno, errno.EBUSY)
+                with self.assertRaises(OSError) as cm:
+                    rc.move_mount(
+                        mfd,
+                        "",
+                        ext_mntns,
+                        "tmp/..",
+                        rc.MOVE_MOUNT_F_EMPTY_PATH
+                        | rc.MOVE_MOUNT_T_MNTNS
+                        | rc.MOVE_MOUNT_BENEATH,
+                    )
+                self.assertEqual(cm.exception.errno, errno.EINVAL)
+                rc.move_mount(
+                    mfd,
+                    "",
+                    ext_mntns,
+                    "tmp/target",
+                    rc.MOVE_MOUNT_F_EMPTY_PATH | rc.MOVE_MOUNT_T_MNTNS,
+                )
+                os.close(mfd)
+            finally:
+                os.close(ext_mntns)
+        finally:
+            ext_hold.close_write()
+        self.assertEqual(_reap_exit_code(plain_pid), 0)
+
+    def test_unprivileged_without_entering_userns(self) -> None:
+        worker = os.fork()
+        if worker == 0:
+            try:
+                if os.geteuid() == 0:
+                    try:
+                        _drop_to_uid(1000)
+                    except OSError as exc:
+                        if exc.errno == errno.EINVAL:
+                            os._exit(SKIP_EXIT)
+                        os._exit(1)
+
+                try:
+                    tfd = rc.fsopen("tmpfs")
+                except OSError as exc:
+                    if exc.errno != errno.EPERM:
+                        os._exit(2)
+                else:
+                    try:
+                        rc.fsconfig(tfd, rc.FSCONFIG_CMD_CREATE)
+                        os._exit(3)
+                    except OSError as exc:
+                        if exc.errno != errno.EPERM:
+                            os._exit(4)
+                    finally:
+                        os.close(tfd)
+
+                try:
+                    cfd = rc.rootns()
+                except OSError as exc:
+                    if exc.errno in SKIP_ERRNOS:
+                        os._exit(SKIP_EXIT)
+                    os._exit(5)
+
+                mntns_fd = rc.rootns_get_nsfd(cfd, rc.CLONE_NEWNS)
+                rootfd = rc.make_rootns_mount(cfd, "tmpfs")
+                rc.move_mount(
+                    rootfd,
+                    "",
+                    mntns_fd,
+                    "/",
+                    rc.MOVE_MOUNT_F_EMPTY_PATH | rc.MOVE_MOUNT_T_MNTNS,
+                )
+                os.close(rootfd)
+
+                go = SyncPipe.create()
+                ack = SyncPipe.create()
+
+                def unpriv_init() -> int:
+                    go.close_write()
+                    ack.close_read()
+                    rc.prctl(rc.PR_SET_DUMPABLE, 1)
+                    ack.write_bytes(b"d")
+                    if go.read_bytes() != b"1":
+                        return 1
+                    os.mkdir("/proc", 0o755)
+                    ack.write_bytes(b"m")
+                    ack.close_write()
+                    if go.read_bytes() != b"2":
+                        return 2
+                    go.close_read()
+                    pids = [e for e in os.listdir("/proc") if e.isdigit()]
+                    return 0 if pids == ["1"] else 3
+
+                pid = rc.run_in_rootns(cfd, unpriv_init)
+                go.close_read()
+                ack.close_write()
+
+                if ack.read_bytes() != b"d":
+                    os._exit(6)
+                _write_ugid_map(pid, os.geteuid(), os.getegid())
+                go.write_bytes(b"1")
+                if ack.read_bytes() != b"m":
+                    os._exit(6)
+                ack.close_read()
+
+                pfd = rc.make_rootns_mount(cfd, "proc")
+                rc.move_mount(
+                    pfd,
+                    "",
+                    mntns_fd,
+                    "proc",
+                    rc.MOVE_MOUNT_F_EMPTY_PATH | rc.MOVE_MOUNT_T_MNTNS,
+                )
+                os.close(pfd)
+                os.close(mntns_fd)
+
+                go.write_bytes(b"2")
+                go.close_write()
+
+                res = rc.rootns_wait(cfd)
+                os.close(cfd)
+                if res.pid != pid or res.exit_code != 0:
+                    os._exit(7)
+                if _reap_exit_code(pid) != 0:
+                    os._exit(8)
+                os._exit(0)
+            except BaseException:
+                os._exit(9)
+
+        code = _reap_exit_code(worker)
+        if code == SKIP_EXIT:
+            self.skipTest("unprivileged rootns unavailable")
+        self.assertEqual(code, 0)
+
+
+if __name__ == "__main__":
+    unittest.main()
diff --git a/tools/testing/selftests/rootns/test_smoke.sh b/tools/testing/selftests/rootns/test_smoke.sh
new file mode 100755
index 000000000000..2cb23ca2ad29
--- /dev/null
+++ b/tools/testing/selftests/rootns/test_smoke.sh
@@ -0,0 +1,11 @@
+#!/bin/sh
+# SPDX-License-Identifier: GPL-2.0
+
+# Kselftest framework requirement - SKIP code is 4.
+ksft_skip=4
+
+command -v python3 >/dev/null 2>&1 || exit $ksft_skip
+
+DIR="$(dirname "$(readlink -f "$0")")"
+PYTHONPATH="$DIR${PYTHONPATH:+:$PYTHONPATH}" \
+	python3 -m unittest -v rootns_test 2>&1
-- 
2.47.3

