Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.167.49
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795194602;
	b=kq89nHRceJHZWq+KuCKPhlv9upy7oTlH3F1PJ1dIphzEO5Pcax5BQLl1Dn09R9yaRrUO
	 MOBXOb5lwp+iiNuX9+IHhQ4lf/TgtMZhe9sGOOXtW9acG7HFAZORcvGuIqBNOFoZZYxiW
	 Lx6UhMzpEB5/9EeUmlv58yo/ggnkzTHFBLokWslX+/y30tC9IEgC5IM54Ikwv8R1Jvp/v
	 9Qb/KhVF2jhXU/jSzT3hJQdbH6CS7IbkEXUzRwOeHigbXu5eCSz+u69FVEb+KW32H/36m
	 mw/qGqKpK7x/0doCF6NNMnKqwjq/Cl6+mosDlKeOBUOqgvttY/TgIqalfKroUs/XN7g==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795194602;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=ZjKXRhmMlyIf4k/Bgeh6+i9VHnnHMzl/5R3cKodeiFA=;
	b=uJBybjIN2uNQxlgMsICYIB/QVC+UZ2FfwhVfPk4GUpzNRfm4UuoP2HHYRAFKW+2OQhE0
	 lhSfjy2DFcKn0Un6aq6ZzbNWF0jmf07Wwtap76WcHV3g0+OcR2GFFvk3cqhsBL29dqRLu
	 tVX/iX+a11WiREPE5TALTL3LwO4W4B3QaIufPeHQ3+44LzMEUrZ1PlylUNauElOaIJh1h
	 pbsvtU3vylydBVMdJdFopaufrNMS2ejMziONvQj1SXUxVr0Na74ZkHyxhDVZy722y1yHh
	 ZgV7ttuNRd9aI7/TsLVXSKzIYlILfePuTgL+svnrRUraWyp3SBlV7iUH7q8OvnYaxLQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=none header.from=amacapital.net;
	spf=pass smtp.mailfrom=amacapital.net;
	dkim=pass header.d=amacapital-net.20260707.gappssmtp.com header.i=@amacapital-net.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=KzuPKz9w;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.167.49
Received: from mail-lf1-f49.google.com (mail-lf1-f49.google.com [209.85.167.49])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2999060A2635
	for <linux-api@vger.kernel.org>; Fri, 20 Nov 2026 17:10:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2999060A2635
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=amacapital.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amacapital.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amacapital-net.20260707.gappssmtp.com header.i=@amacapital-net.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=KzuPKz9w
Received: by mail-lf1-f49.google.com with SMTP id 2adb3069b0e04-5be3d5927ceso1600585e87.3
        for <linux-api@vger.kernel.org>; Fri, 20 Nov 2026 09:10:00 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795194599; cv=none;
        d=google.com; s=arc-20260327;
        b=iJpkszB+u4XlidbdEWZP7xjM6y6hvemgrsNKXgRxJTNT6TkoXYofCY5tSO6Q6cLaNc
         X2jeb8LnOtP4x2X03+wp+bBejOzQsQH/j3IeJw8wUlco3eSeREX5yL0dvKldUOytVefO
         AiCYqzDY1mN5cdvMztidhXbbCrGqSeVFQzcSsKAElU5ZlzxSvl+HmM2Vo/n0uhJ7TdpA
         gyNwOJ1IGkAqOyq9lruV+r/6e9mFgeTB/6PZqVY7dfXe275IkPtp3xJDlWEhSTzCycE7
         0jv3jUGyuXlVP993MVHs7Gq+DeMwx7FiMLIwEKisYGU839xMUFVwU8qCEsE/SNlrbeBb
         XDUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ZjKXRhmMlyIf4k/Bgeh6+i9VHnnHMzl/5R3cKodeiFA=;
        fh=kfkJAYKbhIjPiWHVx2SiV+kuwTi797IEn/aqkV5dFok=;
        b=JSEBh2lZgGlXhJ/g66vkh+7LkyBmMCr/nT9TfxoHOSindfYuMIOEtwBY74gz2589tE
         dfJjgbdQAcH5eULiBxVBVwWBiufuCkcmGNgYfHRRhNImF1ZtJP634EwuEUaW79KVaq4t
         LN1k/nlPxOJZT9czmjAEwkUEVO9770VckUeVrjAEPv9LJg0zsKJ00FKF4tzU8/tCNQn3
         FthAllUdKxZCeXTqTxzf0tMhqqAAwjBtCETgOwQP98FWXQAMtqzYlh5PUWUPap7MPall
         /vUhJvnlzZ8JJGS2rCQNYNWtJN9LEQZcGsAAx7tfGM34IO8FCaD0RQ/IAt99dOeTU8qR
         /4qg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amacapital-net.20260707.gappssmtp.com; s=20260707; t=1795194599; x=1795799399; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ZjKXRhmMlyIf4k/Bgeh6+i9VHnnHMzl/5R3cKodeiFA=;
        b=KzuPKz9wlUIhaJWdwueDeEluQfGhTtFH6fz8FAZF85dKlUnHi8FkaBQALudYSWmLoT
         azKe3eFVYRDOFx+8IjhGNb9qwSrA+uMjFasO0Y78bF+3hajdbSeasLRKTqR9rrRw93Fs
         mgsw5HsHH8a8RLldzj7UExTUzudAO7FPQcBGxVHr544OLOOoquGgLjJUclHerWxaJdLi
         uxmk8NZd0Ky9WVaupdZUPVmFOhf9Zb4PrRXYdyH2vDYOnjm+WhZ7uYiyPgxh2C1qaltX
         V7aCX88km55ADvHdXfnZgPboy0v8Geo0MFUxnSN4Wp1aITRMGG9KONQZYt3Rs95J370H
         rqIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795194599; x=1795799399;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ZjKXRhmMlyIf4k/Bgeh6+i9VHnnHMzl/5R3cKodeiFA=;
        b=ccPjl7pL4g3n1koemEvO113wVc+AIUtQvbP0md0b160bej43gLIeUD9akaQAegzwG0
         bnOXynOHq+65vJRPmZ9DEqUZ0j3LuOMa/8EzpW6w1en+QAdb6t4tteX2hsUWzTFhDqut
         5pynqxZ9ZMPGzcTsMDOSferQS7/+3hBZ/ggHaaDDHK4jgU/ZLvdDoyDDZKuw7yR5Zw++
         giXvu25RVWcJyHgK2QtmTxMEUKl6RxUrbnAaoqLivI/kHr3/l7ed6COzR0Uffy9qvQ+7
         tjbNAyzwJVN1BSaE/L70B8ZHIit9xIHW87C3LtfIXu/yeEuh2LL6qUBU6ik3zJYGF2Ck
         tvgA==
X-Forwarded-Encrypted: i=1; AL+hErE1288pv0WXjcsn9URBvwO1qXczYGlhP2Ya3xRiqi4Up+Xnw6K0bRDxwDnee5IxkAJIzIn+UBiUb6c=@vger.kernel.org
X-Gm-Message-State: APuU4Z+9OUUEFQwCG10D9xEXmcP+cKmw4K+LzE7RR4/MPb/uzz3frDPP
	c+SrnfvQfOxYemzcpPRgdvCM1JLqUs4SxMbss+64DlzjDjn9VxArwCCeGhL9Uut4Kn9oyhJlUo7
	dcmGY5nZ9DOQMFJ6df1GjjzoTboDHhpMk/sU22NJo
X-Gm-Gg: AZFdTZfA+h4EtvDt0AF+X4/V/WjrGiW9KWeYt3LD2jHv9brdzR0+LxizxkAF+XUPUbG
	d9P1rt8D5nd6Qs2Zg+U64qLdvlA8BZwULKDLhF6m252mGuWzhhwtKAoOoQrcqnKUK1/BvHvvEyZ
	r5q0kRntVRAI28dXEMFXOVD/+g5quEDslzlXxmdTVCqp0bFlXfQpOSR2ZZvB3bkt121qkG7ZoV1
	lgzOg/TH3qNnt1T9p4zVIXB01DxrgVGxGJseEx9A82bizWM22GSa/9ewrwtRlMY/vaf5SpWIIht
	irdAryWP+KXtpQVqfXlZYF95PYVL6fFjWQlefwrvSbn19dhKEU/Pu3LL3Z2aypVfdwyHHoAjRpl
	wk9uYk/tBrtxdFK6K3jbZWDPiSmX5wD86iQ==
X-Received: by 2002:a05:6512:1042:b0:5c1:4c4a:f026 with SMTP id
 2adb3069b0e04-5c1bc6f633dmr1312524e87.4.1795194599155; Fri, 20 Nov 2026
 09:09:59 -0800 (PST)
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261119104208.782900-1-halg@google.com> <20261119104208.782900-2-halg@google.com>
 <CALCETrVqc+1bjH1bhqHee9bsUdk2B6314z7PMexbsnNpMhk14g@mail.gmail.com>
In-Reply-To: <CALCETrVqc+1bjH1bhqHee9bsUdk2B6314z7PMexbsnNpMhk14g@mail.gmail.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Fri, 20 Nov 2026 09:09:47 -0800
X-Gm-Features: Aa3M54qqiWJmEKSjiAInchWSC43ADdXnD64UgkMS8cTjGJqVilvL89j5dcH7YsU
Message-ID: <CALCETrV=zSxb6sgA08DLiK2bQovdMEj9ycG=Cc71mLn2C5Pgeg@mail.gmail.com>
Subject: Re: [PATCH v2 1/4] userns: introduce capability bounding set for user namespaces
To: Andy Lutomirski <luto@kernel.org>
Cc: "Hallgrimur H. Gunnarsson" <halg@google.com>, Christian Brauner <brauner@kernel.org>, 
	Serge Hallyn <sergeh@kernel.org>, Paul Moore <paul@paul-moore.com>, 
	James Morris <jmorris@namei.org>, David Howells <dhowells@redhat.com>, 
	Jarkko Sakkinen <jarkko@kernel.org>, Kees Cook <kees@kernel.org>, Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <skhan@linuxfoundation.org>, Randy Dunlap <rdunlap@infradead.org>, 
	=?UTF-8?B?TWlja2HDq2wgU2FsYcO8bg==?= <mic@digikod.net>, 
	Jonathan Calmels <jcalmels@3xx0.net>, Jann Horn <jannh@google.com>, 
	=?UTF-8?Q?G=C3=BCnther_Noack?= <gnoack@google.com>, 
	Singh KP <kpsingh@kernel.org>, Casey Schaufler <casey@schaufler-ca.com>, 
	linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org, 
	linux-api@vger.kernel.org, containers@lists.linux.dev, 
	keyrings@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

> On Nov 19, 2026, at 2:52=E2=80=AFPM, Andy Lutomirski <luto@kernel.org> wr=
ote:
> =EF=BB=BFOn Thu, Nov 19, 2026 at 2:43=E2=80=AFAM Hallgrimur H. Gunnarsson
> <halg@google.com> wrote:
>>
>> When a process creates a new user namespace, it receives a full set of
>> capabilities (CAP_FULL_SET) scoped to that namespace. While namespaced
>> in scope, several of these capabilities (such as CAP_NET_ADMIN and
>> CAP_NET_RAW) expose broad kernel attack surface that many sandboxes and
>> containers never need. However, there is currently no configurable way
>> to withhold such capabilities from user namespaces while still granting
>> them to workloads that require them.
>
>
> One thought (from the rootns thread): the other decent sized attack
> surface here is CAP_MOUNT_ADMIN.  Which doesn't exist as a capability
> bit.
>
> A sort of horrible solution (but maybe not so awful) would be to
> declare that the bits in cap_userns aren't actually capability bits,
> and that you need the bit in cap_userns *and* the bit in cap_effective
> to do sensitive things, and that mounting needs cap_userns to have
> NSCAP_MOUNT_ADMIN *and* cap_effective to have CAP_SYS_ADMIN.
>
> I want to sleep on this.  It might actually solve several problems,
> e.g. controlling creation of ipv4 and ipv6 loopback or tunnel devices
> or whatever.

I slept on it. Here=E2=80=99s a counterproposal.  I=E2=80=99m not saying I =
think this
is better than this patch set, but I think it=E2=80=99s worth weighting the
options.

Define a whole new set of privilege bits.  As a
poorly-painted-bikeshed option, I=E2=80=99ll call them eprivs (for exposure
privileges - it=E2=80=99s a crappy name but at least it=E2=80=99s pronounce=
able).

An epriv is not permission to do something *to* an object; it=E2=80=99s
permission to do something that exposes a meaningful attack surface
within the kernel. So there=E2=80=99s no ns_has_epriv because there is no
object.  These are kind of the opposite of object capabilities.
Additionally, an epriv never grants the ability to do something that
one couldn=E2=80=99t do in an epriv-less world.

For now, all tasks have all eprivs, even not-yet-defined ones, unless
user code or config explicitly changes this.  (Maybe some day secure
boot might remove certain eprivs.)

There should never be a check like ns_capable || has_epriv. It=E2=80=99s al=
so
&&, or perhaps caps are not checked at all.

Example eprivs include:

EPRIV_FSOPEN_VIRT: may fsconfig, fsopen, etc a virtual fs like fuse or
tmpfs or overlayfs.

EPRIV_CLONE_TREE: may clone a mount tree

EPRIV_MOVE_MOUNT: may move mounts around (but only if you also have
CAP_SYS_ADMIN on the correct namespace, of course)

EPRIV_FIREWALL_TC: may configure any firewalling configuration or tc
configuration (this includes iptables, nftables, and ebtables)

EPRIV_NET_RAW: may use raw/packet sockets (like CAP_NET_RAW)

EPRIV_TUNTAP: may create and attach to tun/tap interfaces

EPRIV_IP_LOOPBACK: may set up IPv4 and IPv6 loopback using whatever
new facility we add

EPRIV_NETLINK: may use netlink at all

EPRIV_NET_ADMIN: may use traditional CAP_NET_ADMIN abilities (all
CAP_NET_ADMIN checks will also check EPRIV_NET_ADMIN)

EPRIV_OPEN_FILE_HANDLE: May use open_by_handle_at, etc.

EPRIV_UNSHARE_USERNS: may unshare userns

EPRIV_UNSHARE_NONUSERNS: may unshare any other namespace

EPRIV_MOUNT_CGROUPv1, EPRIV_MOUNT_CGROUPv2: may create a new mount of
these subsystems

EPRIV_PTRACE: there are lots of different variations that might make sense.

EPRIV_MOUNT_PROC_PIDONLY: may mount proc-pidonly

EPRIV_MOUNT_PROC_NOTPIDONLY: may mount proc not-pidonly

EPRIV_MOUNT_SYSFS: may mount sysfs

Example eprivs that are questionable:

EPRIV_DMESG: the kernel log is a specific object, and I think it's
better to control access using something kernel-log-specific.



There is no operation that increases eprivs -- even without
no_new_privs set, a task will never gain an epriv, nor will a child
ever have an epriv that its creator did not have at the time the child
was created.

The evolution rules could be as simple as, on fork/clone, the child
inheriting exactly the parent's eprivs.

Or we could bind eprivs to a userns instead of a task, but that could
be more limiting and awkward than we want.


What do you all think?


FWIW, I had an LLM make an inventory (surely not exhaustive) of
recent-ish CVEs and how they relate to this list.  (The below is the
only part of this email that is LLM-generated, although I added
EPRIV_SYSFS because I didn't realize that nonroot userns could mount
it until I asked an LLM, sigh.)  To me, the list and its breakdown
suggests that there is quite a lot of room for meaningful attack
surface reductions while still leaving large parts of userns
available, and that my epriv proposal captures much of this but the
cap_userns proposal may be too coarse-grained.

(I also asked about eBPF, and my LLM came up with a lot of CVEs, but
there's an existing BPF token mechanism and I therefore did not
propose EPRIV_LOAD_EBPF.)

--- begin LLM output ---

**EPRIV_FSOPEN_VIRT:** CVE-2022-0185*, CVE-2023-0386*, CVE-2023-2640*,
CVE-2023-32629*, CVE-2025-38499*

**EPRIV_CLONE_TREE:** CVE-2025-38499* (only if the check also covers
the relevant internal mount-cloning path; explicit `open_tree()`
restrictions alone are insufficient)

**EPRIV_MOVE_MOUNT:** CVE-2025-37988

**EPRIV_FIREWALL_TC:** CVE-2022-25636, CVE-2022-1015, CVE-2022-1016,
CVE-2022-32250, CVE-2022-34918, CVE-2022-48911*, CVE-2022-2588,
CVE-2023-32233, CVE-2023-35001, CVE-2023-4004, CVE-2023-4015,
CVE-2023-4244, CVE-2023-5197, CVE-2023-6817, CVE-2023-3609,
CVE-2023-4623, CVE-2023-4921, CVE-2024-1086, CVE-2024-0607,
CVE-2024-27397, CVE-2024-26925, CVE-2025-38001, CVE-2026-23111

**EPRIV_NET_RAW:** None identified.

**EPRIV_TUNTAP:** None identified as requiring TUN/TAP. Some
packet-triggered exploits may optionally use it, but that does not
establish it as a necessary blocker.

**EPRIV_IP_LOOPBACK:** None identified.

**EPRIV_NETLINK:** Also those blocked by `EPRIV_FIREWALL_TC`, insofar
as the documented attack paths use netlink. No additional CVEs
identified.

**EPRIV_NET_ADMIN:** Also those blocked by `EPRIV_FIREWALL_TC`,
insofar as the vulnerable operations require `CAP_NET_ADMIN`. No
additional CVEs identified.

**EPRIV_OPEN_FILE_HANDLE:** CVE-2025-38306*

**EPRIV_UNSHARE_USERNS:** Also those blocked by `EPRIV_FSOPEN_VIRT`,
`EPRIV_MOVE_MOUNT`, `EPRIV_FIREWALL_TC`, `EPRIV_OPEN_FILE_HANDLE`,
`EPRIV_MOUNT_CGROUPv1`, and `EPRIV_MOUNT_SYSFS`, plus CVE-2025-38058*.
More generally, blocks the documented unprivileged user-namespace
setup for the entire inventory when no usable user namespace already
exists.

**EPRIV_UNSHARE_NONUSERNS:** Also the namespace-dependent attack paths
blocked by `EPRIV_FIREWALL_TC`, `EPRIV_MOVE_MOUNT`,
`EPRIV_MOUNT_CGROUPv1`, `EPRIV_MOUNT_SYSFS`, and many of those blocked
by `EPRIV_FSOPEN_VIRT`. Coverage depends on whether the necessary
non-user namespaces already exist.

**EPRIV_MOUNT_CGROUPv1:** CVE-2022-0492*

**EPRIV_MOUNT_CGROUPv2:** None identified.

**EPRIV_PTRACE:** None identified.

**EPRIV_LOAD_EBPF:** None identified.

**EPRIV_MOUNT_PROC_PIDONLY:** None identified.

**EPRIV_MOUNT_PROC_NOTPIDONLY:** None identified.

**EPRIV_MOUNT_SYSFS:** CVE-2025-22089*

CVEs not cleanly blocked by an operation-specific bit
Excluding the two EPRIV_UNSHARE_* gates:

- CVE-2025-38058: No explicit unmount privilege. The vulnerable race
involves umount(2) and path lookup.

- CVE-2022-0492: The cgroup-v1 mount bit covers the documented
new-mount attack path, but not necessarily configuration of
release_agent on an existing writable hierarchy.

- CVE-2025-38499: The correct gate depends on which filesystem-context
or internal cloning operation reaches clone_private_mnt(). I would not
count EPRIV_CLONE_TREE as a definitive blocker without checking the
exact call paths.
