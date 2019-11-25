From: Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH v17 08/13] namei: LOOKUP_BENEATH: O_BENEATH-like scoped
 resolution
Date: Mon, 25 Nov 2019 00:26:04 +0000
Message-ID: <20191125002604.GE4203@ZenIV.linux.org.uk>
References: <20191117011713.13032-1-cyphar@cyphar.com>
 <20191117011713.13032-9-cyphar@cyphar.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
Content-Disposition: inline
In-Reply-To: <20191117011713.13032-9-cyphar@cyphar.com>
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

On Sun, Nov 17, 2019 at 12:17:08PM +1100, Aleksa Sarai wrote:

> +	if (unlikely(nd->flags & LOOKUP_IS_SCOPED)) {
> +		/*
> +		 * Do a final check to ensure that the path didn't escape. Note
> +		 * that this should already be guaranteed by all of the other
> +		 * LOOKUP_IS_SCOPED checks (and delaying this check this late
> +		 * does open the door to some possible timing-based attacks).
> +		 */
> +		if (WARN_ON(!path_is_under(&nd->path, &nd->root)))
> +			return -EXDEV;

I don't like that.  What it gives is an ability to race that with
rename(), with user-triggered WARN_ON.  You *can't* promise that result of
lookup is in a subtree, simply because it can get moved just as you've
declared it to be in the clear.

	Anyone who relies upon that is delusional; it really can't be done.
What warranties LOOKUP_IS_SCOPED is really supposed to provide?  That we do not
attempt to walk out of the subtree rooted at the start point?  Fine, but this
is not what this test does.  What are you trying to achieve there?  If it's
"what we'd got was at one point in our subtree", the test is more or less
right, but WARN_ON isn't.
