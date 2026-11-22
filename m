Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795379290;
	b=TM3rK5wsjJctdVZvhAae09zHyW9OQp3z3dEnG7FStV0Ii5ZY1gZwsBnl/XVGkzew4lfw
	 AUoZMCcVnclJ/AEtzTNe7brg0KfZGNcAW2rIWRsqHtmTeVoKTjjnZr3I1i3GS+NjBYy1i
	 qtl4PNOTqIuLNzN+IsjWDQcpBbyYftNY2LrWLkbUrRlEBpshTGV3EwGJAvs97h79bsDMh
	 cWSck+jJLrpscqkkv36TplSHtfNkfsoeBnrcP49gH3suqMQBUBDINfaEuNm326uFfznw+
	 NAuPLD70vTDOcDipnd4ntA+SUmJoRNZ6HS90pLACuJtN/HzMJ2w+/FIegnu8J0A9ifA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795379290;
	h=Received:DKIM-Signature:Content-Type:MIME-Version:Message-Id:
	 In-Reply-To:References:Subject:From:To:Cc:Date;
	bh=g5BSMgQQGkCT/g88ue+zmET8GWlmL1qSQjkUJLeU+lc=;
	b=M+sY79Fu7nlrlF1ZJ8mAVZdpXr789NDzLxWiPvFE+OT9cPdAJXnZW6xCV8uQrvgeDEvv
	 lN5r/+mv7WlD1qnR1oNj3u0XtzJ0S6ykWKUvRYOaPPEnUdUD+1iXAh+weaTJT7usA7wlb
	 J8hORGbyUDFETi+UnejsjgW6zNYxuHQWt0trLYhA7NQapjS6fatDOeWvnB2y4BQgoVTw5
	 +KxLe6iastF0Q1r1NiMSMM7hsK4Gh8Y4VHshEI38UcIXc9ew9rmxdHPFQc6sZ2gAZA2eo
	 wp/CUnvWMAXwh2eJjEley23vqCUB24u6FHSkRYBqiJ4UlwKTWxU1ncXJeparmpnl9rw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UTfB8wPx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65124606A32E;
	Sun, 22 Nov 2026 20:28:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UTfB8wPx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AD491F000D0;
	Sun, 22 Nov 2026 20:28:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795379289;
	bh=g5BSMgQQGkCT/g88ue+zmET8GWlmL1qSQjkUJLeU+lc=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date;
	b=UTfB8wPxS/LlttWVeNSAmOOn251pAFPKGOJAcNLbwE1FGdHIcbaDIJ2IvUdtupMPd
	 dVZ/mn2vHW/KnjNOIpN97gq2cSGqu7M0JJ7oIgH4pcIL+p3DRTxxQwz5d9lM+xhEAc
	 t4C5W8b0v4yWMiU6OY4tMqGjjcWnXhTe7Rtu98duTLm64VZeuMOafAONH4HwD5JVwm
	 VOUO+1QknJoLeQm1nU95gshjNy2lOFYLCcb80kTTZrKO4Zub+F/TNLKwGxI62ZGtaa
	 jZxpasS6M1LGE5d7L28NozicCEpV1qDnqfvd4iiQAxR94A4eNPX0gXsT0lgKuiQ6+f
	 4dvRXHczFhgoA==
Content-Type: multipart/mixed; boundary="===============7258520623913429804=="
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Message-Id: <ceb256f2afc7fa8c469f5f235f1e77aed593945868918788bc32ad76dee810ae@mail.kernel.org>
In-Reply-To: <20261122193539.3334213-26-jarkko@kernel.org>
References: <20261122193539.3334213-26-jarkko@kernel.org>
Subject: Re: [RFC PATCH v7 25/26] selftests/userland: Add userland test suite
From: bot+bpf-ci@kernel.org
To: jarkko@kernel.org,linux-fsdevel@vger.kernel.org
Cc: jarkko@kernel.org,bpf@vger.kernel.org,containers@lists.linux.dev,linux-api@vger.kernel.org,linux-arch@vger.kernel.org,linux-doc@vger.kernel.org,linux-kernel@vger.kernel.org,linux-kselftest@vger.kernel.org,linux-mm@kvack.org,linux-security-module@vger.kernel.org,aleksa@amutable.com,alex@amutable.com,viro@zeniv.linux.org.uk,luto@amacapital.net,arnd@arndb.de,brauner@kernel.org,dhowells@redhat.com,ebiggers@kernel.org,giuseppe@scrivano.org,hughd@google.com,jack@suse.cz,jlayton@kernel.org,corbet@lwn.net,josef@toxicpanda.com,kees@kernel.org,kpsingh@kernel.org,lennart@poettering.net,neal@gompa.dev,oleg@redhat.com,paul@paul-moore.com,ptikhomirov@virtuozzo.com,sergeh@kernel.org,skhan@linuxfoundation.org,zygmunt.krynicki@canonical.com,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,mason@kernel.org,ihor.solodrai@linux.dev
Date: Sun, 22 Nov 2026 20:28:05 +0000 (UTC)

--===============7258520623913429804==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> selftests/userland: Add userland test suite

TL;DR:
- Selftest run as root may propagate a tmpfs over the host's /tmp and leave it
  mounted
- Python 3.9-3.11 fails instead of skipping (os.unshare/setns need 3.12)
- E2BIG check may fail on 64K-page kernels

> diff --git a/tools/testing/selftests/userland/test_smoke.sh b/tools/testing/selftests/userland/test_smoke.sh
> new file mode 100755
> --- /dev/null
> +++ b/tools/testing/selftests/userland/test_smoke.sh
> @@ -0,0 +1,10 @@
> +#!/bin/sh
> +# SPDX-License-Identifier: GPL-2.0
> +
> +# Kselftest framework requirement - SKIP code is 4.
> +ksft_skip=4
> +
> +command -v python3 >/dev/null 2>&1 || exit $ksft_skip
> +
> +DIR="$(dirname "$(readlink -f "$0")")"
> +exec python3 "$DIR/userland_test.py" "$@"

Does this wrapper need to check for more than the presence of python3?

userland_test.py calls os.unshare() and os.setns() at many sites, and both
functions first appeared in Python 3.12.  Documentation/process/changes.rst
gives Python 3.9 as the minimum.  On a 3.9 to 3.11 interpreter, with a
kernel that has CONFIG_USERLAND=y, the tests that reach those calls raise
AttributeError.  Inside Userland.run() the child does:

    except BaseException:
        os._exit(126)

so the test only reports assertEqual(126, 0), KtapRunner.main() exits with
KSFT_FAIL, and the run is recorded as "not ok" rather than skipped.  Since
the Makefile change adds userland to the default TARGETS, a default
"make kselftest" would show these failures on such hosts.

Would a check like this be more appropriate:

    python3 -c 'import os, sys; sys.exit(not (hasattr(os, "unshare") and hasattr(os, "setns")))' || exit $ksft_skip

or an equivalent hasattr() check in KtapRunner.main() that exits with
KSFT_SKIP?

[ ... ]

> diff --git a/tools/testing/selftests/userland/userland_test.py b/tools/testing/selftests/userland/userland_test.py

[ ... ]

> +    @classmethod
> +    def enter_foreign_pidns(cls, rns: Userland) -> None:
> +        with cls.closing_fd(rns.get_nsfd(CloneFlag.NEWUSER)) as ufd:
> +            os.setns(ufd, CloneFlag.NEWUSER)
> +        os.unshare(CloneFlag.NEWPID)

A subsystem pattern flags this as potentially concerning: a selftest should
not exit with a failure status when a prerequisite is missing, and should
skip instead.

os.setns() and os.unshare() are only available from Python 3.12, so on
Python 3.9 to 3.11 these calls raise AttributeError even though the kernel
is fully configured.  enter_foreign_pidns() is reached from
test_clone_flags_and_pidns_ancestry() through check_exdev(), and
check_dead_ancestor_pidns() calls os.unshare(CloneFlag.NEWPID) directly.
Both run under run_forked(), whose "except BaseException" turns the
AttributeError into a failure payload, so the result is "not ok" and a
KSFT_FAIL exit instead of a skip.

The kernel-side prerequisites are handled through SKIP_ERRNOS and
probe_pre_idmap_mkdir(), and the interpreter requirement is the only gap.
The Sys helper already calls the other syscalls through ctypes, so would
routing setns and unshare through libc the same way, for example
Sys._LIBC.setns and Sys._LIBC.unshare, remove the 3.12 dependency?  The
alternative is to skip when hasattr(os, "setns") is false.

[ ... ]

> +            def check_child_src_slave_locking() -> None:
> +                self.enter_userns_if_unpriv()
> +                os.unshare(CloneFlag.NEWNS)
> +                with self.closing_fd(self.make_plain_mount("tmpfs")) as tfd:
> +                    os.mkdir("sub", 0o755, dir_fd=tfd)
> +                    Sys.move_mount(
> +                        tfd,
> +                        "",
> +                        Sys.AT_FDCWD,
> +                        "/tmp",
> +                        MoveMountFlag.F_EMPTY_PATH,
> +                    )

Can this leave a tmpfs mounted over the host's /tmp when the suite runs as
root?

When euid is 0, enter_userns_if_unpriv() returns without creating a user
namespace:

    def enter_userns_if_unpriv(cls) -> None:
        if os.geteuid() == 0:
            return

so os.unshare(CloneFlag.NEWNS) creates a mount namespace in init_user_ns.
copy_mnt_ns() only adds CL_SLAVE when the user namespace changes:

    if (user_ns != ns->user_ns)
        copy_flags |= CL_SLAVE;

Without CL_SLAVE the copied mounts remain peers of the host mounts.  On a
systemd host / is shared and /tmp is usually a separate shared mount, and
nothing in the runner or setUp() makes the mounts private.

The move_mount() onto /tmp then reaches attach_recursive_mnt() with a shared
dest_mnt:

    if (IS_MNT_SHARED(dest_mnt)) {
        err = invent_group_ids(source_mnt, true);
        ...
        err = propagate_mnt(dest_mnt, dest_mp, source_mnt, &tree_list);
    }

so a copy of the tmpfs is propagated on top of the host's /tmp.  The
cleanup at the end of the helper is only:

    Sys.umount2("/tmp/sub", UmountFlag.DETACH)

and when the run_forked() child exits, put_mnt_ns() calls
umount_tree(ns->root, 0) without UMOUNT_PROPAGATE, so the propagated copy
stays in the host namespace.  After one root run, the real /tmp contents
(for example /tmp/.X11-unix/X0 or tmux and ssh-agent sockets) would be hidden
behind an empty tmpfs until it is unmounted by hand.  If the test fails
between the T_MNTNS move_mount() and the final umount2(), a propagated
/tmp/sub is left behind as well.

check_standalone_mntns() in test_pivot_root_and_standalone_mntns_hot_mount()
already guards against this:

    os.unshare(CloneFlag.NEWNS)
    Sys.set_mount_propagation("/")

Should check_child_src_slave_locking() call Sys.set_mount_propagation("/")
(MS_REC|MS_PRIVATE) right after os.unshare(CloneFlag.NEWNS)?  The later
set_mount_propagation("/tmp", MountFlag.REC | MountFlag.SHARED) would then
create a peer group local to the test namespace, and the slave locking
scenario would still be exercised.

[ ... ]

> +            big_buf = ctypes.create_string_buffer(65536)
> +            with self.assertRaises(OSError) as cm:
> +                Sys.userns_set_idmap_raw(
> +                    userns_fd, ctypes.addressof(big_buf), size=65536
> +                )
> +            self.assertEqual(cm.exception.errno, errno.E2BIG)

Does this oversized-struct check assume PAGE_SIZE is below 64 KiB?

sys_userns_set_idmap() only returns -E2BIG when size is larger than
PAGE_SIZE:

    if (unlikely(size > PAGE_SIZE))
        return -E2BIG;

On 64K page kernels (PPC_64K_PAGES is the default for PPC_BOOK3S_64, and
arm64 has ARM64_64K_PAGES), size == PAGE_SIZE, so that branch is skipped.
copy_struct_from_user() then finds the trailing bytes zeroed, req is all
zeros, and the syscall returns -EINVAL from the check on
nr_uid_extents, nr_gid_extents and nr_projid_extents.  The
assertEqual(..., errno.E2BIG) would then fail on those systems, which
Sys._build_syscall_numbers() explicitly supports.

Would a size derived from the runtime page size, for example
mmap.PAGESIZE + 1 with a buffer of that size, hit the E2BIG branch on every
page size?


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/45063222848
--===============7258520623913429804==--
