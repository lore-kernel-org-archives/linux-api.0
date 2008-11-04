From: Oren Laadan <orenl-eQaUEPhvms7ENvBUuze7eA@public.gmane.org>
Subject: Re: [RFC v8][PATCH 05/12] x86 support for checkpoint/restart
Date: Tue, 04 Nov 2008 10:32:26 -0500
Message-ID: <49106B0A.8010205@cs.columbia.edu>
References: <1225374675-22850-1-git-send-email-orenl@cs.columbia.edu>	 <1225374675-22850-6-git-send-email-orenl@cs.columbia.edu> <1225791016.5940.33.camel@noir.spf.cl.nec.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1225791016.5940.33.camel-eKIOortEDzKlX1Gi5MogR0v2NXO6HgA6@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Masahiko Takahashi <m-takahashi-kvZsz0w9TrB8UrSeD/g0lQ@public.gmane.org>
Cc: Linus Torvalds <torvalds-3NddpPZAyC0@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dave Hansen <dave-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-X9Un+BFzKDI@public.gmane.org>
List-Id: linux-api@vger.kernel.org



Masahiko Takahashi wrote:
> Hi Oren,
> 
> I'm now trying to port your patchset to x86_64, and find a tiny
> inconsistency issue.
> 
> 
> On 2008-10-30 at 09:51 -0400, Oren Laadan wrote:
>> +/* dump the thread_struct of a given task */
>> +int cr_write_thread(struct cr_ctx *ctx, struct task_struct *t)
>> +{
>> +	struct cr_hdr h;
>> +	struct cr_hdr_thread *hh = cr_hbuf_get(ctx, sizeof(*hh));
>> +	struct thread_struct *thread;
>> +	struct desc_struct *desc;
>> +	int ntls = 0;
>> +	int n, ret;
>> +
>> +	h.type = CR_HDR_THREAD;
>> +	h.len = sizeof(*hh);
>> +	h.parent = task_pid_vnr(t);
>> +
>> +	thread = &t->thread;
>> +
>> +	/* calculate no. of TLS entries that follow */
>> +	desc = thread->tls_array;
>> +	for (n = GDT_ENTRY_TLS_ENTRIES; n > 0; n--, desc++) {
>> +		if (desc->a || desc->b)
>> +			ntls++;
>> +	}
>> +
>> +	hh->gdt_entry_tls_entries = GDT_ENTRY_TLS_ENTRIES;
>> +	hh->sizeof_tls_array = sizeof(thread->tls_array);
>> +	hh->ntls = ntls;
>> +
>> +	ret = cr_write_obj(ctx, &h, hh);
>> +	cr_hbuf_put(ctx, sizeof(*hh));
>> +	if (ret < 0)
>> +		return ret;
> 
> Please add
>    if (ntls == 0)
>             return ret;
> because, in restart phase, reading TLS entries from the image file
> is skipped if hh->ntls == 0, which may incur inconsistency and fail
> to restart.
> 

Will fix, thanks.

Oren.


--
To unsubscribe from this list: send the line "unsubscribe linux-api" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
