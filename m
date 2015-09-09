From: Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>
Subject: Re: [PATCH v3] Cleanup: membarrier selftest
Date: Wed, 09 Sep 2015 18:36:44 +1000
Message-ID: <1441787804.4703.2.camel@ellerman.id.au>
References: <1441745890-25852-1-git-send-email-mathieu.desnoyers@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1441745890-25852-1-git-send-email-mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Pranith Kumar <bobby.prani-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Tue, 2015-09-08 at 16:58 -0400, Mathieu Desnoyers wrote:
> We don't need to specify an explicit rule in the Makefile, the implicit
> one will do the same. The "__EXPORTED_HEADERS__" define is not needed,
> because we build the test against the installed kernel headers, not the
> in-tree kernel headers. Re-use "$(TEST_PROGS)" in the clean target
> rather than spelling the executable name twice. Include <unistd.h>
> rather than the rather specific <asm-generic/unistd.h>. Include
> <syscall.h> rather than <sys/syscall.h>. In both cases, the former
> header is located in a standard location and includes the latter.
> 
> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
> CC: Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>
> CC: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
> CC: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> CC: Pranith Kumar <bobby.prani-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> CC: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
> --
> Changes since v2:
> - Refine Changelog, removing references to comments, taking care
>   of comments from Shuah Khan.
> Changes since v1:
> - Add Changelog.
> Changes since RFC:
> - Take care of comments from Michael Ellerman.

Looks great, thanks.

Acked-by: Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>

cheers
