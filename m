From: Milosz Tanski <milosz@adfin.com>
Subject: Re: [PATCH 2/4] vfs: Define new syscalls preadv2,pwritev2
Date: Wed, 5 Nov 2014 15:32:54 -0500
Message-ID: <CANP1eJE1GbTQ3=AjL=xQ773rQEGsWnQy=GnY=_VzsFnTRVJKeQ@mail.gmail.com>
References: <cover.1413923420.git.milosz@adfin.com>
	<1613303dfaa91e6ff09cdd7860e0316765663ba6.1413923420.git.milosz@adfin.com>
	<x49oat1o4gf.fsf@segfault.boston.devel.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <owner-linux-aio@kvack.org>
In-Reply-To: <x49oat1o4gf.fsf@segfault.boston.devel.redhat.com>
Sender: owner-linux-aio@kvack.org
To: Jeff Moyer <jmoyer@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-aio@kvack.org" <linux-aio@kvack.org>, Mel Gorman <mgorman@suse.de>, Volker Lendecke <Volker.Lendecke@sernet.de>, Tejun Heo <tj@kernel.org>, Theodore Ts'o <tytso@mit.edu>, Al Viro <viro@zeniv.linux.org.uk>, Linux API <linux-api@vger.kernel.org>, Michael Kerrisk <mtk.manpages@gmail.com>
List-Id: linux-api@vger.kernel.org

I have fixed this in the version I'm going to be resubmitting today.

- Milosz

On Fri, Oct 24, 2014 at 11:46 AM, Jeff Moyer <jmoyer@redhat.com> wrote:
> Milosz Tanski <milosz@adfin.com> writes:
>
>> diff --git a/include/uapi/asm-generic/unistd.h b/include/uapi/asm-generic/unistd.h
>> index 22749c1..10f8883 100644
>> --- a/include/uapi/asm-generic/unistd.h
>> +++ b/include/uapi/asm-generic/unistd.h
>> @@ -213,6 +213,10 @@ __SC_COMP(__NR_pwrite64, sys_pwrite64, compat_sys_pwrite64)
>>  __SC_COMP(__NR_preadv, sys_preadv, compat_sys_preadv)
>>  #define __NR_pwritev 70
>>  __SC_COMP(__NR_pwritev, sys_pwritev, compat_sys_pwritev)
>> +#define __NR_preadv2 281
>> +__SC_COMP(__NR_preadv2, sys_preadv2)
>> +#define __NR_pwritev2 282
>> +__SC_COMP(__NR_pwritev2, sys_pwritev2)
>
> This looks odd.  First, __SC_COMP takes 3 arguments.  Second, you are
> going to need to implement compat wrappers for the new system calls.
>
> Cheers,
> Jeff



-- 
Milosz Tanski
CTO
16 East 34th Street, 15th floor
New York, NY 10016

p: 646-253-9055
e: milosz@adfin.com

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
