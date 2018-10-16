From: Laurent Vivier <laurent@vivier.eu>
Subject: Re: [PATCH v6 1/1] ns: add binfmt_misc to the user namespace
Date: Tue, 16 Oct 2018 12:53:11 +0200
Message-ID: <1eca343b-19c7-a82c-d7ac-b3aea288b56b@vivier.eu>
References: <20181010161430.11633-1-laurent@vivier.eu>
 <20181010161430.11633-2-laurent@vivier.eu>
 <97280bb2-933e-9281-bd91-99748e1dd653@rasmusvillemoes.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <97280bb2-933e-9281-bd91-99748e1dd653@rasmusvillemoes.dk>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Rasmus Villemoes <linux@rasmusvillemoes.dk>, linux-kernel@vger.kernel.org
Cc: Jann Horn <jannh@google.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, Andrei Vagin <avagin@gmail.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Eric Biederman <ebiederm@xmission.com>, containers@lists.linux-foundation.org, Dmitry Safonov <dima@arista.com>
List-Id: linux-api@vger.kernel.org

Le 16/10/2018 à 12:13, Rasmus Villemoes a écrit :
> On 2018-10-10 18:14, Laurent Vivier wrote:
> 
>> +	/* create a new binfmt namespace
>> +	 * if we are not in the first user namespace
>> +	 * but the binfmt namespace is the first one
>> +	 */
>> +	if (READ_ONCE(ns->binfmt_ns) == NULL) {
>> +		struct binfmt_namespace *new_ns;
>> +
>> +		new_ns = kmalloc(sizeof(struct binfmt_namespace),
>> +				 GFP_KERNEL);
>> +		if (new_ns == NULL)
>> +			return -ENOMEM;
>> +		INIT_LIST_HEAD(&new_ns->entries);
>> +		new_ns->enabled = 1;
>> +		rwlock_init(&new_ns->entries_lock);
>> +		new_ns->bm_mnt = NULL;
>> +		new_ns->entry_count = 0;
>> +		/* ensure new_ns is completely initialized before sharing it */
>> +		smp_wmb();
>> +		WRITE_ONCE(ns->binfmt_ns, new_ns);
>> +	}
> 
> If ns->binfmt_ns can really change under us (given you use READ_ONCE),
> what prevents two instances of this code running at the same time, in
> which case one of them would leak its new_ns instance? Also, there

See
https://www.mail-archive.com/linux-kernel@vger.kernel.org/msg1782780.html

> doesn't seem to be any smp_rmb() buddy to that wmb(), I don't think
> that's implied by READ_ONCE() in binfmt_ns().

See
https://www.mail-archive.com/linux-kernel@vger.kernel.org/msg1783049.html

Thanks,
Laurent
