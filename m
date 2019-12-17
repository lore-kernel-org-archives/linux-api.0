From: Dominique Martinet <asmadeus@codewreck.org>
Subject: Re: statx struct's stx_size pointer compatibility with
 uint64_t/size_t
Date: Tue, 17 Dec 2019 17:53:50 +0100
Message-ID: <20191217165350.GA10729@nautica>
References: <87r213aykv.fsf@oldenburg2.str.redhat.com>
 <20191217152154.GB25518@nautica>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <libc-alpha-return-108151-glibc-alpha=m.gmane.org@sourceware.org>
List-Unsubscribe: <mailto:libc-alpha-unsubscribe-glibc-alpha=m.gmane.org@sourceware.org>
List-Subscribe: <mailto:libc-alpha-subscribe@sourceware.org>
List-Archive: <http://sourceware.org/ml/libc-alpha/>
List-Post: <mailto:libc-alpha@sourceware.org>
List-Help: <mailto:libc-alpha-help@sourceware.org>, <http://sourceware.org/ml/#faqs>
Sender: libc-alpha-owner@sourceware.org
Content-Disposition: inline
In-Reply-To: <20191217152154.GB25518@nautica>
To: linux-api@vger.kernel.org, libc-alpha@sourceware.org
Cc: Quentin Bouget <quentin.bouget@cea.fr>, Jeff Layton <jlayton@kernel.org>, David Howells <dhowells@redhat.com>, Florian Weimer <fweimer@redhat.com>
List-Id: linux-api@vger.kernel.org

Dominique Martinet wrote on Tue, Dec 17, 2019:
> Florian Weimer wrote on Tue, Dec 17, 2019:
> > I do not know why the kernel definition of __u64 does not follow that
> > of uint64_t in <stdint.h> (or why we even have that __u64 type), and
> > whether the kernel definition can be changed at this point.  We can
> > fix this issue with preprocessor magic, but I am not entirely sure if
> > this is a good idea.

Looking at this from a kernel's point of view, it looks like there
really was a will to simplify 64-bit ints handling over all arches and
have them all define 64-bit ints as long long a few years back.

See for example linux commit 0c79a8e29 ("asm/types.h: Remove
include/asm-generic/int-l64.h")[1] that describes the removal of '64bit
ints as long' there.

[1] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=0c79a8e29b5fcbcbfd611daf9d500cfad8370fcf


This makes sense to me to avoid multiplying header files for the
different arches, so if anything I would be tempted to ask 'why is
stdint.h uint64_t defined with just long'? -- although from what I see,
musl and uClibc both also define it as just long so there must also be
some logic in using the smallest possible type that fits?

If someone happens to know why then perhaps the same reason could also
make sense with the kernel, I don't know. Tricky, as you pointed out...

(size_t is another issue and I agree it's best not to rely on it being
64 bits long anyway)



Thanks,
-- 
Dominique
