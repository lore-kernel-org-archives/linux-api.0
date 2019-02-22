From: Lorenz Bauer <lmb@cloudflare.com>
Subject: [PATCH 3/3] selftests/bpf: add tests for bpf_sk_check_syncookie
Date: Fri, 22 Feb 2019 09:50:57 +0000
Message-ID: <20190222095057.9442-4-lmb@cloudflare.com>
References: <20190222095057.9442-1-lmb@cloudflare.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190222095057.9442-1-lmb@cloudflare.com>
Sender: netdev-owner@vger.kernel.org
To: ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org
Cc: linux-api@vger.kernel.org, Lorenz Bauer <lmb@cloudflare.com>
List-Id: linux-api@vger.kernel.org

Add tests which verify that the new helper works for both IPv4 and
IPv6, by forcing SYN cookies to always on. Use a new network namespace
to avoid clobbering the global SYN cookie settings.

Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>
---
 tools/testing/selftests/bpf/.gitignore        |   1 +
 tools/testing/selftests/bpf/Makefile          |   5 +-
 tools/testing/selftests/bpf/bpf_helpers.h     |   3 +
 .../bpf/progs/test_sk_syncookie_kern.c        | 119 ++++++++++
 .../selftests/bpf/test_sk_syncookie.sh        |  81 +++++++
 .../selftests/bpf/test_sk_syncookie_user.c    | 212 ++++++++++++++++++
 6 files changed, 419 insertions(+), 2 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/progs/test_sk_syncookie_kern.c
 create mode 100755 tools/testing/selftests/bpf/test_sk_syncookie.sh
 create mode 100644 tools/testing/selftests/bpf/test_sk_syncookie_user.c

diff --git a/tools/testing/selftests/bpf/.gitignore b/tools/testing/selftests/bpf/.gitignore
index e47168d1257d..44b2853b8534 100644
--- a/tools/testing/selftests/bpf/.gitignore
+++ b/tools/testing/selftests/bpf/.gitignore
@@ -29,4 +29,5 @@ test_netcnt
 test_section_names
 test_tcpnotify_user
 test_libbpf
+test_sk_syncookie_user
 alu32
diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
index ccffaa0a0787..4ad1f7a915b3 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -51,7 +51,8 @@ TEST_PROGS := test_kmod.sh \
 	test_skb_cgroup_id.sh \
 	test_flow_dissector.sh \
 	test_xdp_vlan.sh \
-	test_lwt_ip_encap.sh
+	test_lwt_ip_encap.sh \
+	test_sk_syncookie.sh
 
 TEST_PROGS_EXTENDED := with_addr.sh \
 	with_tunnels.sh \
@@ -60,7 +61,7 @@ TEST_PROGS_EXTENDED := with_addr.sh \
 
 # Compile but not part of 'make run_tests'
 TEST_GEN_PROGS_EXTENDED = test_libbpf_open test_sock_addr test_skb_cgroup_id_user \
-	flow_dissector_load test_flow_dissector
+	flow_dissector_load test_flow_dissector test_sk_syncookie_user
 
 include ../lib.mk
 
diff --git a/tools/testing/selftests/bpf/bpf_helpers.h b/tools/testing/selftests/bpf/bpf_helpers.h
index d9999f1ed1d2..b80cec7af445 100644
--- a/tools/testing/selftests/bpf/bpf_helpers.h
+++ b/tools/testing/selftests/bpf/bpf_helpers.h
@@ -166,6 +166,9 @@ static struct bpf_sock *(*bpf_sk_lookup_udp)(void *ctx,
 	(void *) BPF_FUNC_sk_lookup_udp;
 static int (*bpf_sk_release)(struct bpf_sock *sk) =
 	(void *) BPF_FUNC_sk_release;
+static int (*bpf_sk_check_syncookie)(struct bpf_sock *sk,
+	    void *ip, int ip_len, void *tcp, int tcp_len) =
+	(void *) BPF_FUNC_sk_check_syncookie;
 static int (*bpf_skb_vlan_push)(void *ctx, __be16 vlan_proto, __u16 vlan_tci) =
 	(void *) BPF_FUNC_skb_vlan_push;
 static int (*bpf_skb_vlan_pop)(void *ctx) =
diff --git a/tools/testing/selftests/bpf/progs/test_sk_syncookie_kern.c b/tools/testing/selftests/bpf/progs/test_sk_syncookie_kern.c
new file mode 100644
index 000000000000..4918457efc1e
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/test_sk_syncookie_kern.c
@@ -0,0 +1,119 @@
+// SPDX-License-Identifier: GPL-2.0
+// Copyright (c) 2018 Facebook
+// Copyright (c) 2019 Cloudflare
+
+#include <string.h>
+
+#include <linux/bpf.h>
+#include <linux/pkt_cls.h>
+#include <linux/if_ether.h>
+#include <linux/in.h>
+#include <linux/ip.h>
+#include <linux/ipv6.h>
+#include <sys/socket.h>
+#include <linux/tcp.h>
+
+#include "bpf_helpers.h"
+#include "bpf_endian.h"
+
+struct bpf_map_def SEC("maps") results = {
+	.type = BPF_MAP_TYPE_ARRAY,
+	.key_size = sizeof(__u32),
+	.value_size = sizeof(__u64),
+	.max_entries = 1,
+};
+
+static __always_inline void check_syncookie(void *ctx, void *data,
+					    void *data_end)
+{
+	struct bpf_sock_tuple tup;
+	struct bpf_sock *sk;
+	struct ethhdr *ethh;
+	struct iphdr *ipv4h;
+	struct ipv6hdr *ipv6h;
+	struct tcphdr *tcph;
+	int ret;
+	__u32 key = 0;
+	__u64 value = 1;
+
+	ethh = data;
+	if (ethh + 1 > data_end)
+		return;
+
+	switch (bpf_ntohs(ethh->h_proto)) {
+	case ETH_P_IP:
+		ipv4h = data + sizeof(struct ethhdr);
+		if (ipv4h + 1 > data_end)
+			return;
+
+		tcph = data + sizeof(struct ethhdr) + sizeof(struct iphdr);
+		if (tcph + 1 > data_end)
+			return;
+
+		tup.ipv4.saddr = ipv4h->saddr;
+		tup.ipv4.daddr = ipv4h->daddr;
+		tup.ipv4.sport = tcph->source;
+		tup.ipv4.dport = tcph->dest;
+
+		sk = bpf_sk_lookup_tcp(ctx, &tup, sizeof(tup.ipv4),
+				       BPF_F_CURRENT_NETNS, 0);
+		if (!sk)
+			return;
+
+		ret = bpf_sk_check_syncookie(sk, ipv4h, sizeof(*ipv4h),
+					     tcph, sizeof(*tcph));
+		break;
+
+	case ETH_P_IPV6:
+		ipv6h = data + sizeof(struct ethhdr);
+		if (ipv6h + 1 > data_end)
+			return;
+
+		if (ipv6h->nexthdr != IPPROTO_TCP)
+			return;
+
+		tcph = data + sizeof(struct ethhdr) + sizeof(struct ipv6hdr);
+		if (tcph + 1 > data_end)
+			return;
+
+		memcpy(tup.ipv6.saddr, &ipv6h->saddr, sizeof(tup.ipv6.saddr));
+		memcpy(tup.ipv6.daddr, &ipv6h->daddr, sizeof(tup.ipv6.daddr));
+		tup.ipv6.sport = tcph->source;
+		tup.ipv6.dport = tcph->dest;
+
+		sk = bpf_sk_lookup_tcp(ctx, &tup, sizeof(tup.ipv6),
+				       BPF_F_CURRENT_NETNS, 0);
+		if (!sk)
+			return;
+
+		ret = bpf_sk_check_syncookie(sk, ipv6h, sizeof(*ipv6h),
+					     tcph, sizeof(*tcph));
+		break;
+
+	default:
+		return;
+	}
+
+	if (ret == 0)
+		bpf_map_update_elem(&results, &key, &value, 0);
+
+	bpf_sk_release(sk);
+}
+
+SEC("clsact/check_syncookie")
+int check_syncookie_clsact(struct __sk_buff *skb)
+{
+	check_syncookie(skb, (void *)(long)skb->data,
+			(void *)(long)skb->data_end);
+	return TC_ACT_OK;
+}
+
+SEC("xdp/check_syncookie")
+int check_syncookie_xdp(struct xdp_md *ctx)
+{
+	check_syncookie(ctx, (void *)(long)ctx->data,
+			(void *)(long)ctx->data_end);
+	return XDP_PASS;
+}
+
+char _license[] SEC("license") = "GPL";
diff --git a/tools/testing/selftests/bpf/test_sk_syncookie.sh b/tools/testing/selftests/bpf/test_sk_syncookie.sh
new file mode 100755
index 000000000000..429ca8c04c5e
--- /dev/null
+++ b/tools/testing/selftests/bpf/test_sk_syncookie.sh
@@ -0,0 +1,81 @@
+#!/bin/sh
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2018 Facebook
+# Copyright (c) 2019 Cloudflare
+
+set -eu
+
+wait_for_ip()
+{
+	local _i
+	printf "Wait for IP %s to become available " "$1"
+	for _i in $(seq ${MAX_PING_TRIES}); do
+		printf "."
+		if ns1_exec ping -c 1 -W 1 "$1" >/dev/null 2>&1; then
+			echo " OK"
+			return
+		fi
+		sleep 1
+	done
+	echo 1>&2 "ERROR: Timeout waiting for test IP to become available."
+	exit 1
+}
+
+get_prog_id()
+{
+	awk '/ id / {sub(/.* id /, "", $0); print($1)}'
+}
+
+ns1_exec()
+{
+	ip netns exec ns1 "$@"
+}
+
+setup()
+{
+	ip netns add ns1
+	ns1_exec ip link set lo up
+
+	ns1_exec sysctl -w net.ipv4.tcp_syncookies=2
+
+	wait_for_ip 127.0.0.1
+	wait_for_ip ::1
+}
+
+cleanup()
+{
+	ip netns del ns1 2>/dev/null || :
+}
+
+main()
+{
+	trap cleanup EXIT 2 3 6 15
+	setup
+
+	printf "Testing clsact..."
+	ns1_exec tc qdisc add dev "${TEST_IF}" clsact
+	ns1_exec tc filter add dev "${TEST_IF}" ingress \
+		bpf obj "${BPF_PROG_OBJ}" sec "${CLSACT_SECTION}" da
+
+	BPF_PROG_ID=$(ns1_exec tc filter show dev "${TEST_IF}" ingress | \
+		      get_prog_id)
+	ns1_exec "${PROG}" "${BPF_PROG_ID}"
+	ns1_exec tc qdisc del dev "${TEST_IF}" clsact
+
+	printf "Testing XDP..."
+	ns1_exec ip link set "${TEST_IF}" xdp \
+		object "${BPF_PROG_OBJ}" section "${XDP_SECTION}"
+	BPF_PROG_ID=$(ns1_exec ip link show "${TEST_IF}" | get_prog_id)
+	ns1_exec "${PROG}" "${BPF_PROG_ID}"
+}
+
+DIR=$(dirname $0)
+TEST_IF=lo
+MAX_PING_TRIES=5
+BPF_PROG_OBJ="${DIR}/test_sk_syncookie_kern.o"
+CLSACT_SECTION="clsact/check_syncookie"
+XDP_SECTION="xdp/check_syncookie"
+BPF_PROG_ID=0
+PROG="${DIR}/test_sk_syncookie_user"
+
+main
diff --git a/tools/testing/selftests/bpf/test_sk_syncookie_user.c b/tools/testing/selftests/bpf/test_sk_syncookie_user.c
new file mode 100644
index 000000000000..87829c86c746
--- /dev/null
+++ b/tools/testing/selftests/bpf/test_sk_syncookie_user.c
@@ -0,0 +1,212 @@
+// SPDX-License-Identifier: GPL-2.0
+// Copyright (c) 2018 Facebook
+// Copyright (c) 2019 Cloudflare
+
+#include <string.h>
+#include <stdlib.h>
+#include <unistd.h>
+
+#include <arpa/inet.h>
+#include <netinet/in.h>
+#include <sys/types.h>
+#include <sys/socket.h>
+
+#include <bpf/bpf.h>
+#include <bpf/libbpf.h>
+
+#include "bpf_rlimit.h"
+#include "cgroup_helpers.h"
+
+static int start_server(const struct sockaddr *addr, socklen_t len)
+{
+	int fd;
+
+	fd = socket(addr->sa_family, SOCK_STREAM, 0);
+	if (fd == -1) {
+		log_err("Failed to create server socket");
+		goto out;
+	}
+
+	if (bind(fd, addr, len) == -1) {
+		log_err("Failed to bind server socket");
+		goto close_out;
+	}
+
+	if (listen(fd, 128) == -1) {
+		log_err("Failed to listen on server socket");
+		goto close_out;
+	}
+
+	goto out;
+
+close_out:
+	close(fd);
+	fd = -1;
+out:
+	return fd;
+}
+
+static int connect_to_server(int server_fd)
+{
+	struct sockaddr_storage addr;
+	socklen_t len = sizeof(addr);
+	int fd = -1;
+
+	if (getsockname(server_fd, (struct sockaddr *)&addr, &len)) {
+		log_err("Failed to get server addr");
+		goto out;
+	}
+
+	fd = socket(addr.ss_family, SOCK_STREAM, 0);
+	if (fd == -1) {
+		log_err("Failed to create client socket");
+		goto out;
+	}
+
+	if (connect(fd, (const struct sockaddr *)&addr, len) == -1) {
+		log_err("Fail to connect to server");
+		goto close_out;
+	}
+
+	goto out;
+
+close_out:
+	close(fd);
+	fd = -1;
+out:
+	return fd;
+}
+
+static int get_map_fd_by_prog_id(int prog_id)
+{
+	struct bpf_prog_info info = {};
+	__u32 info_len = sizeof(info);
+	__u32 map_ids[1];
+	int prog_fd = -1;
+	int map_fd = -1;
+
+	prog_fd = bpf_prog_get_fd_by_id(prog_id);
+	if (prog_fd < 0) {
+		log_err("Failed to get fd by prog id %d", prog_id);
+		goto err;
+	}
+
+	info.nr_map_ids = 1;
+	info.map_ids = (__u64)(unsigned long)map_ids;
+
+	if (bpf_obj_get_info_by_fd(prog_fd, &info, &info_len)) {
+		log_err("Failed to get info by prog fd %d", prog_fd);
+		goto err;
+	}
+
+	if (!info.nr_map_ids) {
+		log_err("No maps found for prog fd %d", prog_fd);
+		goto err;
+	}
+
+	map_fd = bpf_map_get_fd_by_id(map_ids[0]);
+	if (map_fd < 0)
+		log_err("Failed to get fd by map id %d", map_ids[0]);
+err:
+	if (prog_fd >= 0)
+		close(prog_fd);
+	return map_fd;
+}
+
+static int run_test(int server_fd, int results_fd)
+{
+	int client = -1, srv_client = -1;
+	int ret = 0;
+	__u32 key = 0;
+	__u64 value = 0;
+
+	if (bpf_map_update_elem(results_fd, &key, &value, 0) < 0) {
+		log_err("Can't clear results");
+		goto err;
+	}
+
+	client = connect_to_server(server_fd);
+	if (client == -1)
+		goto err;
+
+	srv_client = accept(server_fd, NULL, 0);
+	if (srv_client == -1) {
+		log_err("Can't accept connection");
+		goto err;
+	}
+
+	if (bpf_map_lookup_elem(results_fd, &key, &value) < 0) {
+		log_err("Can't lookup result");
+		goto err;
+	}
+
+	if (value != 1) {
+		log_err("Didn't match syncookie: %llu", value);
+		goto err;
+	}
+
+	goto out;
+
+err:
+	ret = 1;
+out:
+	close(client);
+	close(srv_client);
+	return ret;
+}
+
+int main(int argc, char **argv)
+{
+	struct sockaddr_in addr4;
+	struct sockaddr_in6 addr6;
+	int server = -1;
+	int server_v6 = -1;
+	int results = -1;
+	int err = 0;
+
+	if (argc < 2) {
+		fprintf(stderr, "Usage: %s prog_id\n", argv[0]);
+		exit(1);
+	}
+
+	results = get_map_fd_by_prog_id(atoi(argv[1]));
+	if (results < 0) {
+		log_err("Can't get map");
+		goto err;
+	}
+
+	memset(&addr4, 0, sizeof(addr4));
+	addr4.sin_family = AF_INET;
+	addr4.sin_addr.s_addr = htonl(INADDR_LOOPBACK);
+	addr4.sin_port = 0;
+
+	memset(&addr6, 0, sizeof(addr6));
+	addr6.sin6_family = AF_INET6;
+	addr6.sin6_addr = in6addr_loopback;
+	addr6.sin6_port = 0;
+
+	server = start_server((const struct sockaddr *)&addr4, sizeof(addr4));
+	if (server == -1)
+		goto err;
+
+	server_v6 = start_server((const struct sockaddr *)&addr6,
+				 sizeof(addr6));
+	if (server_v6 == -1)
+		goto err;
+
+	if (run_test(server, results))
+		goto err;
+
+	if (run_test(server_v6, results))
+		goto err;
+
+	printf("ok\n");
+	goto out;
+err:
+	err = 1;
+out:
+	close(server);
+	close(server_v6);
+	close(results);
+	return err;
+}
-- 
2.19.1
