Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.180.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795221861;
	b=a6D2wP9eKKybsk07RJCc2yqbWdzvMcoZFfOAAs0+HnZJW5c99wX5QZ6I5Pjbba/5qMya
	 iqMKs4TdH/7MzErW65CljHhTLo6UcntnfgGRvO6Du5uY7ZU0NnqyGqiLQKFUqofRjYCvO
	 McaOJphLY2cFpeYKKN9ek69d4zcppiC04tf0cLiIHafQbJjBw36INsySIL8kyWBBHBaPP
	 E0k8GFVP7oLg4x7qDOqdwKtsHCvdfGlcW+SyB6VDri/UVNz4hn85wNuKPcofWcRo2u1o2
	 FuIUTa9j9VgjqHdych9GbYqozt9kCHS+fYd/wVLYcQ2Iun4V0bkn3OIgqHJ7nEXJSKw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795221861;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:Cc:References:
	 Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:X-Proofpoint-ORIG-GUID:X-Proofpoint-GUID:
	 X-Authority-Analysis:X-Proofpoint-Spam-Info:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=6bbaPssp2aMlgmcypJoOLAro7xCV2VNSDqC5DV2L0pA=;
	b=BiItKWSlQq3Wj5Cvf9AaAKjmOHOoBoHNaLcJ3ElcvRargiWqpU6wSaPTSrSznBU5uV6W
	 MzaeBHhiITTKkQb3/TVa+PVLa7xpZ40TZwqg46ygBWQpPR21/65HNemhlxwQbKJ3Q8pRB
	 9Zs/n32AYD80xG/zMzhJYHncCkShFIEv/RCoJVkOdf4AnYTzTwWA6rcWXqxpDCrykWumG
	 a3rRE9p3G0mD+Cv3sUl8l72vG4OYDKXHinp1RB478PsCrR3mEKZ/KDw0Le2I/QHkLw1wM
	 b3X/NGC+cLvTBY2Zh98yeA5UQQ94sWzqWwywHME5NxAhgz8LReO+432LK5AG7FURkIw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=QEXaY4Tg;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=FAG4r1X7;
	arc=none smtp.remote-ip=205.220.180.131
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B0AF606A6A7
	for <linux-api@vger.kernel.org>; Sat, 21 Nov 2026 00:44:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2B0AF606A6A7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=QEXaY4Tg;
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=FAG4r1X7
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AL0CitS663699
	for <linux-api@vger.kernel.org>; Sat, 21 Nov 2026 00:44:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	6bbaPssp2aMlgmcypJoOLAro7xCV2VNSDqC5DV2L0pA=; b=QEXaY4TgrqclYeUG
	E4U3L6SY4ofnwsAYJHj/1j44DLSySxjEkq8E10NchzmXvmkdTzi3itIkDLr9BFmg
	DdhPUBwDW3fqkTp+JHB77K7X8PSurKwy9/KdcyQEmcHErDcJYdS40+X0rSSf7ukO
	8WA0y8jtPdTKauky4CIpkQcSqhWTKVE4Bje6FpGzf1qwPipQTPGFdpRmRRI1wIw0
	mS2idhhFwBKArx4g1YVrlssKLd6pl7iSBNoXie+LR6VuNCfrw6+r0HG8VhDm2+yb
	a2k9ieYhV5hLLWXX6uMGmxvdME/vpecVUhBhx2gtJd1X81nM+Nww2fuemP1o330U
	WsIspg==
Received: from mail-dy1-f200.google.com (mail-dy1-f200.google.com [74.125.82.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4j2sjwhs5k-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-api@vger.kernel.org>; Sat, 21 Nov 2026 00:44:17 +0000 (GMT)
Received: by mail-dy1-f200.google.com with SMTP id 5a478bee46e88-33c35f5ca6cso1905279eec.1
        for <linux-api@vger.kernel.org>; Fri, 20 Nov 2026 16:44:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1795221857; x=1795826657; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=6bbaPssp2aMlgmcypJoOLAro7xCV2VNSDqC5DV2L0pA=;
        b=FAG4r1X7F0omf7xzLm/6V2U9a8CJ9xxuHYXocvdbCKF/KvCaeyZxmOBfFro2jhmns8
         BYrjXcTRjipVpXgAbsAroJEr5FFAHqoz0EAoUR8lV9wCoNXsuB5pSNvH+FpPV7RnX9eA
         V3bH3Uet3kymFWSs5CHdmdEZ09bDiYLyW1BAeQG8qFs8SMG6u5ZDxcUGxkmhMUBFWKA+
         JkOTgRqDuvILyWPXgMv5R9MhtzqHQBgDOiTy63guaKGkQ4zRV895HV2rrHa3QBcoYufX
         kwoq3O7/U7S3P5q0D0QZfDctLNWcx0iDNOZAYhJLBIFAIDFjX/Fl6951vsNcLgJL8Yod
         2Bcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795221857; x=1795826657;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=6bbaPssp2aMlgmcypJoOLAro7xCV2VNSDqC5DV2L0pA=;
        b=OWs9VI1gqcsgYLrJwxU6uTJyi+izNGSaOGgaBSP+zbwM+0Va0fhxgSPHRiGNk81c19
         nQkYJZNtOvtD+sbYZ9nUW915WD7rdFK/1ccCUXcBAi8Cd75jzD7R3CLz+QKC8CzIhfdZ
         MEsl1af9z2owcgbHHmKpaTxdo4OSw+Bxc4ExLYSd3u6UkQGfGsSRle8MC4D/9rMHfD+x
         lRRtCPbgj19weGdMfMcm225YBTGEF+qyakhnYCz5lImKH0RB0l9+F1SgTPHlcHolHRKF
         VfOC+E/d33wke1Ju0d8dnY4mIGElJMU+oHgU/4xIF3RyeM2Tdar3+4SbLBzVfPMTIvcR
         dYBQ==
X-Forwarded-Encrypted: i=1; AL+hErEVVkOgLiBXw0ukLoBEngyod7A8PSRcEQz26+LsPDc267tBmq7WEFNczfzSxbytokUOWZhvAF622og=@vger.kernel.org
X-Gm-Message-State: APuU4Z+XitQTguV5Bb+Ae9SUWOXufCt0/L7dyWq4Oz+M+K8EvkHUbWtq
	G5XPmTiviFVyF5ip7XjUIMN1HY2gfKpiYsoj4+52xtc3LxbaiqvPgNNFd6Qgj3CUVDJncYF/U2i
	n6tnb2olr6zDwUnsLcUXiCco36fnBxW3IlM8HhPvaTMMrFtcF9EIo1afdV/AKyQg=
X-Gm-Gg: AZFdTZfm5FEj60fyu2ffaQ0aqFD1Ou0sMpKKqGfK1/34FNAogzS35xsItLznGZQPL5+
	HP8iB5rPZYyjMsNxQAtjufqDypL88OvK5a8C6bc+002vlS+nGBheqOEsUaUErTgfSNtDCf+q5CV
	66KExaR37Md/EZsAbZtoreE/uaZ1KijDJR5+8ooS5ZKooc1WXYYyRtCRhGLpLGmxtLhpiJcqCyX
	Fn9M+ShrMeJFZMTGU2gXp6VnEvmBqyKtvUJwZlEHekoeFJ0fzT10bGoGwBGlJlv94yS0bL0bFfK
	Cp0haFu3XmUEXvQP4Wl30re/NSaYLtm0irhPwjJ0JupDr/s94o/N/T20V73k3d1EPvZFDVgx+Z5
	g8umDkf7hGuzgmZ60WGkBaa8kdWVREmRtiUHA+4fdizT7Gpd0Elgm/nhtQcI8d+H1iilNAFDJXC
	2UVUpYEB+yy8lusBzvDmq85U2qG/j2eFpCqaD+tiSswaCttYCii3YIOZHJ7A==
X-Received: by 2002:a05:693c:6010:b0:385:2057:eb95 with SMTP id 5a478bee46e88-3857073f2a3mr5777412eec.31.1795221856781;
        Fri, 20 Nov 2026 16:44:16 -0800 (PST)
X-Received: by 2002:a05:693c:6010:b0:385:2057:eb95 with SMTP id 5a478bee46e88-3857073f2a3mr5777357eec.31.1795221856211;
        Fri, 20 Nov 2026 16:44:16 -0800 (PST)
Received: from [192.168.1.72] (108-202-119-98.lightspeed.frokca.sbcglobal.net. [108.202.119.98])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-38567daaf70sm12974717eec.28.2026.11.20.16.44.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 Nov 2026 16:44:15 -0800 (PST)
Message-ID: <13d32bf7-7f74-4dc5-a875-671167149df9@oss.qualcomm.com>
Date: Fri, 20 Nov 2026 16:44:15 -0800
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
Subject: Re: [PATCH RFC 0/4] firmware: arm: Add Platform Fault Detection
 Interface support
To: Ahmed Azeem <ahmed.azeem@arm.com>, linux-arm-kernel@lists.infradead.org,
        Sudeep Holla <sudeep.holla@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Lorenzo Pieralisi <lpieralisi@kernel.org>, linux-api@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Divin Raj <divin.raj@arm.com>,
        Bertrand Marquis <Bertrand.Marquis@arm.com>,
        Ashok Raj <ashok.raj@oss.qualcomm.com>, punita@qti.qualcomm.com,
        jonathan.cameron@oss.qualcomm.com
References: <20261119-topics-ahmaze01-upstream-pfdi-rfc-v1-0-4772d18b9115@arm.com>
Content-Language: en-US
From: Jithu Joseph <jithu.joseph@oss.qualcomm.com>
In-Reply-To: <20261119-topics-ahmaze01-upstream-pfdi-rfc-v1-0-4772d18b9115@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-ORIG-GUID: XKlwHntVrek8ipb2cr7qg5MnZDxRGGd6
X-Proofpoint-GUID: XKlwHntVrek8ipb2cr7qg5MnZDxRGGd6
X-Authority-Analysis: v=2.4 cv=dZ4VTnXe c=1 sm=1 tr=0 ts=6b00e961 cx=c_pps
 a=PfFC4Oe2JQzmKTvty2cRDw==:117 a=HIR1veyihGOKDQ4ymPDRgQ==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=3WHJM1ZQz_JShphwDgj5:22
 a=9AdMxfjQAAAA:20 a=VwQbUJbxAAAA:8 a=oK97o0Sx6ny3NbBOOE0A:9 a=QEXdDO2ut3YA:10
 a=6Ab_bkdmUrQuMsNx7PHu:22 a=bA3UWDv6hWIuX7UZL3qL:22
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTIxMDAwMSBTYWx0ZWRfX1EPfDwjilqzT
 RVqDG3GT8ns/6Z9KCUf1fZuRK5ElLagnw8p35iPY8A7FtDtziJdDISjCr0Gr81INxUS+3e/ZCxz
 FfjiDY2XMOUhWSgnl/AGySZujiBztzc=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTIxMDAwMSBTYWx0ZWRfXzJiXFheUIjyO
 uJfF4pgU0aCLDqGn9fYgFd+mm1xNlbFmLGLUvgwozaZe3tMfMc2e5dySaBN4fV5E2YWEtAaQ8Na
 jcMZ3871VdzpW+5kauLG0wMtB0xTVPQExFtQGOm6xyHetzhiDUr7PpDdG74gMvBtEUR7xsaPvSW
 N0CIpeDCsU3Ienv9qvP/t5GpmADbbCpxP2dKsD0bmqCXlLJOP9SXXm8OI68UtYW3lTNt/MCP+rK
 7u1pg19u/JMSaWxez2/npqh77bk7INC3vHn7NCW9Ui5Mgat4a3TmCa0jsXzarXX1QiVvPpG6UHn
 OWoINSe+nuuHxyHnkdxYh9/3ojJrWME6TzrlkUj833yWOyqXps6lzbHSTinU2bdHuBKW6yVCJUp
 F+0OydkfXSgzWUeYabPDSkCl2tPvDfBsW49W7Dy/Lrbk+VY9kYa113qq2PcHaaCpZ7s5HEOk7Vq
 Vttk+6i9D+m/GtP2YhQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-20_06,2026-11-19_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 malwarescore=0 bulkscore=0 lowpriorityscore=0 adultscore=0
 priorityscore=1501 phishscore=0 spamscore=0 clxscore=1011 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611210001

On 11/19/2026 7:36 AM, Ahmed Azeem wrote:
> Hi all,
> 
> This series proposes an arm64 driver for the Arm Platform Fault
> Detection
> Interface (PFDI), providing a common Linux interface for privileged
> userspace to discover and invoke firmware diagnostics.
> 
> We are posting this series as an RFC to seek community feedback on both
> the proposed Linux interface and the underlying firmware specification
> before the specification is finalized. This series and its validation
> use
> the PFDI 1.0 ALP0 specification [1]. The current public revision is PFDI
> 1.0 BET0 [2]. Feedback on the software integration will help identify
> any
> changes needed to align an upstream implementation with the evolving
> specification.
>
 
...

> 
> I would appreciate feedback on the specification's suitability for Linux
> integration, the proposed per-CPU ioctl ABI, the worker and hotplug
> model,
> and whether this belongs under drivers/firmware. In particular, is this
> the right scope for a common PFDI interface, and should error injection
> be exposed separately from normal diagnostic operations?
> 

Thanks for the RFC

I haven't read through the specs or code in great detail, but I thought I would send in my initial thoughts

Most of it comes from my experience developing/up-streaming a similar feature in my prior job at Intel called In Field Scan [1] / [2]. 

I think creating per-cpu threads just for this feature might be an overkill on a system with large core-counts. I think an alternate approach like below might work for this 

1. Drop the per-CPU kthreads and the cpuhp state; run each request on the target CPU when it arrives ... something like
cpus_read_lock();
if (!cpu_online(cpu) 
        ret = -ENODEV;
else
        ret = work_on_cpu(cpu, pfdi_op_fn, &req);   /* or smp_call_on_cpu() */
 cpus_read_unlock();

(IFS used an alternate cpu stopper mechanism as it had the additional responsibility of synchronizing sibling threads and related timing etc ... it might not be needed here )

2. Use one device with the CPU passed in the request, not <numcpu> device nodes. Use a single /dev/pfdi (or /dev/cpu_pfdi) and add a cpu field to each ioctl argument struct. That removes:
- the per-CPU miscdevice and pfdi_dev_data
- the per-CPU register/deregister on hotplug etc

(I will be away next week ...so my responses will be delayed)

[1] https://github.com/torvalds/linux/blob/master/drivers/platform/x86/intel/ifs/ifs.h
[2] https://www.kernel.org/doc/html/latest/arch/x86/ifs.html


Thanks
Jithu
