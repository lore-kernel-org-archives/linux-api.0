From: =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>
Subject: [PATCH bpf-next v8 03/11] bpf: Add eBPF program subtype and is_valid_subtype() verifier
Date: Tue, 27 Feb 2018 01:41:13 +0100
Message-ID: <20180227004121.3633-4-mic@digikod.net>
References: <20180227004121.3633-1-mic@digikod.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <kernel-hardening-return-11970-glkh-kernel-hardening=m.gmane.org@lists.openwall.com>
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
In-Reply-To: <20180227004121.3633-1-mic@digikod.net>
To: linux-kernel@vger.kernel.org
Cc: =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>, Alexei Starovoitov <ast@kernel.org>, Andy Lutomirski <luto@amacapital.net>, Arnaldo Carvalho de Melo <acme@kernel.org>, Casey Schaufler <casey@schaufler-ca.com>, Daniel Borkmann <daniel@iogearbox.net>, David Drysdale <drysdale@google.com>, "David S . Miller" <davem@davemloft.net>, "Eric W . Biederman" <ebiederm@xmission.com>, James Morris <james.l.morris@oracle.com>, Jann Horn <jann@thejh.net>, Jonathan Corbet <corbet@lwn.net>, Michael Kerrisk <mtk.manpages@gmail.com>, Kees Cook <keescook@chromium.org>, Paul Moore <paul@paul-moore.com>, Sargun Dhillon <sargun@sargun.me>, "Serge E . Hallyn" <serge@hallyn.com>, Shuah Khan <shuah@kernel.org>, Tejun Heo <tj@kernel.org>, Thomas Graf <tgraf@suug.ch>, Tycho
List-Id: linux-api@vger.kernel.org

The goal of the program subtype is to be able to have different static
fine-grained verifications for a unique program type.

The struct bpf_verifier_ops gets a new optional function:
is_valid_subtype(). This new verifier is called at the beginning of the
eBPF program verification to check if the (optional) program subtype is
valid.

The struct bpf_prog_ops gets a new optional function: put_extra(). This
may be used to put extra data.

For now, only Landlock eBPF programs are using a program subtype (see
next commits) but this could be used by other program types in the
future.

Signed-off-by: Mickaël Salaün <mic@digikod.net>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: David S. Miller <davem@davemloft.net>
Link: https://lkml.kernel.org/r/20160827205559.GA43880@ast-mbp.thefacebook.com
---

Changes since v7:
* rename LANDLOCK_SUBTYPE_* to LANDLOCK_*
* move subtype in bpf_prog_aux and use only one bit for has_subtype
  (suggested by Alexei Starovoitov)
* wrap the prog_subtype with a prog_extra to be able to reference kernel
  pointers:
  * add an optional put_extra() function to struct bpf_prog_ops to be
    able to free the pointed data
  * replace all the prog_subtype with prog_extra in the struct
    bpf_verifier_ops functions
* remove the ABI field (requested by Alexei Starovoitov)
* rename subtype fields

Changes since v6:
* rename Landlock version to ABI to better reflect its purpose
* fix unsigned integer checks
* fix pointer cast
* constify pointers
* rebase

Changes since v5:
* use a prog_subtype pointer and make it future-proof
* add subtype test
* constify bpf_load_program()'s subtype argument
* cleanup subtype initialization
* rebase

Changes since v4:
* replace the "status" field with "version" (more generic)
* replace the "access" field with "ability" (less confusing)

Changes since v3:
* remove the "origin" field
* add an "option" field
* cleanup comments
---
 include/linux/bpf.h                         | 17 ++++++-
 include/uapi/linux/bpf.h                    | 11 +++++
 kernel/bpf/cgroup.c                         |  6 ++-
 kernel/bpf/core.c                           |  5 +-
 kernel/bpf/syscall.c                        | 35 ++++++++++++-
 kernel/bpf/verifier.c                       | 19 ++++++--
 kernel/trace/bpf_trace.c                    | 15 ++++--
 net/core/filter.c                           | 76 ++++++++++++++++++-----------
 samples/bpf/bpf_load.c                      |  3 +-
 samples/bpf/cookie_uid_helper_example.c     |  2 +-
 samples/bpf/fds_example.c                   |  2 +-
 samples/bpf/sock_example.c                  |  3 +-
 samples/bpf/test_cgrp2_attach.c             |  2 +-
 samples/bpf/test_cgrp2_attach2.c            |  4 +-
 samples/bpf/test_cgrp2_sock.c               |  2 +-
 tools/include/uapi/linux/bpf.h              | 11 +++++
 tools/lib/bpf/bpf.c                         | 15 ++++--
 tools/lib/bpf/bpf.h                         |  8 +--
 tools/lib/bpf/libbpf.c                      |  5 +-
 tools/perf/tests/bpf.c                      |  2 +-
 tools/testing/selftests/bpf/test_align.c    |  2 +-
 tools/testing/selftests/bpf/test_tag.c      |  2 +-
 tools/testing/selftests/bpf/test_verifier.c | 18 ++++++-
 23 files changed, 200 insertions(+), 65 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 66df387106de..377b2f3519f3 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -200,26 +200,38 @@ bpf_ctx_record_field_size(struct bpf_insn_access_aux *aux, u32 size)
 	aux->ctx_field_size = size;
 }
 
+/* specific data per program type */
+struct bpf_prog_extra {
+	union bpf_prog_subtype subtype;
+	union {
+		struct bpf_prog *previous;
+	} landlock_hook;
+};
+
 struct bpf_prog_ops {
 	int (*test_run)(struct bpf_prog *prog, const union bpf_attr *kattr,
 			union bpf_attr __user *uattr);
+	void (*put_extra)(struct bpf_prog_extra *prog_extra);
 };
 
 struct bpf_verifier_ops {
 	/* return eBPF function prototype for verification */
-	const struct bpf_func_proto *(*get_func_proto)(enum bpf_func_id func_id);
+	const struct bpf_func_proto *(*get_func_proto)(enum bpf_func_id func_id,
+				      const struct bpf_prog_extra *prog_extra);
 
 	/* return true if 'size' wide access at offset 'off' within bpf_context
 	 * with 'type' (read or write) is allowed
 	 */
 	bool (*is_valid_access)(int off, int size, enum bpf_access_type type,
-				struct bpf_insn_access_aux *info);
+				struct bpf_insn_access_aux *info,
+				const struct bpf_prog_extra *prog_extra);
 	int (*gen_prologue)(struct bpf_insn *insn, bool direct_write,
 			    const struct bpf_prog *prog);
 	u32 (*convert_ctx_access)(enum bpf_access_type type,
 				  const struct bpf_insn *src,
 				  struct bpf_insn *dst,
 				  struct bpf_prog *prog, u32 *target_size);
+	bool (*is_valid_subtype)(struct bpf_prog_extra *prog_extra);
 };
 
 struct bpf_prog_offload_ops {
@@ -264,6 +276,7 @@ struct bpf_prog_aux {
 		struct work_struct work;
 		struct rcu_head	rcu;
 	};
+	struct bpf_prog_extra *extra;
 };
 
 struct bpf_array {
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index db6bdc375126..87885c92ca78 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -231,6 +231,15 @@ enum bpf_attach_type {
 #define BPF_F_RDONLY		(1U << 3)
 #define BPF_F_WRONLY		(1U << 4)
 
+union bpf_prog_subtype {
+	struct {
+		__u32		type; /* enum landlock_hook_type */
+		__aligned_u64	triggers; /* LANDLOCK_TRIGGER_* */
+		__aligned_u64	options; /* LANDLOCK_OPTION_* */
+		__u32		previous; /* chained program FD */
+	} landlock_hook;
+} __attribute__((aligned(8)));
+
 union bpf_attr {
 	struct { /* anonymous struct used by BPF_MAP_CREATE command */
 		__u32	map_type;	/* one of enum bpf_map_type */
@@ -270,6 +279,8 @@ union bpf_attr {
 		__u32		prog_flags;
 		char		prog_name[BPF_OBJ_NAME_LEN];
 		__u32		prog_ifindex;	/* ifindex of netdev to prep for */
+		__aligned_u64	prog_subtype;	/* bpf_prog_subtype address */
+		__u32		prog_subtype_size;
 	};
 
 	struct { /* anonymous struct used by BPF_OBJ_* commands */
diff --git a/kernel/bpf/cgroup.c b/kernel/bpf/cgroup.c
index c1c0b60d3f2f..77d6d25d2f50 100644
--- a/kernel/bpf/cgroup.c
+++ b/kernel/bpf/cgroup.c
@@ -545,7 +545,8 @@ int __cgroup_bpf_check_dev_permission(short dev_type, u32 major, u32 minor,
 EXPORT_SYMBOL(__cgroup_bpf_check_dev_permission);
 
 static const struct bpf_func_proto *
-cgroup_dev_func_proto(enum bpf_func_id func_id)
+cgroup_dev_func_proto(enum bpf_func_id func_id,
+		      const struct bpf_prog_extra *prog_extra)
 {
 	switch (func_id) {
 	case BPF_FUNC_map_lookup_elem:
@@ -566,7 +567,8 @@ cgroup_dev_func_proto(enum bpf_func_id func_id)
 
 static bool cgroup_dev_is_valid_access(int off, int size,
 				       enum bpf_access_type type,
-				       struct bpf_insn_access_aux *info)
+				       struct bpf_insn_access_aux *info,
+				       const struct bpf_prog_extra *prog_extra)
 {
 	const int size_default = sizeof(__u32);
 
diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index 29ca9208dcfa..e4567f7434af 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -142,7 +142,10 @@ struct bpf_prog *bpf_prog_realloc(struct bpf_prog *fp_old, unsigned int size,
 
 void __bpf_prog_free(struct bpf_prog *fp)
 {
-	kfree(fp->aux);
+	if (fp->aux) {
+		kfree(fp->aux->extra);
+		kfree(fp->aux);
+	}
 	vfree(fp);
 }
 
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index e24aa3241387..90d7de6d7393 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -992,6 +992,8 @@ static void __bpf_prog_put(struct bpf_prog *prog, bool do_idr_lock)
 	if (atomic_dec_and_test(&prog->aux->refcnt)) {
 		int i;
 
+		if (prog->aux->ops->put_extra && prog->aux->extra)
+			prog->aux->ops->put_extra(prog->aux->extra);
 		trace_bpf_prog_put_rcu(prog);
 		/* bpf_prog_free_id() must be called first */
 		bpf_prog_free_id(prog, do_idr_lock);
@@ -1168,7 +1170,7 @@ struct bpf_prog *bpf_prog_get_type_dev(u32 ufd, enum bpf_prog_type type,
 EXPORT_SYMBOL_GPL(bpf_prog_get_type_dev);
 
 /* last field in 'union bpf_attr' used by this command */
-#define	BPF_PROG_LOAD_LAST_FIELD prog_ifindex
+#define	BPF_PROG_LOAD_LAST_FIELD prog_subtype_size
 
 static int bpf_prog_load(union bpf_attr *attr)
 {
@@ -1249,6 +1251,35 @@ static int bpf_prog_load(union bpf_attr *attr)
 	if (err)
 		goto free_prog;
 
+	/* copy eBPF program subtype from user space */
+	if (attr->prog_subtype) {
+		u32 size;
+
+		err = check_uarg_tail_zero(u64_to_user_ptr(attr->prog_subtype),
+					   sizeof(prog->aux->extra->subtype),
+					   attr->prog_subtype_size);
+		if (err)
+			goto free_prog;
+		size = min_t(u32, attr->prog_subtype_size,
+			     sizeof(prog->aux->extra->subtype));
+
+		prog->aux->extra = kzalloc(sizeof(*prog->aux->extra),
+					   GFP_KERNEL | GFP_USER);
+		if (!prog->aux->extra) {
+			err = -ENOMEM;
+			goto free_prog;
+		}
+		if (copy_from_user(&prog->aux->extra->subtype,
+				   u64_to_user_ptr(attr->prog_subtype), size)
+				   != 0) {
+			err = -EFAULT;
+			goto free_prog;
+		}
+	} else if (attr->prog_subtype_size != 0) {
+		err = -EINVAL;
+		goto free_prog;
+	}
+
 	/* run eBPF verifier */
 	err = bpf_check(&prog, attr);
 	if (err < 0)
@@ -1281,6 +1312,8 @@ static int bpf_prog_load(union bpf_attr *attr)
 	return err;
 
 free_used_maps:
+	if (prog->aux->ops->put_extra && prog->aux->extra)
+		prog->aux->ops->put_extra(prog->aux->extra);
 	free_used_maps(prog->aux);
 free_prog:
 	bpf_prog_uncharge_memlock(prog);
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 3c74b163eaeb..ed0905338bb6 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -1310,7 +1310,8 @@ static int check_ctx_access(struct bpf_verifier_env *env, int insn_idx, int off,
 	};
 
 	if (env->ops->is_valid_access &&
-	    env->ops->is_valid_access(off, size, t, &info)) {
+	    env->ops->is_valid_access(off, size, t, &info,
+				      env->prog->aux->extra)) {
 		/* A non zero info.ctx_field_size indicates that this field is a
 		 * candidate for later verifier transformation to load the whole
 		 * field and then apply a mask when accessed with a narrower
@@ -2325,7 +2326,8 @@ static int check_helper_call(struct bpf_verifier_env *env, int func_id, int insn
 	}
 
 	if (env->ops->get_func_proto)
-		fn = env->ops->get_func_proto(func_id);
+		fn = env->ops->get_func_proto(func_id, env->prog->aux->extra);
+
 	if (!fn) {
 		verbose(env, "unknown func %s#%d\n", func_id_name(func_id),
 			func_id);
@@ -5546,7 +5548,7 @@ static int fixup_bpf_calls(struct bpf_verifier_env *env)
 			insn      = new_prog->insnsi + i + delta;
 		}
 patch_call_imm:
-		fn = env->ops->get_func_proto(insn->imm);
+		fn = env->ops->get_func_proto(insn->imm, prog->aux->extra);
 		/* all functions that have prototype and verifier allowed
 		 * programs to call them, must be real in-kernel functions
 		 */
@@ -5633,6 +5635,17 @@ int bpf_check(struct bpf_prog **prog, union bpf_attr *attr)
 	if (!IS_ENABLED(CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS))
 		env->strict_alignment = true;
 
+	if (env->ops->is_valid_subtype) {
+		if (!env->ops->is_valid_subtype(env->prog->aux->extra)) {
+			ret = -EINVAL;
+			goto err_unlock;
+		}
+	} else if (env->prog->aux->extra) {
+		/* do not accept a subtype if the program does not handle it */
+		ret = -EINVAL;
+		goto err_unlock;
+	}
+
 	if (bpf_prog_is_dev_bound(env->prog->aux)) {
 		ret = bpf_prog_offload_verifier_prep(env);
 		if (ret)
diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index fc2838ac8b78..bb5ada28c0f6 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -568,7 +568,8 @@ static const struct bpf_func_proto *tracing_func_proto(enum bpf_func_id func_id)
 	}
 }
 
-static const struct bpf_func_proto *kprobe_prog_func_proto(enum bpf_func_id func_id)
+static const struct bpf_func_proto *kprobe_prog_func_proto(enum bpf_func_id func_id,
+		const struct bpf_prog_extra *prog_extra)
 {
 	switch (func_id) {
 	case BPF_FUNC_perf_event_output:
@@ -588,7 +589,8 @@ static const struct bpf_func_proto *kprobe_prog_func_proto(enum bpf_func_id func
 
 /* bpf+kprobe programs can access fields of 'struct pt_regs' */
 static bool kprobe_prog_is_valid_access(int off, int size, enum bpf_access_type type,
-					struct bpf_insn_access_aux *info)
+					struct bpf_insn_access_aux *info,
+					const struct bpf_prog_extra *prog_extra)
 {
 	if (off < 0 || off >= sizeof(struct pt_regs))
 		return false;
@@ -687,7 +689,8 @@ static const struct bpf_func_proto bpf_perf_prog_read_value_proto_tp = {
          .arg3_type      = ARG_CONST_SIZE,
 };
 
-static const struct bpf_func_proto *tp_prog_func_proto(enum bpf_func_id func_id)
+static const struct bpf_func_proto *tp_prog_func_proto(enum bpf_func_id func_id,
+		const struct bpf_prog_extra *prog_extra)
 {
 	switch (func_id) {
 	case BPF_FUNC_perf_event_output:
@@ -702,7 +705,8 @@ static const struct bpf_func_proto *tp_prog_func_proto(enum bpf_func_id func_id)
 }
 
 static bool tp_prog_is_valid_access(int off, int size, enum bpf_access_type type,
-				    struct bpf_insn_access_aux *info)
+				    struct bpf_insn_access_aux *info,
+				    const struct bpf_prog_extra *prog_extra)
 {
 	if (off < sizeof(void *) || off >= PERF_MAX_TRACE_SIZE)
 		return false;
@@ -724,7 +728,8 @@ const struct bpf_prog_ops tracepoint_prog_ops = {
 };
 
 static bool pe_prog_is_valid_access(int off, int size, enum bpf_access_type type,
-				    struct bpf_insn_access_aux *info)
+				    struct bpf_insn_access_aux *info,
+				    const struct bpf_prog_extra *prog_extra)
 {
 	const int size_sp = FIELD_SIZEOF(struct bpf_perf_event_data,
 					 sample_period);
diff --git a/net/core/filter.c b/net/core/filter.c
index 08ab4c65a998..8c01140db592 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -3403,7 +3403,8 @@ static const struct bpf_func_proto bpf_sock_ops_cb_flags_set_proto = {
 };
 
 static const struct bpf_func_proto *
-bpf_base_func_proto(enum bpf_func_id func_id)
+bpf_base_func_proto(enum bpf_func_id func_id,
+		    const struct bpf_prog_extra *prog_extra)
 {
 	switch (func_id) {
 	case BPF_FUNC_map_lookup_elem:
@@ -3431,7 +3432,8 @@ bpf_base_func_proto(enum bpf_func_id func_id)
 }
 
 static const struct bpf_func_proto *
-sock_filter_func_proto(enum bpf_func_id func_id)
+sock_filter_func_proto(enum bpf_func_id func_id,
+		       const struct bpf_prog_extra *prog_extra)
 {
 	switch (func_id) {
 	/* inet and inet6 sockets are created in a process
@@ -3440,12 +3442,13 @@ sock_filter_func_proto(enum bpf_func_id func_id)
 	case BPF_FUNC_get_current_uid_gid:
 		return &bpf_get_current_uid_gid_proto;
 	default:
-		return bpf_base_func_proto(func_id);
+		return bpf_base_func_proto(func_id, prog_extra);
 	}
 }
 
 static const struct bpf_func_proto *
-sk_filter_func_proto(enum bpf_func_id func_id)
+sk_filter_func_proto(enum bpf_func_id func_id,
+		     const struct bpf_prog_extra *prog_extra)
 {
 	switch (func_id) {
 	case BPF_FUNC_skb_load_bytes:
@@ -3455,12 +3458,13 @@ sk_filter_func_proto(enum bpf_func_id func_id)
 	case BPF_FUNC_get_socket_uid:
 		return &bpf_get_socket_uid_proto;
 	default:
-		return bpf_base_func_proto(func_id);
+		return bpf_base_func_proto(func_id, prog_extra);
 	}
 }
 
 static const struct bpf_func_proto *
-tc_cls_act_func_proto(enum bpf_func_id func_id)
+tc_cls_act_func_proto(enum bpf_func_id func_id,
+		      const struct bpf_prog_extra *prog_extra)
 {
 	switch (func_id) {
 	case BPF_FUNC_skb_store_bytes:
@@ -3522,12 +3526,13 @@ tc_cls_act_func_proto(enum bpf_func_id func_id)
 	case BPF_FUNC_get_socket_uid:
 		return &bpf_get_socket_uid_proto;
 	default:
-		return bpf_base_func_proto(func_id);
+		return bpf_base_func_proto(func_id, prog_extra);
 	}
 }
 
 static const struct bpf_func_proto *
-xdp_func_proto(enum bpf_func_id func_id)
+xdp_func_proto(enum bpf_func_id func_id,
+	       const struct bpf_prog_extra *prog_extra)
 {
 	switch (func_id) {
 	case BPF_FUNC_perf_event_output:
@@ -3545,12 +3550,13 @@ xdp_func_proto(enum bpf_func_id func_id)
 	case BPF_FUNC_redirect_map:
 		return &bpf_xdp_redirect_map_proto;
 	default:
-		return bpf_base_func_proto(func_id);
+		return bpf_base_func_proto(func_id, prog_extra);
 	}
 }
 
 static const struct bpf_func_proto *
-lwt_inout_func_proto(enum bpf_func_id func_id)
+lwt_inout_func_proto(enum bpf_func_id func_id,
+		     const struct bpf_prog_extra *prog_extra)
 {
 	switch (func_id) {
 	case BPF_FUNC_skb_load_bytes:
@@ -3572,12 +3578,13 @@ lwt_inout_func_proto(enum bpf_func_id func_id)
 	case BPF_FUNC_skb_under_cgroup:
 		return &bpf_skb_under_cgroup_proto;
 	default:
-		return bpf_base_func_proto(func_id);
+		return bpf_base_func_proto(func_id, prog_extra);
 	}
 }
 
 static const struct bpf_func_proto *
-	sock_ops_func_proto(enum bpf_func_id func_id)
+	sock_ops_func_proto(enum bpf_func_id func_id,
+			    const struct bpf_prog_extra *prog_extra)
 {
 	switch (func_id) {
 	case BPF_FUNC_setsockopt:
@@ -3589,11 +3596,13 @@ static const struct bpf_func_proto *
 	case BPF_FUNC_sock_map_update:
 		return &bpf_sock_map_update_proto;
 	default:
-		return bpf_base_func_proto(func_id);
+		return bpf_base_func_proto(func_id, prog_extra);
 	}
 }
 
-static const struct bpf_func_proto *sk_skb_func_proto(enum bpf_func_id func_id)
+static const struct bpf_func_proto *
+sk_skb_func_proto(enum bpf_func_id func_id,
+		  const struct bpf_prog_extra *prog_extra)
 {
 	switch (func_id) {
 	case BPF_FUNC_skb_store_bytes:
@@ -3613,12 +3622,13 @@ static const struct bpf_func_proto *sk_skb_func_proto(enum bpf_func_id func_id)
 	case BPF_FUNC_sk_redirect_map:
 		return &bpf_sk_redirect_map_proto;
 	default:
-		return bpf_base_func_proto(func_id);
+		return bpf_base_func_proto(func_id, prog_extra);
 	}
 }
 
 static const struct bpf_func_proto *
-lwt_xmit_func_proto(enum bpf_func_id func_id)
+lwt_xmit_func_proto(enum bpf_func_id func_id,
+		    const struct bpf_prog_extra *prog_extra)
 {
 	switch (func_id) {
 	case BPF_FUNC_skb_get_tunnel_key:
@@ -3648,12 +3658,13 @@ lwt_xmit_func_proto(enum bpf_func_id func_id)
 	case BPF_FUNC_set_hash_invalid:
 		return &bpf_set_hash_invalid_proto;
 	default:
-		return lwt_inout_func_proto(func_id);
+		return lwt_inout_func_proto(func_id, prog_extra);
 	}
 }
 
 static bool bpf_skb_is_valid_access(int off, int size, enum bpf_access_type type,
-				    struct bpf_insn_access_aux *info)
+				    struct bpf_insn_access_aux *info,
+				    const struct bpf_prog_extra *prog_extra)
 {
 	const int size_default = sizeof(__u32);
 
@@ -3696,7 +3707,8 @@ static bool bpf_skb_is_valid_access(int off, int size, enum bpf_access_type type
 
 static bool sk_filter_is_valid_access(int off, int size,
 				      enum bpf_access_type type,
-				      struct bpf_insn_access_aux *info)
+				      struct bpf_insn_access_aux *info,
+				      const struct bpf_prog_extra *prog_extra)
 {
 	switch (off) {
 	case bpf_ctx_range(struct __sk_buff, tc_classid):
@@ -3716,12 +3728,13 @@ static bool sk_filter_is_valid_access(int off, int size,
 		}
 	}
 
-	return bpf_skb_is_valid_access(off, size, type, info);
+	return bpf_skb_is_valid_access(off, size, type, info, prog_extra);
 }
 
 static bool lwt_is_valid_access(int off, int size,
 				enum bpf_access_type type,
-				struct bpf_insn_access_aux *info)
+				struct bpf_insn_access_aux *info,
+				const struct bpf_prog_extra *prog_extra)
 {
 	switch (off) {
 	case bpf_ctx_range(struct __sk_buff, tc_classid):
@@ -3750,12 +3763,13 @@ static bool lwt_is_valid_access(int off, int size,
 		break;
 	}
 
-	return bpf_skb_is_valid_access(off, size, type, info);
+	return bpf_skb_is_valid_access(off, size, type, info, prog_extra);
 }
 
 static bool sock_filter_is_valid_access(int off, int size,
 					enum bpf_access_type type,
-					struct bpf_insn_access_aux *info)
+					struct bpf_insn_access_aux *info,
+					const struct bpf_prog_extra *prog_extra)
 {
 	if (type == BPF_WRITE) {
 		switch (off) {
@@ -3826,7 +3840,8 @@ static int tc_cls_act_prologue(struct bpf_insn *insn_buf, bool direct_write,
 
 static bool tc_cls_act_is_valid_access(int off, int size,
 				       enum bpf_access_type type,
-				       struct bpf_insn_access_aux *info)
+				       struct bpf_insn_access_aux *info,
+				       const struct bpf_prog_extra *prog_extra)
 {
 	if (type == BPF_WRITE) {
 		switch (off) {
@@ -3855,7 +3870,7 @@ static bool tc_cls_act_is_valid_access(int off, int size,
 		return false;
 	}
 
-	return bpf_skb_is_valid_access(off, size, type, info);
+	return bpf_skb_is_valid_access(off, size, type, info, prog_extra);
 }
 
 static bool __is_valid_xdp_access(int off, int size)
@@ -3872,7 +3887,8 @@ static bool __is_valid_xdp_access(int off, int size)
 
 static bool xdp_is_valid_access(int off, int size,
 				enum bpf_access_type type,
-				struct bpf_insn_access_aux *info)
+				struct bpf_insn_access_aux *info,
+				const struct bpf_prog_extra *prog_extra)
 {
 	if (type == BPF_WRITE)
 		return false;
@@ -3904,7 +3920,8 @@ EXPORT_SYMBOL_GPL(bpf_warn_invalid_xdp_action);
 
 static bool sock_ops_is_valid_access(int off, int size,
 				     enum bpf_access_type type,
-				     struct bpf_insn_access_aux *info)
+				     struct bpf_insn_access_aux *info,
+				     const struct bpf_prog_extra *prog_extra)
 {
 	const int size_default = sizeof(__u32);
 
@@ -3950,7 +3967,8 @@ static int sk_skb_prologue(struct bpf_insn *insn_buf, bool direct_write,
 
 static bool sk_skb_is_valid_access(int off, int size,
 				   enum bpf_access_type type,
-				   struct bpf_insn_access_aux *info)
+				   struct bpf_insn_access_aux *info,
+				   const struct bpf_prog_extra *prog_extra)
 {
 	switch (off) {
 	case bpf_ctx_range(struct __sk_buff, tc_classid):
@@ -3979,7 +3997,7 @@ static bool sk_skb_is_valid_access(int off, int size,
 		break;
 	}
 
-	return bpf_skb_is_valid_access(off, size, type, info);
+	return bpf_skb_is_valid_access(off, size, type, info, prog_extra);
 }
 
 static u32 bpf_convert_ctx_access(enum bpf_access_type type,
diff --git a/samples/bpf/bpf_load.c b/samples/bpf/bpf_load.c
index 69806d74fa53..5bb37db6054b 100644
--- a/samples/bpf/bpf_load.c
+++ b/samples/bpf/bpf_load.c
@@ -72,6 +72,7 @@ static int load_and_attach(const char *event, struct bpf_insn *prog, int size)
 	char buf[256];
 	int fd, efd, err, id;
 	struct perf_event_attr attr = {};
+	union bpf_prog_subtype *st = NULL;
 
 	attr.type = PERF_TYPE_TRACEPOINT;
 	attr.sample_type = PERF_SAMPLE_RAW;
@@ -102,7 +103,7 @@ static int load_and_attach(const char *event, struct bpf_insn *prog, int size)
 	}
 
 	fd = bpf_load_program(prog_type, prog, insns_cnt, license, kern_version,
-			      bpf_log_buf, BPF_LOG_BUF_SIZE);
+			      bpf_log_buf, BPF_LOG_BUF_SIZE, st);
 	if (fd < 0) {
 		printf("bpf_load_program() err=%d\n%s", errno, bpf_log_buf);
 		return -1;
diff --git a/samples/bpf/cookie_uid_helper_example.c b/samples/bpf/cookie_uid_helper_example.c
index 9d751e209f31..df457c07d35d 100644
--- a/samples/bpf/cookie_uid_helper_example.c
+++ b/samples/bpf/cookie_uid_helper_example.c
@@ -159,7 +159,7 @@ static void prog_load(void)
 	};
 	prog_fd = bpf_load_program(BPF_PROG_TYPE_SOCKET_FILTER, prog,
 					ARRAY_SIZE(prog), "GPL", 0,
-					log_buf, sizeof(log_buf));
+					log_buf, sizeof(log_buf), NULL);
 	if (prog_fd < 0)
 		error(1, errno, "failed to load prog\n%s\n", log_buf);
 }
diff --git a/samples/bpf/fds_example.c b/samples/bpf/fds_example.c
index e29bd52ff9e8..0f4f5f6a9f9f 100644
--- a/samples/bpf/fds_example.c
+++ b/samples/bpf/fds_example.c
@@ -62,7 +62,7 @@ static int bpf_prog_create(const char *object)
 	} else {
 		return bpf_load_program(BPF_PROG_TYPE_SOCKET_FILTER,
 					insns, insns_cnt, "GPL", 0,
-					bpf_log_buf, BPF_LOG_BUF_SIZE);
+					bpf_log_buf, BPF_LOG_BUF_SIZE, NULL);
 	}
 }
 
diff --git a/samples/bpf/sock_example.c b/samples/bpf/sock_example.c
index 6fc6e193ef1b..3778f66deb76 100644
--- a/samples/bpf/sock_example.c
+++ b/samples/bpf/sock_example.c
@@ -60,7 +60,8 @@ static int test_sock(void)
 	size_t insns_cnt = sizeof(prog) / sizeof(struct bpf_insn);
 
 	prog_fd = bpf_load_program(BPF_PROG_TYPE_SOCKET_FILTER, prog, insns_cnt,
-				   "GPL", 0, bpf_log_buf, BPF_LOG_BUF_SIZE);
+				   "GPL", 0, bpf_log_buf, BPF_LOG_BUF_SIZE,
+				   NULL);
 	if (prog_fd < 0) {
 		printf("failed to load prog '%s'\n", strerror(errno));
 		goto cleanup;
diff --git a/samples/bpf/test_cgrp2_attach.c b/samples/bpf/test_cgrp2_attach.c
index 4bfcaf93fcf3..f8a91d2b7896 100644
--- a/samples/bpf/test_cgrp2_attach.c
+++ b/samples/bpf/test_cgrp2_attach.c
@@ -72,7 +72,7 @@ static int prog_load(int map_fd, int verdict)
 
 	return bpf_load_program(BPF_PROG_TYPE_CGROUP_SKB,
 				prog, insns_cnt, "GPL", 0,
-				bpf_log_buf, BPF_LOG_BUF_SIZE);
+				bpf_log_buf, BPF_LOG_BUF_SIZE, NULL);
 }
 
 static int usage(const char *argv0)
diff --git a/samples/bpf/test_cgrp2_attach2.c b/samples/bpf/test_cgrp2_attach2.c
index 1af412ec6007..16023240ce5d 100644
--- a/samples/bpf/test_cgrp2_attach2.c
+++ b/samples/bpf/test_cgrp2_attach2.c
@@ -45,7 +45,7 @@ static int prog_load(int verdict)
 
 	ret = bpf_load_program(BPF_PROG_TYPE_CGROUP_SKB,
 			       prog, insns_cnt, "GPL", 0,
-			       bpf_log_buf, BPF_LOG_BUF_SIZE);
+			       bpf_log_buf, BPF_LOG_BUF_SIZE, NULL);
 
 	if (ret < 0) {
 		log_err("Loading program");
@@ -229,7 +229,7 @@ static int prog_load_cnt(int verdict, int val)
 
 	ret = bpf_load_program(BPF_PROG_TYPE_CGROUP_SKB,
 			       prog, insns_cnt, "GPL", 0,
-			       bpf_log_buf, BPF_LOG_BUF_SIZE);
+			       bpf_log_buf, BPF_LOG_BUF_SIZE, NULL);
 
 	if (ret < 0) {
 		log_err("Loading program");
diff --git a/samples/bpf/test_cgrp2_sock.c b/samples/bpf/test_cgrp2_sock.c
index e79594dd629b..b4b8d96f61e7 100644
--- a/samples/bpf/test_cgrp2_sock.c
+++ b/samples/bpf/test_cgrp2_sock.c
@@ -115,7 +115,7 @@ static int prog_load(__u32 idx, __u32 mark, __u32 prio)
 	insns_cnt /= sizeof(struct bpf_insn);
 
 	ret = bpf_load_program(BPF_PROG_TYPE_CGROUP_SOCK, prog, insns_cnt,
-				"GPL", 0, bpf_log_buf, BPF_LOG_BUF_SIZE);
+				"GPL", 0, bpf_log_buf, BPF_LOG_BUF_SIZE, NULL);
 
 	free(prog);
 
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index db6bdc375126..87885c92ca78 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -231,6 +231,15 @@ enum bpf_attach_type {
 #define BPF_F_RDONLY		(1U << 3)
 #define BPF_F_WRONLY		(1U << 4)
 
+union bpf_prog_subtype {
+	struct {
+		__u32		type; /* enum landlock_hook_type */
+		__aligned_u64	triggers; /* LANDLOCK_TRIGGER_* */
+		__aligned_u64	options; /* LANDLOCK_OPTION_* */
+		__u32		previous; /* chained program FD */
+	} landlock_hook;
+} __attribute__((aligned(8)));
+
 union bpf_attr {
 	struct { /* anonymous struct used by BPF_MAP_CREATE command */
 		__u32	map_type;	/* one of enum bpf_map_type */
@@ -270,6 +279,8 @@ union bpf_attr {
 		__u32		prog_flags;
 		char		prog_name[BPF_OBJ_NAME_LEN];
 		__u32		prog_ifindex;	/* ifindex of netdev to prep for */
+		__aligned_u64	prog_subtype;	/* bpf_prog_subtype address */
+		__u32		prog_subtype_size;
 	};
 
 	struct { /* anonymous struct used by BPF_OBJ_* commands */
diff --git a/tools/lib/bpf/bpf.c b/tools/lib/bpf/bpf.c
index 592a58a2b681..630060c71c5e 100644
--- a/tools/lib/bpf/bpf.c
+++ b/tools/lib/bpf/bpf.c
@@ -150,7 +150,8 @@ int bpf_load_program_name(enum bpf_prog_type type, const char *name,
 			  const struct bpf_insn *insns,
 			  size_t insns_cnt, const char *license,
 			  __u32 kern_version, char *log_buf,
-			  size_t log_buf_sz)
+			  size_t log_buf_sz,
+			  const union bpf_prog_subtype *subtype)
 {
 	int fd;
 	union bpf_attr attr;
@@ -166,6 +167,8 @@ int bpf_load_program_name(enum bpf_prog_type type, const char *name,
 	attr.log_level = 0;
 	attr.kern_version = kern_version;
 	memcpy(attr.prog_name, name, min(name_len, BPF_OBJ_NAME_LEN - 1));
+	attr.prog_subtype = ptr_to_u64(subtype);
+	attr.prog_subtype_size = subtype ? sizeof(*subtype) : 0;
 
 	fd = sys_bpf(BPF_PROG_LOAD, &attr, sizeof(attr));
 	if (fd >= 0 || !log_buf || !log_buf_sz)
@@ -182,16 +185,18 @@ int bpf_load_program_name(enum bpf_prog_type type, const char *name,
 int bpf_load_program(enum bpf_prog_type type, const struct bpf_insn *insns,
 		     size_t insns_cnt, const char *license,
 		     __u32 kern_version, char *log_buf,
-		     size_t log_buf_sz)
+		     size_t log_buf_sz, const union bpf_prog_subtype *subtype)
 {
 	return bpf_load_program_name(type, NULL, insns, insns_cnt, license,
-				     kern_version, log_buf, log_buf_sz);
+				     kern_version, log_buf, log_buf_sz,
+				     subtype);
 }
 
 int bpf_verify_program(enum bpf_prog_type type, const struct bpf_insn *insns,
 		       size_t insns_cnt, int strict_alignment,
 		       const char *license, __u32 kern_version,
-		       char *log_buf, size_t log_buf_sz, int log_level)
+		       char *log_buf, size_t log_buf_sz, int log_level,
+		       const union bpf_prog_subtype *subtype)
 {
 	union bpf_attr attr;
 
@@ -205,6 +210,8 @@ int bpf_verify_program(enum bpf_prog_type type, const struct bpf_insn *insns,
 	attr.log_level = log_level;
 	log_buf[0] = 0;
 	attr.kern_version = kern_version;
+	attr.prog_subtype = ptr_to_u64(subtype);
+	attr.prog_subtype_size = subtype ? sizeof(*subtype) : 0;
 	attr.prog_flags = strict_alignment ? BPF_F_STRICT_ALIGNMENT : 0;
 
 	return sys_bpf(BPF_PROG_LOAD, &attr, sizeof(attr));
diff --git a/tools/lib/bpf/bpf.h b/tools/lib/bpf/bpf.h
index 8d18fb73d7fb..25f58da59df3 100644
--- a/tools/lib/bpf/bpf.h
+++ b/tools/lib/bpf/bpf.h
@@ -47,15 +47,17 @@ int bpf_load_program_name(enum bpf_prog_type type, const char *name,
 			  const struct bpf_insn *insns,
 			  size_t insns_cnt, const char *license,
 			  __u32 kern_version, char *log_buf,
-			  size_t log_buf_sz);
+			  size_t log_buf_sz,
+			  const union bpf_prog_subtype *subtype);
 int bpf_load_program(enum bpf_prog_type type, const struct bpf_insn *insns,
 		     size_t insns_cnt, const char *license,
 		     __u32 kern_version, char *log_buf,
-		     size_t log_buf_sz);
+		     size_t log_buf_sz, const union bpf_prog_subtype *subtype);
 int bpf_verify_program(enum bpf_prog_type type, const struct bpf_insn *insns,
 		       size_t insns_cnt, int strict_alignment,
 		       const char *license, __u32 kern_version,
-		       char *log_buf, size_t log_buf_sz, int log_level);
+		       char *log_buf, size_t log_buf_sz, int log_level,
+		       const union bpf_prog_subtype *subtype);
 
 int bpf_map_update_elem(int fd, const void *key, const void *value,
 			__u64 flags);
diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 97073d649c1a..615860db6224 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -1175,7 +1175,8 @@ load_program(enum bpf_prog_type type, const char *name, struct bpf_insn *insns,
 		pr_warning("Alloc log buffer for bpf loader error, continue without log\n");
 
 	ret = bpf_load_program_name(type, name, insns, insns_cnt, license,
-				    kern_version, log_buf, BPF_LOG_BUF_SIZE);
+				    kern_version, log_buf, BPF_LOG_BUF_SIZE,
+				    NULL);
 
 	if (ret >= 0) {
 		*pfd = ret;
@@ -1202,7 +1203,7 @@ load_program(enum bpf_prog_type type, const char *name, struct bpf_insn *insns,
 
 			fd = bpf_load_program_name(BPF_PROG_TYPE_KPROBE, name,
 						   insns, insns_cnt, license,
-						   kern_version, NULL, 0);
+						   kern_version, NULL, 0, NULL);
 			if (fd >= 0) {
 				close(fd);
 				ret = -LIBBPF_ERRNO__PROGTYPE;
diff --git a/tools/perf/tests/bpf.c b/tools/perf/tests/bpf.c
index e8399beca62b..2635de920a71 100644
--- a/tools/perf/tests/bpf.c
+++ b/tools/perf/tests/bpf.c
@@ -306,7 +306,7 @@ static int check_env(void)
 
 	err = bpf_load_program(BPF_PROG_TYPE_KPROBE, insns,
 			       sizeof(insns) / sizeof(insns[0]),
-			       license, kver_int, NULL, 0);
+			       license, kver_int, NULL, 0, NULL);
 	if (err < 0) {
 		pr_err("Missing basic BPF support, skip this test: %s\n",
 		       strerror(errno));
diff --git a/tools/testing/selftests/bpf/test_align.c b/tools/testing/selftests/bpf/test_align.c
index ff8bd7e3e50c..ed638ce9932e 100644
--- a/tools/testing/selftests/bpf/test_align.c
+++ b/tools/testing/selftests/bpf/test_align.c
@@ -625,7 +625,7 @@ static int do_test_single(struct bpf_align_test *test)
 	prog_len = probe_filter_length(prog);
 	fd_prog = bpf_verify_program(prog_type ? : BPF_PROG_TYPE_SOCKET_FILTER,
 				     prog, prog_len, 1, "GPL", 0,
-				     bpf_vlog, sizeof(bpf_vlog), 2);
+				     bpf_vlog, sizeof(bpf_vlog), 2, NULL);
 	if (fd_prog < 0 && test->result != REJECT) {
 		printf("Failed to load program.\n");
 		printf("%s", bpf_vlog);
diff --git a/tools/testing/selftests/bpf/test_tag.c b/tools/testing/selftests/bpf/test_tag.c
index 8b201895c569..0b58e746af0c 100644
--- a/tools/testing/selftests/bpf/test_tag.c
+++ b/tools/testing/selftests/bpf/test_tag.c
@@ -58,7 +58,7 @@ static int bpf_try_load_prog(int insns, int fd_map,
 
 	bpf_filler(insns, fd_map);
 	fd_prog = bpf_load_program(BPF_PROG_TYPE_SCHED_CLS, prog, insns, "", 0,
-				   NULL, 0);
+				   NULL, 0, NULL);
 	assert(fd_prog > 0);
 	if (fd_map > 0)
 		bpf_filler(insns, 0);
diff --git a/tools/testing/selftests/bpf/test_verifier.c b/tools/testing/selftests/bpf/test_verifier.c
index c987d3a2426f..3c24a5a7bafc 100644
--- a/tools/testing/selftests/bpf/test_verifier.c
+++ b/tools/testing/selftests/bpf/test_verifier.c
@@ -77,6 +77,8 @@ struct bpf_test {
 	} result, result_unpriv;
 	enum bpf_prog_type prog_type;
 	uint8_t flags;
+	bool has_prog_subtype;
+	union bpf_prog_subtype prog_subtype;
 };
 
 /* Note we want this to be 64 bit aligned so that the end of our array is
@@ -11228,7 +11230,16 @@ static struct bpf_test tests[] = {
 		.result = ACCEPT,
 		.retval = 2,
 	},
-
+	{
+		"superfluous subtype",
+		.insns = {
+			BPF_MOV32_IMM(BPF_REG_0, 0),
+			BPF_EXIT_INSN(),
+		},
+		.errstr = "",
+		.result = REJECT,
+		.has_prog_subtype = true,
+	},
 };
 
 static int probe_filter_length(const struct bpf_insn *fp)
@@ -11346,6 +11357,8 @@ static void do_test_single(struct bpf_test *test, bool unpriv,
 	const char *expected_err;
 	uint32_t retval;
 	int i, err;
+	union bpf_prog_subtype *prog_subtype =
+		test->has_prog_subtype ? &test->prog_subtype : NULL;
 
 	for (i = 0; i < MAX_NR_MAPS; i++)
 		map_fds[i] = -1;
@@ -11354,7 +11367,8 @@ static void do_test_single(struct bpf_test *test, bool unpriv,
 
 	fd_prog = bpf_verify_program(prog_type ? : BPF_PROG_TYPE_SOCKET_FILTER,
 				     prog, prog_len, test->flags & F_LOAD_WITH_STRICT_ALIGNMENT,
-				     "GPL", 0, bpf_vlog, sizeof(bpf_vlog), 1);
+				     "GPL", 0, bpf_vlog, sizeof(bpf_vlog), 1,
+				     prog_subtype);
 
 	expected_ret = unpriv && test->result_unpriv != UNDEF ?
 		       test->result_unpriv : test->result;
-- 
2.16.2
