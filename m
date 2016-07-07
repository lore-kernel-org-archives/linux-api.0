From: Mel Gorman <mgorman@techsingularity.net>
Subject: Re: [PATCH 1/9] x86, pkeys: add fault handling for PF_PK page fault
 bit
Date: Thu, 7 Jul 2016 15:40:27 +0100
Message-ID: <20160707144027.GX11498@techsingularity.net>
References: <20160707124719.3F04C882@viggo.jf.intel.com>
 <20160707124720.6E0DC397@viggo.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <20160707124720.6E0DC397@viggo.jf.intel.com>
Sender: owner-linux-mm@kvack.org
To: Dave Hansen <dave@sr71.net>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, linux-api@vger.kernel.org, linux-arch@vger.kernel.org, linux-mm@kvack.org, torvalds@linux-foundation.org, akpm@linux-foundation.org, dave.hansen@linux.intel.com, arnd@arndb.de, hughd@google.com, viro@zeniv.linux.org.uk
List-Id: linux-api@vger.kernel.org

On Thu, Jul 07, 2016 at 05:47:20AM -0700, Dave Hansen wrote:
> 
> From: Dave Hansen <dave.hansen@linux.intel.com>
> 
> PF_PK means that a memory access violated the protection key
> access restrictions.  It is unconditionally an access_error()
> because the permissions set on the VMA don't matter (the PKRU
> value overrides it), and we never "resolve" PK faults (like
> how a COW can "resolve write fault).
> 
> Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>

An access fault gets propgated as SEGV_PKUERR. What happens if glibc
does not recognise it?

-- 
Mel Gorman
SUSE Labs

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
