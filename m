From: David Howells <dhowells@redhat.com>
Subject: Re: statx struct's stx_size pointer compatibility with uint64_t/size_t
Date: Tue, 17 Dec 2019 18:17:59 +0000
Message-ID: <2919.1576606679@warthog.procyon.org.uk>
References: <20191217165350.GA10729@nautica> <87r213aykv.fsf@oldenburg2.str.redhat.com> <20191217152154.GB25518@nautica>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <libc-alpha-return-108155-glibc-alpha=m.gmane.org@sourceware.org>
List-Unsubscribe: <mailto:libc-alpha-unsubscribe-glibc-alpha=m.gmane.org@sourceware.org>
List-Subscribe: <mailto:libc-alpha-subscribe@sourceware.org>
List-Archive: <http://sourceware.org/ml/libc-alpha/>
List-Post: <mailto:libc-alpha@sourceware.org>
List-Help: <mailto:libc-alpha-help@sourceware.org>, <http://sourceware.org/ml/#faqs>
Sender: libc-alpha-owner@sourceware.org
In-Reply-To: <20191217165350.GA10729@nautica>
Content-ID: <2918.1576606679.1@warthog.procyon.org.uk>
To: Dominique Martinet <asmadeus@codewreck.org>
Cc: dhowells@redhat.com, linux-api@vger.kernel.org, libc-alpha@sourceware.org, Quentin Bouget <quentin.bouget@cea.fr>, Jeff Layton <jlayton@kernel.org>, Florian Weimer <fweimer@redhat.com>
List-Id: linux-api@vger.kernel.org

Dominique Martinet <asmadeus@codewreck.org> wrote:

> Looking at this from a kernel's point of view, it looks like there
> really was a will to simplify 64-bit ints handling over all arches and
> have them all define 64-bit ints as long long a few years back.

Think printk() too.  Do you use "%lu", "%Lu" or "%llu"?  It's a lot easier if
__u64 is consistently unsigned long long - then it's always "%llu".

The problem with defining it as "unsigned long" on some platforms and
"unsigned long long" on others is that you're guaranteed warnings on one arch
or another.

David
