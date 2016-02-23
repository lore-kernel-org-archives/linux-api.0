From: Ingo Molnar <mingo@kernel.org>
Subject: Re: [RFC][PATCH 6/7] x86, pkeys: add pkey set/get syscalls
Date: Tue, 23 Feb 2016 07:45:59 +0100
Message-ID: <20160223064559.GB21091@gmail.com>
References: <20160223011107.FB9B8215@viggo.jf.intel.com>
 <20160223011116.471AAADA@viggo.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <20160223011116.471AAADA@viggo.jf.intel.com>
Sender: owner-linux-mm@kvack.org
To: Dave Hansen <dave@sr71.net>
Cc: linux-kernel@vger.kernel.org, dave.hansen@linux.intel.com, linux-api@vger.kernel.org, linux-mm@kvack.org, x86@kernel.org, torvalds@linux-foundation.org, akpm@linux-foundation.org
List-Id: linux-api@vger.kernel.org


* Dave Hansen <dave@sr71.net> wrote:

> 
> From: Dave Hansen <dave.hansen@linux.intel.com>
> 
> This establishes two more system calls for protection key management:
> 
> 	unsigned long pkey_get(int pkey);
> 	int pkey_set(int pkey, unsigned long access_rights);
> 
> The return value from pkey_get() and the 'access_rights' passed
> to pkey_set() are the same format: a bitmask containing
> PKEY_DENY_WRITE and/or PKEY_DENY_ACCESS, or nothing set at all.
> 
> These can replace userspace's direct use of the new rdpkru/wrpkru
> instructions.
> 
> With current hardware, the kernel can not enforce that it has
> control over a given key.  But, this at least allows the kernel
> to indicate to userspace that userspace does not control a given
> protection key.  This makes it more likely that situations like
> using a pkey after sys_pkey_free() can be detected.

So it's analogous to file descriptor open()/close() syscalls: the kernel does not 
enforce that different libraries of the same process do not interfere with each 
other's file descriptors - but in practice it's not a problem because everyone 
uses open()/close().

Resources that a process uses don't per se 'need' kernel level isolation to be 
useful.

> The kernel does _not_ enforce that this interface must be used for
> changes to PKRU, whether or not a key has been "allocated".

Nor does the kernel enforce that open() must be used to get a file descriptor, so 
code can do the following:

	close(100);

and can interfere with a library that is holding a file open - but it's generally 
not a problem and the above is considered poor code that will cause problems.

One thing that is different is that file descriptors are generally plentiful, 
while of pkeys there are at most 16 - but I think it's still "large enough" to not 
be an issue in practice.

We'll see ...

> This syscall interface could also theoretically be replaced with a pair of 
> vsyscalls.  The vsyscalls would just call WRPKRU/RDPKRU directly in situations 
> where they are drop-in equivalents for what the kernel would be doing.

Indeed.

Thanks,

	Ingo

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
