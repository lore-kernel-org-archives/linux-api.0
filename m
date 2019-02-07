From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 12/18] io_uring: add support for pre-mapped user IO
 buffers
Date: Thu, 7 Feb 2019 15:47:25 -0700
Message-ID: <72dfa45e-0d2e-5966-5343-8d9e2994c2d0@kernel.dk>
References: <20190207195552.22770-1-axboe@kernel.dk>
 <20190207195552.22770-13-axboe@kernel.dk>
 <x49zhr7442d.fsf@segfault.boston.devel.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-aio@kvack.org>
In-Reply-To: <x49zhr7442d.fsf@segfault.boston.devel.redhat.com>
Content-Language: en-US
Sender: owner-linux-aio@kvack.org
To: Jeff Moyer <jmoyer@redhat.com>
Cc: linux-aio@kvack.org, linux-block@vger.kernel.org, linux-api@vger.kernel.org, hch@lst.de, avi@scylladb.com, jannh@google.com, viro@ZenIV.linux.org.uk
List-Id: linux-api@vger.kernel.org

On 2/7/19 3:38 PM, Jeff Moyer wrote:
> Hi, Jens,
> 
> Jens Axboe <axboe@kernel.dk> writes:
> 
>> For now, buffers must not be file backed. If file backed buffers are
>> passed in, the registration will fail with -1/EOPNOTSUPP. This
>> restriction may be relaxed in the future.
> 
> [...]
> 
>> +		down_write(&current->mm->mmap_sem);
>> +		pret = get_user_pages_longterm(ubuf, nr_pages, FOLL_WRITE,
>> +						pages, vmas);
>> +		if (pret == nr_pages) {
>> +			/* don't support file backed memory */
>> +			for (j = 0; j < nr_pages; j++) {
>> +				struct vm_area_struct *vma = vmas[j];
>> +
>> +				if (vma->vm_file) {
>> +					ret = -EOPNOTSUPP;
>> +					break;
>> +				}
>> +			}
> 
> Unfortunately, this suffers the same problem as FOLL_ANON.  Huge pages
> are backed by hugetlbfs, and vma->vm_file will be filled in.
> 
> I guess you could check is_file_hugepages(vma->vm_file):
> 
>         if (vma->vm_file &&
>             !is_file_hugepages(vma->vm_file)) {
>                 ret = -EOPNOTSUPP;
>                 break;
>        }
> 
> That works for me.

Thanks, that looks better. Fixed!

-- 
Jens Axboe

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
