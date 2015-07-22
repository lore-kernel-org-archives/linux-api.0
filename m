From: Mike Kravetz <mike.kravetz@oracle.com>
Subject: Re: [PATCH v4 09/10] hugetlbfs: add hugetlbfs_fallocate()
Date: Wed, 22 Jul 2015 15:23:42 -0700
Message-ID: <55B017EE.5020203@oracle.com>
References: <1437502184-14269-1-git-send-email-mike.kravetz@oracle.com>	<1437502184-14269-10-git-send-email-mike.kravetz@oracle.com> <20150722150345.f8d5b0042cfa7112bd95d9ef@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20150722150345.f8d5b0042cfa7112bd95d9ef@linux-foundation.org>
Sender: owner-linux-mm@kvack.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Dave Hansen <dave.hansen@linux.intel.com>, Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>, David Rientjes <rientjes@google.com>, Hugh Dickins <hughd@google.com>, Davidlohr Bueso <dave@stgolabs.net>, Aneesh Kumar <aneesh.kumar@linux.vnet.ibm.com>, Hillf Danton <hillf.zj@alibaba-inc.com>, Christoph Hellwig <hch@infradead.org>, Michal Hocko <mhocko@suse.cz>
List-Id: linux-api@vger.kernel.org

On 07/22/2015 03:03 PM, Andrew Morton wrote:
> On Tue, 21 Jul 2015 11:09:43 -0700 Mike Kravetz <mike.kravetz@oracle.com> wrote:
...
>> +
>> +	if (mode & ~(FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE))
>> +		return -EOPNOTSUPP;
>
> EOPNOTSUPP is a networking thing.  It's inappropriate here.
>
> The problem is that if this error is ever returned to userspace, the
> user will be sitting looking at "Operation not supported on transport
> endpoint" and wondering what went wrong in the networking stack.

Trying to follow FALLOCATE(2) man page:

"EOPNOTSUPP
	The filesystem containing the file referred to by  fd  does  not
	support  this  operation;  or  the  mode is not supported by the
	filesystem containing the file referred to by fd."

-- 
Mike Kravetz

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
