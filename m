From: Pavel Shilovsky <piastry@etersoft.ru>
Subject: Re: [PATCH 0/2] Shared flags
Date: Thu, 13 Nov 2008 13:08:58 +0300
Message-ID: <491BFCBA.80208@etersoft.ru>
References: <49183DF9.9010003@etersoft.ru> <20081111085211.GB2323@infradead.org> <20081111100940.GA8968@shareable.org> <20081111111428.GA18228@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20081111111428.GA18228@infradead.org>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: jamie@shareable.org, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Christoph Hellwig wrote:
> On Tue, Nov 11, 2008 at 10:09:40AM +0000, Jamie Lokier wrote:
>   
>> Christoph Hellwig wrote:
>>     
>>> On Mon, Nov 10, 2008 at 04:58:17PM +0300, Pavel Shilovsky wrote:
>>>       
>>>> #define O_DENYREAD      004000000 /* Do not permit read access */
>>>> #define O_DENYWRITE     010000000 /* Do not permit write access */
>>>> #define O_DENYDELETE  020000000 /* Do not permit delete or rename operations*/
>>>>         
>>>  (2) you also need to enforce these semantics in the VFS for local
>>>      filesystems
>>>
>>> Now if (2) doesn't cause too much overhead I would say it's fine, if not
>>> I would rather avoid it.
>>>       
>> On the face of it, they look like they have similar denial-of-service
>> potential as mandatory locks.  For example, a root process cleaning
>> out /tmp gets stuck because a user process has O_DENYDELETE set.
>>     
>
> Oh, that's the part I forgot to mention in the previous mail, all of
> these option of course can only be root only, everything else would
> be - as you say - a complete security nightmare.
>
>   
We suggest to switch on this flags with special options during mounting. 
By default, it'll be switch off.
This solution deletes possibility of such situations, like in example.

Pavel Shilovsky.
