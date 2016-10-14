From: Dave Hansen <dave.hansen@intel.com>
Subject: Re: pkeys: Remove easily triggered WARN
Date: Fri, 14 Oct 2016 12:16:57 -0700
Message-ID: <58012F29.8040307@intel.com>
References: <20161014182624.4yzw36n4hd7x56wi@codemonkey.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20161014182624.4yzw36n4hd7x56wi@codemonkey.org.uk>
Sender: owner-linux-mm@kvack.org
To: Dave Jones <davej@codemonkey.org.uk>
Cc: linux-arch@vger.kernel.org, mgorman@techsingularity.net, arnd@arndb.de, linux-api@vger.kernel.org, linux-mm@kvack.org, luto@kernel.org, akpm@linux-foundation.org, torvalds@linux-foundation.org
List-Id: linux-api@vger.kernel.org

On 10/14/2016 11:26 AM, Dave Jones wrote:
> This easy-to-trigger warning shows up instantly when running
> Trinity on a kernel with CONFIG_X86_INTEL_MEMORY_PROTECTION_KEYS disabled.
> 
> At most this should have been a printk, but the -EINVAL alone should be more
> than adequate indicator that something isn't available.

Urg, thanks for the patch.  It's obviously correct, of course.

Acked-by: Dave Hansen <dave.hansen@intel.com>

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
