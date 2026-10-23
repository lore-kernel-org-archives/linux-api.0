Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.47
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792783950;
	b=CjRmnVZZ/hxmC3ccpZgO0LNMW/CY1KkNcupfMtnG2yG8vntQlG/yXYiqxbkSWwuQgSBk
	 aplJ2OpzJiy6QYzQX6ruG4WrFFmLNDD7bQWPqRe4sdXvlNy+zQJ6ZDuCxn3nYx0bekkMv
	 LGIUCnEKIXXydm63A/hChAS3wuj5E7s1sqxEGYURm8X944cNmu9XO7v+6m139wWxymrKt
	 LghZT+fcs+Vo6gUdX6ev4nnDkEKp8a4tTjUC3cpPvOxbwncubfi8Tr3CdpLEIxSNQu3g2
	 WONfMJbh8ij3X6LEWNpGeP8Sb+ieG7nYpBaycPiMY1i0UoKMem4GkYGeSlInWyKD6XA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792783950;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:References:
	 Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=xQ0ZY845r5Du+UUOa8gVSKQGxBME1IJCKr0CS/df4CI=;
	b=DmZT7FpYE2Ep4PvJmcmgmTSQ5ydKkzruR5hm/kQjiFoEjkJtKutqzeLl2Uz5aMQCX+cm
	 DvODcFHaAiwZCM9wyDRSAFPJIzYknCDbPy0ko/xwa3aIIn6xDO2qjijzJawfWwJkzBEx5
	 gc6AaAQqXVgUbqGd4jdR88//J2QAk2UWNu/ea3tlIuuYcX1s5DRn0w4kPlXxKCWnvqdXO
	 NymgKVzx7CRpuLIoYYn7ks+xWBPhGLTsd12B2jPs27bS2C6MX/SYw8Y2yMBn8KDqK/GN0
	 lTXrH0+cWKZ5zOrwlc6TWZA5v3Uft9xKstiFTAsofLgOvLMs5IeLBh+aMdMYVTKlsRg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=colorfullife.com;
	spf=pass smtp.mailfrom=colorfullife.com;
	dkim=pass header.d=colorfullife-com.20251104.gappssmtp.com header.i=@colorfullife-com.20251104.gappssmtp.com header.a=rsa-sha256 header.s=20251104 header.b=IJwkHIua;
	arc=none smtp.remote-ip=209.85.128.47
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19BC8606A31E
	for <linux-api@vger.kernel.org>; Fri, 23 Oct 2026 19:32:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 19BC8606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=colorfullife.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=colorfullife.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=colorfullife-com.20251104.gappssmtp.com header.i=@colorfullife-com.20251104.gappssmtp.com header.a=rsa-sha256 header.s=20251104 header.b=IJwkHIua
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-49d0da752ffso10057205e9.3
        for <linux-api@vger.kernel.org>; Fri, 23 Oct 2026 12:32:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=colorfullife-com.20251104.gappssmtp.com; s=20251104; t=1792783947; x=1793388747; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=xQ0ZY845r5Du+UUOa8gVSKQGxBME1IJCKr0CS/df4CI=;
        b=IJwkHIuahlX2XmMgrR2c4biFHA3eskauE3h6uVTKAANKlsfhz+huia0jeSfgkqD9te
         yCHvIxkXbcIe6zPAb07HORwwUJqgaZefo4YbLOzzVt0oVupxczkq2SHcd4b0OcoBOvWM
         3hYL93P/HIN94qL9lwUvUC5EkzVD/PRGBVNzmk9ednVd+fxpxY4wdyYivid1PyYPuR/U
         KkvmryC9htmaxcQkhC7Z5wj+PycuqCkkBhTg8wlkegLM9BKUZbGxxiOAeLS/Slj03CW7
         kfgNpCvh5LL/du8svsYwsDWWot+MJSqiMqNUbx4EnApPLuFlFacpkDj3CP8OGcXutRx6
         WbOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792783947; x=1793388747;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=xQ0ZY845r5Du+UUOa8gVSKQGxBME1IJCKr0CS/df4CI=;
        b=GG8pC4bA4ZDEwnYF4/fLUmnDji/+6eOxlFDZ4JCTUtiYUqlAASzUozrhPDc0Hj7377
         HKIdI71md1GR5BWKvETSNbmvZ53hfwQYW+QsO5UtEQ7adibXHkIYSotneMuniTTSPATP
         8zx/c6m4jvEFBdkv1nxfDvkm4rJ0QUSfy9lU/AW8QSUXcvAH2DKFOB+Mbm4uAGhOLC+O
         LNC/nDyfZh9W1U61ifjb5/T8qhQ1GYOZ0ji2FEckqIu0TGvAEeZWyaHUuGPsb3NJCDZb
         UcJMG7RmIowHL0RV0myihFYQMmcldaAzxHE4DzgeLasbvqS4tKEQOVIS0lEn+7Jsjoqh
         GmrQ==
X-Forwarded-Encrypted: i=1; AKwUvBzzNoooMwjaXxmV5pKz+nX+7YoAG53bk4rAwad2NySynEn21jKRAnDs0sjx/gneFGygYlC5bOyC0h0=@vger.kernel.org
X-Gm-Message-State: AFq9FYIZ6vks2jdNO7Wa5XJWdw9ZNRDcK2ElcFJNbxwOIDfokvK4CV9c
	AUcZwMb8niHgiAjP98IoLvDZFrHfyJO+zKO4oh3qLFUNS3WT36CsB1sVw9UwXt8W0A==
X-Gm-Gg: AYBFou0b4w9S/F23px0CrKVneQZ6bUEOsKpODvVgs3M3t/8O2xzlKMC+BPdBkgT8eQ6
	X1ZoEmL9KNuPo4i5pA2Pqv956ajLX23zOQ6J1zJcPQfwBrTE2z1yFdch6cY1I5gXf18g/ehhmga
	1SyRT0M3MVjBQiW5Rh3leThvXFm9I4YJ0a/JhMi+AYfuopBfuBNN/hrjiL9ZnR6jd6DIg3CR8Tt
	kKPNUfL+8gXfHuVEwcXMiWyHAGztP2OmlYFhzCDU1QF+JB0CRb5zVSzoUall2CdsUmWtel3t7Q5
	vLAZs6EuTCo4x7X4MZ1XFGP45w7byWs5lqlLe7OgcFja4+un/xVwrMlShVrFFHIPXNRoP+volWW
	uBFdunRoYz7KyZ7ipX80gR1x0NgH2p2uPxdQfpNhfSYpaAXeTM2nBN0/rBERDziPI6S0p8CTGvi
	I4FWa9MYmy47o317yqnOz6Q2Vh0VMqXhNg4E2yv3O21s4Yu7cggUeRY6aHEmUpuXOfzRFcbNBt2
	W6MKqSWnnHBaCtZGuV2vSaLmPHvMiIhxtyeVsepOUWHD5Ue+fhw+Qzkqirxr5VeUsaNlA1qZzhj
	mgdo+WMld4H5stqWBBfJDwljQi8a+IHhWYb1OIeNrl7GGiBbhMuWwPzJx83R+qAcs+5q0gjDGn5
	KkQP5L9vOIZe1QNo=
X-Received: by 2002:a05:600c:630c:b0:4a2:5ca:767f with SMTP id 5b1f17b1804b1-4a211c64f9emr57232995e9.4.1792783947346;
        Fri, 23 Oct 2026 12:32:27 -0700 (PDT)
Received: from ?IPV6:2003:d9:9707:8b00:3fa:3a3e:198d:ab69? (p200300d997078b0003fa3a3e198dab69.dip0.t-ipconnect.de. [2003:d9:9707:8b00:3fa:3a3e:198d:ab69])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a359fb08d5sm14180055e9.1.2026.10.23.12.32.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 23 Oct 2026 12:32:26 -0700 (PDT)
Message-ID: <9a3aa73c-7b62-4f1e-983d-cf22d45ad86b@colorfullife.com>
Date: Fri, 23 Oct 2026 21:32:25 +0200
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/3] ipc/sem: remove obsolete SEMOPM fragmentation
 warning
To: Yingjie Wang <x-professor@outlook.com>,
 Andrew Morton <akpm@linux-foundation.org>, Alexey Gladkov
 <legion@kernel.org>, "Eric W . Biederman" <ebiederm@xmission.com>
Cc: Vasily Averin <vasily.averin@linux.dev>,
 Johannes Weiner <hannes@cmpxchg.org>, Shakeel Butt <shakeel.butt@linux.dev>,
 =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>,
 Michal Hocko <mhocko@suse.com>, Alejandro Colomar <alx@kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "linux-mm@kvack.org" <linux-mm@kvack.org>,
 "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>,
 "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>,
 "linux-man@vger.kernel.org" <linux-man@vger.kernel.org>
References: <cover.1792724953.git.x-professor@outlook.com>
 <cbd5dc183943d2177e5564f6e8ec92499836c7e5.1792724953.git.x-professor@outlook.com>
Content-Language: en-US
From: Manfred Spraul <manfred@colorfullife.com>
In-Reply-To: <cbd5dc183943d2177e5564f6e8ec92499836c7e5.1792724953.git.x-professor@outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi Yingjie,

On 10/23/26 5:19 AM, Yingjie Wang wrote:
> The UAPI comment advises keeping SEMOPM at or below 1000 because a larger
> operation array may fail due to physical memory fragmentation.
>
> Commit e4243b8062c1 ("ipc/sem: play nicer with large nsops allocations")
> changed the operation array to kvmalloc() specifically to support larger
> configured limits, with vmalloc fallback when a physically contiguous
> allocation is unavailable.
>
> Replace the obsolete warning with a description of the compiled-in
> default and the runtime sysctl.
>
> Signed-off-by: Yingjie Wang <x-professor@outlook.com>
> ---
>   include/uapi/linux/sem.h | 7 +++----
>   1 file changed, 3 insertions(+), 4 deletions(-)
>
> diff --git a/include/uapi/linux/sem.h b/include/uapi/linux/sem.h
> index 75aa3b273cd99..cfd772f4c3396 100644
> --- a/include/uapi/linux/sem.h
> +++ b/include/uapi/linux/sem.h
> @@ -71,16 +71,15 @@ struct  seminfo {
>    * The values has been chosen to be larger than necessary for any
>    * known configuration.
>    *
> - * SEMOPM should not be increased beyond 1000, otherwise there is the
> - * risk that semop()/semtimedop() fails due to kernel memory fragmentation when
> - * allocating the sop array.
> + * SEMOPM is the default maximum number of operations per semop() call. The
> + * runtime limit can be changed through /proc/sys/kernel/sem.
>    */
>   
>   
>   #define SEMMNI  32000           /* <= IPCMNI  max # of semaphore identifiers */
>   #define SEMMSL  32000           /* <= INT_MAX max num of semaphores per id */
>   #define SEMMNS  (SEMMNI*SEMMSL) /* <= INT_MAX max # of semaphores in system */
> -#define SEMOPM  500	        /* <= 1 000 max num of ops per semop call */
> +#define SEMOPM  500	        /* default max num of ops per semop call */
>   #define SEMVMX  32767           /* <= 32767 semaphore maximum value */
>   #define SEMAEM  SEMVMX          /* adjust on exit max value */
>   

I think there is a conceptual issue, but perhaps it is today not 
relevant anymore:

The values in uapi/linux/{sem,shm,msg}.h can be adapted as needed: Just 
change the values to what you need, compile a new kernel and you have a 
suitable system, even without sysctl compiled in.

Your change breaks this: SEMOPM is both the compiled in value, and the 
implied limit when _ACCOUNT is used. If someone increases SEMOPM in the 
header file - suddenly more unaccounted memory can be allocated.
Perhaps there should be two defines: SEMOPM and e.g. SEMOPM_NOACCOUNT?

SEPMOPM_NOACCOUNT defined in ipc/sem.c, perhaps 500 or 1000.

And SEMOPM remains in the uapi header file.

Minor point: So far, the format of all limits is identical. Could we 
keep this?

#define VALUE 1234 /* <= 4321, due to whatever reason */

Perhaps something like:

> -#define SEMOPM  500            /* <= 1 000 max num of ops per semop 
> call */
> +#define SEMOPM  500            /* <= INT_MAX max num of ops per semop 
> call */
>
Reviewed-By: Manfred Spraul <manfred@colorfullife.com>
--

     Manfred

