From: Dave Hansen <dave@sr71.net>
Subject: Re: [PATCH 7/8] pkeys: add details of system call use to
 Documentation/
Date: Wed, 1 Jun 2016 10:10:36 -0700
Message-ID: <574F170C.7060302@sr71.net>
References: <20160531152814.36E0B9EE@viggo.jf.intel.com>
 <20160531152824.2B18E890@viggo.jf.intel.com>
 <20160601104333.7c2014fa@lwn.net> <574F114F.8010701@sr71.net>
 <20160601104937.098a89a2@lwn.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20160601104937.098a89a2@lwn.net>
Sender: owner-linux-mm@kvack.org
To: Jonathan Corbet <corbet@lwn.net>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, linux-api@vger.kernel.org, linux-arch@vger.kernel.org, linux-mm@kvack.org, torvalds@linux-foundation.org, akpm@linux-foundation.org, dave.hansen@linux.intel.com
List-Id: linux-api@vger.kernel.org

On 06/01/2016 09:49 AM, Jonathan Corbet wrote:
>> > +	sys_pkey_alloc(0, PKEY_DISABLE_WRITE | PKEY_DISABLE_READ);
>> > +	sys_pkey_mprotect(ptr, size, PROT_READ|PROT_WRITE);
>> > +	something(ptr);
> That should, IMO, be something like:
> 
> 	key = pkey_alloc(...);
> 	pkey_mprotect(ptr, size, PROT_READ|PROT_WRITE, key);

That is true as well.  I'll fix that up as well.

Thanks for taking a look!

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
