Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=178.63.66.53
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793709476;
	b=hAL7AGAfjgLRQgb5TxmeiE51rGsq68iSMRKYfoZFXl7PfVvOXXDpFIVQxbYv2XSQM1d/
	 UQD6roX4Z5UlBTs1BWF6lkb5J/i2XSJAh80QqFmxPTuMloKZd6j/v5MVaWjMAO4zu6/7c
	 UoO/wmFD1YVdQLmYbo7kZvWHad5Jxc8b0mB00B29c/f4m8eW37COrJqUm8M8NW8BxKcMG
	 BZ5odE6D9b4AW/zf/JS4oLlnz6hwMA5LNZrZsQgJn0SV/qT8SX+tV5WDA3pIipxctniyg
	 I7J7mME6JZkT2mPRSKEfzXgUTFGlrw5VPQXlc3/q86tu4RnE9e3W8ZOQEpk+nk7+Z0w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793709476;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To;
	bh=oV7i9bIc6g6SKXJ1HJf50C8bZZAE2Takb9sNll8AaUA=;
	b=r+1jV4wo21sclTqao1oYZSV0fzT29rCVU97bIyC6yVkrjmRttCwrfD2Q/s7G/K9hyOwu
	 XUF6oGmcdlq0nJ/cSW6kI4fmXLfMXmmOiTR/TPBP+jQg+mQdLbk9ctomuIupIL/ozfUKD
	 gJ0DoAXIbHWdByagEN9fm7KfuZmgZDwQs9aVe+z+f45ceBAi9ZEqu9fO1dWLYNqkANYpZ
	 NCOj3qhPN5BzEk1dJdG079/SOUNx0hCbWF57mE/5tJMMWH9MlSAehB0aMRygj2A5el2Jo
	 qe62uJUEdJDqqwwUcikpBN2yknk+4Dg6y3R5eC+S42msouDQy4GA8cAhWOVvaIquqyg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=hallyn.com;
	spf=(null) smtp.mailfrom=hallyn.com;
	dkim=pass header.d=hallyn.com header.i=@hallyn.com header.a=rsa-sha256 header.s=mail header.b=vC9TDmhV;
	arc=none smtp.remote-ip=178.63.66.53
Received: from mail.hallyn.com (mail.hallyn.com [178.63.66.53])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3F20606EEA0;
	Tue,  3 Nov 2026 12:37:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C3F20606EEA0
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=hallyn.com
Authentication-Results: smtp.subspace.kernel.org; spf=tempfail smtp.mailfrom=hallyn.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=hallyn.com header.i=@hallyn.com header.a=rsa-sha256 header.s=mail header.b=vC9TDmhV
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=hallyn.com; s=mail;
	t=1793709466; bh=srJr0W2zj7CWyIxBRugbw6W/RJOIVVmVJA2BZvprlc4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=vC9TDmhVzpFPGgCSMr4165tQq6DCEFta1S319V91nRjNJWVnaElj5EAq2XW2eRHjJ
	 gGh+I4bOHp/FtOf8Kea16ZVZiBZ+iLnPQwxED32qxh1DgFUkGIPtnmq0RepGmeQJ+l
	 4iztOzjKyQPMal+wlEpDHPXVZPYZMmQ+r1A0YwDnpjt0prpdx8aH3DoDR5Ll8IkZdg
	 fcB/kqvpbIl1RI+I4UahFb1R62IqF66zwswBhfdrCuY2o7ADXAPpnWNhmtnnb+e4Q6
	 hgTFzkN5XOXy7wa91Udr49XuOtsnYjLlHZroXiYyT2j/Kp51c9u6bwkqVdqZ0o8Yn8
	 F6wDnif+kXC3g==
Received: by mail.hallyn.com (Postfix, from userid 1001)
	id 326D81B96; Tue,  3 Nov 2026 06:37:46 -0600 (CST)
Date: Tue, 3 Nov 2026 06:37:46 -0600
From: "Serge E. Hallyn" <serge@hallyn.com>
To: "Hallgrimur H. Gunnarsson" <halg@google.com>
Cc: Christian Brauner <brauner@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Paul Moore <paul@paul-moore.com>, Serge Hallyn <sergeh@kernel.org>,
	Kees Cook <kees@kernel.org>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Jan Kara <jack@suse.cz>, James Morris <jmorris@namei.org>,
	Simon Horman <horms@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>, Jann Horn <jannh@google.com>,
	=?iso-8859-1?Q?G=FCnther?= Noack <gnoack@google.com>,
	KP Singh <kpsingh@kernel.org>, Jonathan Calmels <jcalmels@3xx0.net>,
	Casey Schaufler <casey@schaufler-ca.com>,
	linux-fsdevel@vger.kernel.org,
	linux-security-module@vger.kernel.org, linux-api@vger.kernel.org,
	containers@lists.linux.dev, netdev@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/8] userns: per-namespace capability bounding set and
 opt-in netns loopback
Message-ID: <aunVmg42/S2uUDWR@hallyn.com>
References: <20261028221705.3915340-1-halg@google.com>
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261028221705.3915340-1-halg@google.com>

On Wed, Oct 28, 2026 at 10:16:57PM +0000, Hallgrimur H. Gunnarsson wrote:
> When an unprivileged process creates a new user namespace, it is granted
> a full set of capabilities (CAP_FULL_SET) scoped to that namespace.
> While these capabilities are isolated to the namespace, they allow
> unprivileged local users to reach deep kernel subsystems (most notably
> networking configuration and raw sockets via CAP_NET_ADMIN and
> CAP_NET_RAW) that historically assumed a trusted caller and have
> accounted for a large share of local privilege escalation
> vulnerabilities.
> 
> Many workloads and sandboxes use unprivileged user namespaces strictly
> for basic UID/GID, mount, PID, or network isolation and never need
> high-risk capabilities like CAP_NET_ADMIN or CAP_NET_RAW. Likewise,
> system administrators often want a host-wide policy ceiling restricting
> which capabilities unprivileged user namespaces may acquire, without
> disabling unprivileged user namespaces altogether.
> 
> Prior work by Jonathan Calmels [1] proposed addressing this via a sixth
> per-thread capability set (cap_userns) alongside a global sysctl mask.
> During that discussion [1, 2], feedback (e.g. from Casey Schaufler)
> suggested that rather than adding another per-thread capability set and
> prctl() interface, capability restrictions could be integrated directly
> into struct user_namespace and configured via clone3(). At the same
> time, as noted in [1], a clone3() flag alone is not sufficient for
> administrators who need to enforce a host-wide ceiling on unprivileged
> user namespaces without modifying every userspace callsite.
> 
> This series combines both pieces of feedback: it embeds a capability
> bounding set (cap_bset) directly into struct user_namespace, reusing
> the existing task cap_bset, cap_permitted, and cap_effective sets on
> namespace entry, and provides both a system-wide sysctl ceiling for
> unprivileged user namespaces and a CLONE_NEWUSER_BSET flag for
> voluntary per-namespace restriction via clone3().

Hi.  Thanks for sending this, and continuing to think about this problem.

A few weeks back I had a somewhat different idea for such controls.  I've
been meaning to start a wider discussion about it, but was traveling for
a bit.  What I wrote then:

Generally, if I, or some users I support, need to use unprivileged containers
or user namespaces, then when an 0day comes along, I can hopefully trust them
not to exploit it.  The biggest danger comes from the fact that, right now, if
they can use them, anyone can.  So if someone can trigger some other code running
as user nginx or something, that can become a root vector.

So what if we had a built-in feature or LSM which implemented a credential based
whitelist, entered at firstboot?  Something like

```
# Default deny
uid == 1000  # approved
1005 < uid < 1010  # approved
gid == 1005
security_label = lxc_user_t  # Not sure how far we want to go with this
tty # must have a session
```

Now, if you want to use user namespaces for generic sandboxes for all
users, e.g. to confine browser activity or nginx modules, then this model
may not fit.  Or rather, it might need a few tweaks.

Kees whipped up a proof of concept BPF lsm that implemented this.  A copy
from his email (and let's call it GPLv2 unless he wants to change it to
something like MIT) follows:

Needs:

CONFIG_BPF_LSM=y
CONFIG_DEBUG_INFO_BTF=y
FUNCTION_TRACER=y
DYNAMIC_FTRACE=y


#!/bin/bash
# Manage the userns allowlist policy.
#
#   policy.sh load                 load, attach and pin (policy still writable)
#   policy.sh allow-uid UID        add a uid
#   policy.sh allow-gid GID        add a gid
#   policy.sh deny-uid  UID        remove a uid (only before "lock")
#   policy.sh show                 dump the policy
#   policy.sh failures             who has been denied, and how often
#   policy.sh lock                 freeze the policy maps, one way
#   policy.sh unload               detach and unpin everything
#
# bpftool takes keys and values as raw bytes in target byte order, so a u32
# uid has to be written little-endian on x86: uid 1000 is "e8 03 00 00", not
# "00 00 03 e8". Getting that backwards silently writes a policy for uid
# 3892510720 instead, which is why this script exists.
set -eu

BPFFS=${BPFFS:-/sys/fs/bpf}
DIR=$BPFFS/userns			# pinned maps (a directory)
LINK=$BPFFS/userns_link			# pinned lsm link (a file)
OBJ=${OBJ:-$(dirname "$0")/userns_allowlist.bpf.o}
BPFTOOL=${BPFTOOL:-bpftool}

u32_le() {	# 1000 -> "hex e8 03 00 00"
	printf 'hex %02x %02x %02x %02x' \
		$(( $1        & 0xff)) $(( ($1 >> 8)  & 0xff)) \
		$(( ($1 >> 16) & 0xff)) $(( ($1 >> 24) & 0xff))
}

# bpftool prints map contents as integers when the object carries BTF and as
# arrays of hex byte strings when it does not. Handle both.
decode() {
	python3 -c '
import json, sys
rows = json.load(sys.stdin)
if not rows:
    sys.exit("(empty)")
def val(v):
    if isinstance(v, list):
        return int.from_bytes(bytes(int(x, 16) for x in v), "little")
    return int(v)
for r in sorted(rows, key=lambda r: -val(r["value"])):
    print("uid %-8d denied %d time(s)" % (val(r["key"]), val(r["value"])))
'
}

case ${1:-} in
load)
	mountpoint -q "$BPFFS" 2>/dev/null || mount -t bpf bpf "$BPFFS"
	# bpftool creates both pin paths itself and fails if either exists, so
	# do not mkdir them. For a single-program object the program path is a
	# file (the pinned link); pinmaps is a directory.
	$BPFTOOL prog load "$OBJ" "$LINK" pinmaps "$DIR" autoattach
	# "prog load" exits 0 even when the LSM attach failed and it silently
	# fell back to pinning the program, which leaves the policy loaded but
	# inert. The only reliable check is that an lsm link now exists.
	if ! $BPFTOOL link show | grep -q lsm; then
		echo "ERROR: no lsm link: the program is loaded but NOT enforcing." >&2
		echo "Needs CONFIG_BPF_LSM=y, CONFIG_DEBUG_INFO_BTF=y and" >&2
		echo "CONFIG_DYNAMIC_FTRACE_WITH_DIRECT_CALLS=y (the last one" >&2
		echo "requires CONFIG_FUNCTION_TRACER=y), plus bpf in CONFIG_LSM." >&2
		exit 1
	fi
	echo "loaded and enforcing; policy maps under $DIR (not yet frozen)"
	;;
allow-uid)
	$BPFTOOL map update pinned "$DIR/allowed_uids" key $(u32_le "$2") value hex 01
	;;
allow-gid)
	$BPFTOOL map update pinned "$DIR/allowed_gids" key $(u32_le "$2") value hex 01
	;;
deny-uid)
	$BPFTOOL map delete pinned "$DIR/allowed_uids" key $(u32_le "$2")
	;;
show)
	echo "== allowed uids"; $BPFTOOL map dump pinned "$DIR/allowed_uids"
	echo "== allowed gids"; $BPFTOOL map dump pinned "$DIR/allowed_gids"
	;;
failures)
	# key is the euid that was denied, value is a count
	$BPFTOOL -j map dump pinned "$DIR/denied_uids" | decode
	;;
lock)
	# Only the policy maps. denied_uids is written by the program, and
	# program writes bypass the frozen check, so freezing it would lock out
	# this script without stopping anything.
	$BPFTOOL map freeze pinned "$DIR/allowed_uids"
	$BPFTOOL map freeze pinned "$DIR/allowed_gids"
	echo "policy frozen; allow-uid/allow-gid/deny-uid will now fail with EPERM"
	echo "even as root. Changing it means 'unload' and 'load' again."
	;;
unload)
	rm -f "$LINK" "$DIR"/allowed_uids "$DIR"/allowed_gids "$DIR"/denied_uids
	rmdir "$DIR" 2>/dev/null || true
	echo "unpinned; enforcement stops when the last reference goes away"
	;;
*)
	# the header comment block, however long it grows
	awk 'NR > 1 && /^#/ { print; next } NR > 1 { exit }' "$0"
	exit 1
	;;
esac

# There is no "digest" command, though a frozen policy looks like it should
# have one. The kernel will hash a frozen map and return it through
# BPF_OBJ_GET_INFO_BY_FD in info.hash (syscall.c:5433, -EPERM unless
# map->frozen), but only array maps implement ->map_get_hash(); for a
# BPF_MAP_TYPE_HASH it fails with -EINVAL however frozen it is. bpftool does
# not expose info.hash either way. Attesting to this policy would mean
# reshaping it as arrays -- e.g. a bitmap indexed by uid -- and calling
# BPF_OBJ_GET_INFO_BY_FD directly.

exit 0



// SPDX-License-Identifier: GPL-2.0
/*
 * Credential allowlist for unprivileged user namespace creation.
 *
 * Default deny. A caller is allowed to create a user namespace if any of:
 *   - its euid is in allowed_uids
 *   - its egid is in allowed_gids
 *   - any of its supplementary groups is in allowed_gids
 *
 * The maps are populated once (at first boot, from a config file) and then
 * frozen with BPF_MAP_FREEZE, after which the kernel refuses further updates
 * through the syscall interface even from root. Pin the program and the maps
 * under bpffs so they survive the loader exiting.
 */
#include "vmlinux.h"
#include <errno.h>
#include <bpf/bpf_helpers.h>
#include <bpf/bpf_tracing.h>
#include <bpf/bpf_core_read.h>

char _license[] SEC("license") = "GPL";

/*
 * Supplementary groups are walked with a fixed bound so the verifier can
 * see termination. A caller in more than this many groups falls back to the
 * euid/egid checks. Raise it, or switch to bpf_loop(), if that matters.
 */
#define MAX_SUPP_GROUPS 64

struct {
	__uint(type, BPF_MAP_TYPE_HASH);
	__uint(max_entries, 1024);
	__type(key, __u32);		/* uid */
	__type(value, __u8);
} allowed_uids SEC(".maps");

struct {
	__uint(type, BPF_MAP_TYPE_HASH);
	__uint(max_entries, 1024);
	__type(key, __u32);		/* gid */
	__type(value, __u8);
} allowed_gids SEC(".maps");

/* Denials, so you can see what a policy would break before enforcing it. */
struct {
	__uint(type, BPF_MAP_TYPE_HASH);
	__uint(max_entries, 4096);
	__type(key, __u32);		/* uid */
	__type(value, __u64);		/* count */
} denied_uids SEC(".maps");

static __always_inline int gid_allowed(__u32 gid)
{
	return bpf_map_lookup_elem(&allowed_gids, &gid) != NULL;
}

SEC("lsm/userns_create")
int BPF_PROG(userns_allowlist, const struct cred *cred, int ret)
{
	struct group_info *gi;
	__u32 uid, gid;
	int i, ngroups;
	__u64 init = 1, *count;

	/* Someone before us already objected; do not launder their denial. */
	if (ret)
		return ret;

	uid = BPF_CORE_READ(cred, euid.val);
	if (bpf_map_lookup_elem(&allowed_uids, &uid))
		return 0;

	gid = BPF_CORE_READ(cred, egid.val);
	if (gid_allowed(gid))
		return 0;

	/*
	 * The common deployment is one group that everyone permitted is a
	 * member of, which for most users is a supplementary group rather
	 * than their primary one, so egid alone is not enough.
	 */
	gi = BPF_CORE_READ(cred, group_info);
	if (gi) {
		ngroups = BPF_CORE_READ(gi, ngroups);
		if (ngroups > MAX_SUPP_GROUPS)
			ngroups = MAX_SUPP_GROUPS;

		for (i = 0; i < MAX_SUPP_GROUPS; i++) {
			if (i >= ngroups)
				break;
			/*
			 * struct group_info is __randomize_layout and gid[] is
			 * a flexible array, so this has to go through CO-RE
			 * rather than any assumed offset.
			 */
			if (bpf_core_read(&gid, sizeof(gid), &gi->gid[i].val))
				break;
			if (gid_allowed(gid))
				return 0;
		}
	}

	count = bpf_map_lookup_elem(&denied_uids, &uid);
	if (count)
		__sync_fetch_and_add(count, 1);
	else
		bpf_map_update_elem(&denied_uids, &uid, &init, BPF_NOEXIST);

	return -EPERM;
}
