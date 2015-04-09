From: Krzysztof Opasiak <k.opasiak@samsung.com>
Subject: Re: [PATCH 1/5] fs: configfs: Fix typo in comment
Date: Thu, 09 Apr 2015 16:50:34 +0200
Message-ID: <552691BA.8090602@samsung.com>
References: <1428492528-11993-1-git-send-email-k.opasiak@samsung.com>
 <1428492528-11993-2-git-send-email-k.opasiak@samsung.com>
 <20150409134637.GB4393@saruman.tx.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-reply-to: <20150409134637.GB4393@saruman.tx.rr.com>
Sender: linux-kernel-owner@vger.kernel.org
To: balbi@ti.com
Cc: gregkh@linuxfoundation.org, jlbec@evilplan.org, andrzej.p@samsung.com, m.szyprowski@samsung.com, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
List-Id: linux-api@vger.kernel.org



On 04/09/2015 03:46 PM, Felipe Balbi wrote:
> On Wed, Apr 08, 2015 at 01:28:44PM +0200, Krzysztof Opasiak wrote:
>> Signed-off-by: Krzysztof Opasiak <k.opasiak@samsung.com>
>> ---
>>   fs/configfs/dir.c |    2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/fs/configfs/dir.c b/fs/configfs/dir.c
>> index cf0db00..dee1cb5 100644
>> --- a/fs/configfs/dir.c
>> +++ b/fs/configfs/dir.c
>> @@ -325,7 +325,7 @@ static void configfs_dir_set_ready(struct configfs_dirent *sd)
>>    * attached and not validated yet.
>>    * @sd		configfs_dirent of the directory to check
>>    *
>> - * @return	non-zero iff the directory was validated
>> + * @return	non-zero if the directory was validated
>
> iff is not a typo, it's short-hand for "if, and only if"
>

I've already dropped this patch in v2, but thank you for your remark.

Best regards,

-- 
Krzysztof Opasiak
Samsung R&D Institute Poland
Samsung Electronics
