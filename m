From: Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH v17 10/13] namei: LOOKUP_{IN_ROOT,BENEATH}: permit
 limited ".." resolution
Date: Mon, 25 Nov 2019 00:35:01 +0000
Message-ID: <20191125003501.GF4203@ZenIV.linux.org.uk>
References: <20191117011713.13032-1-cyphar@cyphar.com>
 <20191117011713.13032-11-cyphar@cyphar.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
Content-Disposition: inline
In-Reply-To: <20191117011713.13032-11-cyphar@cyphar.com>
List-Unsubscribe: <https://lists.ozlabs.org/options/linuxppc-dev>,
 <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=unsubscribe>
List-Archive: <http://lists.ozlabs.org/pipermail/linuxppc-dev/>
List-Post: <mailto:linuxppc-dev@lists.ozlabs.org>
List-Help: <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=help>
List-Subscribe: <https://lists.ozlabs.org/listinfo/linuxppc-dev>,
 <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=subscribe>
Errors-To: linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org
Sender: "Linuxppc-dev"
 <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
To: Aleksa Sarai <cyphar@cyphar.com>
Cc: Song Liu <songliubraving@fb.com>, linux-ia64@vger.kernel.org, linux-doc@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Alexei Starovoitov <ast@kernel.org>, linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>, linux-kselftest@vger.kernel.org, sparclinux@vger.kernel.org, containers@lists.linux-foundation.org, Christian Brauner <christian.brauner@ubuntu.com>, linux-api@vger.kernel.org, Shuah Khan <shuah@kernel.org>, linux-arch@vger.kernel.org, linux-s390@vger.kernel.org, Tycho Andersen <tycho@tycho.ws>, Daniel Borkmann <daniel@iogearbox.net>, Jonathan Corbet <corbet@lwn.net>, Jiri Olsa <jolsa@redhat.com>, linux-sh@vger.kernel.org, Alexander Shishkin <alexander.shishkin@linux.intel.com>, Ingo Molnar <mingo@redhat.com>, linux-arm-kernel@lists.infradead.org, Yonghong Song <yhs@fb.com>, linux-mips@vger.kernel.o
List-Id: linux-api@vger.kernel.org

On Sun, Nov 17, 2019 at 12:17:10PM +1100, Aleksa Sarai wrote:
> +		if (unlikely(nd->flags & LOOKUP_IS_SCOPED)) {
> +			/*
> +			 * If there was a racing rename or mount along our
> +			 * path, then we can't be sure that ".." hasn't jumped
> +			 * above nd->root (and so userspace should retry or use
> +			 * some fallback).
> +			 */
> +			if (unlikely(read_seqretry(&mount_lock, nd->m_seq)))
> +				return -EAGAIN;
> +			if (unlikely(read_seqretry(&rename_lock, nd->r_seq)))
> +				return -EAGAIN;
> +		}

Looks like excessive barriers to me - it's
	rmb
	check mount_lock.sequence
	rmb
	check rename_lock.sequence

> @@ -2266,6 +2274,10 @@ static const char *path_init(struct nameidata *nd, unsigned flags)
>  	nd->last_type = LAST_ROOT; /* if there are only slashes... */
>  	nd->flags = flags | LOOKUP_JUMPED | LOOKUP_PARENT;
>  	nd->depth = 0;
> +
> +	nd->m_seq = read_seqbegin(&mount_lock);
> +	nd->r_seq = read_seqbegin(&rename_lock);

Same here, pretty much (fetch/rmb/fetch/rmb)
