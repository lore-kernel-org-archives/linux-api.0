From: Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH v16 09/12] namei: LOOKUP_{IN_ROOT,BENEATH}: permit
 limited ".." resolution
Date: Sat, 16 Nov 2019 01:03:27 +0000
Message-ID: <20191116010327.GZ26530@ZenIV.linux.org.uk>
References: <20191116002802.6663-1-cyphar@cyphar.com>
 <20191116002802.6663-10-cyphar@cyphar.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
Content-Disposition: inline
In-Reply-To: <20191116002802.6663-10-cyphar@cyphar.com>
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
Cc: Song Liu <songliubraving@fb.com>, linux-ia64@vger.kernel.org, linux-sh@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Alexei Starovoitov <ast@kernel.org>, linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>, linux-kselftest@vger.kernel.org, sparclinux@vger.kernel.org, containers@lists.linux-foundation.org, Christian Brauner <christian.brauner@ubuntu.com>, linux-api@vger.kernel.org, Shuah Khan <shuah@kernel.org>, linux-arch@vger.kernel.org, linux-s390@vger.kernel.org, Tycho Andersen <tycho@tycho.ws>, Daniel Borkmann <daniel@iogearbox.net>, Jiri Olsa <jolsa@redhat.com>, Alexander Shishkin <alexander.shishkin@linux.intel.com>, Ingo Molnar <mingo@redhat.com>, linux-arm-kernel@lists.infradead.org, Yonghong Song <yhs@fb.com>, linux-mips@vger.kernel.org, Andrii Nakryiko <andriin@fb.com>, bpf@vger.kernel.orgl
List-Id: linux-api@vger.kernel.org

On Sat, Nov 16, 2019 at 11:27:59AM +1100, Aleksa Sarai wrote:

> +		if (unlikely(nd->flags & LOOKUP_IS_SCOPED)) {
> +			bool m_retry = read_seqretry(&mount_lock, nd->m_seq);
> +			bool r_retry = read_seqretry(&rename_lock, nd->r_seq);
> +
> +			/*
> +			 * If there was a racing rename or mount along our
> +			 * path, then we can't be sure that ".." hasn't jumped
> +			 * above nd->root (and so userspace should retry or use
> +			 * some fallback).
> +			 */
> +			if (unlikely(m_retry || r_retry))
> +				return -EAGAIN;
> +		}
>  	}
>  	return 0;

Elaborate...  Do these boolean variables make any sense now, really?
