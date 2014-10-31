From: Karol Lewandowski <k.lewandowsk-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH 4/5] security: introduce lsm hooks for kdbus
Date: Fri, 31 Oct 2014 17:36:36 +0100
Message-ID: <1414773397-26490-5-git-send-email-k.lewandowsk@samsung.com>
References: <54539AF3.6060302@samsung.com>
 <1414773397-26490-1-git-send-email-k.lewandowsk@samsung.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-reply-to: <1414773397-26490-1-git-send-email-k.lewandowsk-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org
Cc: pmoore-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, jkosina-AlSwsSmVLrQ@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, inux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, desrt-0xnayjDhYQY@public.gmane.org, simon.mcvittie-ZGY8ohtN/8pPYcu2f3hruQ@public.gmane.org, daniel-cYrQPVfZoowdnm+yROfE0A@public.gmane.org, dh.herrmann-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, casey.schaufler-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, marcel-kz+m5ild9QBg9hUCZPvPmw@public.gmane.org, tixxdz-Umm1ozX2/EEdnm+yROfE0A@public.gmane.org, javier.martinez-ZGY8ohtN/8pPYcu2f3hruQ@public.gmane.org, alban.crequy-ZGY8ohtN/8pPYcu2f3hruQ@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lmctlx-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, r.krypa-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, Karol Lewandowski <k.lewandowsk-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

This is proof-of-concept set of hooks for kdbus by Karol Lewandowski
and Paul Moore.

Signed-off-by: Karol Lewandowski <k.lewandowsk-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
---
 include/linux/security.h | 114 +++++++++++++++++++++++++++++++++++++++++++++++
 security/capability.c    |  84 ++++++++++++++++++++++++++++++++++
 security/security.c      |  84 ++++++++++++++++++++++++++++++++++
 3 files changed, 282 insertions(+)

diff --git a/include/linux/security.h b/include/linux/security.h
index 623f90e..ac845e9 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -53,6 +53,10 @@ struct msg_queue;
 struct xattr;
 struct xfrm_sec_ctx;
 struct mm_struct;
+struct kdbus_ep;
+struct kdbus_bus;
+struct kdbus_conn;
+struct kdbus_domain;
 
 /* Maximum number of letters for an LSM name string */
 #define SECURITY_NAME_MAX	10
@@ -1438,6 +1442,7 @@ static inline void security_free_mnt_opts(struct security_mnt_opts *opts)
  *	@ctxlen points to the place to put the length of @ctx.
  * This is the main security structure.
  */
+/* XXX - need to include descriptions for the kdbus hooks in the block above */
 struct security_operations {
 	char name[SECURITY_NAME_MAX + 1];
 
@@ -1645,6 +1650,24 @@ struct security_operations {
 	int (*inode_setsecctx)(struct dentry *dentry, void *ctx, u32 ctxlen);
 	int (*inode_getsecctx)(struct inode *inode, void **ctx, u32 *ctxlen);
 
+	int (*kdbus_domain_alloc)(struct kdbus_domain *domain);
+	void (*kdbus_domain_free)(struct kdbus_domain *domain);
+
+	int (*kdbus_bus_alloc)(struct kdbus_bus *bus);
+	void (*kdbus_bus_free)(struct kdbus_bus *bus);
+	int (*kdbus_send)(const struct kdbus_conn *conn, const struct kdbus_bus *bus);
+	int (*kdbus_recv)(const struct kdbus_conn *conn, const struct kdbus_bus *bus);
+	int (*kdbus_name_acquire)(const struct kdbus_conn *conn, const char *name);
+	int (*kdbus_name_list)(const struct kdbus_bus *bus);
+
+	int (*kdbus_ep_create)(const struct kdbus_bus *bus);
+	int (*kdbus_ep_setpolicy)(const struct kdbus_bus *bus);
+
+	int (*kdbus_connect)(struct kdbus_conn *conn, const char *secctx, u32 seclen);
+	void (*kdbus_conn_free)(struct kdbus_conn *conn);
+	int (*kdbus_conn_info)(const struct kdbus_conn *conn);
+	int (*kdbus_talk)(const struct kdbus_conn *src, const struct kdbus_conn *dst);
+
 #ifdef CONFIG_SECURITY_NETWORK
 	int (*unix_stream_connect) (struct sock *sock, struct sock *other, struct sock *newsk);
 	int (*unix_may_send) (struct socket *sock, struct socket *other);
@@ -1905,6 +1928,25 @@ void security_release_secctx(char *secdata, u32 seclen);
 int security_inode_notifysecctx(struct inode *inode, void *ctx, u32 ctxlen);
 int security_inode_setsecctx(struct dentry *dentry, void *ctx, u32 ctxlen);
 int security_inode_getsecctx(struct inode *inode, void **ctx, u32 *ctxlen);
+
+int security_kdbus_domain_alloc(struct kdbus_domain *domain);
+void security_kdbus_domain_free(struct kdbus_domain *domain);
+
+int security_kdbus_bus_alloc(struct kdbus_bus *bus);
+void security_kdbus_bus_free(struct kdbus_bus *bus);
+int security_kdbus_send(const struct kdbus_conn *conn, const struct kdbus_bus *bus);
+int security_kdbus_recv(const struct kdbus_conn *conn, const struct kdbus_bus *bus);
+int security_kdbus_name_acquire(const struct kdbus_conn *conn, const char *name);
+int security_kdbus_name_list(const struct kdbus_bus *bus);
+
+int security_kdbus_ep_create(struct kdbus_bus *bus);
+int security_kdbus_ep_setpolicy(struct kdbus_bus *bus);
+
+int security_kdbus_connect(struct kdbus_conn *conn, const char *secctx, u32 seclen);
+void security_kdbus_conn_free(struct kdbus_conn *conn);
+int security_kdbus_conn_info(const struct kdbus_conn *conn);
+int security_kdbus_talk(const struct kdbus_conn *src, const struct kdbus_conn *dst);
+
 #else /* CONFIG_SECURITY */
 struct security_mnt_opts {
 };
@@ -2630,6 +2672,78 @@ static inline int security_inode_getsecctx(struct inode *inode, void **ctx, u32
 {
 	return -EOPNOTSUPP;
 }
+
+static inline int security_kdbus_domain_alloc(struct kdbus_domain *domain)
+{
+	return 0;
+}
+static inline void security_kdbus_domain_free(struct kdbus_domain *domain)
+{
+}
+
+static inline int security_kdbus_bus_alloc(struct kdbus_bus *bus)
+{
+	return 0;
+}
+
+static inline void security_kdbus_bus_free(struct kdbus_bus *bus)
+{
+}
+
+static inline int security_kdbus_send(const struct kdbus_conn *conn,
+				      const struct kdbus_bus *bus)
+{
+	return 0;
+}
+
+static inline int security_kdbus_recv(const struct kdbus_conn *conn,
+				      const struct kdbus_bus *bus)
+{
+	return 0;
+}
+
+static inline int security_kdbus_name_acquire(const struct kdbus_conn *conn,
+					      const char *name)
+{
+	return 0;
+}
+
+static inline int security_kdbus_name_list(const struct kdbus_bus *bus)
+{
+	return 0;
+}
+
+static inline int security_kdbus_ep_create(const struct kdbus_bus *bus)
+{
+	return 0;
+}
+
+static inline int security_kdbus_ep_setpolicy(const struct kdbus_bus *bus)
+{
+	return 0;
+}
+
+static inline int security_kdbus_connect(struct kdbus_conn *conn,
+					 const char *secctx, u32 seclen)
+{
+	return 0;
+}
+
+static inline void security_kdbus_conn_free(struct kdbus_conn *conn)
+{
+}
+
+static inline int security_kdbus_conn_info(const struct kdbus_conn *conn)
+{
+	return 0;
+}
+
+static inline int security_kdbus_talk(const struct kdbus_conn *src,
+				      const struct kdbus_conn *dst)
+{
+	return 0;
+}
+
 #endif	/* CONFIG_SECURITY */
 
 #ifdef CONFIG_SECURITY_NETWORK
diff --git a/security/capability.c b/security/capability.c
index a74fde6..b4322c8 100644
--- a/security/capability.c
+++ b/security/capability.c
@@ -572,6 +572,76 @@ static int cap_sem_semop(struct sem_array *sma, struct sembuf *sops,
 	return 0;
 }
 
+static int cap_kdbus_domain_alloc(struct kdbus_domain *domain)
+{
+	return 0;
+}
+
+static void cap_kdbus_domain_free(struct kdbus_domain *domain)
+{
+}
+
+static int cap_kdbus_bus_alloc(struct kdbus_bus *bus)
+{
+	return 0;
+}
+
+static void cap_kdbus_bus_free(struct kdbus_bus *bus)
+{
+}
+
+static int cap_kdbus_send(const struct kdbus_conn *conn,
+			  const struct kdbus_bus *bus)
+
+{
+	return 0;
+}
+
+static int cap_kdbus_recv(const struct kdbus_conn *conn,
+			  const struct kdbus_bus *bus)
+{
+	return 0;
+}
+
+static int cap_kdbus_name_acquire(const struct kdbus_conn *conn, const char *name)
+{
+	return 0;
+}
+
+static int cap_kdbus_name_list(const struct kdbus_bus *bus)
+{
+	return 0;
+}
+
+static int cap_kdbus_ep_create(const struct kdbus_bus *bus)
+{
+	return 0;
+}
+
+static int cap_kdbus_ep_setpolicy(const struct kdbus_bus *bus)
+{
+	return 0;
+}
+
+static int cap_kdbus_connect(struct kdbus_conn *conn, const char *secctx, u32 seclen)
+{
+	return 0;
+}
+
+static int cap_kdbus_conn_info(const struct kdbus_conn *conn)
+{
+	return 0;
+}
+
+static void cap_kdbus_conn_free(struct kdbus_conn *conn)
+{
+}
+
+static int cap_kdbus_talk(const struct kdbus_conn *src, const struct kdbus_conn *dst)
+{
+	return 0;
+}
+
 #ifdef CONFIG_SECURITY_NETWORK
 static int cap_unix_stream_connect(struct sock *sock, struct sock *other,
 				   struct sock *newsk)
@@ -1070,6 +1140,20 @@ void __init security_fixup_ops(struct security_operations *ops)
 	set_to_cap_if_null(ops, inode_notifysecctx);
 	set_to_cap_if_null(ops, inode_setsecctx);
 	set_to_cap_if_null(ops, inode_getsecctx);
+	set_to_cap_if_null(ops, kdbus_domain_alloc);
+	set_to_cap_if_null(ops, kdbus_domain_free);
+	set_to_cap_if_null(ops, kdbus_bus_alloc);
+	set_to_cap_if_null(ops, kdbus_bus_free);
+	set_to_cap_if_null(ops, kdbus_send);
+	set_to_cap_if_null(ops, kdbus_recv);
+	set_to_cap_if_null(ops, kdbus_name_acquire);
+	set_to_cap_if_null(ops, kdbus_name_list);
+	set_to_cap_if_null(ops, kdbus_ep_create);
+	set_to_cap_if_null(ops, kdbus_ep_setpolicy);
+	set_to_cap_if_null(ops, kdbus_connect);
+	set_to_cap_if_null(ops, kdbus_conn_free);
+	set_to_cap_if_null(ops, kdbus_conn_info);
+	set_to_cap_if_null(ops, kdbus_talk);
 #ifdef CONFIG_SECURITY_NETWORK
 	set_to_cap_if_null(ops, unix_stream_connect);
 	set_to_cap_if_null(ops, unix_may_send);
diff --git a/security/security.c b/security/security.c
index d29b28b..25a3154 100644
--- a/security/security.c
+++ b/security/security.c
@@ -1131,6 +1131,90 @@ int security_inode_getsecctx(struct inode *inode, void **ctx, u32 *ctxlen)
 }
 EXPORT_SYMBOL(security_inode_getsecctx);
 
+int security_kdbus_domain_alloc(struct kdbus_domain *domain)
+{
+	return security_ops->kdbus_domain_alloc(domain);
+}
+EXPORT_SYMBOL(security_kdbus_domain_alloc);
+
+void security_kdbus_domain_free(struct kdbus_domain *domain)
+{
+	security_ops->kdbus_domain_free(domain);
+}
+EXPORT_SYMBOL(security_kdbus_domain_free);
+
+int security_kdbus_bus_alloc(struct kdbus_bus *bus)
+{
+	return security_ops->kdbus_bus_alloc(bus);
+}
+EXPORT_SYMBOL(security_kdbus_bus_alloc);
+
+void security_kdbus_bus_free(struct kdbus_bus *bus)
+{
+	security_ops->kdbus_bus_free(bus);
+}
+EXPORT_SYMBOL(security_kdbus_bus_free);
+
+int security_kdbus_send(const struct kdbus_conn *conn, const struct kdbus_bus *bus)
+{
+	return security_ops->kdbus_send(conn, bus);
+}
+EXPORT_SYMBOL(security_kdbus_send);
+
+int security_kdbus_recv(const struct kdbus_conn *conn, const struct kdbus_bus *bus)
+{
+	return security_ops->kdbus_recv(conn, bus);
+}
+EXPORT_SYMBOL(security_kdbus_recv);
+
+int security_kdbus_name_acquire(const struct kdbus_conn *conn, const char *name)
+{
+	return security_ops->kdbus_name_acquire(conn, name);
+}
+EXPORT_SYMBOL(security_kdbus_name_acquire);
+
+int security_kdbus_name_list(const struct kdbus_bus *bus)
+{
+	return security_ops->kdbus_name_list(bus);
+}
+EXPORT_SYMBOL(security_kdbus_name_list);
+
+int security_kdbus_ep_create(struct kdbus_bus *bus)
+{
+	return security_ops->kdbus_ep_create(bus);
+}
+EXPORT_SYMBOL(security_kdbus_ep_create);
+
+int security_kdbus_ep_setpolicy(struct kdbus_bus *bus)
+{
+	return security_ops->kdbus_ep_setpolicy(bus);
+}
+EXPORT_SYMBOL(security_kdbus_ep_setpolicy);
+
+int security_kdbus_connect(struct kdbus_conn *conn, const char *secctx, u32 seclen)
+{
+	return security_ops->kdbus_connect(conn, secctx, seclen);
+}
+EXPORT_SYMBOL(security_kdbus_connect);
+
+void security_kdbus_conn_free(struct kdbus_conn *conn)
+{
+	security_ops->kdbus_conn_free(conn);
+}
+EXPORT_SYMBOL(security_kdbus_conn_free);
+
+int security_kdbus_conn_info(const struct kdbus_conn *conn)
+{
+	return security_ops->kdbus_conn_info(conn);
+}
+EXPORT_SYMBOL(security_kdbus_conn_info);
+
+int security_kdbus_talk(const struct kdbus_conn *src, const struct kdbus_conn *dst)
+{
+	return security_ops->kdbus_talk(src, dst);
+}
+EXPORT_SYMBOL(security_kdbus_talk);
+
 #ifdef CONFIG_SECURITY_NETWORK
 
 int security_unix_stream_connect(struct sock *sock, struct sock *other, struct sock *newsk)
-- 
2.1.1
