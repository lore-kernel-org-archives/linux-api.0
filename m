From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [PATCH 0/9] [v3] System Calls for Memory Protection Keys
Date: Thu, 30 Jun 2016 10:40:17 -0700
Message-ID: <CALCETrUgYxT7ts1HAtL6_49BY1N=FqzO1VDBHJZiG_=kBYHxRg@mail.gmail.com>
References: <20160609000117.71AC7623@viggo.jf.intel.com> <20160630094123.GA29268@gmail.com>
 <57754CEA.6070900@sr71.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <57754CEA.6070900@sr71.net>
Sender: owner-linux-mm@kvack.org
To: Dave Hansen <dave@sr71.net>
Cc: Ingo Molnar <mingo@kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, X86 ML <x86@kernel.org>, Linux API <linux-api@vger.kernel.org>, linux-arch <linux-arch@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>, Arnd Bergmann <arnd@arndb.de>, Al Viro <viro@zeniv.linux.org.uk>, Mel Gorman <mgorman@techsingularity.net>, Hugh Dickins <hughd@google.com>
List-Id: linux-api@vger.kernel.org

On Thu, Jun 30, 2016 at 9:46 AM, Dave Hansen <dave@sr71.net> wrote:
> On 06/30/2016 02:41 AM, Ingo Molnar wrote:
>> * Dave Hansen <dave@sr71.net> wrote:
>>> Are there any concerns with merging these into the x86 tree so
>>> that they go upstream for 4.8?  The updates here are pretty
>>> minor.
>>
>>>  include/linux/pkeys.h                         |   39 +-
>>>  include/uapi/asm-generic/mman-common.h        |    5 +
>>>  include/uapi/asm-generic/unistd.h             |   12 +-
>>>  mm/mprotect.c                                 |  134 +-
>>
>> So I'd love to have some high level MM review & ack for these syscall ABI
>> extensions.
>
> That's a quite reasonable request, but I'm really surprised by it at
> this point.  The proposed ABI is one very straightforward extension to
> one existing system call, plus four others that you personally suggested.
>

I apologize for the very late review, but (see other thread) I think
we may need to make sure we've defined the signal delivery semantics
in a useful way before enabling these.  I'm not convinced that the
current behavior is helpful.  This may or may not require any change
to the syscall signatures, but I can imagine that doing it right would
involve adding another syscall to *read* the current signal-delivery
state of a pkey or perhaps of all the pkeys.  That could potentially
be achieved by adding an extra pointer parameter to pkey_get so
pkey_get can return both the current state and the state at next
signal delivery.

--Andy

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
