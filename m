From: Dave Hansen <dave@sr71.net>
Subject: Re: [PATCH 5/8] x86, pkeys: allocation/free syscalls
Date: Thu, 2 Jun 2016 14:10:33 -0700
Message-ID: <5750A0C9.7060409@sr71.net>
References: <20160531152814.36E0B9EE@viggo.jf.intel.com>
 <20160531152822.FE8D405E@viggo.jf.intel.com> <5864297.Wx4gj9qW7E@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <5864297.Wx4gj9qW7E@wuerfel>
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, linux-api@vger.kernel.org, linux-arch@vger.kernel.org, linux-mm@kvack.org, torvalds@linux-foundation.org, akpm@linux-foundation.org, dave.hansen@linux.intel.com
List-Id: linux-api@vger.kernel.org

On 06/01/2016 01:48 PM, Arnd Bergmann wrote:
>> +330    common  pkey_alloc              sys_pkey_alloc
>> > +331    common  pkey_free               sys_pkey_free
>> >  
>> >  #
>> >  # x32-specific system call numbers start at 512 to avoid cache impact
>> > 
> Could you also add the system call numbers to
> include/uapi/asm-generic/unistd.h at the same time?

Yep, I can do that.  I'll add it to my next series that I post.
