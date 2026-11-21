Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795219840;
	b=hs84S4Y5a83dcCtuhcxEEdUamGKc2n+01NvydCSYraEad4tABtB3O0If+dPhNg1RYlIE
	 rPhd1MaGA03QOqc2ux4Pt2eJPOy2MlCFcubuojnoggt/W0nLIpEv/dx6jseDhW+XqES8l
	 Yjr6gtN+R9vqC5v9gFbpPrKlEhNhE2OuDFYBnP4sogRR2SfRvUVdKsvbXO7NLdd1Rob0j
	 N9lm7nRtUI7rsb7gIrQOd7h+uxq1eruhEx6x2hwiT3srcB/aalMlSwU+G1hzdb1Uyyw5m
	 z9VjTfceHsfzYZhC7HY5M+biylGBy2gUO7r3z9fp1NXIi02WyB843olawDCflUBy86w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795219840;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=SkROx6epYpesQyVP+vDK+4KcW7wf9mWHMPhSFU5UIy4=;
	b=UbNQUc3LxYTH1rPMvkod1Mkwo3aIkWD05Vkp82dksstEIUHaSa4JRll/le42SnBu6m2M
	 Rd+5TKCnCvob5hPixNDONllh9RBEYgImQW/oInR60RNLuQLmSvfHCa1wZtaIrtx3VZQCX
	 cdWPKzxSgk3n2DKxGA9Fzl2dKfZMD+ktMzhJ20YWKzRyOu83zkvuzB9SYhgWiIBixgMs9
	 g4lHzStU5AfYx2lrxlu8m4v1SKPvrP0tD1Y9WeNFFoyp04qcARMXe6dziFu4JvwEsVC3C
	 peNEMFlod8ecSvZg0hv16rZCfIvwXb2lOAE4g2mQ6syxch6r8aZXYk5PmXL4QSZuqlA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=On1ayHl1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 900C5606BA84;
	Sat, 21 Nov 2026 00:10:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=On1ayHl1
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id B58CA1F000EB;
	Sat, 21 Nov 2026 00:10:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795219839;
	bh=SkROx6epYpesQyVP+vDK+4KcW7wf9mWHMPhSFU5UIy4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=On1ayHl10p+yaN5tuMwxdRIGcBQlrbnot5kok3ijyoqyMKt/h5jnvUyu9GVTFiMac
	 v/xzprZ02EkXxYNLFTW8tnvX7qIKBBEvukpIfDBwLhBQWgzDSr6KQan7QA5JxXL/we
	 pRNHOZK5VEg3j2mDWqouN0mxFlWNmKrN4pKDTEldsd8bzA1Nqhi0EIvIVQIHvrMPyS
	 RcdC1BSuEJDz9cFIbfQio51FQsTgPUGu+tPolU1Rrda0pWm/WRhbl2qLBZtF1Uy2OW
	 QnOksznvccHeTV0okKKQgc20iwzf9/z4RfKF2JcOKuCYukD1H+ltjEKmPbTm60fErK
	 pSBneVkB7JwiQ==
From: Jarkko Sakkinen <jarkko@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: Jarkko Sakkinen <jarkko@kernel.org>,
	linux-api@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org,
	linux-security-module@vger.kernel.org,
	Alexander Mikhalitsyn <alex@amutable.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Andy Lutomirski <luto@amacapital.net>,
	Christian Brauner <brauner@kernel.org>,
	David Howells <dhowells@redhat.com>,
	Jan Kara <jack@suse.cz>,
	Jonathan Corbet <corbet@lwn.net>,
	Josef Bacik <josef@toxicpanda.com>,
	Kees Cook <kees@kernel.org>,
	Neal Gompa <neal@gompa.dev>,
	Paul Moore <paul@paul-moore.com>,
	Serge Hallyn <sergeh@kernel.org>,
	Zygmunt Krynicki <zygmunt.krynicki@canonical.com>
Subject: [RFC PATCH v5 24/25] selftests/rootns: Add root namespace test suite
Date: Sat, 21 Nov 2026 02:08:43 +0200
Message-ID: <20261121000844.1863324-25-jarkko@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261121000844.1863324-1-jarkko@kernel.org>
References: <20261121000844.1863324-1-jarkko@kernel.org>
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

Verify the root namespace, mount-namespace configuration, and
userns_set_idmap() uAPI and security invariants across privileged,
unprivileged, SCM_RIGHTS delegation, and edge-case scenarios.

Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
---
 tools/testing/selftests/Makefile              |    1 +
 tools/testing/selftests/rootns/Makefile       |    5 +
 tools/testing/selftests/rootns/config         |   10 +
 .../testing/selftests/rootns/rootns_cells.py  | 1400 ++++++++++++++
 tools/testing/selftests/rootns/rootns_test.py | 1645 +++++++++++++++++
 tools/testing/selftests/rootns/test_smoke.sh  |   10 +
 6 files changed, 3071 insertions(+)
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
index 000000000000..733e45b39a8a
--- /dev/null
+++ b/tools/testing/selftests/rootns/rootns_cells.py
@@ -0,0 +1,1400 @@
+#!/usr/bin/env python3
+# SPDX-License-Identifier: GPL-2.0
+#
+# Copyright (C) 2026 Opinsys Oy
+
+from __future__ import annotations
+
+import argparse
+from collections.abc import Callable, Mapping, Sequence
+from contextlib import suppress
+import ctypes
+from dataclasses import asdict, dataclass, field
+from enum import Enum, IntEnum, IntFlag
+import errno
+import json
+import os
+import platform
+import selectors
+import signal
+import socket
+import sys
+from types import TracebackType
+from typing import Any, ClassVar, Final, NoReturn
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
+
+class RootnsFlag(IntFlag):
+    NONE = 0
+    KILL_ON_CLOSE = 0x00000001
+    CLOSE_ON_EXEC = 0x00000002
+    DEFAULT = KILL_ON_CLOSE | CLOSE_ON_EXEC
+    ALL = KILL_ON_CLOSE | CLOSE_ON_EXEC
+
+
+class CloneFlag(IntFlag):
+    NONE = 0
+    NEWTIME = 0x00000080
+    VM = 0x00000100
+    FS = 0x00000200
+    FILES = 0x00000400
+    SIGHAND = 0x00000800
+    PIDFD = 0x00001000
+    VFORK = 0x00004000
+    PARENT = 0x00008000
+    THREAD = 0x00010000
+    NEWNS = 0x00020000
+    SYSVSEM = 0x00040000
+    NEWCGROUP = 0x02000000
+    NEWUTS = 0x04000000
+    NEWIPC = 0x08000000
+    NEWUSER = 0x10000000
+    NEWPID = 0x20000000
+    NEWNET = 0x40000000
+    CLEAR_SIGHAND = 1 << 32
+    INTO_CGROUP = 1 << 33
+    AUTOREAP = 1 << 34
+    NNP = 1 << 35
+    PIDFD_AUTOKILL = 1 << 36
+    EMPTY_MNTNS = 1 << 37
+    INTO_ROOTNS = 1 << 38
+
+
+class AtFlag(IntFlag):
+    NONE = 0
+    EMPTY_PATH = 0x1000
+    RECURSIVE = 0x8000
+
+
+class OpenTreeFlag(IntFlag):
+    CLONE = 1 << 0
+    CLOEXEC = os.O_CLOEXEC
+    RECURSIVE = 0x8000
+
+
+class MoveMountFlag(IntFlag):
+    F_EMPTY_PATH = 0x00000004
+    T_EMPTY_PATH = 0x00000040
+    T_MNTNS = 0x00000080
+    SET_GROUP = 0x00000100
+    BENEATH = 0x00000200
+    CLONE = 0x00000400
+
+
+class UsernsIdmapFlag(IntFlag):
+    NONE = 0
+    UID = 1 << 0
+    GID = 1 << 1
+    PROJID = 1 << 2
+    SETGROUPS_DENY = 1 << 3
+    ALL = 0x0F
+
+
+class MountAttrFlag(IntFlag):
+    NONE = 0
+    RDONLY = 0x00000001
+    NOSUID = 0x00000002
+    NODEV = 0x00000004
+
+
+class MountFlag(IntFlag):
+    REC = 0x4000
+    PRIVATE = 1 << 18
+    SHARED = 1 << 20
+
+
+class UmountFlag(IntFlag):
+    NONE = 0
+    DETACH = 2
+
+
+class ResolveFlag(IntFlag):
+    NONE = 0
+    IN_ROOT = 0x10
+
+
+class FsconfigCmd(IntEnum):
+    SET_FLAG = 0
+    SET_STRING = 1
+    CMD_CREATE = 6
+    SET_ROOTNS = 9
+
+
+class PrctlOp(IntEnum):
+    GET_DUMPABLE = 3
+    SET_DUMPABLE = 4
+    SET_KEEPCAPS = 8
+    GET_NO_NEW_PRIVS = 39
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
+    SIZE_VER2: ClassVar[int] = 88
+    SIZE_VER3: ClassVar[int] = 96
+
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
+class UsernsIdmapExtent(ctypes.Structure):
+    first: int
+    lower_first: int
+    count: int
+    reserved: int
+    _fields_ = [
+        ("first", ctypes.c_uint32),
+        ("lower_first", ctypes.c_uint32),
+        ("count", ctypes.c_uint32),
+        ("reserved", ctypes.c_uint32),
+    ]
+
+
+class CapHeader(ctypes.Structure):
+    VERSION_3: ClassVar[int] = 0x20080522
+
+    version: int
+    pid: int
+    _fields_ = [
+        ("version", ctypes.c_uint32),
+        ("pid", ctypes.c_int32),
+    ]
+
+
+class CapData(ctypes.Structure):
+    effective: int
+    permitted: int
+    inheritable: int
+    _fields_ = [
+        ("effective", ctypes.c_uint32),
+        ("permitted", ctypes.c_uint32),
+        ("inheritable", ctypes.c_uint32),
+    ]
+
+
+class UsernsIdmap(ctypes.Structure):
+    SIZE_VER0: ClassVar[int] = 40
+
+    flags: int
+    nr_uid_extents: int
+    uid_extents: int
+    nr_gid_extents: int
+    nr_projid_extents: int
+    gid_extents: int
+    projid_extents: int
+    _fields_ = [
+        ("flags", ctypes.c_uint32),
+        ("nr_uid_extents", ctypes.c_uint32),
+        ("uid_extents", ctypes.c_uint64),
+        ("nr_gid_extents", ctypes.c_uint32),
+        ("nr_projid_extents", ctypes.c_uint32),
+        ("gid_extents", ctypes.c_uint64),
+        ("projid_extents", ctypes.c_uint64),
+    ]
+
+
+class Sys:
+    AT_FDCWD: Final[int] = -100
+    FSOPEN_CLOEXEC: Final[int] = 0x00000001
+    FSMOUNT_CLOEXEC: Final[int] = 0x00000001
+    CAP_SETGID: Final[int] = 6
+    CAP_SETUID: Final[int] = 7
+    _WIDE_IOC_ARCHS: Final[tuple[str, ...]] = (
+        "ppc",
+        "ppc64",
+        "ppc64le",
+        "powerpc",
+        "sparc",
+        "sparc64",
+        "alpha",
+    )
+
+    @classmethod
+    def _is_wide_ioc_arch(cls) -> bool:
+        mach = platform.machine().lower()
+        return mach in cls._WIDE_IOC_ARCHS or mach.startswith("mips")
+
+    @classmethod
+    def ioc(cls, direction: int, magic: int, nr: int, size: int) -> int:
+        sizebits = 13 if cls._is_wide_ioc_arch() else 14
+        typeshift = 8
+        sizeshift = 16
+        dirshift = sizeshift + sizebits
+        return (
+            (direction << dirshift)
+            | (magic << typeshift)
+            | nr
+            | (size << sizeshift)
+        )
+
+    @classmethod
+    def io(cls, magic: int, nr: int) -> int:
+        none_dir = 1 if cls._is_wide_ioc_arch() else 0
+        return cls.ioc(none_dir, magic, nr, 0)
+
+    @classmethod
+    def iowr(cls, magic: int, nr: int, size: int) -> int:
+        rw = 6 if cls._is_wide_ioc_arch() else 3
+        return cls.ioc(rw, magic, nr, size)
+
+    @staticmethod
+    def _build_syscall_numbers() -> dict[str, int]:
+        mach = platform.machine().lower()
+        if mach == "alpha":
+            base = 110
+        elif mach.startswith("mips"):
+            base = 5000 if ctypes.sizeof(ctypes.c_void_p) == 8 else 4000
+        else:
+            base = 0
+
+        nums: dict[str, int] = {
+            "open_tree": base + 428,
+            "move_mount": base + 429,
+            "fsopen": base + 430,
+            "fsconfig": base + 431,
+            "fsmount": base + 432,
+            "clone3": base + 435,
+            "openat2": base + 437,
+            "userns_set_idmap": base + 473,
+            "rootns": base + 474,
+        }
+        legacy: dict[str, dict[str, int]] = {
+            "x86_64": {"pivot_root": 155, "umount2": 166, "execveat": 322},
+            "i386": {"pivot_root": 217, "umount2": 52, "execveat": 358},
+            "i686": {"pivot_root": 217, "umount2": 52, "execveat": 358},
+            "aarch64": {"pivot_root": 41, "umount2": 39, "execveat": 281},
+            "riscv64": {"pivot_root": 41, "umount2": 39, "execveat": 281},
+            "loongarch64": {
+                "pivot_root": 41,
+                "umount2": 39,
+                "execveat": 281,
+            },
+            "s390x": {"pivot_root": 217, "umount2": 52, "execveat": 354},
+            "ppc64le": {"pivot_root": 203, "umount2": 52, "execveat": 362},
+            "ppc64": {"pivot_root": 203, "umount2": 52, "execveat": 362},
+            "armv7l": {"pivot_root": 218, "umount2": 52, "execveat": 387},
+        }
+        nums.update(legacy.get(mach, legacy["x86_64"]))
+        return nums
+
+    _NR: ClassVar[dict[str, int]]
+    _LIBC: ClassVar[ctypes.CDLL]
+
+    @staticmethod
+    def _os_err() -> NoReturn:
+        err = ctypes.get_errno()
+        raise OSError(err, os.strerror(err))
+
+    @staticmethod
+    def _cstr(val: str | bytes) -> bytes:
+        return val if isinstance(val, bytes) else os.fsencode(val)
+
+    @classmethod
+    def syscall(cls, name: str, *args: Any) -> int:
+        ret: int = cls._LIBC.syscall(ctypes.c_long(cls._NR[name]), *args)
+        if ret < 0:
+            cls._os_err()
+        return int(ret)
+
+    @classmethod
+    def ioctl(cls, fd: int, cmd: int, arg: int = 0) -> int:
+        ret: int = cls._LIBC.ioctl(
+            ctypes.c_int(fd), ctypes.c_ulong(int(cmd)), ctypes.c_ulong(arg)
+        )
+        if ret < 0:
+            cls._os_err()
+        return int(ret)
+
+    @classmethod
+    def fsopen(cls, fsname: str | bytes, flags: int = FSOPEN_CLOEXEC) -> int:
+        return cls.syscall(
+            "fsopen", ctypes.c_char_p(cls._cstr(fsname)), ctypes.c_uint(flags)
+        )
+
+    @classmethod
+    def fsconfig(
+        cls,
+        fsfd: int,
+        cmd: FsconfigCmd,
+        key: str | bytes | None = None,
+        value: str | bytes | None = None,
+        aux: int = 0,
+    ) -> None:
+        k_ptr = (
+            ctypes.c_char_p(cls._cstr(key))
+            if key is not None
+            else ctypes.c_void_p(0)
+        )
+        v_ptr = (
+            ctypes.c_char_p(cls._cstr(value))
+            if value is not None
+            else ctypes.c_void_p(0)
+        )
+        cls.syscall(
+            "fsconfig",
+            ctypes.c_int(fsfd),
+            ctypes.c_uint(int(cmd)),
+            k_ptr,
+            v_ptr,
+            ctypes.c_int(aux),
+        )
+
+    @classmethod
+    def fsmount(
+        cls,
+        fsfd: int,
+        flags: int = FSMOUNT_CLOEXEC,
+        attr_flags: MountAttrFlag = MountAttrFlag.NONE,
+    ) -> int:
+        return cls.syscall(
+            "fsmount",
+            ctypes.c_int(fsfd),
+            ctypes.c_uint(flags),
+            ctypes.c_uint(int(attr_flags)),
+        )
+
+    @classmethod
+    def open_tree(
+        cls, dfd: int, path: str | bytes, flags: OpenTreeFlag
+    ) -> int:
+        return cls.syscall(
+            "open_tree",
+            ctypes.c_int(dfd),
+            ctypes.c_char_p(cls._cstr(path)),
+            ctypes.c_uint(int(flags)),
+        )
+
+    @classmethod
+    def move_mount(
+        cls,
+        from_dfd: int,
+        from_path: str | bytes,
+        to_dfd: int,
+        to_path: str | bytes,
+        flags: MoveMountFlag,
+    ) -> None:
+        cls.syscall(
+            "move_mount",
+            ctypes.c_int(from_dfd),
+            ctypes.c_char_p(cls._cstr(from_path)),
+            ctypes.c_int(to_dfd),
+            ctypes.c_char_p(cls._cstr(to_path)),
+            ctypes.c_uint(int(flags)),
+        )
+
+    @classmethod
+    def openat2(
+        cls,
+        dfd: int,
+        path: str | bytes,
+        flags: int,
+        mode: int = 0,
+        resolve: ResolveFlag = ResolveFlag.NONE,
+    ) -> int:
+        how = OpenHow(flags=flags, mode=mode, resolve=int(resolve))
+        return cls.syscall(
+            "openat2",
+            ctypes.c_int(dfd),
+            ctypes.c_char_p(cls._cstr(path)),
+            ctypes.byref(how),
+            ctypes.c_size_t(ctypes.sizeof(how)),
+        )
+
+    @classmethod
+    def execveat(
+        cls,
+        dfd: int,
+        path: str | bytes,
+        argv: Sequence[str],
+        envp: Mapping[str, str] | Sequence[str] | None = None,
+        flags: AtFlag = AtFlag.NONE,
+    ) -> NoReturn:
+        c_argv = (ctypes.c_char_p * (len(argv) + 1))(
+            *[cls._cstr(a) for a in argv], None
+        )
+        if envp is None:
+            env_items = [f"{k}={v}" for k, v in os.environ.items()]
+        elif isinstance(envp, Mapping):
+            env_items = [f"{k}={v}" for k, v in envp.items()]
+        else:
+            env_items = list(envp)
+        c_envp = (ctypes.c_char_p * (len(env_items) + 1))(
+            *[cls._cstr(e) for e in env_items], None
+        )
+        cls.syscall(
+            "execveat",
+            ctypes.c_int(dfd),
+            ctypes.c_char_p(cls._cstr(path)),
+            c_argv,
+            c_envp,
+            ctypes.c_int(int(flags)),
+        )
+        cls._os_err()
+
+    @classmethod
+    def pivot_root(cls, new_root: str | bytes, put_old: str | bytes) -> None:
+        cls.syscall(
+            "pivot_root",
+            ctypes.c_char_p(cls._cstr(new_root)),
+            ctypes.c_char_p(cls._cstr(put_old)),
+        )
+
+    @classmethod
+    def umount2(
+        cls, target: str | bytes, flags: UmountFlag = UmountFlag.NONE
+    ) -> None:
+        cls.syscall(
+            "umount2",
+            ctypes.c_char_p(cls._cstr(target)),
+            ctypes.c_int(int(flags)),
+        )
+
+    @classmethod
+    def set_mount_propagation(
+        cls,
+        target: str | bytes = "/",
+        flags: MountFlag = MountFlag.REC | MountFlag.PRIVATE,
+    ) -> None:
+        ret: int = cls._LIBC.mount(
+            ctypes.c_char_p(b"none"),
+            ctypes.c_char_p(cls._cstr(target)),
+            ctypes.c_void_p(0),
+            ctypes.c_ulong(int(flags)),
+            ctypes.c_void_p(0),
+        )
+        if ret < 0:
+            cls._os_err()
+
+    @classmethod
+    def setns(cls, fd: int, nstype: CloneFlag | int = 0) -> None:
+        if hasattr(os, "setns"):
+            os.setns(fd, int(nstype))
+            return
+        ret: int = cls._LIBC.setns(ctypes.c_int(fd), ctypes.c_int(int(nstype)))
+        if ret < 0:
+            cls._os_err()
+
+    @classmethod
+    def unshare(cls, flags: CloneFlag | int) -> None:
+        if hasattr(os, "unshare"):
+            os.unshare(int(flags))
+            return
+        ret: int = cls._LIBC.unshare(ctypes.c_int(int(flags)))
+        if ret < 0:
+            cls._os_err()
+
+    @classmethod
+    def setgroups_empty(cls) -> None:
+        ret: int = cls._LIBC.setgroups(ctypes.c_size_t(0), ctypes.c_void_p(0))
+        if ret < 0:
+            cls._os_err()
+
+    @classmethod
+    def drop_to_setid_helper(cls, uid: int) -> None:
+        cls.prctl(PrctlOp.SET_KEEPCAPS, 1)
+        try:
+            cls.setgroups_empty()
+        except OSError as exc:
+            if exc.errno != errno.EPERM:
+                raise
+        os.setresgid(uid, uid, uid)
+        os.setresuid(uid, uid, uid)
+        hdr = CapHeader(version=CapHeader.VERSION_3, pid=0)
+        mask = (1 << cls.CAP_SETGID) | (1 << cls.CAP_SETUID)
+        data = (CapData * 2)(
+            CapData(effective=mask, permitted=mask, inheritable=0),
+            CapData(effective=0, permitted=0, inheritable=0),
+        )
+        ret: int = cls._LIBC.capset(ctypes.byref(hdr), ctypes.byref(data))
+        if ret < 0:
+            cls._os_err()
+        cls.prctl(PrctlOp.SET_DUMPABLE, 1)
+
+    @classmethod
+    def prctl(
+        cls,
+        option: PrctlOp,
+        arg2: int = 0,
+        arg3: int = 0,
+        arg4: int = 0,
+        arg5: int = 0,
+    ) -> int:
+        ret: int = cls._LIBC.prctl(
+            ctypes.c_int(int(option)),
+            ctypes.c_ulong(arg2),
+            ctypes.c_ulong(arg3),
+            ctypes.c_ulong(arg4),
+            ctypes.c_ulong(arg5),
+        )
+        if ret < 0:
+            cls._os_err()
+        return int(ret)
+
+    @classmethod
+    def clone3(cls, args: CloneArgs, size: int | None = None) -> int:
+        actual_size = ctypes.sizeof(args) if size is None else size
+        sys.stdout.flush()
+        sys.stderr.flush()
+        return cls.syscall(
+            "clone3", ctypes.byref(args), ctypes.c_size_t(actual_size)
+        )
+
+    @staticmethod
+    def _extent_array(
+        extents: Sequence[tuple[int, int, int]],
+    ) -> ctypes.Array[UsernsIdmapExtent] | None:
+        if not extents:
+            return None
+        arr_t = UsernsIdmapExtent * len(extents)
+        return arr_t(
+            *[
+                UsernsIdmapExtent(
+                    first=first, lower_first=lower, count=count, reserved=0
+                )
+                for first, lower, count in extents
+            ]
+        )
+
+    @classmethod
+    def userns_set_idmap_raw(
+        cls,
+        userns_fd: int,
+        map_addr: int,
+        size: int = UsernsIdmap.SIZE_VER0,
+        flags: int = 0,
+    ) -> None:
+        cls.syscall(
+            "userns_set_idmap",
+            ctypes.c_int(userns_fd),
+            ctypes.c_void_p(map_addr),
+            ctypes.c_size_t(size),
+            ctypes.c_uint(flags),
+        )
+
+    @classmethod
+    def set_userns_idmap(
+        cls,
+        userns_fd: int,
+        uid_extents: Sequence[tuple[int, int, int]] = (),
+        gid_extents: Sequence[tuple[int, int, int]] = (),
+        projid_extents: Sequence[tuple[int, int, int]] = (),
+        *,
+        deny_setgroups: bool = False,
+        extra_flags: UsernsIdmapFlag | int = UsernsIdmapFlag.NONE,
+        size: int | None = None,
+        sys_flags: int = 0,
+    ) -> None:
+        flags = int(extra_flags)
+        u_arr = cls._extent_array(uid_extents)
+        g_arr = cls._extent_array(gid_extents)
+        p_arr = cls._extent_array(projid_extents)
+        if u_arr is not None:
+            flags |= int(UsernsIdmapFlag.UID)
+        if g_arr is not None:
+            flags |= int(UsernsIdmapFlag.GID)
+        if p_arr is not None:
+            flags |= int(UsernsIdmapFlag.PROJID)
+        if deny_setgroups:
+            flags |= int(UsernsIdmapFlag.SETGROUPS_DENY)
+        req = UsernsIdmap(
+            flags=flags,
+            nr_uid_extents=len(uid_extents),
+            uid_extents=ctypes.addressof(u_arr) if u_arr is not None else 0,
+            nr_gid_extents=len(gid_extents),
+            nr_projid_extents=len(projid_extents),
+            gid_extents=ctypes.addressof(g_arr) if g_arr is not None else 0,
+            projid_extents=ctypes.addressof(p_arr) if p_arr is not None else 0,
+        )
+        cls.userns_set_idmap_raw(
+            userns_fd,
+            ctypes.addressof(req),
+            ctypes.sizeof(req) if size is None else size,
+            sys_flags,
+        )
+
+
+Sys._NR = Sys._build_syscall_numbers()
+Sys._LIBC = ctypes.CDLL(None, use_errno=True)
+Sys._LIBC.syscall.restype = ctypes.c_long
+
+
+class Ioctl(IntEnum):
+    ROOTNS_GET_NSFD = Sys.io(0xB9, 0x01)
+    ROOTNS_WAIT = Sys.iowr(0xB9, 0x02, ctypes.sizeof(RootnsWaitArgs))
+    ROOTNS_KILL = Sys.io(0xB9, 0x03)
+    NS_GET_USERNS = Sys.io(0xB7, 0x01)
+    NS_GET_PARENT = Sys.io(0xB7, 0x02)
+    NS_GET_NSTYPE = Sys.io(0xB7, 0x03)
+
+
+class CellState(str, Enum):
+    CREATED = "created"
+    RUNNING = "running"
+    EXITED = "exited"
+
+
+class CellMode(str, Enum):
+    HOST = "host"
+    TMPFS = "tmpfs"
+
+
+class RpcOp(str, Enum):
+    PING = "ping"
+    SHUTDOWN = "shutdown"
+    LIST = "list"
+    CREATE = "create"
+    SPAWN = "spawn"
+    MOUNT = "mount"
+    KILL = "kill"
+    WAIT = "wait"
+    DESTROY = "destroy"
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
+    state: CellState
+    init_pid: int | None = None
+    exit_code: int | None = None
+
+
+@dataclass(frozen=True)
+class SpawnInfo:
+    pid: int
+    state: CellState
+
+
+class Rootns:
+    fd: int
+
+    def __init__(
+        self,
+        flags: RootnsFlag | int = RootnsFlag.DEFAULT,
+        *,
+        fd: int | None = None,
+    ) -> None:
+        if fd is not None:
+            self.fd = fd
+        else:
+            self.fd = Sys.syscall("rootns", ctypes.c_uint(int(flags)))
+
+    @classmethod
+    def from_fd(cls, fd: int) -> Rootns:
+        return cls(fd=fd)
+
+    def fileno(self) -> int:
+        return self.fd
+
+    def __enter__(self) -> Rootns:
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
+    def close(self) -> None:
+        if self.fd >= 0:
+            try:
+                os.close(self.fd)
+            except OSError:
+                pass
+            self.fd = -1
+
+    def get_nsfd(self, nstype: CloneFlag | int) -> int:
+        return Sys.ioctl(self.fd, Ioctl.ROOTNS_GET_NSFD, int(nstype))
+
+    def set_idmap(
+        self,
+        uid_extents: Sequence[tuple[int, int, int]] = (),
+        gid_extents: Sequence[tuple[int, int, int]] = (),
+        projid_extents: Sequence[tuple[int, int, int]] = (),
+        *,
+        deny_setgroups: bool = False,
+    ) -> None:
+        userns_fd = self.get_nsfd(CloneFlag.NEWUSER)
+        try:
+            Sys.set_userns_idmap(
+                userns_fd,
+                uid_extents=uid_extents,
+                gid_extents=gid_extents,
+                projid_extents=projid_extents,
+                deny_setgroups=deny_setgroups,
+            )
+        finally:
+            os.close(userns_fd)
+
+    def map_self_ugid(self) -> None:
+        self.set_idmap(
+            uid_extents=((0, os.geteuid(), 1),),
+            gid_extents=((0, os.getegid(), 1),),
+            deny_setgroups=True,
+        )
+
+    def wait(self, flags: int = 0) -> WaitResult:
+        args = RootnsWaitArgs(flags=flags, status=0)
+        pid = Sys.ioctl(self.fd, Ioctl.ROOTNS_WAIT, ctypes.addressof(args))
+        return WaitResult(pid=pid, status=int(args.status))
+
+    def kill(self, sig: signal.Signals | int) -> None:
+        mask = (1 << (ctypes.sizeof(ctypes.c_ulong) * 8)) - 1
+        Sys.ioctl(self.fd, Ioctl.ROOTNS_KILL, int(sig) & mask)
+
+    def clone_into(
+        self,
+        extra_flags: CloneFlag = CloneFlag.NONE,
+        exit_signal: int = int(signal.SIGCHLD),
+    ) -> tuple[int, int]:
+        pidfd_cell = ctypes.c_int(-1)
+        args = CloneArgs()
+        args.flags = int(CloneFlag.INTO_ROOTNS | extra_flags)
+        args.exit_signal = exit_signal
+        args.rootns = self.fd & 0xFFFFFFFFFFFFFFFF
+        if extra_flags & CloneFlag.PIDFD:
+            args.pidfd = ctypes.addressof(pidfd_cell)
+        pid = Sys.clone3(args)
+        return pid, int(pidfd_cell.value)
+
+    def run(
+        self,
+        fn: Callable[[], int | None],
+        extra_flags: CloneFlag = CloneFlag.NONE,
+    ) -> int:
+        pid, _ = self.clone_into(extra_flags=extra_flags)
+        if pid == 0:
+            try:
+                self.close()
+                rc = fn()
+                os._exit(0 if rc is None else int(rc))
+            except BaseException:
+                os._exit(126)
+        return pid
+
+    def make_mount(
+        self,
+        fstype: str,
+        attr_flags: MountAttrFlag = MountAttrFlag.NONE,
+        options: Mapping[str, str | None] | None = None,
+    ) -> int:
+        fsfd = Sys.fsopen(fstype)
+        try:
+            Sys.fsconfig(fsfd, FsconfigCmd.SET_ROOTNS, aux=self.fd)
+            if options:
+                for k, v in options.items():
+                    if v is None:
+                        Sys.fsconfig(fsfd, FsconfigCmd.SET_FLAG, key=k)
+                    else:
+                        Sys.fsconfig(
+                            fsfd, FsconfigCmd.SET_STRING, key=k, value=str(v)
+                        )
+            Sys.fsconfig(fsfd, FsconfigCmd.CMD_CREATE)
+            return Sys.fsmount(fsfd, attr_flags=attr_flags)
+        finally:
+            os.close(fsfd)
+
+
+@dataclass
+class Cell:
+    name: str
+    flags: RootnsFlag = RootnsFlag.DEFAULT
+    rns: Rootns = field(init=False)
+    mntns_fd: int = field(init=False, default=-1)
+    root_dfd: int = field(init=False, default=-1)
+    init_pid: int | None = field(init=False, default=None)
+    exit_status: int | None = field(init=False, default=None)
+
+    def __post_init__(self) -> None:
+        self.rns = Rootns(self.flags)
+        try:
+            self.mntns_fd = self.rns.get_nsfd(CloneFlag.NEWNS)
+        except Exception:
+            self.rns.close()
+            raise
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
+    @staticmethod
+    def _close_fd(fd: int) -> int:
+        if fd >= 0:
+            with suppress(OSError):
+                os.close(fd)
+        return -1
+
+    def _move_to_mntns(self, mfd: int, target: str) -> None:
+        Sys.move_mount(
+            mfd,
+            "",
+            self.mntns_fd,
+            target,
+            MoveMountFlag.F_EMPTY_PATH | MoveMountFlag.T_MNTNS,
+        )
+
+    def _consume_mount(self, mfd: int, target: str) -> None:
+        try:
+            self._move_to_mntns(mfd, target.lstrip("/"))
+        finally:
+            os.close(mfd)
+
+    def setup_rootfs(
+        self,
+        dirs: Sequence[str] = ("proc", "tmp", "mnt"),
+        mount_procfs: bool = True,
+        host_runtime: bool = False,
+        map_ugid: bool = True,
+    ) -> None:
+        if map_ugid:
+            self.rns.map_self_ugid()
+        rootfd = self.rns.make_mount("tmpfs")
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
+            self._move_to_mntns(rootfd, "/")
+        except Exception:
+            os.close(rootfd)
+            raise
+        self.root_dfd = rootfd
+        for entry in bind_dirs:
+            self.bind_mount(f"/{entry}", entry)
+        if mount_procfs and "proc" in dirs:
+            self.mount_fs("proc", "proc")
+
+    def mount_fs(
+        self,
+        fstype: str,
+        target: str,
+        attr_flags: MountAttrFlag = MountAttrFlag.NONE,
+        options: Mapping[str, str | None] | None = None,
+    ) -> None:
+        mfd = self.rns.make_mount(
+            fstype, attr_flags=attr_flags, options=options
+        )
+        self._consume_mount(mfd, target)
+
+    def bind_mount(self, host_src: str, target: str) -> None:
+        Sys.move_mount(
+            Sys.AT_FDCWD,
+            host_src,
+            self.mntns_fd,
+            target.lstrip("/"),
+            MoveMountFlag.T_MNTNS | MoveMountFlag.CLONE,
+        )
+
+    def spawn(
+        self,
+        argv: Sequence[str],
+        env: Mapping[str, str] | None = None,
+        resolve_in_root: bool = True,
+    ) -> int:
+        bin_fd = -1
+        if resolve_in_root and self.root_dfd >= 0:
+            bin_fd = Sys.openat2(
+                self.root_dfd,
+                argv[0],
+                os.O_RDONLY | os.O_CLOEXEC,
+                resolve=ResolveFlag.IN_ROOT,
+            )
+        try:
+            pid, _ = self.rns.clone_into(
+                extra_flags=CloneFlag.AUTOREAP, exit_signal=0
+            )
+            if pid == 0:
+                try:
+                    self.close()
+                    if bin_fd >= 0:
+                        Sys.execveat(bin_fd, "", argv, env, AtFlag.EMPTY_PATH)
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
+            self._close_fd(bin_fd)
+
+    def kill(self, sig: signal.Signals | int = signal.SIGTERM) -> None:
+        self.rns.kill(sig)
+
+    def wait(self, nohang: bool = False) -> WaitResult:
+        res = self.rns.wait(os.WNOHANG if nohang else 0)
+        if res.pid > 0:
+            self.exit_status = res.status
+        return res
+
+    @property
+    def state(self) -> CellState:
+        if self.init_pid is None:
+            return CellState.CREATED
+        if self.exit_status is None:
+            return CellState.RUNNING
+        return CellState.EXITED
+
+    def info(self) -> CellInfo:
+        code = (
+            os.waitstatus_to_exitcode(self.exit_status)
+            if self.exit_status is not None
+            else None
+        )
+        return CellInfo(
+            name=self.name,
+            state=self.state,
+            init_pid=self.init_pid,
+            exit_code=code,
+        )
+
+    def close(self) -> None:
+        self.root_dfd = self._close_fd(self.root_dfd)
+        self.mntns_fd = self._close_fd(self.mntns_fd)
+        self.rns.close()
+
+
+class JsonLine:
+    @staticmethod
+    def send(sock: socket.socket, payload: Mapping[str, Any]) -> None:
+        sock.sendall((json.dumps(payload) + "\n").encode("utf-8"))
+
+    @staticmethod
+    def recv(sock: socket.socket) -> dict[str, Any] | None:
+        with sock.makefile("r", encoding="utf-8") as reader:
+            line = reader.readline()
+        if not line:
+            return None
+        data: dict[str, Any] = json.loads(line)
+        return data
+
+
+class CellService:
+    def __init__(self, sock_path: str) -> None:
+        self.sock_path = sock_path
+        self.sel = selectors.DefaultSelector()
+        self.cells: dict[str, Cell] = {}
+        self.running = True
+        with suppress(FileNotFoundError):
+            os.unlink(sock_path)
+        self.srv = socket.socket(
+            socket.AF_UNIX, socket.SOCK_STREAM | socket.SOCK_CLOEXEC
+        )
+        self.srv.bind(sock_path)
+        self.srv.listen(16)
+        self.srv.setblocking(False)
+        self.sel.register(self.srv, selectors.EVENT_READ, self._on_accept)
+
+    def __enter__(self) -> CellService:
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
+    def _safe_unregister(self, fileobj: Any) -> None:
+        with suppress(KeyError, ValueError):
+            self.sel.unregister(fileobj)
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
+        with suppress(OSError):
+            res = cell.wait(nohang=True)
+            if res.pid > 0:
+                self._safe_unregister(cell.rns)
+        self._reap_children()
+
+    def _on_accept(self) -> None:
+        conn, _ = self.srv.accept()
+        with conn:
+            conn.setblocking(True)
+            try:
+                req = JsonLine.recv(conn)
+                if req is None:
+                    return
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
+            JsonLine.send(conn, resp)
+
+    def _dispatch(self, req: Mapping[str, Any]) -> Any:
+        op = RpcOp(req["op"])
+        if op is RpcOp.PING:
+            return "pong"
+        if op is RpcOp.SHUTDOWN:
+            self.running = False
+            return "bye"
+        if op is RpcOp.LIST:
+            self._reap_children()
+            return [asdict(c.info()) for c in self.cells.values()]
+
+        name = str(req["name"])
+        if op is RpcOp.CREATE:
+            if name in self.cells:
+                raise OSError(errno.EEXIST, f"cell {name} already exists")
+            mode = CellMode(req.get("mode", CellMode.HOST))
+            cell = Cell(name, flags=RootnsFlag.DEFAULT)
+            try:
+                cell.setup_rootfs(
+                    mount_procfs=bool(req.get("proc", True)),
+                    host_runtime=mode is CellMode.HOST,
+                )
+            except Exception:
+                cell.close()
+                raise
+            self.cells[name] = cell
+            self.sel.register(
+                cell.rns,
+                selectors.EVENT_READ,
+                lambda c=cell: self._on_cell_event(c),
+            )
+            return asdict(cell.info())
+
+        if name not in self.cells:
+            raise OSError(errno.ENOENT, f"unknown cell {name}")
+        cell = self.cells[name]
+
+        if op is RpcOp.SPAWN:
+            pid = cell.spawn(
+                list(req["argv"]),
+                resolve_in_root=bool(req.get("resolve_in_root", True)),
+            )
+            return asdict(SpawnInfo(pid=pid, state=cell.state))
+        if op is RpcOp.MOUNT:
+            if req.get("bind"):
+                cell.bind_mount(str(req["source"]), str(req["target"]))
+            else:
+                cell.mount_fs(
+                    str(req["source"]),
+                    str(req["target"]),
+                    options=req.get("options"),
+                )
+            return str(req["target"])
+        if op is RpcOp.KILL:
+            cell.kill(int(req.get("sig", int(signal.SIGTERM))))
+            return name
+        if op is RpcOp.WAIT:
+            res = cell.wait(nohang=bool(req.get("nohang", False)))
+            self._reap_children()
+            return asdict(res)
+        if op is RpcOp.DESTROY:
+            self._safe_unregister(cell.rns)
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
+            self._safe_unregister(cell.rns)
+            cell.close()
+        self.cells.clear()
+        self._safe_unregister(self.srv)
+        self.srv.close()
+        self.sel.close()
+        with suppress(FileNotFoundError):
+            os.unlink(self.sock_path)
+        self._reap_children()
+
+
+@dataclass(frozen=True)
+class CellClient:
+    sock_path: str
+
+    def call(self, op: RpcOp, **params: Any) -> Any:
+        with socket.socket(
+            socket.AF_UNIX, socket.SOCK_STREAM | socket.SOCK_CLOEXEC
+        ) as sock:
+            sock.connect(self.sock_path)
+            JsonLine.send(sock, {"op": op.value, **params})
+            resp = JsonLine.recv(sock)
+        if resp is None:
+            raise RuntimeError("empty RPC response")
+        if not resp["ok"]:
+            err = resp.get("errno")
+            if err is not None:
+                raise OSError(int(err), str(resp["error"]))
+            raise RuntimeError(str(resp["error"]))
+        return resp["result"]
+
+    @staticmethod
+    def _parse_cell_info(data: Mapping[str, Any]) -> CellInfo:
+        return CellInfo(
+            name=str(data["name"]),
+            state=CellState(data["state"]),
+            init_pid=data.get("init_pid"),
+            exit_code=data.get("exit_code"),
+        )
+
+    def ping(self) -> str:
+        return str(self.call(RpcOp.PING))
+
+    def shutdown(self) -> str:
+        return str(self.call(RpcOp.SHUTDOWN))
+
+    def list_cells(self) -> list[CellInfo]:
+        items: list[dict[str, Any]] = self.call(RpcOp.LIST)
+        return [self._parse_cell_info(item) for item in items]
+
+    def create(
+        self,
+        name: str,
+        mode: CellMode = CellMode.HOST,
+        proc: bool = True,
+    ) -> CellInfo:
+        data: dict[str, Any] = self.call(
+            RpcOp.CREATE,
+            name=name,
+            mode=mode.value,
+            proc=proc,
+        )
+        return self._parse_cell_info(data)
+
+    def spawn(
+        self,
+        name: str,
+        argv: Sequence[str],
+        resolve_in_root: bool = True,
+    ) -> SpawnInfo:
+        data: dict[str, Any] = self.call(
+            RpcOp.SPAWN,
+            name=name,
+            argv=list(argv),
+            resolve_in_root=resolve_in_root,
+        )
+        return SpawnInfo(pid=int(data["pid"]), state=CellState(data["state"]))
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
+                RpcOp.MOUNT,
+                name=name,
+                source=source,
+                target=target,
+                bind=bind,
+                options=dict(options) if options is not None else None,
+            )
+        )
+
+    def kill(
+        self, name: str, sig: signal.Signals | int = signal.SIGTERM
+    ) -> str:
+        return str(self.call(RpcOp.KILL, name=name, sig=int(sig)))
+
+    def wait(self, name: str, nohang: bool = False) -> WaitResult:
+        data: dict[str, Any] = self.call(RpcOp.WAIT, name=name, nohang=nohang)
+        return WaitResult(pid=int(data["pid"]), status=int(data["status"]))
+
+    def destroy(self, name: str) -> str:
+        return str(self.call(RpcOp.DESTROY, name=name))
+
+
+class CellCli:
+    @staticmethod
+    def build_parser() -> argparse.ArgumentParser:
+        parser = argparse.ArgumentParser()
+        parser.add_argument("--sock", default="/tmp/rootns-cells.sock")
+        sub = parser.add_subparsers(dest="cmd", required=True)
+        sub.add_parser("daemon")
+        sub.add_parser("ps")
+        sub.add_parser("shutdown")
+
+        p_create = sub.add_parser("create")
+        p_create.add_argument("name")
+        p_create.add_argument(
+            "--mode",
+            type=CellMode,
+            choices=tuple(CellMode),
+            default=CellMode.HOST,
+        )
+
+        for cname in ("start", "exec", "spawn"):
+            p_run = sub.add_parser(cname)
+            p_run.add_argument("name")
+            p_run.add_argument("argv", nargs=argparse.REMAINDER)
+
+        p_mnt = sub.add_parser("mount")
+        p_mnt.add_argument("name")
+        p_mnt.add_argument("source")
+        p_mnt.add_argument("target")
+        p_mnt.add_argument("--bind", action="store_true")
+
+        p_kill = sub.add_parser("kill")
+        p_kill.add_argument("name")
+        p_kill.add_argument(
+            "-s", "--sig", type=int, default=int(signal.SIGTERM)
+        )
+
+        p_wait = sub.add_parser("wait")
+        p_wait.add_argument("name")
+
+        p_rm = sub.add_parser("destroy")
+        p_rm.add_argument("name")
+        return parser
+
+    @classmethod
+    def main(cls, argv: Sequence[str] | None = None) -> None:
+        args = cls.build_parser().parse_args(argv)
+        if args.cmd == "daemon":
+            with CellService(args.sock) as srv:
+                srv.serve_forever()
+            return
+
+        client = CellClient(args.sock)
+        if args.cmd == "ps":
+            print(
+                json.dumps([asdict(c) for c in client.list_cells()], indent=2)
+            )
+        elif args.cmd == "shutdown":
+            print(json.dumps(client.shutdown()))
+        elif args.cmd == "create":
+            info = client.create(args.name, mode=args.mode)
+            print(json.dumps(asdict(info)))
+        elif args.cmd in ("start", "exec", "spawn"):
+            cmd_argv = (
+                args.argv[1:]
+                if args.argv and args.argv[0] == "--"
+                else list(args.argv)
+            )
+            print(json.dumps(asdict(client.spawn(args.name, cmd_argv))))
+        elif args.cmd == "mount":
+            print(
+                json.dumps(
+                    client.mount(
+                        args.name, args.source, args.target, bind=args.bind
+                    )
+                )
+            )
+        elif args.cmd == "kill":
+            print(json.dumps(client.kill(args.name, args.sig)))
+        elif args.cmd == "wait":
+            res = client.wait(args.name)
+            print(json.dumps({"pid": res.pid, "exit_code": res.exit_code}))
+        elif args.cmd == "destroy":
+            print(json.dumps(client.destroy(args.name)))
+
+
+if __name__ == "__main__":
+    CellCli.main()
diff --git a/tools/testing/selftests/rootns/rootns_test.py b/tools/testing/selftests/rootns/rootns_test.py
new file mode 100755
index 000000000000..756bfe605f8e
--- /dev/null
+++ b/tools/testing/selftests/rootns/rootns_test.py
@@ -0,0 +1,1645 @@
+#!/usr/bin/env python3
+# SPDX-License-Identifier: GPL-2.0
+#
+# Copyright (C) 2026 Opinsys Oy
+
+from __future__ import annotations
+
+from collections.abc import Callable, Iterator, Sequence
+from contextlib import contextmanager, suppress
+from dataclasses import dataclass
+import errno
+import importlib
+import json
+import os
+from pathlib import Path
+import select
+import shutil
+import signal
+import socket
+import sys
+import tempfile
+import time
+import traceback
+from types import TracebackType
+from typing import Any, Final, NoReturn
+import unittest
+
+from rootns_cells import (
+    Cell,
+    CellClient,
+    CellInfo,
+    CellMode,
+    CellService,
+    CellState,
+    CloneArgs,
+    CloneFlag,
+    FsconfigCmd,
+    Ioctl,
+    MountFlag,
+    MoveMountFlag,
+    OpenTreeFlag,
+    PrctlOp,
+    Rootns,
+    RootnsFlag,
+    Sys,
+    UmountFlag,
+    UsernsIdmap,
+    UsernsIdmapFlag,
+    WaitResult,
+)
+
+PYTHON_BIN: Final[str] = os.path.realpath(sys.executable)
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
+    def __enter__(self) -> SyncPipe:
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
+    def read_all(self) -> bytes:
+        chunks: list[bytes] = []
+        while True:
+            chunk = os.read(self.r_fd, 4096)
+            if not chunk:
+                break
+            chunks.append(chunk)
+        return b"".join(chunks)
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
+    nstype: CloneFlag
+
+
+@dataclass(frozen=True)
+class BadCloneCase:
+    name: str
+    flags: CloneFlag
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
+    NsTypeCase("mnt", CloneFlag.NEWNS),
+    NsTypeCase("cgroup", CloneFlag.NEWCGROUP),
+    NsTypeCase("uts", CloneFlag.NEWUTS),
+    NsTypeCase("ipc", CloneFlag.NEWIPC),
+    NsTypeCase("user", CloneFlag.NEWUSER),
+    NsTypeCase("net", CloneFlag.NEWNET),
+    NsTypeCase("time", CloneFlag.NEWTIME),
+)
+
+BAD_CLONE_CASES: Final[tuple[BadCloneCase, ...]] = (
+    BadCloneCase("newns", CloneFlag.NEWNS),
+    BadCloneCase("newpid", CloneFlag.NEWPID),
+    BadCloneCase("newuser", CloneFlag.NEWUSER),
+    BadCloneCase("empty_mntns", CloneFlag.EMPTY_MNTNS),
+    BadCloneCase("fs", CloneFlag.FS),
+    BadCloneCase(
+        "thread",
+        CloneFlag.THREAD | CloneFlag.SIGHAND | CloneFlag.VM,
+        exit_signal=0,
+    ),
+    BadCloneCase("parent", CloneFlag.PARENT, exit_signal=0),
+    BadCloneCase("sysvsem", CloneFlag.SYSVSEM),
+    BadCloneCase("vm", CloneFlag.VM),
+    BadCloneCase("vm_vfork", CloneFlag.VM | CloneFlag.VFORK),
+)
+
+BAD_SIGNAL_CASES: Final[tuple[SignalCase, ...]] = (
+    SignalCase("negative", -1, errno.EINVAL),
+    SignalCase("out_of_range", 9999, errno.EINVAL),
+    SignalCase("empty_rootns", 0, errno.ESRCH),
+)
+
+
+class RootnsTestBase(unittest.TestCase):
+    @staticmethod
+    @contextmanager
+    def closing_fd(fd: int) -> Iterator[int]:
+        try:
+            yield fd
+        finally:
+            os.close(fd)
+
+    @staticmethod
+    def pause_forever() -> int:
+        signal.pause()
+        return 0
+
+    @staticmethod
+    def reap_exit_code(pid: int) -> int:
+        _, status = os.waitpid(pid, 0)
+        if os.WIFEXITED(status):
+            return os.WEXITSTATUS(status)
+        if os.WIFSIGNALED(status):
+            return 128 + os.WTERMSIG(status)
+        return 255
+
+    @staticmethod
+    def drop_to_uid(uid: int) -> None:
+        try:
+            Sys.setgroups_empty()
+        except OSError as exc:
+            if exc.errno != errno.EPERM:
+                raise
+        os.setresgid(uid, uid, uid)
+        os.setresuid(uid, uid, uid)
+        Sys.prctl(PrctlOp.SET_DUMPABLE, 1)
+
+    @classmethod
+    def make_plain_mount(cls, fstype: str) -> int:
+        with cls.closing_fd(Sys.fsopen(fstype)) as fsfd:
+            Sys.fsconfig(fsfd, FsconfigCmd.CMD_CREATE)
+            return Sys.fsmount(fsfd)
+
+    @classmethod
+    def probe_pre_idmap_mkdir(cls) -> ProbeResult:
+        try:
+            rns = Rootns()
+        except OSError as exc:
+            if exc.errno in SKIP_ERRNOS:
+                return ProbeResult(False, f"rootns() unavailable: {exc}")
+            raise
+        with rns:
+            try:
+                rns.map_self_ugid()
+                mfd = rns.make_mount("tmpfs")
+            except OSError as exc:
+                return ProbeResult(False, f"rootns setup unavailable: {exc}")
+            with cls.closing_fd(mfd):
+                os.mkdir("probe", 0o755, dir_fd=mfd)
+                return ProbeResult(True)
+
+    def run_forked(self, fn: Callable[[], None]) -> None:
+        with SyncPipe.create() as pipe:
+            sys.stdout.flush()
+            sys.stderr.flush()
+            pid = os.fork()
+            if pid == 0:
+                pipe.close_read()
+                try:
+                    fn()
+                except unittest.SkipTest as exc:
+                    payload = json.dumps({"kind": "skip", "msg": str(exc)})
+                    pipe.write_bytes(payload.encode("utf-8"))
+                    pipe.close_write()
+                    os._exit(0)
+                except BaseException:
+                    payload = json.dumps(
+                        {"kind": "fail", "msg": traceback.format_exc()}
+                    )
+                    pipe.write_bytes(payload.encode("utf-8"))
+                    pipe.close_write()
+                    os._exit(1)
+                pipe.close_write()
+                os._exit(0)
+            pipe.close_write()
+            raw = pipe.read_all()
+            code = self.reap_exit_code(pid)
+        if raw:
+            info = json.loads(raw.decode("utf-8"))
+            if info["kind"] == "skip":
+                self.skipTest(str(info["msg"]))
+            self.fail(str(info["msg"]))
+        self.assertEqual(code, 0)
+
+    def create_rootns_as_uid(self, uid: int) -> Rootns | None:
+        s_parent, s_child = socket.socketpair(
+            socket.AF_UNIX, socket.SOCK_DGRAM
+        )
+        sys.stdout.flush()
+        sys.stderr.flush()
+        pid = os.fork()
+        if pid == 0:
+            s_parent.close()
+            try:
+                self.drop_to_uid(uid)
+                with Rootns() as rns:
+                    socket.send_fds(s_child, [b"F"], [rns.fd])
+                os._exit(0)
+            except OSError as exc:
+                os._exit(0 if exc.errno in SKIP_ERRNOS else 1)
+            finally:
+                s_child.close()
+        s_child.close()
+        fds: list[int] = []
+        try:
+            rlist, _, _ = select.select([s_parent], [], [], 5.0)
+            if rlist:
+                _, fds, _, _ = socket.recv_fds(s_parent, 1, 1)
+        finally:
+            s_parent.close()
+        code = self.reap_exit_code(pid)
+        if code != 0:
+            for fd in fds:
+                os.close(fd)
+            self.fail(f"create_rootns_as_uid({uid}) failed with status {code}")
+        return Rootns.from_fd(fds[0]) if fds else None
+
+
+class CellServiceTest(RootnsTestBase):
+    tmpdir: str
+    sock_path: str
+    daemon_pid: int
+    client: CellClient
+
+    def setUp(self) -> None:
+        probe = self.probe_pre_idmap_mkdir()
+        if not probe.supported:
+            self.skipTest(probe.reason)
+        self.daemon_pid = 0
+        self.tmpdir = tempfile.mkdtemp(prefix="rootns-cells-")
+        try:
+            self.sock_path = os.path.join(self.tmpdir, "cells.sock")
+            self.daemon_pid = os.fork()
+            if self.daemon_pid == 0:
+                try:
+                    with CellService(self.sock_path) as srv:
+                        srv.serve_forever()
+                    os._exit(0)
+                except BaseException:
+                    os._exit(1)
+            self.client = CellClient(self.sock_path)
+            for _ in range(50):
+                if os.path.exists(self.sock_path):
+                    try:
+                        if self.client.ping() == "pong":
+                            break
+                    except OSError:
+                        pass
+                time.sleep(0.05)
+            else:
+                self.fail("CellService daemon failed to start")
+        except BaseException:
+            self.tearDown()
+            raise
+
+    def tearDown(self) -> None:
+        daemon_pid = getattr(self, "daemon_pid", 0)
+        if daemon_pid > 0:
+            try:
+                self.client.shutdown()
+            except Exception:
+                os.kill(daemon_pid, signal.SIGKILL)
+            self.reap_exit_code(daemon_pid)
+        tmpdir = getattr(self, "tmpdir", "")
+        if tmpdir:
+            shutil.rmtree(tmpdir, ignore_errors=True)
+
+    def test_cell_lifecycle_exec_and_hot_mount(self) -> None:
+        info = self.client.create("alpha", mode=CellMode.HOST)
+        self.assertEqual(info.state, CellState.CREATED)
+        self.assertEqual(
+            self.client.list_cells(),
+            [CellInfo(name="alpha", state=CellState.CREATED)],
+        )
+
+        started = self.client.spawn("alpha", WAIT_MOUNT_PAYLOAD.argv())
+        self.assertEqual(started.state, CellState.RUNNING)
+
+        self.client.mount("alpha", "tmpfs", "/mnt")
+        self.client.spawn("alpha", WRITE_MOUNT_PAYLOAD.argv())
+
+        res = self.client.wait("alpha")
+        self.assertGreater(res.pid, 0)
+        self.assertEqual(res.exit_code, 0)
+
+        self.client.destroy("alpha")
+        self.assertEqual(self.client.list_cells(), [])
+
+    def test_cell_broadcast_kill(self) -> None:
+        self.client.create("killme", mode=CellMode.HOST)
+        self.client.spawn("killme", PAUSE_PAYLOAD.argv())
+        self.client.spawn("killme", PAUSE_PAYLOAD.argv())
+
+        self.client.kill("killme", signal.SIGKILL)
+        res = self.client.wait("killme")
+        self.assertEqual(res.exit_code, -int(signal.SIGKILL))
+        self.client.destroy("killme")
+
+
+class RootnsUapiTest(RootnsTestBase):
+    probe: ProbeResult
+    cell: Cell | None
+
+    def setUp(self) -> None:
+        self.probe = self.probe_pre_idmap_mkdir()
+        self.cell = None
+        if self.probe.supported:
+            cell = Cell("test")
+            try:
+                cell.setup_rootfs(
+                    dirs=("proc", "tmp", "mnt"), mount_procfs=True
+                )
+            except BaseException:
+                cell.close()
+                raise
+            self.cell = cell
+
+    def tearDown(self) -> None:
+        if self.cell is not None:
+            self.cell.close()
+
+    def _require_cell(self) -> Cell:
+        if not self.probe.supported or self.cell is None:
+            self.skipTest(self.probe.reason)
+        return self.cell
+
+    def test_create_flags(self) -> None:
+        self._require_cell()
+        with Rootns(RootnsFlag.NONE):
+            pass
+        with Rootns(RootnsFlag.DEFAULT):
+            pass
+        with self.assertRaises(OSError) as cm:
+            Rootns((~int(RootnsFlag.ALL)) & 0xFFFFFFFF)
+        self.assertEqual(cm.exception.errno, errno.EINVAL)
+
+    def test_get_nsfd(self) -> None:
+        try:
+            rns = Rootns()
+        except OSError as exc:
+            if exc.errno in SKIP_ERRNOS:
+                self.skipTest(f"rootns() unavailable: {exc}")
+            raise
+        with rns:
+            for case in NS_TYPE_CASES:
+                with self.subTest(ns=case.name):
+                    with self.closing_fd(rns.get_nsfd(case.nstype)) as nsfd:
+                        self.assertEqual(
+                            Sys.ioctl(nsfd, Ioctl.NS_GET_NSTYPE),
+                            int(case.nstype),
+                        )
+
+            with self.assertRaises(OSError) as cm:
+                rns.get_nsfd(CloneFlag.NEWPID)
+            self.assertEqual(cm.exception.errno, errno.ESRCH)
+
+            with self.assertRaises(OSError) as cm:
+                rns.get_nsfd(0)
+            self.assertEqual(cm.exception.errno, errno.EINVAL)
+
+            with (
+                self.closing_fd(rns.get_nsfd(CloneFlag.NEWNS)) as mntns_fd,
+                self.closing_fd(rns.make_mount("tmpfs")) as rootfd,
+            ):
+                Sys.move_mount(
+                    rootfd,
+                    "",
+                    mntns_fd,
+                    "/",
+                    MoveMountFlag.F_EMPTY_PATH | MoveMountFlag.T_MNTNS,
+                )
+
+            with SyncPipe.create() as hold:
+                pid = rns.run(hold.wait_in_child)
+                hold.close_read()
+                try:
+                    with self.closing_fd(
+                        rns.get_nsfd(CloneFlag.NEWPID)
+                    ) as nsfd:
+                        self.assertEqual(
+                            Sys.ioctl(nsfd, Ioctl.NS_GET_NSTYPE),
+                            int(CloneFlag.NEWPID),
+                        )
+                finally:
+                    hold.close_write()
+                    self.assertEqual(self.reap_exit_code(pid), 0)
+
+    def test_wait_poll_and_clone_dead(self) -> None:
+        cell = self._require_cell()
+        rns = cell.rns
+
+        with self.assertRaises(OSError) as cm:
+            Sys.ioctl(rns.fd, Ioctl.ROOTNS_WAIT, 0)
+        self.assertEqual(cm.exception.errno, errno.EINVAL)
+
+        with self.assertRaises(OSError) as cm:
+            rns.wait((~os.WNOHANG) & 0xFFFFFFFF)
+        self.assertEqual(cm.exception.errno, errno.EINVAL)
+
+        for wait_flags in (0, os.WNOHANG):
+            with self.assertRaises(OSError) as cm:
+                rns.wait(wait_flags)
+            self.assertEqual(cm.exception.errno, errno.ECHILD)
+
+        with SyncPipe.create() as hold:
+            pid = rns.run(lambda: hold.wait_in_child(42))
+            hold.close_read()
+
+            self.assertEqual(rns.wait(os.WNOHANG), WaitResult(0, 0))
+
+            def check_foreign_pidns_wait() -> None:
+                Sys.unshare(CloneFlag.NEWPID)
+
+                def check_inner_wait() -> None:
+                    with self.assertRaises(OSError) as cm_w:
+                        rns.wait(os.WNOHANG)
+                    self.assertEqual(cm_w.exception.errno, errno.ECHILD)
+
+                self.run_forked(check_inner_wait)
+
+            self.run_forked(check_foreign_pidns_wait)
+            poller = select.poll()
+            poller.register(rns, select.POLLIN)
+            self.assertEqual(poller.poll(0), [])
+            with select.epoll() as ep1, select.epoll() as ep2:
+                ep1.register(rns, select.EPOLLIN | select.EPOLLEXCLUSIVE)
+                ep2.register(rns, select.EPOLLIN | select.EPOLLEXCLUSIVE)
+                self.assertEqual(ep1.poll(0), [])
+                self.assertEqual(ep2.poll(0), [])
+
+                hold.close_write()
+                events = poller.poll(5000)
+                self.assertTrue(any(ev & select.POLLHUP for _, ev in events))
+                ep1_ev = ep1.poll(5.0)
+                ep2_ev = ep2.poll(5.0)
+                self.assertTrue(any(ev & select.EPOLLHUP for _, ev in ep1_ev))
+                self.assertTrue(any(ev & select.EPOLLHUP for _, ev in ep2_ev))
+
+        res = rns.wait(os.WNOHANG)
+        self.assertEqual(res.pid, pid)
+        self.assertEqual(res.exit_code, 42)
+        self.assertEqual(self.reap_exit_code(pid), 42)
+
+        with self.assertRaises(OSError) as cm:
+            rns.clone_into()
+        self.assertEqual(cm.exception.errno, errno.ESRCH)
+
+    def test_kill_ioctl_and_kill_on_close(self) -> None:
+        cell = self._require_cell()
+        rns = cell.rns
+
+        for case in BAD_SIGNAL_CASES:
+            with self.subTest(sig=case.name):
+                with self.assertRaises(OSError) as cm:
+                    rns.kill(case.sig)
+                self.assertEqual(cm.exception.errno, case.expected_errno)
+
+        with SyncPipe.create() as ready, SyncPipe.create() as hold:
+
+            def init_proc() -> int:
+                ready.close()
+                hold.close()
+                signal.pause()
+                return 0
+
+            def member_proc() -> int:
+                ready.close_read()
+                hold.close_read()
+                os.setsid()
+                gc = os.fork()
+                if gc == 0:
+                    ready.write_bytes(b"r")
+                    ready.close_write()
+                    signal.pause()
+                    os._exit(0)
+                ready.close_write()
+                signal.pause()
+                return 0
+
+            pid1 = rns.run(init_proc)
+            pid2 = rns.run(member_proc)
+            ready.close_write()
+            hold.close_write()
+
+            self.assertEqual(ready.read_bytes(), b"r")
+            ready.close_read()
+
+            rns.kill(0)
+            rns.kill(signal.SIGKILL)
+            self.assertEqual(hold.read_bytes(), b"")
+            hold.close_read()
+
+            self.assertEqual(
+                self.reap_exit_code(pid2), 128 + int(signal.SIGKILL)
+            )
+            self.assertEqual(
+                self.reap_exit_code(pid1), 128 + int(signal.SIGKILL)
+            )
+
+        with Cell("koc", flags=RootnsFlag.DEFAULT) as cell2:
+            cell2.setup_rootfs(mount_procfs=False)
+            pid_koc = cell2.rns.run(self.pause_forever)
+        self.assertEqual(
+            self.reap_exit_code(pid_koc), 128 + int(signal.SIGKILL)
+        )
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
+            Sys.unshare(
+                CloneFlag.NEWUTS | CloneFlag.NEWIPC | CloneFlag.NEWNET
+            )
+            return 0
+
+        pid = cell.rns.run(inside)
+        res = cell.wait()
+        self.assertEqual(res.pid, pid)
+        self.assertEqual(res.exit_code, 0)
+        self.assertEqual(self.reap_exit_code(pid), 0)
+
+    def test_setns_owner_vs_foreign(self) -> None:
+        cell = self._require_cell()
+        with SyncPipe.create() as hold:
+            pid = cell.rns.run(hold.wait_in_child)
+            hold.close_read()
+            try:
+                with self.closing_fd(
+                    os.open(f"/proc/{pid}/ns/uts", os.O_RDONLY | os.O_CLOEXEC)
+                ) as uts_fd:
+                    self.run_forked(
+                        lambda: Sys.setns(uts_fd, CloneFlag.NEWUTS)
+                    )
+
+                    if os.geteuid() == 0:
+
+                        def check_foreign() -> None:
+                            try:
+                                self.drop_to_uid(1000)
+                            except OSError:
+                                return
+                            with self.assertRaises(OSError) as cm_perm:
+                                Sys.setns(uts_fd, CloneFlag.NEWUTS)
+                            self.assertEqual(
+                                cm_perm.exception.errno, errno.EPERM
+                            )
+
+                        self.run_forked(check_foreign)
+            finally:
+                hold.close_write()
+                self.reap_exit_code(pid)
+
+    def test_mount_and_fsconfig_validation(self) -> None:
+        self._require_cell()
+        with (
+            Rootns() as rns,
+            self.closing_fd(rns.get_nsfd(CloneFlag.NEWNS)) as mntns_fd,
+        ):
+            with self.assertRaises(OSError) as cm:
+                Sys.move_mount(
+                    Sys.AT_FDCWD, "/", mntns_fd, "/", MoveMountFlag.T_MNTNS
+                )
+            self.assertEqual(cm.exception.errno, errno.EINVAL)
+
+            with self.assertRaises(OSError) as cm:
+                Sys.move_mount(
+                    Sys.AT_FDCWD,
+                    "/tmp",
+                    Sys.AT_FDCWD,
+                    "/tmp",
+                    MoveMountFlag.CLONE,
+                )
+            self.assertEqual(cm.exception.errno, errno.EINVAL)
+
+            with self.assertRaises(OSError) as cm:
+                Sys.move_mount(
+                    Sys.AT_FDCWD,
+                    "/tmp",
+                    mntns_fd,
+                    "/",
+                    MoveMountFlag.T_MNTNS
+                    | MoveMountFlag.CLONE
+                    | MoveMountFlag.SET_GROUP,
+                )
+            self.assertEqual(cm.exception.errno, errno.EINVAL)
+
+            with self.closing_fd(rns.make_mount("tmpfs")) as m1:
+                Sys.move_mount(
+                    m1,
+                    "",
+                    mntns_fd,
+                    "/",
+                    MoveMountFlag.F_EMPTY_PATH | MoveMountFlag.T_MNTNS,
+                )
+
+            with self.closing_fd(rns.make_mount("tmpfs")) as m2:
+                for alias in ("/", "."):
+                    with self.assertRaises(OSError) as cm:
+                        Sys.move_mount(
+                            m2,
+                            "",
+                            mntns_fd,
+                            alias,
+                            MoveMountFlag.F_EMPTY_PATH | MoveMountFlag.T_MNTNS,
+                        )
+                    self.assertEqual(cm.exception.errno, errno.EBUSY)
+                with self.assertRaises(OSError) as cm:
+                    Sys.move_mount(
+                        m2,
+                        "",
+                        mntns_fd,
+                        ".",
+                        MoveMountFlag.F_EMPTY_PATH
+                        | MoveMountFlag.T_MNTNS
+                        | MoveMountFlag.BENEATH,
+                    )
+                self.assertEqual(cm.exception.errno, errno.EINVAL)
+
+            with self.closing_fd(Sys.fsopen("tmpfs")) as fsfd:
+                Sys.fsconfig(fsfd, FsconfigCmd.SET_ROOTNS, aux=rns.fd)
+                with self.assertRaises(OSError) as cm:
+                    Sys.fsconfig(fsfd, FsconfigCmd.SET_ROOTNS, aux=rns.fd)
+                self.assertEqual(cm.exception.errno, errno.EBUSY)
+
+            with (
+                Rootns() as other_rns,
+                self.closing_fd(
+                    other_rns.get_nsfd(CloneFlag.NEWNS)
+                ) as other_mntns,
+                self.closing_fd(rns.make_mount("tmpfs")) as bound_mfd,
+            ):
+                with self.assertRaises(OSError) as cm:
+                    Sys.move_mount(
+                        bound_mfd,
+                        "",
+                        other_mntns,
+                        "/",
+                        MoveMountFlag.F_EMPTY_PATH | MoveMountFlag.T_MNTNS,
+                    )
+                self.assertEqual(cm.exception.errno, errno.EINVAL)
+
+            with self.closing_fd(Sys.fsopen("proc")) as p_fsfd:
+                Sys.fsconfig(p_fsfd, FsconfigCmd.SET_ROOTNS, aux=rns.fd)
+                with self.assertRaises(OSError) as cm:
+                    Sys.fsconfig(
+                        p_fsfd,
+                        FsconfigCmd.SET_STRING,
+                        key="pidns",
+                        value="/proc/self/ns/pid",
+                    )
+                self.assertEqual(cm.exception.errno, errno.EBUSY)
+
+            with self.closing_fd(Sys.fsopen("proc")) as bad_proc:
+
+                def check_nonancestor_proc() -> None:
+                    Sys.unshare(CloneFlag.NEWPID)
+
+                    def check_inner() -> None:
+                        with self.assertRaises(OSError) as cm_set:
+                            Sys.fsconfig(
+                                bad_proc, FsconfigCmd.SET_ROOTNS, aux=rns.fd
+                            )
+                        self.assertEqual(cm_set.exception.errno, errno.EINVAL)
+                        with self.assertRaises(OSError) as cm_create:
+                            Sys.fsconfig(bad_proc, FsconfigCmd.CMD_CREATE)
+                        self.assertEqual(
+                            cm_create.exception.errno, errno.EBUSY
+                        )
+
+                    self.run_forked(check_inner)
+
+                self.run_forked(check_nonancestor_proc)
+
+            with (
+                Rootns() as rns_lock,
+                self.closing_fd(
+                    rns_lock.get_nsfd(CloneFlag.NEWNS)
+                ) as lock_mntns,
+                SyncPipe.create() as prop_ready,
+                SyncPipe.create() as prop_go,
+            ):
+                rns_lock.map_self_ugid()
+                with self.closing_fd(rns_lock.make_mount("tmpfs")) as rfd:
+                    os.mkdir("host_sub", 0o755, dir_fd=rfd)
+                    os.mkdir("prop_mnt", 0o755, dir_fd=rfd)
+                    Sys.move_mount(
+                        rfd,
+                        "",
+                        lock_mntns,
+                        "/",
+                        MoveMountFlag.F_EMPTY_PATH | MoveMountFlag.T_MNTNS,
+                    )
+                Sys.move_mount(
+                    Sys.AT_FDCWD,
+                    "/tmp",
+                    lock_mntns,
+                    "host_sub",
+                    MoveMountFlag.T_MNTNS | MoveMountFlag.CLONE,
+                )
+
+                def try_umount_locked() -> int:
+                    prop_ready.close_read()
+                    prop_go.close_write()
+                    try:
+                        Sys.umount2("/host_sub", UmountFlag.DETACH)
+                        return 1
+                    except OSError as exc:
+                        if exc.errno != errno.EINVAL:
+                            return 2
+                    Sys.set_mount_propagation(
+                        "/", MountFlag.REC | MountFlag.SHARED
+                    )
+                    peer = os.fork()
+                    if peer == 0:
+                        Sys.unshare(CloneFlag.NEWNS)
+                        prop_ready.write_bytes(b"p")
+                        prop_ready.close_write()
+                        if prop_go.read_bytes() != b"g":
+                            os._exit(3)
+                        prop_go.close_read()
+                        if not os.path.ismount("/prop_mnt"):
+                            os._exit(4)
+                        try:
+                            Sys.umount2("/prop_mnt", UmountFlag.DETACH)
+                            os._exit(5)
+                        except OSError as exc:
+                            os._exit(0 if exc.errno == errno.EINVAL else 6)
+                    prop_ready.close_write()
+                    prop_go.close_read()
+                    return self.reap_exit_code(peer)
+
+                p_lock = rns_lock.run(try_umount_locked)
+                prop_ready.close_write()
+                prop_go.close_read()
+                self.assertEqual(prop_ready.read_bytes(), b"p")
+                Sys.move_mount(
+                    Sys.AT_FDCWD,
+                    "/tmp",
+                    lock_mntns,
+                    "prop_mnt",
+                    MoveMountFlag.T_MNTNS | MoveMountFlag.CLONE,
+                )
+                prop_go.write_bytes(b"g")
+                prop_go.close_write()
+                self.assertEqual(self.reap_exit_code(p_lock), 0)
+
+            if os.geteuid() == 0:
+                u_rns = self.create_rootns_as_uid(1000)
+                if u_rns is not None:
+                    with (
+                        u_rns,
+                        self.closing_fd(
+                            u_rns.get_nsfd(CloneFlag.NEWNS)
+                        ) as u_mntns,
+                    ):
+                        with self.closing_fd(
+                            u_rns.make_mount("tmpfs")
+                        ) as m_root:
+                            Sys.move_mount(
+                                m_root,
+                                "",
+                                u_mntns,
+                                "/",
+                                MoveMountFlag.F_EMPTY_PATH
+                                | MoveMountFlag.T_MNTNS,
+                            )
+
+                        def check_attacker() -> None:
+                            try:
+                                self.drop_to_uid(2000)
+                            except OSError:
+                                return
+                            with self.closing_fd(Sys.fsopen("tmpfs")) as fsfd2:
+                                with self.assertRaises(OSError) as cm_fs:
+                                    Sys.fsconfig(
+                                        fsfd2,
+                                        FsconfigCmd.SET_ROOTNS,
+                                        aux=u_rns.fd,
+                                    )
+                                self.assertEqual(
+                                    cm_fs.exception.errno, errno.EPERM
+                                )
+                            with self.assertRaises(OSError) as cm_clone:
+                                u_rns.clone_into()
+                            self.assertEqual(
+                                cm_clone.exception.errno, errno.EPERM
+                            )
+
+                        self.run_forked(check_attacker)
+
+    def test_clone_flags_and_pidns_ancestry(self) -> None:
+        cell = self._require_cell()
+        rns = cell.rns
+
+        with Rootns() as empty_rns:
+            with self.assertRaises(OSError) as cm:
+                empty_rns.clone_into(CloneFlag.VFORK)
+            self.assertEqual(cm.exception.errno, errno.ENOENT)
+
+            with (
+                self.closing_fd(
+                    empty_rns.get_nsfd(CloneFlag.NEWNS)
+                ) as e_mntns,
+                self.closing_fd(empty_rns.make_mount("tmpfs")) as e_root,
+            ):
+                Sys.move_mount(
+                    e_root,
+                    "",
+                    e_mntns,
+                    "/",
+                    MoveMountFlag.F_EMPTY_PATH | MoveMountFlag.T_MNTNS,
+                )
+            with self.assertRaises(OSError) as cm:
+                empty_rns.clone_into(
+                    CloneFlag.AUTOREAP, exit_signal=int(signal.SIGCHLD)
+                )
+            self.assertEqual(cm.exception.errno, errno.EINVAL)
+
+        args = CloneArgs(
+            flags=int(CloneFlag.INTO_ROOTNS),
+            exit_signal=int(signal.SIGCHLD),
+            rootns=rns.fd,
+        )
+        with self.assertRaises(OSError) as cm:
+            Sys.clone3(args, size=CloneArgs.SIZE_VER2)
+        self.assertEqual(cm.exception.errno, errno.EINVAL)
+
+        for case in BAD_CLONE_CASES:
+            with self.subTest(flag=case.name):
+                with self.assertRaises(OSError) as cm:
+                    rns.clone_into(
+                        extra_flags=case.flags,
+                        exit_signal=case.exit_signal,
+                    )
+                self.assertEqual(cm.exception.errno, case.expected_errno)
+
+        allowed = (
+            CloneFlag.VFORK
+            | CloneFlag.PIDFD
+            | CloneFlag.CLEAR_SIGHAND
+            | CloneFlag.NNP
+        )
+        old_umask = os.umask(0o077)
+        try:
+            Sys.prctl(PrctlOp.SET_DUMPABLE, 1)
+            pid, pidfd = rns.clone_into(extra_flags=allowed)
+            if pid == 0:
+                cur_umask = os.umask(0o022)
+                dumpable = Sys.prctl(PrctlOp.GET_DUMPABLE)
+                ok = (
+                    os.getpid() == 1
+                    and Sys.prctl(PrctlOp.GET_NO_NEW_PRIVS) == 1
+                    and cur_umask == 0o077
+                    and dumpable != 1
+                )
+                os._exit(0 if ok else 1)
+        finally:
+            os.umask(old_umask)
+        self.assertGreaterEqual(pidfd, 0)
+        os.close(pidfd)
+        self.assertEqual(self.reap_exit_code(pid), 0)
+
+        with Cell("exdev") as cell2:
+            cell2.setup_rootfs(mount_procfs=False)
+
+            def check_exdev() -> None:
+                Sys.unshare(CloneFlag.NEWPID)
+
+                def check_inner() -> None:
+                    with self.assertRaises(OSError) as cm_exdev:
+                        cell2.rns.clone_into()
+                    self.assertEqual(cm_exdev.exception.errno, errno.EXDEV)
+
+                self.run_forked(check_inner)
+
+            self.run_forked(check_exdev)
+
+    def test_concurrent_bootstrap(self) -> None:
+        cell = self._require_cell()
+        rns = cell.rns
+        with (
+            SyncPipe.create() as start,
+            SyncPipe.create() as ready,
+            SyncPipe.create() as init_gate,
+            SyncPipe.create() as peer_gate,
+        ):
+            workers: list[int] = []
+            for idx in range(4):
+                wpid = os.fork()
+                if wpid == 0:
+                    start.close_write()
+                    ready.close_read()
+                    init_gate.close_write()
+                    peer_gate.close_write()
+                    start.read_bytes()
+                    start.close_read()
+
+                    def entrant(worker_idx: int = idx) -> int:
+                        my_pid = os.getpid()
+                        ready.write_bytes(bytes([worker_idx, my_pid]))
+                        ready.close_write()
+                        gate = init_gate if my_pid == 1 else peer_gate
+                        gate.read_bytes()
+                        init_gate.close_read()
+                        peer_gate.close_read()
+                        return 0
+
+                    cpid = rns.run(entrant)
+                    ready.close_write()
+                    init_gate.close_read()
+                    peer_gate.close_read()
+                    os._exit(0 if self.reap_exit_code(cpid) == 0 else 1)
+                workers.append(wpid)
+
+            start.close_read()
+            ready.close_write()
+            init_gate.close_read()
+            peer_gate.close_read()
+            start.close_write()
+
+            seen_pids: set[int] = set()
+            init_idx = -1
+            for _ in range(4):
+                msg = ready.read_bytes(2)
+                self.assertEqual(len(msg), 2)
+                if msg[1] == 1:
+                    init_idx = msg[0]
+                seen_pids.add(msg[1])
+            ready.close_read()
+
+            self.assertEqual(seen_pids, {1, 2, 3, 4})
+            self.assertGreaterEqual(init_idx, 0)
+
+            peer_gate.close_write()
+            for i, wpid in enumerate(workers):
+                if i != init_idx:
+                    self.assertEqual(self.reap_exit_code(wpid), 0)
+            init_gate.close_write()
+            self.assertEqual(self.reap_exit_code(workers[init_idx]), 0)
+
+        res = cell.wait()
+        self.assertGreater(res.pid, 0)
+        self.assertEqual(res.exit_code, 0)
+
+    def test_pivot_root_and_standalone_mntns_hot_mount(self) -> None:
+        cell = self._require_cell()
+        with (
+            SyncPipe.create() as ready,
+            SyncPipe.create() as hold,
+        ):
+
+            def init_pivot() -> int:
+                ready.close_read()
+                hold.close_write()
+                with self.closing_fd(self.make_plain_mount("tmpfs")) as mfd:
+                    os.mkdir("old_root", 0o755, dir_fd=mfd)
+                    os.mkdir("sub", 0o755, dir_fd=mfd)
+                    with self.closing_fd(
+                        os.open(
+                            "pivoted",
+                            os.O_CREAT | os.O_WRONLY | os.O_CLOEXEC,
+                            0o644,
+                            dir_fd=mfd,
+                        )
+                    ):
+                        pass
+                    Sys.move_mount(
+                        mfd,
+                        "",
+                        Sys.AT_FDCWD,
+                        "/mnt",
+                        MoveMountFlag.F_EMPTY_PATH,
+                    )
+                os.chdir("/mnt")
+                Sys.pivot_root(".", "old_root")
+                os.chdir("/")
+                Sys.umount2("/old_root", UmountFlag.DETACH)
+                ready.write_bytes(b"p")
+                ready.close_write()
+                hold.read_bytes()
+                hold.close_read()
+                return 0
+
+            pid1 = cell.rns.run(init_pivot)
+            ready.close_write()
+            hold.close_read()
+            try:
+                self.assertEqual(ready.read_bytes(), b"p")
+                ready.close_read()
+
+                cell.mount_fs("tmpfs", "sub")
+
+                pid2 = cell.rns.run(
+                    lambda: (
+                        0
+                        if os.path.exists("/pivoted")
+                        and os.path.ismount("/sub")
+                        else 1
+                    ),
+                )
+                self.assertEqual(self.reap_exit_code(pid2), 0)
+            finally:
+                hold.close_write()
+                self.assertEqual(self.reap_exit_code(pid1), 0)
+
+        with SyncPipe.create() as ext_ready, SyncPipe.create() as ext_hold:
+            plain_pid = os.fork()
+            if plain_pid == 0:
+                ext_ready.close_read()
+                ext_hold.close_write()
+                try:
+                    Sys.unshare(CloneFlag.NEWNS)
+                    Sys.set_mount_propagation("/")
+                    with self.closing_fd(
+                        self.make_plain_mount("tmpfs")
+                    ) as mfd:
+                        Sys.move_mount(
+                            mfd,
+                            "",
+                            Sys.AT_FDCWD,
+                            "/tmp",
+                            MoveMountFlag.F_EMPTY_PATH,
+                        )
+                    os.mkdir("/tmp/target", 0o755)
+                    ext_ready.write_bytes(b"r")
+                    ext_ready.close_write()
+                    ext_hold.read_bytes()
+                    ext_hold.close_read()
+                    os._exit(0 if os.path.ismount("/tmp/target") else 2)
+                except BaseException:
+                    os._exit(1)
+            ext_ready.close_write()
+            ext_hold.close_read()
+            try:
+                self.assertEqual(ext_ready.read_bytes(), b"r")
+                ext_ready.close_read()
+                with (
+                    self.closing_fd(
+                        os.open(
+                            f"/proc/{plain_pid}/ns/mnt",
+                            os.O_RDONLY | os.O_CLOEXEC,
+                        )
+                    ) as ext_mntns,
+                    self.closing_fd(self.make_plain_mount("tmpfs")) as mfd,
+                ):
+                    with self.assertRaises(OSError) as cm:
+                        Sys.move_mount(
+                            mfd,
+                            "",
+                            ext_mntns,
+                            "tmp/..",
+                            MoveMountFlag.F_EMPTY_PATH | MoveMountFlag.T_MNTNS,
+                        )
+                    self.assertEqual(cm.exception.errno, errno.EBUSY)
+                    with self.assertRaises(OSError) as cm:
+                        Sys.move_mount(
+                            mfd,
+                            "",
+                            ext_mntns,
+                            "tmp/..",
+                            MoveMountFlag.F_EMPTY_PATH
+                            | MoveMountFlag.T_MNTNS
+                            | MoveMountFlag.BENEATH,
+                        )
+                    self.assertEqual(cm.exception.errno, errno.EINVAL)
+                    Sys.move_mount(
+                        mfd,
+                        "",
+                        ext_mntns,
+                        "tmp/target",
+                        MoveMountFlag.F_EMPTY_PATH | MoveMountFlag.T_MNTNS,
+                    )
+            finally:
+                ext_hold.close_write()
+            self.assertEqual(self.reap_exit_code(plain_pid), 0)
+
+    def test_userns_set_idmap(self) -> None:
+        self._require_cell()
+        with (
+            Rootns() as rns,
+            self.closing_fd(rns.get_nsfd(CloneFlag.NEWUSER)) as userns_fd,
+            self.closing_fd(rns.get_nsfd(CloneFlag.NEWNS)) as mntns_fd,
+        ):
+            with self.assertRaises(OSError) as cm:
+                Sys.userns_set_idmap_raw(-1, 0)
+            self.assertEqual(cm.exception.errno, errno.EBADF)
+
+            with self.assertRaises(OSError) as cm:
+                Sys.userns_set_idmap_raw(userns_fd, 0)
+            self.assertEqual(cm.exception.errno, errno.EINVAL)
+
+            with self.assertRaises(OSError) as cm:
+                Sys.set_userns_idmap(
+                    userns_fd,
+                    uid_extents=((0, os.geteuid(), 1),),
+                    size=UsernsIdmap.SIZE_VER0 - 1,
+                )
+            self.assertEqual(cm.exception.errno, errno.EINVAL)
+
+            with self.assertRaises(OSError) as cm:
+                Sys.set_userns_idmap(
+                    userns_fd,
+                    uid_extents=((0, os.geteuid(), 1),),
+                    sys_flags=1,
+                )
+            self.assertEqual(cm.exception.errno, errno.EINVAL)
+
+            with self.assertRaises(OSError) as cm:
+                Sys.set_userns_idmap(
+                    rns.fd,
+                    uid_extents=((0, os.geteuid(), 1),),
+                    deny_setgroups=True,
+                )
+            self.assertEqual(cm.exception.errno, errno.EINVAL)
+
+            with self.assertRaises(OSError) as cm:
+                Sys.set_userns_idmap(
+                    mntns_fd,
+                    uid_extents=((0, os.geteuid(), 1),),
+                    deny_setgroups=True,
+                )
+            self.assertEqual(cm.exception.errno, errno.EINVAL)
+
+            with self.assertRaises(OSError) as cm:
+                Sys.set_userns_idmap(userns_fd)
+            self.assertEqual(cm.exception.errno, errno.EINVAL)
+
+            with self.assertRaises(OSError) as cm:
+                Sys.set_userns_idmap(
+                    userns_fd,
+                    extra_flags=(~int(UsernsIdmapFlag.ALL)) & 0xFFFFFFFF,
+                )
+            self.assertEqual(cm.exception.errno, errno.EINVAL)
+
+            with self.assertRaises(OSError) as cm:
+                Sys.set_userns_idmap(
+                    userns_fd,
+                    uid_extents=((0, os.geteuid(), 0),),
+                    deny_setgroups=True,
+                )
+            self.assertEqual(cm.exception.errno, errno.EINVAL)
+
+            rns.map_self_ugid()
+            with self.assertRaises(OSError) as cm:
+                rns.map_self_ugid()
+            self.assertEqual(cm.exception.errno, errno.EPERM)
+
+            with self.closing_fd(rns.make_mount("tmpfs")) as rootfd:
+                os.mkdir("proc", 0o755, dir_fd=rootfd)
+                Sys.move_mount(
+                    rootfd,
+                    "",
+                    mntns_fd,
+                    "/",
+                    MoveMountFlag.F_EMPTY_PATH | MoveMountFlag.T_MNTNS,
+                )
+            with self.closing_fd(rns.make_mount("proc")) as pfd:
+                Sys.move_mount(
+                    pfd,
+                    "",
+                    mntns_fd,
+                    "proc",
+                    MoveMountFlag.F_EMPTY_PATH | MoveMountFlag.T_MNTNS,
+                )
+
+            def verify_idmap() -> int:
+                if os.geteuid() != 0 or os.getegid() != 0:
+                    return 1
+                with open("/proc/self/setgroups", "rb") as f:
+                    if f.read() != b"deny\n":
+                        return 2
+                return 0
+
+            pid = rns.run(verify_idmap)
+            res = rns.wait()
+            self.assertEqual(res.pid, pid)
+            self.assertEqual(res.exit_code, 0)
+            self.assertEqual(self.reap_exit_code(pid), 0)
+
+    def test_userns_set_idmap_delegation(self) -> None:
+        self._require_cell()
+        if os.geteuid() != 0:
+            self.skipTest("uidmapd delegation test requires root")
+
+        rns1 = self.create_rootns_as_uid(1000)
+        rns2 = self.create_rootns_as_uid(1000)
+        if rns1 is None or rns2 is None:
+            if rns1 is not None:
+                rns1.close()
+            if rns2 is not None:
+                rns2.close()
+            self.skipTest("unprivileged rootns creation unavailable")
+
+        with rns1, rns2:
+            s_main, s_alice = socket.socketpair(
+                socket.AF_UNIX, socket.SOCK_DGRAM
+            )
+            alice_pid = os.fork()
+            if alice_pid == 0:
+                s_main.close()
+                try:
+                    self.drop_to_uid(1000)
+                    with self.closing_fd(
+                        rns1.get_nsfd(CloneFlag.NEWUSER)
+                    ) as ufd1:
+                        socket.send_fds(s_alice, [b"A"], [ufd1])
+                    os._exit(0)
+                except BaseException:
+                    os._exit(1)
+                finally:
+                    s_alice.close()
+            s_alice.close()
+            _, alice_fds, _, _ = socket.recv_fds(s_main, 1, 1)
+            s_main.close()
+            self.assertEqual(self.reap_exit_code(alice_pid), 0)
+
+            with (
+                self.closing_fd(alice_fds[0]) as alice_ufd,
+                self.closing_fd(rns2.get_nsfd(CloneFlag.NEWUTS)) as uts2_fd,
+            ):
+                s_m1, s_m2 = socket.socketpair(
+                    socket.AF_UNIX, socket.SOCK_DGRAM
+                )
+                mal_pid = os.fork()
+                if mal_pid == 0:
+                    s_m1.close()
+                    try:
+                        self.drop_to_uid(2000)
+                        with self.closing_fd(
+                            Sys.ioctl(uts2_fd, Ioctl.NS_GET_USERNS)
+                        ) as bad_ufd:
+                            socket.send_fds(s_m2, [b"M"], [bad_ufd])
+                        os._exit(0)
+                    except BaseException:
+                        os._exit(1)
+                    finally:
+                        s_m2.close()
+                s_m2.close()
+                _, mal_fds, _, _ = socket.recv_fds(s_m1, 1, 1)
+                s_m1.close()
+                self.assertEqual(self.reap_exit_code(mal_pid), 0)
+
+                with self.closing_fd(mal_fds[0]) as mallory_ufd:
+
+                    def run_uidmapd() -> None:
+                        try:
+                            Sys.drop_to_setid_helper(990)
+                        except OSError as exc:
+                            if exc.errno in SKIP_ERRNOS:
+                                self.skipTest(f"setid helper setup: {exc}")
+                            raise
+
+                        with self.assertRaises(OSError) as cm_bad:
+                            Sys.set_userns_idmap(
+                                mallory_ufd,
+                                uid_extents=((0, 1000, 1),),
+                                deny_setgroups=True,
+                            )
+                        self.assertEqual(cm_bad.exception.errno, errno.EPERM)
+
+                        with self.assertRaises(OSError) as cm_root:
+                            Sys.set_userns_idmap(
+                                alice_ufd,
+                                uid_extents=((0, 0, 1),),
+                                deny_setgroups=True,
+                            )
+                        self.assertEqual(cm_root.exception.errno, errno.EPERM)
+
+                        Sys.set_userns_idmap(
+                            alice_ufd,
+                            uid_extents=((0, 1000, 1), (1, 2000, 1)),
+                            gid_extents=((0, 1000, 1), (1, 2000, 1)),
+                            deny_setgroups=True,
+                        )
+
+                    self.run_forked(run_uidmapd)
+
+            def verify_as_alice() -> None:
+                self.drop_to_uid(1000)
+                with (
+                    self.closing_fd(
+                        rns1.get_nsfd(CloneFlag.NEWNS)
+                    ) as mntns_fd,
+                    self.closing_fd(rns1.make_mount("tmpfs")) as rootfd,
+                ):
+                    Sys.move_mount(
+                        rootfd,
+                        "",
+                        mntns_fd,
+                        "/",
+                        MoveMountFlag.F_EMPTY_PATH | MoveMountFlag.T_MNTNS,
+                    )
+
+                def switch_subuid() -> int:
+                    os.setresgid(1, 1, 1)
+                    os.setresuid(1, 1, 1)
+                    return 0 if os.geteuid() == 1 and os.getegid() == 1 else 1
+
+                pid = rns1.run(switch_subuid)
+                res = rns1.wait()
+                self.assertEqual(res.pid, pid)
+                self.assertEqual(res.exit_code, 0)
+                self.assertEqual(self.reap_exit_code(pid), 0)
+
+            self.run_forked(verify_as_alice)
+
+    def test_unprivileged_without_entering_userns(self) -> None:
+        def worker() -> None:
+            if os.geteuid() == 0:
+                try:
+                    self.drop_to_uid(1000)
+                except OSError as exc:
+                    if exc.errno == errno.EINVAL:
+                        self.skipTest("uid 1000 unmapped in current userns")
+                    raise
+
+            try:
+                tfd = Sys.fsopen("tmpfs")
+            except OSError as exc:
+                self.assertEqual(exc.errno, errno.EPERM)
+            else:
+                with self.closing_fd(tfd):
+                    with self.assertRaises(OSError) as cm_create:
+                        Sys.fsconfig(tfd, FsconfigCmd.CMD_CREATE)
+                    self.assertEqual(cm_create.exception.errno, errno.EPERM)
+
+            with self.assertRaises(OSError) as cm_ot:
+                Sys.open_tree(
+                    Sys.AT_FDCWD,
+                    "/tmp",
+                    OpenTreeFlag.CLONE | OpenTreeFlag.CLOEXEC,
+                )
+            self.assertEqual(cm_ot.exception.errno, errno.EPERM)
+
+            try:
+                cell = Cell("unpriv", flags=RootnsFlag.DEFAULT)
+            except OSError as exc:
+                if exc.errno in SKIP_ERRNOS:
+                    self.skipTest("unprivileged rootns unavailable")
+                raise
+
+            with (
+                tempfile.TemporaryDirectory(prefix="rootns-unpriv-") as hdir,
+                cell,
+            ):
+                os.chmod(hdir, 0o755)
+                with open(os.path.join(hdir, "hello"), "wb") as f:
+                    f.write(b"unpriv-ok\n")
+                cell.setup_rootfs(
+                    dirs=("proc", "tmp", "mnt"), mount_procfs=True
+                )
+                cell.bind_mount(hdir, "mnt")
+
+                def unpriv_init() -> int:
+                    if (
+                        os.getpid() != 1
+                        or os.geteuid() != 0
+                        or os.getegid() != 0
+                    ):
+                        return 1
+                    pids = [e for e in os.listdir("/proc") if e.isdigit()]
+                    if pids != ["1"]:
+                        return 2
+                    with open("/mnt/hello", "rb") as hf:
+                        if hf.read() != b"unpriv-ok\n":
+                            return 3
+                    try:
+                        Sys.umount2("/mnt", UmountFlag.DETACH)
+                        return 4
+                    except OSError as exc:
+                        return 0 if exc.errno == errno.EINVAL else 5
+
+                pid = cell.rns.run(unpriv_init)
+                res = cell.wait()
+                self.assertEqual(res.pid, pid)
+                self.assertEqual(res.exit_code, 0)
+                self.assertEqual(self.reap_exit_code(pid), 0)
+
+        self.run_forked(worker)
+
+class KtapTestResult(unittest.TestResult):
+    def __init__(self, ksft_mod: Any) -> None:
+        super().__init__()
+        self._ksft = ksft_mod
+        self._failed = False
+
+    @staticmethod
+    def _test_name(test: unittest.TestCase) -> str:
+        return f"{type(test).__name__}.{test._testMethodName}"
+
+    def _print_diag(self, text: str) -> None:
+        for line in text.rstrip().splitlines():
+            self._ksft.print_msg(line)
+
+    def _print_err(
+        self,
+        test: unittest.TestCase,
+        err: (
+            tuple[type[BaseException], BaseException, TracebackType]
+            | tuple[None, None, None]
+        ),
+    ) -> None:
+        formatted = "".join(traceback.format_exception(*err))
+        self._print_diag(f"{test.id()}:\n{formatted}")
+
+    def startTest(self, test: unittest.TestCase) -> None:
+        super().startTest(test)
+        self._failed = False
+
+    def stopTest(self, test: unittest.TestCase) -> None:
+        if self._failed:
+            self._ksft.test_result_fail(self._test_name(test))
+        super().stopTest(test)
+
+    def addSuccess(self, test: unittest.TestCase) -> None:
+        super().addSuccess(test)
+        self._ksft.test_result_pass(self._test_name(test))
+
+    def addSkip(self, test: unittest.TestCase, reason: str) -> None:
+        super().addSkip(test, reason)
+        name = self._test_name(test)
+        if reason:
+            self._print_diag(f"{name}: {reason}")
+        self._ksft.test_result_skip(name)
+
+    def addFailure(
+        self,
+        test: unittest.TestCase,
+        err: (
+            tuple[type[BaseException], BaseException, TracebackType]
+            | tuple[None, None, None]
+        ),
+    ) -> None:
+        super().addFailure(test, err)
+        self._print_err(test, err)
+        self._failed = True
+
+    def addError(
+        self,
+        test: unittest.TestCase,
+        err: (
+            tuple[type[BaseException], BaseException, TracebackType]
+            | tuple[None, None, None]
+        ),
+    ) -> None:
+        super().addError(test, err)
+        self._print_err(test, err)
+        self._failed = True
+
+    def addSubTest(
+        self,
+        test: unittest.TestCase,
+        subtest: unittest.TestCase,
+        err: (
+            tuple[type[BaseException], BaseException, TracebackType]
+            | tuple[None, None, None]
+            | None
+        ),
+    ) -> None:
+        super().addSubTest(test, subtest, err)
+        if err is not None:
+            self._print_err(subtest, err)
+            self._failed = True
+
+
+class KtapRunner:
+    @staticmethod
+    def _load_ksft() -> Any:
+        ksft_dir = str(Path(__file__).resolve().parents[1] / "kselftest")
+        if ksft_dir not in sys.path:
+            sys.path.insert(0, ksft_dir)
+        return importlib.import_module("ksft")
+
+    @classmethod
+    def main(cls, argv: Sequence[str] | None = None) -> NoReturn:
+        args = list(sys.argv[1:] if argv is None else argv)
+        loader = unittest.TestLoader()
+        module = sys.modules[__name__]
+        suite = (
+            loader.loadTestsFromNames(args, module)
+            if args
+            else loader.loadTestsFromModule(module)
+        )
+        ksft = cls._load_ksft()
+        total = suite.countTestCases()
+        ksft.print_header()
+        ksft.set_plan(total)
+        result = KtapTestResult(ksft)
+        suite.run(result)
+        ksft.print_cnts()
+        sys.stdout.flush()
+        counts: dict[str, int] = ksft.ksft_cnt
+        if counts["fail"] > 0:
+            code = int(ksft.KSFT_FAIL)
+        elif total == 0 or (counts["pass"] == 0 and counts["skip"] > 0):
+            code = int(ksft.KSFT_SKIP)
+        else:
+            code = int(ksft.KSFT_PASS)
+        sys.exit(code)
+
+
+if __name__ == "__main__":
+    KtapRunner.main()
diff --git a/tools/testing/selftests/rootns/test_smoke.sh b/tools/testing/selftests/rootns/test_smoke.sh
new file mode 100755
index 000000000000..729e0c275602
--- /dev/null
+++ b/tools/testing/selftests/rootns/test_smoke.sh
@@ -0,0 +1,10 @@
+#!/bin/sh
+# SPDX-License-Identifier: GPL-2.0
+
+# Kselftest framework requirement - SKIP code is 4.
+ksft_skip=4
+
+command -v python3 >/dev/null 2>&1 || exit $ksft_skip
+
+DIR="$(dirname "$(readlink -f "$0")")"
+exec python3 "$DIR/rootns_test.py" "$@"
-- 
2.47.3

