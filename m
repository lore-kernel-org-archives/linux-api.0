From: Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH v17 11/13] open: introduce openat2(2) syscall
Date: Mon, 25 Nov 2019 00:37:24 +0000
Message-ID: <20191125003724.GG4203@ZenIV.linux.org.uk>
References: <20191117011713.13032-1-cyphar@cyphar.com>
 <20191117011713.13032-12-cyphar@cyphar.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
Content-Disposition: inline
In-Reply-To: <20191117011713.13032-12-cyphar@cyphar.com>
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
Cc: Song Liu <songliubraving@fb.com>, linux-ia64@vger.kernel.org, linux-doc@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Alexei Starovoitov <ast@kernel.org>, linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>, linux-kselftest@vger.kernel.org, sparclinux@vger.kernel.org, containers@lists.linux-foundation.org, linux-api@vger.kernel.org, Shuah Khan <shuah@kernel.org>, linux-arch@vger.kernel.org, linux-s390@vger.kernel.org, Tycho Andersen <tycho@tycho.ws>, Daniel Borkmann <daniel@iogearbox.net>, Jonathan Corbet <corbet@lwn.net>, Jiri Olsa <jolsa@redhat.com>, linux-sh@vger.kernel.org, Alexander Shishkin <alexander.shishkin@linux.intel.com>, Ingo Molnar <mingo@redhat.com>, linux-arm-kernel@lists.infradead.org, Yonghong Song <yhs@fb.com>, linux-mips@vger.kernel.org, Andrii Nakryiko <andriin@fb.com>, bpf@vger.ke
List-Id: linux-api@vger.kernel.org

On Sun, Nov 17, 2019 at 12:17:11PM +1100, Aleksa Sarai wrote:

> +/* how->upgrade flags for openat2(2). */
> +/* First bit is reserved for a future UPGRADE_NOEXEC flag. */
> +#define UPGRADE_NOREAD		0x02 /* Block re-opening with MAY_READ. */
> +#define UPGRADE_NOWRITE		0x04 /* Block re-opening with MAY_WRITE. */

I'd drop that chunk, for the lack of ->upgrade...
