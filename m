From: Vlastimil Babka <vbabka@suse.cz>
Subject: Re: [PATCH v4 2/4] mm, proc: account for shmem swap in
 /proc/pid/smaps
Date: Tue, 6 Oct 2015 09:08:03 +0200
Message-ID: <56137353.2010600@suse.cz>
References: <1443792951-13944-1-git-send-email-vbabka@suse.cz>
 <1443792951-13944-3-git-send-email-vbabka@suse.cz>
 <20151002153702.7bdc4c0483cd9b2ee9e0fba3@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <20151002153702.7bdc4c0483cd9b2ee9e0fba3@linux-foundation.org>
Sender: linux-doc-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, Jerome Marchand <jmarchan@redhat.com>, Hugh Dickins <hughd@google.com>, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, Michal Hocko <mhocko@suse.cz>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Cyrill Gorcunov <gorcunov@openvz.org>, Randy Dunlap <rdunlap@infradead.org>, linux-s390@vger.kernel.org, Martin Schwidefsky <schwidefsky@de.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, Peter Zijlstra <peterz@infradead.org>, Paul Mackerras <paulus@samba.org>, Arnaldo Carvalho de Melo <acme@kernel.org>, Oleg Nesterov <oleg@redhat.com>, Linux API <linux-api@vger.kernel.org>, Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
List-Id: linux-api@vger.kernel.org

On 10/03/2015 12:37 AM, Andrew Morton wrote:
> On Fri,  2 Oct 2015 15:35:49 +0200 Vlastimil Babka <vbabka@suse.cz> wrote:
>
>>
>> --- a/include/linux/shmem_fs.h
>> +++ b/include/linux/shmem_fs.h
>> @@ -60,6 +60,12 @@ extern struct page *shmem_read_mapping_page_gfp(struct address_space *mapping,
>>   extern void shmem_truncate_range(struct inode *inode, loff_t start, loff_t end);
>>   extern int shmem_unuse(swp_entry_t entry, struct page *page);
>>
>> +#ifdef CONFIG_SWAP
>> +extern unsigned long shmem_swap_usage(struct inode *inode);
>> +extern unsigned long shmem_partial_swap_usage(struct address_space *mapping,
>> +						pgoff_t start, pgoff_t end);
>> +#endif
>
> CONFIG_SWAP is wrong, isn't it?  It should be CONFIG_SHMEM if anything.

Yeah, I overlooked this while removing the other ifdefs. Thanks.

