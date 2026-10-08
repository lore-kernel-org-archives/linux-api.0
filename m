Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3FD94734CF;
	Thu,  8 Oct 2026 08:51:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791449489; cv=none; b=I/FvVGphQFtTPJFMP6LoP76bDyi592WCS+kCPSez0H8vbizb8VL2Oh/E1bEHB8Cgwcjsxt4EYyuUlaSgNaQ9uE59CEphp5ot+tWNFCixcMnGbAOtreFq5GLZHjkO94D+5V9vpqGsXZvCZH7WsqqClLfxPxYcfzdjBqhJ1B+tBaw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791449489; c=relaxed/simple;
	bh=y3mksDWJ1cnx2vUcwBui9kRBD7D1m6dYAJo/BBdmKFw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YxoKqOJ3FPHlCOKCU6erPyYzDvBd9k8jcxKlS6aKcAS0rHiuBaKtciy1ph8N/NFm020E+dTVpkZPXxp+Nf3H/TUTBx904c19UkJzMK6EPVccxR0RP0i+hSta5xLKGbfJI89P7V5ravFdc5UYct23rtMw+5aBgBi6A0bFhnmz5k4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=E+QZGOj7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="E+QZGOj7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B14291F00898;
	Thu,  8 Oct 2026 08:51:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791449487;
	bh=9HBsK9JWrsaB9tSfr6Gh6KHk9xHWrytrLennN91BCx4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=E+QZGOj7Ry9R0+RX0ixIWYO29bD2e9nS/g09b8uihB6NY3mfwAg2JGWMCm4adYndW
	 tXaVADQVVoxNQABaq0QKTeAo/HTao57IsZCrp1D57QeHg8NdR73hb2ksTz8VTIeu1W
	 mPFAl1FYOb5Xh6+S3RZdQbF15hU1DNK+E0h6Yn/JuXBmaOrFR0sVfbdmrFw9fo39vN
	 WGi4Df/NyfOWMnv2KD5paQx+8pL7RL39bk0T9NP3qVX+Vhi0A+9Zun0RqchYsvQoZk
	 /gqaDj+9Ofd4O1f0UI8XbUmrGKpuw8xXZGyNWeFHAPdXGWSHQmA5x6sa0qDpsAn7kV
	 Gvimn4EdY4pUg==
From: Sasha Levin <sashal@kernel.org>
To: linux-api@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	linux-doc@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kbuild@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	workflows@vger.kernel.org,
	tools@kernel.org,
	x86@kernel.org,
	Thomas Gleixner <tglx@kernel.org>,
	"Paul E . McKenney" <paulmck@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Dmitry Vyukov <dvyukov@google.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	Cyril Hrubis <chrubis@suse.cz>,
	Kees Cook <kees@kernel.org>,
	Jake Edge <jake@lwn.net>,
	David Laight <david.laight.linux@gmail.com>,
	Gabriele Paoloni <gpaoloni@redhat.com>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Andrew Morton <akpm@linux-foundation.org>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Nathan Chancellor <nathan@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [PATCH v5 11/11] kernel/api: add syscall enter/exit tracepoints
Date: Thu,  8 Oct 2026 04:49:51 -0400
Message-ID: <20261008084956.2911790-12-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261008084956.2911790-1-sashal@kernel.org>
References: <20261008084956.2911790-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add two tracepoints to the CONFIG_KAPI_RUNTIME_CHECKS syscall validation
path so the framework's behavior can be observed without the noise and
loss of pr_warn_ratelimited():

  kapi_syscall_enter - the spec name, the raw argument values, and a
                       rendered "name=value" list of the specified
                       parameters (pointer-like values in hex, signed
                       integers and file descriptors in decimal)
  kapi_syscall_exit  - the spec name, the return value, and whether it
                       matched the specification (spec_match)

Both fire only for syscalls that have a KAPI specification and live
inside the existing CONFIG_KAPI_RUNTIME_CHECKS region, so they exist
exactly when the runtime checks do; they compile to no-ops without
CONFIG_TRACEPOINTS and stay dormant until enabled. The parameter list
is rendered only when the enter tracepoint is enabled.

kapi_syscall_exit is also emitted on the parameter-validation rejection
path -- where the validator returns -EINVAL and the real handler is
skipped -- with spec_match=0, so every kapi_syscall_enter has a matching
exit.

Assisted-by: LLM
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/dev-tools/kernel-api-spec.rst | 31 ++++++++
 MAINTAINERS                                 |  1 +
 include/trace/events/kapi.h                 | 74 +++++++++++++++++++
 kernel/api/kernel_api_spec.c                | 79 +++++++++++++++++----
 4 files changed, 173 insertions(+), 12 deletions(-)
 create mode 100644 include/trace/events/kapi.h

diff --git a/Documentation/dev-tools/kernel-api-spec.rst b/Documentation/dev-tools/kernel-api-spec.rst
index 95b72060f8ef8..818c9b966a0c0 100644
--- a/Documentation/dev-tools/kernel-api-spec.rst
+++ b/Documentation/dev-tools/kernel-api-spec.rst
@@ -312,6 +312,37 @@ specification. Kerneldoc annotations cannot set it, so it is only available to a
     .constraint_type = KAPI_CONSTRAINT_CUSTOM,
     .validate = validate_buffer_size,
 
+Tracepoints
+-----------
+
+When ``CONFIG_KAPI_RUNTIME_CHECKS`` is enabled, the syscall validation path emits
+two ftrace tracepoints (in the ``kapi`` trace system) for every syscall that has a
+specification:
+
+- ``kapi_syscall_enter`` -- fired before parameter validation, recording the spec
+  name, the raw syscall argument values, and -- when the spec provides parameter
+  metadata -- a rendered ``name=value`` list: signed integer and file descriptor
+  values are shown in decimal, all other values in hex, and an unnamed parameter
+  as ``arg``.
+- ``kapi_syscall_exit`` -- fired after the handler returns, or in place of the
+  handler when parameter validation rejects the call (the handler is skipped and
+  ``-EINVAL`` is returned). Records the spec name, the return value, and
+  ``spec_match``: 0 when the parameters were rejected or a successful ``fd`` return
+  was not a valid file descriptor, and 1 otherwise. Error codes missing from the
+  spec do not clear it.
+
+Unlike the ``pr_warn_ratelimited`` violation reports, the tracepoints capture every
+spec'd call rather than only violations, and can be filtered with the usual ftrace
+facilities. They require ``CONFIG_TRACEPOINTS`` and stay dormant
+until enabled::
+
+    # echo 1 > /sys/kernel/tracing/events/kapi/enable
+    # cat /sys/kernel/tracing/trace
+     ...  kapi_syscall_enter: sys_read(fd=3, buf=0x7ffd46780b58, count=0x340)
+     ...  kapi_syscall_exit: sys_read = 832 spec_match=1
+     ...  kapi_syscall_enter: sys_open(filename=0x480300, flags=268435456, mode=0x0)
+     ...  kapi_syscall_exit: sys_open = -22 spec_match=0
+
 DebugFS Interface
 =================
 
diff --git a/MAINTAINERS b/MAINTAINERS
index 1d9e55b6bf5ff..20020705921a6 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -14125,6 +14125,7 @@ S:	Maintained
 F:	Documentation/dev-tools/kernel-api-spec.rst
 F:	include/linux/kapi_syscall.h
 F:	include/linux/kernel_api_spec.h
+F:	include/trace/events/kapi.h
 F:	kernel/api/
 F:	tools/kapi/
 F:	tools/lib/python/kdoc/kdoc_apispec.py
diff --git a/include/trace/events/kapi.h b/include/trace/events/kapi.h
new file mode 100644
index 0000000000000..47828f3338828
--- /dev/null
+++ b/include/trace/events/kapi.h
@@ -0,0 +1,74 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM kapi
+
+#if !defined(_TRACE_KAPI_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _TRACE_KAPI_H
+
+#include <linux/tracepoint.h>
+
+/* Max length of the rendered "name=value, ..." parameter list. */
+#define KAPI_TP_PARAMS_LEN 256
+
+/*
+ * Emitted from the CONFIG_KAPI_RUNTIME_CHECKS syscall validation path for
+ * syscalls that have a KAPI specification: kapi_syscall_enter fires before
+ * parameter validation, kapi_syscall_exit after the handler returns.
+ * @name is the spec name, e.g. "sys_open".
+ *
+ * kapi_syscall_enter carries both the raw argument values (args[]) and, when
+ * the spec provides parameter metadata, a rendered "name=value" list (params,
+ * built by the caller): pointer-like values in hex, integers and fds in decimal.
+ */
+TRACE_EVENT(kapi_syscall_enter,
+
+	TP_PROTO(const char *name, int nargs, const s64 *args, const char *params),
+
+	TP_ARGS(name, nargs, args, params),
+
+	TP_STRUCT__entry(
+		__string(	name,	name	)
+		__field(	int,	nargs	)
+		__array(	u64,	args,	6	)
+		__string(	params,	params	)
+	),
+
+	TP_fast_assign(
+		__assign_str(name);
+		__entry->nargs = nargs;
+		memset(__entry->args, 0, sizeof(__entry->args));
+		if (args && nargs > 0)
+			memcpy(__entry->args, args,
+			       min_t(int, nargs, 6) * sizeof(__entry->args[0]));
+		__assign_str(params);
+	),
+
+	TP_printk("%s(%s)", __get_str(name), __get_str(params))
+);
+
+TRACE_EVENT(kapi_syscall_exit,
+
+	TP_PROTO(const char *name, long ret, bool spec_match),
+
+	TP_ARGS(name, ret, spec_match),
+
+	TP_STRUCT__entry(
+		__string(	name,		name		)
+		__field(	long,		ret		)
+		__field(	bool,		spec_match	)
+	),
+
+	TP_fast_assign(
+		__assign_str(name);
+		__entry->ret = ret;
+		__entry->spec_match = spec_match;
+	),
+
+	TP_printk("%s = %ld spec_match=%d",
+		  __get_str(name), __entry->ret, __entry->spec_match)
+);
+
+#endif /* _TRACE_KAPI_H */
+
+/* This part must be outside protection */
+#include <trace/define_trace.h>
diff --git a/kernel/api/kernel_api_spec.c b/kernel/api/kernel_api_spec.c
index c3b220104c04b..993674ce67789 100644
--- a/kernel/api/kernel_api_spec.c
+++ b/kernel/api/kernel_api_spec.c
@@ -751,6 +751,45 @@ EXPORT_SYMBOL_GPL(kapi_export_json);
 
 #ifdef CONFIG_KAPI_RUNTIME_CHECKS
 
+#define CREATE_TRACE_POINTS
+#include <trace/events/kapi.h>
+
+/*
+ * Render a syscall's parameters as a "name=value, ..." string for the
+ * kapi_syscall_enter tracepoint.  Names come from the spec; pointer-like
+ * values are shown in hex, integers and file descriptors in decimal.
+ */
+static void kapi_trace_format_params(const struct kernel_api_spec *spec,
+				     const s64 *args, int nargs,
+				     char *buf, size_t size)
+{
+	int i, used = 0;
+
+	buf[0] = '\0';
+	/* Bound by the caller-supplied arg count; the spec arity may differ. */
+	for (i = 0; args && i < nargs && i < 6; i++) {
+		const char *name = "arg";
+		bool dec = false;
+
+		if (i < spec->param_count) {
+			const struct kapi_param_spec *ps = &spec->params[i];
+
+			if (ps->name)
+				name = ps->name;
+			dec = ps->type == KAPI_TYPE_INT || ps->type == KAPI_TYPE_FD;
+		}
+
+		used += scnprintf(buf + used, size - used, "%s%s=",
+				  i ? ", " : "", name);
+		if (dec)
+			used += scnprintf(buf + used, size - used, "%lld",
+					  (long long)args[i]);
+		else
+			used += scnprintf(buf + used, size - used, "0x%llx",
+					  (unsigned long long)args[i]);
+	}
+}
+
 /**
  * kapi_validate_fd - Validate that a file descriptor value is in valid range
  * @fd: File descriptor to validate
@@ -1211,16 +1250,24 @@ EXPORT_SYMBOL_GPL(kapi_validate_param_with_context);
 int kapi_validate_syscall_params(const struct kernel_api_spec *spec,
 				 const s64 *params, int param_count)
 {
-	int i;
+	int i, ret = 0;
 
 	if (!spec || !params)
 		return 0;
 
+	if (trace_kapi_syscall_enter_enabled()) {
+		char pbuf[KAPI_TP_PARAMS_LEN];
+
+		kapi_trace_format_params(spec, params, param_count, pbuf, sizeof(pbuf));
+		trace_kapi_syscall_enter(spec->name, param_count, params, pbuf);
+	}
+
 	/* Validate that we have the expected number of parameters */
 	if (param_count != spec->param_count) {
 		pr_warn_ratelimited("API %s: parameter count mismatch (expected %u, got %d)\n",
 			spec->name, spec->param_count, param_count);
-		return -EINVAL;
+		ret = -EINVAL;
+		goto out;
 	}
 
 	/* Validate each parameter with context */
@@ -1230,12 +1277,22 @@ int kapi_validate_syscall_params(const struct kernel_api_spec *spec,
 		if (!kapi_validate_param_with_context(param_spec, params[i], params, param_count)) {
 			if (strncmp(spec->name, "sys_", 4) == 0) {
 				/* For syscalls, we can return EINVAL to userspace */
-				return -EINVAL;
+				ret = -EINVAL;
+				goto out;
 			}
 		}
 	}
 
-	return 0;
+out:
+	/*
+	 * Emit the exit event on the rejection path too (the wrapper
+	 * short-circuits the handler on a non-zero return), so every
+	 * kapi_syscall_enter has a matching kapi_syscall_exit.
+	 */
+	if (ret)
+		trace_kapi_syscall_exit(spec->name, ret, false);
+
+	return ret;
 }
 EXPORT_SYMBOL_GPL(kapi_validate_syscall_params);
 
@@ -1353,18 +1410,16 @@ EXPORT_SYMBOL_GPL(kapi_validate_return_value);
  */
 int kapi_validate_syscall_return(const struct kernel_api_spec *spec, s64 retval)
 {
+	bool valid = true;
+
 	if (!spec)
 		return 0;
 
-	/* Skip return validation if return spec was not defined */
-	if (spec->return_magic != KAPI_MAGIC_RETURN)
-		return 0;
+	/* Validate against the return spec when one was defined */
+	if (spec->return_magic == KAPI_MAGIC_RETURN)
+		valid = kapi_validate_return_value(spec, retval);
 
-	if (!kapi_validate_return_value(spec, retval)) {
-		/* Log the violation but don't change the return value */
-		pr_warn_ratelimited("KAPI: Syscall %s returned unspecified value %lld\n",
-				    spec->name, retval);
-	}
+	trace_kapi_syscall_exit(spec->name, retval, valid);
 
 	return 0;
 }
-- 
2.53.0

