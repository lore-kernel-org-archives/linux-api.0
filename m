Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E110B254AFF;
	Tue, 26 May 2026 03:35:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779766514; cv=none; b=h5DYoApveQve2eI19lPeWyguB/kCWam7o1N/udD+OMOQ4w7XVb99bCLQzBKGrctUL7ikhKyXiYQlKd7xsC0xpTcKDQnqn8ur4TgxI3yjDw1x3FA44Jf6920ephHum89cgT/Re2llS3OvNPHzHFw/RDHXltNiW5HiMW1HUAsnJT0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779766514; c=relaxed/simple;
	bh=cNXwuioLXgIKShhvAkjwzAAW03LjBAYy5OsXLEqhlrU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qexxNRxUEI0Y8KNTuzFWcXTHRlt0J51QJjzgxo+K2M3JiKpMs+tdqMM7r2pfa4O1nphkm+VnvPwkZLVBQfqkzB11TIrRfo2Gk8ObYMNyrjWZI9l1Z61nuhc7aF2hw1LvzoicdC/5Z42GVFsoODzdhYnHmFFRYr++YpLaBRSrJq4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=n7//IyJl; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="n7//IyJl"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	Content-Type:In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:
	Message-ID:Sender:Reply-To:Content-ID:Content-Description;
	bh=527TQNohQgXTy7ya7qpWQCeh7V6iZfuABrEHgfWiUv0=; b=n7//IyJl/zK+ighao5zYHcv2xi
	9yzBpONPFgEHn+jpAeMzWdxE39d6MIzzhkwuotgCXfHy4eZO6iawJEp8vIgipOoGVDKqLx8ntWT37
	UK01O4TKEmSRq/SPGb2BxY4Kc8ynVjr1HEvHZp/e/vktJyuTd9U5DtUK9tD3tHC/UH3IoxnZwpRVs
	JwCVBAKH81qxp8aM6P3A9L5jJahSJkXzfqISPRV/6T5CpWfUwqswoAWHHzzRk3PXWgX/OsfCErbQK
	STsy75nGeF5ZjUSwdkiEnpFARej4s9SSM845gK7T2zKZLyy2MFaPLEczhZMoi6zaiiOuos9pcOQtG
	UqU8YnwA==;
Received: from [50.53.43.113] (helo=[192.168.254.34])
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wRiZS-00000000wa1-1OnB;
	Tue, 26 May 2026 03:35:10 +0000
Message-ID: <8a42abed-8289-44ec-a144-dfe531a4af71@infradead.org>
Date: Mon, 25 May 2026 20:35:08 -0700
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [f2fs-dev] [PATCH v2] f2fs: another way to set large folio by
 remembering inode number
To: Jaegeuk Kim <jaegeuk@kernel.org>, Theodore Tso <tytso@mit.edu>
Cc: linux-api@vger.kernel.org, linux-kernel@vger.kernel.org,
 Matthew Wilcox <willy@infradead.org>,
 linux-f2fs-devel@lists.sourceforge.net, Christoph Hellwig
 <hch@infradead.org>, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
 Akilesh Kailash <akailash@google.com>,
 Christian Brauner <christian@brauner.io>
References: <adhPZxtbZxgU-37v@google.com> <ad30g9xMs9wNJhFb@infradead.org>
 <ad_AVHe7RMnGrGTb@google.com> <ad_HwhzlNPUEKQi6@casper.infradead.org>
 <ag7HfNryTmQ-bVIS@infradead.org> <20260521155748.GA79343@macsyma-wired.lan>
 <ag_OVwPF49LSZ7rz@google.com> <20260522141115.GA8258@macsyma-wired.lan>
 <ahCNmWbcd_2lAJyk@google.com> <20260522224108.GA18663@macsyma-wired.lan>
 <ahTzHyHBL8t0iNBR@google.com>
Content-Language: en-US
From: Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <ahTzHyHBL8t0iNBR@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 5/25/26 6:10 PM, Jaegeuk Kim wrote:
> On 05/22, Theodore Tso wrote:
>> On Fri, May 22, 2026 at 05:08:41PM +0000, Jaegeuk Kim wrote:
>>>
>>> Thank you for the explanation. It seems I made a wrong assumption on the
>>> usage of "user." prefix where each filesystem can support in different
>>> ways.
>>
>> The "user." prefix is used by all userspace applications that wish to
>> store extended attributes.  For example, user.mime_type,
>> user.xdg.origin_url, user.charset, user.appache_handler, etc
>>
>> For more information, see:
>>
>>     https://www.freedesktop.org/wiki/CommonExtendedAttribute
>>     https://wiki.archlinux.org/title/Extended_attributes
>>
>> I certainly assumed this was common knowledge across all file system
>> maintainers, but this was apparently not true in your case.  I don't
>> know how this could be the case given that f2fs implements extended
>> attributes, and I would have thought you would have known that when
>> testing that feature.
>>
>>> I shared some motivation when replying to Darrick's feedback [1], but yes,
>>> it was not enough for all heads-up. The problem started that some speicific
>>> application needs as many high-order pages as possible mostly for reads. So,
>>> I thought we can turn on large folio on the specific files per hints. One way
>>> for the hints was using immutable bit, but it turned out it's very hard to
>>> manage disabling the bit whenever deleting the files. Along with limited
>>> ioctl() and requiring inode eviction to manage large folio activation, I had
>>> to implement this path.
>>>
>>> [1] https://lore.kernel.org/lkml/aeA5C8byIpXWla7f@google.com/
>>
>> Actually, you still haven't explained your use case, at least, not
>> well enough for me to understand what you are trying to do.
>>
>> So an application wants a particular file to use as many high-order
>> pages as possible.  Why?  What sort of guarantees do you need to
>> provide?  What happens if they can't be provided?  What happens if a
>> possibly malicious, or at least gready, application uses this
>> interface to grab a lot of high-order pages?
>>
>> >From your patch:
>>
>> 1. setxattr(file, "user.fadvise", &value, sizeof(unsigned int), 0)
>>  -> register the inode number for large folio
>> 2. chmod(0400, file)
>>  -> make Read-Only
>> 3. open()
>>  -> f2fs_iget() with large folio
>> 4. open(WRITE), mkwrite on mmap, chmod(WRITE)
>>  -> return error
>> 5. iput() and open()
>>  -> goto #3
>> 6. unlink
>>  -> deregister the inode number
>>
>> Why should making the file read-only matter?  And when you say
>> "derigster the inode number", why should this be related to deleting
>> the inode?
>>
>> This is an interface which seems to be very specific to your use case.
>> What if those requirements change over time?  What if you want pull in
>> a file without making it be read-only?  And what if you want to
>> release the large-order pages without deleting the file?
> 
> Let me try to write more details, helped with Gemini.

[as an interested reader:]

If this idea is so good, why shouldn't it be done in the VFS/MM so that
other filesystems could do the same thing instead of just in f2fs?


-- 
~Randy

