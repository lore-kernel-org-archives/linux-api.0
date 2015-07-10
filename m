From: Gioh Kim <gioh.kim@lge.com>
Subject: Re: [RFCv3 3/5] mm/balloon: apply mobile page migratable into balloon
Date: Fri, 10 Jul 2015 09:21:40 +0900
Message-ID: <559F1014.6070306@lge.com>
References: <1436243785-24105-1-git-send-email-gioh.kim@lge.com>
	<1436243785-24105-4-git-send-email-gioh.kim@lge.com>
	<20150709105119-mutt-send-email-mst@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
In-Reply-To: <20150709105119-mutt-send-email-mst@redhat.com>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/virtualization/>
List-Post: <mailto:virtualization@lists.linux-foundation.org>
List-Help: <mailto:virtualization-request@lists.linux-foundation.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=subscribe>
Sender: virtualization-bounces@lists.linux-foundation.org
Errors-To: virtualization-bounces@lists.linux-foundation.org
To: "Michael S. Tsirkin" <mst@redhat.com>, koct9i@gmail.com, aquini@redhat.com
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org, bfields@fieldses.org, minchan@kernel.org, Gioh Kim <gurugio@hanmail.net>, viro@zeniv.linux.org.uk, gunho.lee@lge.com, linux-fsdevel@vger.kernel.org, jlayton@poochiereds.net, iamjoonsoo.kim@lge.com, vbabka@suse.cz
List-Id: linux-api@vger.kernel.org



>> @@ -124,6 +130,7 @@ static inline void balloon_page_insert(struct balloon_dev_info *balloon,
>>   				       struct page *page)
>>   {
>>   	__SetPageBalloon(page);
>> +	page->mapping = balloon->inode->i_mapping;
>>   	SetPagePrivate(page);
>>   	set_page_private(page, (unsigned long)balloon);
>>   	list_add(&page->lru, &balloon->pages);
>> @@ -140,6 +147,7 @@ static inline void balloon_page_insert(struct balloon_dev_info *balloon,
>>   static inline void balloon_page_delete(struct page *page)
>>   {
>>   	__ClearPageBalloon(page);
>> +	page->mapping = NULL;
>>   	set_page_private(page, 0);
>>   	if (PagePrivate(page)) {
>>   		ClearPagePrivate(page);
>
> Order of cleanup here is not the reverse of the order of initialization.
> Better make it exactly the reverse.
>
>
> Also, I have a question: is it enough to lock the page to make changing
> the mapping safe? Do all users lock the page too?
>
>
>
>

I think balloon developers can answer that precisely.

I've just follow this comment:
http://lxr.free-electrons.com/source/include/linux/balloon_compaction.h#L16
