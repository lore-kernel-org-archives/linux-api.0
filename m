From: Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org>
Subject: [PATCH 24/98] rds.h: use __u8, __u16, __s16, __u32 and __s64 from linux/types.h
Date: Sat, 30 May 2015 17:38:16 +0200
Message-ID: <1433000370-19509-25-git-send-email-mikko.rapeli@iki.fi>
References: <1433000370-19509-1-git-send-email-mikko.rapeli@iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1433000370-19509-1-git-send-email-mikko.rapeli-X3B1VOXEql0@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

=46ixes userspace compilation errors like:

linux/rds.h:96:2: error: unknown type name =E2=80=98uint8_t=E2=80=99

Signed-off-by: Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org>
---
 include/uapi/linux/rds.h | 102 +++++++++++++++++++++++----------------=
--------
 1 file changed, 51 insertions(+), 51 deletions(-)

diff --git a/include/uapi/linux/rds.h b/include/uapi/linux/rds.h
index 9195095..0f0da42 100644
--- a/include/uapi/linux/rds.h
+++ b/include/uapi/linux/rds.h
@@ -93,8 +93,8 @@
 #define RDS_INFO_LAST			10010
=20
 struct rds_info_counter {
-	uint8_t	name[32];
-	uint64_t	value;
+	__u8	name[32];
+	__u64	value;
 } __attribute__((packed));
=20
 #define RDS_INFO_CONNECTION_FLAG_SENDING	0x01
@@ -104,35 +104,35 @@ struct rds_info_counter {
 #define TRANSNAMSIZ	16
=20
 struct rds_info_connection {
-	uint64_t	next_tx_seq;
-	uint64_t	next_rx_seq;
+	__u64	next_tx_seq;
+	__u64	next_rx_seq;
 	__be32		laddr;
 	__be32		faddr;
-	uint8_t	transport[TRANSNAMSIZ];		/* null term ascii */
-	uint8_t	flags;
+	__u8	transport[TRANSNAMSIZ];		/* null term ascii */
+	__u8	flags;
 } __attribute__((packed));
=20
 #define RDS_INFO_MESSAGE_FLAG_ACK               0x01
 #define RDS_INFO_MESSAGE_FLAG_FAST_ACK          0x02
=20
 struct rds_info_message {
-	uint64_t	seq;
-	uint32_t	len;
+	__u64	seq;
+	__u32	len;
 	__be32		laddr;
 	__be32		faddr;
 	__be16		lport;
 	__be16		fport;
-	uint8_t	flags;
+	__u8	flags;
 } __attribute__((packed));
=20
 struct rds_info_socket {
-	uint32_t	sndbuf;
+	__u32	sndbuf;
 	__be32		bound_addr;
 	__be32		connected_addr;
 	__be16		bound_port;
 	__be16		connected_port;
-	uint32_t	rcvbuf;
-	uint64_t	inum;
+	__u32	rcvbuf;
+	__u64	inum;
 } __attribute__((packed));
=20
 struct rds_info_tcp_socket {
@@ -140,25 +140,25 @@ struct rds_info_tcp_socket {
 	__be16          local_port;
 	__be32          peer_addr;
 	__be16          peer_port;
-	uint64_t       hdr_rem;
-	uint64_t       data_rem;
-	uint32_t       last_sent_nxt;
-	uint32_t       last_expected_una;
-	uint32_t       last_seen_una;
+	__u64       hdr_rem;
+	__u64       data_rem;
+	__u32       last_sent_nxt;
+	__u32       last_expected_una;
+	__u32       last_seen_una;
 } __attribute__((packed));
=20
 #define RDS_IB_GID_LEN	16
 struct rds_info_rdma_connection {
 	__be32		src_addr;
 	__be32		dst_addr;
-	uint8_t		src_gid[RDS_IB_GID_LEN];
-	uint8_t		dst_gid[RDS_IB_GID_LEN];
+	__u8		src_gid[RDS_IB_GID_LEN];
+	__u8		dst_gid[RDS_IB_GID_LEN];
=20
-	uint32_t	max_send_wr;
-	uint32_t	max_recv_wr;
-	uint32_t	max_send_sge;
-	uint32_t	rdma_mr_max;
-	uint32_t	rdma_mr_size;
+	__u32	max_send_wr;
+	__u32	max_recv_wr;
+	__u32	max_send_sge;
+	__u32	rdma_mr_max;
+	__u32	rdma_mr_size;
 };
=20
 /*
@@ -199,70 +199,70 @@ struct rds_info_rdma_connection {
  * (so that the application does not have to worry about
  * alignment).
  */
-typedef uint64_t	rds_rdma_cookie_t;
+typedef __u64	rds_rdma_cookie_t;
=20
 struct rds_iovec {
-	uint64_t	addr;
-	uint64_t	bytes;
+	__u64	addr;
+	__u64	bytes;
 };
=20
 struct rds_get_mr_args {
 	struct rds_iovec vec;
-	uint64_t	cookie_addr;
-	uint64_t	flags;
+	__u64	cookie_addr;
+	__u64	flags;
 };
=20
 struct rds_get_mr_for_dest_args {
 	struct sockaddr_storage	dest_addr;
 	struct rds_iovec 	vec;
-	uint64_t		cookie_addr;
-	uint64_t		flags;
+	__u64		cookie_addr;
+	__u64		flags;
 };
=20
 struct rds_free_mr_args {
 	rds_rdma_cookie_t cookie;
-	uint64_t	flags;
+	__u64	flags;
 };
=20
 struct rds_rdma_args {
 	rds_rdma_cookie_t cookie;
 	struct rds_iovec remote_vec;
-	uint64_t	local_vec_addr;
-	uint64_t	nr_local;
-	uint64_t	flags;
-	uint64_t	user_token;
+	__u64	local_vec_addr;
+	__u64	nr_local;
+	__u64	flags;
+	__u64	user_token;
 };
=20
 struct rds_atomic_args {
 	rds_rdma_cookie_t cookie;
-	uint64_t 	local_addr;
-	uint64_t 	remote_addr;
+	__u64 	local_addr;
+	__u64 	remote_addr;
 	union {
 		struct {
-			uint64_t	compare;
-			uint64_t	swap;
+			__u64	compare;
+			__u64	swap;
 		} cswp;
 		struct {
-			uint64_t	add;
+			__u64	add;
 		} fadd;
 		struct {
-			uint64_t	compare;
-			uint64_t	swap;
-			uint64_t	compare_mask;
-			uint64_t	swap_mask;
+			__u64	compare;
+			__u64	swap;
+			__u64	compare_mask;
+			__u64	swap_mask;
 		} m_cswp;
 		struct {
-			uint64_t	add;
-			uint64_t	nocarry_mask;
+			__u64	add;
+			__u64	nocarry_mask;
 		} m_fadd;
 	};
-	uint64_t	flags;
-	uint64_t	user_token;
+	__u64	flags;
+	__u64	user_token;
 };
=20
 struct rds_rdma_notify {
-	uint64_t	user_token;
-	int32_t		status;
+	__u64	user_token;
+	__s32		status;
 };
=20
 #define RDS_RDMA_SUCCESS	0
--=20
2.1.4
