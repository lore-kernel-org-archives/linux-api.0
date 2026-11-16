Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794872203;
	b=LTLAdsdLXqKxunAOs/L0cJ6yeSaTleregEXm3nHll0YWYY7VGfX0dUhzkVeSmfCbcYrr
	 76MWlxI+F5FC39rzIZVkb6i34zpoTY3Pu8DBtCMLhOHGHn7JQFjp/22XCBdkygt4HOljo
	 mlUvrMsOD+yFC9OEgYSEYA5M6vbKYTNP0TsjpZJOuBJWapF0Bu/wruZjRAM/RAwz/Ha0W
	 1UUxg3TAqijGhUUOF1OGOHSkTnpUdXzEuqUejaVneH1TU6o0UvnePqKUbXueON7Q7sXQn
	 ddRL53iugp/Cvx1Z6pwh4jkR660V+pwTlU/IPwkzXSqoqJjXRYbhutjSQl34+6xsKtA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794872203;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-Id:
	 In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=SqY9CO3fEYEagBoh62ysw+i10UsVB9Z68o/EjIOaJHg=;
	b=ZuHjS9d+modIb7gzXqtZeMHWYULLQupVxoI+xnp49yx8nahZZ4oPE3n1zKgm9RosrZOV
	 S2Hba3Eu/w1fOCKW7Bxib0015qMtLfK32vdoPNdOxkbKFBmydVdrN+kmxhZTWYVQAH5FA
	 RRscaF8C1vFooJ4STWBlM+TvOpNzLqDHqxsILNWgwpiZILyMuHT214HHVY71LOcbj0LTC
	 ytxUusKMS/iuRIPP4UGaRGVL9F3JeNTp86KNfoZtwuPgO8/vrfCK9LDJ9hoY0Ji+UZa/J
	 8nNS71Pg65KGiSxBs9lxcA96IeGc0Ofg5w/NFDZtjXQH39kKhdA4Zfi2m+1rn5GF9qQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=mC+IXjY2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81046606A31C;
	Mon, 16 Nov 2026 23:36:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=mC+IXjY2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D11F1F000C4;
	Mon, 16 Nov 2026 23:36:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794872202;
	bh=SqY9CO3fEYEagBoh62ysw+i10UsVB9Z68o/EjIOaJHg=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=mC+IXjY26Sewr12LP9oiVQl8fdcKTbMh/ZgHnYk6C7FV8CJvIftp5pAasuEFPKGDL
	 Cq9nHkcS0VbWh5goVYlc/J9VpPntZfg+weOwdBiA2ZRBK36K+quwAkx4KNkxdI5hLR
	 uP+fsfNAzRRwjMDHVxOhu85tticamOAkrib+e8ws=
Date: Mon, 16 Nov 2026 15:36:42 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Renzo Davoli <renzo@cs.unibo.it>
Cc: linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>,
 "Dmitry V . Levin" <ldv@strace.io>, Alexey Gladkov <legion@kernel.org>,
 Eugene Syromyatnikov <evgsyr@gmail.com>, Charlie Jenkins
 <thecharlesjenkins@gmail.com>, Bradley Morgan <bradley.morgan@linux.dev>,
 Shuah Khan <shuah@kernel.org>, strace-devel@lists.strace.io,
 linux-api@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v4 2/2] selftests/ptrace: check that
 PTRACE_SET_SYSCALL_INFO rejects invalid error values
Message-Id: <20261116153642.a8dddc43f53fed0402283dfa@linux-foundation.org>
In-Reply-To: <20261116134050.505355-3-renzo@cs.unibo.it>
References: <20261116134050.505355-1-renzo@cs.unibo.it>
	<20261116134050.505355-3-renzo@cs.unibo.it>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 16 Nov 2026 14:40:46 +0100 Renzo Davoli <renzo@cs.unibo.it> wrote:

> At every exit stop of the set_syscall_info test, try to set with
> is_error set a few values outside [-MAX_ERRNO, -1], check that
> PTRACE_SET_SYSCALL_INFO fails with ERANGE and that the return value
> of the system call is left untouched.

Thanks.

LLM suggested a little fixup here, please check.



From: Andrew Morton <akpm@linux-foundation.org>
Subject: selftests/ptrace: test the lowest valid syscall error
Date: Mon, 16 Nov 2026 22:27:14 +0000

PTRACE_SET_SYSCALL_INFO must reject values below -MAX_ERRNO while
accepting -MAX_ERRNO itself. Name the bound locally for this userspace
selftest, and add a successful exit-stop case at that boundary. Retain
the existing -EISDIR case. The tracee checks the resulting errno.

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Renzo Davoli <renzo@cs.unibo.it>

 tools/testing/selftests/ptrace/set_syscall_info.c |   25 +++++++++++-
 1 file changed, 24 insertions(+), 1 deletion(-)

--- a/tools/testing/selftests/ptrace/set_syscall_info.c~selftests-ptrace-check-that-ptrace_set_syscall_info-rejects-invalid-error-values-fix
+++ a/tools/testing/selftests/ptrace/set_syscall_info.c
@@ -15,6 +15,8 @@
 #include <linux/types.h>
 #include <linux/ptrace.h>
 
+#define MAX_ERRNO 4095
+
 #if defined(_MIPS_SIM) && _MIPS_SIM == _MIPS_SIM_NABI32
 /*
  * MIPS N32 is the only architecture where __kernel_ulong_t
@@ -131,7 +133,7 @@ static const long long bad_error_rval[]
 	0,
 	1,
 	ESRCH,
-	-4095 - 1,	/* -MAX_ERRNO - 1 */
+	-MAX_ERRNO - 1,
 	-2147483647LL - 1,
 #if __SIZEOF_LONG__ > 4
 	0x100000000LL,
@@ -325,6 +327,27 @@ TEST(set_syscall_info)
 			}
 		},
 
+		/* change scno, change non-error rval to -MAX_ERRNO */
+		{
+			{
+				{
+					__NR_chdir,
+					{
+						dummy[0], dummy[1], dummy[2],
+						dummy[3], dummy[4], dummy[5]
+					}
+				}, {
+					__NR_getppid,
+					{
+						dummy[0], dummy[1], dummy[2],
+						dummy[3], dummy[4], dummy[5]
+					}
+				}
+			}, {
+				{ 0, tracer_pid }, { 1, -MAX_ERRNO }
+			}
+		},
+
 		/* change scno and all args, change non-error rval */
 		{
 			{
_

