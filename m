Return-Path: <linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 250D9C4320E
	for <linux-api@archiver.kernel.org>; Wed, 28 Jul 2021 16:10:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0FF5D60187
	for <linux-api@archiver.kernel.org>; Wed, 28 Jul 2021 16:10:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231232AbhG1QK4 (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Wed, 28 Jul 2021 12:10:56 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:38752 "EHLO
        out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237464AbhG1QKu (ORCPT
        <rfc822;linux-api@vger.kernel.org>); Wed, 28 Jul 2021 12:10:50 -0400
Received: from in01.mta.xmission.com ([166.70.13.51]:43296)
        by out03.mta.xmission.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1m8m8j-00HGYH-Fq; Wed, 28 Jul 2021 10:10:37 -0600
Received: from ip68-227-160-95.om.om.cox.net ([68.227.160.95]:41390 helo=email.xmission.com)
        by in01.mta.xmission.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1m8m8a-00AA3v-G4; Wed, 28 Jul 2021 10:10:31 -0600
From:   ebiederm@xmission.com (Eric W. Biederman)
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Helge Deller <deller@gmx.de>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Christoph Hellwig <hch@infradead.org>,
        Feng Tang <feng.tang@intel.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-mips@vger.kernel.org, linux-parisc@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org,
        sparclinux@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-api@vger.kernel.org, linux-mm@kvack.org
References: <20210727144859.4150043-1-arnd@kernel.org>
        <20210727144859.4150043-3-arnd@kernel.org>
Date:   Wed, 28 Jul 2021 11:10:20 -0500
In-Reply-To: <20210727144859.4150043-3-arnd@kernel.org> (Arnd Bergmann's
        message of "Tue, 27 Jul 2021 16:48:55 +0200")
Message-ID: <87a6m6fmhf.fsf@disp2133>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1m8m8a-00AA3v-G4;;;mid=<87a6m6fmhf.fsf@disp2133>;;;hst=in01.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX18jESHy/qa/BMuMj4KVyetONWlkP5WqcQ8=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
Subject: Re: [PATCH v5 2/6] kexec: avoid compat_alloc_user_space
X-SA-Exim-Version: 4.2.1 (built Sat, 08 Feb 2020 21:53:50 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

Arnd Bergmann <arnd@kernel.org> writes:

> From: Arnd Bergmann <arnd@arndb.de>
>
> kimage_alloc_init() expects a __user pointer, so compat_sys_kexec_load()
> uses compat_alloc_user_space() to convert the layout and put it back
> onto the user space caller stack.
>
> Moving the user space access into the syscall handler directly actually
> makes the code simpler, as the conversion for compat mode can now be
> done on kernel memory.

Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>

>
> Co-developed-by: Eric Biederman <ebiederm@xmission.com>
> Co-developed-by: Christoph Hellwig <hch@infradead.org>
> Link: https://lore.kernel.org/lkml/YPbtsU4GX6PL7%2F42@infradead.org/
> Link: https://lore.kernel.org/lkml/m1y2cbzmnw.fsf@fess.ebiederm.org/
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  kernel/kexec.c | 61 +++++++++++++++++++++-----------------------------
>  1 file changed, 25 insertions(+), 36 deletions(-)
>
> diff --git a/kernel/kexec.c b/kernel/kexec.c
> index 9c7aef8f4bb6..b5e40f069768 100644
> --- a/kernel/kexec.c
> +++ b/kernel/kexec.c
> @@ -19,26 +19,9 @@
>  
>  #include "kexec_internal.h"
>  
> -static int copy_user_segment_list(struct kimage *image,
> -				  unsigned long nr_segments,
> -				  struct kexec_segment __user *segments)
> -{
> -	int ret;
> -	size_t segment_bytes;
> -
> -	/* Read in the segments */
> -	image->nr_segments = nr_segments;
> -	segment_bytes = nr_segments * sizeof(*segments);
> -	ret = copy_from_user(image->segment, segments, segment_bytes);
> -	if (ret)
> -		ret = -EFAULT;
> -
> -	return ret;
> -}
> -
>  static int kimage_alloc_init(struct kimage **rimage, unsigned long entry,
>  			     unsigned long nr_segments,
> -			     struct kexec_segment __user *segments,
> +			     struct kexec_segment *segments,
>  			     unsigned long flags)
>  {
>  	int ret;
> @@ -58,10 +41,8 @@ static int kimage_alloc_init(struct kimage **rimage, unsigned long entry,
>  		return -ENOMEM;
>  
>  	image->start = entry;
> -
> -	ret = copy_user_segment_list(image, nr_segments, segments);
> -	if (ret)
> -		goto out_free_image;
> +	image->nr_segments = nr_segments;
> +	memcpy(image->segment, segments, nr_segments * sizeof(*segments));
>  
>  	if (kexec_on_panic) {
>  		/* Enable special crash kernel control page alloc policy. */
> @@ -104,7 +85,7 @@ static int kimage_alloc_init(struct kimage **rimage, unsigned long entry,
>  }
>  
>  static int do_kexec_load(unsigned long entry, unsigned long nr_segments,
> -		struct kexec_segment __user *segments, unsigned long flags)
> +		struct kexec_segment *segments, unsigned long flags)
>  {
>  	struct kimage **dest_image, *image;
>  	unsigned long i;
> @@ -250,7 +231,8 @@ static inline int kexec_load_check(unsigned long nr_segments,
>  SYSCALL_DEFINE4(kexec_load, unsigned long, entry, unsigned long, nr_segments,
>  		struct kexec_segment __user *, segments, unsigned long, flags)
>  {
> -	int result;
> +	struct kexec_segment *ksegments;
> +	unsigned long result;
>  
>  	result = kexec_load_check(nr_segments, flags);
>  	if (result)
> @@ -261,7 +243,12 @@ SYSCALL_DEFINE4(kexec_load, unsigned long, entry, unsigned long, nr_segments,
>  		((flags & KEXEC_ARCH_MASK) != KEXEC_ARCH_DEFAULT))
>  		return -EINVAL;
>  
> -	result = do_kexec_load(entry, nr_segments, segments, flags);
> +	ksegments = memdup_user(segments, nr_segments * sizeof(ksegments[0]));
> +	if (IS_ERR(ksegments))
> +		return PTR_ERR(ksegments);
> +
> +	result = do_kexec_load(entry, nr_segments, ksegments, flags);
> +	kfree(ksegments);
>  
>  	return result;
>  }
> @@ -273,7 +260,7 @@ COMPAT_SYSCALL_DEFINE4(kexec_load, compat_ulong_t, entry,
>  		       compat_ulong_t, flags)
>  {
>  	struct compat_kexec_segment in;
> -	struct kexec_segment out, __user *ksegments;
> +	struct kexec_segment *ksegments;
>  	unsigned long i, result;
>  
>  	result = kexec_load_check(nr_segments, flags);
> @@ -286,24 +273,26 @@ COMPAT_SYSCALL_DEFINE4(kexec_load, compat_ulong_t, entry,
>  	if ((flags & KEXEC_ARCH_MASK) == KEXEC_ARCH_DEFAULT)
>  		return -EINVAL;
>  
> -	ksegments = compat_alloc_user_space(nr_segments * sizeof(out));
> +	ksegments = kmalloc_array(nr_segments, sizeof(ksegments[0]),
> +			GFP_KERNEL);
> +	if (!ksegments)
> +		return -ENOMEM;
> +
>  	for (i = 0; i < nr_segments; i++) {
>  		result = copy_from_user(&in, &segments[i], sizeof(in));
>  		if (result)
> -			return -EFAULT;
> +			goto fail;
>  
> -		out.buf   = compat_ptr(in.buf);
> -		out.bufsz = in.bufsz;
> -		out.mem   = in.mem;
> -		out.memsz = in.memsz;
> -
> -		result = copy_to_user(&ksegments[i], &out, sizeof(out));
> -		if (result)
> -			return -EFAULT;
> +		ksegments[i].buf   = compat_ptr(in.buf);
> +		ksegments[i].bufsz = in.bufsz;
> +		ksegments[i].mem   = in.mem;
> +		ksegments[i].memsz = in.memsz;
>  	}
>  
>  	result = do_kexec_load(entry, nr_segments, ksegments, flags);
>  
> +fail:
> +	kfree(ksegments);
>  	return result;
>  }
>  #endif
