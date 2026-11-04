Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=203.205.221.245
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793763376;
	b=q7z2u/JYg085dNmy0k/f+dKjkOXfYBi3j7g4I0WFCUy99mcyg0WEgjSUnOZZsla9nfPy
	 xWWDEun76iCP89+CoQzCK2T0TcuHtQIE1K8JFMOu8pzFljAec2ikRDE8fur+nhpgcGGna
	 7sye7boWwDfPEjcJjeKSbWHgw5HrLypm771dKfB+ljmDj+9hVue1198CexP+cqz7ewHVJ
	 tFOVStTk0xTQ2zZHYzqic/Y43oWEO+8H5bcwZ1hi3bMGWXz1sTI3ZhcLR/4XohKJfjZd5
	 4DwqxnDRIgRfNGmLKwncyn91SXOoHU+8yocHaZ8x32qz2PC4nqkm5uHDhn6OD7okdLA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793763376;
	h=DMARC-Filter:DKIM-Signature:Received:X-QQ-mid:Message-ID:
	 X-QQ-XMAILINFO:X-QQ-XMRINFO:From:To:Cc:Subject:Date:X-OQ-MSGID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=c1L8CWwxkb82VUM74HKD/x2WhzlFYQ0FCkDUGbRnDf0=;
	b=rFJ/OFwWXAyyfyixyuvLURqy+szK/XAcUHZvC0CBh5b4mGp3/0/tZWrQPVvEiffgkVIQ
	 E7bbTQ8aCrfwUWrRX2NUfIwtxgNJ3K6rwJKbzP9/pfBX3WegeQ2tFec/6valo2fom73tY
	 8hN16LUymoD0hT3oVJtDsX+POI8XN372q3LVO3IbdGMuIkPx85N3hqDMvU3cFPfLOLdox
	 V/z3E8HVPWyD1rlgJz7Yutxu94I9roWAfolzkYNgF79I6Rhh2YfXtJCG0yWw+K14nwCm3
	 F9dzJOaD8PVMzeMh5vOpKpZrze0So6WTBhm2GjRVJrsVFuIkmZj8OLJoBX6qXt/iKVw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=qq.com;
	spf=pass smtp.mailfrom=qq.com;
	dkim=pass header.d=qq.com header.i=@qq.com header.a=rsa-sha256 header.s=s201512 header.b=SeCrb8aN;
	arc=none smtp.remote-ip=203.205.221.245
Received: from out203-205-221-245.mail.qq.com (out203-205-221-245.mail.qq.com [203.205.221.245])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AAA8606A326;
	Wed,  4 Nov 2026 03:36:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6AAA8606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=qq.com header.i=@qq.com header.a=rsa-sha256 header.s=s201512 header.b=SeCrb8aN
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1793763367; bh=c1L8CWwxkb82VUM74HKD/x2WhzlFYQ0FCkDUGbRnDf0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SeCrb8aNm2YCb//OC88n3B+Uqv8DlSe585EazKUxOWpsw39m360PnCqvS0UEspqB0
	 joV5ThZK946z9rDNNHOC9jCs2h75FhfCYKm82RGr5bRDhz9MvIybUtfI4mFTZeanBJ
	 vfjaVJl4cUzm0tBXWw5nsDlo4YvU7GaunywRn4zs=
Received: from hub.zhongying.com.zhongying.com ([2409:891f:8f46:1a8b:2dd5:45b2:eebc:59b4])
	by newxmesmtplogicsvrszc50-0.qq.com (NewEsmtp) with SMTP
	id 8DBB9AD2; Wed, 04 Nov 2026 11:35:27 +0800
X-QQ-mid: xmsmtpt1793763363tjbmkdbgd
Message-ID: <tencent_5B994F45E09E8315DDD523066FED2C26A106@qq.com>
X-QQ-XMAILINFO: MDbayGdXPuoerk0Uj7pKS4/9Q76bVUyFd5nl5Y3azBvPg/8IoMo0XsNBBzhQcF
	 K9J1UsHqdeZDnxnnysG6AQdYwrN4aSef9pCnqXhiXH0E1GXrOV7y3QIIBDSyspwkHFq0RgrP1CTV
	 UGTl2bs2XGQ3HTgp/pyJAs7CGD9o7ZHZo2r2QY1yYrAGpiMrMpcd6nztjygLHkTgLvW3i7q3+Fbm
	 S33GJ5nwXh6BbVVXXc94wAsq/8+vmtEL968Vp5l+x+9WRoboVTAnw2px6jg5hTyKw1MyQnwSM4F+
	 Ue+POf8m96wFiGX7pRA7nS+Vu7JEJLJazb0z9Nkvq8cfM9gYRE4Secyxie7+T8UpV2Bi0rSRgN1s
	 sQsFiNjozPYTzMj5RrhdKjbZ4jT4xfa95XeSh2MbqQIEB5t7BX4+38b3Iwc9MKwHagU9H7eXNvyu
	 E+fNAa++fa786lYqZHn/ASOLf7c88AWeTvsVR2QSBBks+v+GeXsONgv6ZFrZB/8lWIuYd8YlmDsL
	 RS1UuO+F0KMolz6r3zkiw36QTWM1pJzyc+zERvQBRqU8g+hQwGjCoagsBticMp887ACXydcuqlCQ
	 CQdT/UZAzjJ8eJv0TwWVyj5w4I3lIA0m3b7cSkj2hBCMAd2ejfKsBgOAQzKsWz6HEsdGlDyzdyBt
	 WELiWmQf9loJoJ/jkCAGPpbVQO/KwOY063qIYFlhuaI0KwXxb71H3hRjTzNuZRy2pmAyTWxDQqhh
	 lGkdbygPKxNt+JaYLDumgPDt8mrGgPLFq2NdVaxZA/4bKrb1c3LgNGPLl/+NcqkkRnoLMX3/M8hM
	 HtyiQu9aaS/ezRAlZmpqthkH1+57Pr72mPbZyT+23Lu48b3BkhS7w/0s0+Srq9JcpNIm7zzvJiu9
	 H6mggsRqJYVpys7Xv8XUWuT6MzoU6xzmrQrTE//EyCiVV5p+GaApzUxHPfTi/k8rsUocQMzD5KFX
	 qJdbUjR6TNLd4UKlHQ/PettR1dQdIwK8oBW0BxTzs3O7olcEFSR02cANGrNnhBjHmyhVeLnzDC5r
	 /z1pWA3Yz3kHnrLjWiTznEobBNof++IhDCdxsUQ5JpXjYPh9FxObJSqaRU31BtRiVdVXkU3bf9VL
	 okm6Qm
X-QQ-XMRINFO: MPJ6Tf5t3I/ylTmHUqvI8+Wpn+Gzalws3A==
From: patrick <work_patrick@qq.com>
To: netdev@vger.kernel.org
Cc: davem@davemloft.net,
	edumazet@kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	horms@kernel.org,
	corbet@lwn.net,
	rdunlap@infradead.org,
	linux-doc@vger.kernel.org,
	skhan@linuxfoundation.org,
	linux-kselftest@vger.kernel.org,
	linux-api@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH net-next 2/2] selftests: net: cover ROUTE multicast namespace and switch semantics
Date: Wed,  4 Nov 2026 11:35:26 +0800
X-OQ-MSGID: <20261104033526.2917590-3-work_patrick@qq.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20261104033526.2917590-1-work_patrick@qq.com>
References: <20261104033526.2917590-1-work_patrick@qq.com>
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

Exercise local and cross-namespace delivery, permissions, group filters,
subscription and option transitions, socket filters, overflow behaviour,
compatibility mode and unaffected Netlink protocols. Include group
memberships above 32. Validate live changes of the optional ROUTE index
while existing sockets remain active and while subscriptions change.

Use unique namespace names and clean up sockets and namespaces on exit.
Restore the sysctl after the switch test. Report missing privileges,
iproute2, Python setns support or the optional sysctl as kselftest SKIP.
The general semantic test also runs on kernels without the new switch.
No function tracing, FRR or network access is required.

AI assistance: An LLM assisted with implementation adaptation.

Signed-off-by: patrick <work_patrick@qq.com>
---
 tools/testing/selftests/net/Makefile          |   2 +
 tools/testing/selftests/net/config            |   1 +
 .../selftests/net/netlink_mcast_semantics.py  | 420 ++++++++++++++++++
 .../selftests/net/netlink_mcast_switch.py     | 217 +++++++++
 4 files changed, 640 insertions(+)
 create mode 100755 tools/testing/selftests/net/netlink_mcast_semantics.py
 create mode 100755 tools/testing/selftests/net/netlink_mcast_switch.py

diff --git a/tools/testing/selftests/net/Makefile b/tools/testing/selftests/net/Makefile
index 9180b9bec..4f7bb7edb 100644
--- a/tools/testing/selftests/net/Makefile
+++ b/tools/testing/selftests/net/Makefile
@@ -71,6 +71,8 @@ TEST_PROGS := \
 	netdev-l2addr.sh \
 	netdev_lock.py \
 	netdevice.sh \
+	netlink_mcast_semantics.py \
+	netlink_mcast_switch.py \
 	netns-name.sh \
 	netns-sysctl.sh \
 	nk_qlease.py \
diff --git a/tools/testing/selftests/net/config b/tools/testing/selftests/net/config
index d4416f8bd..3dbb0d3f8 100644
--- a/tools/testing/selftests/net/config
+++ b/tools/testing/selftests/net/config
@@ -97,6 +97,7 @@ CONFIG_NET_IPGRE_DEMUX=m
 CONFIG_NET_IPIP=y
 CONFIG_NET_IPVTI=y
 CONFIG_NETKIT=y
+CONFIG_NETLINK_DIAG=y
 CONFIG_NET_L3_MASTER_DEV=y
 CONFIG_NET_NS=y
 CONFIG_NET_PKTGEN=m
diff --git a/tools/testing/selftests/net/netlink_mcast_semantics.py b/tools/testing/selftests/net/netlink_mcast_semantics.py
new file mode 100755
index 000000000..2c5884d1e
--- /dev/null
+++ b/tools/testing/selftests/net/netlink_mcast_semantics.py
@@ -0,0 +1,420 @@
+#!/usr/bin/env python3
+# SPDX-License-Identifier: GPL-2.0-only
+"""NETLINK_ROUTE multicast semantic checks, independent of the lab."""
+import argparse
+import array
+import contextlib
+import ctypes
+import errno
+import json
+import os
+from pathlib import Path
+import select
+import socket
+import struct
+import subprocess as sp
+import time
+import tempfile
+import shutil
+import sys
+
+SOL_NETLINK = 270
+ROUTE6, ROUTE4, LINK, ADDR4, ADDR6, NEXTHOP = 11, 7, 1, 5, 9, 32
+ap = argparse.ArgumentParser(description=__doc__)
+ap.add_argument('--output', type=Path)
+args = ap.parse_args()
+if os.geteuid() != 0 or not shutil.which('ip') or not hasattr(os, 'setns'):
+    print('1..0 # SKIP requires root, iproute2 and Python os.setns')
+    sys.exit(4)
+out = args.output or Path(tempfile.mkdtemp(prefix='netlink-mcast-'))
+if args.output:
+    out.mkdir(exist_ok=False, parents=True)
+cases, sockets, namespaces = [], [], []
+prefix = f'nlmc-{os.getpid()}-'
+if not Path('/proc/sys/net/ipv4/nexthop_compat_mode').exists():
+    print('1..0 # SKIP requires IPv4/IPv6 nexthop support')
+    sys.exit(4)
+print('TAP version 13', flush=True)
+original = os.open('/proc/self/ns/net', os.O_RDONLY)
+# Probe namespace creation before beginning behavioural assertions.
+probe_lib = ctypes.CDLL(None, use_errno=True)
+if probe_lib.unshare(0x40000000):
+    probe_errno = ctypes.get_errno()
+    os.close(original)
+    if probe_errno in (errno.EPERM, errno.EINVAL, errno.ENOSYS):
+        print('1..0 # SKIP cannot create a network namespace')
+        sys.exit(4)
+    raise OSError(probe_errno, os.strerror(probe_errno))
+try:
+    for probe_protocol in (0, 4, 16):
+        socket.socket(socket.AF_NETLINK, socket.SOCK_RAW, probe_protocol).close()
+except OSError as probe_error:
+    if probe_error.errno in (errno.EPROTONOSUPPORT, errno.EAFNOSUPPORT):
+        print('1..0 # SKIP missing required Netlink protocol')
+        os.setns(original, 0)
+        os.close(original)
+        sys.exit(4)
+    raise
+os.setns(original, 0)
+
+
+def cmd(*a):
+    return sp.check_output(a, text=True, stderr=sp.STDOUT, timeout=30).strip()
+
+def ns(name):
+    name = prefix+name
+    cmd('ip', 'netns', 'add', name)
+    namespaces.append(name)
+    cmd('ip', '-n', name, 'link', 'set', 'lo', 'up')
+    return name
+
+@contextlib.contextmanager
+def enter(name):
+    fd = os.open('/run/netns/'+name, os.O_RDONLY)
+    os.setns(fd, 0)
+    try:
+        yield
+    finally:
+        os.setns(original, 0)
+        os.close(fd)
+
+def sock(name, groups=(), allns=False, rcvbuf=4*1024*1024, protocol=0):
+    with enter(name):
+        s = socket.socket(socket.AF_NETLINK, socket.SOCK_RAW, protocol)
+        s.setsockopt(socket.SOL_SOCKET, socket.SO_RCVBUF, rcvbuf)
+        s.setsockopt(SOL_NETLINK, 3, 1)  # NETLINK_PKTINFO
+        if allns:
+            s.setsockopt(SOL_NETLINK, 8, 1)
+        s.bind((0, 0))
+        for group in groups:
+            s.setsockopt(SOL_NETLINK, 1, group)
+        s.setblocking(False)
+    sockets.append(s)
+    return s
+
+def messages(s, wait=0.025, allow_enobufs=False):
+    result, errors = [], []
+    while select.select([s], [], [], wait)[0]:
+        try:
+            data, ancillary, flags, address = s.recvmsg(262144, 512)
+        except OSError as e:
+            if e.errno == errno.ENOBUFS and allow_enobufs:
+                errors.append(e.errno)
+                continue
+            raise
+        assert not flags & (socket.MSG_TRUNC | socket.MSG_CTRUNC)
+        tags = {kind: struct.unpack('i', value[:4])[0]
+                for level, kind, value in ancillary if level == SOL_NETLINK}
+        offset = 0
+        while offset < len(data):
+            length, kind, nlflags, seq, pid = struct.unpack_from('IHHII', data, offset)
+            assert 16 <= length <= len(data)-offset
+            result.append(dict(type=kind, flags=nlflags, seq=seq,
+                               family=data[offset+16] if length > 16 else None,
+                               tags=tags, data=data[offset+16:offset+length]))
+            offset += (length+3) & ~3
+        assert offset == len(data)
+        wait = 0
+    return result, errors
+
+def clean():
+    # One settle interval per preparation boundary; idle sockets do not each
+    # add another interval. Expected notification reads still wait explicitly.
+    time.sleep(0.025)
+    for s in sockets:
+        if s.fileno() >= 0:
+            messages(s,wait=0)
+
+def record(name, **details):
+    cases.append(dict(name=name, passed=True, **details))
+    (out/'cases.json').write_text(json.dumps(cases, indent=2))
+    print(f'ok {len(cases)} - {name}', flush=True)
+    print('# '+json.dumps(cases[-1]), flush=True)
+
+def route(name, family=6):
+    dest = 'fdab:123::1/128' if family == 6 else '198.18.0.1/32'
+    cmd('ip', '-n', name, '-'+str(family), 'route', 'replace', dest, 'dev', 'lo')
+
+def expect(s, count, kind=24, family=10, cross=None, group=ROUTE6):
+    found, errors = messages(s)
+    chosen = [m for m in found if m['type'] == kind and m['family'] == family]
+    assert len(chosen) == count, (count, [(m['type'], m['family'],m['tags']) for m in found])
+    for m in chosen:
+        assert m['tags'].get(3) == group, m
+        assert m['tags'].get(8) == cross, m
+    return len(chosen)
+
+def nlmsg(kind, flags, seq, body):
+    return struct.pack('IHHII', 16+len(body), kind, flags, seq, 0)+body
+
+def attr(kind, body):
+    value = struct.pack('HH', len(body)+4, kind)+body
+    return value+b'\0'*((-len(value)) % 4)
+
+def slow_queue(tx, no_enobufs, broadcast_error=False):
+    slow = sock(tx, [ROUTE6], rcvbuf=4096)
+    slow.setsockopt(SOL_NETLINK, 5, int(no_enobufs))
+    slow.setsockopt(SOL_NETLINK, 4, int(broadcast_error))
+    sender = sock(tx)
+    request = b''
+    for i in range(200):
+        body = struct.pack('BBBBBBBBI', 10, 128, 0, 0, 254, 186, 0, 1, 0)
+        body += attr(1, socket.inet_pton(socket.AF_INET6, 'fdab:456::'+format(i+1,'x')))
+        body += attr(4, struct.pack('I', 1))
+        request += nlmsg(24, 1|4|0x100|0x400, i+1, body)
+    sender.sendto(request, (0, 0))
+    acks, errors = messages(sender, 1)
+    assert len(acks) == 200 and all(m['type']==2 and struct.unpack_from('i',m['data'])[0]==0 for m in acks)
+    delivered, overflows = messages(slow, allow_enobufs=True)
+    assert 0 < len(delivered) < 200
+    assert bool(overflows) == (not no_enobufs), (len(delivered),overflows)
+    slow.close(); sender.close()
+    return dict(acks=len(acks), delivered=len(delivered), enobufs=len(overflows))
+
+try:
+    tx, rx, nomap = ns('tx'), ns('rx'), ns('nomap')
+    cmd('ip', 'netns', 'exec', rx, 'ip', 'netns', 'set', tx, '71')
+    local = sock(tx, [ROUTE6])
+    local_all = sock(tx, [ROUTE6], allns=True)
+    wrong = sock(tx, [LINK])
+    multi = sock(tx, [ROUTE6, LINK])
+    foreign = sock(rx, [ROUTE6])
+    cross = sock(rx, [ROUTE6], allns=True)
+    unmapped = sock(nomap, [ROUTE6], allns=True)
+    clean(); route(tx)
+    assert [expect(s,n,cross=x) for s,n,x in
+            [(local,1,None),(local_all,1,None),(wrong,0,None),(multi,1,None),
+             (foreign,0,None),(cross,1,71),(unmapped,0,None)]] == [1,1,0,1,0,1,0]
+    record('local-group-multiple-sockets-multiple-groups-and-cross-nsid',
+           local=3, cross=1, cross_nsid=71, foreign_ordinary=0, missing_map=0,
+           local_all_nsid_duplicates=0)
+
+    high = sock(tx, [ROUTE6, 33, 34])
+    mask = high.getsockopt(SOL_NETLINK, 9, 128)
+    assert struct.unpack_from('=I', mask, 4)[0] & 2
+    clean(); route(tx); expect(high, 1)
+    high.close()
+    record('membership-above-32-and-matching-route-group')
+
+    # Toggle an already subscribed foreign socket, then last-membership removal.
+    for enabled in [0,1,0,1]:
+        cross.setsockopt(SOL_NETLINK, 8, enabled)
+        clean(); route(tx)
+        expect(cross,enabled,cross=71)
+    record('listen-all-nsid-toggle-after-subscription', transitions=[0,1,0,1])
+    cross.setsockopt(SOL_NETLINK, 2, ROUTE6)
+    clean(); route(tx); expect(cross,0)
+    cross.setsockopt(SOL_NETLINK, 1, ROUTE6)
+    clean(); route(tx); expect(cross,1,cross=71)
+    record('cross-last-drop-and-rejoin')
+
+    local.setsockopt(SOL_NETLINK, 2, ROUTE6)
+    clean(); route(tx); expect(local,0)
+    local.setsockopt(SOL_NETLINK, 1, LINK)
+    local.setsockopt(SOL_NETLINK, 1, ROUTE6)
+    local.setsockopt(SOL_NETLINK, 2, LINK)
+    clean(); route(tx); expect(local,1)
+    local.bind((local.getsockname()[0],0))
+    clean(); route(tx); expect(local,0)
+    local.bind((local.getsockname()[0],1<<(ROUTE6-1)))
+    clean(); route(tx); expect(local,1)
+    record('first-last-membership-rebind-and-multi-group-updates')
+
+    # Receive-side classic BPF filter remains applied by do_one_broadcast().
+    class Filter(ctypes.Structure):
+        _fields_=[('code',ctypes.c_ushort),('jt',ctypes.c_ubyte),('jf',ctypes.c_ubyte),('k',ctypes.c_uint)]
+    class Program(ctypes.Structure):
+        _fields_=[('len',ctypes.c_ushort),('filter',ctypes.POINTER(Filter))]
+    insn=Filter(6,0,0,0); prog=Program(1,ctypes.pointer(insn))
+    libc=ctypes.CDLL(None,use_errno=True)
+    assert libc.setsockopt(local.fileno(),socket.SOL_SOCKET,26,ctypes.byref(prog),ctypes.sizeof(prog))==0
+    clean(); route(tx); expect(local,0)
+    local.setsockopt(socket.SOL_SOCKET,27,0)
+    clean(); route(tx); expect(local,1)
+    record('socket-bpf-receive-filter')
+
+    # file_ns_capable() checks the credentials captured when the socket opened.
+    parent, child = socket.socketpair()
+    pid=os.fork()
+    if pid==0:
+        try:
+            parent.close()
+            class CapHeader(ctypes.Structure):
+                _fields_=[('version',ctypes.c_uint),('pid',ctypes.c_int)]
+            class CapData(ctypes.Structure):
+                _fields_=[('effective',ctypes.c_uint),('permitted',ctypes.c_uint),('inheritable',ctypes.c_uint)]
+            header=CapHeader(0x20080522,0); caps=(CapData*2)()
+            assert libc.capget(ctypes.byref(header),caps)==0
+            for f in ['effective','permitted','inheritable']:
+                setattr(caps[0],f,getattr(caps[0],f)&~(1<<11))
+            assert libc.capset(ctypes.byref(header),caps)==0
+            with enter(rx):
+                denied=socket.socket(socket.AF_NETLINK,socket.SOCK_RAW,0)
+                denied.bind((0,1<<(ROUTE6-1)))
+                try:
+                    denied.setsockopt(SOL_NETLINK,8,1)
+                except PermissionError:
+                    pass
+                else:
+                    raise AssertionError('unprivileged setsockopt unexpectedly succeeded')
+            child.sendmsg([b'fd'],[(socket.SOL_SOCKET,socket.SCM_RIGHTS,array.array('i',[denied.fileno()]))])
+            os._exit(0)
+        except BaseException:
+            import traceback
+            traceback.print_exc(); os._exit(1)
+    child.close()
+    data, anc, flags, addr=parent.recvmsg(16,socket.CMSG_SPACE(4))
+    assert os.waitpid(pid,0)[1]==0
+    fd=array.array('i'); fd.frombytes(anc[0][2][:4])
+    denied=socket.socket(fileno=fd[0]); denied.setblocking(False); sockets.append(denied)
+    denied.setsockopt(SOL_NETLINK,8,1)
+    clean(); route(tx); expect(denied,0); expect(cross,1,cross=71)
+    denied.close(); parent.close()
+    record('cross-namespace-capability-denied-and-set-option-denied')
+
+    ipv4=sock(tx,[ROUTE4]); clean(); route(tx,4)
+    expect(ipv4,1,family=2,group=ROUTE4); expect(local,0)
+    cmd('ip','-n',tx,'-4','route','del','198.18.0.1/32')
+    expect(ipv4,1,kind=25,family=2,group=ROUTE4)
+    clean(); cmd('ip','-n',tx,'-6','route','del','fdab:123::1/128')
+    expect(local,1,kind=25); expect(cross,1,kind=25,cross=71)
+    record('ipv4-ipv6-route-add-delete-and-family-group-filter')
+    link=sock(tx,[LINK]); a4=sock(tx,[ADDR4]); a6=sock(tx,[ADDR6]); nh=sock(tx,[NEXTHOP])
+    clean(); cmd('ip','-n',tx,'link','add','nl-dummy','type','dummy')
+    expect(link,1,kind=16,family=0,group=LINK)
+    cmd('ip','-n',tx,'link','set','nl-dummy','up'); clean()
+    cmd('ip','-n',tx,'addr','add','198.19.0.1/24','dev','nl-dummy')
+    expect(a4,1,kind=20,family=2,group=ADDR4)
+    cmd('ip','-n',tx,'-6','addr','add','fdab:999::1/64','dev','nl-dummy','nodad')
+    expect(a6,1,kind=20,family=10,group=ADDR6)
+    clean(); cmd('ip','-n',tx,'-6','nexthop','add','id','101','dev','lo')
+    expect(nh,1,kind=104,family=10,group=NEXTHOP)
+    cmd('ip','-n',tx,'nexthop','del','id','101')
+    expect(nh,1,kind=105,family=10,group=NEXTHOP)
+    clean(); cmd('ip','-n',tx,'addr','del','198.19.0.1/24','dev','nl-dummy')
+    expect(a4,1,kind=21,family=2,group=ADDR4)
+    clean(); cmd('ip','-n',tx,'-6','addr','del','fdab:999::1/64','dev','nl-dummy')
+    expect(a6,1,kind=21,family=10,group=ADDR6)
+    clean(); cmd('ip','-n',tx,'link','del','nl-dummy')
+    expect(link,1,kind=17,family=0,group=LINK)
+    record('link-address-ipv4-ipv6-and-nexthop-add-delete')
+
+    route(tx)
+    sender=sock(tx)
+    sender.sendto(nlmsg(26,1|0x300,100,bytes([10])+b'\0'*11),(0,0))
+    dump,errs=messages(sender,1)
+    assert dump and dump[-1]['type']==3 and all(m['seq']==100 for m in dump)
+    assert any(m['type']==24 for m in dump)
+    bad=struct.pack('BBBBBBBBI',10,129,0,0,254,186,0,1,0)
+    sender.sendto(nlmsg(24,1|4|0x400|0x100,101,bad),(0,0))
+    ack,errs=messages(sender,1)
+    assert len(ack)==1 and ack[0]['type']==2 and ack[0]['seq']==101
+    code=struct.unpack_from('i',ack[0]['data'])[0]
+    assert code==-errno.EINVAL,code
+    record('unicast-route-dump-and-invalid-request-error-ack',error=code)
+
+    # Change candidate population without changing the true recipients.
+    # Extra sockets use LINK and carry no IPv6-route data.
+    pool=[]
+    transitions=[]
+    for target in (0,48,64,80,128,64,48,0):
+        while len(pool)<target:
+            pool.append(sock(nomap,[LINK]))
+        while len(pool)>target:
+            pool.pop().close()
+        clean(); route(tx)
+        expect(local,1); expect(local_all,1); expect(cross,1,cross=71)
+        if target:
+            # Toggle cross-netns membership while true route recipients stay fixed.
+            for enabled in (1,0):
+                for extra in pool: extra.setsockopt(SOL_NETLINK,8,enabled)
+                clean(); route(tx)
+                expect(local,1); expect(local_all,1); expect(cross,1,cross=71)
+        transitions.append(target)
+    record('candidate-population-transitions-no-missing-or-duplicate',sizes=transitions)
+    # A mapped OVS-style listener must still receive LINK/ADDR on indexed path.
+    ovs=sock(rx,[1,5,9,12],allns=True)
+    field_pool=[sock(nomap,[LINK]) for _ in range(128)]
+    clean(); cmd('ip','-n',tx,'link','add','nlg-ovs','type','dummy')
+    expect(ovs,1,kind=16,family=0,group=LINK,cross=71)
+    cmd('ip','-n',tx,'link','set','nlg-ovs','up'); clean()
+    cmd('ip','-n',tx,'addr','add','198.20.1.1/32','dev','nlg-ovs')
+    expect(ovs,1,kind=20,family=2,group=ADDR4,cross=71)
+    clean(); cmd('ip','-n',tx,'-6','addr','add','fdaa:908::1/128','dev','nlg-ovs','nodad')
+    expect(ovs,1,kind=20,family=10,group=ADDR6,cross=71)
+    clean(); cmd('ip','-n',tx,'link','del','nlg-ovs'); clean()
+    for extra in field_pool: extra.close()
+    ovs.close()
+    record('mapped-ovs-style-link-address-notifications-with-128-foreign')
+
+    probe=sock(tx,allns=True)
+    # Unsubscribed option changes, duplicate joins, partial/last drops and rebind.
+    for enabled in (0,1,0,1): probe.setsockopt(SOL_NETLINK,8,enabled)
+    for group in (ROUTE6,ROUTE6,LINK): probe.setsockopt(SOL_NETLINK,1,group)
+    clean(); route(tx); expect(probe,1)
+    probe.setsockopt(SOL_NETLINK,2,LINK)
+    clean(); route(tx); expect(probe,1)
+    probe.setsockopt(SOL_NETLINK,2,ROUTE6)
+    clean(); route(tx); expect(probe,0)
+    for _ in range(2): probe.bind((probe.getsockname()[0],1<<(ROUTE6-1)))
+    clean(); route(tx); expect(probe,1)
+    probe.close()
+    record('duplicate-and-partial-membership-transitions')
+    for compat in (0,1):
+        cmd('ip','netns','exec',tx,'sysctl','-qw',f'net.ipv4.nexthop_compat_mode={compat}')
+        cmd('ip','-n',tx,'-6','nexthop','add','id','200','dev','lo')
+        cmd('ip','-n',tx,'-6','route','add','fdab:888::1/128','nhid','200')
+        clean()
+        cmd('ip','-n',tx,'-6','nexthop','replace','id','200','blackhole')
+        expect(local,compat); expect(cross,compat,cross=71)
+        clean(); cmd('ip','-n',tx,'nexthop','del','id','200')
+        expect(local,compat,kind=25); expect(cross,compat,kind=25,cross=71)
+        record('nexthop-reference-compat-'+str(compat),route_change_notifications=compat,route_delete_notifications=compat)
+
+    # Close regular listeners before deliberately flooding a small queue.
+    for s in sockets:
+        s.close()
+    record('slow-reader-default-enobufs',**slow_queue(tx,False))
+    record('slow-reader-no-enobufs-option',**slow_queue(tx,True))
+    record('slow-reader-broadcast-error-option-keeps-success-acks',**slow_queue(tx,False,True))
+
+    sink=sock(tx,protocol=2)
+    user_local=sock(tx,[1],protocol=2)
+    user_foreign=sock(rx,[1],protocol=2)
+    user_cross=sock(rx,[1],allns=True,protocol=2)
+    user_sender=sock(tx,protocol=2)
+    payload=nlmsg(42,0,900,b'\0usersock-regression')
+    assert user_sender.sendto(payload,(sink.getsockname()[0],1))==len(payload)
+    expect(user_local,1,kind=42,family=0,group=1)
+    expect(user_foreign,0,kind=42,family=0,group=1)
+    expect(user_cross,1,kind=42,family=0,group=1,cross=71)
+    unicast, errs = messages(sink)
+    assert len(unicast) == 1 and unicast[0]['type'] == 42
+    assert unicast[0]['data'] == payload[16:]
+    record('usersock-multicast-local-cross-and-unicast-unchanged')
+
+    # Generic-netlink control query and SOCK_DIAG dump use untouched protocols.
+    with enter(tx):
+        generic=socket.socket(socket.AF_NETLINK,socket.SOCK_RAW,16)
+        generic.bind((0,0)); generic.setblocking(False); sockets.append(generic)
+        generic.sendto(nlmsg(16,1|4,701,struct.pack('BBH',3,1,0)+attr(2,b'nlctrl\0')),(0,0))
+        g,errs=messages(generic,1)
+        assert any(m['type']==16 and m['seq']==701 for m in g)
+        diag=socket.socket(socket.AF_NETLINK,socket.SOCK_RAW,4)
+        diag.bind((0,0)); diag.setblocking(False); sockets.append(diag)
+        # netlink_diag_req is 20 bytes: family/protocol/pad, inode/show/cookie[2].
+        req=struct.pack('BBHIIII',socket.AF_NETLINK,0,0,0,1|8,0xffffffff,0xffffffff)
+        diag.sendto(nlmsg(20,1|0x300,702,req),(0,0))
+        d,errs=messages(diag,1)
+        assert d and d[-1]['type']==3 and any(m['type']==20 for m in d)
+    record('generic-netlink-and-sock-diag',generic_reply=True,diag_records=sum(m['type']==20 for m in d))
+    record('proc-netlink-visible',lines=len(Path('/proc/net/netlink').read_text().splitlines()))
+    print(f'1..{len(cases)}', flush=True)
+    (out/'complete.json').write_text(json.dumps(dict(success=True,kernel=os.uname().release,
+        boot_id=Path('/proc/sys/kernel/random/boot_id').read_text().strip(),cases=len(cases)),indent=2))
+finally:
+    for s in sockets:
+        s.close()
+    os.setns(original,0); os.close(original)
+    for name in reversed(namespaces):
+        sp.run(['ip','netns','del',name],check=False,stdout=sp.DEVNULL,stderr=sp.DEVNULL)
diff --git a/tools/testing/selftests/net/netlink_mcast_switch.py b/tools/testing/selftests/net/netlink_mcast_switch.py
new file mode 100755
index 000000000..5bf9f5f1d
--- /dev/null
+++ b/tools/testing/selftests/net/netlink_mcast_switch.py
@@ -0,0 +1,217 @@
+#!/usr/bin/env python3
+# SPDX-License-Identifier: GPL-2.0-only
+"""NETLINK_ROUTE live-switch semantics; no tracing dependency."""
+import contextlib
+import ctypes
+import errno
+import json
+import os
+from pathlib import Path
+import select
+import socket
+import struct
+import subprocess
+import threading
+import time
+import argparse
+import tempfile
+import shutil
+import sys
+
+p = argparse.ArgumentParser()
+p.add_argument('--output', type=Path)
+a = p.parse_args()
+if os.geteuid() != 0 or not shutil.which('ip') or not hasattr(os, 'setns'):
+    print('1..0 # SKIP requires root, iproute2 and Python os.setns')
+    sys.exit(4)
+control = Path('/proc/sys/net/core/netlink_route_mc_index')
+if not control.exists():
+    print('1..0 # SKIP kernel has no netlink_route_mc_index sysctl')
+    sys.exit(4)
+root = a.output or Path(tempfile.mkdtemp(prefix='netlink-switch-'))
+if a.output:
+    root.mkdir(exist_ok=False, parents=True)
+saved_mode = control.read_text()
+print('TAP version 13', flush=True)
+original = os.open("/proc/self/ns/net", os.O_RDONLY)
+# Probe namespace creation before beginning behavioural assertions.
+probe_lib = ctypes.CDLL(None, use_errno=True)
+if probe_lib.unshare(0x40000000):
+    probe_errno = ctypes.get_errno()
+    os.close(original)
+    if probe_errno in (errno.EPERM, errno.EINVAL, errno.ENOSYS):
+        print('1..0 # SKIP cannot create a network namespace')
+        sys.exit(4)
+    raise OSError(probe_errno, os.strerror(probe_errno))
+os.setns(original, 0)
+
+namespaces, sockets, checks = [], [], []
+sequence = 0
+
+
+def command(*args):
+    return subprocess.check_output(args, text=True, stderr=subprocess.STDOUT,
+                                   timeout=20).strip()
+
+
+def record(name, **details):
+    checks.append(dict(name=name, passed=True, **details))
+    print(f'ok {len(checks)} - {name}', flush=True)
+    print('# '+json.dumps(checks[-1]), flush=True)
+
+
+def namespace(suffix):
+    name = f"nlsw-{os.getpid()}-" + suffix
+    command("ip", "netns", "add", name)
+    namespaces.append(name)
+    command("ip", "-n", name, "link", "set", "lo", "up")
+    return name
+
+
+@contextlib.contextmanager
+def enter(name):
+    fd = os.open("/run/netns/" + name, os.O_RDONLY)
+    os.setns(fd, 0)
+    try:
+        yield
+    finally:
+        os.setns(original, 0)
+        os.close(fd)
+
+
+def subscriber(name, allns=False):
+    with enter(name):
+        sk = socket.socket(socket.AF_NETLINK, socket.SOCK_RAW, 0)
+        sk.setsockopt(270, 8, int(allns))
+        sk.bind((0, 1 << 10))  # RTNLGRP_IPV6_ROUTE = 11
+        sk.setblocking(False)
+    sockets.append(sk)
+    return sk
+
+
+def mode(value):
+    control.write_text(str(value) + "\n")
+    assert int(control.read_text()) == value
+
+
+def drain(sk):
+    found = []
+    while select.select([sk], [], [], 0)[0]:
+        data = sk.recv(262144)
+        offset = 0
+        while offset < len(data):
+            length, kind, flags, seq, pid = struct.unpack_from("IHHII", data, offset)
+            assert 16 <= length <= len(data) - offset
+            found.append((kind, data[offset + 16:offset + length]))
+            offset += (length + 3) & ~3
+        assert offset == len(data)
+    return found
+
+
+def notify(expected, selected=None):
+    global sequence
+    sequence += 1
+    for sk in sockets:
+        if sk.fileno() >= 0:
+            drain(sk)
+    command("ip", "-n", tx, "-6", "route", "add",
+            f"fdab:abcd::{sequence:x}/128", "dev", "lo")
+    for sk, count in expected.items():
+        messages = [m for m in drain(sk) if m[0] == 24 and m[1][0] == 10]
+        assert len(messages) == count, (sequence, sk.fileno(), count, len(messages))
+    return None
+
+
+try:
+    mode(0)
+    for bad in ("-1\n", "2\n", "garbage\n"):
+        try:
+            control.write_text(bad)
+        except OSError as error:
+            assert error.errno == errno.EINVAL, error
+        else:
+            raise AssertionError("invalid value accepted: " + bad)
+        assert control.read_text().strip() == "0"
+    record("disabled-setting-and-invalid-values-rejected")
+
+    tx, monitor, unmapped = [namespace(n) for n in ("tx", "monitor", "unmapped")]
+    with enter(tx):
+        assert not control.exists(), "global control exposed in child netns"
+    record("control-only-visible-in-initial-netns")
+    command("ip", "-n", monitor, "netns", "set", tx, "71")
+    local = subscriber(tx)
+    local_all = subscriber(tx, True)
+    ordinary = subscriber(monitor)
+    cross = subscriber(monitor, True)
+    no_map = subscriber(unmapped, True)
+    expected = {local: 1, local_all: 1, ordinary: 0, cross: 1, no_map: 0}
+
+    paths = []
+    for value in (0, 1, 0, 1):
+        mode(value)
+        paths.append(dict(mode=value, receive_check=notify(expected)))
+    record("live-switch-with-existing-local-and-cross-sockets", paths=paths)
+
+    mode(0)
+    late_local = subscriber(tx)
+    late_cross = subscriber(monitor, True)
+    local.setsockopt(270, 2, 11)
+    cross.setsockopt(270, 8, 0)
+    subscriber(tx).close()
+    subscriber(monitor, True).close()
+    mode(1)
+    changed = {**expected, local: 0, cross: 0, late_local: 1, late_cross: 1}
+    notify(changed)
+    mode(0)
+    local.setsockopt(270, 1, 11)
+    cross.setsockopt(270, 8, 1)
+    mode(1)
+    expected.update({late_local: 1, late_cross: 1})
+    notify(expected)
+    record("indexes-maintained-while-off-for-join-drop-option-and-close")
+
+    mode(0)
+    pool = [subscriber(unmapped, True) for _ in range(80)]
+    mode(1)
+    notify({**expected, **{sk: 0 for sk in pool}})
+    for sk in pool:
+        sk.close()
+    record("enabled-forces-index-despite-large-cross-list")
+
+    stop, started = threading.Event(), threading.Event()
+    updates, errors = [0], []
+
+    def toggle():
+        try:
+            while not stop.is_set():
+                mode(updates[0] % 2)
+                updates[0] += 1
+                started.set()
+                time.sleep(0.001)
+        except BaseException as error:
+            errors.append(repr(error))
+
+    worker = threading.Thread(target=toggle)
+    worker.start()
+    assert started.wait(5)
+    try:
+        for _ in range(40):
+            notify(expected)
+    finally:
+        stop.set()
+        worker.join(5)
+    assert not worker.is_alive() and not errors, errors
+    assert updates[0] >= 2
+    record("concurrent-switch-no-missing-or-duplicate", notifications=40,
+           switch_writes=updates[0])
+    print(f'1..{len(checks)}', flush=True)
+    (root / "switch-test.json").write_text(json.dumps(checks, indent=2) + "\n")
+finally:
+    if control.exists():
+        control.write_text(saved_mode)
+    for sk in sockets:
+        sk.close()
+    os.setns(original, 0)
+    os.close(original)
+    for name in reversed(namespaces):
+        subprocess.run(["ip", "netns", "del", name], check=True)

