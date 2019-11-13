From: Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH v15 4/9] namei: LOOKUP_BENEATH: O_BENEATH-like scoped
 resolution
Date: Wed, 13 Nov 2019 01:55:34 +0000
Message-ID: <20191113015534.GA26530@ZenIV.linux.org.uk>
References: <20191105090553.6350-1-cyphar@cyphar.com>
 <20191105090553.6350-5-cyphar@cyphar.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <20191105090553.6350-5-cyphar@cyphar.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Aleksa Sarai <cyphar@cyphar.com>
Cc: linux-ia64@vger.kernel.org, linux-sh@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Alexei Starovoitov <ast@kernel.org>, linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>, linux-kselftest@vger.kernel.org, sparclinux@vger.kernel.org, Christian Brauner <christian.brauner@ubuntu.com>, Shuah Khan <shuah@kernel.org>, linux-arch@vger.kernel.org, linux-s390@vger.kernel.org, Tycho Andersen <tycho@tycho.ws>, Aleksa Sarai <asarai@suse.de>, Jiri Olsa <jolsa@redhat.com>, Alexander Shishkin <alexander.shishkin@linux.intel.com>, Ingo Molnar <mingo@redhat.com>, linux-arm-kernel@lists.infradead.org, linux-mips@vger.kernel.org, linux-xtensa@linux-xtensa.org, Kees Cook <keescook@chromium.org>, Arnd Bergmann <arnd@arndb.de>, Jann Horn <jannh@google.com>, linuxppc-dev@lists.ozlabs.org, linux-m68k@lists.linux-m68k.orgAn
List-Id: linux-api@vger.kernel.org

On Tue, Nov 05, 2019 at 08:05:48PM +1100, Aleksa Sarai wrote:

Minor nit here - I'd split "move the conditional call of set_root()
into nd_jump_root()" into a separate patch before that one.  Makes
for fewer distractions in this one.  I'd probably fold "and be
ready for errors other than -ECHILD" into the same preliminary
patch.

> +			/* Not currently safe for scoped-lookups. */
> +			if (unlikely(nd->flags & LOOKUP_IS_SCOPED))
> +				return ERR_PTR(-EXDEV);

Also a candidate for doing in nd_jump_link()...

> @@ -1373,8 +1403,11 @@ static int follow_dotdot_rcu(struct nameidata *nd)
>  	struct inode *inode = nd->inode;
>  
>  	while (1) {
> -		if (path_equal(&nd->path, &nd->root))
> +		if (path_equal(&nd->path, &nd->root)) {
> +			if (unlikely(nd->flags & LOOKUP_BENEATH))
> +				return -EXDEV;

Umm...  Are you sure it's not -ECHILD?
