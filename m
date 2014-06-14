From: Rich Felker <dalias@libc.org>
Subject: Re: [RFC 0/2] __vdso_findsym
Date: Sat, 14 Jun 2014 17:30:00 -0400
Message-ID: <20140614213000.GO179@brightrain.aerifal.cx>
References: <cover.1402769596.git.luto@amacapital.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <cover.1402769596.git.luto@amacapital.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@amacapital.net>
Cc: Russ Cox <rsc@golang.org>, linux-api@vger.kernel.org, Ian Taylor <iant@golang.org>, linux-kernel@vger.kernel.org, X86 ML <x86@kernel.org>
List-Id: linux-api@vger.kernel.org

On Sat, Jun 14, 2014 at 11:16:42AM -0700, Andy Lutomirski wrote:
> The idea is to add AT_VDSO_FINDSYM pointing at __vdso_findsym.  This
> implements __vdso_findsym.
> 
> This would make it easier for runtimes that don't otherwise implement
> ELF loaders to use the vdso.
> 
> Thoughts?
> 
> If people like the basic concept, I'll finish it, write up
> documentation and a selftest.  If people don't like it, I'll drop it.

I like the idea. I don't think it's immediately useful, since
libraries wanting to use vdso will likely want to support older
kernels that don't yet have this, and thus need to include their own
vdso parsing code. However, if we could get this in now, it would be
very useful a few years down the line where optimizing for old kernels
is not an important goal. I'd certainly like to be able to drop the
ELF parsing code from musl to reduce static binary size. And I could
see other projects possibly using it just to avoid the issue of ever
adding ELF parsing code in the first place.

Rich
