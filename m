From: Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH v3 07/11] arm64/tracing: fix compat syscall handling
Date: Wed, 12 Oct 2016 11:04:04 +0100
Message-ID: <20161012100404.GD32032@arm.com>
References: <1476182576-15247-1-git-send-email-marcin.nowakowski@imgtec.com>
 <1476182576-15247-8-git-send-email-marcin.nowakowski@imgtec.com>
 <20161011133623.GE9532@arm.com>
 <fed0151c-ebfd-18d2-939c-21e315dc7584@imgtec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <fed0151c-ebfd-18d2-939c-21e315dc7584@imgtec.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Marcin Nowakowski <marcin.nowakowski@imgtec.com>
Cc: linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, rostedt@goodmis.org, luto@amacapital.net, Ingo Molnar <mingo@redhat.com>, Catalin Marinas <catalin.marinas@arm.com>, linux-arm-kernel@lists.infradead.org
List-Id: linux-api@vger.kernel.org

On Wed, Oct 12, 2016 at 09:07:03AM +0200, Marcin Nowakowski wrote:
> On 11.10.2016 15:36, Will Deacon wrote:
> >On Tue, Oct 11, 2016 at 12:42:52PM +0200, Marcin Nowakowski wrote:
> >>diff --git a/arch/arm64/include/asm/unistd.h b/arch/arm64/include/asm/unistd.h
> >>index e78ac26..276d049 100644
> >>--- a/arch/arm64/include/asm/unistd.h
> >>+++ b/arch/arm64/include/asm/unistd.h
> >>@@ -45,6 +45,7 @@
> >> #define __ARM_NR_compat_set_tls		(__ARM_NR_COMPAT_BASE+5)
> >>
> >> #define __NR_compat_syscalls		394
> >>+#define NR_compat_syscalls (__NR_compat_syscalls)
> >
> >We may as well just define NR_compat_syscalls instead of
> >__NR_compat_syscalls and move the handful of users over.
> 
> I had tried to minimise the amount of arch-specific changes here -
> especially those that are not directly related to the proposed syscall
> handling change. But I agree having these 2 #defines is a bit unnecessary

There's only three users of __NR_compat_syscalls, so I think you can
move them over.

> >>diff --git a/arch/arm64/kernel/ftrace.c b/arch/arm64/kernel/ftrace.c
> >>index 40ad08a..75d010f 100644
> >>--- a/arch/arm64/kernel/ftrace.c
> >>+++ b/arch/arm64/kernel/ftrace.c
> >>@@ -176,4 +176,20 @@ int ftrace_disable_ftrace_graph_caller(void)
> >> 	return ftrace_modify_graph_caller(false);
> >> }
> >> #endif /* CONFIG_DYNAMIC_FTRACE */
> >>+
> >> #endif /* CONFIG_FUNCTION_GRAPH_TRACER */
> >>+
> >>+#if (defined CONFIG_FTRACE_SYSCALLS) && (defined CONFIG_COMPAT)
> >>+
> >>+extern const void *sys_call_table[];
> >>+extern const void *compat_sys_call_table[];
> >>+
> >>+unsigned long __init arch_syscall_addr(int nr, bool compat)
> >>+{
> >>+	if (compat)
> >>+		return (unsigned long)compat_sys_call_table[nr];
> >>+
> >>+	return (unsigned long)sys_call_table[nr];
> >>+}
> >
> >Do we care about the compat private syscalls (from base 0x0f0000)? We
> >need to make sure that we exhibit the same behaviour as a native
> >32-bit ARM machine.
> >
> >Will
> 
> Tracing of such syscalls has been disabled for a long time (see
> http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=086ba77a6db0).
> Apart from using non-contiguous numbers, they are not defined using standard
> SYSCALL macros, so they do not have any metadata generated either.
> My suggestion is that if you wanted those to be included in the trace then
> it should be done separately from these changes.

Fine by me -- I just wanted to make sure our compat behaviour matched
the behaviour of native arch/arm/. It sounds like it does, so no need to
change anything here.

Acked-by: Will Deacon <will.deacon@arm.com>

Will
