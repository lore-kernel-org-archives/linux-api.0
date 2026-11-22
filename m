Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795313660;
	b=VEkihWfpkCa+ZQUrTwd/M6NqbfSPH9X9s5Gp4NLmx3tiJIQJ04spxCZ/Q64k8bo3wFkO
	 iN+Z4BdSOUTwE+/bUHLaRoZLFoL2+1zKX8rGXnBq/L4YBzT5duGJE1gsFQ3UlazEeu9SA
	 VbdgDBIKcEjOBcnbmjyVTbmOOtx169Yxr7Hcr2LSmi3NTLk90XaUq/LvYxpNOAsRM6bpE
	 PoMHIDEY2tQmy4ByQisa8d/8MaSq3rWPCgtCBPiAEMm3DMjxn370bmovrDJrhlbVSRcqR
	 797lkBcgZg5r/qQ5u/KxSBJdT4Atbbts0fo/iYafxftcXbvqlGP1T//UERxjgF/za5Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795313660;
	h=Received:DKIM-Signature:Content-Type:MIME-Version:Message-Id:
	 In-Reply-To:References:Subject:From:To:Cc:Date;
	bh=h5VA1YE3lZnMuc4pgcwx05FrLM8HqoJ1Sdgg4XfYCTc=;
	b=0pxUXSYS/a+jr6132xQWid6fslWnrTiSDkR1IJfs8/4g6ZwX/s9RRLmUE3TF/jFoHVPT
	 Jv/ddEUf3h2av0JHqt6llyCbrAf/NsShdRe+6WiVsMZM+RkC4nrSyJi9jQr5wvx65JCQx
	 vgjFBEl7cBEDNPWUhN/cx4K5S3yj3QaBc8bacxLAYAm0TBmE7WTQDjGPo2qd2YJKK1efY
	 KTWdi6J+EzjfqzOSYhKdl7yc+K3jqZv4j69VwlVMt76Ul8ffoJyZCAJr/dY+FXAu8gnmC
	 aunBt14RscXrFFdmUy1fByUbJ3TqTpNwPTIHaAUAHfHyOpLE8QYVIYByGWBXMxOiUYA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FeZXY1bn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6029F606A332;
	Sun, 22 Nov 2026 02:14:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FeZXY1bn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 585771F000CA;
	Sun, 22 Nov 2026 02:14:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795313660;
	bh=h5VA1YE3lZnMuc4pgcwx05FrLM8HqoJ1Sdgg4XfYCTc=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date;
	b=FeZXY1bnXRjfWfDhdd9xvxA2C1PvOyxAVG/K78D8Kl9qL79GS5Qc997rcaK+Aa0DZ
	 jl7mxVscPW7m/j4p3AR8o7Pgfv7EdqDS7MMMUdCmSkdniwuxKXU0nZ1MvJtABdS0To
	 MGbUtZ0CeNa6NIJe+6hVKxEcz0iQdZ5UtGu4oMb0/TY1/v48944cY4nucneJ6g6kNI
	 rwBf2H2sqlK4Eqycd2/wLe9kB2+F3DlVJHlbuudR+Wj4FMYMVYloWJ2vmPZtPUaCsz
	 JYGGcRSqFRIHgjga3nhOPl0vDkmiDNg/9CgrfDzA44h72yk+os9ZejeY4N1M/xJOfN
	 H4vWAxohEgGEA==
Content-Type: multipart/mixed; boundary="===============3579480507848251298=="
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Message-Id: <a20bfb0569b8af98b16097472118dd35c85fc9c1e258860871b01bfa9c6c9384@mail.kernel.org>
In-Reply-To: <20261122011809.2667684-26-jarkko@kernel.org>
References: <20261122011809.2667684-26-jarkko@kernel.org>
Subject: Re: [RFC PATCH v6 25/26] selftests/userland: Add userland test suite
From: bot+bpf-ci@kernel.org
To: jarkko@kernel.org,linux-fsdevel@vger.kernel.org
Cc: jarkko@kernel.org,bpf@vger.kernel.org,containers@lists.linux.dev,linux-api@vger.kernel.org,linux-arch@vger.kernel.org,linux-doc@vger.kernel.org,linux-kernel@vger.kernel.org,linux-kselftest@vger.kernel.org,linux-mm@kvack.org,linux-security-module@vger.kernel.org,aleksa@amutable.com,alex@amutable.com,viro@zeniv.linux.org.uk,luto@amacapital.net,arnd@arndb.de,brauner@kernel.org,dhowells@redhat.com,giuseppe@scrivano.org,hughd@google.com,jack@suse.cz,jlayton@kernel.org,corbet@lwn.net,josef@toxicpanda.com,kees@kernel.org,kpsingh@kernel.org,lennart@poettering.net,neal@gompa.dev,oleg@redhat.com,paul@paul-moore.com,ptikhomirov@virtuozzo.com,sergeh@kernel.org,skhan@linuxfoundation.org,zygmunt.krynicki@canonical.com,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,mason@kernel.org,ihor.solodrai@linux.dev
Date: Sun, 22 Nov 2026 02:14:16 +0000 (UTC)

--===============3579480507848251298==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> selftests/userland: Add userland test suite

TL;DR:
- Selftest may fail on out-of-tree builds: ksft.py helper isn't installed
  (TEST_INCLUDES)
- Plain i386 userspace on x86_64 may get x32 syscall numbers and wrongly skip
- Time-namespace case may fail without TIME_NS; a socket recv may hang on
  failure

> diff --git a/tools/testing/selftests/userland/Makefile b/tools/testing/selftests/userland/Makefile
> new file mode 100644
> index 000000000000..baf26c6780bb
> --- /dev/null
> +++ b/tools/testing/selftests/userland/Makefile
> @@ -0,0 +1,5 @@
> +# SPDX-License-Identifier: GPL-2.0
> +include ../lib.mk
> +
> +TEST_PROGS := test_smoke.sh
> +TEST_FILES := userland_cells.py userland_test.py

Will this suite run under an out-of-tree build such as
"make O=/tmp/kselftest kselftest"?

With O= set, the run_tests recipe in lib.mk copies only $(TEST_PROGS) and
$(TEST_FILES) into $(OUTPUT), and INSTALL_INCLUDES copies nothing because
TEST_INCLUDES is not set.

test_smoke.sh then execs userland_test.py from the copied location, and
KtapRunner._load_ksft() looks for the helper relative to that file:

    ksft_dir = str(Path(__file__).resolve().parents[1] / "kselftest")
    ...
    return importlib.import_module("ksft")

Nothing in that flow creates <dir>/kselftest/kselftest, so
import_module() raises ModuleNotFoundError and run_one() records
"not ok ... selftests: userland: test_smoke.sh # exit=1" even on a kernel
with CONFIG_USERLAND=y.

Would adding the helper to TEST_INCLUDES keep the layout that
_load_ksft() expects?

    TEST_INCLUDES := ../kselftest/ksft.py

net/packetdrill/Makefile does this for ../../kselftest/ktap_helpers.sh.

[ ... ]

> diff --git a/tools/testing/selftests/userland/userland_cells.py b/tools/testing/selftests/userland/userland_cells.py
> new file mode 100644
> --- /dev/null
> +++ b/tools/testing/selftests/userland/userland_cells.py

[ ... ]

> +        elif mach == "x86_64" and ptr_size == 4:
> +            base = 0x40000000
> +            arch_legacy = {
> +                "pivot_root": base + 155,
> +                "umount2": base + 166,
> +                "waitid": base + 529,
> +                "execveat": base + 545,
> +            }

Does this branch also catch plain i386 userspace running on an x86_64
kernel?

platform.machine() comes from uname(), and a 32-bit task only sees the
compat machine string when it runs with PER_LINUX32:

    #define override_architecture(name) \
            (personality(current->personality) == PER_LINUX32 && \
             copy_to_user(name->machine, COMPAT_UTS_MACHINE, ...

So an i386 Docker image or chroot entered without linux32 reports
mach == "x86_64" with ptr_size == 4, and gets the x32 numbering.  The
test then calls userland_open as 0x40000000 + 474 instead of 474, and
do_syscall_32_irqs_on() returns -ENOSYS for nr >= IA32_NR_syscalls.

ENOSYS is in SKIP_ERRNOS, so probe_pre_idmap_mkdir() reports
"userland_open() unavailable" and the suite exits KSFT_SKIP.  The compat
entry paths of userland_open, userns_set_idmap, clone3, fsconfig and
waitid(P_USERLAND) are then never exercised in the configuration that
needs them.

The function already tells these cases apart on other architectures.
Would gating this branch on "x32" in multiarch, and sending the remaining
x86_64/ptr_size == 4 case to the i386 numbers (217/52/284/358), work?

[ ... ]

> diff --git a/tools/testing/selftests/userland/userland_test.py b/tools/testing/selftests/userland/userland_test.py
> new file mode 100755
> --- /dev/null
> +++ b/tools/testing/selftests/userland/userland_test.py

[ ... ]

> +    def test_get_nsfd(self) -> None:
> +        try:
> +            rns = Userland()
> +        except OSError as exc:
> +            if exc.errno in SKIP_ERRNOS:
> +                self.skipTest(f"userland_open() unavailable: {exc}")
> +            raise
> +        with rns:
> +            for case in NS_TYPE_CASES:
> +                with self.subTest(ns=case.name):
> +                    with self.closing_fd(rns.get_nsfd(case.nstype)) as nsfd:

A subsystem pattern flags this as potentially concerning: test_get_nsfd()
requires USERLAND_GET_NSFD to succeed for every entry in NS_TYPE_CASES,
including NsTypeCase("time", CloneFlag.NEWTIME).

CONFIG_USERLAND does not depend on TIME_NS, and userland_get_nsfd()
handles that configuration explicitly:

    case CLONE_NEWTIME:
    #ifdef CONFIG_TIME_NS
            ns = to_ns_common(userland->ns->time_ns);
            break;
    #else
            return -EOPNOTSUPP;
    #endif

On a CONFIG_USERLAND=y, CONFIG_TIME_NS=n kernel, the OSError(EOPNOTSUPP)
is raised inside subTest(ns="time"), the test is marked failed, and
KtapRunner.main() exits KSFT_FAIL.  The selftest config fragment sets
CONFIG_TIME_NS=y, so a run that follows it does not hit this.

Should the time case be skipped on EOPNOTSUPP?  test_share_nsfd() already
handles a missing time namespace with "if not os.path.exists(ns_path):
continue".

[ ... ]

> +        def check_dead_ancestor_pidns() -> None:
> +            self.enter_userns_if_unpriv()
> +            s_p, s_c = socket.socketpair(socket.AF_UNIX, socket.SOCK_DGRAM)
> +            p1 = os.fork()
> +            if p1 == 0:
> +                s_p.close()
> +                try:
> +                    os.unshare(CloneFlag.NEWPID)
> +                    p2 = os.fork()
> +                    if p2 == 0:
> +                        with Userland() as nested_u:
> +                            socket.send_fds(s_c, [b"U"], [nested_u.fd])
> +                        os._exit(0)
> +                    os._exit(self.reap_exit_code(p2))
> +                finally:
> +                    s_c.close()
> +            s_c.close()
> +            try:
> +                _, recv_u, _, _ = socket.recv_fds(s_p, 1, 1)
> +            finally:
> +                s_p.close()

Can this recv_fds() block forever?

If p1's os.unshare(CloneFlag.NEWPID) fails, or p2's Userland() or
send_fds() fails, nothing is ever sent.  Closing the other end of an
AF_UNIX SOCK_DGRAM socketpair does not wake the reader, because
unix_release_sock() only sets the peer's sk_shutdown for SOCK_STREAM and
SOCK_SEQPACKET.

p1 and p2 are forks of the run_forked() child, so their exceptions end in
_exit(1) after writing a fail payload, while the run_forked() child stays
blocked in recv_fds() and keeps the pipe's write end open.  The parent
then blocks in pipe.read_all(), so a failure turns into a hang.  Under
run_kselftest.sh the 45s default timeout kills it, and the tests that sort
after test_clone_flags_and_pidns_ancestry never run.

create_userland_as_uid() in the same file guards the same fd-passing
pattern with select.select([s_parent], [], [], 5.0).  Would the same
timeout, or a SOCK_SEQPACKET socketpair, turn this into a normal test
failure?


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/44972669664
--===============3579480507848251298==--
