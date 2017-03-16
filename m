From: Goldwyn Rodrigues <rgoldwyn-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [PATCH 3/8] nowait aio: return if direct write will trigger
 writeback
Date: Thu, 16 Mar 2017 08:46:31 -0500
Message-ID: <8a799ad5-6481-66d3-7f21-6eaeb33eaa7b@suse.de>
References: <20170315215107.5628-1-rgoldwyn@suse.de>
 <20170315215107.5628-4-rgoldwyn@suse.de>
 <20170316132052.GG4033@bombadil.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170316132052.GG4033-PfSpb0PWhxZc2C7mugBRk2EX/6BAtgUQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jack-IBi9RG/b67k@public.gmane.org, hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org, avi-VrcmuVmyx1hWk0Htik3J/w@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Goldwyn Rodrigues <rgoldwyn-IBi9RG/b67k@public.gmane.org>
List-Id: linux-api@vger.kernel.org



On 03/16/2017 08:20 AM, Matthew Wilcox wrote:
> On Wed, Mar 15, 2017 at 04:51:02PM -0500, Goldwyn Rodrigues wrote:
>> From: Goldwyn Rodrigues <rgoldwyn-IBi9RG/b67k@public.gmane.org>
>>
>> Find out if the write will trigger a wait due to writeback. If yes,
>> return -EAGAIN.
>>
>> This introduces a new function filemap_range_has_page() which
>> returns true if the file's mapping has a page within the range
>> mentioned.
>>
>> Return -EINVAL for buffered AIO: there are multiple causes of
>> delay such as page locks, dirty throttling logic, page loading
>> from disk etc. which cannot be taken care of.
> 
> Also, this patch only touches the write path; we have a similar call to
> write_and_wait_range() in generic_file_read_iter().
> 

This patch series is concerned with direct-write AIO paths only.

-- 
Goldwyn
