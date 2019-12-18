From: Florian Weimer <fweimer@redhat.com>
Subject: Re: statx struct's stx_size pointer compatibility with uint64_t/size_t
Date: Wed, 18 Dec 2019 12:51:26 +0100
Message-ID: <87mubp26o1.fsf@oldenburg2.str.redhat.com>
References: <87r213aykv.fsf@oldenburg2.str.redhat.com>
	<20191217152154.GB25518@nautica> <20191217165350.GA10729@nautica>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <libc-alpha-return-108192-glibc-alpha=m.gmane.org@sourceware.org>
List-Unsubscribe: <mailto:libc-alpha-unsubscribe-glibc-alpha=m.gmane.org@sourceware.org>
List-Subscribe: <mailto:libc-alpha-subscribe@sourceware.org>
List-Archive: <http://sourceware.org/ml/libc-alpha/>
List-Post: <mailto:libc-alpha@sourceware.org>
List-Help: <mailto:libc-alpha-help@sourceware.org>, <http://sourceware.org/ml/#faqs>
Sender: libc-alpha-owner@sourceware.org
In-Reply-To: <20191217165350.GA10729@nautica> (Dominique Martinet's message of
	"Tue, 17 Dec 2019 17:53:50 +0100")
To: Dominique Martinet <asmadeus@codewreck.org>
Cc: linux-api@vger.kernel.org, libc-alpha@sourceware.org, Quentin Bouget <quentin.bouget@cea.fr>, Jeff Layton <jlayton@kernel.org>, David Howells <dhowells@redhat.com>
List-Id: linux-api@vger.kernel.org

* Dominique Martinet:

> This makes sense to me to avoid multiplying header files for the
> different arches, so if anything I would be tempted to ask 'why is
> stdint.h uint64_t defined with just long'?

It's not a compiler-provided header.  When it was added to glibc in the
90s, I don't think long long support was universal among 64-bit
compilers, and you could not just drop the type (which might have been
acceptable on 32-bit architectures).

Anyway, looking at this, it looks like we should define struct statx
with unsigned long long int in our copy instead of uint64_t.  I filed
bug 25292 to track this.  I guess it's just another thing to keep in
mind when adding system call support to glibc headers.

Thanks,
Florian
