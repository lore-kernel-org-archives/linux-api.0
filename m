Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72E8A3C10A7
	for <linux-api@vger.kernel.org>; Wed,  1 Jul 2026 07:51:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782892303; cv=none; b=ei5PvFdwAaV/j6KHEKTrLyS/AyiGmJg2XE3peoxDVyZJxMxAddxcyBi7nU7jg89XiTs7IjeSM3KtsE1fCBPanI0O1gHNjLoW2QBNsVf/4kbiLFa4yNIiU7Ibo589QqyroIXtY6TYnq/Wy39Entw19oWVFg+fsEd8wK+HeNLhBeY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782892303; c=relaxed/simple;
	bh=cjosReaGgzzEhX5VIa/0e68NTsVETg6Gw16U7jnPHsU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kxILMApqTMqdwcg28iUdbEHATXYQld7OhVKpMJ3bbl9YPxIiCLJYDXZEaC6REMaY/rsL7JxjrpFcoMaEAXmFE9CVLy4zXjkcX3a6Fwm+wE+l84+Iik2Skyg5qdHbunTnvzt7gSj7ZhVrDMisvgP8Ucyd+vQjntARZFX3nYDdC0w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=CHrmkNT/; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=W4q0mENl; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="CHrmkNT/";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="W4q0mENl"
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6616qu06280868
	for <linux-api@vger.kernel.org>; Wed, 1 Jul 2026 07:51:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	T5Hajlt0GSOifEEgLYuCorRENs6/gAytzHqsua8a2iM=; b=CHrmkNT/8n82uDku
	5W/oxi04FrcTejUH736a5SP/Dy+IdwMaKBBx4VlX/kzWSVybP0ERM9fwN3EW28be
	nxp8N4flgNS8xHjUTYPB0hTXFaFH0K3VbYIjfdwVSGYa/kU2s/6l6B4vn/4eD77n
	8CN7VAuJMdRMXbZ1MI2Ql1w4vPnltoAe7CUmD/W7PdPwfFcnNFXzV9SXm2tbEaRU
	9U6CncWN1oDCGNXO3xt8q4o/xS5QJ3DTPoUXCms7wc9lreP4eMDOBSVgUt+BUGSN
	FY9IflqNWjSL0RY00wl2hBKCFMky8dE0xbgHmdI2nti6WFzd0HvmcwxhMCHOFHDv
	DFT4ag==
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com [209.85.160.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4f4x0tg9q1-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-api@vger.kernel.org>; Wed, 01 Jul 2026 07:51:37 +0000 (GMT)
Received: by mail-qt1-f198.google.com with SMTP id d75a77b69052e-51c26012cd0so2598891cf.0
        for <linux-api@vger.kernel.org>; Wed, 01 Jul 2026 00:51:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1782892297; x=1783497097; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=T5Hajlt0GSOifEEgLYuCorRENs6/gAytzHqsua8a2iM=;
        b=W4q0mENlPn8PesA4joqNAsZMbsgjFmlACtI91Z127yXgF7fjzU+3+Sev8X6TvNyq2c
         ECoejTQs2D6N3wm2gykkWqyLcnJAnhRPRF0rU51cQk1A6415wLasjMdTG4Y8ACLn1mq2
         Nh6cSVbBcXV47xajnLH9AaLxN7pA55IgAx9Q3Ycq0TQlho506QGfFmjKh2/Z2UmB1qiQ
         T2xcLvk8vF9lKbQq8BMNTmdy1u32Y0xYAO5ueCNWszKhiUaBaeJ5BGxhC6XWsGIDTDjV
         5VvRrOVy8y+XUp3ervZnvmF++DXguQUq3XHhTsqAhTew2TqR8ffGYf7EBN9BWXAXE5no
         X73Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782892297; x=1783497097;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=T5Hajlt0GSOifEEgLYuCorRENs6/gAytzHqsua8a2iM=;
        b=HYp9pj/xnNMetWtHxbHzJznomMLANMnSbzx7q0qFAuSSNM4Nu9H/317bgV6SzhigYM
         YZYCRcf/eGgbJvuAjZSfCVE+T298pnPa2+sUbN4ZoYlnfK+N+9H3GMp7OgWm3bWam0U6
         CJPkat4oT+cc8N9To0DrmwwTqKtgP2eWckhFL3ho3z/OTCE+2Ve5C2+LJRWZ+eKwjvFA
         f3OhcJAAjSqOMqxODareAZyVZQAf0oYFlx+e7vzWQNT/VOApCrCt4IflTYnO375Z2ZBO
         kdw+Bok7sB+1PDXQI8btJJ3KM8YxYk2a2VablIYqS8VgZzlELjfxMKPJspd2mkEjqaO2
         61Xg==
X-Forwarded-Encrypted: i=1; AFNElJ+MVjqK5eM2aRpOA0bGEPhmiTvmgZF+PSPczsqcrAyFvGKgxJvQEDnUw+z24nGfFWfG8PecVAYkk3g=@vger.kernel.org
X-Gm-Message-State: AOJu0YxQY6I8exE0LekPfGwy0c+TM+67d1u4kc48FS4LL/mLQlNyz79i
	aAoWy4ZwDNKVV5WFvEXoVLiS4jI8h5Bl+dL1Qyxxut+FO9y60FXBaJmo2xb2HsFr/GUYkzioxRi
	BPleBql76I4n7Ld7Ojkigp4UxzftbXWLU9pTKdWyJgdakFQkTMg79lLar1+/1CRU=
X-Gm-Gg: AfdE7clLLt/pJak1JK+q+z+8xTJFKf8ICbYIJK7LQj0QwZoeBIUm4e6betAOGE5ef5q
	YbHrpqTTAeZHVLj83bApLb7HkzZV/FO+ryivbepzlKZdXhtd1Q94Dx3YVextRqZ9bcMN/VbKh35
	s1l+bTLx6VUYlCoym2zJVUZ/tRhmRcG3Zi3X2AFIR80kZeS0yeDVfKc2eJfnooAp1eoxbPmR+Dz
	AZOdvtyGO+SUFhtKLxMMMMSfk5Jd2/JKXpL/QFhjE/zz/KoJku3Dz/s1Anc0qYqM8imLsWRkXUC
	oTYZHPJ9KmrWZkJq9PAXZnbBLfOyTLa0X4jpsbnMFYhjxPFNYdNJ2IC9tKXuTNsa1znAYPr8qXv
	Vr60WSc9zcLOhE5lwZQMMPduhnquZ5KtoflXNsxnxgAk2LxvuxwOpzv0rPXKdcA==
X-Received: by 2002:a05:620a:2a08:b0:92b:6805:eaed with SMTP id af79cd13be357-92e785233cfmr72403985a.74.1782892297511;
        Wed, 01 Jul 2026 00:51:37 -0700 (PDT)
X-Received: by 2002:a05:620a:2a08:b0:92b:6805:eaed with SMTP id af79cd13be357-92e785233cfmr72401385a.74.1782892297051;
        Wed, 01 Jul 2026 00:51:37 -0700 (PDT)
Received: from [192.168.69.212] (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c1288d6a3e8sm228444966b.19.2026.07.01.00.51.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Jul 2026 00:51:36 -0700 (PDT)
Message-ID: <7b5b211d-bbf1-42ea-9b1d-f8dfe744841c@oss.qualcomm.com>
Date: Wed, 1 Jul 2026 09:51:33 +0200
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 9/9] vdso/gettimeofday: Verify COMPAT_32BIT_TIME
 interactions
Content-Language: en-US
To: =?UTF-8?Q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
        Andy Lutomirski <luto@kernel.org>, Thomas Gleixner <tglx@kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, Russell King <linux@armlinux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Madhavan Srinivasan <maddy@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Nicholas Piggin <npiggin@gmail.com>,
        "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>,
        John Stultz <jstultz@google.com>, Stephen Boyd <sboyd@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Andreas Larsson <andreas@gaisler.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linuxppc-dev@lists.ozlabs.org, linux-mips@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, linux-api@vger.kernel.org,
        sparclinux@vger.kernel.org
References: <20260630-vdso-compat_32bit_time-v2-0-520d194640dd@linutronix.de>
 <20260630-vdso-compat_32bit_time-v2-9-520d194640dd@linutronix.de>
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@oss.qualcomm.com>
In-Reply-To: <20260630-vdso-compat_32bit_time-v2-9-520d194640dd@linutronix.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: Qx8h14DSem8VA4O9BX0GY0x_thIzgQAA
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzAxMDA3NyBTYWx0ZWRfX9Xe88rOZYlud
 /a5STX6GxA8L9hwqc0Z9Z5xznEMvBBQaY2BTt00SJL+SvwBhj2IAJHgNAqiDvm9y8sKqWgCoGzD
 iKCdeJTduS2ZYRbEplGy1scMZb0uV/I=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzAxMDA3NyBTYWx0ZWRfX9YO3GqQzmqXO
 T6cNGZUnBTE321Haz046VNMgPoz82oqHXB4CY2P5Xg8I7aRnMEDGZ5XZcx9asz73+J43wGlYYb0
 iIos99SSDLiTijAie4o8F4rteYxyz5mavz+o/vgurZf6eYSlhvQHZPBJZqJXr0vZbpyqoNTbxZR
 tktPvcrqya9Y4eZGmeZhvSwJll7t+Vf1Lr2wdxj6GPxcWUkMViT4NVyBUpMXrbBd+BB/0a0qONu
 1x7F59lO6yLIyugzd6DveqRqTfJ+HGgFmDCnwusa18nFa+2p4/+lT/ax9kn41szoYzNo+rUULII
 K/H6YAEyJ5daoYEDxROWonk5JTqqlhQJdwB/A13J7WEDRcJcSsM0BPqURYa45tpERiTAx62aGFP
 Ge/XI3GGv5AABrmimK2XBYZPtsGkLyEKaJ7Vj4gtiKU6wQjiIIrOi+35vL8LZvZ2IBDW5oFNjeO
 ZDCtdLq/fht+AAetDpw==
X-Authority-Analysis: v=2.4 cv=T5+8ifKQ c=1 sm=1 tr=0 ts=6a44c70a cx=c_pps
 a=mPf7EqFMSY9/WdsSgAYMbA==:117 a=4s3hRJSeHn4rkQlkrse1kQ==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=M51BFTxLslgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=gowsoOTTUOVcmtlkKump:22
 a=EUspDBNiAAAA:8 a=gC1PrsFcNpCBvASTUOwA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=dawVfQjAaf238kedN5IG:22
X-Proofpoint-ORIG-GUID: Qx8h14DSem8VA4O9BX0GY0x_thIzgQAA
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-07-01_01,2026-06-26_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 spamscore=0 adultscore=0 lowpriorityscore=0 phishscore=0
 bulkscore=0 clxscore=1015 priorityscore=1501 malwarescore=0 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607010077

On 30/6/26 09:38, Thomas WeiÃschuh wrote:
> If CONFIG_COMPAT_32BIT_TIME is disabled then the vDSO should not
> provide any 32-bit time related functionality.
> 
> Add some build-time validations to make sure the architecture-specific
> glue satisfies this requirement.
> 
> Signed-off-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
> ---
>   lib/vdso/gettimeofday.c | 10 ++++++++++
>   1 file changed, 10 insertions(+)

Reviewed-by: Philippe Mathieu-Daudé <philmd@oss.qualcomm.com>
