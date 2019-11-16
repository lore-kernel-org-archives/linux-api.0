From: Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH v16 06/12] namei: LOOKUP_NO_XDEV: block mountpoint crossing
Date: Sat, 16 Nov 2019 01:01:44 +0000
Message-ID: <20191116010144.GY26530@ZenIV.linux.org.uk>
References: <20191116002802.6663-1-cyphar@cyphar.com>
 <20191116002802.6663-7-cyphar@cyphar.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
Content-Disposition: inline
In-Reply-To: <20191116002802.6663-7-cyphar@cyphar.com>
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

On Sat, Nov 16, 2019 at 11:27:56AM +1100, Aleksa Sarai wrote:

> @@ -1383,6 +1398,8 @@ static int follow_dotdot_rcu(struct nameidata *nd)
>  				return -ECHILD;
>  			if (&mparent->mnt == nd->path.mnt)
>  				break;
> +			if (unlikely(nd->flags & LOOKUP_NO_XDEV))
> +				return -EXDEV;
>  			/* we know that mountpoint was pinned */
>  			nd->path.dentry = mountpoint;
>  			nd->path.mnt = &mparent->mnt;
> @@ -1397,6 +1414,8 @@ static int follow_dotdot_rcu(struct nameidata *nd)
>  			return -ECHILD;
>  		if (!mounted)
>  			break;
> +		if (unlikely(nd->flags & LOOKUP_NO_XDEV))
> +			return -EXDEV;
>  		nd->path.mnt = &mounted->mnt;
>  		nd->path.dentry = mounted->mnt.mnt_root;
>  		inode = nd->path.dentry->d_inode;

I really don't think we should return hard errors from that function.
Let the caller redo it in refwalk mode.

It's not the fast path, especially for this kind of errors.  Matter of
fact, I'm not sure about -ENOENT returned in another failure case
there - it's probably OK, but again, -ECHILD would be just as good.
